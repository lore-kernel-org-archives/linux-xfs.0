Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9462CC00144
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Aug 2022 03:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbiHBDUO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Aug 2022 23:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbiHBDUN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Aug 2022 23:20:13 -0400
Received: from m15112.mail.126.com (m15112.mail.126.com [220.181.15.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 817A5FB
        for <linux-xfs@vger.kernel.org>; Mon,  1 Aug 2022 20:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=3cSBf
        AZ1DMaDBscBrhr3f8ybsLy7cL8GEFx5FJxY2MQ=; b=k9MVs/B6SxifHF5nk9vFb
        bXG0BopTvCnVJ9CMbRiQJf2gM7k4aUNA1uB1cO8nInh8YZEUlugl4Ai52tRLkLw7
        HpA6syIsH1az9D7fANZLOKg3SSCGa+J/ALD1AGccNilwL9fHvlH+9H+qgIlJbmJS
        I23+UGfs+I7BuOsAHS9H8k=
Received: from DESKTOP-G0RBR07.localdomain (unknown [117.61.20.198])
        by smtp2 (Coremail) with SMTP id DMmowADXPfp2l+hiF4u2GQ--.20324S2;
        Tue, 02 Aug 2022 11:18:15 +0800 (CST)
From:   Xiaole He <hexiaole1994@126.com>
To:     linux-xfs@vger.kernel.org
Cc:     hexiaole <hexiaole@kylinos.cn>
Subject: [PATCH v1] libxfs: fix inode reservation space for removing transaction
Date:   Tue,  2 Aug 2022 11:18:06 +0800
Message-Id: <20220802031806.236-1-hexiaole1994@126.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMmowADXPfp2l+hiF4u2GQ--.20324S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ar4DZr43Cr4rWF4rXrW3Awb_yoW8Wr1UpF
        n7GF47Crn8Gr1Fkrs3trs0qryayayrKr4a9r48tFn3Zw1DJr12yry8Kw15tFyrWr4avryj
        vryDAw1UZa12va7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jnpnQUUUUU=
X-Originating-IP: [117.61.20.198]
X-CM-SenderInfo: 5kh0xt5rohimizu6ij2wof0z/1tbicxhRBlpEBniEfgAAsm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: hexiaole <hexiaole@kylinos.cn>

In 'libxfs/xfs_trans_resv.c', the comment for transaction of removing a
directory entry writes:

/* libxfs/xfs_trans_resv.c begin */
/*
 * For removing a directory entry we can modify:
 *    the parent directory inode: inode size
 *    the removed inode: inode size
...
/* libxfs/xfs_trans_resv.c end */

There has 2 inode size of space to be reserverd, but the actual code
for inode reservation space writes:

/* libxfs/xfs_trans_resv.c begin */
/*
 * For removing a directory entry we can modify:
 *    the parent directory inode: inode size
 *    the removed inode: inode size
...
xfs_calc_remove_reservation(
        struct xfs_mount        *mp)
{
        return XFS_DQUOT_LOGRES(mp) +
                xfs_calc_iunlink_add_reservation(mp) +
                max((xfs_calc_inode_res(mp, 1) +
...
/* libxfs/xfs_trans_resv.c end */

There only count for 1 inode size to be reserved in
'xfs_calc_inode_res(mp, 1)', rather than 2.

Signed-off-by: hexiaole <hexiaole@kylinos.cn>
---
 libxfs/xfs_trans_resv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index d4a9f69e..797176d7 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -514,7 +514,7 @@ xfs_calc_remove_reservation(
 {
 	return XFS_DQUOT_LOGRES(mp) +
 		xfs_calc_iunlink_add_reservation(mp) +
-		max((xfs_calc_inode_res(mp, 1) +
+		max((xfs_calc_inode_res(mp, 2) +
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
-- 
2.27.0


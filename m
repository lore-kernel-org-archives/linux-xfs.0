Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 143CCC25B06
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Aug 2022 02:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbiHOCzW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Aug 2022 22:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiHOCzV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Aug 2022 22:55:21 -0400
Received: from m15111.mail.126.com (m15111.mail.126.com [220.181.15.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B87AEDC8
        for <linux-xfs@vger.kernel.org>; Sun, 14 Aug 2022 19:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=QZVW5
        aWZ+2PASecqhmZ/TwdS7cieGr9sHQQVtFbAvNc=; b=SsLN2noDLW8/7NBiSvW/t
        qHH4J+AXZykuRb2SIMltj7TBIGVKr4wK1e4frBtPi4OblfJ97sPhcWsB7Qdlw5AP
        qdnut52bUBUhmiVyGUmT2oEYXVHWsPUNuzs1xaXRZPc/lzMNMmTpcNtkcd0Iz4ah
        0gEo5gkcUcDkeE81PugVUg=
Received: from DESKTOP-G0RBR07.localdomain (unknown [123.150.8.42])
        by smtp1 (Coremail) with SMTP id C8mowABHZRqEtflimkd+AA--.18004S2;
        Mon, 15 Aug 2022 10:55:01 +0800 (CST)
From:   Xiaole He <hexiaole1994@126.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, hexiaole <hexiaole@kylinos.cn>
Subject: [PATCH v2] libxfs: fix inode reservation space for removing transaction
Date:   Mon, 15 Aug 2022 10:54:58 +0800
Message-Id: <20220815025458.137-1-hexiaole1994@126.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8mowABHZRqEtflimkd+AA--.18004S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7trW7Zw4rAF45JFy3Gr4fGrg_yoW8GFW5pF
        n7GF4fCrn5GrySkrs7trnIqrya9ayFkr429r4ktrn3Zw1DJr17try8Kw15tFyrWr4YvF4j
        vryDAw15uw42va7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jn18kUUUUU=
X-Originating-IP: [123.150.8.42]
X-CM-SenderInfo: 5kh0xt5rohimizu6ij2wof0z/1tbihAZeBlx5iyYk-gAAsI
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: hexiaole <hexiaole@kylinos.cn>

In 'libxfs/xfs_trans_resv.c', the comment for transaction of removing a
directory entry mentions that there has 2 inode size of space to be
reserverd, but the actual code only count for 1 inode size:

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

Here only count for 1 inode size to be reserved in
'xfs_calc_inode_res(mp, 1)', rather than 2.

Signed-off-by: hexiaole <hexiaole@kylinos.cn>
---
V1 -> V2: djwong: remove redundant code citations

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


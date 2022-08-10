Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A954C00140
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 06:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbiHJGdR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Aug 2022 02:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbiHJGdP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Aug 2022 02:33:15 -0400
Received: from m15112.mail.126.com (m15112.mail.126.com [220.181.15.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ECA886E2CF
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 23:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=I5Aao
        zCKLig84rdrkkvidj71TQnDyCzILc+VuRJAY+o=; b=gby5mpIpq4U7kDoeop6Qt
        RtG8KZ1F1kdALkgAA6VF5OO+m379MVFnVcq3aQwbMR8MkkHkvx6tvJWTkAmmLhjp
        Da6feKC813124cSm4kSd8az7Uv1vdL3ZRc20cLWAKt5sbUZCArP9U+C+VFeR1f3T
        cmt6AsjL9hZT22kqHpe4BE=
Received: from localhost.localdomain (unknown [123.150.8.42])
        by smtp2 (Coremail) with SMTP id DMmowABXW_2AUPNiATmqHA--.55526S2;
        Wed, 10 Aug 2022 14:30:26 +0800 (CST)
From:   Xiaole He <hexiaole1994@126.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, dchinner@redhat.com, chandan.babu@oracle.com,
        hexiaole <hexiaole@kylinos.cn>
Subject: [PATCH v1] libxfs: fix inode reservation space for removing transaction
Date:   Wed, 10 Aug 2022 14:29:40 +0800
Message-Id: <20220810062940.10133-1-hexiaole1994@126.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMmowABXW_2AUPNiATmqHA--.55526S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ar4DZr43Cr4rWF4rXrW3Awb_yoW8WF1rpF
        n7Ga1akrn8Gr1Fkrs3trn0q34ayayFkr429r4kJFnavw1DJr12yry8Kw15KFyrWr4avryj
        9ryDAw1UXa12va7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jlD7sUUUUU=
X-Originating-IP: [123.150.8.42]
X-CM-SenderInfo: 5kh0xt5rohimizu6ij2wof0z/1tbimx1ZBlx5hoY4ZgABsj
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
 fs/xfs/libxfs/xfs_trans_resv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index e9913c2c5a24..2c4ad6e4bb14 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -515,7 +515,7 @@ xfs_calc_remove_reservation(
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


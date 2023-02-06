Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7921C636CD
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Feb 2023 06:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjBGGQZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Feb 2023 01:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBGGQY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Feb 2023 01:16:24 -0500
X-Greylist: delayed 1814 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 06 Feb 2023 22:16:19 PST
Received: from m126.mail.126.com (m126.mail.126.com [220.181.12.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BDCF303F6
        for <linux-xfs@vger.kernel.org>; Mon,  6 Feb 2023 22:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=BZ+Jr
        9tv+HR7qNDEghVYNw3vpcV5TunO3qpwai82R48=; b=YNnHtZrgo8WrfrGKCpmyr
        SPl3MCU413CYlIACAcm4gKRxEYxzIwypcJrf5pL5PwaPFinRtDw6MyI17uq9r/bz
        kv50TMbwiv18TnwlMlv7/RKQiIiFXFtwD8HzCkv/4dUPR7gi91/bkzcb5ULfznNv
        fgS/YTB2799xZpkIxpUVtY=
Received: from localhost.localdomain (unknown [116.128.244.169])
        by zwqz-smtp-mta-g4-1 (Coremail) with SMTP id _____wDHz7Fx5eFjaNW4Ag--.36973S2;
        Tue, 07 Feb 2023 13:45:32 +0800 (CST)
From:   Xiaole He <hexiaole1994@126.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, dchinner@redhat.com, chandan.babu@oracle.com,
        zhangshida@kylinos.cn, Xiaole He <hexiaole1994@126.com>,
        Xiaole He <hexiaole@kylinos.cn>
Subject: [PATCH v1] libxfs: fix reservation space for removing transaction
Date:   Mon,  6 Feb 2023 21:09:49 +0800
Message-Id: <20230206130949.12947-1-hexiaole1994@126.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wDHz7Fx5eFjaNW4Ag--.36973S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tw4xJryUur15Ar4ktFyrJFb_yoW8ZrW3pr
        n7Cr4Skrn8JryFyFn7Jr1qqryYya9Ykw429r48Zrn3Zw1DJFnFyry09w1Y9Fyjqr4fZr1U
        ZryUCw17Za1IvaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zExR6-UUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5kh0xt5rohimizu6ij2wof0z/1tbikAMPBlpEC5WxkwAAs4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In libxfs/xfs_trans_resv.c:

/* libxfs/xfs_trans_resv.c begin */
 1 /*
 2  * For removing a directory entry we can modify:
 3  *    the parent directory inode: inode size
 4  *    the removed inode: inode size
 5  *    the directory btree could join: (max depth + v2) * dir block size
 6  *    the directory bmap btree could join or split: (max depth + v2) * blocksize
 7  * And the bmap_finish transaction can free the dir and bmap blocks giving:
 8  *    the agf for the ag in which the blocks live: 2 * sector size
 9  *    the agfl for the ag in which the blocks live: 2 * sector size
10  *    the superblock for the free block count: sector size
11  ...
12  */
13 STATIC uint
14 xfs_calc_remove_reservation(
15      struct xfs_mount        *mp)
16 {
17      return XFS_DQUOT_LOGRES(mp) +
18              xfs_calc_iunlink_add_reservation(mp) +
19              max((xfs_calc_inode_res(mp, 1) +
20                   xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
21                                    XFS_FSB_TO_B(mp, 1))),
22                  (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
23      ...
24 }
/* libxfs/xfs_trans_resv.c end */

Above lines 8-10 indicates there has 5 sector size of space to be
reserved, but the above line 22 only reserve 4 sector size of space,
this patch fix the problem and sorry for not notice this problem at
Commit d3e53ab7cdc7fabb8c94137e335634e0ed4691e8 ("xfs: fix inode
reservation space for removing transaction").

Signed-off-by: Xiaole He <hexiaole@kylinos.cn>
---
 libxfs/xfs_trans_resv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 04c44480..3d106c77 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -517,7 +517,7 @@ xfs_calc_remove_reservation(
 		max((xfs_calc_inode_res(mp, 2) +
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
+		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
 		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
 				      XFS_FSB_TO_B(mp, 1))));
 }
-- 
2.27.0


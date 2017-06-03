Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32822 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdFCEWK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 00:22:10 -0400
Received: by mail-pf0-f194.google.com with SMTP id f27so14605578pfe.0
        for <linux-xfs@vger.kernel.org>; Fri, 02 Jun 2017 21:22:10 -0700 (PDT)
From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] xfs: avoid -Wint-in-bool-context warning in xfs_bmap_util.c
Date: Fri,  2 Jun 2017 21:21:07 -0700
Message-Id: <20170603042107.17469-1-ebiggers3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

XFS triggers gcc 7's -Wint-in-bool-context warning (on by default with
-Wall), which warns about arithmetic in a boolean context that has no
effect on the result:

    In file included from fs/xfs/xfs_inode.h:22:0,
                     from fs/xfs/xfs_bmap_util.c:29:
    fs/xfs/xfs_bmap_util.c: In function ‘xfs_swap_extents_check_format’:
    fs/xfs/libxfs/xfs_inode_fork.h:90:30: warning: ‘<<’ in boolean context, did you mean ‘<’ ? [-Wint-in-bool-context]
     #define XFS_IFORK_BOFF(ip)  ((int)((ip)->i_d.di_forkoff << 3))
                                 ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    fs/xfs/xfs_bmap_util.c:1620:7: note: in expansion of macro ‘XFS_IFORK_BOFF’
       if (XFS_IFORK_BOFF(ip) &&
           ^~~~~~~~~~~~~~
    fs/xfs/libxfs/xfs_inode_fork.h:90:30: warning: ‘<<’ in boolean context, did you mean ‘<’ ? [-Wint-in-bool-context]
     #define XFS_IFORK_BOFF(ip)  ((int)((ip)->i_d.di_forkoff << 3))
                                 ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    fs/xfs/xfs_bmap_util.c:1630:7: note: in expansion of macro ‘XFS_IFORK_BOFF’
       if (XFS_IFORK_BOFF(tip) &&
           ^~~~~~~~~~~~~~

This is more or less a false positive, because the useless arithmetic is
just the left shift in XFS_IFORK_BOFF().  Use XFS_IFORK_Q() instead to
make the warnings go away, while having the same behavior and being more
consistent with other places in XFS which also use XFS_IFORK_Q().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/xfs/xfs_bmap_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 7ac80a1facf2..05a6fdf5976d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1613,7 +1613,7 @@ xfs_swap_extents_check_format(
 	 * extent format...
 	 */
 	if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
-		if (XFS_IFORK_BOFF(ip) &&
+		if (XFS_IFORK_Q(ip) &&
 		    XFS_BMAP_BMDR_SPACE(tip->i_df.if_broot) > XFS_IFORK_BOFF(ip))
 			return -EINVAL;
 		if (XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) <=
@@ -1623,7 +1623,7 @@ xfs_swap_extents_check_format(
 
 	/* Reciprocal target->temp btree format checks */
 	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
-		if (XFS_IFORK_BOFF(tip) &&
+		if (XFS_IFORK_Q(tip) &&
 		    XFS_BMAP_BMDR_SPACE(ip->i_df.if_broot) > XFS_IFORK_BOFF(tip))
 			return -EINVAL;
 		if (XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) <=
-- 
2.13.0


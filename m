Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46258 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752078AbdIQVHV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:21 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/47] xfs: Fix per-inode DAX flag inheritance
Date: Sun, 17 Sep 2017 14:06:41 -0700
Message-Id: <20170917210712.10804-17-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Lukas Czerner <lczerner@redhat.com>

commit 56bdf855e676f1f2ed7033f288f57dfd315725ba upstream.

According to the commit that implemented per-inode DAX flag:
commit 58f88ca2df72 ("xfs: introduce per-inode DAX enablement")
the flag is supposed to act as "inherit flag".

Currently this only works in the situations where parent directory
already has a flag in di_flags set, otherwise inheritance does not
work. This is because setting the XFS_DIFLAG2_DAX flag is done in a
wrong branch designated for di_flags, not di_flags2.

Fix this by moving the code to branch designated for setting di_flags2,
which does test for flags in di_flags2.

Fixes: 58f88ca2df72 ("xfs: introduce per-inode DAX enablement")
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7a0b4eeb99e4..98cd905eadca 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -881,7 +881,6 @@ xfs_ialloc(
 	case S_IFREG:
 	case S_IFDIR:
 		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
-			uint64_t	di_flags2 = 0;
 			uint		di_flags = 0;
 
 			if (S_ISDIR(mode)) {
@@ -918,20 +917,23 @@ xfs_ialloc(
 				di_flags |= XFS_DIFLAG_NODEFRAG;
 			if (pip->i_d.di_flags & XFS_DIFLAG_FILESTREAM)
 				di_flags |= XFS_DIFLAG_FILESTREAM;
-			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
-				di_flags2 |= XFS_DIFLAG2_DAX;
 
 			ip->i_d.di_flags |= di_flags;
-			ip->i_d.di_flags2 |= di_flags2;
 		}
 		if (pip &&
 		    (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY) &&
 		    pip->i_d.di_version == 3 &&
 		    ip->i_d.di_version == 3) {
+			uint64_t	di_flags2 = 0;
+
 			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
-				ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+				di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
 				ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
 			}
+			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
+				di_flags2 |= XFS_DIFLAG2_DAX;
+
+			ip->i_d.di_flags2 |= di_flags2;
 		}
 		/* FALLTHROUGH */
 	case S_IFLNK:
-- 
2.14.1


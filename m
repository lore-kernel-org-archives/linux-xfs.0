Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33862 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752249AbcLOOHx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 09:07:53 -0500
From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH 2/9] xfs: introduce and use KM_NOLOCKDEP to silence reclaim lockdep false positives
Date: Thu, 15 Dec 2016 15:07:08 +0100
Message-Id: <20161215140715.12732-3-mhocko@kernel.org>
In-Reply-To: <20161215140715.12732-1-mhocko@kernel.org>
References: <20161215140715.12732-1-mhocko@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>

From: Michal Hocko <mhocko@suse.com>

Now that the page allocator offers __GFP_NOLOCKDEP let's introduce
KM_NOLOCKDEP alias for the xfs allocation APIs. While we are at it
also change KM_NOFS users introduced by b17cb364dbbb ("xfs: fix missing
KM_NOFS tags to keep lockdep happy") and use the new flag for them
instead. There is really no reason to make these allocations contexts
weaker just because of the lockdep which even might not be enabled
in most cases.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 fs/xfs/kmem.h                | 4 ++++
 fs/xfs/libxfs/xfs_da_btree.c | 4 ++--
 fs/xfs/xfs_buf.c             | 2 +-
 fs/xfs/xfs_dir2_readdir.c    | 2 +-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 689f746224e7..ea3984091d58 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -33,6 +33,7 @@ typedef unsigned __bitwise xfs_km_flags_t;
 #define KM_NOFS		((__force xfs_km_flags_t)0x0004u)
 #define KM_MAYFAIL	((__force xfs_km_flags_t)0x0008u)
 #define KM_ZERO		((__force xfs_km_flags_t)0x0010u)
+#define KM_NOLOCKDEP	((__force xfs_km_flags_t)0x0020u)
 
 /*
  * We use a special process flag to avoid recursive callbacks into
@@ -57,6 +58,9 @@ kmem_flags_convert(xfs_km_flags_t flags)
 	if (flags & KM_ZERO)
 		lflags |= __GFP_ZERO;
 
+	if (flags & KM_NOLOCKDEP)
+		lflags |= __GFP_NOLOCKDEP;
+
 	return lflags;
 }
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index f2dc1a950c85..b8b5f6914863 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2429,7 +2429,7 @@ xfs_buf_map_from_irec(
 
 	if (nirecs > 1) {
 		map = kmem_zalloc(nirecs * sizeof(struct xfs_buf_map),
-				  KM_SLEEP | KM_NOFS);
+				  KM_SLEEP | KM_NOLOCKDEP);
 		if (!map)
 			return -ENOMEM;
 		*mapp = map;
@@ -2488,7 +2488,7 @@ xfs_dabuf_map(
 		 */
 		if (nfsb != 1)
 			irecs = kmem_zalloc(sizeof(irec) * nfsb,
-					    KM_SLEEP | KM_NOFS);
+					    KM_SLEEP | KM_NOLOCKDEP);
 
 		nirecs = nfsb;
 		error = xfs_bmapi_read(dp, (xfs_fileoff_t)bno, nfsb, irecs,
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 7f0a01f7b592..f31ae592dcae 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1785,7 +1785,7 @@ xfs_alloc_buftarg(
 {
 	xfs_buftarg_t		*btp;
 
-	btp = kmem_zalloc(sizeof(*btp), KM_SLEEP | KM_NOFS);
+	btp = kmem_zalloc(sizeof(*btp), KM_SLEEP | KM_NOLOCKDEP);
 
 	btp->bt_mount = mp;
 	btp->bt_dev =  bdev->bd_dev;
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 003a99b83bd8..033ed65d7ce6 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -503,7 +503,7 @@ xfs_dir2_leaf_getdents(
 	length = howmany(bufsize + geo->blksize, (1 << geo->fsblog));
 	map_info = kmem_zalloc(offsetof(struct xfs_dir2_leaf_map_info, map) +
 				(length * sizeof(struct xfs_bmbt_irec)),
-			       KM_SLEEP | KM_NOFS);
+			       KM_SLEEP | KM_NOLOCKDEP);
 	map_info->map_size = length;
 
 	/*
-- 
2.10.2


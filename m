Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:34414 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755138AbdAFOLW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jan 2017 09:11:22 -0500
From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH 4/8] xfs: use memalloc_nofs_{save,restore} instead of memalloc_noio*
Date: Fri,  6 Jan 2017 15:11:03 +0100
Message-Id: <20170106141107.23953-5-mhocko@kernel.org>
In-Reply-To: <20170106141107.23953-1-mhocko@kernel.org>
References: <20170106141107.23953-1-mhocko@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, djwong@kernel.org, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>

From: Michal Hocko <mhocko@suse.com>

kmem_zalloc_large and _xfs_buf_map_pages use memalloc_noio_{save,restore}
API to prevent from reclaim recursion into the fs because vmalloc can
invoke unconditional GFP_KERNEL allocations and these functions might be
called from the NOFS contexts. The memalloc_noio_save will enforce
GFP_NOIO context which is even weaker than GFP_NOFS and that seems to be
unnecessary. Let's use memalloc_nofs_{save,restore} instead as it should
provide exactly what we need here - implicit GFP_NOFS context.

Changes since v1
- s@memalloc_noio_restore@memalloc_nofs_restore@ in _xfs_buf_map_pages
  as per Brian Foster

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 fs/xfs/kmem.c    | 10 +++++-----
 fs/xfs/xfs_buf.c |  8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index a76a05dae96b..d69ed5e76621 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -65,7 +65,7 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
 void *
 kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
 {
-	unsigned noio_flag = 0;
+	unsigned nofs_flag = 0;
 	void	*ptr;
 	gfp_t	lflags;
 
@@ -80,14 +80,14 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
 	 * context via PF_MEMALLOC_NOIO to prevent memory reclaim re-entering
 	 * the filesystem here and potentially deadlocking.
 	 */
-	if ((current->flags & PF_MEMALLOC_NOFS) || (flags & KM_NOFS))
-		noio_flag = memalloc_noio_save();
+	if (flags & KM_NOFS)
+		nofs_flag = memalloc_nofs_save();
 
 	lflags = kmem_flags_convert(flags);
 	ptr = __vmalloc(size, lflags | __GFP_HIGHMEM | __GFP_ZERO, PAGE_KERNEL);
 
-	if ((current->flags & PF_MEMALLOC_NOFS) || (flags & KM_NOFS))
-		memalloc_noio_restore(noio_flag);
+	if (flags & KM_NOFS)
+		memalloc_nofs_restore(nofs_flag);
 
 	return ptr;
 }
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 7f0a01f7b592..8cb8dd4cdfd8 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -441,17 +441,17 @@ _xfs_buf_map_pages(
 		bp->b_addr = NULL;
 	} else {
 		int retried = 0;
-		unsigned noio_flag;
+		unsigned nofs_flag;
 
 		/*
 		 * vm_map_ram() will allocate auxillary structures (e.g.
 		 * pagetables) with GFP_KERNEL, yet we are likely to be under
 		 * GFP_NOFS context here. Hence we need to tell memory reclaim
-		 * that we are in such a context via PF_MEMALLOC_NOIO to prevent
+		 * that we are in such a context via PF_MEMALLOC_NOFS to prevent
 		 * memory reclaim re-entering the filesystem here and
 		 * potentially deadlocking.
 		 */
-		noio_flag = memalloc_noio_save();
+		nofs_flag = memalloc_nofs_save();
 		do {
 			bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
 						-1, PAGE_KERNEL);
@@ -459,7 +459,7 @@ _xfs_buf_map_pages(
 				break;
 			vm_unmap_aliases();
 		} while (retried++ <= 1);
-		memalloc_noio_restore(noio_flag);
+		memalloc_nofs_restore(nofs_flag);
 
 		if (!bp->b_addr)
 			return -ENOMEM;
-- 
2.11.0


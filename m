Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8C9237CA0
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:33:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 556A7304053
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 02:33:49 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id NLGd1D76drnJ8Mwv (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Mar 2016 02:33:46 -0700 (PDT)
Date: Thu, 24 Mar 2016 02:33:45 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Failing XFS memory allocation
Message-ID: <20160324093345.GA13569@infradead.org>
References: <56F26CCE.6010502@kyup.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <56F26CCE.6010502@kyup.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Nikolay Borisov <kernel@kyup.com>
Cc: xfs@oss.sgi.com


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Nikolay,

can you give the patch below a spin?  While it doesn't solve the root
cause it makes many typical uses of kmem_realloc behave less badly,
so it should help with at least some of the less dramatic cases of very
fragmented files:


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-xfs-improve-kmem_realloc.patch"

>From 4cfef0d21729704c79dc26621a254e507ea372a7 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 17 Mar 2016 11:15:59 +0100
Subject: xfs: improve kmem_realloc

Use krealloc to implement our realloc function.  This helps to avoid
new allocations if we are still in the slab bucket.  At least for the
bmap btree root that's actually the common case.

This also allows removing the now unused oldsize argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/kmem.c                  | 26 +++++++++++++++-----------
 fs/xfs/kmem.h                  |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 10 +++-------
 fs/xfs/xfs_log_recover.c       |  2 +-
 fs/xfs/xfs_mount.c             |  1 -
 5 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 686ba6f..339c696 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -93,19 +93,23 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
 }
 
 void *
-kmem_realloc(const void *ptr, size_t newsize, size_t oldsize,
-	     xfs_km_flags_t flags)
+kmem_realloc(const void *old, size_t newsize, xfs_km_flags_t flags)
 {
-	void	*new;
+	int	retries = 0;
+	gfp_t	lflags = kmem_flags_convert(flags);
+	void	*ptr;
 
-	new = kmem_alloc(newsize, flags);
-	if (ptr) {
-		if (new)
-			memcpy(new, ptr,
-				((oldsize < newsize) ? oldsize : newsize));
-		kmem_free(ptr);
-	}
-	return new;
+	do {
+		ptr = krealloc(old, newsize, lflags);
+		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
+			return ptr;
+		if (!(++retries % 100))
+			xfs_err(NULL,
+	"%s(%u) possible memory allocation deadlock size %zu in %s (mode:0x%x)",
+				current->comm, current->pid,
+				newsize, __func__, lflags);
+		congestion_wait(BLK_RW_ASYNC, HZ/50);
+	} while (1);
 }
 
 void *
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index d1c66e4..689f746 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -62,7 +62,7 @@ kmem_flags_convert(xfs_km_flags_t flags)
 
 extern void *kmem_alloc(size_t, xfs_km_flags_t);
 extern void *kmem_zalloc_large(size_t size, xfs_km_flags_t);
-extern void *kmem_realloc(const void *, size_t, size_t, xfs_km_flags_t);
+extern void *kmem_realloc(const void *, size_t, xfs_km_flags_t);
 static inline void  kmem_free(const void *ptr)
 {
 	kvfree(ptr);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 4fbe226..d3d1477 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -542,7 +542,6 @@ xfs_iroot_realloc(
 		new_max = cur_max + rec_diff;
 		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
 		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
-				XFS_BMAP_BROOT_SPACE_CALC(mp, cur_max),
 				KM_SLEEP | KM_NOFS);
 		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
 						     ifp->if_broot_bytes);
@@ -686,7 +685,6 @@ xfs_idata_realloc(
 				ifp->if_u1.if_data =
 					kmem_realloc(ifp->if_u1.if_data,
 							real_size,
-							ifp->if_real_bytes,
 							KM_SLEEP | KM_NOFS);
 			}
 		} else {
@@ -1402,8 +1400,7 @@ xfs_iext_realloc_direct(
 		if (rnew_size != ifp->if_real_bytes) {
 			ifp->if_u1.if_extents =
 				kmem_realloc(ifp->if_u1.if_extents,
-						rnew_size,
-						ifp->if_real_bytes, KM_NOFS);
+						rnew_size, KM_NOFS);
 		}
 		if (rnew_size > ifp->if_real_bytes) {
 			memset(&ifp->if_u1.if_extents[ifp->if_bytes /
@@ -1487,9 +1484,8 @@ xfs_iext_realloc_indirect(
 	if (new_size == 0) {
 		xfs_iext_destroy(ifp);
 	} else {
-		ifp->if_u1.if_ext_irec = (xfs_ext_irec_t *)
-			kmem_realloc(ifp->if_u1.if_ext_irec,
-				new_size, size, KM_NOFS);
+		ifp->if_u1.if_ext_irec =
+			kmem_realloc(ifp->if_u1.if_ext_irec, new_size, KM_NOFS);
 	}
 }
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 396565f..bf6e807 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3843,7 +3843,7 @@ xlog_recover_add_to_cont_trans(
 	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
 	old_len = item->ri_buf[item->ri_cnt-1].i_len;
 
-	ptr = kmem_realloc(old_ptr, len+old_len, old_len, KM_SLEEP);
+	ptr = kmem_realloc(old_ptr, len + old_len, KM_SLEEP);
 	memcpy(&ptr[old_len], dp, len);
 	item->ri_buf[item->ri_cnt-1].i_len += len;
 	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 536a0ee..654799f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -89,7 +89,6 @@ xfs_uuid_mount(
 	if (hole < 0) {
 		xfs_uuid_table = kmem_realloc(xfs_uuid_table,
 			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
-			xfs_uuid_table_size  * sizeof(*xfs_uuid_table),
 			KM_SLEEP);
 		hole = xfs_uuid_table_size++;
 	}
-- 
2.1.4


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8t9RHnE3ZwKMSgU+--

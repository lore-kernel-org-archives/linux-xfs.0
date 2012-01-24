Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OLdi2b077937 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 15:39:44 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ynIIgvfxBloNt5qV (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 13:39:38 -0800 (PST)
Date: Tue, 24 Jan 2012 16:39:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS problem
Message-ID: <20120124213936.GA1505@infradead.org>
References: <CAAA8XhOXuszcyCaMOcVWb-erGAJQdhBHCX-gsJ4KpH+Td7+bPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAA8XhOXuszcyCaMOcVWb-erGAJQdhBHCX-gsJ4KpH+Td7+bPQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Kelbel Junior <jymmyjr@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jan 20, 2012 at 03:55:18PM -0200, Kelbel Junior wrote:
> Hello again ...
> 
> So ... after changing the memory allocator SLUB to SLAB in the Linux
> kernel and apply the patch mentioned below, the system was stable for
> 3 days and today it happened again delay to deliver content on the
> disc.
> 
> When I went to see if there was something wrong in /var/log/messages
> appear several times this block:

Can you try the patch below to make the extent indirection array
reallocation more efficient?  It's still working around the symptoms,
though.

What kind of workload are you running to get this extremely high number
of extents?

Index: xfs/fs/xfs/kmem.c
===================================================================
--- xfs.orig/fs/xfs/kmem.c	2011-10-17 09:28:57.159149025 +0200
+++ xfs/fs/xfs/kmem.c	2012-01-24 21:04:50.405954910 +0100
@@ -86,19 +86,22 @@ kmem_free(const void *ptr)
 }
 
 void *
-kmem_realloc(const void *ptr, size_t newsize, size_t oldsize,
-	     unsigned int __nocast flags)
+kmem_realloc(const void *old, size_t newsize, unsigned int __nocast flags)
 {
+	gfp_t	lflags = kmem_flags_convert(flags);
+	int	retries = 0;
 	void	*new;
 
-	new = kmem_alloc(newsize, flags);
-	if (ptr) {
-		if (new)
-			memcpy(new, ptr,
-				((oldsize < newsize) ? oldsize : newsize));
-		kmem_free(ptr);
-	}
-	return new;
+	do {
+		new = krealloc(old, newsize, lflags);
+		if (new || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
+			return new;
+		if (!(++retries % 100))
+			xfs_err(NULL,
+		"possible memory allocation deadlock in %s (mode:0x%x)",
+					__func__, lflags);
+		congestion_wait(BLK_RW_ASYNC, HZ/50);
+	} while (1);
 }
 
 void *
Index: xfs/fs/xfs/kmem.h
===================================================================
--- xfs.orig/fs/xfs/kmem.h	2011-12-18 23:35:30.893167926 +0100
+++ xfs/fs/xfs/kmem.h	2012-01-24 21:00:07.865956600 +0100
@@ -56,7 +56,7 @@ kmem_flags_convert(unsigned int __nocast
 
 extern void *kmem_alloc(size_t, unsigned int __nocast);
 extern void *kmem_zalloc(size_t, unsigned int __nocast);
-extern void *kmem_realloc(const void *, size_t, size_t, unsigned int __nocast);
+extern void *kmem_realloc(const void *, size_t, unsigned int __nocast);
 extern void  kmem_free(const void *);
 
 static inline void *kmem_zalloc_large(size_t size)
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2012-01-24 20:57:27.079290895 +0100
+++ xfs/fs/xfs/xfs_inode.c	2012-01-24 21:02:48.145955643 +0100
@@ -1826,7 +1826,6 @@ xfs_iroot_realloc(
 		new_max = cur_max + rec_diff;
 		new_size = (size_t)XFS_BMAP_BROOT_SPACE_CALC(new_max);
 		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
-				(size_t)XFS_BMAP_BROOT_SPACE_CALC(cur_max), /* old size */
 				KM_SLEEP | KM_NOFS);
 		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
 						     ifp->if_broot_bytes);
@@ -1968,7 +1967,6 @@ xfs_idata_realloc(
 				ifp->if_u1.if_data =
 					kmem_realloc(ifp->if_u1.if_data,
 							real_size,
-							ifp->if_real_bytes,
 							KM_SLEEP | KM_NOFS);
 			}
 		} else {
@@ -3254,8 +3252,7 @@ xfs_iext_realloc_direct(
 		if (rnew_size != ifp->if_real_bytes) {
 			ifp->if_u1.if_extents =
 				kmem_realloc(ifp->if_u1.if_extents,
-						rnew_size,
-						ifp->if_real_bytes, KM_NOFS);
+						rnew_size, KM_NOFS);
 		}
 		if (rnew_size > ifp->if_real_bytes) {
 			memset(&ifp->if_u1.if_extents[ifp->if_bytes /
@@ -3333,20 +3330,15 @@ xfs_iext_realloc_indirect(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	int		new_size)	/* new indirection array size */
 {
-	int		nlists;		/* number of irec's (ex lists) */
-	int		size;		/* current indirection array size */
-
 	ASSERT(ifp->if_flags & XFS_IFEXTIREC);
-	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
-	size = nlists * sizeof(xfs_ext_irec_t);
 	ASSERT(ifp->if_real_bytes);
-	ASSERT((new_size >= 0) && (new_size != size));
+	ASSERT(new_size >= 0);
+
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
 
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2011-12-18 23:35:30.906501259 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2012-01-24 21:02:20.352622478 +0100
@@ -1489,7 +1489,7 @@ xlog_recover_add_to_cont_trans(
 	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
 	old_len = item->ri_buf[item->ri_cnt-1].i_len;
 
-	ptr = kmem_realloc(old_ptr, len+old_len, old_len, 0u);
+	ptr = kmem_realloc(old_ptr, len+old_len, KM_SLEEP);
 	memcpy(&ptr[old_len], dp, len); /* d, s, l */
 	item->ri_buf[item->ri_cnt-1].i_len += len;
 	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2011-12-18 23:35:30.906501259 +0100
+++ xfs/fs/xfs/xfs_mount.c	2012-01-24 21:05:29.699288013 +0100
@@ -147,7 +147,6 @@ xfs_uuid_mount(
 	if (hole < 0) {
 		xfs_uuid_table = kmem_realloc(xfs_uuid_table,
 			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
-			xfs_uuid_table_size  * sizeof(*xfs_uuid_table),
 			KM_SLEEP);
 		hole = xfs_uuid_table_size++;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

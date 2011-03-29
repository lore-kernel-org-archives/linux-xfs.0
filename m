Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2TJxmQu246920
	for <linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 14:59:48 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18227115C7A0
	for <linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 13:02:58 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id H8kQD1OHKkhOl0el for
	<linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 13:02:58 -0700 (PDT)
Date: Tue, 29 Mar 2011 16:02:56 -0400
From: "'Christoph Hellwig'" <hch@infradead.org>
Subject: Re: XFS memory allocation deadlock in 2.6.38
Message-ID: <20110329200256.GA6019@infradead.org>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
	<20110324174311.GA31576@infradead.org>
	<AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
	<BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5359@MSXAOA6.twosigma.com>
	<20110329192434.GA10536@infradead.org>
	<081DDE43F61F3D43929A181B477DCA95639B535C@MSXAOA6.twosigma.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <081DDE43F61F3D43929A181B477DCA95639B535C@MSXAOA6.twosigma.com>
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
To: Sean Noonan <Sean.Noonan@twosigma.com>
Cc: Trammell Hudson <Trammell.Hudson@twosigma.com>, Christos Zoulas <Christos.Zoulas@twosigma.com>, Martin Bligh <Martin.Bligh@twosigma.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Stephen Degler <Stephen.Degler@twosigma.com>, 'Christoph Hellwig' <hch@infradead.org>, "'linux-mm@kvack.org'" <linux-mm@kvack.org>, "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, 'Michel Lespinasse' <walken@google.com>

On Tue, Mar 29, 2011 at 03:46:21PM -0400, Sean Noonan wrote:
> > Can you check if the brute force patch below helps?
> 
> No such luck.

Actually thinking about it - we never do the vmalloc under any fs lock,
so this can't be the reason.  But nothing else in the patch spring to
mind either, so to narrow this down does reverting the patch on
2.6.38 also fix it?  The revert isn't quite trivial due to changes
since then, so here's the patch I came up with:


Index: xfs/fs/xfs/linux-2.6/kmem.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/kmem.c	2011-03-29 21:55:12.871726512 +0200
+++ xfs/fs/xfs/linux-2.6/kmem.c	2011-03-29 21:55:31.648723706 +0200
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include <linux/mm.h>
+#include <linux/vmalloc.h>
 #include <linux/highmem.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
@@ -25,25 +26,8 @@
 #include "kmem.h"
 #include "xfs_message.h"
 
-/*
- * Greedy allocation.  May fail and may return vmalloced memory.
- *
- * Must be freed using kmem_free_large.
- */
-void *
-kmem_zalloc_greedy(size_t *size, size_t minsize, size_t maxsize)
-{
-	void		*ptr;
-	size_t		kmsize = maxsize;
-
-	while (!(ptr = kmem_zalloc_large(kmsize))) {
-		if ((kmsize >>= 1) <= minsize)
-			kmsize = minsize;
-	}
-	if (ptr)
-		*size = kmsize;
-	return ptr;
-}
+#define MAX_VMALLOCS	6
+#define MAX_SLAB_SIZE	0x20000
 
 void *
 kmem_alloc(size_t size, unsigned int __nocast flags)
@@ -52,8 +36,19 @@ kmem_alloc(size_t size, unsigned int __n
 	gfp_t	lflags = kmem_flags_convert(flags);
 	void	*ptr;
 
+#ifdef DEBUG
+	if (unlikely(!(flags & KM_LARGE) && (size > PAGE_SIZE))) {
+		printk(KERN_WARNING "Large %s attempt, size=%ld\n",
+			__func__, (long)size);
+		dump_stack();
+	}
+#endif
+
 	do {
-		ptr = kmalloc(size, lflags);
+		if (size < MAX_SLAB_SIZE || retries > MAX_VMALLOCS)
+			ptr = kmalloc(size, lflags);
+		else
+			ptr = __vmalloc(size, lflags, PAGE_KERNEL);
 		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
 			return ptr;
 		if (!(++retries % 100))
@@ -75,6 +70,27 @@ kmem_zalloc(size_t size, unsigned int __
 	return ptr;
 }
 
+void *
+kmem_zalloc_greedy(size_t *size, size_t minsize, size_t maxsize,
+		   unsigned int __nocast flags)
+{
+	void		*ptr;
+	size_t		kmsize = maxsize;
+	unsigned int	kmflags = (flags & ~KM_SLEEP) | KM_NOSLEEP;
+
+	while (!(ptr = kmem_zalloc(kmsize, kmflags))) {
+		if ((kmsize <= minsize) && (flags & KM_NOSLEEP))
+			break;
+		if ((kmsize >>= 1) <= minsize) {
+			kmsize = minsize;
+			kmflags = flags;
+		}
+	}
+	if (ptr)
+		*size = kmsize;
+	return ptr;
+}
+
 void
 kmem_free(const void *ptr)
 {
Index: xfs/fs/xfs/linux-2.6/kmem.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/kmem.h	2011-03-29 21:55:12.879725146 +0200
+++ xfs/fs/xfs/linux-2.6/kmem.h	2011-03-29 21:55:31.652725467 +0200
@@ -21,7 +21,6 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
-#include <linux/vmalloc.h>
 
 /*
  * General memory allocation interfaces
@@ -31,6 +30,7 @@
 #define KM_NOSLEEP	0x0002u
 #define KM_NOFS		0x0004u
 #define KM_MAYFAIL	0x0008u
+#define KM_LARGE	0x0010u
 
 /*
  * We use a special process flag to avoid recursive callbacks into
@@ -42,7 +42,7 @@ kmem_flags_convert(unsigned int __nocast
 {
 	gfp_t	lflags;
 
-	BUG_ON(flags & ~(KM_SLEEP|KM_NOSLEEP|KM_NOFS|KM_MAYFAIL));
+	BUG_ON(flags & ~(KM_SLEEP|KM_NOSLEEP|KM_NOFS|KM_MAYFAIL|KM_LARGE));
 
 	if (flags & KM_NOSLEEP) {
 		lflags = GFP_ATOMIC | __GFP_NOWARN;
@@ -56,25 +56,10 @@ kmem_flags_convert(unsigned int __nocast
 
 extern void *kmem_alloc(size_t, unsigned int __nocast);
 extern void *kmem_zalloc(size_t, unsigned int __nocast);
+extern void *kmem_zalloc_greedy(size_t *, size_t, size_t, unsigned int __nocast);
 extern void *kmem_realloc(const void *, size_t, size_t, unsigned int __nocast);
 extern void  kmem_free(const void *);
 
-static inline void *kmem_zalloc_large(size_t size)
-{
-	void *ptr;
-
-	ptr = vmalloc(size);
-	if (ptr)
-		memset(ptr, 0, size);
-	return ptr;
-}
-static inline void kmem_free_large(void *ptr)
-{
-	vfree(ptr);
-}
-
-extern void *kmem_zalloc_greedy(size_t *, size_t, size_t);
-
 /*
  * Zone interfaces
  */
Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2011-03-29 21:55:12.859726589 +0200
+++ xfs/fs/xfs/quota/xfs_qm.c	2011-03-29 21:55:41.387278609 +0200
@@ -110,11 +110,12 @@ xfs_Gqm_init(void)
 	 */
 	udqhash = kmem_zalloc_greedy(&hsize,
 				     XFS_QM_HASHSIZE_LOW * sizeof(xfs_dqhash_t),
-				     XFS_QM_HASHSIZE_HIGH * sizeof(xfs_dqhash_t));
+				     XFS_QM_HASHSIZE_HIGH * sizeof(xfs_dqhash_t),
+				     KM_SLEEP | KM_MAYFAIL | KM_LARGE);
 	if (!udqhash)
 		goto out;
 
-	gdqhash = kmem_zalloc_large(hsize);
+	gdqhash = kmem_zalloc(hsize, KM_SLEEP | KM_LARGE);
 	if (!gdqhash)
 		goto out_free_udqhash;
 
@@ -171,7 +172,7 @@ xfs_Gqm_init(void)
 	return xqm;
 
  out_free_udqhash:
-	kmem_free_large(udqhash);
+	kmem_free(udqhash);
  out:
 	return NULL;
 }
@@ -194,8 +195,8 @@ xfs_qm_destroy(
 		xfs_qm_list_destroy(&(xqm->qm_usr_dqhtable[i]));
 		xfs_qm_list_destroy(&(xqm->qm_grp_dqhtable[i]));
 	}
-	kmem_free_large(xqm->qm_usr_dqhtable);
-	kmem_free_large(xqm->qm_grp_dqhtable);
+	kmem_free(xqm->qm_usr_dqhtable);
+	kmem_free(xqm->qm_grp_dqhtable);
 	xqm->qm_usr_dqhtable = NULL;
 	xqm->qm_grp_dqhtable = NULL;
 	xqm->qm_dqhashmask = 0;
Index: xfs/fs/xfs/xfs_itable.c
===================================================================
--- xfs.orig/fs/xfs/xfs_itable.c	2011-03-29 21:55:12.851725366 +0200
+++ xfs/fs/xfs/xfs_itable.c	2011-03-29 21:55:31.660724287 +0200
@@ -259,10 +259,8 @@ xfs_bulkstat(
 		(XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog);
 	nimask = ~(nicluster - 1);
 	nbcluster = nicluster >> mp->m_sb.sb_inopblog;
-	irbuf = kmem_zalloc_greedy(&irbsize, PAGE_SIZE, PAGE_SIZE * 4);
-	if (!irbuf)
-		return ENOMEM;
-
+	irbuf = kmem_zalloc_greedy(&irbsize, PAGE_SIZE, PAGE_SIZE * 4,
+				   KM_SLEEP | KM_MAYFAIL | KM_LARGE);
 	nirbuf = irbsize / sizeof(*irbuf);
 
 	/*
@@ -527,7 +525,7 @@ xfs_bulkstat(
 	/*
 	 * Done, we're either out of filesystem or space to put the data.
 	 */
-	kmem_free_large(irbuf);
+	kmem_free(irbuf);
 	*ubcountp = ubelem;
 	/*
 	 * Found some inodes, return them now and return the error next time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

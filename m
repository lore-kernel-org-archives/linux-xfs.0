Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Aug 2006 22:53:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7A5rBDW003612
	for <xfs@oss.sgi.com>; Wed, 9 Aug 2006 22:53:25 -0700
Received: from wobbly.melbourne.sgi.com (wobbly.melbourne.sgi.com [134.14.55.135]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id PAA19071 for <xfs@oss.sgi.com>; Thu, 10 Aug 2006 15:52:32 +1000
Received: from wobbly.melbourne.sgi.com (localhost [127.0.0.1])
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k7A5qVgw2591511
	for <xfs@oss.sgi.com>; Thu, 10 Aug 2006 15:52:31 +1000 (EST)
Received: (from nathans@localhost)
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id k7A5qTPU2590997
	for xfs@oss.sgi.com; Thu, 10 Aug 2006 15:52:29 +1000 (EST)
Date: Thu, 10 Aug 2006 15:52:29 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: review: greedy allocation interface
Message-ID: <20060810155229.B2591606@wobbly.melbourne.sgi.com>
References: <20060802170636.B2356368@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060802170636.B2356368@wobbly.melbourne.sgi.com>; from nathans@sgi.com on Wed, Aug 02, 2006 at 05:06:36PM +1000
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wed, Aug 02, 2006 at 05:06:36PM +1000, Nathan Scott wrote:
> As discussed.  Slightly different interface, it was a bit simpler
> to have both min/max passed in separately to the passed out size.

There was a buglet in handling the maximum sizing of a couple of
the hash table caches earlier, here is a fixed version.

cheers.

-- 
Nathan

Index: xfs-linux/linux-2.4/kmem.c
===================================================================
--- xfs-linux.orig/linux-2.4/kmem.c	2006-08-09 13:51:42.888636500 +1000
+++ xfs-linux/linux-2.4/kmem.c	2006-08-09 13:59:05.117873750 +1000
@@ -85,6 +85,19 @@ kmem_zalloc(size_t size, int flags)
 	return ptr;
 }
 
+void *
+kmem_zalloc_greedy(size_t *size, size_t minsize, size_t maxsize, int flags)
+{
+	void	*ptr;
+
+	while (!(ptr = kmem_zalloc(maxsize, flags))) {
+		if ((maxsize >>= 1) <= minsize)
+			flags = KM_SLEEP;
+	}
+	*size = maxsize;
+	return ptr;
+}
+
 void
 kmem_free(void *ptr, size_t size)
 {
Index: xfs-linux/linux-2.4/kmem.h
===================================================================
--- xfs-linux.orig/linux-2.4/kmem.h	2006-08-09 13:51:04.753328000 +1000
+++ xfs-linux/linux-2.4/kmem.h	2006-08-09 13:59:05.149875750 +1000
@@ -54,8 +54,9 @@ kmem_flags_convert(int flags)
 }
 
 extern void *kmem_alloc(size_t, int);
-extern void *kmem_realloc(void *, size_t, size_t, int);
 extern void *kmem_zalloc(size_t, int);
+extern void *kmem_zalloc_greedy(size_t *, size_t, size_t, int);
+extern void *kmem_realloc(void *, size_t, size_t, int);
 extern void  kmem_free(void *, size_t);
 
 /*
Index: xfs-linux/linux-2.6/kmem.c
===================================================================
--- xfs-linux.orig/linux-2.6/kmem.c	2006-08-09 13:51:49.849589750 +1000
+++ xfs-linux/linux-2.6/kmem.c	2006-08-09 13:59:05.237881250 +1000
@@ -68,6 +68,20 @@ kmem_zalloc(size_t size, unsigned int __
 	return ptr;
 }
 
+void *
+kmem_zalloc_greedy(size_t *size, size_t minsize, size_t maxsize,
+		   unsigned int __nocast flags)
+{
+	void	*ptr;
+
+	while (!(ptr = kmem_zalloc(maxsize, flags))) {
+		if ((maxsize >>= 1) <= minsize)
+			flags = KM_SLEEP;
+	}
+	*size = maxsize;
+	return ptr;
+}
+
 void
 kmem_free(void *ptr, size_t size)
 {
Index: xfs-linux/linux-2.6/kmem.h
===================================================================
--- xfs-linux.orig/linux-2.6/kmem.h	2006-08-09 13:51:04.889268500 +1000
+++ xfs-linux/linux-2.6/kmem.h	2006-08-09 13:59:05.273883500 +1000
@@ -55,8 +55,9 @@ kmem_flags_convert(unsigned int __nocast
 }
 
 extern void *kmem_alloc(size_t, unsigned int __nocast);
-extern void *kmem_realloc(void *, size_t, size_t, unsigned int __nocast);
 extern void *kmem_zalloc(size_t, unsigned int __nocast);
+extern void *kmem_zalloc_greedy(size_t *, size_t, size_t, unsigned int __nocast);
+extern void *kmem_realloc(void *, size_t, size_t, unsigned int __nocast);
 extern void  kmem_free(void *, size_t);
 
 /*
Index: xfs-linux/quota/xfs_qm.c
===================================================================
--- xfs-linux.orig/quota/xfs_qm.c	2006-08-09 13:51:04.969233500 +1000
+++ xfs-linux/quota/xfs_qm.c	2006-08-09 13:59:05.365889250 +1000
@@ -112,17 +112,16 @@ xfs_Gqm_init(void)
 {
 	xfs_dqhash_t	*udqhash, *gdqhash;
 	xfs_qm_t	*xqm;
-	uint		i, hsize, flags = KM_SLEEP | KM_MAYFAIL | KM_LARGE;
+	uint		i, hsize;
 
 	/*
 	 * Initialize the dquot hash tables.
 	 */
-	hsize = XFS_QM_HASHSIZE_HIGH;
-	while (!(udqhash = kmem_zalloc(hsize * sizeof(*udqhash), flags))) {
-		if ((hsize >>= 1) <= XFS_QM_HASHSIZE_LOW)
-			flags = KM_SLEEP;
-	}
-	gdqhash = kmem_zalloc(hsize * sizeof(*gdqhash), KM_SLEEP | KM_LARGE);
+	udqhash = kmem_zalloc_greedy(&hsize,
+				     XFS_QM_HASHSIZE_LOW, XFS_QM_HASHSIZE_HIGH,
+				     KM_SLEEP | KM_MAYFAIL | KM_LARGE);
+	gdqhash = kmem_zalloc(hsize, KM_SLEEP | KM_LARGE);
+	hsize /= sizeof(xfs_dqhash_t);
 	ndquot = hsize << 8;
 
 	xqm = kmem_zalloc(sizeof(xfs_qm_t), KM_SLEEP);
Index: xfs-linux/xfs_iget.c
===================================================================
--- xfs-linux.orig/xfs_iget.c	2006-08-09 13:51:05.049198500 +1000
+++ xfs-linux/xfs_iget.c	2006-08-09 14:03:31.392278750 +1000
@@ -50,7 +50,7 @@ void
 xfs_ihash_init(xfs_mount_t *mp)
 {
 	__uint64_t	icount;
-	uint		i, flags = KM_SLEEP | KM_MAYFAIL | KM_LARGE;
+	uint		i;
 
 	if (!mp->m_ihsize) {
 		icount = mp->m_maxicount ? mp->m_maxicount :
@@ -61,14 +61,13 @@ xfs_ihash_init(xfs_mount_t *mp)
 					(64 * NBPP) / sizeof(xfs_ihash_t));
 	}
 
-	while (!(mp->m_ihash = (xfs_ihash_t *)kmem_zalloc(mp->m_ihsize *
-						sizeof(xfs_ihash_t), flags))) {
-		if ((mp->m_ihsize >>= 1) <= NBPP)
-			flags = KM_SLEEP;
-	}
-	for (i = 0; i < mp->m_ihsize; i++) {
+	mp->m_ihash = kmem_zalloc_greedy(&mp->m_ihsize,
+					 NBPC * sizeof(xfs_ihash_t),
+					 mp->m_ihsize * sizeof(xfs_ihash_t),
+					 KM_SLEEP | KM_MAYFAIL | KM_LARGE);
+	mp->m_ihsize /= sizeof(xfs_ihash_t);
+	for (i = 0; i < mp->m_ihsize; i++)
 		rwlock_init(&(mp->m_ihash[i].ih_lock));
-	}
 }
 
 /*
@@ -77,7 +76,7 @@ xfs_ihash_init(xfs_mount_t *mp)
 void
 xfs_ihash_free(xfs_mount_t *mp)
 {
-	kmem_free(mp->m_ihash, mp->m_ihsize*sizeof(xfs_ihash_t));
+	kmem_free(mp->m_ihash, mp->m_ihsize * sizeof(xfs_ihash_t));
 	mp->m_ihash = NULL;
 }
 
Index: xfs-linux/xfs_itable.c
===================================================================
--- xfs-linux.orig/xfs_itable.c	2006-08-09 13:51:05.081184500 +1000
+++ xfs-linux/xfs_itable.c	2006-08-09 13:59:05.537900000 +1000
@@ -326,7 +326,6 @@ xfs_bulkstat(
 	int			i;	/* loop index */
 	int			icount;	/* count of inodes good in irbuf */
 	int			irbsize; /* size of irec buffer in bytes */
-	unsigned int		kmflags; /* flags for allocating irec buffer */
 	xfs_ino_t		ino;	/* inode number (filesystem) */
 	xfs_inobt_rec_incore_t	*irbp;	/* current irec buffer pointer */
 	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
@@ -371,19 +370,8 @@ xfs_bulkstat(
 		(XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog);
 	nimask = ~(nicluster - 1);
 	nbcluster = nicluster >> mp->m_sb.sb_inopblog;
-	/*
-	 * Allocate a local buffer for inode cluster btree records.
-	 * This caps our maximum readahead window (so don't be stingy)
-	 * but we must handle the case where we can't get a contiguous
-	 * multi-page buffer, so we drop back toward pagesize; the end
-	 * case we ensure succeeds, via appropriate allocation flags.
-	 */
-	irbsize = NBPP * 4;
-	kmflags = KM_SLEEP | KM_MAYFAIL;
-	while (!(irbuf = kmem_alloc(irbsize, kmflags))) {
-		if ((irbsize >>= 1) <= NBPP)
-			kmflags = KM_SLEEP;
-	}
+	irbuf = kmem_zalloc_greedy(&irbsize, NBPC, NBPC * 4,
+				   KM_SLEEP | KM_MAYFAIL | KM_LARGE);
 	nirbuf = irbsize / sizeof(*irbuf);
 
 	/*

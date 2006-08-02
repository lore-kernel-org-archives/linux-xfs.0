Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Aug 2006 00:07:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7277GDW010082
	for <xfs@oss.sgi.com>; Wed, 2 Aug 2006 00:07:27 -0700
Received: from wobbly.melbourne.sgi.com (wobbly.melbourne.sgi.com [134.14.55.135]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id RAA04623 for <xfs@oss.sgi.com>; Wed, 2 Aug 2006 17:06:39 +1000
Received: from wobbly.melbourne.sgi.com (localhost [127.0.0.1])
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k7276bgw2327111
	for <xfs@oss.sgi.com>; Wed, 2 Aug 2006 17:06:38 +1000 (EST)
Received: (from nathans@localhost)
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id k7276aCO2355087
	for xfs@oss.sgi.com; Wed, 2 Aug 2006 17:06:36 +1000 (EST)
Date: Wed, 2 Aug 2006 17:06:36 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: review: greedy allocation interface
Message-ID: <20060802170636.B2356368@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

As discussed.  Slightly different interface, it was a bit simpler
to have both min/max passed in separately to the passed out size.

cheers.

-- 
Nathan


Index: xfs-linux/linux-2.4/kmem.c
===================================================================
--- xfs-linux.orig/linux-2.4/kmem.c	2006-08-02 13:59:38.934868500 +1000
+++ xfs-linux/linux-2.4/kmem.c	2006-08-02 14:06:16.163693750 +1000
@@ -90,6 +90,19 @@ kmem_zalloc(size_t size, int flags)
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
--- xfs-linux.orig/linux-2.4/kmem.h	2006-08-02 13:54:48.211704000 +1000
+++ xfs-linux/linux-2.4/kmem.h	2006-08-02 14:06:16.183695000 +1000
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
--- xfs-linux.orig/linux-2.6/kmem.c	2006-08-02 13:59:47.419398750 +1000
+++ xfs-linux/linux-2.6/kmem.c	2006-08-02 14:06:16.207696500 +1000
@@ -73,6 +73,20 @@ kmem_zalloc(size_t size, unsigned int __
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
--- xfs-linux.orig/linux-2.6/kmem.h	2006-08-02 13:54:48.187702500 +1000
+++ xfs-linux/linux-2.6/kmem.h	2006-08-02 14:06:16.231698000 +1000
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
--- xfs-linux.orig/quota/xfs_qm.c	2006-08-02 13:54:48.431717750 +1000
+++ xfs-linux/quota/xfs_qm.c	2006-08-02 14:06:16.251699250 +1000
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
Index: xfs-linux/quota/xfs_qm.h
===================================================================
--- xfs-linux.orig/quota/xfs_qm.h	2006-08-02 13:54:34.842868500 +1000
+++ xfs-linux/quota/xfs_qm.h	2006-08-02 14:06:16.263700000 +1000
@@ -52,8 +52,8 @@ extern kmem_zone_t	*qm_dqtrxzone;
 /*
  * Dquot hashtable constants/threshold values.
  */
-#define XFS_QM_HASHSIZE_LOW		(NBPP / sizeof(xfs_dqhash_t))
-#define XFS_QM_HASHSIZE_HIGH		((NBPP * 4) / sizeof(xfs_dqhash_t))
+#define XFS_QM_HASHSIZE_LOW		(NBPP)
+#define XFS_QM_HASHSIZE_HIGH		(NBPP * 4)
 
 /*
  * We output a cmn_err when quotachecking a quota file with more than
Index: xfs-linux/xfs_iget.c
===================================================================
--- xfs-linux.orig/xfs_iget.c	2006-08-02 13:54:48.387715000 +1000
+++ xfs-linux/xfs_iget.c	2006-08-02 14:10:27.901694500 +1000
@@ -61,14 +61,11 @@ xfs_ihash_init(xfs_mount_t *mp)
 					(64 * NBPP) / sizeof(xfs_ihash_t));
 	}
 
-	while (!(mp->m_ihash = (xfs_ihash_t *)kmem_zalloc(mp->m_ihsize *
-						sizeof(xfs_ihash_t), flags))) {
-		if ((mp->m_ihsize >>= 1) <= NBPP)
-			flags = KM_SLEEP;
-	}
-	for (i = 0; i < mp->m_ihsize; i++) {
+	mp->m_ihash = kmem_zalloc_greedy(&mp->m_ihsize, NBPC,
+					 mp->m_ihsize * sizeof(xfs_ihash_t),
+					 KM_SLEEP | KM_MAYFAIL | KM_LARGE);
+	for (i = 0; i < mp->m_ihsize; i++)
 		rwlock_init(&(mp->m_ihash[i].ih_lock));
-	}
 }
 
 /*
@@ -77,7 +74,7 @@ xfs_ihash_init(xfs_mount_t *mp)
 void
 xfs_ihash_free(xfs_mount_t *mp)
 {
-	kmem_free(mp->m_ihash, mp->m_ihsize*sizeof(xfs_ihash_t));
+	kmem_free(mp->m_ihash, mp->m_ihsize * sizeof(xfs_ihash_t));
 	mp->m_ihash = NULL;
 }
 
Index: xfs-linux/xfs_itable.c
===================================================================
--- xfs-linux.orig/xfs_itable.c	2006-08-02 13:54:38.735111750 +1000
+++ xfs-linux/xfs_itable.c	2006-08-02 14:11:38.405330500 +1000
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

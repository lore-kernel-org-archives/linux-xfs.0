Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Aug 2006 21:19:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7A4J0DW022608
	for <xfs@oss.sgi.com>; Wed, 9 Aug 2006 21:19:11 -0700
Received: from wobbly.melbourne.sgi.com (wobbly.melbourne.sgi.com [134.14.55.135]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id OAA17227 for <xfs@oss.sgi.com>; Thu, 10 Aug 2006 14:18:21 +1000
Received: from wobbly.melbourne.sgi.com (localhost [127.0.0.1])
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k7A4IJgw2588049
	for <xfs@oss.sgi.com>; Thu, 10 Aug 2006 14:18:20 +1000 (EST)
Received: (from nathans@localhost)
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id k7A4III32587767
	for xfs@oss.sgi.com; Thu, 10 Aug 2006 14:18:18 +1000 (EST)
Date: Thu, 10 Aug 2006 14:18:17 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: review: catch large memory allocations
Message-ID: <20060810141817.B2585102@wobbly.melbourne.sgi.com>
References: <20060802170431.A2356368@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060802170431.A2356368@wobbly.melbourne.sgi.com>; from nathans@sgi.com on Wed, Aug 02, 2006 at 05:04:31PM +1000
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wed, Aug 02, 2006 at 05:04:31PM +1000, Nathan Scott wrote:
> As discussed the other day, this is primarily a debugging patch
> to catch allocations that are unexpectedly large or dipping into
> vmalloc space.

Turns out that log recovery at least still needs to dip into vmalloc
space, so here's an updated version of the patch with that warning no
longer there.

cheers.

-- 
Nathan


Index: xfs-linux/linux-2.4/kmem.c
===================================================================
--- xfs-linux.orig/linux-2.4/kmem.c	2006-08-09 14:14:50.362431250 +1000
+++ xfs-linux/linux-2.4/kmem.c	2006-08-10 11:53:39.103452500 +1000
@@ -53,6 +53,14 @@ kmem_alloc(size_t size, int flags)
 	int	retries = 0, lflags = kmem_flags_convert(flags);
 	void	*ptr;
 
+#ifdef DEBUG
+	if (unlikely(!(flags & KM_LARGE) && (size > PAGE_SIZE))) {
+		printk(KERN_WARNING "Large %s attempt, size=%ld\n",
+			__FUNCTION__, (long)size);
+		dump_stack();
+	}
+#endif
+
 	do {
 		if (size < MAX_SLAB_SIZE || retries > MAX_VMALLOCS)
 			ptr = kmalloc(size, lflags);
Index: xfs-linux/linux-2.6/kmem.c
===================================================================
--- xfs-linux.orig/linux-2.6/kmem.c	2006-08-09 14:14:50.502370000 +1000
+++ xfs-linux/linux-2.6/kmem.c	2006-08-10 11:53:39.167488500 +1000
@@ -34,6 +34,14 @@ kmem_alloc(size_t size, unsigned int __n
 	gfp_t	lflags = kmem_flags_convert(flags);
 	void	*ptr;
 
+#ifdef DEBUG
+	if (unlikely(!(flags & KM_LARGE) && (size > PAGE_SIZE))) {
+		printk(KERN_WARNING "Large %s attempt, size=%ld\n",
+			__FUNCTION__, (long)size);
+		dump_stack();
+	}
+#endif
+
 	do {
 		if (size < MAX_SLAB_SIZE || retries > MAX_VMALLOCS)
 			ptr = kmalloc(size, lflags);
Index: xfs-linux/linux-2.6/kmem.h
===================================================================
--- xfs-linux.orig/linux-2.6/kmem.h	2006-08-09 14:14:50.578336750 +1000
+++ xfs-linux/linux-2.6/kmem.h	2006-08-10 11:53:39.203508750 +1000
@@ -30,6 +30,7 @@
 #define KM_NOSLEEP	0x0002u
 #define KM_NOFS		0x0004u
 #define KM_MAYFAIL	0x0008u
+#define KM_LARGE	0x0010u
 
 /*
  * We use a special process flag to avoid recursive callbacks into
@@ -41,7 +42,7 @@ kmem_flags_convert(unsigned int __nocast
 {
 	gfp_t	lflags;
 
-	BUG_ON(flags & ~(KM_SLEEP|KM_NOSLEEP|KM_NOFS|KM_MAYFAIL));
+	BUG_ON(flags & ~(KM_SLEEP|KM_NOSLEEP|KM_NOFS|KM_MAYFAIL|KM_LARGE));
 
 	if (flags & KM_NOSLEEP) {
 		lflags = GFP_ATOMIC | __GFP_NOWARN;
Index: xfs-linux/linux-2.4/kmem.h
===================================================================
--- xfs-linux.orig/linux-2.4/kmem.h	2006-08-09 14:14:50.430401500 +1000
+++ xfs-linux/linux-2.4/kmem.h	2006-08-10 11:53:39.135470500 +1000
@@ -29,6 +29,7 @@
 #define KM_NOSLEEP	0x0002
 #define KM_NOFS		0x0004
 #define KM_MAYFAIL	0x0008
+#define KM_LARGE	0x0010
 
 /*
  * We use a special process flag to avoid recursive callbacks into
@@ -40,7 +41,7 @@ kmem_flags_convert(int flags)
 {
 	int	lflags;
 
-	BUG_ON(flags & ~(KM_SLEEP|KM_NOSLEEP|KM_NOFS|KM_MAYFAIL));
+	BUG_ON(flags & ~(KM_SLEEP|KM_NOSLEEP|KM_NOFS|KM_MAYFAIL|KM_LARGE));
 
 	if (flags & KM_NOSLEEP) {
 		lflags = GFP_ATOMIC;
Index: xfs-linux/support/ktrace.c
===================================================================
--- xfs-linux.orig/support/ktrace.c	2006-08-09 14:14:50.654303500 +1000
+++ xfs-linux/support/ktrace.c	2006-08-10 11:49:57.882810000 +1000
@@ -75,7 +75,7 @@ ktrace_alloc(int nentries, unsigned int 
 							    sleep);
 	} else {
 		ktep = (ktrace_entry_t*)kmem_zalloc((nentries * sizeof(*ktep)),
-							    sleep);
+							    sleep | KM_LARGE);
 	}
 
 	if (ktep == NULL) {
Index: xfs-linux/linux-2.6/xfs_buf.c
===================================================================
--- xfs-linux.orig/linux-2.6/xfs_buf.c	2006-08-09 14:15:34.155263500 +1000
+++ xfs-linux/linux-2.6/xfs_buf.c	2006-08-10 11:54:06.572962750 +1000
@@ -773,7 +773,7 @@ xfs_buf_get_noaddr(
 	_xfs_buf_initialize(bp, target, 0, len, 0);
 
  try_again:
-	data = kmem_alloc(malloc_len, KM_SLEEP | KM_MAYFAIL);
+	data = kmem_alloc(malloc_len, KM_SLEEP | KM_MAYFAIL | KM_LARGE);
 	if (unlikely(data == NULL))
 		goto fail_free_buf;
 
Index: xfs-linux/linux-2.4/xfs_buf.c
===================================================================
--- xfs-linux.orig/linux-2.4/xfs_buf.c	2006-08-09 14:14:50.466385750 +1000
+++ xfs-linux/linux-2.4/xfs_buf.c	2006-08-10 11:54:31.058493000 +1000
@@ -875,7 +875,7 @@ xfs_buf_get_noaddr(
 	_xfs_buf_initialize(bp, target, 0, len, XBF_FORCEIO);
 
  try_again:
-	data = kmem_alloc(malloc_len, KM_SLEEP | KM_MAYFAIL);
+	data = kmem_alloc(malloc_len, KM_SLEEP | KM_MAYFAIL | KM_LARGE);
 	if (unlikely(data == NULL))
 		goto fail_free_buf;
 
Index: xfs-linux/xfs_log.c
===================================================================
--- xfs-linux.orig/xfs_log.c	2006-08-09 14:15:34.103286250 +1000
+++ xfs-linux/xfs_log.c	2006-08-09 14:15:34.503111250 +1000
@@ -1226,7 +1226,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 			  kmem_zalloc(sizeof(xlog_in_core_t), KM_SLEEP);
 		iclog = *iclogp;
 		iclog->hic_data = (xlog_in_core_2_t *)
-			  kmem_zalloc(iclogsize, KM_SLEEP);
+			  kmem_zalloc(iclogsize, KM_SLEEP | KM_LARGE);
 
 		iclog->ic_prev = prev_iclog;
 		prev_iclog = iclog;
Index: xfs-linux/xfs_iget.c
===================================================================
--- xfs-linux.orig/xfs_iget.c	2006-08-09 14:14:50.722273750 +1000
+++ xfs-linux/xfs_iget.c	2006-08-10 11:53:39.267544750 +1000
@@ -50,7 +50,7 @@ void
 xfs_ihash_init(xfs_mount_t *mp)
 {
 	__uint64_t	icount;
-	uint		i, flags = KM_SLEEP | KM_MAYFAIL;
+	uint		i, flags = KM_SLEEP | KM_MAYFAIL | KM_LARGE;
 
 	if (!mp->m_ihsize) {
 		icount = mp->m_maxicount ? mp->m_maxicount :
@@ -95,7 +95,7 @@ xfs_chash_init(xfs_mount_t *mp)
 	mp->m_chsize = min_t(uint, mp->m_chsize, mp->m_ihsize);
 	mp->m_chash = (xfs_chash_t *)kmem_zalloc(mp->m_chsize
 						 * sizeof(xfs_chash_t),
-						 KM_SLEEP);
+						 KM_SLEEP | KM_LARGE);
 	for (i = 0; i < mp->m_chsize; i++) {
 		spinlock_init(&mp->m_chash[i].ch_lock,"xfshash");
 	}
Index: xfs-linux/quota/xfs_qm.c
===================================================================
--- xfs-linux.orig/quota/xfs_qm.c	2006-08-09 14:15:33.359611750 +1000
+++ xfs-linux/quota/xfs_qm.c	2006-08-10 11:53:39.235526750 +1000
@@ -112,17 +112,17 @@ xfs_Gqm_init(void)
 {
 	xfs_dqhash_t	*udqhash, *gdqhash;
 	xfs_qm_t	*xqm;
-	uint		i, hsize, flags = KM_SLEEP | KM_MAYFAIL;
+	uint		i, hsize, flags = KM_SLEEP | KM_MAYFAIL | KM_LARGE;
 
 	/*
 	 * Initialize the dquot hash tables.
 	 */
 	hsize = XFS_QM_HASHSIZE_HIGH;
-	while (!(udqhash = kmem_zalloc(hsize * sizeof(xfs_dqhash_t), flags))) {
+	while (!(udqhash = kmem_zalloc(hsize * sizeof(*udqhash), flags))) {
 		if ((hsize >>= 1) <= XFS_QM_HASHSIZE_LOW)
 			flags = KM_SLEEP;
 	}
-	gdqhash = kmem_zalloc(hsize * sizeof(xfs_dqhash_t), KM_SLEEP);
+	gdqhash = kmem_zalloc(hsize * sizeof(*gdqhash), KM_SLEEP | KM_LARGE);
 	ndquot = hsize << 8;
 
 	xqm = kmem_zalloc(sizeof(xfs_qm_t), KM_SLEEP);

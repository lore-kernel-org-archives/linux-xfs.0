Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Jul 2006 20:51:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6P3ogDW014809
	for <xfs@oss.sgi.com>; Mon, 24 Jul 2006 20:50:54 -0700
Date: Tue, 25 Jul 2006 13:50:04 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: review: increase bulkstat readahead window
Message-ID: <20060725135004.E2116482@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: vapo@melbourne.sgi.com
Cc: xfs@oss.sgi.com

Hi all,
    
We limit the amount of bulkstat readahead we can issue based on 
the size of the array of inode cluster records (irbuf), which we
allocate on each bulkstat call.  Increasing the size of this array
has shown noticable performance improvements, and given bulkstat
is always called to scan the filesystem from one end to the other,
we're going to have to issue that IO at some point, may as well do
it up front.  We don't want to get silly in sizing this buffer, 
though, as it needs to be a contiguous chunk of memory.  Here I've
increased it from 1 page to 4 pages, with some logic to halve the
size incrementally if we cant allocate that successfully (as we do
in one or two other places in XFS, for other things).

cheers.

-- 
Nathan


Index: xfs-linux/xfs_itable.c
===================================================================
--- xfs-linux.orig/xfs_itable.c	2006-07-25 11:59:26.144649250 +1000
+++ xfs-linux/xfs_itable.c	2006-07-25 12:01:53.734832500 +1000
@@ -325,6 +325,8 @@ xfs_bulkstat(
 	xfs_agino_t		gino;	/* current btree rec's start inode */
 	int			i;	/* loop index */
 	int			icount;	/* count of inodes good in irbuf */
+	int			irbsize; /* size of irec buffer in bytes */
+	unsigned int		kmflags; /* flags for allocating irec buffer */
 	xfs_ino_t		ino;	/* inode number (filesystem) */
 	xfs_inobt_rec_incore_t	*irbp;	/* current irec buffer pointer */
 	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
@@ -370,12 +372,20 @@ xfs_bulkstat(
 	nimask = ~(nicluster - 1);
 	nbcluster = nicluster >> mp->m_sb.sb_inopblog;
 	/*
-	 * Allocate a page-sized buffer for inode btree records.
-	 * We could try allocating something smaller, but for normal
-	 * calls we'll always (potentially) need the whole page.
+	 * Allocate a local buffer for inode cluster btree records.
+	 * This caps our maximum readahead window (so don't be stingy)
+	 * but we must handle the case where we can't get a contiguous
+	 * multi-page buffer, so we drop back toward pagesize; the end
+	 * case we ensure succeeds, via appropriate allocation flags.
 	 */
-	irbuf = kmem_alloc(NBPC, KM_SLEEP);
-	nirbuf = NBPC / sizeof(*irbuf);
+	irbsize = NBPP * 4;
+	kmflags = KM_SLEEP | KM_MAYFAIL;
+	while (!(irbuf = kmem_alloc(irbsize, kmflags))) {
+		if ((irbsize >>= 1) <= NBPP)
+			kmflags = KM_SLEEP;
+	}
+	nirbuf = irbsize / sizeof(*irbuf);
+
 	/*
 	 * Loop over the allocation groups, starting from the last
 	 * inode returned; 0 means start of the allocation group.
@@ -673,7 +683,7 @@ xfs_bulkstat(
 	/*
 	 * Done, we're either out of filesystem or space to put the data.
 	 */
-	kmem_free(irbuf, NBPC);
+	kmem_free(irbuf, irbsize);
 	*ubcountp = ubelem;
 	if (agno >= mp->m_sb.sb_agcount) {
 		/*

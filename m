Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Apr 2007 23:28:25 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3Q6SJfB014323
	for <xfs@oss.sgi.com>; Wed, 25 Apr 2007 23:28:20 -0700
Received: from edge (unknown [203.89.192.141])
	by postoffice.aconex.com (Postfix) with ESMTP id 83D5C92CE3A
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2007 14:20:19 +1000 (EST)
Subject: [PATCH] make growfs check device size limits too
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
Content-Type: multipart/mixed; boundary="=-Nuo0430tAw3aLPKSo1ct"
Date: Thu, 26 Apr 2007 16:30:14 +1000
Message-Id: <1177569014.6273.367.camel@edge>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--=-Nuo0430tAw3aLPKSo1ct
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On the mount path we check for a superblock that describes a filesystem
to large for the running kernel to handle.  This catches the case of an
attempt to mount a >16TB filesystem on i386 (where we are limited by the
page->index size, for XFS metadata buffers in xfs_buf.c).

This patch makes similar checks on the growfs code paths for regular and
realtime growth, else we can end up with filesystem corruption, it would
seem (from #xfs chatter).  Untested patch follows; probably better to do
this as a macro, in a header, and call that in each place...?

cheers.

-- 
Nathan

--=-Nuo0430tAw3aLPKSo1ct
Content-Disposition: attachment; filename=growfs.patch
Content-Type: text/x-patch; name=growfs.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- fs/xfs/xfs_fsops.c.orig	2007-04-26 16:05:38.126936000 +1000
+++ fs/xfs/xfs_fsops.c	2007-04-26 16:17:03.385762000 +1000
@@ -148,6 +148,20 @@
 		return error;
 	ASSERT(bp);
 	xfs_buf_relse(bp);
+	/*
+	 * Device drivers seem to be pathological liars... so, guess we
+	 * better check that the size isn't something completely insane.
+	 * Same check is done during mount, so we wont create something
+	 * here that we cannot later mount, at least.
+	 */
+#if XFS_BIG_BLKNOS     /* Limited by ULONG_MAX of page cache index */
+	if (unlikely(
+	    (nb >> (PAGE_CACHE_SHIFT - sbp->sb_blocklog)) > ULONG_MAX))
+#else                  /* Limited by UINT_MAX of sectors */
+	if (unlikely(
+	    (nb << (sbp->sb_blocklog - BBSHIFT)) > UINT_MAX))
+#endif
+	    return XFS_ERROR(E2BIG);
 
 	new = nb;	/* use new as a temporary here */
 	nb_mod = do_div(new, mp->m_sb.sb_agblocks);
--- fs/xfs/xfs_rtalloc.c.orig	2007-04-26 16:16:34.695969000 +1000
+++ fs/xfs/xfs_rtalloc.c	2007-04-26 16:22:43.227000750 +1000
@@ -1893,6 +1893,20 @@
 	ASSERT(bp);
 	xfs_buf_relse(bp);
 	/*
+	 * Device drivers seem to be pathological liars... so, guess we
+	 * better check that the size isn't something completely insane.
+	 * Same check is done during mount, so we wont create something
+	 * here that we cannot later mount, at least.
+	 */
+#if XFS_BIG_BLKNOS     /* Limited by ULONG_MAX of page cache index */
+	if (unlikely(
+	    (nrblocks >> (PAGE_CACHE_SHIFT - sbp->sb_blocklog)) > ULONG_MAX))
+#else                  /* Limited by UINT_MAX of sectors */
+	if (unlikely(
+	    (nrblocks << (sbp->sb_blocklog - BBSHIFT)) > UINT_MAX))
+#endif
+		return XFS_ERROR(E2BIG);
+	/*
 	 * Calculate new parameters.  These are the final values to be reached.
 	 */
 	nrextents = nrblocks;

--=-Nuo0430tAw3aLPKSo1ct--

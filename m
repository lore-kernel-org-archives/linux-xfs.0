Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Aug 2006 20:32:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7S3WKDW019197
	for <xfs@oss.sgi.com>; Sun, 27 Aug 2006 20:32:32 -0700
Received: from wobbly.melbourne.sgi.com (wobbly.melbourne.sgi.com [134.14.55.135]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id NAA00464 for <xfs@oss.sgi.com>; Mon, 28 Aug 2006 13:31:36 +1000
Received: from wobbly.melbourne.sgi.com (localhost [127.0.0.1])
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k7S3VYgw3119471
	for <xfs@oss.sgi.com>; Mon, 28 Aug 2006 13:31:34 +1000 (EST)
Received: (from nathans@localhost)
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id k7S3VW2u3127520
	for xfs@oss.sgi.com; Mon, 28 Aug 2006 13:31:32 +1000 (EST)
Date: Mon, 28 Aug 2006 13:31:32 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: review: change default realtime extsize
Message-ID: <20060828133132.A3124842@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

While testing something else recently, I noticed we were always
creating a large number of unwritten extents during page cache
writout to the realtime subvolume.  It turned out to be because
of the way we are typically called with page sized allocation
requests, but we always allocate much more than a page.  Back
when realtime subvols could only use direct I/O this was fine
(apps typically used larger IO sizes) but now its not so good.

These larger allocations are ending up meaning we need to do many
additional unwritten extent conversions (i.e. more transactions,
and more log traffic), which we can easily avoid.  Since we have
a default 4K filesystem blocksize on the data device, there would
seem to be no harm in matching that on the realtime subvolume, by
default.  This simple mkfs tweak does just that...

cheers.

-- 
Nathan


Index: xfsprogs/include/xfs_rtalloc.h
===================================================================
--- xfsprogs.orig/include/xfs_rtalloc.h	2006-08-18 11:50:35.916857000 +1000
+++ xfsprogs/include/xfs_rtalloc.h	2006-08-18 11:55:44.820162250 +1000
@@ -25,7 +25,7 @@ struct xfs_trans;
 
 /* Min and max rt extent sizes, specified in bytes */
 #define	XFS_MAX_RTEXTSIZE	(1024 * 1024 * 1024)	/* 1GB */
-#define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64KB */
+#define	XFS_DFL_RTEXTSIZE	(4 * 1024)	        /* 4KB */
 #define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4KB */
 
 /*

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 15:01:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m41M0n0C001306
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 15:00:55 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6EA7A1B2BCAC
	for <xfs@oss.sgi.com>; Thu,  1 May 2008 15:01:30 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id swAtAmJsO3kY8pMO for <xfs@oss.sgi.com>; Thu, 01 May 2008 15:01:30 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m41M1OF3002470
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 2 May 2008 00:01:24 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m41M1OwX002468
	for xfs@oss.sgi.com; Fri, 2 May 2008 00:01:24 +0200
Date: Fri, 2 May 2008 00:01:24 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/10] kill calls to xfs_binval in the mount error path
Message-ID: <20080501220124.GH2315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_binval aka xfs_flush_buftarg is the first thing done in
xfs_free_buftarg, so there is no need to have duplicated calls just
before xfs_free_buftarg in the mount failure path.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-05-01 20:33:11.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-05-01 20:33:35.000000000 +0200
@@ -1790,10 +1790,10 @@ xfs_fs_fill_super(
 	 */
 	error = xfs_start_flags(args, mp);
 	if (error)
-		goto error1;
+		goto out_destroy_counters;
 	error = xfs_readsb(mp, flags);
 	if (error)
-		goto error1;
+		goto out_destroy_counters;
 	error = xfs_finish_flags(args, mp);
 	if (error)
 		goto error2;
@@ -1854,12 +1854,6 @@ xfs_fs_fill_super(
  error2:
 	if (mp->m_sb_bp)
 		xfs_freesb(mp);
- error1:
-	xfs_binval(mp->m_ddev_targp);
-	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
-		xfs_binval(mp->m_logdev_targp);
-	if (mp->m_rtdev_targp)
-		xfs_binval(mp->m_rtdev_targp);
  out_destroy_counters:
 	xfs_icsb_destroy_counters(mp);
 	xfs_close_devices(mp);

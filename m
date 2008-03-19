Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 13:44:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2JKinri030048
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 13:44:52 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C5F16C0810
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 13:45:21 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 3ZOPkjUE9Jf0dVrG for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 13:45:21 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m2JKjFF3024203
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 21:45:15 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m2JKjFBQ024201
	for xfs@oss.sgi.com; Wed, 19 Mar 2008 21:45:15 +0100
Date: Wed, 19 Mar 2008 21:45:15 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] kill XFS_ICSB_SB_LOCKED
Message-ID: <20080319204515.GD23644@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

With the last two patches XFS_ICSB_SB_LOCKED is never checked and
only superflously passed to xfs_icsb_count, so kill it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-03-08 15:51:26.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-03-08 15:51:26.000000000 +0100
@@ -2193,7 +2193,7 @@ xfs_icsb_disable_counter(
 	if (!test_and_set_bit(field, &mp->m_icsb_counters)) {
 		/* drain back to superblock */
 
-		xfs_icsb_count(mp, &cnt, XFS_ICSB_SB_LOCKED|XFS_ICSB_LAZY_COUNT);
+		xfs_icsb_count(mp, &cnt, XFS_ICSB_LAZY_COUNT);
 		switch(field) {
 		case XFS_SBS_ICOUNT:
 			mp->m_sb.sb_icount = cnt.icsb_icount;
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-03-08 15:51:24.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-03-08 15:51:26.000000000 +0100
@@ -206,7 +206,6 @@ typedef struct xfs_icsb_cnts {
 
 #define XFS_ICSB_FLAG_LOCK	(1 << 0)	/* counter lock bit */
 
-#define XFS_ICSB_SB_LOCKED	(1 << 0)	/* sb already locked */
 #define XFS_ICSB_LAZY_COUNT	(1 << 1)	/* accuracy not needed */
 
 extern int	xfs_icsb_init_counters(struct xfs_mount *);

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:02:08 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M421oq031796
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:02:03 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BA5EE8EE22
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:02:27 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Y2RhSRykG7KFJtKa for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:02:27 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m1M42MF3006222
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 05:02:22 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m1M42MqS006220
	for xfs@oss.sgi.com; Fri, 22 Feb 2008 05:02:22 +0100
Date: Fri, 22 Feb 2008 05:02:22 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/8] cleanup vnode use in xfs_bmap.c
Message-ID: <20080222040222.GH5964@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-01-03 15:04:00.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-01-03 15:04:09.000000000 +0100
@@ -5772,7 +5772,6 @@ xfs_getbmap(
 	int			error;		/* return value */
 	__int64_t		fixlen;		/* length for -1 case */
 	int			i;		/* extent number */
-	bhv_vnode_t		*vp;		/* corresponding vnode */
 	int			lock;		/* lock state */
 	xfs_bmbt_irec_t		*map;		/* buffer for user's data */
 	xfs_mount_t		*mp;		/* file system mount point */
@@ -5789,7 +5788,6 @@ xfs_getbmap(
 	int			bmapi_flags;	/* flags for xfs_bmapi */
 	__int32_t		oflags;		/* getbmapx bmv_oflags field */
 
-	vp = XFS_ITOV(ip);
 	mp = ip->i_mount;
 
 	whichfork = interface & BMV_IF_ATTRFORK ? XFS_ATTR_FORK : XFS_DATA_FORK;

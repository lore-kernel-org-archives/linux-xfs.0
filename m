Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 May 2008 12:07:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4PJ77RR022269
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 12:07:07 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA0771B0673
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 12:07:58 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id F4Rj9fs2CPNYZDPN for <xfs@oss.sgi.com>; Sun, 25 May 2008 12:07:58 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m4PJ7oF3014119
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 21:07:50 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m4PJ7oiM014117
	for xfs@oss.sgi.com; Sun, 25 May 2008 21:07:50 +0200
Date: Sun, 25 May 2008 21:07:50 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] fix the noquota mount option
Message-ID: <20080525190750.GC13372@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Noquota should clear all mount options, and not just user and group
quota.  Probably doesn't matter very much in real life.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-05-25 20:57:33.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-05-25 20:58:52.000000000 +0200
@@ -337,6 +337,7 @@ xfs_parseargs(
 		} else if (!strcmp(this_char, MNTOPT_NOQUOTA)) {
 			mp->m_qflags &= ~(XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
 					  XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
+					  XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
 					  XFS_UQUOTA_ENFD | XFS_OQUOTA_ENFD);
 		} else if (!strcmp(this_char, MNTOPT_QUOTA) ||
 			   !strcmp(this_char, MNTOPT_UQUOTA) ||

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 31 May 2008 00:57:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4V7vjbG007113
	for <xfs@oss.sgi.com>; Sat, 31 May 2008 00:57:47 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E16B41D5A4F
	for <xfs@oss.sgi.com>; Sat, 31 May 2008 00:58:37 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id xKcfRLuExtnQjveJ for <xfs@oss.sgi.com>; Sat, 31 May 2008 00:58:37 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m4V7wTOc005554
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 31 May 2008 09:58:30 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m4V7wTuc005552
	for xfs@oss.sgi.com; Sat, 31 May 2008 09:58:29 +0200
Date: Sat, 31 May 2008 09:58:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] check for invalid flags in xfs_attrlist_by_handle
Message-ID: <20080531075829.GA5424@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_attrlist_by_handle should only take the ATTR_ flags for the root
namespaces.  The ATTR_KERN* flags may change at anytime and expect special
preconditions that can't be guaranteed for userspace-originating
requests.  For example passing down ATTR_KERNNOVAL through
xfs_attrlist_by_handle will hit an assert in debug builds currently.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-05-28 17:37:02.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-05-28 17:42:18.000000000 +0200
@@ -470,6 +470,12 @@ xfs_attrlist_by_handle(
 	if (al_hreq.buflen > XATTR_LIST_MAX)
 		return -XFS_ERROR(EINVAL);
 
+	/*
+	 * Reject flags, only allow namespaces.
+	 */
+	if (al_hreq.flags & ~(ATTR_ROOT|ATTR_TRUST|ATTR_SECURE))
+		return -XFS_ERROR(EINVAL);
+
 	error = xfs_vget_fsop_handlereq(mp, parinode, &al_hreq.hreq, &inode);
 	if (error)
 		goto out;

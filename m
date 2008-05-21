Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 23:58:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4L6vvCM030016
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 23:57:58 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39A62BAF48C
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 23:58:46 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 1r9uulB3CTNJNaYT for <xfs@oss.sgi.com>; Tue, 20 May 2008 23:58:46 -0700 (PDT)
Date: Wed, 21 May 2008 08:58:32 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] optimize inode_setattr a little
Message-ID: <20080521065832.GA27545@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, Artem.Bityutskiy@nokia.com

Only mark the inode dirty if any field was actually changed.  Currently
this can't happen but it will with the next patch.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/attr.c
===================================================================
--- linux-2.6.orig/fs/attr.c	2008-05-20 20:37:46.000000000 +0200
+++ linux-2.6/fs/attr.c	2008-05-20 20:39:05.000000000 +0200
@@ -66,36 +66,50 @@ EXPORT_SYMBOL(inode_change_ok);
 int inode_setattr(struct inode * inode, struct iattr * attr)
 {
 	unsigned int ia_valid = attr->ia_valid;
+	int sync_it = 0;
 
 	if (ia_valid & ATTR_SIZE &&
 	    attr->ia_size != i_size_read(inode)) {
 		int error = vmtruncate(inode, attr->ia_size);
 		if (error)
 			return error;
+		sync_it = 1;
 	}
 
-	if (ia_valid & ATTR_UID)
+	if (ia_valid & ATTR_UID) {
 		inode->i_uid = attr->ia_uid;
-	if (ia_valid & ATTR_GID)
+		sync_it = 1;
+	}
+	if (ia_valid & ATTR_GID) {
 		inode->i_gid = attr->ia_gid;
-	if (ia_valid & ATTR_ATIME)
+		sync_it = 1;
+	}
+	if (ia_valid & ATTR_ATIME) {
 		inode->i_atime = timespec_trunc(attr->ia_atime,
 						inode->i_sb->s_time_gran);
-	if (ia_valid & ATTR_MTIME)
+		sync_it = 1;
+	}
+	if (ia_valid & ATTR_MTIME) {
 		inode->i_mtime = timespec_trunc(attr->ia_mtime,
 						inode->i_sb->s_time_gran);
-	if (ia_valid & ATTR_CTIME)
+		sync_it = 1;
+	}
+	if (ia_valid & ATTR_CTIME) {
 		inode->i_ctime = timespec_trunc(attr->ia_ctime,
 						inode->i_sb->s_time_gran);
+		sync_it = 1;
+	}
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
 
 		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
 			mode &= ~S_ISGID;
 		inode->i_mode = mode;
+		sync_it = 1;
 	}
-	mark_inode_dirty(inode);
 
+	if (sync_it)
+		mark_inode_dirty(inode);
 	return 0;
 }
 EXPORT_SYMBOL(inode_setattr);

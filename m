Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 737FC29E16
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 07:10:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 615A58F8035
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 05:10:54 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id kzsLBfXQNahOzJ4J (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Nov 2013 05:10:53 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1ViObM-0005e5-ME
	for xfs@oss.sgi.com; Mon, 18 Nov 2013 13:10:52 +0000
Date: Mon, 18 Nov 2013 05:10:52 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] xfs: add xfs_setattr_time
Message-ID: <20131118131052.GB21649@infradead.org>
References: <20131118131040.GA21649@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131118131040.GA21649@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Split out a xfs_setattr_time helper to share code between truncate and
regular setattr similar to xfs_setattr_mode.  I might also have another
caller growing for this in the near future.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_iops.c |   66 ++++++++++++++++++++++++------------------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

Index: linux/fs/xfs/xfs_iops.c
===================================================================
--- linux.orig/fs/xfs/xfs_iops.c	2013-11-18 11:54:46.083792257 +0100
+++ linux/fs/xfs/xfs_iops.c	2013-11-18 11:55:34.891791256 +0100
@@ -474,6 +474,32 @@ xfs_setattr_mode(
 	inode->i_mode |= mode & ~S_IFMT;
 }
 
+static void
+xfs_setattr_time(
+	struct xfs_inode	*ip,
+	struct iattr		*iattr)
+{
+	struct inode		*inode = VFS_I(ip);
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	if (iattr->ia_valid & ATTR_ATIME) {
+		inode->i_atime = iattr->ia_atime;
+		ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
+		ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
+	}
+	if (iattr->ia_valid & ATTR_CTIME) {
+		inode->i_ctime = iattr->ia_ctime;
+		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
+		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
+	}
+	if (iattr->ia_valid & ATTR_MTIME) {
+		inode->i_mtime = iattr->ia_mtime;
+		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
+		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
+	}
+}
+
 int
 xfs_setattr_nonsize(
 	struct xfs_inode	*ip,
@@ -627,30 +653,10 @@ xfs_setattr_nonsize(
 		}
 	}
 
-	/*
-	 * Change file access modes.
-	 */
 	if (mask & ATTR_MODE)
 		xfs_setattr_mode(ip, iattr);
-
-	/*
-	 * Change file access or modified times.
-	 */
-	if (mask & ATTR_ATIME) {
-		inode->i_atime = iattr->ia_atime;
-		ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
-		ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
-	}
-	if (mask & ATTR_CTIME) {
-		inode->i_ctime = iattr->ia_ctime;
-		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
-		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
-	}
-	if (mask & ATTR_MTIME) {
-		inode->i_mtime = iattr->ia_mtime;
-		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
-		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
-	}
+	if (mask & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
+		xfs_setattr_time(ip, iattr);
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
@@ -865,22 +871,10 @@ xfs_setattr_size(
 		xfs_inode_clear_eofblocks_tag(ip);
 	}
 
-	/*
-	 * Change file access modes.
-	 */
 	if (mask & ATTR_MODE)
 		xfs_setattr_mode(ip, iattr);
-
-	if (mask & ATTR_CTIME) {
-		inode->i_ctime = iattr->ia_ctime;
-		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
-		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
-	}
-	if (mask & ATTR_MTIME) {
-		inode->i_mtime = iattr->ia_mtime;
-		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
-		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
-	}
+	if (mask & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
+		xfs_setattr_time(ip, iattr);
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

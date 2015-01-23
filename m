Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C97987F4E
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 21:33:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 99E218F8050
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 19:33:55 -0800 (PST)
Received: from mail-pd0-f174.google.com (mail-pd0-f174.google.com
	[209.85.192.174]) by cuda.sgi.com with ESMTP id
	YLZ1MTSTbNnqlRNo (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 19:33:51 -0800 (PST)
Received: by mail-pd0-f174.google.com with SMTP id ft15so5902222pdb.5
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 19:33:51 -0800 (PST)
Received: from dhruv-MacBookAir ([14.97.157.235])
	by mx.google.com with ESMTPSA id rf7sm290497pab.3.2015.01.22.19.33.48
	for <xfs@oss.sgi.com> (version=TLSv1 cipher=RC4-SHA bits=128/128);
	Thu, 22 Jan 2015 19:33:50 -0800 (PST)
Message-ID: <54c1c11e.678c420a.37a1.13c6@mx.google.com>
From: Dhruvesh Rathore <adrscube@gmail.com>
Date: Fri, 23 Jan 2015 09:03:44 +0530
Subject: [PATCH 1/2] xfs_spaceman: XFS_IOC_FIEMAPFS ioctl replacing previous
	FS_IOC_FIEMAPFS
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The original kernel patch that Dave wrote for xfs_spaceman implemented
FS_IOC_FIEMAPFS ioctl, here is the original fiemap extension patch:

http://oss.sgi.com/archives/xfs/2012-10/msg00363.html

These patches were not posted and were just forward ported to a current 
3.18-rc7+ for-next XFS tree and were pushed to the fiemapfs branch in Dave's
kernel tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

The original xfs_spaceman tool that Dave wrote to call the fiemap
interface and make use of it is here:

http://oss.sgi.com/archives/xfs/2012-10/msg00366.html

Dave just updated it to the 3.2.2 code base and pushed it to the
spaceman branch in this tree:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

This patch is concerned with turning FS_IOC_FIEMAPFS, present in the earlier
version of xfs_spaceman into an XFS specific ioctl called XFS_IOC_FIEMAPFS
that uses the fiemap plumbing. Please do comment. 

Signed-off-by: 
Dhruvesh Rathore <dhruvesh_r@outlook.com>
Amey Ruikar <ameyruikar@yahoo.com>
Somdeep Dey <somdeepdey10@gmail.com>
---
linux-xfs/fs/xfs/xfs_fs.h		| 1 +
linux-xfs/fs/xfs/xfs_ioctl.c		| 71 ++++-
xfsprogs-3.2.2/include/xfs_fs.h		| 1 +
xfsprogs-3.2.2/spaceman/freesp.c	| 10 ++++++---
4 files changed, 79 insertions(+), 4 deletions(-) 

---------------------------------------------------------------------------------------

--- a/linux-xfs/fs/xfs/xfs_fs.h	2015-01-04 15:26:46.954401773 +0530
+++ b/linux-xfs/fs/xfs/xfs_fs.h	2015-01-04 11:29:54.531652554 +0530
@@ -505,6 +505,7 @@
 #define XFS_IOC_DIOINFO	_IOR ('X', 30, struct dioattr)
 #define XFS_IOC_FSGETXATTR	_IOR ('X', 31, struct fsxattr)
 #define XFS_IOC_FSSETXATTR	_IOW ('X', 32, struct fsxattr)
+#define XFS_IOC_FIEMAPFS	_IOWR('X', 33, struct fiemap)
 #define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
 #define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
 #define XFS_IOC_GETBMAP	_IOWR('X', 38, struct getbmap)

----------------------------------------------------------------------------------------

--- a/linux-xfs/fs/xfs/xfs_ioctl.c	2015-01-04 15:45:26.518359725 +0530
+++ b/linux-xfs/fs/xfs/xfs_ioctl.c	2015-01-04 15:24:06.030407817 +0530
@@ -49,6 +49,8 @@
 #include <linux/exportfs.h>
 
 
+/* So that the fiemap access checks can't overflow on 32 bit machines. */   		 
+#define FIEMAP_MAX_EXTENTS	(UINT_MAX / sizeof(struct fiemap_extent))		 
 
 /*
  * xfs_find_handle maps from userspace xfs_fsop_handlereq structure to
@@ -1511,8 +1513,73 @@
 	return error;
 }
 
+static int fiemap_check_ranges(struct super_block *sb,
+			       u64 start, u64 len, u64 *new_len)
+{
+	u64 maxbytes = (u64) sb->s_maxbytes;
+
+	*new_len = len;
+
+	if (len == 0)
+		return -EINVAL;
+
+	if (start > maxbytes)
+		return -EFBIG;
+
+	/*
+	 * Shrink request scope to what the fs can actually handle.
+	 */
+	if (len > maxbytes || (maxbytes - len) < start)
+		*new_len = maxbytes - start;
 
+	return 0;
+}
+
+static int xfsctl_fiemapfs(struct super_block *sb, unsigned long arg)				
+{
+	struct fiemap fiemap;									
+	struct fiemap __user *ufiemap = (struct fiemap __user *) arg;
+	struct fiemap_extent_info fieinfo = { 0, };
+	u64 len;
+	int error;
+
+	if (!sb->s_op->fiemapfs)
+		return -EOPNOTSUPP;
 
+	if (copy_from_user(&fiemap, ufiemap, sizeof(fiemap)))
+		return -EFAULT;
+
+	if (fiemap.fm_extent_count > FIEMAP_MAX_EXTENTS)
+		return -EINVAL;
+
+	error = fiemap_check_ranges(sb, fiemap.fm_start, fiemap.fm_length,
+				    &len);
+	if (error)
+		return error;
+
+	fieinfo.fi_flags = fiemap.fm_flags;
+	fieinfo.fi_extents_max = fiemap.fm_extent_count;
+	fieinfo.fi_extents_start = ufiemap->fm_extents;
+
+	if (fiemap.fm_extent_count != 0 &&
+	    !access_ok(VERIFY_WRITE, fieinfo.fi_extents_start,
+		       fieinfo.fi_extents_max * sizeof(struct fiemap_extent)))
+		return -EFAULT;
+
+	if (fiemap.fm_extent_count != 0 &&
+	    (fiemap.fm_flags & FIEMAPFS_FLAG_FREESP_SIZE_HINT) &&
+	    !access_ok(VERIFY_READ, fieinfo.fi_extents_start,
+		       sizeof(struct fiemap_extent)))
+		return -EFAULT;
+
+	error = sb->s_op->fiemapfs(sb, &fieinfo, fiemap.fm_start, len);
+	fiemap.fm_flags = fieinfo.fi_flags;
+	fiemap.fm_mapped_extents = fieinfo.fi_extents_mapped;
+	if (copy_to_user(ufiemap, &fiemap, sizeof(fiemap)))
+		error = -EFAULT;
+
+	return error;
+}
 
 /*
  * Note: some of the ioctl's return positive numbers as a
@@ -1570,7 +1637,9 @@
 		return 0;
 	}
 
-	
+	case XFS_IOC_FIEMAPFS:						
+	   return xfsctl_fiemapfs(inode->i_sb, p);			
+
 	case XFS_IOC_FSBULKSTAT_SINGLE:
 	case XFS_IOC_FSBULKSTAT:
 	case XFS_IOC_FSINUMBERS:

--------------------------------------------------------------------------------------------

--- a/xfsprogs-3.2.2/include/xfs_fs.h	2015-01-04 15:26:50.954401773 +0530
+++ b/xfsprogs-3.2.2/include/xfs_fs.h	2015-01-04 11:29:59.531652554 +0530
@@ -505,6 +505,7 @@
 #define XFS_IOC_DIOINFO	_IOR ('X', 30, struct dioattr)
 #define XFS_IOC_FSGETXATTR	_IOR ('X', 31, struct fsxattr)
 #define XFS_IOC_FSSETXATTR	_IOW ('X', 32, struct fsxattr)
+#define XFS_IOC_FIEMAPFS	_IOWR('X', 33, struct fiemap)
 #define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
 #define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
 #define XFS_IOC_GETBMAP	_IOWR('X', 38, struct getbmap)

--------------------------------------------------------------------------------------------

--- a/xfsprogs-3.2.2/spaceman/freesp.c	2015-01-04 15:39:58.446372047 +0530
+++ b/xfsprogs-3.2.2/spaceman/freesp.c	2015-01-04 15:38:30.294375357 +0530
@@ -31,7 +31,7 @@
 #define FIEMAPFS_FLAG_FREESP_SIZE_HINT	0x20000000
 #define	FIEMAPFS_FLAG_FREESP_CONTINUE   0x10000000
 
-#define FS_IOC_FIEMAPFS			_IOWR('f', 12, struct fiemap)
+#define XFS_IOC_FIEMAPFS			_IOWR('X', 33, struct fiemap)
 #endif
 
 typedef struct histent
@@ -201,9 +201,9 @@
 		fiemap->fm_length = length;
 		fiemap->fm_extent_count = NR_EXTENTS;
 
-		ret = ioctl(file->fd, XFS_IOC_FIEMAPFS, (unsigned long)fiemap);
+		ret = xfsctl(file->name,file->fd, XFS_IOC_FIEMAPFS, (unsigned long)fiemap);
 		if (ret < 0) {	
-			fprintf(stderr, "%s: ioctl(FS_IOC_FIEMAPFS) [\"%s\"]: "	
+			fprintf(stderr, "%s: xfsctl(XFS_IOC_FIEMAPFS) [\"%s\"]: "	
 				"%s\n", progname, file->name, strerror(errno));
 			free(fiemap);
 			exitcode = 1;
@@ -338,6 +338,10 @@
 
 	if (!init(argc, argv))
 		return 0;
+
+	if (dumpflag)
+		printf("%8s %8s %8s\n", "agno", "agbno", "len");	
+
 	for (agno = 0; agno < file->geom.agcount; agno++)  {
 		if (inaglist(agno))
 			scan_ag(agno);

----------------------------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

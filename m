Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 12:44:31 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8PJiOQ3008372
	for <xfs@oss.sgi.com>; Tue, 25 Sep 2007 12:44:27 -0700
Date: Tue, 25 Sep 2007 21:44:24 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] cleanup vnode useage in xfs_dm.c
Message-ID: <20070925194424.GA1714@lst.de>
References: <20070923114339.GB9585@lst.de> <46F88602.4040104@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F88602.4040104@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Vlad Apostolov <vapo@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Sep 25, 2007 at 01:52:34PM +1000, Vlad Apostolov wrote:
> It is looking good Christoph. I also built and tested it with XFS DMAPI QA
> all went fine. I think it is time to kill the 2.4 / 2.6 compat code as we
> are going to drop the XFS 2.4 tree soon. Do you have a patch for this
> or I could do it?

I have a patch in the queue, as usual :)

--

Kill 2.4 compat ifdefs in dmapi.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-09-25 10:38:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-09-25 10:41:09.000000000 +0200
@@ -54,62 +54,23 @@
 
 #define MAXNAMLEN MAXNAMELEN
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 #define MIN_DIO_SIZE(mp)		((mp)->m_sb.sb_sectsize)
 #define MAX_DIO_SIZE(mp)		(INT_MAX & ~(MIN_DIO_SIZE(mp) - 1))
-#define XFS_TO_HOST_DEVT(mp)		new_encode_dev(mp->m_ddev_targp->bt_dev)
-#define BREAK_LEASE(inode,flag)		break_lease(inode,flag)
-#else
-#define MIN_DIO_SIZE(mp)		((mp)->m_sb.sb_blocksize)
-#define MAX_DIO_SIZE(mp)		(INT_MAX & ~(MIN_DIO_SIZE(mp) - 1))
-#define XFS_TO_HOST_DEVT(mp)		((mp)->m_ddev_targp->bt_dev)
-#define BREAK_LEASE(inode,flag)		get_lease(inode,flag)
-#endif
 
 static void up_rw_sems(struct inode *ip, int flags)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	if (flags & DM_FLAGS_IALLOCSEM_WR)
 		up_write(&ip->i_alloc_sem);
 	if (flags & DM_FLAGS_IMUX)
 		mutex_unlock(&ip->i_mutex);
-#endif
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)) && \
-    (LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,22))
-	if (flags & DM_FLAGS_IMUX)
-		up(&ip->i_sem);
-	if (flags & DM_FLAGS_IALLOCSEM_RD)
-		up_read(&ip->i_alloc_sem);
-	else if (flags & DM_FLAGS_IALLOCSEM_WR)
-		up_write(&ip->i_alloc_sem);
-#endif
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,4,21)
-	if (flags & DM_FLAGS_IMUX)
-		up(&ip->i_sem);
-#endif
 }
 
 static void down_rw_sems(struct inode *ip, int flags)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	if (flags & DM_FLAGS_IMUX)
 		mutex_lock(&ip->i_mutex);
 	if (flags & DM_FLAGS_IALLOCSEM_WR)
 		down_write(&ip->i_alloc_sem);
-#endif
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)) && \
-    (LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,22))
-	if (flags & DM_FLAGS_IALLOCSEM_RD)
-		down_read(&ip->i_alloc_sem);
-	else if (flags & DM_FLAGS_IALLOCSEM_WR)
-		down_write(&ip->i_alloc_sem);
-	if (flags & DM_FLAGS_IMUX)
-		down(&ip->i_sem);
-#endif
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,4,21)
-	if (flags & DM_FLAGS_IMUX)
-		down(&ip->i_sem);
-#endif
 }
 
 
@@ -216,9 +177,6 @@ xfs_dm_send_data_event(
  *	Otherwise if the file is memory mapped, no READ event can be set.
  *
  */
-
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 STATIC int
 prohibited_mr_events(
 	struct address_space *mapping)
@@ -235,36 +193,6 @@ prohibited_mr_events(
 
 	return prohibited;
 }
-#else
-STATIC int
-prohibited_mr_events(
-	struct address_space *mapping)
-{
-	int prohibited = (1 << DM_EVENT_READ);
-	struct vm_area_struct *vma = NULL;
-
-	if (!VN_MAPPED(inode_to_vn(mapping->host)))
-		return 0;
-
-	spin_lock(&mapping->i_shared_lock);
-	for (vma = mapping->i_mmap_shared; vma; vma = vma->vm_next_share) {
-		if (vma->vm_flags & VM_WRITE) {
-			prohibited |= (1 << DM_EVENT_WRITE);
-			break;
-		}
-	}
-	for (vma = mapping->i_mmap; vma; vma = vma->vm_next_share) {
-		if (vma->vm_flags & VM_WRITE) {
-			prohibited |= (1 << DM_EVENT_WRITE);
-			break;
-		}
-	}
-	spin_unlock(&mapping->i_shared_lock);
-
-	return prohibited;
-}
-#endif
-
 
 #ifdef	DEBUG_RIGHTS
 STATIC int
@@ -415,7 +343,7 @@ xfs_dip_to_stat(
 		/*buf->dt_xfs_projid = be16_to_cpu(dic->di_projid);*/
 	}
 	buf->dt_ino = ino;
-	buf->dt_dev = XFS_TO_HOST_DEVT(mp);
+	buf->dt_dev = new_encode_dev(mp->m_ddev_targp->bt_dev);
 	buf->dt_mode = be16_to_cpu(dic->di_mode);
 	buf->dt_uid = be32_to_cpu(dic->di_uid);
 	buf->dt_gid = be32_to_cpu(dic->di_gid);
@@ -488,7 +416,7 @@ xfs_ip_to_stat(
 	buf->dt_uid = dic->di_uid;
 	buf->dt_gid = dic->di_gid;
 	buf->dt_size = XFS_ISIZE(ip);
-	buf->dt_dev = XFS_TO_HOST_DEVT(mp);
+	buf->dt_dev = new_encode_dev(mp->m_ddev_targp->bt_dev);
 	vn_atime_to_time_t(XFS_ITOV(ip), &buf->dt_atime);
 	buf->dt_mtime = dic->di_mtime.t_sec;
 	buf->dt_ctime = dic->di_ctime.t_sec;
@@ -2507,7 +2435,7 @@ xfs_dm_punch_hole(
 		return -EACCES;
 
 	/* Make sure there are no leases. */
-	error = BREAK_LEASE(inode, FMODE_WRITE);
+	error = break_lease(inode, FMODE_WRITE);
 	if (error)
 		return -EBUSY;
 

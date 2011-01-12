Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0C0iAqT124929 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 18:44:10 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4012D256228
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 16:36:47 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	IcVUQImqy9J3taY6 for <xfs@oss.sgi.com>;
	Tue, 11 Jan 2011 16:36:47 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	51913617-1927428
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 11:06:46 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PcohM-0000US-3E
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:36:24 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pcogu-0002G6-Le
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:35:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/12] xfs: Convert linux-2.6/ files to new logging interface
Date: Wed, 12 Jan 2011 11:35:44 +1100
Message-Id: <1294792553-8378-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1294792553-8378-1-git-send-email-david@fromorbit.com>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Convert the files in fs/xfs/linux-2.6/ to use the new xfs_<level>
logging format that replaces the old irix inherited cmn_err()
interfaces. While there, also convert naked printk calls to use the
relevant xfs logging function to standardise output format.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/kmem.c       |    9 ++-
 fs/xfs/linux-2.6/xfs_aops.c   |    6 +-
 fs/xfs/linux-2.6/xfs_buf.c    |   17 +++---
 fs/xfs/linux-2.6/xfs_super.c  |  127 ++++++++++++++++++----------------------
 fs/xfs/linux-2.6/xfs_sync.c   |    5 +-
 fs/xfs/linux-2.6/xfs_sysctl.c |    2 +-
 6 files changed, 76 insertions(+), 90 deletions(-)

diff --git a/fs/xfs/linux-2.6/kmem.c b/fs/xfs/linux-2.6/kmem.c
index 666c9db..f91ea9c 100644
--- a/fs/xfs/linux-2.6/kmem.c
+++ b/fs/xfs/linux-2.6/kmem.c
@@ -23,6 +23,7 @@
 #include <linux/backing-dev.h>
 #include "time.h"
 #include "kmem.h"
+#include "xfs_printk.h"
 
 /*
  * Greedy allocation.  May fail and may return vmalloced memory.
@@ -56,8 +57,8 @@ kmem_alloc(size_t size, unsigned int __nocast flags)
 		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
 			return ptr;
 		if (!(++retries % 100))
-			printk(KERN_ERR "XFS: possible memory allocation "
-					"deadlock in %s (mode:0x%x)\n",
+			xfs_err(NULL,
+		"possible memory allocation deadlock in %s (mode:0x%x)",
 					__func__, lflags);
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	} while (1);
@@ -112,8 +113,8 @@ kmem_zone_alloc(kmem_zone_t *zone, unsigned int __nocast flags)
 		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
 			return ptr;
 		if (!(++retries % 100))
-			printk(KERN_ERR "XFS: possible memory allocation "
-					"deadlock in %s (mode:0x%x)\n",
+			xfs_err(NULL,
+		"possible memory allocation deadlock in %s (mode:0x%x)",
 					__func__, lflags);
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	} while (1);
diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index ec7bbb5..8c5c872 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -854,7 +854,7 @@ xfs_aops_discard_page(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		goto out_invalidate;
 
-	xfs_fs_cmn_err(CE_ALERT, ip->i_mount,
+	xfs_alert(ip->i_mount,
 		"page discard on page %p, inode 0x%llx, offset %llu.",
 			page, ip->i_ino, offset);
 
@@ -872,7 +872,7 @@ xfs_aops_discard_page(
 		if (error) {
 			/* something screwed, just bail */
 			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-				xfs_fs_cmn_err(CE_ALERT, ip->i_mount,
+				xfs_alert(ip->i_mount,
 			"page discard unable to remove delalloc mapping.");
 			}
 			break;
@@ -1411,7 +1411,7 @@ xfs_vm_write_failed(
 		if (error) {
 			/* something screwed, just bail */
 			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-				xfs_fs_cmn_err(CE_ALERT, ip->i_mount,
+				xfs_alert(ip->i_mount,
 			"xfs_vm_write_failed: unable to clean up ino %lld",
 						ip->i_ino);
 			}
diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index ac1c7e8..3cc671c 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -401,9 +401,8 @@ _xfs_buf_lookup_pages(
 			 * handle buffer allocation failures we can't do much.
 			 */
 			if (!(++retries % 100))
-				printk(KERN_ERR
-					"XFS: possible memory allocation "
-					"deadlock in %s (mode:0x%x)\n",
+				xfs_err(NULL,
+		"possible memory allocation deadlock in %s (mode:0x%x)",
 					__func__, gfp_mask);
 
 			XFS_STATS_INC(xb_page_retries);
@@ -615,8 +614,8 @@ xfs_buf_get(
 	if (!(bp->b_flags & XBF_MAPPED)) {
 		error = _xfs_buf_map_pages(bp, flags);
 		if (unlikely(error)) {
-			printk(KERN_WARNING "%s: failed to map pages\n",
-					__func__);
+			xfs_warn(target->bt_mount,
+				"%s: failed to map pages\n", __func__);
 			goto no_buffer;
 		}
 	}
@@ -850,8 +849,8 @@ xfs_buf_get_uncached(
 
 	error = _xfs_buf_map_pages(bp, XBF_MAPPED);
 	if (unlikely(error)) {
-		printk(KERN_WARNING "%s: failed to map pages\n",
-				__func__);
+		xfs_warn(target->bt_mount,
+			"%s: failed to map pages\n", __func__);
 		goto fail_free_mem;
 	}
 
@@ -1617,8 +1616,8 @@ xfs_setsize_buftarg_flags(
 	btp->bt_smask = sectorsize - 1;
 
 	if (set_blocksize(btp->bt_bdev, sectorsize)) {
-		printk(KERN_WARNING
-			"XFS: Cannot set_blocksize to %u on device %s\n",
+		xfs_warn(btp->bt_mount,
+			"Cannot set_blocksize to %u on device %s\n",
 			sectorsize, XFS_BUFTARG_NAME(btp));
 		return EINVAL;
 	}
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index af32f37..78248b7 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -173,6 +173,15 @@ xfs_parseargs(
 	__uint8_t		iosizelog = 0;
 
 	/*
+	 * set up the mount name first so all the errors will refer to the
+	 * correct device.
+	 */
+	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
+	if (!mp->m_fsname)
+		return ENOMEM;
+	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
+
+	/*
 	 * Copy binary VFS mount flags we are interested in.
 	 */
 	if (sb->s_flags & MS_RDONLY)
@@ -207,24 +216,21 @@ xfs_parseargs(
 
 		if (!strcmp(this_char, MNTOPT_LOGBUFS)) {
 			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
+				xfs_warn(mp, "%s option requires an argument",
 					this_char);
 				return EINVAL;
 			}
 			mp->m_logbufs = simple_strtoul(value, &eov, 10);
 		} else if (!strcmp(this_char, MNTOPT_LOGBSIZE)) {
 			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
+				xfs_warn(mp, "%s option requires an argument",
 					this_char);
 				return EINVAL;
 			}
 			mp->m_logbsize = suffix_strtoul(value, &eov, 10);
 		} else if (!strcmp(this_char, MNTOPT_LOGDEV)) {
 			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
+				xfs_warn(mp, "%s option requires an argument",
 					this_char);
 				return EINVAL;
 			}
@@ -232,14 +238,12 @@ xfs_parseargs(
 			if (!mp->m_logname)
 				return ENOMEM;
 		} else if (!strcmp(this_char, MNTOPT_MTPT)) {
-			cmn_err(CE_WARN,
-				"XFS: %s option not allowed on this system",
+			xfs_warn(mp, "%s option not allowed on this system",
 				this_char);
 			return EINVAL;
 		} else if (!strcmp(this_char, MNTOPT_RTDEV)) {
 			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
+				xfs_warn(mp, "%s option requires an argument",
 					this_char);
 				return EINVAL;
 			}
@@ -248,8 +252,7 @@ xfs_parseargs(
 				return ENOMEM;
 		} else if (!strcmp(this_char, MNTOPT_BIOSIZE)) {
 			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
+				xfs_warn(mp, "%s option requires an argument",
 					this_char);
 				return EINVAL;
 			}
@@ -257,8 +260,7 @@ xfs_parseargs(
 			iosizelog = ffs(iosize) - 1;
 		} else if (!strcmp(this_char, MNTOPT_ALLOCSIZE)) {
 			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
+				xfs_warn(mp, "%s option requires an argument",
 					this_char);
 				return EINVAL;
 			}
@@ -280,16 +282,14 @@ xfs_parseargs(
 			mp->m_flags |= XFS_MOUNT_SWALLOC;
 		} else if (!strcmp(this_char, MNTOPT_SUNIT)) {
 			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
+				xfs_warn(mp, "%s option requires an argument",
 					this_char);
 				return EINVAL;
 			}
 			dsunit = simple_strtoul(value, &eov, 10);
 		} else if (!strcmp(this_char, MNTOPT_SWIDTH)) {
 			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
+				xfs_warn(mp, "%s option requires an argument",
 					this_char);
 				return EINVAL;
 			}
@@ -297,8 +297,7 @@ xfs_parseargs(
 		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
 			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
 #if !XFS_BIG_INUMS
-			cmn_err(CE_WARN,
-				"XFS: %s option not allowed on this system",
+			xfs_warn(mp, "%s option not allowed on this system",
 				this_char);
 			return EINVAL;
 #endif
@@ -356,20 +355,19 @@ xfs_parseargs(
 		} else if (!strcmp(this_char, MNTOPT_NODELAYLOG)) {
 			mp->m_flags &= ~XFS_MOUNT_DELAYLOG;
 		} else if (!strcmp(this_char, "ihashsize")) {
-			cmn_err(CE_WARN,
-	"XFS: ihashsize no longer used, option is deprecated.");
+			xfs_warn(mp,
+	"ihashsize no longer used, option is deprecated.");
 		} else if (!strcmp(this_char, "osyncisdsync")) {
-			cmn_err(CE_WARN,
-	"XFS: osyncisdsync has no effect, option is deprecated.");
+			xfs_warn(mp,
+	"osyncisdsync has no effect, option is deprecated.");
 		} else if (!strcmp(this_char, "osyncisosync")) {
-			cmn_err(CE_WARN,
-	"XFS: osyncisosync has no effect, option is deprecated.");
+			xfs_warn(mp,
+	"osyncisosync has no effect, option is deprecated.");
 		} else if (!strcmp(this_char, "irixsgid")) {
-			cmn_err(CE_WARN,
-	"XFS: irixsgid is now a sysctl(2) variable, option is deprecated.");
+			xfs_warn(mp,
+	"irixsgid is now a sysctl(2) variable, option is deprecated.");
 		} else {
-			cmn_err(CE_WARN,
-				"XFS: unknown mount option [%s].", this_char);
+			xfs_warn(mp, "unknown mount option [%s].", this_char);
 			return EINVAL;
 		}
 	}
@@ -379,40 +377,37 @@ xfs_parseargs(
 	 */
 	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
 	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
-		cmn_err(CE_WARN, "XFS: no-recovery mounts must be read-only.");
+		xfs_warn(mp, "no-recovery mounts must be read-only.");
 		return EINVAL;
 	}
 
 	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (dsunit || dswidth)) {
-		cmn_err(CE_WARN,
-	"XFS: sunit and swidth options incompatible with the noalign option");
+		xfs_warn(mp,
+	"sunit and swidth options incompatible with the noalign option");
 		return EINVAL;
 	}
 
 #ifndef CONFIG_XFS_QUOTA
 	if (XFS_IS_QUOTA_RUNNING(mp)) {
-		cmn_err(CE_WARN,
-			"XFS: quota support not available in this kernel.");
+		xfs_warn(mp, "quota support not available in this kernel.");
 		return EINVAL;
 	}
 #endif
 
 	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
 	    (mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE))) {
-		cmn_err(CE_WARN,
-			"XFS: cannot mount with both project and group quota");
+		xfs_warn(mp, "cannot mount with both project and group quota");
 		return EINVAL;
 	}
 
 	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
-		cmn_err(CE_WARN,
-			"XFS: sunit and swidth must be specified together");
+		xfs_warn(mp, "sunit and swidth must be specified together");
 		return EINVAL;
 	}
 
 	if (dsunit && (dswidth % dsunit != 0)) {
-		cmn_err(CE_WARN,
-	"XFS: stripe width (%d) must be a multiple of the stripe unit (%d)",
+		xfs_warn(mp,
+	"stripe width (%d) must be a multiple of the stripe unit (%d)",
 			dswidth, dsunit);
 		return EINVAL;
 	}
@@ -438,8 +433,7 @@ done:
 	    mp->m_logbufs != 0 &&
 	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
 	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
-		cmn_err(CE_WARN,
-			"XFS: invalid logbufs value: %d [not %d-%d]",
+		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
 			mp->m_logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
 		return XFS_ERROR(EINVAL);
 	}
@@ -448,22 +442,16 @@ done:
 	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
 	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
 	     !is_power_of_2(mp->m_logbsize))) {
-		cmn_err(CE_WARN,
-	"XFS: invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
+		xfs_warn(mp,
+			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
 			mp->m_logbsize);
 		return XFS_ERROR(EINVAL);
 	}
 
-	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
-	if (!mp->m_fsname)
-		return ENOMEM;
-	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
-
 	if (iosizelog) {
 		if (iosizelog > XFS_MAX_IO_LOG ||
 		    iosizelog < XFS_MIN_IO_LOG) {
-			cmn_err(CE_WARN,
-		"XFS: invalid log iosize: %d [not %d-%d]",
+			xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
 				iosizelog, XFS_MIN_IO_LOG,
 				XFS_MAX_IO_LOG);
 			return XFS_ERROR(EINVAL);
@@ -609,7 +597,7 @@ xfs_blkdev_get(
 	*bdevp = open_bdev_exclusive(name, FMODE_READ|FMODE_WRITE, mp);
 	if (IS_ERR(*bdevp)) {
 		error = PTR_ERR(*bdevp);
-		printk("XFS: Invalid device [%s], error=%d\n", name, error);
+		xfs_warn(mp, "Invalid device [%s], error=%d\n", name, error);
 	}
 
 	return -error;
@@ -663,23 +651,23 @@ xfs_mountfs_check_barriers(xfs_mount_t *mp)
 	int error;
 
 	if (mp->m_logdev_targp != mp->m_ddev_targp) {
-		xfs_fs_cmn_err(CE_NOTE, mp,
+		xfs_notice(mp,
 		  "Disabling barriers, not supported with external log device");
 		mp->m_flags &= ~XFS_MOUNT_BARRIER;
 		return;
 	}
 
 	if (xfs_readonly_buftarg(mp->m_ddev_targp)) {
-		xfs_fs_cmn_err(CE_NOTE, mp,
-		  "Disabling barriers, underlying device is readonly");
+		xfs_notice(mp,
+			"Disabling barriers, underlying device is readonly");
 		mp->m_flags &= ~XFS_MOUNT_BARRIER;
 		return;
 	}
 
 	error = xfs_barrier_test(mp);
 	if (error) {
-		xfs_fs_cmn_err(CE_NOTE, mp,
-		  "Disabling barriers, trial barrier write failed");
+		xfs_notice(mp,
+			"Disabling barriers, trial barrier write failed");
 		mp->m_flags &= ~XFS_MOUNT_BARRIER;
 		return;
 	}
@@ -742,8 +730,8 @@ xfs_open_devices(
 			goto out_close_logdev;
 
 		if (rtdev == ddev || rtdev == logdev) {
-			cmn_err(CE_WARN,
-	"XFS: Cannot mount filesystem with identical rtdev and ddev/logdev.");
+			xfs_warn(mp,
+	"Cannot mount filesystem with identical rtdev and ddev/logdev.");
 			error = EINVAL;
 			goto out_close_rtdev;
 		}
@@ -1344,8 +1332,8 @@ xfs_fs_remount(
 			 * options that we can't actually change.
 			 */
 #if 0
-			printk(KERN_INFO
-	"XFS: mount option \"%s\" not supported for remount\n", p);
+			xfs_info(mp,
+		"mount option \"%s\" not supported for remount\n", p);
 			return -EINVAL;
 #else
 			break;
@@ -1366,8 +1354,7 @@ xfs_fs_remount(
 		if (mp->m_update_flags) {
 			error = xfs_mount_log_sb(mp, mp->m_update_flags);
 			if (error) {
-				cmn_err(CE_WARN,
-					"XFS: failed to write sb changes");
+				xfs_warn(mp, "failed to write sb changes");
 				return error;
 			}
 			mp->m_update_flags = 0;
@@ -1451,15 +1438,15 @@ xfs_finish_flags(
 			mp->m_logbsize = mp->m_sb.sb_logsunit;
 		} else if (mp->m_logbsize > 0 &&
 			   mp->m_logbsize < mp->m_sb.sb_logsunit) {
-			cmn_err(CE_WARN,
-	"XFS: logbuf size must be greater than or equal to log stripe size");
+			xfs_warn(mp,
+		"logbuf size must be greater than or equal to log stripe size");
 			return XFS_ERROR(EINVAL);
 		}
 	} else {
 		/* Fail a mount if the logbuf is larger than 32K */
 		if (mp->m_logbsize > XLOG_BIG_RECORD_BSIZE) {
-			cmn_err(CE_WARN,
-	"XFS: logbuf size for version 1 logs must be 16K or 32K");
+			xfs_warn(mp,
+		"logbuf size for version 1 logs must be 16K or 32K");
 			return XFS_ERROR(EINVAL);
 		}
 	}
@@ -1476,8 +1463,8 @@ xfs_finish_flags(
 	 * prohibit r/w mounts of read-only filesystems
 	 */
 	if ((mp->m_sb.sb_flags & XFS_SBF_READONLY) && !ronly) {
-		cmn_err(CE_WARN,
-	"XFS: cannot mount a read-only filesystem as read-write");
+		xfs_warn(mp,
+			"cannot mount a read-only filesystem as read-write");
 		return XFS_ERROR(EROFS);
 	}
 
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index e22f005..6c10f1d 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -425,8 +425,7 @@ xfs_quiesce_attr(
 	/* Push the superblock and write an unmount record */
 	error = xfs_log_sbcount(mp, 1);
 	if (error)
-		xfs_fs_cmn_err(CE_WARN, mp,
-				"xfs_attr_quiesce: failed to log sb changes. "
+		xfs_warn(mp, "xfs_attr_quiesce: failed to log sb changes. "
 				"Frozen image may not be consistent.");
 	xfs_log_unmount_write(mp);
 	xfs_unmountfs_writesb(mp);
@@ -806,7 +805,7 @@ xfs_reclaim_inode(
 	 * pass on the error.
 	 */
 	if (error && error != EAGAIN && !XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-		xfs_fs_cmn_err(CE_WARN, ip->i_mount,
+		xfs_warn(ip->i_mount,
 			"inode 0x%llx background reclaim flush failed with %d",
 			(long long)ip->i_ino, error);
 	}
diff --git a/fs/xfs/linux-2.6/xfs_sysctl.c b/fs/xfs/linux-2.6/xfs_sysctl.c
index ee3cee0..ee2d2ad 100644
--- a/fs/xfs/linux-2.6/xfs_sysctl.c
+++ b/fs/xfs/linux-2.6/xfs_sysctl.c
@@ -37,7 +37,7 @@ xfs_stats_clear_proc_handler(
 	ret = proc_dointvec_minmax(ctl, write, buffer, lenp, ppos);
 
 	if (!ret && write && *valp) {
-		printk("XFS Clearing xfsstats\n");
+		xfs_notice(NULL, "Clearing xfsstats");
 		for_each_possible_cpu(c) {
 			preempt_disable();
 			/* save vn_active, it's a universal truth! */
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

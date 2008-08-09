Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 09 Aug 2008 12:51:20 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m79JoqjS012360
	for <xfs@oss.sgi.com>; Sat, 9 Aug 2008 12:50:53 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49F0B1BC22DA
	for <xfs@oss.sgi.com>; Sat,  9 Aug 2008 12:52:07 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id aTp9JkrBHLxDRl2u for <xfs@oss.sgi.com>; Sat, 09 Aug 2008 12:52:07 -0700 (PDT)
Date: Sat, 9 Aug 2008 21:51:59 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] stop rejecting options in remount
Message-ID: <20080809195159.GA8562@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: jasper@amiton.co.nz

Thanks to some not so nice code in mount(8) we can't blindly reject moun
options we don't support to be changed in remount.  See the comment in
the code for more details.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-08-09 16:34:33.000000000 -0300
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-08-09 16:36:55.000000000 -0300
@@ -1349,9 +1349,28 @@ xfs_fs_remount(
 			mp->m_flags &= ~XFS_MOUNT_BARRIER;
 			break;
 		default:
+			/*
+			 * Logically we would return an error here to prevent
+			 * users from believing they might have changed
+			 * mount options using remount which can't be changed.
+			 *
+			 * But unfortunately mount(8) adds all options from
+			 * mtab and fstab to the mount arguments in some
+			 * cases so we can't blindly reject options.
+			 *
+			 * The workaround for that behaviour will be to
+			 * check for each specified option whether it actually
+			 * is a change compared to the status quo and if yes
+			 * silently ignore it or otherwise reject the remount
+			 * and tell the user about the reason.
+			 */
+#if 0
 			printk(KERN_INFO
 	"XFS: mount option \"%s\" not supported for remount\n", p);
 			return -EINVAL;
+#else
+			return 0;
+#endif
 		}
 	}
 

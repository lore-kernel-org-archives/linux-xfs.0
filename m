Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Apr 2007 20:15:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3U3F4fB007735
	for <xfs@oss.sgi.com>; Sun, 29 Apr 2007 20:15:07 -0700
Date: Mon, 30 Apr 2007 13:14:43 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] Add preallocation beyond EOF to fallocate
Message-ID: <20070430031443.GP32602149@melbourne.sgi.com>
References: <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070430004702.GM32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430004702.GM32602149@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

Add new mode to ->fallocate() to allow allocation to occur
beyond the current EOF without changing the file size. Implement
in XFS ->fallocate() vector.

Signed-Off-By: Dave Chinner <dgc@sgi.com>

---
 fs/xfs/linux-2.6/xfs_iops.c |    8 +++++---
 include/linux/fs.h          |    1 +
 2 files changed, 6 insertions(+), 3 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-04-30 11:02:16.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_iops.c	2007-04-30 11:09:48.233375382 +1000
@@ -833,11 +833,13 @@ xfs_vn_fallocate(
 						VNODE_POSITION_XFS);
 
 	switch (mode) {
-	case FA_ALLOCATE: /* changes file size */
-		error = xfs_change_file_space(bdp, XFS_IOC_RESVSP,
-						&bf, 0, NULL, 0);
+	case FA_ALLOCATE:	 /* changes file size */
 		if (offset + len > i_size_read(inode))
 			do_setattr = offset + len;
+		/* FALL THROUGH */
+	case FA_PREALLOCATE:	/* no filesize change */
+		error = xfs_change_file_space(bdp, XFS_IOC_RESVSP,
+						&bf, 0, NULL, 0);
 		break;
 	case FA_DEALLOCATE:
 		/* XXX: changes file size?  this just punches a hole */
Index: 2.6.x-xfs-new/include/linux/fs.h
===================================================================
--- 2.6.x-xfs-new.orig/include/linux/fs.h	2007-04-27 18:48:01.000000000 +1000
+++ 2.6.x-xfs-new/include/linux/fs.h	2007-04-30 11:08:05.790903661 +1000
@@ -269,6 +269,7 @@ extern int dir_notify_enable;
  */
 #define FA_ALLOCATE	0x1
 #define FA_DEALLOCATE	0x2
+#define FA_PREALLOCATE	0x3
 
 #ifdef __KERNEL__
 

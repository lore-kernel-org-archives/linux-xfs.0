Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Aug 2007 04:46:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l79Bjtbm007742
	for <xfs@oss.sgi.com>; Thu, 9 Aug 2007 04:45:57 -0700
Date: Thu, 9 Aug 2007 21:45:48 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 4 of 4] Restore ihashsize mount option as deprecated
Message-ID: <20070809114548.GG12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

The ihashsize option should remain so that filesystems with
this set don't fail to mount. Ignore the mount option value
and issue a deprecation warning to syslog.

Update the ihashsize mount option documentation to indicate this
behaviour.  Update the ikeep/noikeep mount option documentation
while we are there.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 Documentation/filesystems/xfs.txt |   14 ++++++--------
 fs/xfs/xfs_vfsops.c               |    3 +++
 2 files changed, 9 insertions(+), 8 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2007-08-09 13:03:53.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2007-08-09 18:27:39.740905512 +1000
@@ -1883,6 +1883,9 @@ xfs_parseargs(
 			args->flags &= ~XFSMNT_ATTR2;
 		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
 			args->flags2 |= XFSMNT2_FILESTREAMS;
+		} else if (!strcmp(this_char, "ihashsize")) {
+			cmn_err(CE_WARN,
+	"XFS: ihashsize no longer used, option is deprecated.");
 		} else if (!strcmp(this_char, "osyncisdsync")) {
 			/* no-op, this is now the default */
 			cmn_err(CE_WARN,
Index: 2.6.x-xfs-new/Documentation/filesystems/xfs.txt
===================================================================
--- 2.6.x-xfs-new.orig/Documentation/filesystems/xfs.txt	2007-08-09 13:00:11.000000000 +1000
+++ 2.6.x-xfs-new/Documentation/filesystems/xfs.txt	2007-08-09 18:35:57.300771335 +1000
@@ -52,16 +52,14 @@ When mounting an XFS filesystem, the fol
 	and also gets the setgid bit set if it is a directory itself.
 
   ihashsize=value
-	Sets the number of hash buckets available for hashing the
-	in-memory inodes of the specified mount point.  If a value
-	of zero is used, the value selected by the default algorithm
-	will be displayed in /proc/mounts.
+	In memory inode hashes have been removed, so this option has
+	no function as of August 2007. Option is deprecated.
 
   ikeep/noikeep
-	When inode clusters are emptied of inodes, keep them around
-	on the disk (ikeep) - this is the traditional XFS behaviour
-	and is still the default for now.  Using the noikeep option,
-	inode clusters are returned to the free space pool.
+	When ikeep is specified, XFS does not delete empty inode clusters
+	and keeps them around on disk. ikeep is the traditional XFS
+	behaviour. When noikeep is specified, empty inode clusters
+	are returned to the free space pool. The default is noikeep.
 
   inode64
 	Indicates that XFS is allowed to create inodes at any location

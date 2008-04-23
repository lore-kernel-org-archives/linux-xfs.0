Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Apr 2008 22:29:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3N5Sqqq023572
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 22:28:57 -0700
Message-ID: <480EC93D.9090103@sgi.com>
Date: Wed, 23 Apr 2008 15:29:33 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: REVIEW: 980021 - fix up noattr2 mount option
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Hi there,

Mounting noattr2 in xfs fails to achieve anything AFAICT -
and it certainly doesn't do anything useful.

The twisty mounting path goes something like this:

============================
xfs_fs_get_sb
-> xfs_fs_fill_super
     -> xfs_parseargs - sets args->flags: MNTOPT_ATTR2, MNTOPT_NOATTR2
     -> xfs_mount(...args...)

xfs_mount
-> xfs_start_flags - XFSMNT_ATTR2 -> XFS_MOUNT_ATTR2,
                      XFSMNT_NOATTR2 -> XFS_MOUNT_NOATTR2
-> xfs_readsb
-> xfs_finish_flags - checks sb for attr2 and if not noattr2,
                       then sets XFS_MOUNT_ATTR2
...
-> xfs_mountfs - does the features2 correction which can
                  set the sb with attr2 if not noattr2 mnt,
                  for noattr2 and sb with attr2, it removes
                  the attr2 from the sb and updates it

============================

I tried with just using XFS_MNTOPT_NOATTR2 and not XFS_MOUNT_NOATTR2
but then seemed to need it in the features2 correction code
where I could no longer tell that not having XFS_MOUNT_ATTR2 meant
that noattr2 had been used - I needed to know explicitly.

The qa test checks that noattr2 works and does so when
attr2 is the last features2 bit or there is more left (i.e. lazy sb)
i.e. I want to know if we are still using features2/morebits or
not.

xfstests patch:
  b/xfstests/187     |  121 +++++++++++++++++++++++++++++++++++++++++++++++++++++
  b/xfstests/187.out |   39 +++++++++++++++++
  b/xfstests/group   |    1
  3 files changed, 161 insertions(+)

kernel patch:
  2.6.x-xfs-quilt/fs/xfs/linux-2.6/xfs_super.c |    1 +
  2.6.x-xfs-quilt/fs/xfs/xfs_clnt.h            |    1 +
  2.6.x-xfs-quilt/fs/xfs/xfs_mount.c           |   12 +++++++++++-
  2.6.x-xfs-quilt/fs/xfs/xfs_mount.h           |    1 +
  2.6.x-xfs-quilt/fs/xfs/xfs_sb.h              |    7 +++++++
  2.6.x-xfs-quilt/fs/xfs/xfs_vfsops.c          |    9 ++++++++-
  6 files changed, 29 insertions(+), 2 deletions(-)


--Tim


===========================================================================
Index: xfstests/187
===========================================================================

--- a/xfstests/187	2006-06-17 00:58:24.000000000 +1000
+++ b/xfstests/187	2008-04-23 16:20:01.271902400 +1000
@@ -0,0 +1,121 @@
+#! /bin/sh
+# FS QA Test No. 187
+#
+# To test out the noattr2 flag which is broken in pv#980021
+# Given an existing attr2 filesystem, we should be able to mount
+# as noattr2 and go back to an attr1 filesystem.
+#
+# Test the case where there are no more features2 bits on and
+# so the morebitsbit should be off.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+#-----------------------------------------------------------------------
+#
+# creator
+owner=tes@emu.melbourne.sgi.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+_filter_version()
+{
+	tee -a $seq.full | tr ',' '\n' | egrep 'ATTR|MORE|LAZY'
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_require_scratch
+_supported_fs xfs
+_supported_os Linux
+rm -f $seq.full
+
+# lazysb and attr2 are in features2 and will require morebitsbit on
+# So test with lazysb and without it to see if the morebitsbit is
+# okay etc....
+# Reset the options so that we can control what is going on here
+export MKFS_OPTIONS=""
+export MOUNT_OPTIONS=""
+
+# Make sure that when we think we are testing with morebits off
+# that we really are.
+# Trying to future-proof in case mkfs defaults change.
+_scratch_mkfs -i attr=1 >/dev/null 2>&1
+$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 >$tmp.db
+if grep -i morebits $tmp.db
+then
+	echo ""
+	echo "Need to update test $seq so that initial subtests do not use features2"
+	echo ""
+	exit
+fi
+
+echo ""
+echo "*** 1. test attr2 mkfs and then noattr2 mount ***"
+echo ""
+echo "attr2 fs"
+echo ""
+_scratch_mkfs -i attr=2 -l lazy-count=0 >/dev/null 2>&1
+$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 | _filter_version
+echo ""
+echo "noattr2 fs"
+echo ""
+_scratch_mount -o noattr2
+$UMOUNT_PROG $SCRATCH_MNT
+$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 | _filter_version
+
+# adding an EA will ensure the ATTR1 flag is turned on
+echo ""
+echo "*** 2. test attr2 mkfs and then noattr2 mount with 1 EA ***"
+echo ""
+echo "attr2 fs"
+echo ""
+_scratch_mkfs -i attr=2 -l lazy-count=0 >/dev/null 2>&1
+$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 | _filter_version
+echo ""
+echo "noattr2 fs"
+echo ""
+_scratch_mount -o noattr2
+cd $SCRATCH_MNT
+touch testfile
+setfattr -n user.test -v 0xbabe testfile
+getfattr testfile
+cd $here
+$UMOUNT_PROG $SCRATCH_MNT
+$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 | _filter_version
+
+echo ""
+echo "*** 3. test noattr2 mount and lazy sb ***"
+echo ""
+echo ""
+echo "attr2 fs"
+echo ""
+_scratch_mkfs -i attr=2 -l lazy-count=1 >/dev/null 2>&1
+$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 | _filter_version
+echo ""
+echo "noattr2 fs"
+echo ""
+_scratch_mount -o noattr2
+cd $SCRATCH_MNT
+touch testfile
+cd $here
+$UMOUNT_PROG $SCRATCH_MNT
+$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 | _filter_version
+
+# success, all done
+status=0
+exit

===========================================================================
Index: xfstests/187.out
===========================================================================

--- a/xfstests/187.out	2006-06-17 00:58:24.000000000 +1000
+++ b/xfstests/187.out	2008-04-23 16:20:43.087902450 +1000
@@ -0,0 +1,39 @@
+QA output created by 187
+
+*** 1. test attr2 mkfs and then noattr2 mount ***
+
+attr2 fs
+
+MOREBITS
+ATTR2
+
+noattr2 fs
+
+
+*** 2. test attr2 mkfs and then noattr2 mount with 1 EA ***
+
+attr2 fs
+
+MOREBITS
+ATTR2
+
+noattr2 fs
+
+# file: testfile
+user.test
+
+ATTR
+
+*** 3. test noattr2 mount and lazy sb ***
+
+
+attr2 fs
+
+MOREBITS
+ATTR2
+LAZYSBCOUNT
+
+noattr2 fs
+
+MOREBITS
+LAZYSBCOUNT

===========================================================================
Index: xfstests/group
===========================================================================

--- a/xfstests/group	2008-04-23 14:43:04.000000000 +1000
+++ b/xfstests/group	2008-04-22 16:35:47.844386650 +1000
@@ -274,3 +274,4 @@ filestreams	dgc@sgi.com
  184 metadata auto
  185 dmapi auto
  186 attr auto
+187 attr auto



Index: 2.6.x-xfs-quilt/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- 2.6.x-xfs-quilt.orig/fs/xfs/linux-2.6/xfs_super.c	2008-04-22 17:05:28.234900761 +1000
+++ 2.6.x-xfs-quilt/fs/xfs/linux-2.6/xfs_super.c	2008-04-22 17:05:39.477451936 +1000
@@ -314,6 +314,7 @@ xfs_parseargs(
  			args->flags |= XFSMNT_ATTR2;
  		} else if (!strcmp(this_char, MNTOPT_NOATTR2)) {
  			args->flags &= ~XFSMNT_ATTR2;
+			args->flags |= XFSMNT_NOATTR2;
  		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
  			args->flags2 |= XFSMNT2_FILESTREAMS;
  		} else if (!strcmp(this_char, MNTOPT_NOQUOTA)) {
Index: 2.6.x-xfs-quilt/fs/xfs/xfs_clnt.h
===================================================================
--- 2.6.x-xfs-quilt.orig/fs/xfs/xfs_clnt.h	2008-04-22 17:05:28.234900761 +1000
+++ 2.6.x-xfs-quilt/fs/xfs/xfs_clnt.h	2008-04-22 17:05:39.477451936 +1000
@@ -78,6 +78,7 @@ struct xfs_mount_args {
  #define XFSMNT_IOSIZE		0x00002000	/* optimize for I/O size */
  #define XFSMNT_OSYNCISOSYNC	0x00004000	/* o_sync is REALLY o_sync */
  						/* (osyncisdsync is default) */
+#define XFSMNT_NOATTR2		0x00008000	/* turn off ATTR2 EA format */
  #define XFSMNT_32BITINODES	0x00200000	/* restrict inodes to 32
  						 * bits of address space */
  #define XFSMNT_GQUOTA		0x00400000	/* group quota accounting */
Index: 2.6.x-xfs-quilt/fs/xfs/xfs_sb.h
===================================================================
--- 2.6.x-xfs-quilt.orig/fs/xfs/xfs_sb.h	2008-04-22 17:05:28.238900245 +1000
+++ 2.6.x-xfs-quilt/fs/xfs/xfs_sb.h	2008-04-22 17:05:39.477451936 +1000
@@ -473,6 +473,13 @@ static inline void xfs_sb_version_addatt
  		((sbp)->sb_features2 | XFS_SB_VERSION2_ATTR2BIT)));
  }

+static inline void xfs_sb_version_removeattr2(xfs_sb_t *sbp)
+{
+	sbp->sb_features2 &= ~XFS_SB_VERSION2_ATTR2BIT;
+	if (!sbp->sb_features2)
+		sbp->sb_versionnum &= ~XFS_SB_VERSION_MOREBITSBIT;
+}
+
  /*
   * end of superblock version macros
   */
Index: 2.6.x-xfs-quilt/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-quilt.orig/fs/xfs/xfs_vfsops.c	2008-04-22 17:05:28.238900245 +1000
+++ 2.6.x-xfs-quilt/fs/xfs/xfs_vfsops.c	2008-04-23 14:05:14.046729504 +1000
@@ -283,6 +283,8 @@ xfs_start_flags(
  		mp->m_flags |= XFS_MOUNT_DIRSYNC;
  	if (ap->flags & XFSMNT_ATTR2)
  		mp->m_flags |= XFS_MOUNT_ATTR2;
+	if (ap->flags & XFSMNT_NOATTR2)
+		mp->m_flags |= XFS_MOUNT_NOATTR2;

  	if (ap->flags2 & XFSMNT2_COMPAT_IOSIZE)
  		mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
@@ -345,7 +347,12 @@ xfs_finish_flags(
  		}
  	}

-	if (xfs_sb_version_hasattr2(&mp->m_sb))
+	/*
+	 * mkfs'ed attr2 will turn on attr2 mount unless explicitly
+	 * told by noattr2 to turn it off
+	 */
+	if (xfs_sb_version_hasattr2(&mp->m_sb) &&
+	    !(ap->flags & XFSMNT_NOATTR2))
  		mp->m_flags |= XFS_MOUNT_ATTR2;

  	/*
Index: 2.6.x-xfs-quilt/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-quilt.orig/fs/xfs/xfs_mount.c	2008-04-22 17:05:18.000000000 +1000
+++ 2.6.x-xfs-quilt/fs/xfs/xfs_mount.c	2008-04-23 13:57:00.398272074 +1000
@@ -994,9 +994,19 @@ xfs_mountfs(
  		 * Re-check for ATTR2 in case it was found in bad_features2
  		 * slot.
  		 */
-		if (xfs_sb_version_hasattr2(&mp->m_sb))
+		if (xfs_sb_version_hasattr2(&mp->m_sb) &&
+		   !(mp->m_flags & XFS_MOUNT_NOATTR2))
  			mp->m_flags |= XFS_MOUNT_ATTR2;
+	}

+	if (xfs_sb_version_hasattr2(&mp->m_sb) &&
+	   (mp->m_flags & XFS_MOUNT_NOATTR2)) {
+		xfs_sb_version_removeattr2(&mp->m_sb);
+		update_flags |= XFS_SB_FEATURES2;
+
+		/* update sb_versionnum for the clearing of the morebits */
+		if (!sbp->sb_features2)
+			update_flags |= XFS_SB_VERSIONNUM;
  	}

  	/*
Index: 2.6.x-xfs-quilt/fs/xfs/xfs_mount.h
===================================================================
--- 2.6.x-xfs-quilt.orig/fs/xfs/xfs_mount.h	2008-04-23 11:12:45.000000000 +1000
+++ 2.6.x-xfs-quilt/fs/xfs/xfs_mount.h	2008-04-23 13:58:13.480864956 +1000
@@ -377,6 +377,7 @@ typedef struct xfs_mount {
  						   counters */
  #define XFS_MOUNT_FILESTREAMS	(1ULL << 24)	/* enable the filestreams
  						   allocator */
+#define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */


  /*

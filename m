Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 18:48:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5T1mPtL027484
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 18:48:27 -0700
Date: Fri, 29 Jun 2007 11:48:18 +1000
From: David Chinner <dgc@sgi.com>
Subject: Review: Concurrent Filestreams V4
Message-ID: <20070629014818.GI31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Concurrent Multi-File Data Streams

In media spaces, video is often stored in a frame-per-file format.
When dealing with uncompressed realtime HD video streams in this format,
it is crucial that files do not get fragmented and that multiple files
a placed contiguously on disk.

When multiple streams are being ingested and played out at the same
time, it is critical that the filesystem does not cross the streams
and interleave them together as this creates seek and readahead
cache miss latency and prevents both ingest and playout from meeting
frame rate targets.

This patches creates a "stream of files" concept into the allocator
to place all the data from a single stream contiguously on disk so
that RAID array readahead can be used effectively. Each additional
stream gets placed in different allocation groups within the
filesystem, thereby ensuring that we don't cross any streams. When
an AG fills up, we select a new AG for the stream that is not in
use.

The core of the functionality is the stream tracking - each inode
that we create in a directory needs to be associated with the
directories' stream. Hence every time we create a file, we look up
the directories' stream object and associate the new file with that
object.

Once we have a stream object for a file, we use the AG that the
stream object point to for allocations. If we can't allocate in that
AG (e.g. it is full) we move the entire stream to another AG. Other
inodes in the same stream are moved to the new AG on their next
allocation (i.e. lazy update).

Stream objects are kept in a cache and hold a reference on the
inode. Hence the inode cannot be reclaimed while there is an
outstanding stream reference. This means that on unlink we need to
remove the stream association and we also need to flush all the
associations on certain events that want to reclaim all unreferenced
inodes (e.g.  filesystem freeze).

Credits: The original filestream allocator on Irix was written by
Glen Overby, the Linux port and rewrite by Nathan Scott and Sam
Vaughan (none of whom work at SGI any more). I just picked the pieces
and beat it repeatedly with a big stick until it passed XFSQA.

Version 4:

o cleanup code in xfs_bmap_btalloc
o add comments to xfs_bmap_btalloc
o moved comments from xfs_mru_cache.h to mxfs_mru_cache.c so functions
  are documented rather than their protoypes
o fixed use-after-free in tracing code
o fixed xfs_release merge screwup
o fixed ABBA deadlock on the directory inode in xfs_filestream_associate
  during xfs_freeze

Version 3:

o use proper define for mount args
o make filestreams inode flag mark child inodes correctly so that
  filestreams are applied to them even if they are not tagged
o split quota inode filestreams avoidance out into a separate
  patch.
o move xfs_close() hooks for stream destruction on unlink to
  xfs_release().

Version 2:

o fold xfs_bmap_filestream() into xfs_bmap_btalloc()
o use ktrace infrastructure for debug code in xfs_filestream.c
o wrap repeated filestream inode checks.
o rename per-AG filestream reference counting macros and convert
  to static inline
o remove debug from xfs_mru_cache.[ch]
o fix function call/error check formatting.
o removed unnecessary fstrm_mnt_data_t structure.
o cleaned up ASSERT checks
o cleaned up namespace-less globals in xfs_mru_cache.c
o removed unnecessary casts

---
 fs/xfs/Makefile-linux-2.6      |    2 
 fs/xfs/linux-2.6/xfs_globals.c |    1 
 fs/xfs/linux-2.6/xfs_linux.h   |    1 
 fs/xfs/linux-2.6/xfs_sysctl.c  |   11 
 fs/xfs/linux-2.6/xfs_sysctl.h  |    2 
 fs/xfs/xfs.h                   |    1 
 fs/xfs/xfs_ag.h                |    1 
 fs/xfs/xfs_bmap.c              |   69 +++
 fs/xfs/xfs_clnt.h              |    2 
 fs/xfs/xfs_dinode.h            |    4 
 fs/xfs/xfs_filestream.c        |  771 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_filestream.h        |  136 +++++++
 fs/xfs/xfs_fs.h                |    1 
 fs/xfs/xfs_fsops.c             |    2 
 fs/xfs/xfs_inode.c             |   17 
 fs/xfs/xfs_inode.h             |    1 
 fs/xfs/xfs_mount.h             |    4 
 fs/xfs/xfs_mru_cache.c         |  608 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mru_cache.h         |   57 +++
 fs/xfs/xfs_vfsops.c            |   26 +
 fs/xfs/xfs_vnodeops.c          |   25 +
 fs/xfs/xfsidbg.c               |  188 +++++++++
 22 files changed, 1918 insertions(+), 12 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/Makefile-linux-2.6
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/Makefile-linux-2.6	2007-06-20 16:35:45.172356726 +1000
+++ 2.6.x-xfs-new/fs/xfs/Makefile-linux-2.6	2007-06-20 17:59:34.794802221 +1000
@@ -54,6 +54,7 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_dir2_sf.o \
 				   xfs_error.o \
 				   xfs_extfree_item.o \
+				   xfs_filestream.o \
 				   xfs_fsops.o \
 				   xfs_ialloc.o \
 				   xfs_ialloc_btree.o \
@@ -67,6 +68,7 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_log.o \
 				   xfs_log_recover.o \
 				   xfs_mount.o \
+				   xfs_mru_cache.o \
 				   xfs_rename.o \
 				   xfs_trans.o \
 				   xfs_trans_ail.o \
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_globals.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_globals.c	2007-06-20 16:35:45.192354104 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_globals.c	2007-06-20 17:59:34.902788196 +1000
@@ -49,6 +49,7 @@ xfs_param_t xfs_params = {
 	.inherit_nosym	= {	0,		0,		1	},
 	.rotorstep	= {	1,		1,		255	},
 	.inherit_nodfrg	= {	0,		1,		1	},
+	.fstrm_timer	= {	1,		50,		3600*100},
 };
 
 /*
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_linux.h	2007-06-20 16:35:45.196353580 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_linux.h	2007-06-28 11:04:29.751600456 +1000
@@ -132,6 +132,7 @@
 #define xfs_inherit_nosymlinks	xfs_params.inherit_nosym.val
 #define xfs_rotorstep		xfs_params.rotorstep.val
 #define xfs_inherit_nodefrag	xfs_params.inherit_nodfrg.val
+#define xfs_fstrm_centisecs	xfs_params.fstrm_timer.val
 
 #define current_cpu()		(raw_smp_processor_id())
 #define current_pid()		(current->pid)
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_sysctl.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_sysctl.c	2007-06-20 16:35:45.200353055 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_sysctl.c	2007-06-20 17:59:34.914786638 +1000
@@ -243,6 +243,17 @@ static ctl_table xfs_table[] = {
 		.extra1		= &xfs_params.inherit_nodfrg.min,
 		.extra2		= &xfs_params.inherit_nodfrg.max
 	},
+	{
+		.ctl_name	= XFS_FILESTREAM_TIMER,
+		.procname	= "filestream_centisecs",
+		.data		= &xfs_params.fstrm_timer.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &xfs_params.fstrm_timer.min,
+		.extra2		= &xfs_params.fstrm_timer.max,
+	},
 	/* please keep this the last entry */
 #ifdef CONFIG_PROC_FS
 	{
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_sysctl.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_sysctl.h	2007-06-20 16:35:45.212351482 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_sysctl.h	2007-06-20 17:59:34.918786119 +1000
@@ -50,6 +50,7 @@ typedef struct xfs_param {
 	xfs_sysctl_val_t inherit_nosym;	/* Inherit the "nosymlinks" flag. */
 	xfs_sysctl_val_t rotorstep;	/* inode32 AG rotoring control knob */
 	xfs_sysctl_val_t inherit_nodfrg;/* Inherit the "nodefrag" inode flag. */
+	xfs_sysctl_val_t fstrm_timer;	/* Filestream dir-AG assoc'n timeout. */
 } xfs_param_t;
 
 /*
@@ -89,6 +90,7 @@ enum {
 	XFS_INHERIT_NOSYM = 19,
 	XFS_ROTORSTEP = 20,
 	XFS_INHERIT_NODFRG = 21,
+	XFS_FILESTREAM_TIMER = 22,
 };
 
 extern xfs_param_t	xfs_params;
Index: 2.6.x-xfs-new/fs/xfs/xfs_ag.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ag.h	2007-06-20 17:59:24.992075301 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_ag.h	2007-06-28 11:04:33.895058244 +1000
@@ -196,6 +196,7 @@ typedef struct xfs_perag
 	lock_t		pagb_lock;	/* lock for pagb_list */
 #endif
 	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
+	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
 
 	int		pag_ici_init;	/* incore inode cache initialised */
 	rwlock_t	pag_ici_lock;	/* incore inode lock */
Index: 2.6.x-xfs-new/fs/xfs/xfs_bmap.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bmap.c	2007-06-20 16:35:45.220350433 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_bmap.c	2007-06-29 11:38:01.970328178 +1000
@@ -52,6 +52,7 @@
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_buf_item.h"
+#include "xfs_filestream.h"
 
 
 #ifdef DEBUG
@@ -2724,9 +2725,15 @@ xfs_bmap_btalloc(
 	}
 	nullfb = ap->firstblock == NULLFSBLOCK;
 	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, ap->firstblock);
-	if (nullfb)
-		ap->rval = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
-	else
+	if (nullfb) {
+		if (ap->userdata && xfs_inode_is_filestream(ap->ip)) {
+			ag = xfs_filestream_lookup_ag(ap->ip);
+			ag = (ag != NULLAGNUMBER) ? ag : 0;
+			ap->rval = XFS_AGB_TO_FSB(mp, ag, 0);
+		} else {
+			ap->rval = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
+		}
+	} else
 		ap->rval = ap->firstblock;
 
 	xfs_bmap_adjacent(ap);
@@ -2750,13 +2757,22 @@ xfs_bmap_btalloc(
 	args.firstblock = ap->firstblock;
 	blen = 0;
 	if (nullfb) {
-		args.type = XFS_ALLOCTYPE_START_BNO;
+		if (ap->userdata && xfs_inode_is_filestream(ap->ip))
+			args.type = XFS_ALLOCTYPE_NEAR_BNO;
+		else
+			args.type = XFS_ALLOCTYPE_START_BNO;
 		args.total = ap->total;
+
 		/*
-		 * Find the longest available space.
-		 * We're going to try for the whole allocation at once.
+		 * Search for an allocation group with a single extent
+		 * large enough for the request.
+		 *
+		 * If one isn't found, then adjust the minimum allocation
+		 * size to the largest space found.
 		 */
 		startag = ag = XFS_FSB_TO_AGNO(mp, args.fsbno);
+		if (startag == NULLAGNUMBER)
+			startag = ag = 0;
 		notinit = 0;
 		down_read(&mp->m_peraglock);
 		while (blen < ap->alen) {
@@ -2782,6 +2798,35 @@ xfs_bmap_btalloc(
 					blen = longest;
 			} else
 				notinit = 1;
+
+			if (xfs_inode_is_filestream(ap->ip)) {
+				if (blen >= ap->alen)
+					break;
+
+				if (ap->userdata) {
+					/*
+					 * If startag is an invalid AG, we've
+					 * come here once before and
+					 * xfs_filestream_new_ag picked the
+					 * best currently available.
+					 *
+					 * Don't continue looping, since we
+					 * could loop forever.
+					 */
+					if (startag == NULLAGNUMBER)
+						break;
+
+					error = xfs_filestream_new_ag(ap, &ag);
+					if (error) {
+						up_read(&mp->m_peraglock);
+						return error;
+					}
+
+					/* loop again to set 'blen'*/
+					startag = NULLAGNUMBER;
+					continue;
+				}
+			}
 			if (++ag == mp->m_sb.sb_agcount)
 				ag = 0;
 			if (ag == startag)
@@ -2806,8 +2851,18 @@ xfs_bmap_btalloc(
 		 */
 		else
 			args.minlen = ap->alen;
+
+		/*
+		 * set the failure fallback case to look in the selected
+		 * AG as the stream may have moved.
+		 */
+		if (xfs_inode_is_filestream(ap->ip))
+			ap->rval = args.fsbno = XFS_AGB_TO_FSB(mp, ag, 0);
 	} else if (ap->low) {
-		args.type = XFS_ALLOCTYPE_START_BNO;
+		if (xfs_inode_is_filestream(ap->ip))
+			args.type = XFS_ALLOCTYPE_FIRST_AG;
+		else
+			args.type = XFS_ALLOCTYPE_START_BNO;
 		args.total = args.minlen = ap->minlen;
 	} else {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
Index: 2.6.x-xfs-new/fs/xfs/xfs_clnt.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_clnt.h	2007-06-20 17:53:27.670502869 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_clnt.h	2007-06-29 11:36:43.236506638 +1000
@@ -98,5 +98,7 @@ struct xfs_mount_args {
  */
 #define XFSMNT2_COMPAT_IOSIZE	0x00000001	/* don't report large preferred
 						 * I/O size in stat(2) */
+#define XFSMNT2_FILESTREAMS	0x00000002	/* enable the filestreams
+						 * allocator */
 
 #endif	/* __XFS_CLNT_H__ */
Index: 2.6.x-xfs-new/fs/xfs/xfs_dinode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_dinode.h	2007-06-20 16:35:45.236348336 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_dinode.h	2007-06-20 17:59:34.950781963 +1000
@@ -257,6 +257,7 @@ typedef enum xfs_dinode_fmt
 #define XFS_DIFLAG_EXTSIZE_BIT      11	/* inode extent size allocator hint */
 #define XFS_DIFLAG_EXTSZINHERIT_BIT 12	/* inherit inode extent size */
 #define XFS_DIFLAG_NODEFRAG_BIT     13	/* do not reorganize/defragment */
+#define XFS_DIFLAG_FILESTREAM_BIT   14  /* use filestream allocator */
 #define XFS_DIFLAG_REALTIME      (1 << XFS_DIFLAG_REALTIME_BIT)
 #define XFS_DIFLAG_PREALLOC      (1 << XFS_DIFLAG_PREALLOC_BIT)
 #define XFS_DIFLAG_NEWRTBM       (1 << XFS_DIFLAG_NEWRTBM_BIT)
@@ -271,12 +272,13 @@ typedef enum xfs_dinode_fmt
 #define XFS_DIFLAG_EXTSIZE       (1 << XFS_DIFLAG_EXTSIZE_BIT)
 #define XFS_DIFLAG_EXTSZINHERIT  (1 << XFS_DIFLAG_EXTSZINHERIT_BIT)
 #define XFS_DIFLAG_NODEFRAG      (1 << XFS_DIFLAG_NODEFRAG_BIT)
+#define XFS_DIFLAG_FILESTREAM    (1 << XFS_DIFLAG_FILESTREAM_BIT)
 
 #define XFS_DIFLAG_ANY \
 	(XFS_DIFLAG_REALTIME | XFS_DIFLAG_PREALLOC | XFS_DIFLAG_NEWRTBM | \
 	 XFS_DIFLAG_IMMUTABLE | XFS_DIFLAG_APPEND | XFS_DIFLAG_SYNC | \
 	 XFS_DIFLAG_NOATIME | XFS_DIFLAG_NODUMP | XFS_DIFLAG_RTINHERIT | \
 	 XFS_DIFLAG_PROJINHERIT | XFS_DIFLAG_NOSYMLINKS | XFS_DIFLAG_EXTSIZE | \
-	 XFS_DIFLAG_EXTSZINHERIT | XFS_DIFLAG_NODEFRAG)
+	 XFS_DIFLAG_EXTSZINHERIT | XFS_DIFLAG_NODEFRAG | XFS_DIFLAG_FILESTREAM)
 
 #endif	/* __XFS_DINODE_H__ */
Index: 2.6.x-xfs-new/fs/xfs/xfs_filestream.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ 2.6.x-xfs-new/fs/xfs/xfs_filestream.c	2007-06-29 11:42:55.336391604 +1000
@@ -0,0 +1,771 @@
+/*
+ * Copyright (c) 2006-2007 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inum.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_sf.h"
+#include "xfs_attr_sf.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_ag.h"
+#include "xfs_dmapi.h"
+#include "xfs_log.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_bmap.h"
+#include "xfs_alloc.h"
+#include "xfs_utils.h"
+#include "xfs_mru_cache.h"
+#include "xfs_filestream.h"
+
+#ifdef XFS_FILESTREAMS_TRACE
+
+ktrace_t *xfs_filestreams_trace_buf;
+
+STATIC void
+xfs_filestreams_trace(
+	xfs_mount_t	*mp,	/* mount point */
+	int		type,	/* type of trace */
+	const char	*func,	/* source function */
+	int		line,	/* source line number */
+	__psunsigned_t	arg0,
+	__psunsigned_t	arg1,
+	__psunsigned_t	arg2,
+	__psunsigned_t	arg3,
+	__psunsigned_t	arg4,
+	__psunsigned_t	arg5)
+{
+	ktrace_enter(xfs_filestreams_trace_buf,
+		(void *)(__psint_t)(type | (line << 16)),
+		(void *)func,
+		(void *)(__psunsigned_t)current_pid(),
+		(void *)mp,
+		(void *)(__psunsigned_t)arg0,
+		(void *)(__psunsigned_t)arg1,
+		(void *)(__psunsigned_t)arg2,
+		(void *)(__psunsigned_t)arg3,
+		(void *)(__psunsigned_t)arg4,
+		(void *)(__psunsigned_t)arg5,
+		NULL, NULL, NULL, NULL, NULL, NULL);
+}
+
+#define TRACE0(mp,t)			TRACE6(mp,t,0,0,0,0,0,0)
+#define TRACE1(mp,t,a0)			TRACE6(mp,t,a0,0,0,0,0,0)
+#define TRACE2(mp,t,a0,a1)		TRACE6(mp,t,a0,a1,0,0,0,0)
+#define TRACE3(mp,t,a0,a1,a2)		TRACE6(mp,t,a0,a1,a2,0,0,0)
+#define TRACE4(mp,t,a0,a1,a2,a3)	TRACE6(mp,t,a0,a1,a2,a3,0,0)
+#define TRACE5(mp,t,a0,a1,a2,a3,a4)	TRACE6(mp,t,a0,a1,a2,a3,a4,0)
+#define TRACE6(mp,t,a0,a1,a2,a3,a4,a5) \
+	xfs_filestreams_trace(mp, t, __FUNCTION__, __LINE__, \
+				(__psunsigned_t)a0, (__psunsigned_t)a1, \
+				(__psunsigned_t)a2, (__psunsigned_t)a3, \
+				(__psunsigned_t)a4, (__psunsigned_t)a5)
+
+#define TRACE_AG_SCAN(mp, ag, ag2) \
+		TRACE2(mp, XFS_FSTRM_KTRACE_AGSCAN, ag, ag2);
+#define TRACE_AG_PICK1(mp, max_ag, maxfree) \
+		TRACE2(mp, XFS_FSTRM_KTRACE_AGPICK1, max_ag, maxfree);
+#define TRACE_AG_PICK2(mp, ag, ag2, cnt, free, scan, flag) \
+		TRACE6(mp, XFS_FSTRM_KTRACE_AGPICK2, ag, ag2, \
+			 cnt, free, scan, flag)
+#define TRACE_UPDATE(mp, ip, ag, cnt, ag2, cnt2) \
+		TRACE5(mp, XFS_FSTRM_KTRACE_UPDATE, ip, ag, cnt, ag2, cnt2)
+#define TRACE_FREE(mp, ip, pip, ag, cnt) \
+		TRACE4(mp, XFS_FSTRM_KTRACE_FREE, ip, pip, ag, cnt)
+#define TRACE_LOOKUP(mp, ip, pip, ag, cnt) \
+		TRACE4(mp, XFS_FSTRM_KTRACE_ITEM_LOOKUP, ip, pip, ag, cnt)
+#define TRACE_ASSOCIATE(mp, ip, pip, ag, cnt) \
+		TRACE4(mp, XFS_FSTRM_KTRACE_ASSOCIATE, ip, pip, ag, cnt)
+#define TRACE_MOVEAG(mp, ip, pip, oag, ocnt, nag, ncnt) \
+		TRACE6(mp, XFS_FSTRM_KTRACE_MOVEAG, ip, pip, oag, ocnt, nag, ncnt)
+#define TRACE_ORPHAN(mp, ip, ag) \
+		TRACE2(mp, XFS_FSTRM_KTRACE_ORPHAN, ip, ag);
+
+
+#else
+#define TRACE_AG_SCAN(mp, ag, ag2)
+#define TRACE_AG_PICK1(mp, max_ag, maxfree)
+#define TRACE_AG_PICK2(mp, ag, ag2, cnt, free, scan, flag)
+#define TRACE_UPDATE(mp, ip, ag, cnt, ag2, cnt2)
+#define TRACE_FREE(mp, ip, pip, ag, cnt)
+#define TRACE_LOOKUP(mp, ip, pip, ag, cnt)
+#define TRACE_ASSOCIATE(mp, ip, pip, ag, cnt)
+#define TRACE_MOVEAG(mp, ip, pip, oag, ocnt, nag, ncnt)
+#define TRACE_ORPHAN(mp, ip, ag)
+#endif
+
+static kmem_zone_t *item_zone;
+
+/*
+ * Structure for associating a file or a directory with an allocation group.
+ * The parent directory pointer is only needed for files, but since there will
+ * generally be vastly more files than directories in the cache, using the same
+ * data structure simplifies the code with very little memory overhead.
+ */
+typedef struct fstrm_item
+{
+	xfs_agnumber_t	ag;	/* AG currently in use for the file/directory. */
+	xfs_inode_t	*ip;	/* inode self-pointer. */
+	xfs_inode_t	*pip;	/* Parent directory inode pointer. */
+} fstrm_item_t;
+
+
+/*
+ * Scan the AGs starting at startag looking for an AG that isn't in use and has
+ * at least minlen blocks free.
+ */
+static int
+_xfs_filestream_pick_ag(
+	xfs_mount_t	*mp,
+	xfs_agnumber_t	startag,
+	xfs_agnumber_t	*agp,
+	int		flags,
+	xfs_extlen_t	minlen)
+{
+	int		err, trylock, nscan;
+	xfs_extlen_t	delta, longest, need, free, minfree, maxfree = 0;
+	xfs_agnumber_t	ag, max_ag = NULLAGNUMBER;
+	struct xfs_perag *pag;
+
+	/* 2% of an AG's blocks must be free for it to be chosen. */
+	minfree = mp->m_sb.sb_agblocks / 50;
+
+	ag = startag;
+	*agp = NULLAGNUMBER;
+
+	/* For the first pass, don't sleep trying to init the per-AG. */
+	trylock = XFS_ALLOC_FLAG_TRYLOCK;
+
+	for (nscan = 0; 1; nscan++) {
+
+		TRACE_AG_SCAN(mp, ag, xfs_filestream_peek_ag(mp, ag));
+
+		pag = mp->m_perag + ag;
+
+		if (!pag->pagf_init) {
+			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
+			if (err && !trylock)
+				return err;
+		}
+
+		/* Might fail sometimes during the 1st pass with trylock set. */
+		if (!pag->pagf_init)
+			goto next_ag;
+
+		/* Keep track of the AG with the most free blocks. */
+		if (pag->pagf_freeblks > maxfree) {
+			maxfree = pag->pagf_freeblks;
+			max_ag = ag;
+		}
+
+		/*
+		 * The AG reference count does two things: it enforces mutual
+		 * exclusion when examining the suitability of an AG in this
+		 * loop, and it guards against two filestreams being established
+		 * in the same AG as each other.
+		 */
+		if (xfs_filestream_get_ag(mp, ag) > 1) {
+			xfs_filestream_put_ag(mp, ag);
+			goto next_ag;
+		}
+
+		need = XFS_MIN_FREELIST_PAG(pag, mp);
+		delta = need > pag->pagf_flcount ? need - pag->pagf_flcount : 0;
+		longest = (pag->pagf_longest > delta) ?
+		          (pag->pagf_longest - delta) :
+		          (pag->pagf_flcount > 0 || pag->pagf_longest > 0);
+
+		if (((minlen && longest >= minlen) ||
+		     (!minlen && pag->pagf_freeblks >= minfree)) &&
+		    (!pag->pagf_metadata || !(flags & XFS_PICK_USERDATA) ||
+		     (flags & XFS_PICK_LOWSPACE))) {
+
+			/* Break out, retaining the reference on the AG. */
+			free = pag->pagf_freeblks;
+			*agp = ag;
+			break;
+		}
+
+		/* Drop the reference on this AG, it's not usable. */
+		xfs_filestream_put_ag(mp, ag);
+next_ag:
+		/* Move to the next AG, wrapping to AG 0 if necessary. */
+		if (++ag >= mp->m_sb.sb_agcount)
+			ag = 0;
+
+		/* If a full pass of the AGs hasn't been done yet, continue. */
+		if (ag != startag)
+			continue;
+
+		/* Allow sleeping in xfs_alloc_pagf_init() on the 2nd pass. */
+		if (trylock != 0) {
+			trylock = 0;
+			continue;
+		}
+
+		/* Finally, if lowspace wasn't set, set it for the 3rd pass. */
+		if (!(flags & XFS_PICK_LOWSPACE)) {
+			flags |= XFS_PICK_LOWSPACE;
+			continue;
+		}
+
+		/*
+		 * Take the AG with the most free space, regardless of whether
+		 * it's already in use by another filestream.
+		 */
+		if (max_ag != NULLAGNUMBER) {
+			xfs_filestream_get_ag(mp, max_ag);
+			TRACE_AG_PICK1(mp, max_ag, maxfree);
+			free = maxfree;
+			*agp = max_ag;
+			break;
+		}
+
+		/* take AG 0 if none matched */
+		TRACE_AG_PICK1(mp, max_ag, maxfree);
+		*agp = 0;
+		return 0;
+	}
+
+	TRACE_AG_PICK2(mp, startag, *agp, xfs_filestream_peek_ag(mp, *agp),
+			free, nscan, flags);
+
+	return 0;
+}
+
+/*
+ * Set the allocation group number for a file or a directory, updating inode
+ * references and per-AG references as appropriate.  Must be called with the
+ * m_peraglock held in read mode.
+ */
+static int
+_xfs_filestream_update_ag(
+	xfs_inode_t	*ip,
+	xfs_inode_t	*pip,
+	xfs_agnumber_t	ag)
+{
+	int		err = 0;
+	xfs_mount_t	*mp;
+	xfs_mru_cache_t	*cache;
+	fstrm_item_t	*item;
+	xfs_agnumber_t	old_ag;
+	xfs_inode_t	*old_pip;
+
+	/*
+	 * Either ip is a regular file and pip is a directory, or ip is a
+	 * directory and pip is NULL.
+	 */
+	ASSERT(ip && (((ip->i_d.di_mode & S_IFREG) && pip &&
+	               (pip->i_d.di_mode & S_IFDIR)) ||
+	              ((ip->i_d.di_mode & S_IFDIR) && !pip)));
+
+	mp = ip->i_mount;
+	cache = mp->m_filestream;
+
+	item = xfs_mru_cache_lookup(cache, ip->i_ino);
+	if (item) {
+		ASSERT(item->ip == ip);
+		old_ag = item->ag;
+		item->ag = ag;
+		old_pip = item->pip;
+		item->pip = pip;
+		xfs_mru_cache_done(cache);
+
+		/*
+		 * If the AG has changed, drop the old ref and take a new one,
+		 * effectively transferring the reference from old to new AG.
+		 */
+		if (ag != old_ag) {
+			xfs_filestream_put_ag(mp, old_ag);
+			xfs_filestream_get_ag(mp, ag);
+		}
+
+		/*
+		 * If ip is a file and its pip has changed, drop the old ref and
+		 * take a new one.
+		 */
+		if (pip && pip != old_pip) {
+			IRELE(old_pip);
+			IHOLD(pip);
+		}
+
+		TRACE_UPDATE(mp, ip, old_ag, xfs_filestream_peek_ag(mp, old_ag),
+				ag, xfs_filestream_peek_ag(mp, ag));
+		return 0;
+	}
+
+	item = kmem_zone_zalloc(item_zone, KM_MAYFAIL);
+	if (!item)
+		return ENOMEM;
+
+	item->ag = ag;
+	item->ip = ip;
+	item->pip = pip;
+
+	err = xfs_mru_cache_insert(cache, ip->i_ino, item);
+	if (err) {
+		kmem_zone_free(item_zone, item);
+		return err;
+	}
+
+	/* Take a reference on the AG. */
+	xfs_filestream_get_ag(mp, ag);
+
+	/*
+	 * Take a reference on the inode itself regardless of whether it's a
+	 * regular file or a directory.
+	 */
+	IHOLD(ip);
+
+	/*
+	 * In the case of a regular file, take a reference on the parent inode
+	 * as well to ensure it remains in-core.
+	 */
+	if (pip)
+		IHOLD(pip);
+
+	TRACE_UPDATE(mp, ip, ag, xfs_filestream_peek_ag(mp, ag),
+			ag, xfs_filestream_peek_ag(mp, ag));
+
+	return 0;
+}
+
+/* xfs_fstrm_free_func(): callback for freeing cached stream items. */
+void
+xfs_fstrm_free_func(
+	xfs_ino_t	ino,
+	fstrm_item_t	*item)
+{
+	xfs_inode_t	*ip = item->ip;
+	int ref;
+
+	ASSERT(ip->i_ino == ino);
+
+	xfs_iflags_clear(ip, XFS_IFILESTREAM);
+
+	/* Drop the reference taken on the AG when the item was added. */
+	ref = xfs_filestream_put_ag(ip->i_mount, item->ag);
+
+	ASSERT(ref >= 0);
+	TRACE_FREE(ip->i_mount, ip, item->pip, item->ag,
+		xfs_filestream_peek_ag(ip->i_mount, item->ag));
+
+	/*
+	 * _xfs_filestream_update_ag() always takes a reference on the inode
+	 * itself, whether it's a file or a directory.  Release it here.
+	 * This can result in the inode being freed and so we must
+	 * not hold any inode locks when freeing filesstreams objects
+	 * otherwise we can deadlock here.
+	 */
+	IRELE(ip);
+
+	/*
+	 * In the case of a regular file, _xfs_filestream_update_ag() also
+	 * takes a ref on the parent inode to keep it in-core.  Release that
+	 * too.
+	 */
+	if (item->pip)
+		IRELE(item->pip);
+
+	/* Finally, free the memory allocated for the item. */
+	kmem_zone_free(item_zone, item);
+}
+
+/*
+ * xfs_filestream_init() is called at xfs initialisation time to set up the
+ * memory zone that will be used for filestream data structure allocation.
+ */
+int
+xfs_filestream_init(void)
+{
+	item_zone = kmem_zone_init(sizeof(fstrm_item_t), "fstrm_item");
+#ifdef XFS_FILESTREAMS_TRACE
+	xfs_filestreams_trace_buf = ktrace_alloc(XFS_FSTRM_KTRACE_SIZE, KM_SLEEP);
+#endif
+	return item_zone ? 0 : -ENOMEM;
+}
+
+/*
+ * xfs_filestream_uninit() is called at xfs termination time to destroy the
+ * memory zone that was used for filestream data structure allocation.
+ */
+void
+xfs_filestream_uninit(void)
+{
+#ifdef XFS_FILESTREAMS_TRACE
+	ktrace_free(xfs_filestreams_trace_buf);
+#endif
+	kmem_zone_destroy(item_zone);
+}
+
+/*
+ * xfs_filestream_mount() is called when a file system is mounted with the
+ * filestream option.  It is responsible for allocating the data structures
+ * needed to track the new file system's file streams.
+ */
+int
+xfs_filestream_mount(
+	xfs_mount_t	*mp)
+{
+	int		err;
+	unsigned int	lifetime, grp_count;
+
+	/*
+	 * The filestream timer tunable is currently fixed within the range of
+	 * one second to four minutes, with five seconds being the default.  The
+	 * group count is somewhat arbitrary, but it'd be nice to adhere to the
+	 * timer tunable to within about 10 percent.  This requires at least 10
+	 * groups.
+	 */
+	lifetime  = xfs_fstrm_centisecs * 10;
+	grp_count = 10;
+
+	err = xfs_mru_cache_create(&mp->m_filestream, lifetime, grp_count,
+	                     (xfs_mru_cache_free_func_t)xfs_fstrm_free_func);
+
+	return err;
+}
+
+/*
+ * xfs_filestream_unmount() is called when a file system that was mounted with
+ * the filestream option is unmounted.  It drains the data structures created
+ * to track the file system's file streams and frees all the memory that was
+ * allocated.
+ */
+void
+xfs_filestream_unmount(
+	xfs_mount_t	*mp)
+{
+	xfs_mru_cache_destroy(mp->m_filestream);
+}
+
+/*
+ * If the mount point's m_perag array is going to be reallocated, all
+ * outstanding cache entries must be flushed to avoid accessing reference count
+ * addresses that have been freed.  The call to xfs_filestream_flush() must be
+ * made inside the block that holds the m_peraglock in write mode to do the
+ * reallocation.
+ */
+void
+xfs_filestream_flush(
+	xfs_mount_t	*mp)
+{
+	/* point in time flush, so keep the reaper running */
+	xfs_mru_cache_flush(mp->m_filestream, 1);
+}
+
+/*
+ * Return the AG of the filestream the file or directory belongs to, or
+ * NULLAGNUMBER otherwise.
+ */
+xfs_agnumber_t
+xfs_filestream_lookup_ag(
+	xfs_inode_t	*ip)
+{
+	xfs_mru_cache_t	*cache;
+	fstrm_item_t	*item;
+	xfs_agnumber_t	ag;
+	int		ref;
+
+	if (!(ip->i_d.di_mode & (S_IFREG | S_IFDIR))) {
+		ASSERT(0);
+		return NULLAGNUMBER;
+	}
+
+	cache = ip->i_mount->m_filestream;
+	item = xfs_mru_cache_lookup(cache, ip->i_ino);
+	if (!item) {
+		TRACE_LOOKUP(ip->i_mount, ip, NULL, NULLAGNUMBER, 0);
+		return NULLAGNUMBER;
+	}
+
+	ASSERT(ip == item->ip);
+	ag = item->ag;
+	ref = xfs_filestream_peek_ag(ip->i_mount, ag);
+	xfs_mru_cache_done(cache);
+
+	TRACE_LOOKUP(ip->i_mount, ip, item->pip, ag, ref);
+	return ag;
+}
+
+/*
+ * xfs_filestream_associate() should only be called to associate a regular file
+ * with its parent directory.  Calling it with a child directory isn't
+ * appropriate because filestreams don't apply to entire directory hierarchies.
+ * Creating a file in a child directory of an existing filestream directory
+ * starts a new filestream with its own allocation group association.
+ *
+ * Returns < 0 on error, 0 if successful association occurred, > 0 if
+ * we failed to get an association because of locking issues.
+ */
+int
+xfs_filestream_associate(
+	xfs_inode_t	*pip,
+	xfs_inode_t	*ip)
+{
+	xfs_mount_t	*mp;
+	xfs_mru_cache_t	*cache;
+	fstrm_item_t	*item;
+	xfs_agnumber_t	ag, rotorstep, startag;
+	int		err = 0;
+
+	ASSERT(pip->i_d.di_mode & S_IFDIR);
+	ASSERT(ip->i_d.di_mode & S_IFREG);
+	if (!(pip->i_d.di_mode & S_IFDIR) || !(ip->i_d.di_mode & S_IFREG))
+		return -EINVAL;
+
+	mp = pip->i_mount;
+	cache = mp->m_filestream;
+	down_read(&mp->m_peraglock);
+
+	/*
+	 * We have a problem, Houston.
+	 *
+	 * Taking the iolock here violates inode locking order - we already
+	 * hold the ilock. Hence if we block getting this lock we may never
+	 * wake. Unfortunately, that means if we can't get the lock, we're
+	 * screwed in terms of getting a stream association - we can't spin
+	 * waiting for the lock because someone else is waiting on the lock we
+	 * hold and we cannot drop that as we are in a transaction here.
+	 *
+	 * Lucky for us, this inversion is rarely a problem because it's a
+	 * directory inode that we are trying to lock here and that means the
+	 * only place that matters is xfs_sync_inodes() and SYNC_DELWRI is
+	 * used. i.e. freeze, remount-ro, quotasync or unmount.
+	 *
+	 * So, if we can't get the iolock without sleeping then just give up
+	 */
+	if (!xfs_ilock_nowait(pip, XFS_IOLOCK_EXCL)) {
+		up_read(&mp->m_peraglock);
+		return 1;
+	}
+
+	/* If the parent directory is already in the cache, use its AG. */
+	item = xfs_mru_cache_lookup(cache, pip->i_ino);
+	if (item) {
+		ASSERT(item->ip == pip);
+		ag = item->ag;
+		xfs_mru_cache_done(cache);
+
+		TRACE_LOOKUP(mp, pip, pip, ag, xfs_filestream_peek_ag(mp, ag));
+		err = _xfs_filestream_update_ag(ip, pip, ag);
+
+		goto exit;
+	}
+
+	/*
+	 * Set the starting AG using the rotor for inode32, otherwise
+	 * use the directory inode's AG.
+	 */
+	if (mp->m_flags & XFS_MOUNT_32BITINODES) {
+		rotorstep = xfs_rotorstep;
+		startag = (mp->m_agfrotor / rotorstep) % mp->m_sb.sb_agcount;
+		mp->m_agfrotor = (mp->m_agfrotor + 1) %
+		                 (mp->m_sb.sb_agcount * rotorstep);
+	} else
+		startag = XFS_INO_TO_AGNO(mp, pip->i_ino);
+
+	/* Pick a new AG for the parent inode starting at startag. */
+	err = _xfs_filestream_pick_ag(mp, startag, &ag, 0, 0);
+	if (err || ag == NULLAGNUMBER)
+		goto exit_did_pick;
+
+	/* Associate the parent inode with the AG. */
+	err = _xfs_filestream_update_ag(pip, NULL, ag);
+	if (err)
+		goto exit_did_pick;
+
+	/* Associate the file inode with the AG. */
+	err = _xfs_filestream_update_ag(ip, pip, ag);
+	if (err)
+		goto exit_did_pick;
+
+	TRACE_ASSOCIATE(mp, ip, pip, ag, xfs_filestream_peek_ag(mp, ag));
+
+exit_did_pick:
+	/*
+	 * If _xfs_filestream_pick_ag() returned a valid AG, remove the
+	 * reference it took on it, since the file and directory will have taken
+	 * their own now if they were successfully cached.
+	 */
+	if (ag != NULLAGNUMBER)
+		xfs_filestream_put_ag(mp, ag);
+
+exit:
+	xfs_iunlock(pip, XFS_IOLOCK_EXCL);
+	up_read(&mp->m_peraglock);
+	return -err;
+}
+
+/*
+ * Pick a new allocation group for the current file and its file stream.  This
+ * function is called by xfs_bmap_filestreams() with the mount point's per-ag
+ * lock held.
+ */
+int
+xfs_filestream_new_ag(
+	xfs_bmalloca_t	*ap,
+	xfs_agnumber_t	*agp)
+{
+	int		flags, err;
+	xfs_inode_t	*ip, *pip = NULL;
+	xfs_mount_t	*mp;
+	xfs_mru_cache_t	*cache;
+	xfs_extlen_t	minlen;
+	fstrm_item_t	*dir, *file;
+	xfs_agnumber_t	ag = NULLAGNUMBER;
+
+	ip = ap->ip;
+	mp = ip->i_mount;
+	cache = mp->m_filestream;
+	minlen = ap->alen;
+	*agp = NULLAGNUMBER;
+
+	/*
+	 * Look for the file in the cache, removing it if it's found.  Doing
+	 * this allows it to be held across the dir lookup that follows.
+	 */
+	file = xfs_mru_cache_remove(cache, ip->i_ino);
+	if (file) {
+		ASSERT(ip == file->ip);
+
+		/* Save the file's parent inode and old AG number for later. */
+		pip = file->pip;
+		ag = file->ag;
+
+		/* Look for the file's directory in the cache. */
+		dir = xfs_mru_cache_lookup(cache, pip->i_ino);
+		if (dir) {
+			ASSERT(pip == dir->ip);
+
+			/*
+			 * If the directory has already moved on to a new AG,
+			 * use that AG as the new AG for the file. Don't
+			 * forget to twiddle the AG refcounts to match the
+			 * movement.
+			 */
+			if (dir->ag != file->ag) {
+				xfs_filestream_put_ag(mp, file->ag);
+				xfs_filestream_get_ag(mp, dir->ag);
+				*agp = file->ag = dir->ag;
+			}
+
+			xfs_mru_cache_done(cache);
+		}
+
+		/*
+		 * Put the file back in the cache.  If this fails, the free
+		 * function needs to be called to tidy up in the same way as if
+		 * the item had simply expired from the cache.
+		 */
+		err = xfs_mru_cache_insert(cache, ip->i_ino, file);
+		if (err) {
+			xfs_fstrm_free_func(ip->i_ino, file);
+			return err;
+		}
+
+		/*
+		 * If the file's AG was moved to the directory's new AG, there's
+		 * nothing more to be done.
+		 */
+		if (*agp != NULLAGNUMBER) {
+			TRACE_MOVEAG(mp, ip, pip,
+					ag, xfs_filestream_peek_ag(mp, ag),
+					*agp, xfs_filestream_peek_ag(mp, *agp));
+			return 0;
+		}
+	}
+
+	/*
+	 * If the file's parent directory is known, take its iolock in exclusive
+	 * mode to prevent two sibling files from racing each other to migrate
+	 * themselves and their parent to different AGs.
+	 */
+	if (pip)
+		xfs_ilock(pip, XFS_IOLOCK_EXCL);
+
+	/*
+	 * A new AG needs to be found for the file.  If the file's parent
+	 * directory is also known, it will be moved to the new AG as well to
+	 * ensure that files created inside it in future use the new AG.
+	 */
+	ag = (ag == NULLAGNUMBER) ? 0 : (ag + 1) % mp->m_sb.sb_agcount;
+	flags = (ap->userdata ? XFS_PICK_USERDATA : 0) |
+	        (ap->low ? XFS_PICK_LOWSPACE : 0);
+
+	err = _xfs_filestream_pick_ag(mp, ag, agp, flags, minlen);
+	if (err || *agp == NULLAGNUMBER)
+		goto exit;
+
+	/*
+	 * If the file wasn't found in the file cache, then its parent directory
+	 * inode isn't known.  For this to have happened, the file must either
+	 * be pre-existing, or it was created long enough ago that its cache
+	 * entry has expired.  This isn't the sort of usage that the filestreams
+	 * allocator is trying to optimise, so there's no point trying to track
+	 * its new AG somehow in the filestream data structures.
+	 */
+	if (!pip) {
+		TRACE_ORPHAN(mp, ip, *agp);
+		goto exit;
+	}
+
+	/* Associate the parent inode with the AG. */
+	err = _xfs_filestream_update_ag(pip, NULL, *agp);
+	if (err)
+		goto exit;
+
+	/* Associate the file inode with the AG. */
+	err = _xfs_filestream_update_ag(ip, pip, *agp);
+	if (err)
+		goto exit;
+
+	TRACE_MOVEAG(mp, ip, pip, NULLAGNUMBER, 0,
+			*agp, xfs_filestream_peek_ag(mp, *agp));
+
+exit:
+	/*
+	 * If _xfs_filestream_pick_ag() returned a valid AG, remove the
+	 * reference it took on it, since the file and directory will have taken
+	 * their own now if they were successfully cached.
+	 */
+	if (*agp != NULLAGNUMBER)
+		xfs_filestream_put_ag(mp, *agp);
+	else
+		*agp = 0;
+
+	if (pip)
+		xfs_iunlock(pip, XFS_IOLOCK_EXCL);
+
+	return err;
+}
+
+/*
+ * Remove an association between an inode and a filestream object.
+ * Typically this is done on last close of an unlinked file.
+ */
+void
+xfs_filestream_deassociate(
+	xfs_inode_t	*ip)
+{
+	xfs_mru_cache_t	*cache = ip->i_mount->m_filestream;
+
+	xfs_mru_cache_delete(cache, ip->i_ino);
+}
Index: 2.6.x-xfs-new/fs/xfs/xfs_filestream.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ 2.6.x-xfs-new/fs/xfs/xfs_filestream.h	2007-06-29 11:38:01.966328695 +1000
@@ -0,0 +1,136 @@
+/*
+ * Copyright (c) 2006-2007 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_FILESTREAM_H__
+#define __XFS_FILESTREAM_H__
+
+#ifdef __KERNEL__
+
+struct xfs_mount;
+struct xfs_inode;
+struct xfs_perag;
+struct xfs_bmalloca;
+
+#ifdef XFS_FILESTREAMS_TRACE
+#define XFS_FSTRM_KTRACE_INFO		1
+#define XFS_FSTRM_KTRACE_AGSCAN		2
+#define XFS_FSTRM_KTRACE_AGPICK1	3
+#define XFS_FSTRM_KTRACE_AGPICK2	4
+#define XFS_FSTRM_KTRACE_UPDATE		5
+#define XFS_FSTRM_KTRACE_FREE		6
+#define	XFS_FSTRM_KTRACE_ITEM_LOOKUP	7
+#define	XFS_FSTRM_KTRACE_ASSOCIATE	8
+#define	XFS_FSTRM_KTRACE_MOVEAG		9
+#define	XFS_FSTRM_KTRACE_ORPHAN		10
+
+#define XFS_FSTRM_KTRACE_SIZE	16384
+extern ktrace_t *xfs_filestreams_trace_buf;
+
+#endif
+
+/*
+ * Allocation group filestream associations are tracked with per-ag atomic
+ * counters.  These counters allow _xfs_filestream_pick_ag() to tell whether a
+ * particular AG already has active filestreams associated with it. The mount
+ * point's m_peraglock is used to protect these counters from per-ag array
+ * re-allocation during a growfs operation.  When xfs_growfs_data_private() is
+ * about to reallocate the array, it calls xfs_filestream_flush() with the
+ * m_peraglock held in write mode.
+ *
+ * Since xfs_mru_cache_flush() guarantees that all the free functions for all
+ * the cache elements have finished executing before it returns, it's safe for
+ * the free functions to use the atomic counters without m_peraglock protection.
+ * This allows the implementation of xfs_fstrm_free_func() to be agnostic about
+ * whether it was called with the m_peraglock held in read mode, write mode or
+ * not held at all.  The race condition this addresses is the following:
+ *
+ *  - The work queue scheduler fires and pulls a filestream directory cache
+ *    element off the LRU end of the cache for deletion, then gets pre-empted.
+ *  - A growfs operation grabs the m_peraglock in write mode, flushes all the
+ *    remaining items from the cache and reallocates the mount point's per-ag
+ *    array, resetting all the counters to zero.
+ *  - The work queue thread resumes and calls the free function for the element
+ *    it started cleaning up earlier.  In the process it decrements the
+ *    filestreams counter for an AG that now has no references.
+ *
+ * With a shrinkfs feature, the above scenario could panic the system.
+ *
+ * All other uses of the following macros should be protected by either the
+ * m_peraglock held in read mode, or the cache's internal locking exposed by the
+ * interval between a call to xfs_mru_cache_lookup() and a call to
+ * xfs_mru_cache_done().  In addition, the m_peraglock must be held in read mode
+ * when new elements are added to the cache.
+ *
+ * Combined, these locking rules ensure that no associations will ever exist in
+ * the cache that reference per-ag array elements that have since been
+ * reallocated.
+ */
+STATIC_INLINE int
+xfs_filestream_peek_ag(
+	xfs_mount_t	*mp,
+	xfs_agnumber_t	agno)
+{
+	return atomic_read(&mp->m_perag[agno].pagf_fstrms);
+}
+
+STATIC_INLINE int
+xfs_filestream_get_ag(
+	xfs_mount_t	*mp,
+	xfs_agnumber_t	agno)
+{
+	return atomic_inc_return(&mp->m_perag[agno].pagf_fstrms);
+}
+
+STATIC_INLINE int
+xfs_filestream_put_ag(
+	xfs_mount_t	*mp,
+	xfs_agnumber_t	agno)
+{
+	return atomic_dec_return(&mp->m_perag[agno].pagf_fstrms);
+}
+
+/* allocation selection flags */
+typedef enum xfs_fstrm_alloc {
+	XFS_PICK_USERDATA = 1,
+	XFS_PICK_LOWSPACE = 2,
+} xfs_fstrm_alloc_t;
+
+/* prototypes for filestream.c */
+int xfs_filestream_init(void);
+void xfs_filestream_uninit(void);
+int xfs_filestream_mount(struct xfs_mount *mp);
+void xfs_filestream_unmount(struct xfs_mount *mp);
+void xfs_filestream_flush(struct xfs_mount *mp);
+xfs_agnumber_t xfs_filestream_lookup_ag(struct xfs_inode *ip);
+int xfs_filestream_associate(struct xfs_inode *dip, struct xfs_inode *ip);
+void xfs_filestream_deassociate(struct xfs_inode *ip);
+int xfs_filestream_new_ag(struct xfs_bmalloca *ap, xfs_agnumber_t *agp);
+
+
+/* filestreams for the inode? */
+STATIC_INLINE int
+xfs_inode_is_filestream(
+	struct xfs_inode	*ip)
+{
+	return (ip->i_mount->m_flags & XFS_MOUNT_FILESTREAMS) ||
+		xfs_iflags_test(ip, XFS_IFILESTREAM) ||
+		(ip->i_d.di_flags & XFS_DIFLAG_FILESTREAM);
+}
+
+#endif /* __KERNEL__ */
+
+#endif /* __XFS_FILESTREAM_H__ */
Index: 2.6.x-xfs-new/fs/xfs/xfs_fs.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_fs.h	2007-06-20 16:35:45.256345714 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_fs.h	2007-06-20 17:59:35.006774692 +1000
@@ -66,6 +66,7 @@ struct fsxattr {
 #define XFS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
 #define XFS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
 #define XFS_XFLAG_NODEFRAG	0x00002000  	/* do not defragment */
+#define XFS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
 #define XFS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /*
Index: 2.6.x-xfs-new/fs/xfs/xfs_fsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_fsops.c	2007-06-20 16:35:45.256345714 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_fsops.c	2007-06-29 11:36:43.804433222 +1000
@@ -44,6 +44,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_rtalloc.h"
 #include "xfs_rw.h"
+#include "xfs_filestream.h"
 
 /*
  * File system operations
@@ -165,6 +166,7 @@ xfs_growfs_data_private(
 	new = nb - mp->m_sb.sb_dblocks;
 	oagcount = mp->m_sb.sb_agcount;
 	if (nagcount > oagcount) {
+		xfs_filestream_flush(mp);
 		down_write(&mp->m_peraglock);
 		mp->m_perag = kmem_realloc(mp->m_perag,
 			sizeof(xfs_perag_t) * nagcount,
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2007-06-20 17:53:27.610510667 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2007-06-29 11:42:55.360388500 +1000
@@ -48,6 +48,7 @@
 #include "xfs_dir2_trace.h"
 #include "xfs_quota.h"
 #include "xfs_acl.h"
+#include "xfs_filestream.h"
 
 #include <linux/log2.h>
 
@@ -818,6 +819,8 @@ _xfs_dic2xflags(
 			flags |= XFS_XFLAG_EXTSZINHERIT;
 		if (di_flags & XFS_DIFLAG_NODEFRAG)
 			flags |= XFS_XFLAG_NODEFRAG;
+		if (di_flags & XFS_DIFLAG_FILESTREAM)
+			flags |= XFS_XFLAG_FILESTREAM;
 	}
 
 	return flags;
@@ -1151,7 +1154,7 @@ xfs_ialloc(
 	/*
 	 * Project ids won't be stored on disk if we are using a version 1 inode.
 	 */
-	if ( (prid != 0) && (ip->i_d.di_version == XFS_DINODE_VERSION_1))
+	if ((prid != 0) && (ip->i_d.di_version == XFS_DINODE_VERSION_1))
 		xfs_bump_ino_vers2(tp, ip);
 
 	if (XFS_INHERIT_GID(pip, vp->v_vfsp)) {
@@ -1196,8 +1199,16 @@ xfs_ialloc(
 		flags |= XFS_ILOG_DEV;
 		break;
 	case S_IFREG:
+		if (xfs_inode_is_filestream(pip)) {
+			error = xfs_filestream_associate(pip, ip);
+			if (error < 0)
+				return -error;
+			if (!error)
+				xfs_iflags_set(ip, XFS_IFILESTREAM);
+		}
+		/* fall through */
 	case S_IFDIR:
-		if (unlikely(pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
+		if (pip->i_d.di_flags & XFS_DIFLAG_ANY) {
 			uint	di_flags = 0;
 
 			if ((mode & S_IFMT) == S_IFDIR) {
@@ -1234,6 +1245,8 @@ xfs_ialloc(
 			if ((pip->i_d.di_flags & XFS_DIFLAG_NODEFRAG) &&
 			    xfs_inherit_nodefrag)
 				di_flags |= XFS_DIFLAG_NODEFRAG;
+			if (pip->i_d.di_flags & XFS_DIFLAG_FILESTREAM)
+				di_flags |= XFS_DIFLAG_FILESTREAM;
 			ip->i_d.di_flags |= di_flags;
 		}
 		/* FALLTHROUGH */
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.h	2007-06-20 17:53:35.609470968 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.h	2007-06-29 11:36:43.236506638 +1000
@@ -63,6 +63,7 @@ struct xfs_bmbt_irec;
 struct xfs_bmap_free;
 struct xfs_extdelta;
 struct xfs_swapext;
+struct xfs_mru_cache;
 
 extern struct bhv_vfsops xfs_vfsops;
 extern struct bhv_vnodeops xfs_vnodeops;
@@ -431,6 +432,7 @@ typedef struct xfs_mount {
 	struct notifier_block	m_icsb_notifier; /* hotplug cpu notifier */
 	struct mutex		m_icsb_mutex;	/* balancer sync lock */
 #endif
+	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 } xfs_mount_t;
 
 /*
@@ -470,6 +472,8 @@ typedef struct xfs_mount {
 						 * I/O size in stat() */
 #define XFS_MOUNT_NO_PERCPU_SB	(1ULL << 23)	/* don't use per-cpu superblock
 						   counters */
+#define XFS_MOUNT_FILESTREAMS	(1ULL << 24)	/* enable the filestreams
+						   allocator */
 
 
 /*
Index: 2.6.x-xfs-new/fs/xfs/xfs_mru_cache.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mru_cache.c	2007-06-29 11:38:01.962329212 +1000
@@ -0,0 +1,608 @@
+/*
+ * Copyright (c) 2006-2007 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_mru_cache.h"
+
+/*
+ * The MRU Cache data structure consists of a data store, an array of lists and
+ * a lock to protect its internal state.  At initialisation time, the client
+ * supplies an element lifetime in milliseconds and a group count, as well as a
+ * function pointer to call when deleting elements.  A data structure for
+ * queueing up work in the form of timed callbacks is also included.
+ *
+ * The group count controls how many lists are created, and thereby how finely
+ * the elements are grouped in time.  When reaping occurs, all the elements in
+ * all the lists whose time has expired are deleted.
+ *
+ * To give an example of how this works in practice, consider a client that
+ * initialises an MRU Cache with a lifetime of ten seconds and a group count of
+ * five.  Five internal lists will be created, each representing a two second
+ * period in time.  When the first element is added, time zero for the data
+ * structure is initialised to the current time.
+ *
+ * All the elements added in the first two seconds are appended to the first
+ * list.  Elements added in the third second go into the second list, and so on.
+ * If an element is accessed at any point, it is removed from its list and
+ * inserted at the head of the current most-recently-used list.
+ *
+ * The reaper function will have nothing to do until at least twelve seconds
+ * have elapsed since the first element was added.  The reason for this is that
+ * if it were called at t=11s, there could be elements in the first list that
+ * have only been inactive for nine seconds, so it still does nothing.  If it is
+ * called anywhere between t=12 and t=14 seconds, it will delete all the
+ * elements that remain in the first list.  It's therefore possible for elements
+ * to remain in the data store even after they've been inactive for up to
+ * (t + t/g) seconds, where t is the inactive element lifetime and g is the
+ * number of groups.
+ *
+ * The above example assumes that the reaper function gets called at least once
+ * every (t/g) seconds.  If it is called less frequently, unused elements will
+ * accumulate in the reap list until the reaper function is eventually called.
+ * The current implementation uses work queue callbacks to carefully time the
+ * reaper function calls, so this should happen rarely, if at all.
+ *
+ * From a design perspective, the primary reason for the choice of a list array
+ * representing discrete time intervals is that it's only practical to reap
+ * expired elements in groups of some appreciable size.  This automatically
+ * introduces a granularity to element lifetimes, so there's no point storing an
+ * individual timeout with each element that specifies a more precise reap time.
+ * The bonus is a saving of sizeof(long) bytes of memory per element stored.
+ *
+ * The elements could have been stored in just one list, but an array of
+ * counters or pointers would need to be maintained to allow them to be divided
+ * up into discrete time groups.  More critically, the process of touching or
+ * removing an element would involve walking large portions of the entire list,
+ * which would have a detrimental effect on performance.  The additional memory
+ * requirement for the array of list heads is minimal.
+ *
+ * When an element is touched or deleted, it needs to be removed from its
+ * current list.  Doubly linked lists are used to make the list maintenance
+ * portion of these operations O(1).  Since reaper timing can be imprecise,
+ * inserts and lookups can occur when there are no free lists available.  When
+ * this happens, all the elements on the LRU list need to be migrated to the end
+ * of the reap list.  To keep the list maintenance portion of these operations
+ * O(1) also, list tails need to be accessible without walking the entire list.
+ * This is the reason why doubly linked list heads are used.
+ */
+
+/*
+ * An MRU Cache is a dynamic data structure that stores its elements in a way
+ * that allows efficient lookups, but also groups them into discrete time
+ * intervals based on insertion time.  This allows elements to be efficiently
+ * and automatically reaped after a fixed period of inactivity.
+ *
+ * When a client data pointer is stored in the MRU Cache it needs to be added to
+ * both the data store and to one of the lists.  It must also be possible to
+ * access each of these entries via the other, i.e. to:
+ *
+ *    a) Walk a list, removing the corresponding data store entry for each item.
+ *    b) Look up a data store entry, then access its list entry directly.
+ *
+ * To achieve both of these goals, each entry must contain both a list entry and
+ * a key, in addition to the user's data pointer.  Note that it's not a good
+ * idea to have the client embed one of these structures at the top of their own
+ * data structure, because inserting the same item more than once would most
+ * likely result in a loop in one of the lists.  That's a sure-fire recipe for
+ * an infinite loop in the code.
+ */
+typedef struct xfs_mru_cache_elem
+{
+	struct list_head list_node;
+	unsigned long	key;
+	void		*value;
+} xfs_mru_cache_elem_t;
+
+static kmem_zone_t		*xfs_mru_elem_zone;
+static struct workqueue_struct	*xfs_mru_reap_wq;
+
+/*
+ * When inserting, destroying or reaping, it's first necessary to update the
+ * lists relative to a particular time.  In the case of destroying, that time
+ * will be well in the future to ensure that all items are moved to the reap
+ * list.  In all other cases though, the time will be the current time.
+ *
+ * This function enters a loop, moving the contents of the LRU list to the reap
+ * list again and again until either a) the lists are all empty, or b) time zero
+ * has been advanced sufficiently to be within the immediate element lifetime.
+ *
+ * Case a) above is detected by counting how many groups are migrated and
+ * stopping when they've all been moved.  Case b) is detected by monitoring the
+ * time_zero field, which is updated as each group is migrated.
+ *
+ * The return value is the earliest time that more migration could be needed, or
+ * zero if there's no need to schedule more work because the lists are empty.
+ */
+STATIC unsigned long
+_xfs_mru_cache_migrate(
+	xfs_mru_cache_t	*mru,
+	unsigned long	now)
+{
+	unsigned int	grp;
+	unsigned int	migrated = 0;
+	struct list_head *lru_list;
+
+	/* Nothing to do if the data store is empty. */
+	if (!mru->time_zero)
+		return 0;
+
+	/* While time zero is older than the time spanned by all the lists. */
+	while (mru->time_zero <= now - mru->grp_count * mru->grp_time) {
+
+		/*
+		 * If the LRU list isn't empty, migrate its elements to the tail
+		 * of the reap list.
+		 */
+		lru_list = mru->lists + mru->lru_grp;
+		if (!list_empty(lru_list))
+			list_splice_init(lru_list, mru->reap_list.prev);
+
+		/*
+		 * Advance the LRU group number, freeing the old LRU list to
+		 * become the new MRU list; advance time zero accordingly.
+		 */
+		mru->lru_grp = (mru->lru_grp + 1) % mru->grp_count;
+		mru->time_zero += mru->grp_time;
+
+		/*
+		 * If reaping is so far behind that all the elements on all the
+		 * lists have been migrated to the reap list, it's now empty.
+		 */
+		if (++migrated == mru->grp_count) {
+			mru->lru_grp = 0;
+			mru->time_zero = 0;
+			return 0;
+		}
+	}
+
+	/* Find the first non-empty list from the LRU end. */
+	for (grp = 0; grp < mru->grp_count; grp++) {
+
+		/* Check the grp'th list from the LRU end. */
+		lru_list = mru->lists + ((mru->lru_grp + grp) % mru->grp_count);
+		if (!list_empty(lru_list))
+			return mru->time_zero +
+			       (mru->grp_count + grp) * mru->grp_time;
+	}
+
+	/* All the lists must be empty. */
+	mru->lru_grp = 0;
+	mru->time_zero = 0;
+	return 0;
+}
+
+/*
+ * When inserting or doing a lookup, an element needs to be inserted into the
+ * MRU list.  The lists must be migrated first to ensure that they're
+ * up-to-date, otherwise the new element could be given a shorter lifetime in
+ * the cache than it should.
+ */
+STATIC void
+_xfs_mru_cache_list_insert(
+	xfs_mru_cache_t		*mru,
+	xfs_mru_cache_elem_t	*elem)
+{
+	unsigned int	grp = 0;
+	unsigned long	now = jiffies;
+
+	/*
+	 * If the data store is empty, initialise time zero, leave grp set to
+	 * zero and start the work queue timer if necessary.  Otherwise, set grp
+	 * to the number of group times that have elapsed since time zero.
+	 */
+	if (!_xfs_mru_cache_migrate(mru, now)) {
+		mru->time_zero = now;
+		if (!mru->next_reap)
+			mru->next_reap = mru->grp_count * mru->grp_time;
+	} else {
+		grp = (now - mru->time_zero) / mru->grp_time;
+		grp = (mru->lru_grp + grp) % mru->grp_count;
+	}
+
+	/* Insert the element at the tail of the corresponding list. */
+	list_add_tail(&elem->list_node, mru->lists + grp);
+}
+
+/*
+ * When destroying or reaping, all the elements that were migrated to the reap
+ * list need to be deleted.  For each element this involves removing it from the
+ * data store, removing it from the reap list, calling the client's free
+ * function and deleting the element from the element zone.
+ */
+STATIC void
+_xfs_mru_cache_clear_reap_list(
+	xfs_mru_cache_t		*mru)
+{
+	xfs_mru_cache_elem_t	*elem, *next;
+	struct list_head	tmp;
+
+	INIT_LIST_HEAD(&tmp);
+	list_for_each_entry_safe(elem, next, &mru->reap_list, list_node) {
+
+		/* Remove the element from the data store. */
+		radix_tree_delete(&mru->store, elem->key);
+
+		/*
+		 * remove to temp list so it can be freed without
+		 * needing to hold the lock
+		 */
+		list_move(&elem->list_node, &tmp);
+	}
+	mutex_spinunlock(&mru->lock, 0);
+
+	list_for_each_entry_safe(elem, next, &tmp, list_node) {
+
+		/* Remove the element from the reap list. */
+		list_del_init(&elem->list_node);
+
+		/* Call the client's free function with the key and value pointer. */
+		mru->free_func(elem->key, elem->value);
+
+		/* Free the element structure. */
+		kmem_zone_free(xfs_mru_elem_zone, elem);
+	}
+
+	mutex_spinlock(&mru->lock);
+}
+
+/*
+ * We fire the reap timer every group expiry interval so
+ * we always have a reaper ready to run. This makes shutdown
+ * and flushing of the reaper easy to do. Hence we need to
+ * keep when the next reap must occur so we can determine
+ * at each interval whether there is anything we need to do.
+ */
+STATIC void
+_xfs_mru_cache_reap(
+	struct work_struct	*work)
+{
+	xfs_mru_cache_t		*mru = container_of(work, xfs_mru_cache_t, work.work);
+	unsigned long		now;
+
+	ASSERT(mru && mru->lists);
+	if (!mru || !mru->lists)
+		return;
+
+	mutex_spinlock(&mru->lock);
+	now = jiffies;
+	if (mru->reap_all ||
+	    (mru->next_reap && time_after(now, mru->next_reap))) {
+		if (mru->reap_all)
+			now += mru->grp_count * mru->grp_time * 2;
+		mru->next_reap = _xfs_mru_cache_migrate(mru, now);
+		_xfs_mru_cache_clear_reap_list(mru);
+	}
+
+	/*
+	 * the process that triggered the reap_all is responsible
+	 * for restating the periodic reap if it is required.
+	 */
+	if (!mru->reap_all)
+		queue_delayed_work(xfs_mru_reap_wq, &mru->work, mru->grp_time);
+	mru->reap_all = 0;
+	mutex_spinunlock(&mru->lock, 0);
+}
+
+int
+xfs_mru_cache_init(void)
+{
+	xfs_mru_elem_zone = kmem_zone_init(sizeof(xfs_mru_cache_elem_t),
+	                                 "xfs_mru_cache_elem");
+	if (!xfs_mru_elem_zone)
+		return ENOMEM;
+
+	xfs_mru_reap_wq = create_singlethread_workqueue("xfs_mru_cache");
+	if (!xfs_mru_reap_wq) {
+		kmem_zone_destroy(xfs_mru_elem_zone);
+		return ENOMEM;
+	}
+
+	return 0;
+}
+
+void
+xfs_mru_cache_uninit(void)
+{
+	destroy_workqueue(xfs_mru_reap_wq);
+	kmem_zone_destroy(xfs_mru_elem_zone);
+}
+
+/*
+ * To initialise a struct xfs_mru_cache pointer, call xfs_mru_cache_create()
+ * with the address of the pointer, a lifetime value in milliseconds, a group
+ * count and a free function to use when deleting elements.  This function
+ * returns 0 if the initialisation was successful.
+ */
+int
+xfs_mru_cache_create(
+	xfs_mru_cache_t		**mrup,
+	unsigned int		lifetime_ms,
+	unsigned int		grp_count,
+	xfs_mru_cache_free_func_t free_func)
+{
+	xfs_mru_cache_t	*mru = NULL;
+	int		err = 0, grp;
+	unsigned int	grp_time;
+
+	if (mrup)
+		*mrup = NULL;
+
+	if (!mrup || !grp_count || !lifetime_ms || !free_func)
+		return EINVAL;
+
+	if (!(grp_time = msecs_to_jiffies(lifetime_ms) / grp_count))
+		return EINVAL;
+
+	if (!(mru = kmem_zalloc(sizeof(*mru), KM_SLEEP)))
+		return ENOMEM;
+
+	/* An extra list is needed to avoid reaping up to a grp_time early. */
+	mru->grp_count = grp_count + 1;
+	mru->lists = kmem_alloc(mru->grp_count * sizeof(*mru->lists), KM_SLEEP);
+
+	if (!mru->lists) {
+		err = ENOMEM;
+		goto exit;
+	}
+
+	for (grp = 0; grp < mru->grp_count; grp++)
+		INIT_LIST_HEAD(mru->lists + grp);
+
+	/*
+	 * We use GFP_KERNEL radix tree preload and do inserts under a
+	 * spinlock so GFP_ATOMIC is appropriate for the radix tree itself.
+	 */
+	INIT_RADIX_TREE(&mru->store, GFP_ATOMIC);
+	INIT_LIST_HEAD(&mru->reap_list);
+	spinlock_init(&mru->lock, "xfs_mru_cache");
+	INIT_DELAYED_WORK(&mru->work, _xfs_mru_cache_reap);
+
+	mru->grp_time  = grp_time;
+	mru->free_func = free_func;
+
+	/* start up the reaper event */
+	mru->next_reap = 0;
+	mru->reap_all = 0;
+	queue_delayed_work(xfs_mru_reap_wq, &mru->work, mru->grp_time);
+
+	*mrup = mru;
+
+exit:
+	if (err && mru && mru->lists)
+		kmem_free(mru->lists, mru->grp_count * sizeof(*mru->lists));
+	if (err && mru)
+		kmem_free(mru, sizeof(*mru));
+
+	return err;
+}
+
+/*
+ * Call xfs_mru_cache_flush() to flush out all cached entries, calling their
+ * free functions as they're deleted.  When this function returns, the caller is
+ * guaranteed that all the free functions for all the elements have finished
+ * executing.
+ *
+ * While we are flushing, we stop the periodic reaper event from triggering.
+ * Normally, we want to restart this periodic event, but if we are shutting
+ * down the cache we do not want it restarted. hence the restart parameter
+ * where 0 = do not restart reaper and 1 = restart reaper.
+ */
+void
+xfs_mru_cache_flush(
+	xfs_mru_cache_t		*mru,
+	int			restart)
+{
+	if (!mru || !mru->lists)
+		return;
+
+	cancel_rearming_delayed_workqueue(xfs_mru_reap_wq, &mru->work);
+
+	mutex_spinlock(&mru->lock);
+	mru->reap_all = 1;
+	mutex_spinunlock(&mru->lock, 0);
+
+	queue_work(xfs_mru_reap_wq, &mru->work.work);
+	flush_workqueue(xfs_mru_reap_wq);
+
+	mutex_spinlock(&mru->lock);
+	WARN_ON_ONCE(mru->reap_all != 0);
+	mru->reap_all = 0;
+	if (restart)
+		queue_delayed_work(xfs_mru_reap_wq, &mru->work, mru->grp_time);
+	mutex_spinunlock(&mru->lock, 0);
+}
+
+void
+xfs_mru_cache_destroy(
+	xfs_mru_cache_t		*mru)
+{
+	if (!mru || !mru->lists)
+		return;
+
+	/* we don't want the reaper to restart here */
+	xfs_mru_cache_flush(mru, 0);
+
+	kmem_free(mru->lists, mru->grp_count * sizeof(*mru->lists));
+	kmem_free(mru, sizeof(*mru));
+}
+
+/*
+ * To insert an element, call xfs_mru_cache_insert() with the data store, the
+ * element's key and the client data pointer.  This function returns 0 on
+ * success or ENOMEM if memory for the data element couldn't be allocated.
+ */
+int
+xfs_mru_cache_insert(
+	xfs_mru_cache_t	*mru,
+	unsigned long	key,
+	void		*value)
+{
+	xfs_mru_cache_elem_t *elem;
+
+	ASSERT(mru && mru->lists);
+	if (!mru || !mru->lists)
+		return EINVAL;
+
+	elem = kmem_zone_zalloc(xfs_mru_elem_zone, KM_SLEEP);
+	if (!elem)
+		return ENOMEM;
+
+	if (radix_tree_preload(GFP_KERNEL)) {
+		kmem_zone_free(xfs_mru_elem_zone, elem);
+		return ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&elem->list_node);
+	elem->key = key;
+	elem->value = value;
+
+	mutex_spinlock(&mru->lock);
+
+	radix_tree_insert(&mru->store, key, elem);
+	radix_tree_preload_end();
+	_xfs_mru_cache_list_insert(mru, elem);
+
+	mutex_spinunlock(&mru->lock, 0);
+
+	return 0;
+}
+
+/*
+ * To remove an element without calling the free function, call
+ * xfs_mru_cache_remove() with the data store and the element's key.  On success
+ * the client data pointer for the removed element is returned, otherwise this
+ * function will return a NULL pointer.
+ */
+void *
+xfs_mru_cache_remove(
+	xfs_mru_cache_t	*mru,
+	unsigned long	key)
+{
+	xfs_mru_cache_elem_t *elem;
+	void		*value = NULL;
+
+	ASSERT(mru && mru->lists);
+	if (!mru || !mru->lists)
+		return NULL;
+
+	mutex_spinlock(&mru->lock);
+	elem = radix_tree_delete(&mru->store, key);
+	if (elem) {
+		value = elem->value;
+		list_del(&elem->list_node);
+	}
+
+	mutex_spinunlock(&mru->lock, 0);
+
+	if (elem)
+		kmem_zone_free(xfs_mru_elem_zone, elem);
+
+	return value;
+}
+
+/*
+ * To remove and element and call the free function, call xfs_mru_cache_delete()
+ * with the data store and the element's key.
+ */
+void
+xfs_mru_cache_delete(
+	xfs_mru_cache_t	*mru,
+	unsigned long	key)
+{
+	void		*value = xfs_mru_cache_remove(mru, key);
+
+	if (value)
+		mru->free_func(key, value);
+}
+
+/*
+ * To look up an element using its key, call xfs_mru_cache_lookup() with the
+ * data store and the element's key.  If found, the element will be moved to the
+ * head of the MRU list to indicate that it's been touched.
+ *
+ * The internal data structures are protected by a spinlock that is STILL HELD
+ * when this function returns.  Call xfs_mru_cache_done() to release it.  Note
+ * that it is not safe to call any function that might sleep in the interim.
+ *
+ * The implementation could have used reference counting to avoid this
+ * restriction, but since most clients simply want to get, set or test a member
+ * of the returned data structure, the extra per-element memory isn't warranted.
+ *
+ * If the element isn't found, this function returns NULL and the spinlock is
+ * released.  xfs_mru_cache_done() should NOT be called when this occurs.
+ */
+void *
+xfs_mru_cache_lookup(
+	xfs_mru_cache_t	*mru,
+	unsigned long	key)
+{
+	xfs_mru_cache_elem_t *elem;
+
+	ASSERT(mru && mru->lists);
+	if (!mru || !mru->lists)
+		return NULL;
+
+	mutex_spinlock(&mru->lock);
+	elem = radix_tree_lookup(&mru->store, key);
+	if (elem) {
+		list_del(&elem->list_node);
+		_xfs_mru_cache_list_insert(mru, elem);
+	}
+	else
+		mutex_spinunlock(&mru->lock, 0);
+
+	return elem ? elem->value : NULL;
+}
+
+/*
+ * To look up an element using its key, but leave its location in the internal
+ * lists alone, call xfs_mru_cache_peek().  If the element isn't found, this
+ * function returns NULL.
+ *
+ * See the comments above the declaration of the xfs_mru_cache_lookup() function
+ * for important locking information pertaining to this call.
+ */
+void *
+xfs_mru_cache_peek(
+	xfs_mru_cache_t	*mru,
+	unsigned long	key)
+{
+	xfs_mru_cache_elem_t *elem;
+
+	ASSERT(mru && mru->lists);
+	if (!mru || !mru->lists)
+		return NULL;
+
+	mutex_spinlock(&mru->lock);
+	elem = radix_tree_lookup(&mru->store, key);
+	if (!elem)
+		mutex_spinunlock(&mru->lock, 0);
+
+	return elem ? elem->value : NULL;
+}
+
+/*
+ * To release the internal data structure spinlock after having performed an
+ * xfs_mru_cache_lookup() or an xfs_mru_cache_peek(), call xfs_mru_cache_done()
+ * with the data store pointer.
+ */
+void
+xfs_mru_cache_done(
+	xfs_mru_cache_t	*mru)
+{
+	mutex_spinunlock(&mru->lock, 0);
+}
Index: 2.6.x-xfs-new/fs/xfs/xfs_mru_cache.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mru_cache.h	2007-06-29 11:38:01.966328695 +1000
@@ -0,0 +1,57 @@
+/*
+ * Copyright (c) 2006-2007 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_MRU_CACHE_H__
+#define __XFS_MRU_CACHE_H__
+
+
+/* Function pointer type for callback to free a client's data pointer. */
+typedef void (*xfs_mru_cache_free_func_t)(unsigned long, void*);
+
+typedef struct xfs_mru_cache
+{
+	struct radix_tree_root	store;     /* Core storage data structure.  */
+	struct list_head	*lists;    /* Array of lists, one per grp.  */
+	struct list_head	reap_list; /* Elements overdue for reaping. */
+	spinlock_t		lock;      /* Lock to protect this struct.  */
+	unsigned int		grp_count; /* Number of discrete groups.    */
+	unsigned int		grp_time;  /* Time period spanned by grps.  */
+	unsigned int		lru_grp;   /* Group containing time zero.   */
+	unsigned long		time_zero; /* Time first element was added. */
+	unsigned long		next_reap; /* Time that the reaper should
+					      next do something. */
+	unsigned int		reap_all;  /* if set, reap all lists */
+	xfs_mru_cache_free_func_t free_func; /* Function pointer for freeing. */
+	struct delayed_work	work;      /* Workqueue data for reaping.   */
+} xfs_mru_cache_t;
+
+int xfs_mru_cache_init(void);
+void xfs_mru_cache_uninit(void);
+int xfs_mru_cache_create(struct xfs_mru_cache **mrup, unsigned int lifetime_ms,
+			     unsigned int grp_count,
+			     xfs_mru_cache_free_func_t free_func);
+void xfs_mru_cache_flush(xfs_mru_cache_t *mru, int restart);
+void xfs_mru_cache_destroy(struct xfs_mru_cache *mru);
+int xfs_mru_cache_insert(struct xfs_mru_cache *mru, unsigned long key,
+				void *value);
+void * xfs_mru_cache_remove(struct xfs_mru_cache *mru, unsigned long key);
+void xfs_mru_cache_delete(struct xfs_mru_cache *mru, unsigned long key);
+void *xfs_mru_cache_lookup(struct xfs_mru_cache *mru, unsigned long key);
+void *xfs_mru_cache_peek(struct xfs_mru_cache *mru, unsigned long key);
+void xfs_mru_cache_done(struct xfs_mru_cache *mru);
+
+#endif /* __XFS_MRU_CACHE_H__ */
Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2007-06-20 17:53:27.630508068 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2007-06-29 11:36:43.660451835 +1000
@@ -51,6 +51,8 @@
 #include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_clnt.h"
+#include "xfs_mru_cache.h"
+#include "xfs_filestream.h"
 #include "xfs_fsops.h"
 
 STATIC int	xfs_sync(bhv_desc_t *, int, cred_t *);
@@ -81,6 +83,8 @@ xfs_init(void)
 	xfs_dabuf_zone = kmem_zone_init(sizeof(xfs_dabuf_t), "xfs_dabuf");
 	xfs_ifork_zone = kmem_zone_init(sizeof(xfs_ifork_t), "xfs_ifork");
 	xfs_acl_zone_init(xfs_acl_zone, "xfs_acl");
+	xfs_mru_cache_init();
+	xfs_filestream_init();
 
 	/*
 	 * The size of the zone allocated buf log item is the maximum
@@ -164,6 +168,8 @@ xfs_cleanup(void)
 	xfs_cleanup_procfs();
 	xfs_sysctl_unregister();
 	xfs_refcache_destroy();
+	xfs_filestream_uninit();
+	xfs_mru_cache_uninit();
 	xfs_acl_zone_destroy(xfs_acl_zone);
 
 #ifdef XFS_DIR2_TRACE
@@ -317,6 +323,9 @@ xfs_start_flags(
 	else
 		mp->m_flags &= ~XFS_MOUNT_BARRIER;
 
+	if (ap->flags2 & XFSMNT2_FILESTREAMS)
+		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
+
 	return 0;
 }
 
@@ -515,6 +524,9 @@ xfs_mount(
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
 		xfs_mountfs_check_barriers(mp);
 
+	if ((error = xfs_filestream_mount(mp)))
+		goto error2;
+
 	error = XFS_IOINIT(vfsp, args, flags);
 	if (error)
 		goto error2;
@@ -572,6 +584,13 @@ xfs_unmount(
 	 */
 	xfs_refcache_purge_mp(mp);
 
+	/*
+	 * Blow away any referenced inode in the filestreams cache.
+	 * This can and will cause log traffic as inodes go inactive
+	 * here.
+	 */
+	xfs_filestream_unmount(mp);
+
 	XFS_bflush(mp->m_ddev_targp);
 	error = xfs_unmount_flush(mp, 0);
 	if (error)
@@ -703,6 +722,7 @@ xfs_mntupdate(
 			mp->m_flags &= ~XFS_MOUNT_BARRIER;
 		}
 	} else if (!(vfsp->vfs_flag & VFS_RDONLY)) {	/* rw -> ro */
+		xfs_filestream_flush(mp);
 		bhv_vfs_sync(vfsp, SYNC_DATA_QUIESCE, NULL);
 		xfs_attr_quiesce(mp);
 		vfsp->vfs_flag |= VFS_RDONLY;
@@ -927,6 +947,9 @@ xfs_sync(
 {
 	xfs_mount_t	*mp = XFS_BHVTOM(bdp);
 
+	if (flags & SYNC_IOWAIT)
+		xfs_filestream_flush(mp);
+
 	return xfs_syncsub(mp, flags, NULL);
 }
 
@@ -1676,6 +1699,7 @@ xfs_vget(
 					 * in stat(). */
 #define MNTOPT_ATTR2	"attr2"		/* do use attr2 attribute format */
 #define MNTOPT_NOATTR2	"noattr2"	/* do not use attr2 attribute format */
+#define MNTOPT_FILESTREAM  "filestreams" /* use filestreams allocator */
 
 STATIC unsigned long
 suffix_strtoul(char *s, char **endp, unsigned int base)
@@ -1853,6 +1877,8 @@ xfs_parseargs(
 			args->flags |= XFSMNT_ATTR2;
 		} else if (!strcmp(this_char, MNTOPT_NOATTR2)) {
 			args->flags &= ~XFSMNT_ATTR2;
+		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
+			args->flags2 |= XFSMNT2_FILESTREAMS;
 		} else if (!strcmp(this_char, "osyncisdsync")) {
 			/* no-op, this is now the default */
 			cmn_err(CE_WARN,
Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2007-06-20 17:53:36.657334767 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2007-06-29 11:38:01.966328695 +1000
@@ -51,6 +51,7 @@
 #include "xfs_refcache.h"
 #include "xfs_trans_space.h"
 #include "xfs_log_priv.h"
+#include "xfs_filestream.h"
 
 STATIC int
 xfs_open(
@@ -789,6 +790,8 @@ xfs_setattr(
 				di_flags |= XFS_DIFLAG_PROJINHERIT;
 			if (vap->va_xflags & XFS_XFLAG_NODEFRAG)
 				di_flags |= XFS_DIFLAG_NODEFRAG;
+			if (vap->va_xflags & XFS_XFLAG_FILESTREAM)
+				di_flags |= XFS_DIFLAG_FILESTREAM;
 			if ((ip->i_d.di_mode & S_IFMT) == S_IFDIR) {
 				if (vap->va_xflags & XFS_XFLAG_RTINHERIT)
 					di_flags |= XFS_DIFLAG_RTINHERIT;
@@ -1542,7 +1545,17 @@ xfs_release(
 	if (vp->v_vfsp->vfs_flag & VFS_RDONLY)
 		return 0;
 
-	if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+	if (!XFS_FORCED_SHUTDOWN(mp)) {
+		/*
+		 * If we are using filestreams, and we have an unlinked
+		 * file that we are processing the last close on, then nothing
+		 * will be able to reopen and write to this file. Purge this
+		 * inode from the filestreams cache so that it doesn't delay
+		 * teardown of the inode.
+		 */
+		if ((ip->i_d.di_nlink == 0) && xfs_inode_is_filestream(ip))
+			xfs_filestream_deassociate(ip);
+
 		/*
 		 * If we previously truncated this file and removed old data
 		 * in the process, we want to initiate "early" writeout on
@@ -1557,7 +1570,6 @@ xfs_release(
 			bhv_vop_flush_pages(vp, 0, -1, XFS_B_ASYNC, FI_NONE);
 	}
 
-
 #ifdef HAVE_REFCACHE
 	/* If we are in the NFS reference cache then don't do this now */
 	if (ip->i_refcache)
@@ -2551,6 +2563,15 @@ xfs_remove(
 	 */
 	xfs_refcache_purge_ip(ip);
 
+	/*
+	 * If we are using filestreams, kill the stream association.
+	 * If the file is still open it may get a new one but that
+	 * will get killed on last close in xfs_close() so we don't
+	 * have to worry about that.
+	 */
+	if (link_zero && xfs_inode_is_filestream(ip))
+		xfs_filestream_deassociate(ip);
+
 	vn_trace_exit(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
 
 	/*
Index: 2.6.x-xfs-new/fs/xfs/xfs.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs.h	2007-06-20 16:35:45.276343092 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs.h	2007-06-20 17:59:35.054768459 +1000
@@ -38,6 +38,7 @@
 #define XFS_RW_TRACE 1
 #define XFS_BUF_TRACE 1
 #define XFS_VNODE_TRACE 1
+#define XFS_FILESTREAMS_TRACE 1
 #endif
 
 #include <linux/version.h>
Index: 2.6.x-xfs-new/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2007-06-20 17:53:35.661464210 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2007-06-20 17:59:35.058767939 +1000
@@ -63,6 +63,7 @@
 #include "quota/xfs_qm.h"
 #include "xfs_iomap.h"
 #include "xfs_buf.h"
+#include "xfs_filestream.h"
 
 MODULE_AUTHOR("Silicon Graphics, Inc.");
 MODULE_DESCRIPTION("Additional kdb commands for debugging XFS");
@@ -109,6 +110,9 @@ static void	xfsidbg_xlog_granttrace(xlog
 #ifdef XFS_DQUOT_TRACE
 static void	xfsidbg_xqm_dqtrace(xfs_dquot_t *);
 #endif
+#ifdef XFS_FILESTREAMS_TRACE
+static void	xfsidbg_filestreams_trace(int);
+#endif
 
 
 /*
@@ -196,6 +200,9 @@ static int	xfs_bmbt_trace_entry(ktrace_e
 #ifdef XFS_DIR2_TRACE
 static int	xfs_dir2_trace_entry(ktrace_entry_t *ktep);
 #endif
+#ifdef XFS_FILESTREAMS_TRACE
+static void	xfs_filestreams_trace_entry(ktrace_entry_t *ktep);
+#endif
 #ifdef XFS_RW_TRACE
 static void	xfs_bunmap_trace_entry(ktrace_entry_t   *ktep);
 static void	xfs_rw_enter_trace_entry(ktrace_entry_t *ktep);
@@ -760,6 +767,27 @@ static int	kdbm_xfs_xalttrace(
 }
 #endif /* XFS_ALLOC_TRACE */
 
+#ifdef XFS_FILESTREAMS_TRACE
+static int	kdbm_xfs_xfstrmtrace(
+	int	argc,
+	const char **argv)
+{
+	unsigned long addr;
+	int nextarg = 1;
+	long offset = 0;
+	int diag;
+
+	if (argc != 1)
+		return KDB_ARGCOUNT;
+	diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
+	if (diag)
+		return diag;
+
+	xfsidbg_filestreams_trace((int) addr);
+	return 0;
+}
+#endif /* XFS_FILESTREAMS_TRACE */
+
 static int	kdbm_xfs_xattrcontext(
 	int	argc,
 	const char **argv)
@@ -2615,6 +2643,10 @@ static struct xif xfsidbg_funcs[] = {
 				"Dump XFS bmap extents in inode"},
   {  "xflist",	kdbm_xfs_xflist,	"<xfs_bmap_free_t>",
 				"Dump XFS to-be-freed extent records"},
+#ifdef XFS_FILESTREAMS_TRACE
+  {  "xfstrmtrc",kdbm_xfs_xfstrmtrace,	"",
+				"Dump filestreams trace buffer"},
+#endif
   {  "xhelp",	kdbm_xfs_xhelp,		"",
 				"Print idbg-xfs help"},
   {  "xicall",	kdbm_xfs_xiclogall,	"<xlog_in_core_t>",
@@ -5279,6 +5311,162 @@ xfsidbg_xailock_trace(int count)
 }
 #endif
 
+#ifdef XFS_FILESTREAMS_TRACE
+static void
+xfs_filestreams_trace_entry(ktrace_entry_t *ktep)
+{
+	xfs_inode_t	*ip, *pip;
+
+	/* function:line#[pid]: */
+	kdb_printf("%s:%lu[%lu]: ", (char *)ktep->val[1],
+			((unsigned long)ktep->val[0] >> 16) & 0xffff,
+			(unsigned long)ktep->val[2]);
+	switch ((unsigned long)ktep->val[0] & 0xffff) {
+	case XFS_FSTRM_KTRACE_INFO:
+		break;
+	case XFS_FSTRM_KTRACE_AGSCAN:
+		kdb_printf("scanning AG %ld[%ld]",
+				(long)ktep->val[4], (long)ktep->val[5]);
+		break;
+	case XFS_FSTRM_KTRACE_AGPICK1:
+		kdb_printf("using max_ag %ld[1] with maxfree %ld",
+				(long)ktep->val[4], (long)ktep->val[5]);
+		break;
+	case XFS_FSTRM_KTRACE_AGPICK2:
+
+		kdb_printf("startag %ld newag %ld[%ld] free %ld scanned %ld"
+				" flags 0x%lx",
+				(long)ktep->val[4], (long)ktep->val[5],
+				(long)ktep->val[6], (long)ktep->val[7],
+				(long)ktep->val[8], (long)ktep->val[9]);
+		break;
+	case XFS_FSTRM_KTRACE_UPDATE:
+		ip = (xfs_inode_t *)ktep->val[4];
+		if ((__psint_t)ktep->val[5] != (__psint_t)ktep->val[7])
+			kdb_printf("found ip %p ino %llu, AG %ld[%ld] ->"
+				" %ld[%ld]", ip, (unsigned long long)ip->i_ino,
+				(long)ktep->val[7], (long)ktep->val[8],
+				(long)ktep->val[5], (long)ktep->val[6]);
+		else
+			kdb_printf("found ip %p ino %llu, AG %ld[%ld]",
+				ip, (unsigned long long)ip->i_ino,
+				(long)ktep->val[5], (long)ktep->val[6]);
+		break;
+
+	case XFS_FSTRM_KTRACE_FREE:
+		ip = (xfs_inode_t *)ktep->val[4];
+		pip = (xfs_inode_t *)ktep->val[5];
+		if (ip->i_d.di_mode & S_IFDIR)
+			kdb_printf("deleting dip %p ino %llu, AG %ld[%ld]",
+			       ip, (unsigned long long)ip->i_ino,
+			       (long)ktep->val[6], (long)ktep->val[7]);
+		else
+			kdb_printf("deleting file %p ino %llu, pip %p ino %llu"
+				", AG %ld[%ld]",
+				ip, (unsigned long long)ip->i_ino,
+				pip, (unsigned long long)(pip ?  pip->i_ino : 0),
+				(long)ktep->val[6], (long)ktep->val[7]);
+		break;
+
+	case XFS_FSTRM_KTRACE_ITEM_LOOKUP:
+		ip = (xfs_inode_t *)ktep->val[4];
+		pip = (xfs_inode_t *)ktep->val[5];
+		if (!pip) {
+			kdb_printf("lookup on %s ip %p ino %llu failed, returning %ld",
+			       ip->i_d.di_mode & S_IFREG ? "file" : "dir", ip,
+			       (unsigned long long)ip->i_ino, (long)ktep->val[6]);
+		} else if (ip->i_d.di_mode & S_IFREG)
+			kdb_printf("lookup on file ip %p ino %llu dir %p"
+				" dino %llu got AG %ld[%ld]",
+				ip, (unsigned long long)ip->i_ino,
+				pip, (unsigned long long)pip->i_ino,
+				(long)ktep->val[6], (long)ktep->val[7]);
+		else
+			kdb_printf("lookup on dir ip %p ino %llu got AG %ld[%ld]",
+				ip, (unsigned long long)ip->i_ino,
+				(long)ktep->val[6], (long)ktep->val[7]);
+		break;
+
+	case XFS_FSTRM_KTRACE_ASSOCIATE:
+		ip = (xfs_inode_t *)ktep->val[4];
+		pip = (xfs_inode_t *)ktep->val[5];
+		kdb_printf("pip %p ino %llu and ip %p ino %llu given ag %ld[%ld]",
+				pip, (unsigned long long)pip->i_ino,
+				ip, (unsigned long long)ip->i_ino,
+				(long)ktep->val[6], (long)ktep->val[7]);
+		break;
+
+	case XFS_FSTRM_KTRACE_MOVEAG:
+		ip = ktep->val[4];
+		pip = ktep->val[5];
+		if ((long)ktep->val[6] != NULLAGNUMBER)
+			kdb_printf("dir %p ino %llu to file ip %p ino %llu has"
+				" moved %ld[%ld] -> %ld[%ld]",
+				pip, (unsigned long long)pip->i_ino,
+				ip, (unsigned long long)ip->i_ino,
+				(long)ktep->val[6], (long)ktep->val[7],
+				(long)ktep->val[8], (long)ktep->val[9]);
+		else
+			kdb_printf("pip %p ino %llu and ip %p ino %llu moved"
+				" to new ag %ld[%ld]",
+				pip, (unsigned long long)pip->i_ino,
+				ip, (unsigned long long)ip->i_ino,
+				(long)ktep->val[8], (long)ktep->val[9]);
+		break;
+
+	case XFS_FSTRM_KTRACE_ORPHAN:
+		ip = ktep->val[4];
+		kdb_printf("gave ag %lld to orphan ip %p ino %llu",
+				(__psint_t)ktep->val[5],
+				ip, (unsigned long long)ip->i_ino);
+		break;
+	default:
+		kdb_printf("unknown trace type 0x%lx",
+				(unsigned long)ktep->val[0] & 0xffff);
+	}
+	kdb_printf("\n");
+}
+
+static void
+xfsidbg_filestreams_trace(int count)
+{
+	ktrace_entry_t  *ktep;
+	ktrace_snap_t   kts;
+	int	     nentries;
+	int	     skip_entries;
+
+	if (xfs_filestreams_trace_buf == NULL) {
+		qprintf("The xfs inode lock trace buffer is not initialized\n");
+		return;
+	}
+	nentries = ktrace_nentries(xfs_filestreams_trace_buf);
+	if (count == -1) {
+		count = nentries;
+	}
+	if ((count <= 0) || (count > nentries)) {
+		qprintf("Invalid count.  There are %d entries.\n", nentries);
+		return;
+	}
+
+	ktep = ktrace_first(xfs_filestreams_trace_buf, &kts);
+	if (count != nentries) {
+		/*
+		 * Skip the total minus the number to look at minus one
+		 * for the entry returned by ktrace_first().
+		 */
+		skip_entries = nentries - count - 1;
+		ktep = ktrace_skip(xfs_filestreams_trace_buf, skip_entries, &kts);
+		if (ktep == NULL) {
+			qprintf("Skipped them all\n");
+			return;
+		}
+	}
+	while (ktep != NULL) {
+		xfs_filestreams_trace_entry(ktep);
+		ktep = ktrace_next(xfs_filestreams_trace_buf, &kts);
+	}
+}
+#endif
 /*
  * Compute & print buffer's checksum.
  */
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.h	2007-06-20 17:53:27.342545497 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.h	2007-06-29 11:36:40.812819943 +1000
@@ -350,6 +350,7 @@ xfs_iflags_test(xfs_inode_t *ip, unsigne
 #define XFS_ISTALE	0x0010	/* inode has been staled */
 #define XFS_IRECLAIMABLE 0x0020 /* inode can be reclaimed */
 #define XFS_INEW	0x0040
+#define XFS_IFILESTREAM	0x0080	/* inode is in a filestream directory */
 
 /*
  * Flags for inode locking.

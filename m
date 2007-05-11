Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 May 2007 17:36:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4B0aEfB001875
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 17:36:16 -0700
Date: Fri, 11 May 2007 10:36:07 +1000
From: David Chinner <dgc@sgi.com>
Subject: Review: Concurrent Multi-File Data Streams
Message-ID: <20070511003606.GB85884050@sgi.com>
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

The following patch survives XFSQA with timeouts set to minimum,
default, 500s and maximum. The patch has not had a great
deal of low memory testing, and the object cache may need a shrinker
interface to work in low memory conditions.

Comments?

Credits: The original filestream allocator on Irix was written by
Glen Overby, the Linux port and rewrite by Nathan Scott and Sam
Vaughan (none of whom work at SGI any more). I just picked the pieces
and beat it repeatedly with a big stick until it passed XFSQA.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/Makefile-linux-2.6      |    2 
 fs/xfs/linux-2.6/xfs_globals.c |    1 
 fs/xfs/linux-2.6/xfs_linux.h   |    1 
 fs/xfs/linux-2.6/xfs_sysctl.c  |   11 
 fs/xfs/linux-2.6/xfs_sysctl.h  |    2 
 fs/xfs/quota/xfs_qm.c          |    3 
 fs/xfs/xfs_ag.h                |    1 
 fs/xfs/xfs_bmap.c              |  337 +++++++++++++++++
 fs/xfs/xfs_clnt.h              |    2 
 fs/xfs/xfs_dinode.h            |    4 
 fs/xfs/xfs_filestream.c        |  777 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_filestream.h        |   59 +++
 fs/xfs/xfs_fs.h                |    1 
 fs/xfs/xfs_fsops.c             |    2 
 fs/xfs/xfs_inode.c             |   17 
 fs/xfs/xfs_mount.c             |   11 
 fs/xfs/xfs_mount.h             |    4 
 fs/xfs/xfs_mru_cache.c         |  607 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mru_cache.h         |  225 +++++++++++
 fs/xfs/xfs_vfsops.c            |   25 +
 fs/xfs/xfs_vnodeops.c          |   28 +
 21 files changed, 2114 insertions(+), 6 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/Makefile-linux-2.6
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/Makefile-linux-2.6	2007-05-10 17:22:43.486754830 +1000
+++ 2.6.x-xfs-new/fs/xfs/Makefile-linux-2.6	2007-05-10 17:24:12.975025602 +1000
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
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_globals.c	2007-05-10 17:22:43.486754830 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_globals.c	2007-05-10 17:24:12.987024029 +1000
@@ -49,6 +49,7 @@ xfs_param_t xfs_params = {
 	.inherit_nosym	= {	0,		0,		1	},
 	.rotorstep	= {	1,		1,		255	},
 	.inherit_nodfrg	= {	0,		1,		1	},
+	.fstrm_timer	= {	1,		50,		3600*100},
 };
 
 /*
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_linux.h	2007-05-10 17:22:43.486754830 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_linux.h	2007-05-10 17:24:12.991023505 +1000
@@ -132,6 +132,7 @@
 #define xfs_inherit_nosymlinks	xfs_params.inherit_nosym.val
 #define xfs_rotorstep		xfs_params.rotorstep.val
 #define xfs_inherit_nodefrag	xfs_params.inherit_nodfrg.val
+#define xfs_fstrm_centisecs	xfs_params.fstrm_timer.val
 
 #define current_cpu()		(raw_smp_processor_id())
 #define current_pid()		(current->pid)
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_sysctl.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_sysctl.c	2007-05-10 17:22:43.486754830 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_sysctl.c	2007-05-10 17:24:12.991023505 +1000
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
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_sysctl.h	2007-05-10 17:22:43.486754830 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_sysctl.h	2007-05-10 17:24:12.991023505 +1000
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
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ag.h	2007-05-10 17:22:43.494753782 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_ag.h	2007-05-10 17:24:12.995022981 +1000
@@ -196,6 +196,7 @@ typedef struct xfs_perag
 	lock_t		pagb_lock;	/* lock for pagb_list */
 #endif
 	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
+	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
 
 	/*
 	 * inode allocation search lookup optimisation.
Index: 2.6.x-xfs-new/fs/xfs/xfs_bmap.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bmap.c	2007-05-10 17:22:43.494753782 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_bmap.c	2007-05-10 17:24:13.011020884 +1000
@@ -52,6 +52,7 @@
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_buf_item.h"
+#include "xfs_filestream.h"
 
 
 #ifdef DEBUG
@@ -171,6 +172,14 @@ xfs_bmap_alloc(
 	xfs_bmalloca_t		*ap);	/* bmap alloc argument struct */
 
 /*
+ * xfs_bmap_filestreams is the underlying allocator when filestreams are
+ * enabled.
+ */
+STATIC int				/* error */
+xfs_bmap_filestreams(
+	xfs_bmalloca_t		*ap);	/* bmap alloc argument struct */
+
+/*
  * Transform a btree format file with only one leaf node, where the
  * extents list will fit in the inode, into an extents format file.
  * Since the file extents are already in-core, all we have to do is
@@ -2968,10 +2977,338 @@ xfs_bmap_alloc(
 {
 	if ((ap->ip->i_d.di_flags & XFS_DIFLAG_REALTIME) && ap->userdata)
 		return xfs_bmap_rtalloc(ap);
+	if ((ap->ip->i_mount->m_flags & XFS_MOUNT_FILESTREAMS) ||
+	    (ap->ip->i_d.di_flags & XFS_DIFLAG_FILESTREAM))
+		return xfs_bmap_filestreams(ap);
 	return xfs_bmap_btalloc(ap);
 }
 
 /*
+ * xfs_filestreams called by xfs_bmapi for multi-file data stream filesystems.
+ *
+ * Allocate files in a directory all in the same AG.  When an AG fills, pick
+ * a new AG.
+ */
+int					/* error */
+xfs_bmap_filestreams(
+	xfs_bmalloca_t	*ap)		/* bmap alloc argument struct */
+{
+	xfs_alloctype_t	atype;		/* type for allocation routines */
+	int		error;		/* error return value */
+	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
+	xfs_mount_t	*mp;		/* mount point structure */
+	int		nullfb;		/* true if ap->firstblock isn't set */
+	int		rt;		/* true if inode is realtime */
+	xfs_extlen_t	align;		/* minimum allocation alignment */
+	xfs_agnumber_t	ag;
+	xfs_alloc_arg_t	args;
+	xfs_extlen_t	blen;
+	xfs_extlen_t	delta;
+	int		isaligned;
+	xfs_extlen_t	longest;
+	xfs_extlen_t	need;
+	xfs_extlen_t	nextminlen = 0;
+	int		notinit;
+	xfs_perag_t	*pag;
+	xfs_agnumber_t	startag;
+	int		tryagain;
+
+	/*
+	 * Set up variables.
+	 */
+	mp = ap->ip->i_mount;
+	rt = (ap->ip->i_d.di_flags & XFS_DIFLAG_REALTIME) && ap->userdata;
+	align = (ap->userdata && ap->ip->i_d.di_extsize &&
+		(ap->ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)) ?
+		ap->ip->i_d.di_extsize : 0;
+	if (align) {
+		error = xfs_bmap_extsize_align(mp, ap->gotp, ap->prevp,
+						align, rt,
+						ap->eof, 0, ap->conv,
+						&ap->off, &ap->alen);
+		ASSERT(!error);
+		ASSERT(ap->alen);
+	}
+	nullfb = ap->firstblock == NULLFSBLOCK;
+	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, ap->firstblock);
+	if (nullfb) {
+		ag = xfs_filestream_get_ag(ap->ip);
+		ag = (ag != NULLAGNUMBER) ? ag : 0;
+		ap->rval = (ap->userdata) ? XFS_AGB_TO_FSB(mp, ag, 0) :
+		                            XFS_INO_TO_FSB(mp, ap->ip->i_ino);
+	} else {
+		ap->rval = ap->firstblock;
+	}
+
+	xfs_bmap_adjacent(ap);
+
+	/*
+	 * If allowed, use ap->rval; otherwise must use firstblock since
+	 * it's in the right allocation group.
+	 */
+	if (nullfb || XFS_FSB_TO_AGNO(mp, ap->rval) == fb_agno)
+		;
+	else
+		ap->rval = ap->firstblock;
+	/*
+	 * Normal allocation, done through xfs_alloc_vextent.
+	 */
+	tryagain = isaligned = 0;
+	args.tp = ap->tp;
+	args.mp = mp;
+	args.fsbno = ap->rval;
+	args.maxlen = MIN(ap->alen, mp->m_sb.sb_agblocks);
+	blen = 0;
+	if (nullfb) {
+		/* _vextent doesn't pick an AG */
+		args.type = XFS_ALLOCTYPE_NEAR_BNO;
+		args.total = ap->total;
+		/*
+		 * Find the longest available space.
+		 * We're going to try for the whole allocation at once.
+		 */
+		startag = ag = XFS_FSB_TO_AGNO(mp, args.fsbno);
+		if (startag == NULLAGNUMBER) {
+			startag = ag = 0;
+		}
+		notinit = 0;
+		/*
+		 * Search for an allocation group with a single extent
+		 * large enough for the request.
+		 *
+		 * If one isn't found, then adjust the minimum allocation
+		 * size to the largest space found.
+		 */
+		down_read(&mp->m_peraglock);
+		while (blen < ap->alen) {
+			pag = &mp->m_perag[ag];
+			if (!pag->pagf_init &&
+			    (error = xfs_alloc_pagf_init(mp, args.tp,
+				    ag, XFS_ALLOC_FLAG_TRYLOCK))) {
+				up_read(&mp->m_peraglock);
+				return error;
+			}
+			/*
+			 * See xfs_alloc_fix_freelist...
+			 */
+			if (pag->pagf_init) {
+				need = XFS_MIN_FREELIST_PAG(pag, mp);
+				delta = need > pag->pagf_flcount ?
+					need - pag->pagf_flcount : 0;
+				longest = (pag->pagf_longest > delta) ?
+					(pag->pagf_longest - delta) :
+					(pag->pagf_flcount > 0 ||
+					 pag->pagf_longest > 0);
+				if (blen < longest)
+					blen = longest;
+			} else {
+				notinit = 1;
+			}
+
+			if (blen >= ap->alen)
+				break;
+
+			if (ap->userdata) {
+				if (startag == NULLAGNUMBER) {
+					/*
+					 * If startag is an invalid AG,
+					 * we've come here once before and
+					 * xfs_filestream_new_ag picked the best
+					 * currently available.
+					 *
+					 * Don't continue looping, since we
+					 * could loop forever.
+					 */
+					break;
+				}
+
+				if ((error = xfs_filestream_new_ag(ap, &ag))) {
+					up_read(&mp->m_peraglock);
+					return error;
+				}
+
+				startag = NULLAGNUMBER;
+
+				/* Go around the loop once more to set 'blen'*/
+			} else {
+				if (++ag == mp->m_sb.sb_agcount)
+					ag = 0;
+
+				if (ag == startag)
+					break;
+			}
+		}
+		up_read(&mp->m_peraglock);
+		/*
+		 * Since the above loop did a BUF_TRYLOCK, it is
+		 * possible that there is space for this request.
+		 */
+		if (notinit || blen < ap->minlen)
+			args.minlen = ap->minlen;
+		/*
+		 * If the best seen length is less than the request
+		 * length, use the best as the minimum.
+		 */
+		else if (blen < ap->alen)
+			args.minlen = blen;
+		/*
+		 * Otherwise we've seen an extent as big as alen,
+		 * use that as the minimum.
+		 */
+		else
+			args.minlen = ap->alen;
+		ap->rval = args.fsbno = XFS_AGB_TO_FSB(mp, ag, 0);
+	} else if (ap->low) {
+		args.type = XFS_ALLOCTYPE_FIRST_AG;
+		args.total = args.minlen = ap->minlen;
+	} else {
+		args.type = XFS_ALLOCTYPE_NEAR_BNO;
+		args.total = ap->total;
+		args.minlen = ap->minlen;
+	}
+	if (ap->userdata && ap->ip->i_d.di_extsize &&
+	    (ap->ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)) {
+		args.prod = ap->ip->i_d.di_extsize;
+		if ((args.mod = (xfs_extlen_t)(do_mod(ap->off, args.prod))))
+			args.mod = (xfs_extlen_t)(args.prod - args.mod);
+	} else if (mp->m_sb.sb_blocksize >= NBPP) {
+		args.prod = 1;
+		args.mod = 0;
+	} else {
+		args.prod = NBPP >> mp->m_sb.sb_blocklog;
+		if ((args.mod = (xfs_extlen_t)(do_mod(ap->off, args.prod))))
+			args.mod = (xfs_extlen_t)(args.prod - args.mod);
+	}
+	/*
+	 * If we are not low on available data blocks, and the
+	 * underlying logical volume manager is a stripe, and
+	 * the file offset is zero then try to allocate data
+	 * blocks on stripe unit boundary.
+	 * NOTE: ap->aeof is only set if the allocation length
+	 * is >= the stripe unit and the allocation offset is
+	 * at the end of file.
+	 */
+	atype = args.type;
+	if (!ap->low && ap->aeof) {
+		if (!ap->off) {
+			args.alignment = mp->m_dalign;
+			atype = args.type;
+			isaligned = 1;
+			/*
+			 * Adjust for alignment
+			 */
+			if (blen > args.alignment && blen <= ap->alen)
+				args.minlen = blen - args.alignment;
+			args.minalignslop = 0;
+		} else {
+			/*
+		 	 * First try an exact bno allocation.
+			 * If it fails then do a near or start bno
+			 * allocation with alignment turned on.
+		 	 */
+			atype = args.type;
+			tryagain = 1;
+			args.type = XFS_ALLOCTYPE_THIS_BNO;
+			args.alignment = 1;
+			/*
+			 * Compute the minlen+alignment for the
+			 * next case.  Set slop so that the value
+			 * of minlen+alignment+slop doesn't go up
+			 * between the calls.
+			 */
+			if (blen > mp->m_dalign && blen <= ap->alen)
+				nextminlen = blen - mp->m_dalign;
+			else
+				nextminlen = args.minlen;
+			if (nextminlen + mp->m_dalign > args.minlen + 1)
+				args.minalignslop =
+					nextminlen + mp->m_dalign -
+					args.minlen - 1;
+			else
+				args.minalignslop = 0;
+		}
+	} else {
+		args.alignment = 1;
+		args.minalignslop = 0;
+	}
+	args.minleft = ap->minleft;
+	args.wasdel = ap->wasdel;
+	args.isfl = 0;
+	args.userdata = ap->userdata;
+	if ((error = xfs_alloc_vextent(&args)))
+		return error;
+	if (tryagain && args.fsbno == NULLFSBLOCK) {
+		/*
+		 * Exact allocation failed. Now try with alignment
+		 * turned on.
+		 */
+		args.type = atype;
+		args.fsbno = ap->rval;
+		args.alignment = mp->m_dalign;
+		args.minlen = nextminlen;
+		args.minalignslop = 0;
+		isaligned = 1;
+		if ((error = xfs_alloc_vextent(&args)))
+			return error;
+	}
+	if (isaligned && args.fsbno == NULLFSBLOCK) {
+		/*
+		 * allocation failed, so turn off alignment and
+		 * try again.
+		 */
+		args.type = atype;
+		args.fsbno = ap->rval;
+		args.alignment = 0;
+		if ((error = xfs_alloc_vextent(&args)))
+			return error;
+	}
+	if (args.fsbno == NULLFSBLOCK && nullfb &&
+	    args.minlen > ap->minlen) {
+		args.minlen = ap->minlen;
+		args.type = XFS_ALLOCTYPE_START_BNO;
+		args.fsbno = ap->rval;
+		if ((error = xfs_alloc_vextent(&args)))
+			return error;
+	}
+	if (args.fsbno == NULLFSBLOCK && nullfb) {
+		args.fsbno = 0;
+		args.type = XFS_ALLOCTYPE_FIRST_AG;
+		args.total = ap->minlen;
+		args.minleft = 0;
+		if ((error = xfs_alloc_vextent(&args)))
+			return error;
+		ap->low = 1;
+	}
+	if (args.fsbno != NULLFSBLOCK) {
+		ap->firstblock = ap->rval = args.fsbno;
+		ASSERT(nullfb || fb_agno == args.agno ||
+		       (ap->low && fb_agno < args.agno));
+		ap->alen = args.len;
+		ap->ip->i_d.di_nblocks += args.len;
+		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
+		if (ap->wasdel)
+			ap->ip->i_delayed_blks -= args.len;
+		/*
+		 * Adjust the disk quota also. This was reserved
+		 * earlier.
+		 */
+		if (XFS_IS_QUOTA_ON(mp) &&
+		    ap->ip->i_ino != mp->m_sb.sb_uquotino &&
+		    ap->ip->i_ino != mp->m_sb.sb_gquotino) {
+		    XFS_TRANS_MOD_DQUOT_BYINO(mp, ap->tp, ap->ip,
+				ap->wasdel ?
+					XFS_TRANS_DQ_DELBCOUNT :
+					XFS_TRANS_DQ_BCOUNT,
+				(long)args.len);
+		}
+	} else {
+		ap->rval = NULLFSBLOCK;
+		ap->alen = 0;
+	}
+	return 0;
+}
+
+/*
  * Transform a btree format file with only one leaf node, where the
  * extents list will fit in the inode, into an extents format file.
  * Since the file extents are already in-core, all we have to do is
Index: 2.6.x-xfs-new/fs/xfs/xfs_clnt.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_clnt.h	2007-05-10 17:22:43.494753782 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_clnt.h	2007-05-10 17:24:13.011020884 +1000
@@ -99,5 +99,7 @@ struct xfs_mount_args {
  */
 #define XFSMNT2_COMPAT_IOSIZE	0x00000001	/* don't report large preferred
 						 * I/O size in stat(2) */
+#define XFSMNT2_FILESTREAMS	0x00000002	/* enable the filestreams
+						 * allocator */
 
 #endif	/* __XFS_CLNT_H__ */
Index: 2.6.x-xfs-new/fs/xfs/xfs_dinode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_dinode.h	2007-05-10 17:22:43.494753782 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_dinode.h	2007-05-10 17:24:13.015020360 +1000
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
+++ 2.6.x-xfs-new/fs/xfs/xfs_filestream.c	2007-05-10 17:24:13.019019836 +1000
@@ -0,0 +1,777 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
+#ifdef DEBUG_FILESTREAMS
+#define dprint(fmt, args...) do {                    \
+        printk(KERN_DEBUG "%4d %s: " fmt "\n",       \
+               current_pid(), __FUNCTION__, ##args); \
+} while(0)
+#else
+#define dprint(args...) do {} while (0)
+#endif
+
+static kmem_zone_t *item_zone;
+
+/*
+ * Per-mount point data structure to maintain its active filestreams.  Currently
+ * only contains a single pointer, but set up and allocated as a structure to
+ * ease future expansion, if any.
+ */
+typedef struct fstrm_mnt_data
+{
+	struct xfs_mru_cache	*fstrm_items;
+} fstrm_mnt_data_t;
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
+#define GET_AG_REF(mp, ag) atomic_read(&(mp)->m_perag[ag].pagf_fstrms)
+#define INC_AG_REF(mp, ag) atomic_inc_return(&(mp)->m_perag[ag].pagf_fstrms)
+#define DEC_AG_REF(mp, ag) atomic_dec_return(&(mp)->m_perag[ag].pagf_fstrms)
+
+#define XFS_PICK_USERDATA 1
+#define XFS_PICK_LOWSPACE 2
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
+		//dprint("scanning AG %d[%d]", ag, GET_AG_REF(mp, ag));
+
+		pag = mp->m_perag + ag;
+
+		if (!pag->pagf_init &&
+		    (err = xfs_alloc_pagf_init(mp, NULL, ag, trylock)) &&
+		    !trylock) {
+			dprint("xfs_alloc_pagf_init returned %d", err);
+			return err;
+		}
+
+		/* Might fail sometimes during the 1st pass with trylock set. */
+		if (!pag->pagf_init) {
+			dprint("!pagf_init");
+			goto next_ag;
+		}
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
+		if (INC_AG_REF(mp, ag) > 1) {
+			DEC_AG_REF(mp, ag);
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
+		DEC_AG_REF(mp, ag);
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
+			INC_AG_REF(mp, max_ag);
+			dprint("using max_ag %d[1] with maxfree %d", max_ag,
+			       maxfree);
+
+			free = maxfree;
+			*agp = max_ag;
+			break;
+		}
+
+		dprint("giving up, returning AG 0");
+		*agp = 0;
+		return 0;
+	}
+
+	/*
+	dprint("mp %p startag %d newag %d[%d] free %d minlen %d minfree %d "
+	       "scanned %d trylock %d flags 0x%x", mp, startag, *agp,
+	       GET_AG_REF(mp, *agp), free, minlen, minfree, nscan, trylock,
+	       flags);
+	*/
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
+_xfs_filestream_set_ag(
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
+	cache = mp->m_filestream->fstrm_items;
+
+	if ((item = (fstrm_item_t*)xfs_mru_cache_lookup(cache, ip->i_ino))) {
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
+			DEC_AG_REF(mp, old_ag);
+			INC_AG_REF(mp, ag);
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
+		if (ag != old_ag)
+			dprint("found ip %p ino %lld, AG %d[%d] -> %d[%d]", ip,
+			       ip->i_ino, old_ag, GET_AG_REF(mp, old_ag), ag,
+			       GET_AG_REF(mp, ag));
+		else
+			dprint("found ip %p ino %lld, AG %d[%d]", ip, ip->i_ino,
+			       ag, GET_AG_REF(mp, ag));
+
+		return 0;
+	}
+
+	if (!(item = (fstrm_item_t*)kmem_zone_zalloc(item_zone, KM_SLEEP)))
+		return ENOMEM;
+
+	item->ag = ag;
+	item->ip = ip;
+	item->pip = pip;
+
+	if ((err = xfs_mru_cache_insert(cache, ip->i_ino, item))) {
+		kmem_zone_free(item_zone, item);
+		return err;
+	}
+
+	/* Take a reference on the AG. */
+	INC_AG_REF(mp, ag);
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
+	dprint("put ip %p ino %lld into AG %d[%d]", ip, ip->i_ino, ag,
+	       GET_AG_REF(mp, ag));
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
+	/* Drop the reference taken on the AG when the item was added. */
+	ref = DEC_AG_REF(ip->i_mount, item->ag);
+
+	ASSERT(ref >= 0);
+
+	/*
+	 * _xfs_filestream_set_ag() always takes a reference on the inode
+	 * itself, whether it's a file or a directory.  Release it here.
+	 */
+	IRELE(ip);
+
+	/*
+	 * In the case of a regular file, _xfs_filestream_set_ag() also takes a
+	 * ref on the parent inode to keep it in-core.  Release that too.
+	 */
+	if (item->pip)
+		IRELE(item->pip);
+
+	if (ip->i_d.di_mode & S_IFDIR)
+		dprint("deleting dip %p ino %lld, AG %d[%d]", ip, ip->i_ino,
+		       item->ag, GET_AG_REF(ip->i_mount, item->ag));
+	else
+		dprint("deleting file %p ino %lld, pip %p ino %lld, AG %d[%d]",
+		       ip, ip->i_ino, item->pip,
+		       item->pip ? item->pip->i_ino : 0, item->ag,
+		       GET_AG_REF(ip->i_mount, item->ag));
+
+	/* Finally, free the memory allocated for the item. */
+	kmem_zone_free(item_zone, item);
+}
+
+/*
+ * xfs_filestream_init() is called at xfs initialisation time to set up the
+ * memory zone that will be used for filestream data structure allocation.
+ */
+void
+xfs_filestream_init(void)
+{
+	item_zone = kmem_zone_init(sizeof(fstrm_item_t), "fstrm_item");
+	ASSERT(item_zone);
+}
+
+/*
+ * xfs_filestream_uninit() is called at xfs termination time to destroy the
+ * memory zone that was used for filestream data structure allocation.
+ */
+void
+xfs_filestream_uninit(void)
+{
+	if (item_zone) {
+		kmem_zone_destroy(item_zone);
+		item_zone = NULL;
+	}
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
+	int		err = 0;
+	unsigned int	lifetime, grp_count;
+	fstrm_mnt_data_t *md;
+
+	if (!(md = (fstrm_mnt_data_t*)kmem_zalloc(sizeof(*md), KM_SLEEP)))
+		return ENOMEM;
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
+	if ((err = xfs_mru_cache_create(&md->fstrm_items, lifetime, grp_count,
+	                     (xfs_mru_cache_free_func_t)xfs_fstrm_free_func))) {
+		kmem_free(md, sizeof(*md));
+		return err;
+	}
+
+	mp->m_filestream = md;
+
+	dprint("created fstrm_items %p for mount %p", md->fstrm_items, mp);
+
+	return 0;
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
+	xfs_mru_cache_destroy(mp->m_filestream->fstrm_items);
+	kmem_free(mp->m_filestream, sizeof(*mp->m_filestream));
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
+	xfs_mru_cache_flush(mp->m_filestream->fstrm_items, 1);
+}
+
+/*
+ * Return the AG of the filestream the file or directory belongs to, or
+ * NULLAGNUMBER otherwise.
+ */
+xfs_agnumber_t
+xfs_filestream_get_ag(
+	xfs_inode_t	*ip)
+{
+	xfs_mru_cache_t	*cache;
+	fstrm_item_t	*item;
+	xfs_agnumber_t	ag;
+	int		ref;
+
+	ASSERT(ip->i_d.di_mode & (S_IFREG | S_IFDIR));
+	if (!(ip->i_d.di_mode & (S_IFREG | S_IFDIR)))
+		return NULLAGNUMBER;
+
+	cache = ip->i_mount->m_filestream->fstrm_items;
+	if (!(item = (fstrm_item_t*)xfs_mru_cache_lookup(cache, ip->i_ino))) {
+		dprint("lookup on %s ip %p ino %lld failed, returning %d",
+		       ip->i_d.di_mode & S_IFREG ? "file" : "dir", ip,
+		       ip->i_ino, NULLAGNUMBER);
+		return NULLAGNUMBER;
+	}
+
+	ASSERT(ip == item->ip);
+	ag = item->ag;
+	ref = GET_AG_REF(ip->i_mount, ag);
+	xfs_mru_cache_done(cache);
+
+	if (ip->i_d.di_mode & S_IFREG)
+		dprint("lookup on file ip %p ino %lld dir %p dino %lld got AG "
+		       "%d[%d]", ip, ip->i_ino, item->pip, item->pip->i_ino, ag,
+		       ref);
+	else
+		dprint("lookup on dir ip %p ino %lld got AG %d[%d]", ip,
+		       ip->i_ino, ag, ref);
+
+	return ag;
+}
+
+/*
+ * xfs_filestream_associate() should only be called to associate a regular file
+ * with its parent directory.  Calling it with a child directory isn't
+ * appropriate because filestreams don't apply to entire directory hierarchies.
+ * Creating a file in a child directory of an existing filestream directory
+ * starts a new filestream with its own allocation group association.
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
+		return EINVAL;
+
+	mp = pip->i_mount;
+	cache = mp->m_filestream->fstrm_items;
+	down_read(&mp->m_peraglock);
+	xfs_ilock(pip, XFS_IOLOCK_EXCL);
+
+	/* If the parent directory is already in the cache, use its AG. */
+	if ((item = (fstrm_item_t*)xfs_mru_cache_lookup(cache, pip->i_ino))) {
+		ASSERT(item->ip == pip);
+		ag = item->ag;
+		xfs_mru_cache_done(cache);
+
+		dprint("got cached dir %p ino %lld with AG %d[%d]", pip,
+		       pip->i_ino, ag, GET_AG_REF(mp, ag));
+
+		if ((err = _xfs_filestream_set_ag(ip, pip, ag)))
+			dprint("_xfs_filestream_set_ag(%p, %p, %d) -> err %d",
+			       ip, pip, ag, err);
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
+	if ((err = _xfs_filestream_pick_ag(mp, startag, &ag, 0, 0)) ||
+	    ag == NULLAGNUMBER)
+		goto exit_did_pick;
+
+	/* Associate the parent inode with the AG. */
+	if ((err = _xfs_filestream_set_ag(pip, NULL, ag))) {
+		dprint("_xfs_filestream_set_ag(%p (%lld), NULL, %d) -> err %d",
+		       pip, pip->i_ino, ag, err);
+		goto exit_did_pick;
+	}
+
+	/* Associate the file inode with the AG. */
+	if ((err = _xfs_filestream_set_ag(ip, pip, ag))) {
+		dprint("_xfs_filestream_set_ag(%p (%lld), %p (%lld), %d) -> "
+		       "err %d", ip, ip->i_ino, pip, pip->i_ino, ag, err);
+		goto exit_did_pick;
+	}
+
+	dprint("pip %p ino %lld and ip %p ino %lld given ag %d[%d]",
+	       pip, pip->i_ino, ip, ip->i_ino, ag, GET_AG_REF(mp, ag));
+
+exit_did_pick:
+	/*
+	 * If _xfs_filestream_pick_ag() returned a valid AG, remove the
+	 * reference it took on it, since the file and directory will have taken
+	 * their own now if they were successfully cached.
+	 */
+	if (ag != NULLAGNUMBER)
+		DEC_AG_REF(mp, ag);
+	else
+		dprint("_pick_ag() returned invalid AG %d, no stream set", ag);
+
+exit:
+	xfs_iunlock(pip, XFS_IOLOCK_EXCL);
+	up_read(&mp->m_peraglock);
+	return err;
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
+	cache = mp->m_filestream->fstrm_items;
+	minlen = ap->alen;
+	*agp = NULLAGNUMBER;
+
+	/*
+	 * Look for the file in the cache, removing it if it's found.  Doing
+	 * this allows it to be held across the dir lookup that follows.
+	 */
+	if ((file = (fstrm_item_t*)xfs_mru_cache_remove(cache, ip->i_ino))) {
+		ASSERT(ip == file->ip);
+
+		/* Save the file's parent inode and old AG number for later. */
+		pip = file->pip;
+		ag = file->ag;
+
+		/* Look for the file's directory in the cache. */
+		dir = (fstrm_item_t*)xfs_mru_cache_lookup(cache, pip->i_ino);
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
+				DEC_AG_REF(mp, file->ag);
+				INC_AG_REF(mp, dir->ag);
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
+		if ((err = xfs_mru_cache_insert(cache, ip->i_ino, file))) {
+			xfs_fstrm_free_func(ip->i_ino, file);
+			return err;
+		}
+
+		/*
+		 * If the file's AG was moved to the directory's new AG, there's
+		 * nothing more to be done.
+		 */
+		if (*agp != NULLAGNUMBER) {
+			dprint("dir %p ino %lld for file %p ino %lld has "
+			       "already moved %d[%d] -> %d[%d]", pip,
+			       pip->i_ino, ip, ip->i_ino, ag,
+			       GET_AG_REF(mp, ag), *agp, GET_AG_REF(mp, *agp));
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
+	if ((err = _xfs_filestream_pick_ag(mp, ag, agp, flags, minlen)) ||
+	    *agp == NULLAGNUMBER)
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
+		dprint("gave ag %d to orphan ip %p ino %lld", *agp, ip,
+		       ip->i_ino);
+		goto exit;
+	}
+
+	/* Associate the parent inode with the AG. */
+	if ((err = _xfs_filestream_set_ag(pip, NULL, *agp))) {
+		dprint("_xfs_filestream_set_ag(%p (%lld), NULL, %d) -> err %d",
+		       pip, pip->i_ino, *agp, err);
+		goto exit;
+	}
+
+	/* Associate the file inode with the AG. */
+	if ((err = _xfs_filestream_set_ag(ip, pip, *agp))) {
+		dprint("_xfs_filestream_set_ag(%p (%lld), %p (%lld), %d) -> "
+		       "err %d", ip, ip->i_ino, pip, pip->i_ino, *agp, err);
+		goto exit;
+	}
+
+	dprint("pip %p ino %lld and ip %p ino %lld moved to new ag %d[%d]",
+	       pip, pip->i_ino, ip, ip->i_ino, *agp, GET_AG_REF(mp, *agp));
+
+exit:
+	/*
+	 * If _xfs_filestream_pick_ag() returned a valid AG, remove the
+	 * reference it took on it, since the file and directory will have taken
+	 * their own now if they were successfully cached.
+	 */
+	if (*agp != NULLAGNUMBER)
+		DEC_AG_REF(mp, *agp);
+	else {
+		dprint("_pick_ag() returned invalid AG %d, using AG 0", *agp);
+		*agp = 0;
+	}
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
+	xfs_mru_cache_t	*cache = ip->i_mount->m_filestream->fstrm_items;
+
+	xfs_mru_cache_delete(cache, ip->i_ino);
+}
Index: 2.6.x-xfs-new/fs/xfs/xfs_filestream.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ 2.6.x-xfs-new/fs/xfs/xfs_filestream.h	2007-05-10 17:24:13.107008304 +1000
@@ -0,0 +1,59 @@
+/*
+ * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
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
+void
+xfs_filestream_init(void);
+
+void
+xfs_filestream_uninit(void);
+
+int
+xfs_filestream_mount(struct xfs_mount *mp);
+
+void
+xfs_filestream_unmount(struct xfs_mount *mp);
+
+void
+xfs_filestream_flush(struct xfs_mount *mp);
+
+xfs_agnumber_t
+xfs_filestream_get_ag(struct xfs_inode *ip);
+
+int
+xfs_filestream_associate(struct xfs_inode *dip,
+                         struct xfs_inode *ip);
+
+void
+xfs_filestream_deassociate(struct xfs_inode *ip);
+
+int
+xfs_filestream_new_ag(struct xfs_bmalloca *ap,
+                      xfs_agnumber_t      *agp);
+
+#endif /* __KERNEL__ */
+
+#endif /* __XFS_FILESTREAM_H__ */
Index: 2.6.x-xfs-new/fs/xfs/xfs_fs.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_fs.h	2007-05-10 17:22:43.506752209 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_fs.h	2007-05-10 17:24:13.123006207 +1000
@@ -66,6 +66,7 @@ struct fsxattr {
 #define XFS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
 #define XFS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
 #define XFS_XFLAG_NODEFRAG	0x00002000  	/* do not defragment */
+#define XFS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
 #define XFS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /*
Index: 2.6.x-xfs-new/fs/xfs/xfs_fsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_fsops.c	2007-05-10 17:22:43.506752209 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_fsops.c	2007-05-10 17:24:13.131005159 +1000
@@ -44,6 +44,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_rtalloc.h"
 #include "xfs_rw.h"
+#include "xfs_filestream.h"
 
 /*
  * File system operations
@@ -163,6 +164,7 @@ xfs_growfs_data_private(
 	new = nb - mp->m_sb.sb_dblocks;
 	oagcount = mp->m_sb.sb_agcount;
 	if (nagcount > oagcount) {
+		xfs_filestream_flush(mp);
 		down_write(&mp->m_peraglock);
 		mp->m_perag = kmem_realloc(mp->m_perag,
 			sizeof(xfs_perag_t) * nagcount,
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2007-05-10 17:22:43.506752209 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2007-05-10 17:24:13.143003586 +1000
@@ -48,6 +48,7 @@
 #include "xfs_dir2_trace.h"
 #include "xfs_quota.h"
 #include "xfs_acl.h"
+#include "xfs_filestream.h"
 
 
 kmem_zone_t *xfs_ifork_zone;
@@ -817,6 +818,8 @@ _xfs_dic2xflags(
 			flags |= XFS_XFLAG_EXTSZINHERIT;
 		if (di_flags & XFS_DIFLAG_NODEFRAG)
 			flags |= XFS_XFLAG_NODEFRAG;
+		if (di_flags & XFS_DIFLAG_FILESTREAM)
+			flags |= XFS_XFLAG_FILESTREAM;
 	}
 
 	return flags;
@@ -1099,7 +1102,7 @@ xfs_ialloc(
 	 * Call the space management code to pick
 	 * the on-disk inode to be allocated.
 	 */
-	error = xfs_dialloc(tp, pip->i_ino, mode, okalloc,
+	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, mode, okalloc,
 			    ialloc_context, call_again, &ino);
 	if (error != 0) {
 		return error;
@@ -1153,7 +1156,7 @@ xfs_ialloc(
 	if ( (prid != 0) && (ip->i_d.di_version == XFS_DINODE_VERSION_1))
 		xfs_bump_ino_vers2(tp, ip);
 
-	if (XFS_INHERIT_GID(pip, vp->v_vfsp)) {
+	if (pip && XFS_INHERIT_GID(pip, vp->v_vfsp)) {
 		ip->i_d.di_gid = pip->i_d.di_gid;
 		if ((pip->i_d.di_mode & S_ISGID) && (mode & S_IFMT) == S_IFDIR) {
 			ip->i_d.di_mode |= S_ISGID;
@@ -1195,8 +1198,14 @@ xfs_ialloc(
 		flags |= XFS_ILOG_DEV;
 		break;
 	case S_IFREG:
+		if (unlikely(pip &&
+		     ((ip->i_mount->m_flags & XFS_MOUNT_FILESTREAMS) ||
+		      (pip->i_d.di_flags & XFS_DIFLAG_FILESTREAM)) &&
+		     (error = xfs_filestream_associate(pip, ip))))
+			return error;
+		/* fall through */
 	case S_IFDIR:
-		if (unlikely(pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
+		if (unlikely(pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY))) {
 			uint	di_flags = 0;
 
 			if ((mode & S_IFMT) == S_IFDIR) {
@@ -1233,6 +1242,8 @@ xfs_ialloc(
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
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.h	2007-05-10 17:22:43.506752209 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.h	2007-05-10 17:24:13.147003062 +1000
@@ -66,6 +66,7 @@ struct xfs_bmbt_irec;
 struct xfs_bmap_free;
 struct xfs_extdelta;
 struct xfs_swapext;
+struct xfs_filestream;
 
 extern struct bhv_vfsops xfs_vfsops;
 extern struct bhv_vnodeops xfs_vnodeops;
@@ -436,6 +437,7 @@ typedef struct xfs_mount {
 	struct notifier_block	m_icsb_notifier; /* hotplug cpu notifier */
 	struct mutex		m_icsb_mutex;	/* balancer sync lock */
 #endif
+	struct fstrm_mnt_data   *m_filestream;  /* per-mount filestream data */
 } xfs_mount_t;
 
 /*
@@ -475,6 +477,8 @@ typedef struct xfs_mount {
 						 * I/O size in stat() */
 #define XFS_MOUNT_NO_PERCPU_SB	(1ULL << 23)	/* don't use per-cpu superblock
 						   counters */
+#define XFS_MOUNT_FILESTREAMS	(1ULL << 24)	/* enable the filestreams
+						   allocator */
 
 
 /*
Index: 2.6.x-xfs-new/fs/xfs/xfs_mru_cache.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mru_cache.c	2007-05-10 17:24:13.151002538 +1000
@@ -0,0 +1,607 @@
+/*
+ * Copyright (c) 2000-2002,2006 Silicon Graphics, Inc.
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
+//#define DEBUG_MRU_CACHE 1
+#include "xfs.h"
+#include "xfs_mru_cache.h"
+
+/*
+ * An MRU Cache is a dynamic data structure that stores its elements in a way
+ * that allows efficient lookups, but also groups them into discrete time
+ * intervals based on insertion time.  This allows elements to be efficiently
+ * and automatically reaped after a fixed period of inactivity.
+ */
+
+#ifdef DEBUG_MRU_CACHE
+#define dprint(fmt, args...) do {                                          \
+        printk(KERN_DEBUG "%4d %s: " fmt "\n",                             \
+               current_pid(), __FUNCTION__, ##args);                       \
+} while(0)
+
+#define DEBUG_DECL_CACHE_FIELDS                                            \
+        unsigned int  *list_elems;                                         \
+        unsigned int  reap_elems;                                          \
+        unsigned long allocs;                                              \
+        unsigned long frees;
+
+#define DEBUG_INIT_CACHE(mru)                                              \
+        ((mru)->list_elems = (unsigned int*)                               \
+                kmem_zalloc((mru)->grp_count * sizeof(*(mru)->list_elems), \
+                            KM_SLEEP))
+
+#define DEBUG_UNINIT_CACHE(mru)                                            \
+        kmem_free((mru)->list_elems,                                       \
+              (mru)->grp_count * sizeof(*(mru)->list_elems))
+
+#define DEBUG_INC_ALLOCS(mru)   (mru)->allocs++
+#define DEBUG_INC_FREES(mru)    (mru)->frees++
+
+STATIC int
+_xfs_mru_cache_print(struct xfs_mru_cache *mru, char *buf);
+
+#define DEBUG_PRINT_STACK_VARS                                             \
+        char          buf[256];                                            \
+        char          *bufp = buf;
+
+#define DEBUG_PRINT_BEFORE_REAP                                            \
+        bufp += _xfs_mru_cache_print(mru, bufp)
+
+#define DEBUG_PRINT_AFTER_REAP                                             \
+        bufp += sprintf(bufp, " -> ");                                     \
+        bufp += _xfs_mru_cache_print(mru, bufp);                           \
+        dprint("[%p]: %s", mru, buf)
+#else /* !defined DEBUG_MRU_CACHE */
+#define dprint(args...)         do {} while (0)
+#define DEBUG_DECL_CACHE_FIELDS
+#define DEBUG_INIT_CACHE(mru)   1
+#define DEBUG_UNINIT_CACHE(mru) do {} while (0)
+#define DEBUG_INC_ALLOCS(mru)   do {} while (0)
+#define DEBUG_INC_FREES(mru)    do {} while (0)
+#define DEBUG_PRINT_STACK_VARS
+#define DEBUG_PRINT_BEFORE_REAP do {} while (0)
+#define DEBUG_PRINT_AFTER_REAP  do {} while (0)
+#endif /* DEBUG_MRU_CACHE */
+
+
+/*
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
+static kmem_zone_t		*elem_zone;
+static struct workqueue_struct	*reap_wq;
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
+		kmem_zone_free(elem_zone, elem);
+		DEBUG_INC_FREES(mru);
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
+	unsigned long		now, next;
+	DEBUG_PRINT_STACK_VARS;
+
+	ASSERT(mru && mru->lists);
+	if (!mru || !mru->lists)
+		return;
+
+	mutex_spinlock(&mru->lock);
+	now = jiffies;
+	if (mru->reap_all ||
+	    (mru->next_reap && time_after(now, mru->next_reap))) {
+		DEBUG_PRINT_BEFORE_REAP;
+		if (mru->reap_all)
+			now += mru->grp_count * mru->grp_time * 2;
+		mru->next_reap = _xfs_mru_cache_migrate(mru, now);
+		_xfs_mru_cache_clear_reap_list(mru);
+		DEBUG_PRINT_AFTER_REAP;
+	}
+
+	/*
+	 * the process that triggered the reap_all is responsible
+	 * for restating the periodic reap if it is required.
+	 */
+	if (!mru->reap_all)
+		queue_delayed_work(reap_wq, &mru->work, mru->grp_time);
+	mru->reap_all = 0;
+	mutex_spinunlock(&mru->lock, 0);
+}
+
+int
+xfs_mru_cache_init(void)
+{
+	if (!(elem_zone = kmem_zone_init(sizeof(xfs_mru_cache_elem_t),
+	                                 "xfs_mru_cache_elem")))
+		return ENOMEM;
+
+	if (!(reap_wq = create_singlethread_workqueue("xfs_mru_cache"))) {
+		kmem_zone_destroy(elem_zone);
+		elem_zone = NULL;
+		return ENOMEM;
+	}
+
+	return 0;
+}
+
+void
+xfs_mru_cache_uninit(void)
+{
+	if (reap_wq) {
+		destroy_workqueue(reap_wq);
+		reap_wq = NULL;
+	}
+
+	if (elem_zone) {
+		kmem_zone_destroy(elem_zone);
+		elem_zone = NULL;
+	}
+}
+
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
+	mru->lists = (struct list_head*)
+	             kmem_alloc(mru->grp_count * sizeof(*mru->lists), KM_SLEEP);
+
+	if (!mru->lists || !DEBUG_INIT_CACHE(mru)) {
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
+	queue_delayed_work(reap_wq, &mru->work, mru->grp_time);
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
+ * When flushing, we stop the periodic reaper from running first
+ * so we don't race with it. If we are flushing on unmount, we
+ * don't want to restart the reaper again, so the restart is conditional.
+ *
+ * Because reaping can drop the last refcount on inodes which can free
+ * extents, we have to push the reaping off to the workqueue thread
+ * because we could be called holding locks that extent freeing requires.
+ */
+void
+xfs_mru_cache_flush(
+	xfs_mru_cache_t		*mru,
+	int			restart)
+{
+	DEBUG_PRINT_STACK_VARS;
+
+	if (!mru || !mru->lists)
+		return;
+
+	cancel_rearming_delayed_workqueue(reap_wq, &mru->work);
+
+	mutex_spinlock(&mru->lock);
+	mru->reap_all = 1;
+	mutex_spinunlock(&mru->lock, 0);
+
+	queue_work(reap_wq, &mru->work.work);
+	flush_workqueue(reap_wq);
+
+	mutex_spinlock(&mru->lock);
+	WARN_ON_ONCE(mru->reap_all != 0);
+	mru->reap_all = 0;
+	if (restart)
+		queue_delayed_work(reap_wq, &mru->work, mru->grp_time);
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
+	DEBUG_UNINIT_CACHE(mru);
+	kmem_free(mru->lists, mru->grp_count * sizeof(*mru->lists));
+	kmem_free(mru, sizeof(*mru));
+}
+
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
+	elem = (xfs_mru_cache_elem_t*)kmem_zone_zalloc(elem_zone, KM_SLEEP);
+	if (!elem)
+		return ENOMEM;
+
+	if (radix_tree_preload(GFP_KERNEL)) {
+		kmem_zone_free(elem_zone, elem);
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
+
+	_xfs_mru_cache_list_insert(mru, elem);
+
+	DEBUG_INC_ALLOCS(mru);
+
+	mutex_spinunlock(&mru->lock, 0);
+
+	return 0;
+}
+
+void*
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
+	elem = (xfs_mru_cache_elem_t*)radix_tree_delete(&mru->store, key);
+	if (elem) {
+		value = elem->value;
+		list_del(&elem->list_node);
+		DEBUG_INC_FREES(mru);
+	}
+
+	mutex_spinunlock(&mru->lock, 0);
+
+	if (elem)
+		kmem_zone_free(elem_zone, elem);
+
+	return value;
+}
+
+void
+xfs_mru_cache_delete(
+	xfs_mru_cache_t	*mru,
+	unsigned long	key)
+{
+	void		*value;
+
+	if ((value = xfs_mru_cache_remove(mru, key)))
+		mru->free_func(key, value);
+}
+
+void*
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
+	elem = (xfs_mru_cache_elem_t*)radix_tree_lookup(&mru->store, key);
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
+void*
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
+	elem = (xfs_mru_cache_elem_t*)radix_tree_lookup(&mru->store, key);
+	if (!elem)
+		mutex_spinunlock(&mru->lock, 0);
+
+	return elem ? elem->value : NULL;
+}
+
+void
+xfs_mru_cache_done(
+	xfs_mru_cache_t	*mru)
+{
+	mutex_spinunlock(&mru->lock, 0);
+}
+
+#ifdef DEBUG_MRU_CACHE
+STATIC int
+_xfs_mru_cache_print(
+	xfs_mru_cache_t	*mru,
+	char		*buf)
+{
+	unsigned int	grp;
+	struct list_head *node;
+	char		*bufp = buf;
+
+	for (grp = 0; grp < mru->grp_count; grp++) {
+		mru->list_elems[grp] = 0;
+		list_for_each(node, mru->lists + grp)
+			mru->list_elems[grp]++;
+	}
+	mru->reap_elems = 0;
+	list_for_each(node, &mru->reap_list)
+		mru->reap_elems++;
+
+	bufp += sprintf(bufp, "(%d) ", mru->reap_elems);
+
+	for (grp = 0; grp < mru->grp_count; grp++)
+	{
+		if (grp == mru->lru_grp)
+			*bufp++ = '*';
+
+		bufp += sprintf(bufp, "%u", mru->list_elems[grp]);
+
+		if (grp == mru->lru_grp)
+			*bufp++ = '*';
+
+		if (grp < mru->grp_count - 1)
+			*bufp++ = ' ';
+	}
+
+	bufp += sprintf(bufp, " [%lu/%lu]", mru->allocs, mru->frees);
+
+	return bufp - buf;
+}
+#endif /* DEBUG_MRU_CACHE */
Index: 2.6.x-xfs-new/fs/xfs/xfs_mru_cache.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mru_cache.h	2007-05-10 17:24:13.155002014 +1000
@@ -0,0 +1,225 @@
+/*
+ * Copyright (c) 2000-2002,2006 Silicon Graphics, Inc.
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
+/* Function pointer type for callback to free a client's data pointer. */
+typedef void (*xfs_mru_cache_free_func_t)(void*, void*);
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
+#ifdef DEBUG_MRU_CACHE
+        unsigned int  *list_elems;
+        unsigned int  reap_elems;
+        unsigned long allocs;
+        unsigned long frees;
+#endif
+} xfs_mru_cache_t;
+
+/*
+ * xfs_mru_cache_init() prepares memory zones and any other globally scoped
+ * resources.
+ */
+int
+xfs_mru_cache_init(void);
+
+/*
+ * xfs_mru_cache_uninit() tears down all the globally scoped resources prepared
+ * in xfs_mru_cache_init().
+ */
+void
+xfs_mru_cache_uninit(void);
+
+/*
+ * To initialise a struct xfs_mru_cache pointer, call xfs_mru_cache_create()
+ * with the address of the pointer, a lifetime value in milliseconds, a group
+ * count and a free function to use when deleting elements.  This function
+ * returns 0 if the initialisation was successful.
+ */
+int
+xfs_mru_cache_create(struct xfs_mru_cache      **mrup,
+                     unsigned int              lifetime_ms,
+                     unsigned int              grp_count,
+                     xfs_mru_cache_free_func_t free_func);
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
+	int			restart);
+
+/*
+ * Call xfs_mru_cache_destroy() with the MRU Cache pointer when the cache is no
+ * longer needed.
+ */
+void
+xfs_mru_cache_destroy(struct xfs_mru_cache *mru);
+
+/*
+ * To insert an element, call xfs_mru_cache_insert() with the data store, the
+ * element's key and the client data pointer.  This function returns 0 on
+ * success or ENOMEM if memory for the data element couldn't be allocated.
+ */
+int
+xfs_mru_cache_insert(struct xfs_mru_cache	*mru,
+                     unsigned long		key,
+                     void			*value);
+
+/*
+ * To remove an element without calling the free function, call
+ * xfs_mru_cache_remove() with the data store and the element's key.  On success
+ * the client data pointer for the removed element is returned, otherwise this
+ * function will return a NULL pointer.
+ */
+void*
+xfs_mru_cache_remove(struct xfs_mru_cache	*mru,
+                     unsigned long		key);
+
+/*
+ * To remove and element and call the free function, call xfs_mru_cache_delete()
+ * with the data store and the element's key.
+ */
+void
+xfs_mru_cache_delete(struct xfs_mru_cache	*mru,
+                     unsigned long		key);
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
+void*
+xfs_mru_cache_lookup(struct xfs_mru_cache	*mru,
+                     unsigned long		key);
+
+/*
+ * To look up an element using its key, but leave its location in the internal
+ * lists alone, call xfs_mru_cache_peek().  If the element isn't found, this
+ * function returns NULL.
+ *
+ * See the comments above the declaration of the xfs_mru_cache_lookup() function
+ * for important locking information pertaining to this call.
+ */
+void*
+xfs_mru_cache_peek(struct xfs_mru_cache	*mru,
+		   unsigned long	key);
+/*
+ * To release the internal data structure spinlock after having performed an
+ * xfs_mru_cache_lookup() or an xfs_mru_cache_peek(), call xfs_mru_cache_done()
+ * with the data store pointer.
+ */
+void
+xfs_mru_cache_done(struct xfs_mru_cache *mru);
+
+#endif /* __XFS_MRU_CACHE_H__ */
Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2007-05-10 17:22:43.506752209 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2007-05-10 17:24:13.163000966 +1000
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
@@ -320,6 +326,9 @@ xfs_start_flags(
 	else
 		mp->m_flags &= ~XFS_MOUNT_BARRIER;
 
+	if (ap->flags2 & XFSMNT2_FILESTREAMS)
+		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
+
 	return 0;
 }
 
@@ -518,6 +527,9 @@ xfs_mount(
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
 		xfs_mountfs_check_barriers(mp);
 
+	if ((error = xfs_filestream_mount(mp)))
+		goto error2;
+
 	error = XFS_IOINIT(vfsp, args, flags);
 	if (error)
 		goto error2;
@@ -575,6 +587,13 @@ xfs_unmount(
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
@@ -682,6 +701,7 @@ xfs_mntupdate(
 			mp->m_flags &= ~XFS_MOUNT_BARRIER;
 		}
 	} else if (!(vfsp->vfs_flag & VFS_RDONLY)) {	/* rw -> ro */
+		xfs_filestream_flush(mp);
 		bhv_vfs_sync(vfsp, SYNC_FSDATA|SYNC_BDFLUSH|SYNC_ATTR, NULL);
 		xfs_quiesce_fs(mp);
 		xfs_log_sbcount(mp, 1);
@@ -909,6 +929,9 @@ xfs_sync(
 {
 	xfs_mount_t	*mp = XFS_BHVTOM(bdp);
 
+	if (flags & SYNC_IOWAIT)
+		xfs_filestream_flush(mp);
+
 	return xfs_syncsub(mp, flags, NULL);
 }
 
@@ -1869,6 +1892,8 @@ xfs_parseargs(
 		} else if (!strcmp(this_char, "irixsgid")) {
 			cmn_err(CE_WARN,
 	"XFS: irixsgid is now a sysctl(2) variable, option is deprecated.");
+		} else if (!strcmp(this_char, "filestreams")) {
+			args->flags2 |= XFSMNT2_FILESTREAMS;
 		} else {
 			cmn_err(CE_WARN,
 				"XFS: unknown mount option [%s].", this_char);
Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2007-05-10 17:22:43.506752209 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2007-05-10 17:24:13.170999917 +1000
@@ -51,6 +51,7 @@
 #include "xfs_refcache.h"
 #include "xfs_trans_space.h"
 #include "xfs_log_priv.h"
+#include "xfs_filestream.h"
 
 STATIC int
 xfs_open(
@@ -94,6 +95,19 @@ xfs_close(
 		return 0;
 
 	/*
+	 * If we are using filestreams, and we have an unlinked
+	 * file that we are processing the last close on, then nothing
+	 * will be able to reopen and write to this file. Purge this
+	 * inode from the filestreams cache so that it doesn't delay
+	 * teardown of the inode.
+	 */
+	if ((ip->i_d.di_nlink == 0) &&
+	    ((ip->i_mount->m_flags & XFS_MOUNT_FILESTREAMS) ||
+	     (ip->i_d.di_flags & XFS_DIFLAG_FILESTREAM))) {
+		xfs_filestream_deassociate(ip);
+	}
+
+	/*
 	 * If we previously truncated this file and removed old data in
 	 * the process, we want to initiate "early" writeout on the last
 	 * close.  This is an attempt to combat the notorious NULL files
@@ -820,6 +834,8 @@ xfs_setattr(
 				di_flags |= XFS_DIFLAG_PROJINHERIT;
 			if (vap->va_xflags & XFS_XFLAG_NODEFRAG)
 				di_flags |= XFS_DIFLAG_NODEFRAG;
+			if (vap->va_xflags & XFS_XFLAG_FILESTREAM)
+				di_flags |= XFS_DIFLAG_FILESTREAM;
 			if ((ip->i_d.di_mode & S_IFMT) == S_IFDIR) {
 				if (vap->va_xflags & XFS_XFLAG_RTINHERIT)
 					di_flags |= XFS_DIFLAG_RTINHERIT;
@@ -2564,6 +2580,18 @@ xfs_remove(
 	 */
 	xfs_refcache_purge_ip(ip);
 
+	/*
+	 * If we are using filestreams, kill the stream association.
+	 * If the file is still open it may get a new one but that
+	 * will get killed on last close in xfs_close() so we don't
+	 * have to worry about that.
+	 */
+	if (link_zero &&
+	    ((ip->i_mount->m_flags & XFS_MOUNT_FILESTREAMS) ||
+	     (ip->i_d.di_flags & XFS_DIFLAG_FILESTREAM))) {
+		xfs_filestream_deassociate(ip);
+	}
+
 	vn_trace_exit(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
 
 	/*
Index: 2.6.x-xfs-new/fs/xfs/quota/xfs_qm.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/quota/xfs_qm.c	2007-05-10 17:22:43.506752209 +1000
+++ 2.6.x-xfs-new/fs/xfs/quota/xfs_qm.c	2007-05-10 17:24:13.186997821 +1000
@@ -65,7 +65,6 @@ kmem_zone_t	*qm_dqtrxzone;
 static struct shrinker *xfs_qm_shaker;
 
 static cred_t	xfs_zerocr;
-static xfs_inode_t	xfs_zeroino;
 
 STATIC void	xfs_qm_list_init(xfs_dqlist_t *, char *, int);
 STATIC void	xfs_qm_list_destroy(xfs_dqlist_t *);
@@ -1415,7 +1414,7 @@ xfs_qm_qino_alloc(
 		return error;
 	}
 
-	if ((error = xfs_dir_ialloc(&tp, &xfs_zeroino, S_IFREG, 1, 0,
+	if ((error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
 				   &xfs_zerocr, 0, 1, ip, &committed))) {
 		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
 				 XFS_TRANS_ABORT);

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Jun 2007 02:14:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5E9ElWt027411
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2007 02:14:49 -0700
Date: Thu, 14 Jun 2007 19:14:26 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS shrink functionality
Message-ID: <20070614091426.GB86004887@sgi.com>
References: <1180715974.10796.46.camel@localhost> <20070604001632.GA86004887@sgi.com> <20070604084154.GA8273@teal.hq.k1024.org> <1181291033.7510.40.camel@localhost> <20070608101532.GA18788@teal.hq.k1024.org> <20070608151223.GF86004887@sgi.com> <1181810127.6539.13.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181810127.6539.13.camel@localhost>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ruben Porras <nahoo82@gmail.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, cw@f00f.org, iusty@k1024.org

On Thu, Jun 14, 2007 at 10:35:27AM +0200, Ruben Porras wrote:
> > > I took a look at both items since this discussion started. And honestly,
> > > I think 1) is harder that 4), so you're welcome to work on it :) The
> > > points that make it harder is that, per David's suggestion, there needs
> > > to be:
> > >  - define two new transaction types
> > 
> > one new transaction type:
> > 
> > XFS_TRANS_AGF_FLAGS
> 
> done
> 
> > and and extension to xfs_alloc_log_agf(). Is about all that is
> > needed there.
> 
> still to do. Will come after the ioctls.
> 
> > See the patch here:
> > 
> > http://oss.sgi.com/archives/xfs/2007-04/msg00103.html
> > 
> > For an example of a very simlar transaction to what is needed
> > (look at xfs_log_sbcount()) and very similar addition to
> > the AGF (xfs_btreeblks).
> > 
> > >  - define two new ioctls
> > 
> > XFS_IOC_ALLOC_ALLOW_AG, parameter xfsagnumber_t.
> > XFS_IOC_ALLOC_DENY_AG, parameter xfsagnumber_t.
> 
> almost done.

FWIW, I've had second thoughts on this ioctl interface. It's
horribly specific, considering all we are doing are setting
or clearing a flag in an AG.

Perhaps a better interface is:

XFS_IOC_GET_AGF_FLAGS
XFS_IOC_SET_AGF_FLAGS

with:

struct xfs_ioc_agflags {
	xfs_agnumber_t	ag;
	__u32		flags;
}

As the parameter structure and:

#define XFS_AGF_FLAGS_ALLOC_DENY	(1<<0)


> How I'm should I obtain a pointer to an xfs_agf_t from
> inside the ioctls?
> 
> I guess that the first step is to get a *bp with xfs_getsb and then an *sbp,
> but, which function/macro gives me the xfs_agf_t pointer? Sorry, I can't
> find the way greeping through the code.

I've attached the quick hack I did when thinking this through
initially. It'll give you an idea of how to do this and a bit more.
FWIW, it was this hack that made me think the above interface
is a better way to go....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_ioctl.c |   27 +++++++++++
 fs/xfs/xfs_ag.h              |    7 ++
 fs/xfs/xfs_alloc.c           |  103 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fs.h              |    2 
 fs/xfs/xfs_trans.h           |    3 -
 5 files changed, 140 insertions(+), 2 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2007-06-08 21:34:37.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ioctl.c	2007-06-08 22:22:59.305412098 +1000
@@ -899,6 +899,33 @@ xfs_ioctl(
 		return -error;
 	}
 
+	case XFS_IOC_ALLOC_DENY_AG: {
+		xfs_agnumber_t in;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (copy_from_user(&in, arg, sizeof(in)))
+			return -XFS_ERROR(EFAULT);
+
+		error = xfs_alloc_deny_ag(mp, &in);
+		return -error;
+
+	}
+	case XFS_IOC_ALLOC_ALLOW_AG: {
+		xfs_agnumber_t in;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (copy_from_user(&in, arg, sizeof(in)))
+			return -XFS_ERROR(EFAULT);
+
+		error = xfs_alloc_allow_ag(mp, &in);
+		return -error;
+
+	}
+
 	case XFS_IOC_FREEZE:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
Index: 2.6.x-xfs-new/fs/xfs/xfs_ag.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ag.h	2007-06-08 21:46:28.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_ag.h	2007-06-08 22:09:18.323606142 +1000
@@ -69,6 +69,7 @@ typedef struct xfs_agf {
 	__be32		agf_freeblks;	/* total free blocks */
 	__be32		agf_longest;	/* longest free space */
 	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
+	__be32		agf_flags;	/* status flags */
 } xfs_agf_t;
 
 #define	XFS_AGF_MAGICNUM	0x00000001
@@ -83,9 +84,12 @@ typedef struct xfs_agf {
 #define	XFS_AGF_FREEBLKS	0x00000200
 #define	XFS_AGF_LONGEST		0x00000400
 #define	XFS_AGF_BTREEBLKS	0x00000800
-#define	XFS_AGF_NUM_BITS	12
+#define	XFS_AGF_FLAGS		0x00001000
+#define	XFS_AGF_NUM_BITS	13
 #define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
 
+
+
 /* disk block (xfs_daddr_t) in the AG */
 #define XFS_AGF_DADDR(mp)	((xfs_daddr_t)(1 << (mp)->m_sectbb_log))
 #define	XFS_AGF_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGF_DADDR(mp))
@@ -189,6 +193,7 @@ typedef struct xfs_perag
 	xfs_extlen_t	pagf_freeblks;	/* total free blocks */
 	xfs_extlen_t	pagf_longest;	/* longest free space */
 	__uint32_t	pagf_btreeblks;	/* # of blocks held in AGF btrees */
+	__uint32_t	pagf_flags;	/* status flags for AG */
 	xfs_agino_t	pagi_freecount;	/* number of free inodes */
 	xfs_agino_t	pagi_count;	/* number of allocated inodes */
 	int		pagb_count;	/* pagb slots in use */
Index: 2.6.x-xfs-new/fs/xfs/xfs_alloc.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_alloc.c	2007-06-05 22:12:50.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_alloc.c	2007-06-08 23:12:51.256348632 +1000
@@ -2085,6 +2085,7 @@ xfs_alloc_log_agf(
 		offsetof(xfs_agf_t, agf_freeblks),
 		offsetof(xfs_agf_t, agf_longest),
 		offsetof(xfs_agf_t, agf_btreeblks),
+		offsetof(xfs_agf_t, agf_flags),
 		sizeof(xfs_agf_t)
 	};
 
@@ -2112,6 +2113,107 @@ xfs_alloc_pagf_init(
 	return 0;
 }
 
+#define XFS_AGFLAG_ALLOC_DENY	1
+STATIC void
+xfs_alloc_set_flag_ag(
+	xfs_trans_t	*tp,
+	xfs_buf_t	*agbp,	/* buffer for a.g. freelist header */
+	xfs_perag_t	*pag,
+	int		flag)
+{
+	xfs_agf_t		*agf;	/* a.g. freespace structure */
+
+	agf = XFS_BUF_TO_AGF(agbp);
+	pag->pagf_flags |= flag;
+	agf->agf_flags = cpu_to_be32(pag->pagf_flags);
+
+	xfs_alloc_log_agf(tp, agbp, XFS_AGF_FLAGS);
+}
+
+STATIC void
+xfs_alloc_clear_flag_ag(
+	xfs_trans_t	*tp,
+	xfs_buf_t	*agbp,	/* buffer for a.g. freelist header */
+	xfs_perag_t	*pag,
+	int		flag)
+{
+	xfs_agf_t		*agf;	/* a.g. freespace structure */
+
+	agf = XFS_BUF_TO_AGF(agbp);
+	pag->pagf_flags &= ~flag;
+	agf->agf_flags = cpu_to_be32(pag->pagf_flags);
+
+	xfs_alloc_log_agf(tp, agbp, XFS_AGF_FLAGS);
+}
+
+int
+xfs_alloc_allow_ag(
+	xfs_mount_t	*mp,
+	xfs_agnumber_t	agno)
+{
+	xfs_perag_t	*pag;
+	xfs_buf_t	*bp;
+	int		error;
+	xfs_trans_t	*tp;
+
+	if (agno >= mp->m_sb.sb_agcount)
+		return -EINVAL;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_ALLOC_FLAGS);
+	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
+					XFS_DEFAULT_LOG_COUNT);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		return error;
+	}
+	error = xfs_alloc_read_agf(mp, tp, agno, 0, &bp);
+	if (error)
+		return error;
+
+	pag = &mp->m_perag[agno];
+	xfs_alloc_clear_flag_ag(tp, bp, pag, XFS_AGFLAG_ALLOC_DENY);
+
+	xfs_trans_set_sync(tp);
+	xfs_trans_commit(tp, 0);
+
+	return 0;
+
+}
+
+int
+xfs_alloc_deny_ag(
+	xfs_mount_t	*mp,
+	xfs_agnumber_t	agno)
+{
+	xfs_perag_t	*pag;
+	xfs_buf_t	*bp;
+	int		error;
+	xfs_trans_t	*tp;
+
+	if (agno >= mp->m_sb.sb_agcount)
+		return -EINVAL;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_ALLOC_FLAGS);
+	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
+					XFS_DEFAULT_LOG_COUNT);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		return error;
+	}
+	error = xfs_alloc_read_agf(mp, tp, agno, 0, &bp);
+	if (error)
+		return error;
+
+	pag = &mp->m_perag[agno];
+	xfs_alloc_set_flag_ag(tp, bp, pag, XFS_AGFLAG_ALLOC_DENY);
+
+	xfs_trans_set_sync(tp);
+	xfs_trans_commit(tp, 0);
+
+	return 0;
+
+}
+
 /*
  * Put the block on the freelist for the allocation group.
  */
@@ -2226,6 +2328,7 @@ xfs_alloc_read_agf(
 		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
 		pag->pagf_flcount = be32_to_cpu(agf->agf_flcount);
 		pag->pagf_longest = be32_to_cpu(agf->agf_longest);
+		pag->pagf_flags = be32_to_cpu(agf->agf_flags);
 		pag->pagf_levels[XFS_BTNUM_BNOi] =
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
 		pag->pagf_levels[XFS_BTNUM_CNTi] =
Index: 2.6.x-xfs-new/fs/xfs/xfs_trans.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans.h	2007-06-08 21:41:32.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans.h	2007-06-08 22:50:46.449405162 +1000
@@ -95,7 +95,8 @@ typedef struct xfs_trans_header {
 #define	XFS_TRANS_GROWFSRT_FREE		39
 #define	XFS_TRANS_SWAPEXT		40
 #define	XFS_TRANS_SB_COUNT		41
-#define	XFS_TRANS_TYPE_MAX		41
+#define	XFS_TRANS_ALLOC_FLAGS		42
+#define	XFS_TRANS_TYPE_MAX		42
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_fs.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_fs.h	2007-06-08 21:46:29.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_fs.h	2007-06-08 23:15:31.755284394 +1000
@@ -493,6 +493,8 @@ typedef struct xfs_handle {
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+#define XFS_IOC_ALLOC_DENY_AG	     _IOR ('X', 126, __uint32_t)
+#define XFS_IOC_ALLOC_ALLOW_AG	     _IOR ('X', 127, __uint32_t)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 

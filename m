Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 03:52:30 -0700 (PDT)
Received: from mail.pawisda.de (mail.pawisda.de [213.157.4.156])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5SAqOtL021390
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 03:52:25 -0700
Received: from localhost (localhost.intra.frontsite.de [127.0.0.1])
	by mail.pawisda.de (Postfix) with ESMTP id 937DBD57B
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 12:26:02 +0200 (CEST)
Received: from mail.pawisda.de ([127.0.0.1])
 by localhost (ndb [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 25532-08 for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 12:25:50 +0200 (CEST)
Received: from [192.168.51.2] (lw-pc002.intra.frontsite.de [192.168.51.2])
	by mail.pawisda.de (Postfix) with ESMTP id 9A8F3D532
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 12:25:50 +0200 (CEST)
Message-ID: <46838CAE.9030808@linworks.de>
Date: Thu, 28 Jun 2007 12:25:50 +0200
From: Ruben Porras <ruben.porras@linworks.de>
MIME-Version: 1.0
Subject: Re: [PATCH] Implement ioctl to mark AGs as "don't use/use"
References: <1182939325.5313.12.camel@localhost> <20070628045049.GF989688@sgi.com>
In-Reply-To: <20070628045049.GF989688@sgi.com>
Content-Type: multipart/mixed;
 boundary="------------090407080102030706060601"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------090407080102030706060601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

David Chinner wrote:
> It's a good first cut - comments are inline in the patch below.
>
>
>   
> Looks like some whitespace problems there (mixing spaces and tabs).
> Also, can you include empty lines either side of a unique hunk of code
> like this?
>
> I wonder how many other places we are going to have to put this check?
> I haven't looked myself, but this is a good place to start ;)
>
>   

I'm still wondering how should I educate emacs to introduce alsways tabs ;)
> You shouldn't renumber the existing ioctls - that changes the
> interfaces to userspace and so will break lots of stuff :( Just put
> them at the end as 126/127. (Oh, you've got two "111" ioctls in
> there, anyway ;)
>   

> IOWs, the flag passed to xfs_trans_alloc() defines the type of the
> transaction and the flag passed to xfs_alloc_log_agf() defines what
> has been modified within the transaction.
>
>   
Ok, thank you for the explanation, I think that now I got it right.
Attached is a new patch.

There is one question that I would like to ask: when you sketched the 
xfs_alloc_set_flag_ag function, you put inside it the call to the 
funcintion xfs_alloc_log_agf (see next code snippet).

STATIC void
xfs_alloc_set_flag_ag(
 xfs_trans_t *tp,
 xfs_buf_t *agbp, /* buffer for a.g. freelist header */
 xfs_perag_t *pag,
 int flag)
{
 xfs_agf_t *agf; /* a.g. freespace structure */

 agf = XFS_BUF_TO_AGF(agbp);
 pag->pagf_flags |= flag;
 agf->agf_flags = cpu_to_be32(pag->pagf_flags);

 xfs_alloc_log_agf(tp, agbp, XFS_AGF_FLAGS); <-- ***** FROM HERE
}

is it required to do the transaction log right after the change or can it be
done in the caller function right after calling xfs_alloc_set_flag_ag?

For example

caller(...)

{
xfs_alloc_set_flag_ag(tp, bp, pag, XFS_AGFLAG_ALLOC_DENY);

<-- **** TO HERE

xfs_trans_set_sync(tp);
xfs_trans_commit(tp, 0);
}

Thanks

-- 
Rubén Porras
LinWorks GmbH


--------------090407080102030706060601
Content-Type: text/x-patch;
 name="patch_markags1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch_markags1.diff"

Index: fs/xfs/xfs_ag.h
===================================================================
RCS file: /cvs/linux-2.6-xfs/fs/xfs/xfs_ag.h,v
retrieving revision 1.59
diff -u -r1.59 xfs_ag.h
--- fs/xfs/xfs_ag.h	22 May 2007 15:50:48 -0000	1.59
+++ fs/xfs/xfs_ag.h	28 Jun 2007 09:47:41 -0000
@@ -69,6 +69,7 @@
 	__be32		agf_freeblks;	/* total free blocks */
 	__be32		agf_longest;	/* longest free space */
 	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
+	__be32		agf_flags;      /* persistent AG state flags */
 } xfs_agf_t;
 
 #define	XFS_AGF_MAGICNUM	0x00000001
@@ -83,7 +84,8 @@
 #define	XFS_AGF_FREEBLKS	0x00000200
 #define	XFS_AGF_LONGEST		0x00000400
 #define	XFS_AGF_BTREEBLKS	0x00000800
-#define	XFS_AGF_NUM_BITS	12
+#define	XFS_AGF_FLAGS		0x00001000
+#define	XFS_AGF_NUM_BITS	13
 #define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
 
 /* disk block (xfs_daddr_t) in the AG */
@@ -196,8 +198,17 @@
 	lock_t		pagb_lock;	/* lock for pagb_list */
 #endif
 	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
+	__u32		 pagf_flags;	/* persistent AG state flags */
 } xfs_perag_t;
 
+typedef struct xfs_ioc_agflags
+{
+	xfs_agnumber_t	ag;
+	__u32		flags;
+} xfs_ioc_agflags_t;
+
+#define XFS_AGF_FLAGS_ALLOC_DENY	(1<<0)
+
 #define	XFS_AG_MAXLEVELS(mp)		((mp)->m_ag_maxlevels)
 #define	XFS_MIN_FREELIST_RAW(bl,cl,mp)	\
 	(MIN(bl + 1, XFS_AG_MAXLEVELS(mp)) + MIN(cl + 1, XFS_AG_MAXLEVELS(mp)))
Index: fs/xfs/xfs_alloc.c
===================================================================
RCS file: /cvs/linux-2.6-xfs/fs/xfs/xfs_alloc.c,v
retrieving revision 1.186
diff -u -r1.186 xfs_alloc.c
--- fs/xfs/xfs_alloc.c	22 May 2007 15:50:48 -0000	1.186
+++ fs/xfs/xfs_alloc.c	28 Jun 2007 09:47:44 -0000
@@ -549,6 +549,7 @@
 	xfs_alloc_arg_t	*args)	/* argument structure for allocation */
 {
 	int		error=0;
+	xfs_perag_t	*pag;
 #ifdef XFS_ALLOC_TRACE
 	static char	fname[] = "xfs_alloc_ag_vextent";
 #endif
@@ -558,6 +559,17 @@
 	ASSERT(args->minlen <= args->maxlen);
 	ASSERT(args->mod < args->prod);
 	ASSERT(args->alignment > 0);
+
+	/*
+	 * Return an error if the a.g. should not be allocated.
+	 * This happens normally during a shrink operation.
+	 */
+	pag = (args->pag);
+	if (unlikely(pag->pagf_flags & XFS_AGF_FLAGS_ALLOC_DENY)) {
+		args->agbno = NULLAGBLOCK;
+		return 0;
+	}
+
 	/*
 	 * Branch to correct routine based on the type.
 	 */
@@ -2085,6 +2097,7 @@
 		offsetof(xfs_agf_t, agf_freeblks),
 		offsetof(xfs_agf_t, agf_longest),
 		offsetof(xfs_agf_t, agf_btreeblks),
+		offsetof(xfs_agf_t, agf_flags),
 		sizeof(xfs_agf_t)
 	};
 
Index: fs/xfs/xfs_fs.h
===================================================================
RCS file: /cvs/linux-2.6-xfs/fs/xfs/xfs_fs.h,v
retrieving revision 1.33
diff -u -r1.33 xfs_fs.h
--- fs/xfs/xfs_fs.h	22 May 2007 15:50:48 -0000	1.33
+++ fs/xfs/xfs_fs.h	28 Jun 2007 09:47:44 -0000
@@ -492,6 +492,8 @@
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+#define XFS_IOC_GET_AGF_FLAGS	     _IOWR('X', 126, struct xfs_ioc_agflags)
+#define XFS_IOC_SET_AGF_FLAGS	     _IOW ('X', 127, struct xfs_ioc_agflags)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
Index: fs/xfs/xfs_fsops.c
===================================================================
RCS file: /cvs/linux-2.6-xfs/fs/xfs/xfs_fsops.c,v
retrieving revision 1.126
diff -u -r1.126 xfs_fsops.c
--- fs/xfs/xfs_fsops.c	8 Jun 2007 16:03:59 -0000	1.126
+++ fs/xfs/xfs_fsops.c	28 Jun 2007 09:47:45 -0000
@@ -649,3 +649,79 @@
 
 	return 0;
 }
+
+STATIC void
+xfs_ag_set_flags_private(
+	xfs_trans_t	*tp,
+	xfs_buf_t	*agbp,	/* buffer for a.g. freelist header */
+	xfs_perag_t	*pag,
+	__u32		flags)
+{
+	xfs_agf_t	*agf;	/* a.g. freespace structure */
+
+	agf = XFS_BUF_TO_AGF(agbp);
+	pag->pagf_flags |= flags;
+	agf->agf_flags = cpu_to_be32(pag->pagf_flags);
+
+	xfs_alloc_log_agf(tp, agbp, XFS_AGF_FLAGS);
+}
+
+__u32
+xfs_ag_get_flags_private(
+	xfs_perag_t	*pag)
+{
+	return pag->pagf_flags;
+}
+
+int
+xfs_ag_set_flags(
+	xfs_mount_t		*mp,
+	xfs_ioc_agflags_t 	*ioc_flags)
+{
+	xfs_agnumber_t  agno;
+	xfs_perag_t	*pag;
+	xfs_buf_t	*bp;
+	int		error;
+	xfs_trans_t	*tp;
+
+	agno = ioc_flags->ag;
+	if (agno >= mp->m_sb.sb_agcount)
+		return -EINVAL;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_AGF_FLAGS);
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
+	xfs_ag_set_flags_private(tp, bp, pag, ioc_flags->flags);
+
+	xfs_trans_set_sync(tp);
+	xfs_trans_commit(tp, 0);
+
+	return 0;
+
+}
+
+int
+xfs_ag_get_flags(
+	xfs_mount_t		*mp,
+	xfs_ioc_agflags_t 	*ioc_flags)
+{
+	xfs_agnumber_t	agno;
+	xfs_perag_t	*pag;
+
+	agno = ioc_flags->ag;
+	if (agno >= mp->m_sb.sb_agcount)
+		return -EINVAL;
+
+	pag = &mp->m_perag[agno];
+	ioc_flags->flags = xfs_ag_get_flags_private(pag);
+	return 0;
+}
Index: fs/xfs/xfs_fsops.h
===================================================================
RCS file: /cvs/linux-2.6-xfs/fs/xfs/xfs_fsops.h,v
retrieving revision 1.29
diff -u -r1.29 xfs_fsops.h
--- fs/xfs/xfs_fsops.h	21 Nov 2005 14:42:36 -0000	1.29
+++ fs/xfs/xfs_fsops.h	28 Jun 2007 09:47:45 -0000
@@ -27,4 +27,7 @@
 extern int xfs_fs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
 extern void xfs_fs_log_dummy(xfs_mount_t *mp);
 
+extern int xfs_ag_set_flags(xfs_mount_t *mp, xfs_ioc_agflags_t *ioc_flags);
+extern int xfs_ag_get_flags(xfs_mount_t *mp, xfs_ioc_agflags_t *ioc_flags);
+
 #endif	/* __XFS_FSOPS_H__ */
Index: fs/xfs/xfs_trans.h
===================================================================
RCS file: /cvs/linux-2.6-xfs/fs/xfs/xfs_trans.h,v
retrieving revision 1.145
diff -u -r1.145 xfs_trans.h
--- fs/xfs/xfs_trans.h	22 May 2007 15:50:48 -0000	1.145
+++ fs/xfs/xfs_trans.h	28 Jun 2007 09:47:46 -0000
@@ -95,7 +95,8 @@
 #define	XFS_TRANS_GROWFSRT_FREE		39
 #define	XFS_TRANS_SWAPEXT		40
 #define	XFS_TRANS_SB_COUNT		41
-#define	XFS_TRANS_TYPE_MAX		41
+#define	XFS_TRANS_AGF_FLAGS		42
+#define	XFS_TRANS_TYPE_MAX		42
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
 
Index: fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
RCS file: /cvs/linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c,v
retrieving revision 1.144
diff -u -r1.144 xfs_ioctl.c
--- fs/xfs/linux-2.6/xfs_ioctl.c	7 Feb 2007 02:50:13 -0000	1.144
+++ fs/xfs/linux-2.6/xfs_ioctl.c	28 Jun 2007 09:47:46 -0000
@@ -860,6 +860,37 @@
 		return 0;
 	}
 
+	case XFS_IOC_GET_AGF_FLAGS: {
+		xfs_ioc_agflags_t inout;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (copy_from_user(&inout, arg, sizeof(inout)))
+			return -XFS_ERROR(EFAULT);
+
+		error = xfs_ag_get_flags(mp, &inout);
+		if (error)
+			return -error;
+
+		if (copy_to_user(arg, &inout, sizeof(inout)))
+			return -XFS_ERROR(EFAULT);
+		return 0;
+	}
+
+	case XFS_IOC_SET_AGF_FLAGS: {
+		xfs_ioc_agflags_t in;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (copy_from_user(&in, arg, sizeof(in)))
+			return -XFS_ERROR(EFAULT);
+
+		error = xfs_ag_set_flags(mp, &in);
+		return -error;
+	}
+
 	case XFS_IOC_FSGROWFSDATA: {
 		xfs_growfs_data_t in;
 

--------------090407080102030706060601--

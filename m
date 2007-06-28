Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Jun 2007 21:51:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5S4owtL029557
	for <xfs@oss.sgi.com>; Wed, 27 Jun 2007 21:51:00 -0700
Date: Thu, 28 Jun 2007 14:50:49 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Implement ioctl to mark AGs as "don't use/use"
Message-ID: <20070628045049.GF989688@sgi.com>
References: <1182939325.5313.12.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182939325.5313.12.camel@localhost>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ruben Porras <nahoo82@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 27, 2007 at 12:15:25PM +0200, Ruben Porras wrote:
> The patch has the following parts:
> 
> - Necessary changes to xfs_ag.h
> - two new ioctls
> - Changes to the allocation functions to avoid using marked AGs
> - Extension to xfs_alloc_log_agf
> 
> This should implement the second step on the requirement list to shrink
> an xfs filesystem. Comment are welcome.

It's a good first cut - comments are inline in the patch below.

> Index: xfs/xfs_ag.h
> ===================================================================
> RCS file: /cvs/linux-2.6-xfs/fs/xfs/xfs_ag.h,v
> retrieving revision 1.59
> diff -u -r1.59 xfs_ag.h
> --- xfs/xfs_ag.h	22 May 2007 15:50:48 -0000	1.59
> +++ xfs/xfs_ag.h	27 Jun 2007 09:06:39 -0000
> @@ -69,6 +69,7 @@
>  	__be32		agf_freeblks;	/* total free blocks */
>  	__be32		agf_longest;	/* longest free space */
>  	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
> +	__be32		agf_flags;      /* the AGF is allocatable */

The comment should say "persistent AG state flags" or something
similar - it's not just for allocation ;)

>  } xfs_agf_t;
>  
>  #define	XFS_AGF_MAGICNUM	0x00000001
> @@ -196,8 +197,17 @@
>  	lock_t		pagb_lock;	/* lock for pagb_list */
>  #endif
>  	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
> +	__u32		 pagf_flags;	/* the AGF is allocatable */

Ditto.

> --- xfs/xfs_alloc.c	22 May 2007 15:50:48 -0000	1.186
> +++ xfs/xfs_alloc.c	27 Jun 2007 09:06:40 -0000
> @@ -549,6 +549,7 @@
>  	xfs_alloc_arg_t	*args)	/* argument structure for allocation */
>  {
>  	int		error=0;
> +	xfs_perag_t	*pag;
>  #ifdef XFS_ALLOC_TRACE
>  	static char	fname[] = "xfs_alloc_ag_vextent";
>  #endif
> @@ -559,6 +560,15 @@
>  	ASSERT(args->mod < args->prod);
>  	ASSERT(args->alignment > 0);
>  	/*
> +	 * Return an error if the a.g. should not be allocated.
> +	 * This happens normally during a shrink operation.
> +	 */
> +        pag = (args->pag);
> +        if (unlikely(pag->pagf_flags & XFS_AGF_FLAGS_ALLOC_DENY)) {
> +		args->agbno = NULLAGBLOCK;
> +		return 0;
> +	}
> +	/*
>  	 * Branch to correct routine based on the type.
>  	 */
>  	args->wasfromfl = 0;

Looks like some whitespace problems there (mixing spaces and tabs).
Also, can you include empty lines either side of a unique hunk of code
like this?

I wonder how many other places we are going to have to put this check?
I haven't looked myself, but this is a good place to start ;)


> Index: xfs/xfs_fs.h
> ===================================================================
> RCS file: /cvs/linux-2.6-xfs/fs/xfs/xfs_fs.h,v
> retrieving revision 1.33
> diff -u -r1.33 xfs_fs.h
> --- xfs/xfs_fs.h	22 May 2007 15:50:48 -0000	1.33
> +++ xfs/xfs_fs.h	27 Jun 2007 09:06:40 -0000
> @@ -476,22 +476,24 @@
>  #define XFS_IOC_OPEN_BY_HANDLE	     _IOWR('X', 107, struct xfs_fsop_handlereq)
>  #define XFS_IOC_READLINK_BY_HANDLE   _IOWR('X', 108, struct xfs_fsop_handlereq)
>  #define XFS_IOC_SWAPEXT		     _IOWR('X', 109, struct xfs_swapext)
> -#define XFS_IOC_FSGROWFSDATA	     _IOW ('X', 110, struct xfs_growfs_data)
> -#define XFS_IOC_FSGROWFSLOG	     _IOW ('X', 111, struct xfs_growfs_log)
> -#define XFS_IOC_FSGROWFSRT	     _IOW ('X', 112, struct xfs_growfs_rt)
> -#define XFS_IOC_FSCOUNTS	     _IOR ('X', 113, struct xfs_fsop_counts)
> -#define XFS_IOC_SET_RESBLKS	     _IOWR('X', 114, struct xfs_fsop_resblks)
> -#define XFS_IOC_GET_RESBLKS	     _IOR ('X', 115, struct xfs_fsop_resblks)
> -#define XFS_IOC_ERROR_INJECTION	     _IOW ('X', 116, struct xfs_error_injection)
> -#define XFS_IOC_ERROR_CLEARALL	     _IOW ('X', 117, struct xfs_error_injection)
> -/*	XFS_IOC_ATTRCTL_BY_HANDLE -- deprecated 118	 */
> -#define XFS_IOC_FREEZE		     _IOWR('X', 119, int)
> -#define XFS_IOC_THAW		     _IOWR('X', 120, int)
> -#define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
> -#define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
> -#define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
> -#define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
> -#define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
> +#define XFS_IOC_GET_AGF_FLAGS       _IOW ('X', 110, struct xfs_ioc_agflags)
> +#define XFS_IOC_SET_AGF_FLAGS       _IOW ('X', 111, struct xfs_ioc_agflags)
> +#define XFS_IOC_FSGROWFSDATA	     _IOW ('X', 111, struct xfs_growfs_data)
> +#define XFS_IOC_FSGROWFSLOG	     _IOW ('X', 112, struct xfs_growfs_log)
> +#define XFS_IOC_FSGROWFSRT	     _IOW ('X', 113, struct xfs_growfs_rt)
> +#define XFS_IOC_FSCOUNTS	     _IOR ('X', 114, struct xfs_fsop_counts)
> +#define XFS_IOC_SET_RESBLKS	     _IOWR('X', 115, struct xfs_fsop_resblks)
> +#define XFS_IOC_GET_RESBLKS	     _IOR ('X', 116, struct xfs_fsop_resblks)
> +#define XFS_IOC_ERROR_INJECTION	     _IOW ('X', 117, struct xfs_error_injection)
> +#define XFS_IOC_ERROR_CLEARALL	     _IOW ('X', 118, struct xfs_error_injection)
> +/*	XFS_IOC_ATTRCTL_BY_HANDLE -- deprecated 119	 */
> +#define XFS_IOC_FREEZE		     _IOWR('X', 120, int)
> +#define XFS_IOC_THAW		     _IOWR('X', 121, int)
> +#define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 122, struct xfs_fsop_setdm_handlereq)
> +#define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 123, struct xfs_fsop_attrlist_handlereq)
> +#define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 124, struct xfs_fsop_attrmulti_handlereq)
> +#define XFS_IOC_FSGEOMETRY	     _IOR ('X', 125, struct xfs_fsop_geom)
> +#define XFS_IOC_GOINGDOWN	     _IOR ('X', 126, __uint32_t)

You shouldn't renumber the existing ioctls - that changes the
interfaces to userspace and so will break lots of stuff :( Just put
them at the end as 126/127. (Oh, you've got two "111" ioctls in
there, anyway ;)

Also, XFS_IOC_GET_AGF_FLAGS needs to be _IOWR as it has input and
output parameters that need to be copied in and out. We only need to
copy in for XFS_IOC_SET_AGF_FLAGS, so _IOW is right for that.
(I think I got that the right way around....)

> +STATIC void
> +xfs_ag_set_flags_private(
> +	xfs_trans_t	*tp,
> +	xfs_buf_t	*agbp,	/* buffer for a.g. freelist header */
> +	xfs_perag_t	*pag,
> +	__u32		flags)
> +{
> +	xfs_agf_t	*agf;	/* a.g. freespace structure */
> +
> +	agf = XFS_BUF_TO_AGF(agbp);
> +	pag->pagf_flags |= flags;
> +	agf->agf_flags = cpu_to_be32(pag->pagf_flags);
> +
> +	xfs_alloc_log_agf(tp, agbp, XFS_TRANS_AGF_FLAGS);

XFS_TRANS_AGF_FLAGS doesn't match with the other AGF log flags.
They are defined in fs/xfs/xfs_ag.h. Search for XFS_AGF_BTREEBLKS
(which is a flag passed to xfs_alloc_log_agf()). You'll also
need to increment XFS_AGF_NUM_BITS....

> +int
> +xfs_ag_set_flags(
> +	xfs_mount_t		*mp,
> +	xfs_ioc_agflags_t 	*ioc_flags)
> +{
> +	xfs_agnumber_t  agno;
> +	xfs_perag_t	*pag;
> +	xfs_buf_t	*bp;
> +	int		error;
> +	xfs_trans_t	*tp;
> +
> +	agno = ioc_flags->ag;
> +	if (agno >= mp->m_sb.sb_agcount)
> +		return -EINVAL;
> +
> +	tp = xfs_trans_alloc(mp, XFS_TRANS_AGF_FLAGS);

Ah, i see the confusion now...

Ok, so the transaction type definition is different to the field in a
structure that is being logged. The flag passed into xfs_trans_alloc() is
placed in the transaction header in the log to describe the type of
transaction that needs to be recovered. Some transaction types require special
handling and so we ned to be able to tell what type of transaction it is in
the log. These are defined in fs/xfs/xfs_trans.h (search for
XFS_TRANS_SB_COUNT).

The flag passed to xfs_alloc_log_agf() tells the transaction which
bits in the AGF are being modified as only the modified bits of
the AGF are logged in the transaction. it is only used within
the xfs_alloc_log_agf() function and is used to look up the
offset into the AGF of the modified field(s).

IOWs, the flag passed to xfs_trans_alloc() defines the type of the
transaction and the flag passed to xfs_alloc_log_agf() defines what
has been modified within the transaction.

> Index: xfs/xfs_trans.h
> ===================================================================
> RCS file: /cvs/linux-2.6-xfs/fs/xfs/xfs_trans.h,v
> retrieving revision 1.145
> diff -u -r1.145 xfs_trans.h
> --- xfs/xfs_trans.h	22 May 2007 15:50:48 -0000	1.145
> +++ xfs/xfs_trans.h	27 Jun 2007 09:06:41 -0000
> @@ -418,6 +418,10 @@
>  #define	XFS_TRANS_SB_REXTENTS		0x00001000
>  #define	XFS_TRANS_SB_REXTSLOG		0x00002000
>  
> +/*
> + * Value for xfs_trans_mod_agf
> + */
> +#define XFS_TRANS_AGF_FLAGS             0x00004000

This is the transaction type, and so needs to be defined as
the next transaction after XFS_TRANS_SB_COUNT.

> @@ -860,6 +860,38 @@
>  		return 0;
>  	}
>  
> +	case XFS_IOC_GET_AGF_FLAGS: {
> +		xfs_ioc_agflags_t in;
> +               __u32 out;
> +
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EPERM;
> +
> +		if (copy_from_user(&in, arg, sizeof(in)))
> +			return -XFS_ERROR(EFAULT);
> +
> +		error = xfs_ag_get_flags(mp, &in, &out);
> +		if (error)
> +			return -error;
> +
> +		if (copy_to_user(arg, &out, sizeof(out)))
> +			return -XFS_ERROR(EFAULT);

I'm don't think that is correct - the flags need to be placed into
the structure that was passed in, not completely overwritten.

That is:

+	case XFS_IOC_GET_AGF_FLAGS: {
+		xfs_ioc_agflags_t inout;
+               __u32 out;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (copy_from_user(&inout, arg, sizeof(inout)))
+			return -XFS_ERROR(EFAULT);
+
+		error = xfs_ag_get_flags(mp, &inout, &out);
+		if (error)
+			return -error;
+
+		inout->flags = out;
+		if (copy_to_user(arg, &inout, sizeof(inout)))
+			return -XFS_ERROR(EFAULT);

Basically, our input structure is also the output structure, and
we need to put the flags:

+typedef struct xfs_ioc_agflags
+{
+       xfs_agnumber_t  ag;
+       __u32           flags;     <<<<<<<< here
+} xfs_ioc_agflags_t;



Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

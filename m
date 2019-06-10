Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51906 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390384AbfFJOCc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jun 2019 10:02:32 -0400
Date: Mon, 10 Jun 2019 10:02:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/10] xfs: convert bulkstat to new iwalk infrastructure
Message-ID: <20190610140226.GD6473@bfoster>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968499323.1657646.9567491795149169699.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155968499323.1657646.9567491795149169699.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 02:49:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a new ibulk structure incore to help us deal with bulk inode stat
> state tracking and then convert the bulkstat code to use the new iwalk
> iterator.  This disentangles inode walking from bulk stat control for
> simpler code and enables us to isolate the formatter functions to the
> ioctl handling code.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c   |   65 ++++++--
>  fs/xfs/xfs_ioctl.h   |    5 +
>  fs/xfs/xfs_ioctl32.c |   88 +++++------
>  fs/xfs/xfs_itable.c  |  407 ++++++++++++++------------------------------------
>  fs/xfs/xfs_itable.h  |   79 ++++------
>  5 files changed, 245 insertions(+), 399 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 5ffbdcff3dba..43734901aeb9 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
...
> @@ -745,35 +757,54 @@ xfs_ioc_bulkstat(
>  	if (copy_from_user(&bulkreq, arg, sizeof(xfs_fsop_bulkreq_t)))
>  		return -EFAULT;
>  
> -	if (copy_from_user(&inlast, bulkreq.lastip, sizeof(__s64)))
> +	if (copy_from_user(&lastino, bulkreq.lastip, sizeof(__s64)))
>  		return -EFAULT;
>  
> -	if ((count = bulkreq.icount) <= 0)
> +	if (bulkreq.icount <= 0)
>  		return -EINVAL;
>  
>  	if (bulkreq.ubuffer == NULL)
>  		return -EINVAL;
>  
> -	if (cmd == XFS_IOC_FSINUMBERS)
> -		error = xfs_inumbers(mp, &inlast, &count,
> +	breq.ubuffer = bulkreq.ubuffer;
> +	breq.icount = bulkreq.icount;
> +
> +	/*
> +	 * FSBULKSTAT_SINGLE expects that *lastip contains the inode number
> +	 * that we want to stat.  However, FSINUMBERS and FSBULKSTAT expect
> +	 * that *lastip contains either zero or the number of the last inode to
> +	 * be examined by the previous call and return results starting with
> +	 * the next inode after that.  The new bulk request functions take the
> +	 * inode to start with, so we have to adjust the lastino/startino
> +	 * parameter to maintain correct function.
> +	 */

It's kind of difficult to tell what's new or old when just looking at
the code. The comment suggests FSINUMBERS and FSBULKSTAT use the same
interface wrt to lastip, but they aren't handled the same below. I take
it this is because xfs_inumbers() still has the same behavior whereas
xfs_bulkstat() has been changed to operate based on breq rather than
lastip..?

> +	if (cmd == XFS_IOC_FSINUMBERS) {
> +		int	count = breq.icount;
> +
> +		breq.startino = lastino;
> +		error = xfs_inumbers(mp, &breq.startino, &count,
>  					bulkreq.ubuffer, xfs_inumbers_fmt);
> -	else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE)
> -		error = xfs_bulkstat_one(mp, inlast, bulkreq.ubuffer,
> -					sizeof(xfs_bstat_t), NULL, &done);
> -	else	/* XFS_IOC_FSBULKSTAT */
> -		error = xfs_bulkstat(mp, &inlast, &count, xfs_bulkstat_one,
> -				     sizeof(xfs_bstat_t), bulkreq.ubuffer,
> -				     &done);
> +		breq.ocount = count;
> +		lastino = breq.startino;
> +	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE) {
> +		breq.startino = lastino;
> +		error = xfs_bulkstat_one(&breq, xfs_bulkstat_one_fmt);
> +		lastino = breq.startino;
> +	} else {	/* XFS_IOC_FSBULKSTAT */
> +		breq.startino = lastino + 1;
> +		error = xfs_bulkstat(&breq, xfs_bulkstat_one_fmt);
> +		lastino = breq.startino - 1;
> +	}
>  
...
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 814ffe6fbab7..add15819daf3 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
...
> @@ -284,38 +263,57 @@ xfs_compat_ioc_bulkstat(
>  		return -EFAULT;
>  	bulkreq.ocount = compat_ptr(addr);
>  
> -	if (copy_from_user(&inlast, bulkreq.lastip, sizeof(__s64)))
> +	if (copy_from_user(&lastino, bulkreq.lastip, sizeof(__s64)))
>  		return -EFAULT;
> +	breq.startino = lastino + 1;
>  
> -	if ((count = bulkreq.icount) <= 0)
> +	if (bulkreq.icount <= 0)
>  		return -EINVAL;
>  
>  	if (bulkreq.ubuffer == NULL)
>  		return -EINVAL;
>  
> +	breq.ubuffer = bulkreq.ubuffer;
> +	breq.icount = bulkreq.icount;
> +
> +	/*
> +	 * FSBULKSTAT_SINGLE expects that *lastip contains the inode number
> +	 * that we want to stat.  However, FSINUMBERS and FSBULKSTAT expect
> +	 * that *lastip contains either zero or the number of the last inode to
> +	 * be examined by the previous call and return results starting with
> +	 * the next inode after that.  The new bulk request functions take the
> +	 * inode to start with, so we have to adjust the lastino/startino
> +	 * parameter to maintain correct function.
> +	 */

(Same comment here.)

>  	if (cmd == XFS_IOC_FSINUMBERS_32) {
> -		error = xfs_inumbers(mp, &inlast, &count,
> +		int	count = breq.icount;
> +
> +		breq.startino = lastino;
> +		error = xfs_inumbers(mp, &breq.startino, &count,
>  				bulkreq.ubuffer, inumbers_func);
> +		breq.ocount = count;
> +		lastino = breq.startino;
>  	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE_32) {
> -		int res;
> -
> -		error = bs_one_func(mp, inlast, bulkreq.ubuffer,
> -				bs_one_size, NULL, &res);
> +		breq.startino = lastino;
> +		error = xfs_bulkstat_one(&breq, bs_one_func);
> +		lastino = breq.startino;
>  	} else if (cmd == XFS_IOC_FSBULKSTAT_32) {
> -		error = xfs_bulkstat(mp, &inlast, &count,
> -			bs_one_func, bs_one_size,
> -			bulkreq.ubuffer, &done);
> -	} else
> +		breq.startino = lastino + 1;
> +		error = xfs_bulkstat(&breq, bs_one_func);
> +		lastino = breq.startino - 1;
> +	} else {
>  		error = -EINVAL;
> +	}
>  	if (error)
>  		return error;
>  
> +	lastino = breq.startino - 1;

Should this be here?

>  	if (bulkreq.lastip != NULL &&
> -	    copy_to_user(bulkreq.lastip, &inlast, sizeof(xfs_ino_t)))
> +	    copy_to_user(bulkreq.lastip, &lastino, sizeof(xfs_ino_t)))
>  		return -EFAULT;
>  
>  	if (bulkreq.ocount != NULL &&
> -	    copy_to_user(bulkreq.ocount, &count, sizeof(count)))
> +	    copy_to_user(bulkreq.ocount, &breq.ocount, sizeof(__s32)))
>  		return -EFAULT;
>  
>  	return 0;
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 3ca1c454afe6..87c597ea1df7 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -22,37 +22,63 @@
>  #include "xfs_iwalk.h"
>  
>  /*
> - * Return stat information for one inode.
> - * Return 0 if ok, else errno.
> + * Bulk Stat
> + * =========
> + *
> + * Use the inode walking functions to fill out struct xfs_bstat for every
> + * allocated inode, then pass the stat information to some externally provided
> + * iteration function.
>   */
> -int
> +
> +struct xfs_bstat_chunk {
> +	bulkstat_one_fmt_pf	formatter;
> +	struct xfs_ibulk	*breq;
> +};
> +
> +/*
> + * Fill out the bulkstat info for a single inode and report it somewhere.
> + *
> + * bc->breq->lastino is effectively the inode cursor as we walk through the
> + * filesystem.  Therefore, we update it any time we need to move the cursor
> + * forward, regardless of whether or not we're sending any bstat information
> + * back to userspace.  If the inode is internal metadata or, has been freed
> + * out from under us, we just simply keep going.
> + *
> + * However, if any other type of error happens we want to stop right where we
> + * are so that userspace will call back with exact number of the bad inode and
> + * we can send back an error code.
> + *
> + * Note that if the formatter tells us there's no space left in the buffer we
> + * move the cursor forward and abort the walk.
> + */
> +STATIC int
>  xfs_bulkstat_one_int(
> -	struct xfs_mount	*mp,		/* mount point for filesystem */
> -	xfs_ino_t		ino,		/* inode to get data for */
> -	void __user		*buffer,	/* buffer to place output in */
> -	int			ubsize,		/* size of buffer */
> -	bulkstat_one_fmt_pf	formatter,	/* formatter, copy to user */
> -	int			*ubused,	/* bytes used by me */
> -	int			*stat)		/* BULKSTAT_RV_... */
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_ino_t		ino,
> +	void			*data)
>  {

Any reason this function takes an 'ino' param considering it's sourced
from breq->startino and we bump that value from within this function?
The latter seems slightly misplaced to me since it doesn't appear to
control the iteration.

It also looks like we bump startino in almost all cases. Exceptions are
memory allocation failure of the buffer and formatter error. Hmm.. could
we lift the buffer to the bc and reuse it to avoid that error entirely
(along with repeated allocs/frees)? From there, perhaps we could lift
the ->startino update to the callers based on something like error !=
-EFAULT..? (Alternatively, the caller could update it first and then
walk it back if error == -EFAULT).

> +	struct xfs_bstat_chunk	*bc = data;
>  	struct xfs_icdinode	*dic;		/* dinode core info pointer */
>  	struct xfs_inode	*ip;		/* incore inode pointer */
>  	struct inode		*inode;
>  	struct xfs_bstat	*buf;		/* return buffer */
>  	int			error = 0;	/* error value */
>  
> -	*stat = BULKSTAT_RV_NOTHING;
> -
> -	if (!buffer || xfs_internal_inum(mp, ino))
> +	if (xfs_internal_inum(mp, ino)) {
> +		bc->breq->startino = ino + 1;
>  		return -EINVAL;
> +	}
>  
>  	buf = kmem_zalloc(sizeof(*buf), KM_SLEEP | KM_MAYFAIL);
>  	if (!buf)
>  		return -ENOMEM;
>  
> -	error = xfs_iget(mp, NULL, ino,
> +	error = xfs_iget(mp, tp, ino,
>  			 (XFS_IGET_DONTCACHE | XFS_IGET_UNTRUSTED),
>  			 XFS_ILOCK_SHARED, &ip);
> +	if (error == -ENOENT || error == -EINVAL)
> +		bc->breq->startino = ino + 1;
>  	if (error)
>  		goto out_free;
>  
> @@ -119,43 +145,45 @@ xfs_bulkstat_one_int(
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  	xfs_irele(ip);
>  
> -	error = formatter(buffer, ubsize, ubused, buf);
> -	if (!error)
> -		*stat = BULKSTAT_RV_DIDONE;
> -
> - out_free:
> +	error = bc->formatter(bc->breq, buf);
> +	switch (error) {
> +	case XFS_IBULK_BUFFER_FULL:
> +		error = XFS_IWALK_ABORT;
> +		/* fall through */
> +	case 0:
> +		bc->breq->startino = ino + 1;
> +		break;
> +	}
> +out_free:
>  	kmem_free(buf);
>  	return error;
>  }
>  
> -/* Return 0 on success or positive error */
> -STATIC int
> -xfs_bulkstat_one_fmt(
> -	void			__user *ubuffer,
> -	int			ubsize,
> -	int			*ubused,
> -	const xfs_bstat_t	*buffer)
> -{
> -	if (ubsize < sizeof(*buffer))
> -		return -ENOMEM;
> -	if (copy_to_user(ubuffer, buffer, sizeof(*buffer)))
> -		return -EFAULT;
> -	if (ubused)
> -		*ubused = sizeof(*buffer);
> -	return 0;
> -}
> -
> +/* Bulkstat a single inode. */
>  int
>  xfs_bulkstat_one(
> -	xfs_mount_t	*mp,		/* mount point for filesystem */
> -	xfs_ino_t	ino,		/* inode number to get data for */
> -	void		__user *buffer,	/* buffer to place output in */
> -	int		ubsize,		/* size of buffer */
> -	int		*ubused,	/* bytes used by me */
> -	int		*stat)		/* BULKSTAT_RV_... */
> +	struct xfs_ibulk	*breq,
> +	bulkstat_one_fmt_pf	formatter)
>  {
> -	return xfs_bulkstat_one_int(mp, ino, buffer, ubsize,
> -				    xfs_bulkstat_one_fmt, ubused, stat);
> +	struct xfs_bstat_chunk	bc = {
> +		.formatter	= formatter,
> +		.breq		= breq,
> +	};
> +	int			error;
> +
> +	breq->icount = 1;
> +	breq->ocount = 0;
> +

So ->icount is already set by the caller based on user input. I'd guess
this is set here to guarantee a single cycle in the event that the user
provided value is >1, but that seems unnecessary since we're calling the
internal helper to handle a single inode.

If we want to set ->icount for whatever reason, can we do it in the
caller where it's more obvious? That also shows that the ->ocount init
is unnecessary since the whole structure is initialized in the caller.

> +	error = xfs_bulkstat_one_int(breq->mp, NULL, breq->startino, &bc);
> +
> +	/*
> +	 * If we reported one inode to userspace then we abort because we hit
> +	 * the end of the buffer.  Don't leak that back to userspace.
> +	 */
> +	if (error == XFS_IWALK_ABORT)
> +		error = 0;
> +
> +	return error;
>  }
>  
>  /*
...
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index 369e3f159d4e..366d391eb11f 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -5,63 +5,46 @@
>  #ifndef __XFS_ITABLE_H__
>  #define	__XFS_ITABLE_H__
>  
> -/*
> - * xfs_bulkstat() is used to fill in xfs_bstat structures as well as dm_stat
> - * structures (by the dmi library). This is a pointer to a formatter function
> - * that will iget the inode and fill in the appropriate structure.
> - * see xfs_bulkstat_one() and xfs_dm_bulkstat_one() in dmapi_xfs.c
> - */
> -typedef int (*bulkstat_one_pf)(struct xfs_mount	*mp,
> -			       xfs_ino_t	ino,
> -			       void		__user *buffer,
> -			       int		ubsize,
> -			       int		*ubused,
> -			       int		*stat);
> +/* In-memory representation of a userspace request for batch inode data. */
> +struct xfs_ibulk {
> +	struct xfs_mount	*mp;
> +	void __user		*ubuffer; /* user output buffer */
> +	xfs_ino_t		startino; /* start with this inode */
> +	unsigned int		icount;   /* number of elements in ubuffer */
> +	unsigned int		ocount;   /* number of records returned */
> +};
> +
> +/* Return value that means we want to abort the walk. */
> +#define XFS_IBULK_ABORT		(XFS_IWALK_ABORT)
> +
> +/* Return value that means the formatting buffer is now full. */
> +#define XFS_IBULK_BUFFER_FULL	(2)
>  

It might be wise to define this such that it's guaranteed not to be the
same as the abort value, since that is defined externally to this
header. IBULK_ABORT + 1 perhaps?

Brian

>  /*
> - * Values for stat return value.
> + * Advance the user buffer pointer by one record of the given size.  If the
> + * buffer is now full, return the appropriate error code.
>   */
> -#define BULKSTAT_RV_NOTHING	0
> -#define BULKSTAT_RV_DIDONE	1
> -#define BULKSTAT_RV_GIVEUP	2
> +static inline int
> +xfs_ibulk_advance(
> +	struct xfs_ibulk	*breq,
> +	size_t			bytes)
> +{
> +	char __user		*b = breq->ubuffer;
> +
> +	breq->ubuffer = b + bytes;
> +	breq->ocount++;
> +	return breq->ocount == breq->icount ? XFS_IBULK_BUFFER_FULL : 0;
> +}
>  
>  /*
>   * Return stat information in bulk (by-inode) for the filesystem.
>   */
> -int					/* error status */
> -xfs_bulkstat(
> -	xfs_mount_t	*mp,		/* mount point for filesystem */
> -	xfs_ino_t	*lastino,	/* last inode returned */
> -	int		*count,		/* size of buffer/count returned */
> -	bulkstat_one_pf formatter,	/* func that'd fill a single buf */
> -	size_t		statstruct_size,/* sizeof struct that we're filling */
> -	char		__user *ubuffer,/* buffer with inode stats */
> -	int		*done);		/* 1 if there are more stats to get */
>  
> -typedef int (*bulkstat_one_fmt_pf)(  /* used size in bytes or negative error */
> -	void			__user *ubuffer, /* buffer to write to */
> -	int			ubsize,		 /* remaining user buffer sz */
> -	int			*ubused,	 /* bytes used by formatter */
> -	const xfs_bstat_t	*buffer);        /* buffer to read from */
> +typedef int (*bulkstat_one_fmt_pf)(struct xfs_ibulk *breq,
> +		const struct xfs_bstat *bstat);
>  
> -int
> -xfs_bulkstat_one_int(
> -	xfs_mount_t		*mp,
> -	xfs_ino_t		ino,
> -	void			__user *buffer,
> -	int			ubsize,
> -	bulkstat_one_fmt_pf	formatter,
> -	int			*ubused,
> -	int			*stat);
> -
> -int
> -xfs_bulkstat_one(
> -	xfs_mount_t		*mp,
> -	xfs_ino_t		ino,
> -	void			__user *buffer,
> -	int			ubsize,
> -	int			*ubused,
> -	int			*stat);
> +int xfs_bulkstat_one(struct xfs_ibulk *breq, bulkstat_one_fmt_pf formatter);
> +int xfs_bulkstat(struct xfs_ibulk *breq, bulkstat_one_fmt_pf formatter);
>  
>  typedef int (*inumbers_fmt_pf)(
>  	void			__user *ubuffer, /* buffer to write to */
> 

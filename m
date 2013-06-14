Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 08AC07CBF
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 21:17:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EAD04304032
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 19:17:24 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	5r2GDErVShn3bEe8 for <xfs@oss.sgi.com>;
	Thu, 13 Jun 2013 19:17:22 -0700 (PDT)
Date: Fri, 14 Jun 2013 12:17:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfs: fix the symbolic link assert in xfs_ifree
Message-ID: <20130614021720.GR29338@dastard>
References: <20130613170449.144027450@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130613170449.144027450@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 13, 2013 at 12:04:49PM -0500, Mark Tinguely wrote:
> Adding an extended attribute to a symbolic link can force that
> link to an remote extent. xfs_inactive() incorrectly assumes
> that any symbolic link small enough to be in the inode core
> is incore, resulting in the remote extent to not be removed.
> xfs_ifree() will assert on presence of this leaked remote extent.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
.....
> +/*
> + * xfs_inactive_symlink - free a symlink
> + */
> +int
> +xfs_inactive_symlink(
> +	struct xfs_inode	*ip,
> +	struct xfs_trans	**tp)
> +{
> +	struct xfs_mount *mp = ip->i_mount;
> +	xfs_fsize_t	pathlen;

int will do here - it can't be more than MAXPATHLEN = 1024, and this
gets rid of the casts in the error print.

> +
> +	trace_xfs_readlink(ip);

trace_xfs_inactive_symlink, as you mentioned ;)

> +
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return XFS_ERROR(EIO);
> +
> +	/*
> +	 * Zero length symlinks _can_ exist.
> +	 */
> +	pathlen = ip->i_d.di_size;
> +	if (!pathlen)
> +		return 0;
> +
> +	if (pathlen < 0 || pathlen > MAXPATHLEN) {
> +		xfs_alert(mp, "%s: inode (%llu) bad symlink length (%lld)",
> +			 __func__, (unsigned long long) ip->i_ino,
                                                       ^ whitespace
> +			 (long long) pathlen);

Can we change this to a hex-based inode number (much easier to read)
and the pathlen cast can go away if you use an int. i.e.:

		xfs_alert(mp, "%s: inode (0x%llx) bad symlink length (%d)",
			 __func__, (unsigned long long)ip->i_ino, pathlen);


> +		ASSERT(0);
> +		return XFS_ERROR(EFSCORRUPTED);
> +	}
> +
> +	if (ip->i_df.if_flags & XFS_IFINLINE) {
> +		if (ip->i_df.if_bytes > 0)
> +			xfs_idata_realloc(ip, -(ip->i_df.if_bytes),
> +					  XFS_DATA_FORK);
> +		ASSERT(ip->i_df.if_bytes == 0);
> +		return 0;
> +	}
> +
> +	/* remove the remote symlink */
> +	return(xfs_inactive_symlink_rmt(ip, tp));

And no () around xfs_inactive_symlink_rmt().

> +}
> Index: b/fs/xfs/xfs_symlink.h
> ===================================================================
> --- a/fs/xfs/xfs_symlink.h
> +++ b/fs/xfs/xfs_symlink.h
> @@ -60,7 +60,7 @@ extern const struct xfs_buf_ops xfs_syml
>  int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
>  		const char *target_path, umode_t mode, struct xfs_inode **ipp);
>  int xfs_readlink(struct xfs_inode *ip, char *link);
> -int xfs_inactive_symlink_rmt(struct xfs_inode *ip, struct xfs_trans **tpp);
> +int xfs_inactive_symlink(struct xfs_inode *ip, struct xfs_trans **tpp);
>  
>  #endif /* __KERNEL__ */
>  #endif /* __XFS_SYMLINK_H */
> Index: b/fs/xfs/xfs_trace.h
> ===================================================================
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -594,6 +594,8 @@ DEFINE_INODE_EVENT(xfs_inode_set_eofbloc
>  DEFINE_INODE_EVENT(xfs_inode_clear_eofblocks_tag);
>  DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
>  
> +DEFINE_INODE_EVENT(xfs_symlink_inactive);
> +

No need for the extra whitespace, just put it hard up against the
other DEFINE_INODE_EVENT()s. Might be better to put it directly
after the readlink trace definition.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

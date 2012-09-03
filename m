Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8355Kxl143791 for <xfs@oss.sgi.com>; Mon, 3 Sep 2012 00:05:21 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	0a8UodXJNS2S2Yci for <xfs@oss.sgi.com>;
	Sun, 02 Sep 2012 22:06:15 -0700 (PDT)
Date: Mon, 3 Sep 2012 15:06:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 2/4] xfs: create function to scan and clear EOFBLOCKS
	inodes
Message-ID: <20120903050612.GR15292@dastard>
References: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
	<1346097111-4476-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1346097111-4476-3-git-send-email-bfoster@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 27, 2012 at 03:51:49PM -0400, Brian Foster wrote:
> xfs_inodes_free_eofblocks() implements scanning functionality for
> EOFBLOCKS inodes. It scans the radix tree and frees post-EOF blocks
> for inodes that meet particular criteria. The scan can be filtered
> by a particular quota type/id and minimum file size. The scan can
> also be invoked in trylock mode or wait (force) mode.
> 
> The xfs_free_eofblocks() helper is invoked to clear post-EOF space.
> It is slightly modified to support an output parameter that
> indicates whether space was freed and helps decide whether the
> EOFBLOCKS tag should be cleared in trylock scans.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_sync.c     |  168 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_sync.h     |    3 +
>  fs/xfs/xfs_vnodeops.c |   17 +++--
>  fs/xfs/xfs_vnodeops.h |    2 +
>  4 files changed, 184 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
> index 5e14741..27c3c46 100644
> --- a/fs/xfs/xfs_sync.c
> +++ b/fs/xfs/xfs_sync.c
> @@ -971,6 +971,174 @@ xfs_reclaim_inodes_count(
>  	return reclaimable;
>  }
>  
> +/*
> + * Handle an EOFBLOCKS tagged inode. If this is a forced scan, we wait on the
> + * iolock ourselves rather than rely on the trylock in xfs_free_eofblocks(). 
> + *
> + * We rely on the output parameter from xfs_free_eofblocks() to determine
> + * whether we should clear the tag because in the trylock case, it could have
> + * skipped the inode due to lock contention.
> + */
> +STATIC int
> +xfs_inode_free_eofblocks(
> +	struct xfs_inode	*ip,
> +	int			flags)
> +{
> +	int ret = 0;
> +	bool freed = false;
> +	bool wait_iolock = (flags & EOFBLOCKS_WAIT) ? true : false;
> +
> +	if (wait_iolock)
> +		xfs_ilock(ip, XFS_IOLOCK_EXCL);

Why do we need the IO lock here? xfs_free_eofblocks() does all the
necessary locking....

> +
> +	if ((S_ISREG(ip->i_d.di_mode) &&
> +	     (VFS_I(ip)->i_size > 0 ||
> +	     (VN_CACHED(VFS_I(ip)) > 0 || ip->i_delayed_blks > 0)) &&
> +	     (ip->i_df.if_flags & XFS_IFEXTENTS)) &&
> +	    (!(ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))) {

This check is now repeated in 3 places - xfs_inactive, xfs_release
and now here. I think it needs a helper.

> +		/* !wait_iolock == need_iolock in xfs_free_eofblocks() */
> +		ret = xfs_free_eofblocks(ip->i_mount, ip, !wait_iolock, &freed);
> +		if (freed)
> +			xfs_inode_clear_eofblocks_tag(ip);

If you move xfs_inode_clear_eofblocks_tag() inside
xfs_free_eofblocks(), there's no need for this extra return value.

> +	} else {
> +		/* inode could be preallocated or append-only */
> +		xfs_inode_clear_eofblocks_tag(ip);

This should be a rare event - it's probably worth adding a pair of
trace events here for the two cases so we can see if there is ever a
significant number of inodes being scanned for prealloc that can't
be cleared...

(e.g 'perf top -e xfs:xfs_i*' to count all the inode events)

> +	}
> +
> +	if (wait_iolock)
> +		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> +
> +	return ret;
> +}
> +
> +/*
> + * Determine whether an inode matches a particular qouta id.
> + */
> +STATIC int
> +xfs_inode_match_quota_id(
> +	struct xfs_inode	*ip,
> +	int			qtype,
> +	uint32_t		id)
> +{
> +	switch (qtype) {
> +	case XFS_DQ_USER:
> +		return ip->i_d.di_uid == id;
> +	case XFS_DQ_GROUP:
> +		return ip->i_d.di_gid == id;
> +	default:
> +		return xfs_get_projid(ip) == id;
> +	}
> +
> +	return 0;
> +}

There's nothing really quota specific about this scan. I'd leave
this functionality to a separate patch once all the core
infrastructure is in place.

> +
> +/*
> + * This is mostly copied from xfs_reclaim_inodes_ag().
> + *
> + * TODO:
> + * - Could we enhance ag_iterator to support a tag and use it instead of this?

Yes. This code is too tricky to duplicate for every use case, and
this doesn't have special case requirements like the reclaim code.

i.e. the xfs_inode_free_eofblocks() becomes the execute function
(and the quota checks move inside that eventually). Passing a tag of
"-1" would indicate a non-tag lookup, otherwise use a tag based
lookup. Given the extra fields that this version uses, passing a
void *args is probably necessary so that a structure can be passed
to the execute function along with the flags....

I'd suggest this conversion should be done in a patch prior to
introducing this scanner.

FWIW, this is going to conflict with my "get rid of xfs-sync.c patch
series, so we'll need to work out who rebases what at some point.

> + */
> +int
> +xfs_inodes_free_eofblocks(
> +	struct xfs_mount	*mp,
> +	int			qtype,
> +	uint32_t		id,
> +	uint64_t		min_file_size,
> +	int			flags)
> +{
.....
> +			for (i = 0; i < nr_found; i++) {
> +				if (!batch[i])
> +					continue;
> +
> +				/* default projid represents a full scan */

I don't think thats a good idea. From a normal users perspective,
the background trimming will occur irrespective of the quota groups
the inode is part of. Background trimming defines the default
behaviour, because that's what 99.99% of users will see active, not
quota/application specific events driven through ioctls.

IOWs, selecting inodes by quota type/id for pruning is a secondary
function of the execute implementation, not a primary concern of the
infrastructure.

> +				if ((!(qtype == XFS_DQ_PROJ &&
> +				       id == XFS_PROJID_DEFAULT) &&
> +				     !xfs_inode_match_quota_id(batch[i], qtype,
> +							       id)) ||
> +				    (min_file_size && XFS_ISIZE(batch[i]) < 
> +								min_file_size)

> +				   ) {
> +					IRELE(batch[i]);
> +					continue;
> +				}

Moving this check to the execute function will get rid of the indent
mess....

> +
> +				error = xfs_inode_free_eofblocks(batch[i], flags);
> +				IRELE(batch[i]);
> +				if (error)
> +					last_error = error;
> +			}
> +
> +			cond_resched();
> +
> +		} while (nr_found && !done);
> +
> +		xfs_perag_put(pag);
> +	}
> +
> +	return XFS_ERROR(last_error);
> +}
> +
>  STATIC void
>  __xfs_inode_set_eofblocks_tag(
>  	struct xfs_perag	*pag,
> diff --git a/fs/xfs/xfs_sync.h b/fs/xfs/xfs_sync.h
> index 4486491..78aca41 100644
> --- a/fs/xfs/xfs_sync.h
> +++ b/fs/xfs/xfs_sync.h
> @@ -43,8 +43,11 @@ void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
>  void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
>  				struct xfs_inode *ip);
>  
> +#define EOFBLOCKS_WAIT		0x0001

I'd just reuse SYNC_WAIT and SYNC_TRYLOCK which are already defined
and used by the sync and reclaim iterators.

> +
>  void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
>  void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
> +int xfs_inodes_free_eofblocks(struct xfs_mount *, int, uint32_t, uint64_t, int);
>  
>  int xfs_sync_inode_grab(struct xfs_inode *ip);
>  int xfs_inode_ag_iterator(struct xfs_mount *mp,
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index 658ee2e..53460f3 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -150,11 +150,12 @@ xfs_readlink(
>   * when the link count isn't zero and by xfs_dm_punch_hole() when
>   * punching a hole to EOF.
>   */
> -STATIC int
> +int
>  xfs_free_eofblocks(
>  	xfs_mount_t	*mp,
>  	xfs_inode_t	*ip,
> -	bool		need_iolock)
> +	bool		need_iolock,
> +	bool		*blocks_freed)

I don't really see a point to adding this. Either we removed all the
EOF blocks or we didn't, and that means we should just clear the
tags directly in this function if it is appropriate.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

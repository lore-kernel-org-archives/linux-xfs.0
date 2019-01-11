Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56516 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388129AbfAKTFu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Jan 2019 14:05:50 -0500
Date: Fri, 11 Jan 2019 14:05:47 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/12] xfs: refactor the predicate part of
 xfs_free_eofblocks
Message-ID: <20190111190547.GB33275@bfoster>
References: <154630901076.16693.13111277988041606505.stgit@magnolia>
 <154630902321.16693.17215403042253916619.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154630902321.16693.17215403042253916619.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 31, 2018 at 06:17:03PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the part of _free_eofblocks that decides if it's really going
> to truncate post-EOF blocks into a separate helper function.  The
> upcoming deferred inode inactivation patch requires us to be able to
> decide this prior to actual inactivation.  No functionality changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_util.c |  101 ++++++++++++++++++++----------------------------
>  fs/xfs/xfs_inode.c     |   32 +++++++++++++++
>  fs/xfs/xfs_inode.h     |    1 
>  3 files changed, 75 insertions(+), 59 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c8bf02be0003..662ee537ffb5 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3568,3 +3568,35 @@ xfs_irele(
>  	trace_xfs_irele(ip, _RET_IP_);
>  	iput(VFS_I(ip));
>  }
> +
> +/*
> + * Decide if this inode have post-EOF blocks.  The caller is responsible
> + * for knowing / caring about the PREALLOC/APPEND flags.
> + */
> +bool
> +xfs_inode_has_posteof_blocks(

I think something like xfs_has_eofblocks() is more consistent with the
other related function names (i.e., xfs_free_eofblocks(),
xfs_can_free_eofblocks(), etc.).

> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_bmbt_irec	imap;
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_fileoff_t		end_fsb;
> +	xfs_fileoff_t		last_fsb;
> +	xfs_filblks_t		map_len;
> +	int			nimaps;
> +	int			error;
> +
> +	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
> +	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> +	if (last_fsb <= end_fsb)
> +		return false;
> +	map_len = last_fsb - end_fsb;
> +
> +	nimaps = 1;
> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	error = xfs_bmapi_read(ip, end_fsb, map_len, &imap, &nimaps, 0);
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +
> +	return !error && (nimaps != 0) &&
> +	       (imap.br_startblock != HOLESTARTBLOCK ||
> +	        ip->i_delayed_blks);

I don't think we should be suppressing this error. It's a divergence
from the current code at least.

Brian

> +}
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index be2014520155..02a938661ba8 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -499,5 +499,6 @@ extern struct kmem_zone	*xfs_inode_zone;
>  #define XFS_DEFAULT_COWEXTSZ_HINT 32
>  
>  bool xfs_inode_verify_forks(struct xfs_inode *ip);
> +bool xfs_inode_has_posteof_blocks(struct xfs_inode *ip);
>  
>  #endif	/* __XFS_INODE_H__ */
> 

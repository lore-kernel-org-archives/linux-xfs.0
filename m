Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8NGivZw136555 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 11:44:58 -0500
Subject: Re: [PATCH 11/16] xfs: split inode AG walking into separate code
	for reclaim
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1285137869-10310-12-git-send-email-david@fromorbit.com>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
	<1285137869-10310-12-git-send-email-david@fromorbit.com>
Date: Thu, 23 Sep 2010 11:45:52 -0500
Message-ID: <1285260352.1973.28.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, 2010-09-22 at 16:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The reclaim walk requires different locking and has a slightly
> different walk algorithm, so separate it out so that it can be
> optimised separately.

You assert this above xfs_reclaim_inodes_ag():
 Walk the AGs and reclaim the inodes in them. Even if the filesystem is
 corrupted, we still want to try to reclaim all the inodes.

I don't refute that statement, but if I'm not mistaken
this is new handling.  I just felt it should not slip in
without being mentioned.  I also suggest a short sentence
along with that comment to justify it might be in order.

I have one other minor comment below, but otherwise this
looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_sync.c    |  200 ++++++++++++++++++----------------------
>  fs/xfs/linux-2.6/xfs_sync.h    |    2 +-
>  fs/xfs/linux-2.6/xfs_trace.h   |    2 +-
>  fs/xfs/quota/xfs_qm_syscalls.c |    3 +-
>  fs/xfs/xfs_mount.c             |   26 +++++
>  fs/xfs/xfs_mount.h             |    2 +
>  6 files changed, 120 insertions(+), 115 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
> index ddeaff9..7737a13 100644
> --- a/fs/xfs/linux-2.6/xfs_sync.c
> +++ b/fs/xfs/linux-2.6/xfs_sync.c

. . .

> @@ -859,13 +781,70 @@ reclaim:
>  
>  }
>  
> +/*
> + * Walk the AGs and reclaim the inodes in them. Even if the filesystem is
> + * corrupted, we still want to try to reclaim all the inodes.
> + */
> +int
> +xfs_reclaim_inodes_ag(
> +	struct xfs_mount	*mp,
> +	int			flags,
> +	int			*nr_to_scan)
> +{
> +	struct xfs_perag	*pag;
> +	int			error = 0;
> +	int			last_error = 0;
> +	xfs_agnumber_t		ag;
> +
> +	ag = 0;
> +	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
> +		unsigned long	first_index = 0;
> +		int		done = 0;
> +
> +		ag = pag->pag_agno + 1;
> +
> +		do {
> +			struct xfs_inode *ip;
> +			int	nr_found;
> +
> +			write_lock(&pag->pag_ici_lock);
> +			nr_found = radix_tree_gang_lookup_tag(&pag->pag_ici_root,
> +					(void **)&ip, first_index, 1,
> +					XFS_ICI_RECLAIM_TAG);
> +			if (!nr_found) {
> +				write_unlock(&pag->pag_ici_lock);
> +				break;
> +			}
> +
> +			/*
> +			 * Update the index for the next lookup. Catch overflows
> +			 * into the next AG range which can occur if we have inodes
> +			 * in the last block of the AG and we are currently
> +			 * pointing to the last inode.
> +			 */
> +			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
> +			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
> +				done = 1;
> +
> +			error = xfs_reclaim_inode(ip, pag, flags);
> +			if (error && last_error != EFSCORRUPTED)
> +				last_error = error;
> +
> +		} while (!done && (*nr_to_scan)--);

I know you guys disagreed with me before on this point.
But since there is no reason anybody outside this function
has a need to see the intermediate values of *nr_to_scan,
you should use a local variable to keep track of it instead,
and then assign its final value to *nr_to_scan before returning.
It allows registers to be used rather than updating real
memory at each iteration.

> +
> +		xfs_perag_put(pag);
> +	}
> +	return XFS_ERROR(last_error);
> +}
> +
>  int
>  xfs_reclaim_inodes(
>  	xfs_mount_t	*mp,
>  	int		mode)
>  {

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

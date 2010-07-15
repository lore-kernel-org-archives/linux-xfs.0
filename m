Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6FHwlkK215969 for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 12:58:48 -0500
Subject: Re: [PATCH 1/5] xfs: track AGs with reclaimable inodes in per-ag
	radix tree
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1279154300-2018-2-git-send-email-david@fromorbit.com>
References: <1279154300-2018-1-git-send-email-david@fromorbit.com>
	<1279154300-2018-2-git-send-email-david@fromorbit.com>
Date: Thu, 15 Jul 2010 13:01:40 -0500
Message-ID: <1279216900.2054.28.camel@doink>
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
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Thu, 2010-07-15 at 10:38 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=16348
> 
> When the filesystem grows to a large number of allocation groups,
> the summing of recalimable inodes gets expensive. In many cases,
> most AGs won't have any reclaimable inodes and so we are wasting CPU
> time aggregating over these AGs. This is particularly important for
> the inode shrinker that gets called frequently under memory
> pressure.
> 
> To avoid the overhead, track AGs with reclaimable inodes in the
> per-ag radix tree so that we can find all the AGs with reclaimable
> inodes via a simple gang tag lookup. This involves setting the tag
> when the first reclaimable inode is tracked in the AG, and removing
> the tag when the last reclaimable inode is removed from the tree.
> Then the summation process becomes a loop walking the radix tree
> summing AGs with the reclaim tag set.
> 
> This significantly reduces the overhead of scanning - a 6400 AG
> filesystea now only uses about 25% of a cpu in kswapd while slab reclaim
> progresses instead of being permanently stuck at 100% CPU and making little
> progress. Clean filesystems filesystems will see no overhead and the
> overhead only increases linearly with the number of dirty AGs.

Using the same tag represent a perag with reclaimable
inodes as the tag representing an inode is reclaimable
is nicely consistent...

I have a few comments below for your consideration
but they are minor (and don't even require a response).

Overall this looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_sync.c  |   71 +++++++++++++++++++++++++++++++++++++----
>  fs/xfs/linux-2.6/xfs_trace.h |    3 ++
>  2 files changed, 67 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
> index 56fed91..51da595 100644
> --- a/fs/xfs/linux-2.6/xfs_sync.c
> +++ b/fs/xfs/linux-2.6/xfs_sync.c
> @@ -133,6 +133,41 @@ restart:
>  	return last_error;
>  }
>  
> +/*
> + * Select the next per-ag structure to iterate during the walk. The reclaim
> + * walk is optimised only to walk AGs with reclaimable inodes in them.
> + */
> +static struct xfs_perag *
> +xfs_inode_ag_iter_next_pag(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		*first,
> +	int			tag)
> +{
> +	struct xfs_perag	*pag = NULL;
> +
> +	if (tag == XFS_ICI_RECLAIM_TAG) {
> +		int found;
> +		int ref;
> +
> +		spin_lock(&mp->m_perag_lock);
> +		found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
> +				(void **)&pag, *first, 1, tag);
> +		if (found <= 0) {
> +			spin_unlock(&mp->m_perag_lock);
> +			return NULL;
> +		}
> +		*first = pag->pag_agno + 1;

Maybe move this below, just before the return.  I.e.:
	if (pag)
		*first = pag->pag_agno + 1;

To me it's slightly clearer that we're just setting
up to search next time with the perag following the
one returned.

> +		/* open coded pag reference increment */

By open-coding here you miss the assertions in xfs_perag_get().
(Though a common inline encapsulating them would have to be
in a header because the two functions reside in different files.)

> +		ref = atomic_inc_return(&pag->pag_ref);
> +		spin_unlock(&mp->m_perag_lock);
> +		trace_xfs_perag_get_reclaim(mp, pag->pag_agno, ref, _RET_IP_);
> +	} else {
> +		pag = xfs_perag_get(mp, *first);
> +		(*first)++;
> +	}
> +	return pag;
> +}
> +
>  int
>  xfs_inode_ag_iterator(
>  	struct xfs_mount	*mp,

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

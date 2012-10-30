Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UHu6Vw061164 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 12:56:08 -0500
Date: Tue, 30 Oct 2012 06:30:26 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 19/25] xfs: add xfs_da_node verification
Message-ID: <20121030133026.GE18595@caliban.engr.sgi.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-20-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-20-git-send-email-david@fromorbit.com>
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

On Thu, Oct 25, 2012 at 05:34:08PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_attr.c      |   22 ++++------
>  fs/xfs/xfs_attr_leaf.c |   12 +++---
>  fs/xfs/xfs_attr_leaf.h |    8 ++--
>  fs/xfs/xfs_da_btree.c  |  108 ++++++++++++++++++++++++++++++++++++------------
>  fs/xfs/xfs_da_btree.h  |    3 ++
>  fs/xfs/xfs_dir2_leaf.c |    2 +-
>  fs/xfs/xfs_dir2_priv.h |    1 +
>  7 files changed, 106 insertions(+), 50 deletions(-)

Reviewed-by: Phil White <pwhite@sgi.com>

One minor comment:

> diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
> index a46035b..e950192 100644
> --- a/fs/xfs/xfs_da_btree.c
> +++ b/fs/xfs/xfs_da_btree.c
> @@ -91,6 +91,67 @@ STATIC int	xfs_da_blk_unlink(xfs_da_state_t *state,
>  				  xfs_da_state_blk_t *save_blk);
>  STATIC void	xfs_da_state_kill_altpath(xfs_da_state_t *state);
>  
> +static void
> +__xfs_da_node_verify(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> +	struct xfs_da_node_hdr *hdr = bp->b_addr;
> +	int			block_ok = 0;
> +
> +	block_ok = hdr->info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC);
> +	block_ok |= hdr->level > 0;
> +	block_ok |= hdr->count > 0;

This particular assignment seemed a little inconsistent, compared to
other usages.  Functionally, it's fine though.

-Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

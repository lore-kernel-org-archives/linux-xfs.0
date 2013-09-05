Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E8EE29DFB
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 21:11:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 22FEF304067
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 19:11:14 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	o13pzSYd56rBRuSJ for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 19:11:13 -0700 (PDT)
Date: Thu, 5 Sep 2013 12:10:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 08/11] xfs: insert newly allocated inode chunks into
	the finobt
Message-ID: <20130905021035.GV23571@dastard>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-9-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1378232708-57156-9-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 03, 2013 at 02:25:05PM -0400, Brian Foster wrote:
> A newly allocated inode chunk, by definition, has at least one
> free inode, so a record is always inserted into the finobt.
> 
> Create the xfs_inobt_insert() helper from existing code to insert
> a record in an inobt based on the provided BTNUM. Update
> xfs_ialloc_ag_alloc() to invoke the helper for the existing
> XFS_BTNUM_INO tree and XFS_BTNUM_FINO tree, if enabled.

Factoring is good...

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_ialloc.c | 79 +++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 56 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index 5ced506..e64a728 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -152,6 +152,52 @@ xfs_check_agi_freecount(
>  #endif
>  
>  /*
> + * Insert records describing a newly allocated inode chunk into the inobt.
> + */
> +STATIC int
> +xfs_inobt_insert(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agbp,
> +	xfs_agino_t		newino,
> +	xfs_agino_t		newlen,
> +	xfs_btnum_t		btnum)
> +{
> +	struct xfs_btree_cur	*cur;
> +	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
> +	xfs_agnumber_t		agno = be32_to_cpu(agi->agi_seqno);
> +	xfs_agino_t		thisino;
> +	int			i;
> +	int			error;
> +
> +	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
> +
> +	for (thisino = newino;
> +	     thisino < newino + newlen;
> +	     thisino += XFS_INODES_PER_CHUNK) {
> +		cur->bc_rec.i.ir_startino = thisino;
> +		cur->bc_rec.i.ir_freecount = XFS_INODES_PER_CHUNK;
> +		cur->bc_rec.i.ir_free = XFS_INOBT_ALL_FREE;
> +		error = xfs_btree_lookup(cur, XFS_LOOKUP_EQ, &i);
> +		if (error) {
> +			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> +			return error;
> +		}

I'm wondering if we'd do better to pass freecount/free to
xfs_inobt_lookup() and call that instead. i.e. we don't need to
expose the btree cursor internals here...

Maybe, also, move this function up to the top of the file with the
other xfs_inobt_* functions.

Otherwise it all looks OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

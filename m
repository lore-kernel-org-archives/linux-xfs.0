Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 02CF07F56
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 17:41:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E16078F8049
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 15:41:18 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	GQXPt6wacoGzxd5T for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 15:41:16 -0700 (PDT)
Date: Fri, 25 Jul 2014 08:41:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/18] xfs: create helper to manage record overlap for
	sparse inode chunks
Message-ID: <20140724224112.GR20518@dastard>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-9-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406211788-63206-9-git-send-email-bfoster@redhat.com>
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

On Thu, Jul 24, 2014 at 10:22:58AM -0400, Brian Foster wrote:
> Create xfs_spchunk_has_record() to receive the parameters of a new
> sparse inode chunk allocation and identify whether a record exists that
> is capable of tracking this sparse chunk.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 27d3437..be57b51 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -351,6 +351,61 @@ xfs_ialloc_inode_init(
>  }
>  
>  /*
> + * Determine whether part of a sparse inode chunk that has just been allocated
> + * is covered by an existing inobt record.
> + */
> +STATIC int
> +xfs_spchunk_has_record(

not sure I like the "spchunk" naming. I see that and I have no idea
what subsystem it belongs to. It's actually an inobt lookup
function, and doesn't really have anything to do with sparse chunks.
So maybe xfs_inobt_rec_exists or xfs_inobt_lookup_exact?

> +	struct xfs_mount		*mp,
> +	struct xfs_trans		*tp,
> +	struct xfs_buf			*agbp,
> +	xfs_agino_t			newino,
> +	xfs_agino_t			count,
> +	xfs_btnum_t			btnum,
> +	struct xfs_inobt_rec_incore	*orec)
> +{
> +	struct xfs_btree_cur		*cur;
> +	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
> +	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
> +	xfs_agino_t			previno;
> +	int				error;
> +	int				i;
> +	struct xfs_inobt_rec_incore	rec;
> +
> +	orec->ir_startino = NULLAGINO;
> +
> +	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
> +
> +	previno = newino + count - XFS_INODES_PER_CHUNK;
> +	error = xfs_inobt_lookup(cur, previno, XFS_LOOKUP_GE, &i);

You want XFS_LOOKUP_EQ, yes? i.e. XFS_LOOKUP_GE won't fail if the
exact record for the inode chunk does not exist - it will return the
next one in the btree.

> +	if (error)
> +		goto error;
> +	if (i == 0)
> +		goto out;
> +
> +	error = xfs_inobt_get_rec(cur, &rec, &i);
> +	if (error)
> +		goto error;
> +	XFS_WANT_CORRUPTED_GOTO(i == 1, error);
> +
> +	if (rec.ir_startino > newino)
> +		goto out;

And so this check would not be necessary...

> +
> +	ASSERT(rec.ir_startino <= newino &&
> +	       rec.ir_startino + XFS_INODES_PER_CHUNK > newino);
> +	ASSERT(rec.ir_freecount + count <= XFS_INODES_PER_CHUNK);
> +
> +	*orec = rec;

/* struct copy */

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

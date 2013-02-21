Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 179E17F50
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 16:53:06 -0600 (CST)
Date: Thu, 21 Feb 2013 16:53:05 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 3/9] xfs: add CRC checks to the AGF
Message-ID: <20130221225305.GT22182@sgi.com>
References: <1358774760-21841-1-git-send-email-david@fromorbit.com>
	<1358774760-21841-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1358774760-21841-4-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave,

Just some minor nits.

On Tue, Jan 22, 2013 at 12:25:54AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> THe AGF already has some self identifying fields (e.g. the sequence
  The

> number) so we only need to add the uuid to it to identify the
> filesystem it belongs to. The location is fixed based on the
> sequence number, so there's no need to add a block number, either.
> 
> Hence the only additional fields are the CRC and LSN fields. These
> are unlogged, so place some space between the end of the logged
> fields and them so that future expansion of the AGF for legged
							  logged

> fields can be placed adjacent to the existing logged fields and
> hence not complicate the field-derived range based logging we
> currently have.
> 
> Based originally on a patch from myself, modified further by
> Christoph Hellwig and then modified again to fit into the
> verifier structure with additional fields by myself. The multiple
> signed-off-by tags indicate the age and history of this patch.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_ag.h          |   21 +++++++++++-
>  fs/xfs/xfs_alloc.c       |   80 ++++++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_buf_item.h    |    4 ++-
>  fs/xfs/xfs_fsops.c       |    3 ++
>  fs/xfs/xfs_log_recover.c |    7 ++++
>  5 files changed, 89 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
> index f2aeedb..b382703 100644
> --- a/fs/xfs/xfs_ag.h
> +++ b/fs/xfs/xfs_ag.h
> @@ -63,12 +63,29 @@ typedef struct xfs_agf {
>  	__be32		agf_spare0;	/* spare field */
>  	__be32		agf_levels[XFS_BTNUM_AGF];	/* btree levels */
>  	__be32		agf_spare1;	/* spare field */
> +
>  	__be32		agf_flfirst;	/* first freelist block's index */
>  	__be32		agf_fllast;	/* last freelist block's index */
>  	__be32		agf_flcount;	/* count of blocks in freelist */
>  	__be32		agf_freeblks;	/* total free blocks */
> +
>  	__be32		agf_longest;	/* longest free space */
>  	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
> +	uuid_t		agf_uuid;	/* uuid of filesystem */
> +
> +	/*
> +	 * reserve some contiguous space for future logged fields before we add
> +	 * the unlogged fields. This makes the range logging via flags and
> +	 * structure offsets much simpler.
> +	 */
> +	__be64		agf_spare64[16];
> +
> +	/* unlogged fields, written during buffer writeback. */
> +	__be64		agf_lsn;	/* last write sequence */
> +	__be32		agf_crc;	/* crc of agf sector */
> +	__be32		agf_spare2;
> +
> +	/* structure must be padded to 64 bit alignment */
>  } xfs_agf_t;
>  
>  #define	XFS_AGF_MAGICNUM	0x00000001
> @@ -83,6 +100,7 @@ typedef struct xfs_agf {
>  #define	XFS_AGF_FREEBLKS	0x00000200
>  #define	XFS_AGF_LONGEST		0x00000400
>  #define	XFS_AGF_BTREEBLKS	0x00000800
> +#define	XFS_AGF_UUID		0x00001000
>  #define	XFS_AGF_NUM_BITS	12
					13 ?
You added a 13th bit.

How do you envision having the uuid in these structures will be helpful?

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6DE747FFE
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 17:56:42 -0600 (CST)
Date: Fri, 1 Mar 2013 17:56:41 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 05/16] xfs: add CRC checks to the AGFL
Message-ID: <20130301235641.GE22182@sgi.com>
References: <1361755901-12453-1-git-send-email-david@fromorbit.com>
	<1361755901-12453-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1361755901-12453-6-git-send-email-david@fromorbit.com>
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

Hi Dave,

On Mon, Feb 25, 2013 at 12:31:30PM +1100, Dave Chinner wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Add CRC checks, location information and a magic number to the AGFL.
> Previously the AGFL was just a block containing nothing but the
> free block pointers.  The new AGFL has a real header with the usual
> boilerplate instead, so that we can verify it's not corrupted and
> written into the right place.
> 
> [dchinner@redhat.com] Added LSN field, reworked significantly to fit
> into new verifier structure and growfs structure, enabled full
> verifier functionality now there is a header to verify and we can
> guarantee an initialised AGFL.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_ag.h          |   25 +++++++++-
>  fs/xfs/xfs_alloc.c       |  119 ++++++++++++++++++++++++++++++----------------
>  fs/xfs/xfs_buf_item.h    |    4 +-
>  fs/xfs/xfs_fsops.c       |    5 ++
>  fs/xfs/xfs_log_recover.c |   10 ++++
>  5 files changed, 119 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
> index 9f4815e..272ef09 100644
> --- a/fs/xfs/xfs_ag.h
> +++ b/fs/xfs/xfs_ag.h
> @@ -30,6 +30,7 @@ struct xfs_trans;
>  
>  #define	XFS_AGF_MAGIC	0x58414746	/* 'XAGF' */
>  #define	XFS_AGI_MAGIC	0x58414749	/* 'XAGI' */
> +#define	XFS_AGFL_MAGIC	0x5841464c	/* 'XAFL' */
>  #define	XFS_AGF_VERSION	1
>  #define	XFS_AGI_VERSION	1
>  
> @@ -190,11 +191,31 @@ extern const struct xfs_buf_ops xfs_agi_buf_ops;
>   */
>  #define XFS_AGFL_DADDR(mp)	((xfs_daddr_t)(3 << (mp)->m_sectbb_log))
>  #define	XFS_AGFL_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGFL_DADDR(mp))
> -#define XFS_AGFL_SIZE(mp)	((mp)->m_sb.sb_sectsize / sizeof(xfs_agblock_t))
>  #define	XFS_BUF_TO_AGFL(bp)	((xfs_agfl_t *)((bp)->b_addr))
>  
> +#define XFS_BUF_TO_AGFL_BNO(mp, bp) \
> +	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
> +		&(XFS_BUF_TO_AGFL(bp)->agfl_bno[0]) : \
> +		(__be32 *)(bp)->b_addr)
> +
> +/*
> + * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of
> + * slots in the beginning of the block for a proper header with the
> + * location information and CRC.
> + */
> +#define XFS_AGFL_SIZE(mp) \
> +	(((mp)->m_sb.sb_sectsize - \
> +	 (xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
> +		sizeof(struct xfs_agfl) : 0)) / \
> +	  sizeof(xfs_agblock_t))
> +
>  typedef struct xfs_agfl {
> -	__be32		agfl_bno[1];	/* actually XFS_AGFL_SIZE(mp) */
> +	__be32		agfl_magicnum;

  +     __be32		agfl_versionnum;

Now would be a good time to add this, and it would be consistent with the AGF
and AGI structures.  There is no shortage of agfl slots according to my
calculation, and this might be helpful for xfsrepair later.

-Ben

> +	__be32		agfl_seqno;
> +	uuid_t		agfl_uuid;
> +	__be64		agfl_lsn;
> +	__be32		agfl_crc;
> +	__be32		agfl_bno[];	/* actually XFS_AGFL_SIZE(mp) */
>  } xfs_agfl_t;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 81E187CAF
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 12:32:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1F12D304048
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 10:32:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NJejylpbFfEmpZAA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 30 Jun 2016 10:32:48 -0700 (PDT)
Date: Thu, 30 Jun 2016 13:32:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 024/119] xfs: add rmap btree stats infrastructure
Message-ID: <20160630173245.GB27303@bfoster.bfoster>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612642642.12839.4422813555398236765.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612642642.12839.4422813555398236765.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Thu, Jun 16, 2016 at 06:20:26PM -0700, Darrick J. Wong wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The rmap btree will require the same stats as all the other generic
> btrees, so add al the code for that now.

		 all

> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_btree.h |    5 +++--
>  fs/xfs/xfs_stats.c        |    1 +
>  fs/xfs/xfs_stats.h        |   18 +++++++++++++++++-
>  3 files changed, 21 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 202fdd3..a29067c 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -96,7 +96,7 @@ do {    \
>  	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(__mp, bmbt, stat); break; \
>  	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(__mp, ibt, stat); break; \
>  	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(__mp, fibt, stat); break; \
> -	case XFS_BTNUM_RMAP: break;	\
> +	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(__mp, rmap, stat); break; \
>  	case XFS_BTNUM_MAX: ASSERT(0); __mp = __mp /* fucking gcc */ ; break; \
>  	}       \
>  } while (0)
> @@ -117,7 +117,8 @@ do {    \
>  		__XFS_BTREE_STATS_ADD(__mp, ibt, stat, val); break; \
>  	case XFS_BTNUM_FINO:	\
>  		__XFS_BTREE_STATS_ADD(__mp, fibt, stat, val); break; \
> -	case XFS_BTNUM_RMAP: break; \
> +	case XFS_BTNUM_RMAP:	\
> +		__XFS_BTREE_STATS_ADD(__mp, rmap, stat, val); break; \
>  	case XFS_BTNUM_MAX: ASSERT(0); __mp = __mp /* fucking gcc */ ; break; \
>  	}       \
>  } while (0)
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index 8686df6..f04f547 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -61,6 +61,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  		{ "bmbt2",		XFSSTAT_END_BMBT_V2		},
>  		{ "ibt2",		XFSSTAT_END_IBT_V2		},
>  		{ "fibt2",		XFSSTAT_END_FIBT_V2		},
> +		{ "rmapbt",		XFSSTAT_END_RMAP_V2		},
>  		/* we print both series of quota information together */
>  		{ "qm",			XFSSTAT_END_QM			},
>  	};
> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> index 483b0ef..657865f 100644
> --- a/fs/xfs/xfs_stats.h
> +++ b/fs/xfs/xfs_stats.h
> @@ -197,7 +197,23 @@ struct xfsstats {
>  	__uint32_t		xs_fibt_2_alloc;
>  	__uint32_t		xs_fibt_2_free;
>  	__uint32_t		xs_fibt_2_moves;
> -#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_FIBT_V2+6)
> +#define XFSSTAT_END_RMAP_V2		(XFSSTAT_END_FIBT_V2+15)
> +	__uint32_t		xs_rmap_2_lookup;
> +	__uint32_t		xs_rmap_2_compare;
> +	__uint32_t		xs_rmap_2_insrec;
> +	__uint32_t		xs_rmap_2_delrec;
> +	__uint32_t		xs_rmap_2_newroot;
> +	__uint32_t		xs_rmap_2_killroot;
> +	__uint32_t		xs_rmap_2_increment;
> +	__uint32_t		xs_rmap_2_decrement;
> +	__uint32_t		xs_rmap_2_lshift;
> +	__uint32_t		xs_rmap_2_rshift;
> +	__uint32_t		xs_rmap_2_split;
> +	__uint32_t		xs_rmap_2_join;
> +	__uint32_t		xs_rmap_2_alloc;
> +	__uint32_t		xs_rmap_2_free;
> +	__uint32_t		xs_rmap_2_moves;
> +#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_RMAP_V2+6)
>  	__uint32_t		xs_qm_dqreclaims;
>  	__uint32_t		xs_qm_dqreclaim_misses;
>  	__uint32_t		xs_qm_dquot_dups;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

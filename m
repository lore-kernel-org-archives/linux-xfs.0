Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:15134 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726070AbeJKM4h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 08:56:37 -0400
Date: Thu, 11 Oct 2018 16:29:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: use offsetof() in place of offset macros for
 __xfsstats
Message-ID: <20181011052957.GO6311@dastard>
References: <20181010123708.7632-1-cmaiolino@redhat.com>
 <20181010123708.7632-3-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181010123708.7632-3-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 02:37:08PM +0200, Carlos Maiolino wrote:
> Most offset macro mess is used in xfs_stats_format() only, and we can
> simply get the right offsets using offsetof(), instead of several macros
> to mark the offsets inside __xfsstats structure.
> 
> Replace all XFSSTAT_END_* macros by a single helper macro to get the
> right offset into __xfsstats, and use this helper in xfs_stats_format()
> directly.
> 
> The quota stats code, still looks a bit cleaner when using XFSSTAT_*
> macros, so, this patch also defines XFSSTAT_START_XQMSTAT and
> XFSSTAT_END_XQMSTAT locally to that code. This also should prevent
> offset mistakes when updates are done into __xfsstats.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_stats.c | 52 +++++++++++++++++++++++++---------------------
>  fs/xfs/xfs_stats.h | 28 +++----------------------
>  2 files changed, 31 insertions(+), 49 deletions(-)
> 
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index 740ac9674848..cc509743facd 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -29,30 +29,30 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  		char	*desc;
>  		int	endpoint;
>  	} xstats[] = {
> -		{ "extent_alloc",	XFSSTAT_END_EXTENT_ALLOC	},
> -		{ "abt",		XFSSTAT_END_ALLOC_BTREE		},
> -		{ "blk_map",		XFSSTAT_END_BLOCK_MAPPING	},
> -		{ "bmbt",		XFSSTAT_END_BLOCK_MAP_BTREE	},
> -		{ "dir",		XFSSTAT_END_DIRECTORY_OPS	},
> -		{ "trans",		XFSSTAT_END_TRANSACTIONS	},
> -		{ "ig",			XFSSTAT_END_INODE_OPS		},
> -		{ "log",		XFSSTAT_END_LOG_OPS		},
> -		{ "push_ail",		XFSSTAT_END_TAIL_PUSHING	},
> -		{ "xstrat",		XFSSTAT_END_WRITE_CONVERT	},
> -		{ "rw",			XFSSTAT_END_READ_WRITE_OPS	},
> -		{ "attr",		XFSSTAT_END_ATTRIBUTE_OPS	},
> -		{ "icluster",		XFSSTAT_END_INODE_CLUSTER	},
> -		{ "vnodes",		XFSSTAT_END_VNODE_OPS		},
> -		{ "buf",		XFSSTAT_END_BUF			},
> -		{ "abtb2",		XFSSTAT_END_ABTB_V2		},
> -		{ "abtc2",		XFSSTAT_END_ABTC_V2		},
> -		{ "bmbt2",		XFSSTAT_END_BMBT_V2		},
> -		{ "ibt2",		XFSSTAT_END_IBT_V2		},
> -		{ "fibt2",		XFSSTAT_END_FIBT_V2		},
> -		{ "rmapbt",		XFSSTAT_END_RMAP_V2		},
> -		{ "refcntbt",		XFSSTAT_END_REFCOUNT		},
> +		{ "extent_alloc",	xfsstats_offset(xs_abt_lookup)	},
> +		{ "abt",		xfsstats_offset(xs_blk_mapr)	},
> +		{ "blk_map",		xfsstats_offset(xs_bmbt_lookup)	},
> +		{ "bmbt",		xfsstats_offset(xs_dir_lookup)	},
> +		{ "dir",		xfsstats_offset(xs_trans_sync)	},
> +		{ "trans",		xfsstats_offset(xs_ig_attempts)	},
> +		{ "ig",			xfsstats_offset(xs_log_writes)	},
> +		{ "log",		xfsstats_offset(xs_try_logspace)},
> +		{ "push_ail",		xfsstats_offset(xs_xstrat_quick)},
> +		{ "xstrat",		xfsstats_offset(xs_write_calls)	},
> +		{ "rw",			xfsstats_offset(xs_attr_get)	},
> +		{ "attr",		xfsstats_offset(xs_iflush_count)},
> +		{ "icluster",		xfsstats_offset(vn_active)	},
> +		{ "vnodes",		xfsstats_offset(xb_get)		},
> +		{ "buf",		xfsstats_offset(xs_abtb_2)	},
> +		{ "abtb2",		xfsstats_offset(xs_abtc_2)	},
> +		{ "abtc2",		xfsstats_offset(xs_bmbt_2)	},
> +		{ "bmbt2",		xfsstats_offset(xs_ibt_2)	},
> +		{ "ibt2",		xfsstats_offset(xs_fibt_2)	},
> +		{ "fibt2",		xfsstats_offset(xs_rmap_2)	},
> +		{ "rmapbt",		xfsstats_offset(xs_refcbt_2)	},
> +		{ "refcntbt",		xfsstats_offset(xs_qm_dqreclaims)},
>  		/* we print both series of quota information together */
> -		{ "qm",			XFSSTAT_END_QM			},
> +		{ "qm",			xfsstats_offset(xs_xstrat_bytes)},
>  	};

Now that I look at this more closely , it's a little bit ... odd.
i.e. the endpoint offset points to the first variable in the next
line, not the last variable of the stats line described by the text.
While it works, it just doesn't seem quite right to me.

Can we change it so that the index in the table is the last variable
of that line? This may require changing the inner loop to a <= check
rather than a < check, but the table would make more sense this way.
ie.

	{ "extent_alloc",	xfsstats_index(xs_freeb) },
	{ "abt",		xfsstats_index(xs_abt_delrec) },
.....


It may require a different macro for the expanded btree stats (the
array based ones) because they are defined as an array rather than
individual variables, but I think that's ok given those already have
special macros for changing them.

> +#define	xfsstats_offset(f)	(offsetof(struct __xfsstats, f)/sizeof(uint32_t))

I also think this should be named xfsstats_index(), not _offset. i.e.
it's an index into a structure we treat as an array of ints, not a byte
offset from the start of a u8 buffer....

> +
>  struct xfsstats {
>  	union {
>  		struct __xfsstats	s;
> -		uint32_t		a[XFSSTAT_END_XQMSTAT];
> +		uint32_t		a[xfsstats_offset(xs_qm_dquot)];

I think this should remain XFSSTAT_END_XQMSTAT, as we still define
that and require the quota stats to be at the end of the structure.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

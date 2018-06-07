Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60746 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753283AbeFGLmH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Jun 2018 07:42:07 -0400
Date: Thu, 7 Jun 2018 07:42:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: replace do_mod with native operations
Message-ID: <20180607114204.GD7798@bfoster>
References: <20180607052751.6541-1-david@fromorbit.com>
 <20180607052751.6541-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180607052751.6541-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 07, 2018 at 03:27:50PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> do_mod() is a hold-over from when we have different sizes for file
> offsets and and other internal values for 40 bit XFS filesystems.
> Hence depending on build flags variables passed to do_mod() could
> change size. We no longer support those small format filesystems and
> hence everything is of fixed size theses days, even on 32 bit
> platforms.
> 
> As such, we can convert all the do_mod() callers to platform
> optimised modulus operations as defined by linux/math64.h.
> Individual conversions depend on the types of variables being used.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 37 +++++++++++++++++++++++--------------
>  fs/xfs/xfs_bmap_util.c   | 14 +++++++++-----
>  fs/xfs/xfs_inode.c       |  2 +-
>  fs/xfs/xfs_iomap.h       |  4 ++--
>  fs/xfs/xfs_linux.h       | 19 -------------------
>  fs/xfs/xfs_log_recover.c | 32 +++++++++++++++++++++++++-------
>  fs/xfs/xfs_rtalloc.c     | 15 +++++++++++----
>  7 files changed, 71 insertions(+), 52 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 7d897c58b0c8..4405ff21f9a9 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1235,6 +1235,25 @@ xlog_verify_head(
>  				be32_to_cpu((*rhead)->h_size));
>  }
>  
> +/*
> + * We need to make sure we handle log wrapping properly, so we can't use teh
> + * calculated logbno directly. Make sure it wraps to teh correct bno inside teh
> + * log.
> + *

s/teh/the/

> + * The log is limited to 32 bit sizes, so we use the appropriate modulus
> + * operation here and cast it back to a 64 bit daddr on return.
> + */
> +static inline xfs_daddr_t
> +xlog_wrap_logbno(
> +	struct xlog		*log,
> +	xfs_daddr_t		bno)
> +{
> +	int			mod;
> +
> +	div_s64_rem(bno, log->l_logBBsize, &mod);
> +	return mod;
> +}
> +
>  /*
>   * Check whether the head of the log points to an unmount record. In other
>   * words, determine whether the log is clean. If so, update the in-core state
...
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 80bbfe604ce0..776502a5dcb7 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
...
> @@ -1262,8 +1266,11 @@ xfs_rtpick_extent(
>  		resid = seq - (1ULL << log2);
>  		b = (mp->m_sb.sb_rextents * ((resid << 1) + 1ULL)) >>
>  		    (log2 + 1);
> -		if (b >= mp->m_sb.sb_rextents)
> -			b = do_mod(b, mp->m_sb.sb_rextents);
> +		if (b >= mp->m_sb.sb_rextents) {
> +			xfs_rtblock_t mod;
> +			div64_u64_rem(b, mp->m_sb.sb_rextents, &mod);
> +			b = mod;
> +		}

Shouldn't we be able to do 'div64_u64_rem(b, mp->m_sb.sb_rextents, &b)'
here? Otherwise looks fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  		if (b + len > mp->m_sb.sb_rextents)
>  			b = mp->m_sb.sb_rextents - len;
>  	}
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

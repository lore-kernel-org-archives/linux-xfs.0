Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42620 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbfDDLuO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Apr 2019 07:50:14 -0400
Date: Thu, 4 Apr 2019 07:50:11 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 09/10] xfs: scrub/repair should update filesystem
 metadata health
Message-ID: <20190404115009.GB37737@bfoster>
References: <155413860964.4966.6087725033542837255.stgit@magnolia>
 <155413867262.4966.18080677522827911800.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155413867262.4966.18080677522827911800.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 01, 2019 at 10:11:12AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we have the ability to track sick metadata in-core, make scrub
> and repair update those health assessments after doing work.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/Makefile       |    1 
>  fs/xfs/scrub/health.c |  180 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/health.h |   12 +++
>  fs/xfs/scrub/scrub.c  |    8 ++
>  fs/xfs/scrub/scrub.h  |   11 +++
>  5 files changed, 212 insertions(+)
>  create mode 100644 fs/xfs/scrub/health.c
>  create mode 100644 fs/xfs/scrub/health.h
> 
> 
...
> diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
> new file mode 100644
> index 000000000000..dd9986500801
> --- /dev/null
> +++ b/fs/xfs/scrub/health.c
> @@ -0,0 +1,180 @@
...
> +/* Update filesystem health assessments based on what we found and did. */
> +void
> +xchk_update_health(
> +	struct xfs_scrub	*sc,
> +	bool			already_fixed)
> +{
> +	/*
> +	 * If the scrubber finds errors, we mark sick whatever's mentioned in
> +	 * sick_mask, no matter whether this is a first scan or an evaluation
> +	 * of repair effectiveness.
> +	 *
> +	 * If there is no direct corruption and we're called after a repair,
> +	 * clear whatever's in heal_mask because that's what we fixed.
> +	 *
> +	 * Otherwise, there's no direct corruption and we didn't repair
> +	 * anything, so mark whatever's in sick_mask as healthy.
> +	 */
> +	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> +		xchk_mark_sick(sc, sc->sick_mask);
> +	else if (already_fixed)
> +		xchk_mark_healthy(sc, sc->heal_mask);
> +	else
> +		xchk_mark_healthy(sc, sc->sick_mask);
> +}

Hmm, I think I follow what we're doing here but it's a bit confusing
without the additional context of where these bits will be set/cleared
at the lower scrub layers (or at least without an example). Some
questions on that below...

...
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 1b2344d00525..b1519dfc5811 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -40,6 +40,7 @@
>  #include "scrub/trace.h"
>  #include "scrub/btree.h"
>  #include "scrub/repair.h"
> +#include "scrub/health.h"
>  
>  /*
>   * Online Scrub and Repair
> @@ -468,6 +469,7 @@ xfs_scrub_metadata(
>  {
>  	struct xfs_scrub		sc;
>  	struct xfs_mount		*mp = ip->i_mount;
> +	unsigned int			heal_mask;
>  	bool				try_harder = false;
>  	bool				already_fixed = false;
>  	int				error = 0;
> @@ -488,6 +490,7 @@ xfs_scrub_metadata(
>  	error = xchk_validate_inputs(mp, sm);
>  	if (error)
>  		goto out;
> +	heal_mask = xchk_health_mask_for_scrub_type(sm->sm_type);
>  
>  	xchk_experimental_warning(mp);
>  
> @@ -499,6 +502,8 @@ xfs_scrub_metadata(
>  	sc.ops = &meta_scrub_ops[sm->sm_type];
>  	sc.try_harder = try_harder;
>  	sc.sa.agno = NULLAGNUMBER;
> +	sc.heal_mask = heal_mask;
> +	sc.sick_mask = xchk_health_mask_for_scrub_type(sm->sm_type);

Ok, so we initialize the heal/sick masks based on the scrub type that
was requested on the first pass through...

>  	error = sc.ops->setup(&sc, ip);
>  	if (error)
>  		goto out_teardown;
> @@ -519,6 +524,8 @@ xfs_scrub_metadata(
>  	} else if (error)
>  		goto out_teardown;
>  
> +	xchk_update_health(&sc, already_fixed);
> +

... then update the in-core fs health state based on the sick mask. Is
it possible for the scrub operation to set more sick mask bits based on
what it finds? More specifically, I'm wondering why the masks wouldn't
start as zero and toggle based on finding/fixing corruption(s). Or if
the sick mask value is essentially fixed, whether we need to store it in
the xfs_scrub context...

>  	if ((sc.sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) && !already_fixed) {
>  		bool needs_fix;
>  
> @@ -551,6 +558,7 @@ xfs_scrub_metadata(
>  				xrep_failure(mp);
>  				goto out;
>  			}
> +			heal_mask = sc.heal_mask;

And if we end up doing a repair, we presumably can repair multiple
things and so we track that separately and persist the heal mask across
a potential retry. What about the case where we don't retry, but scrub
finds something and then immediately repairs it? Should we update the fs
state after both detecting and clearing the problem, or does that happen
elsewhere?

Also, if repair can potentially clear multiple bits, what's the
possibility of a repair clearing one failure and then failing on
another, causing the broader repair op to return an error or jump into
this retry? ISTM that it might be possible to skip clearing one fail
state bit so long as the original thing remained corrupted, but I feel
like I'm still missing some context on the bigger picture scrub
tracking...

Brian

>  			goto retry_op;
>  		}
>  	}
> diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
> index 22f754fba8e5..05f1ad242a35 100644
> --- a/fs/xfs/scrub/scrub.h
> +++ b/fs/xfs/scrub/scrub.h
> @@ -62,6 +62,17 @@ struct xfs_scrub {
>  	struct xfs_inode		*ip;
>  	void				*buf;
>  	uint				ilock_flags;
> +
> +	/* Metadata to be marked sick if scrub finds errors. */
> +	unsigned int			sick_mask;
> +
> +	/*
> +	 * Metadata to be marked healthy if repair fixes errors.  Some repair
> +	 * functions can fix multiple data structures at once, so we have to
> +	 * treat sick and heal masks separately.
> +	 */
> +	unsigned int			heal_mask;
> +
>  	bool				try_harder;
>  	bool				has_quotaofflock;
>  
> 

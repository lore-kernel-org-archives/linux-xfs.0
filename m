Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:7133 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750954AbdIEFXk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2017 01:23:40 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dp6Kh-0003ei-Vg
        for linux-xfs@vger.kernel.org; Tue, 05 Sep 2017 15:23:32 +1000
Date: Tue, 5 Sep 2017 15:23:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 39/42] mkfs: factor log size calculations
Message-ID: <20170905052331.GJ17782@dastard>
References: <20170829235052.21050-1-david@fromorbit.com>
 <20170829235052.21050-40-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829235052.21050-40-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 09:50:49AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
....
> +static void
> +align_internal_log(
> +	struct mkfs_params	*cfg,
> +	struct xfs_mount	*mp,
> +	int			sunit)
> +{
> +	uint64_t	agspace;
> +
> +	/* round up log start if necessary */
> +	if ((cfg->logstart % sunit) != 0)
> +		cfg->logstart = ((cfg->logstart + (sunit - 1)) / sunit) * sunit;
> +
> +	/* round up/down the log size now */
> +	align_log_size(cfg, sunit);
> +
> +	/* check the aligned log still fits in an AG. */
> +	agspace = cfg->agsize - libxfs_prealloc_blocks(mp);
> +	if (cfg->logblocks > agspace - XFS_FSB_TO_AGBNO(mp, cfg->logstart)) {

This breaks xfs/250. Should be:

	if (cfg->logblocks > cfg->agsize - XFS_FSB_TO_AGBNO(mp, cfg->logstart)) {

and the agspace variable goes away.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:63633 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750855AbcKRAxh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2016 19:53:37 -0500
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1c7XQo-0008VU-Ux
        for linux-xfs@vger.kernel.org; Fri, 18 Nov 2016 11:53:30 +1100
Date: Fri, 18 Nov 2016 11:53:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: hold AGF buffers over defer ops
Message-ID: <20161118005330.GF28177@dastard>
References: <20161117213224.GD28177@dastard>
 <1479426935-7112-1-git-send-email-david@fromorbit.com>
 <1479426935-7112-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479426935-7112-4-git-send-email-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Fri, Nov 18, 2016 at 10:55:34AM +1100, Dave Chinner wrote:
> +static void
> +xfs_defer_brelse(
> +	struct xfs_trans	*tp,
> +	struct xfs_defer_ops	*dop)
> +{
> +	int				i;
> +
> +	for (i = 0; i < XFS_DEFER_OPS_NR_BUFS; i++) {
> +		if (!tp)
> +			tp = dop->dop_bufs[i]->b_transp;
> +		if (dop->dop_bufs[i])
> +			xfs_trans_bhold_release(tp, dop->dop_bufs[i]);
> +	}

This let's the smoke out in generic/139. Will fix...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

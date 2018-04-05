Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:10247 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751251AbeDEXYr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Apr 2018 19:24:47 -0400
Date: Fri, 6 Apr 2018 09:24:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/21] xfs: implement the metadata repair ioctl flag
Message-ID: <20180405232441.GN23861@dastard>
References: <152269897182.16346.1710955088267364781.stgit@magnolia>
 <152269903184.16346.15038651436338921730.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152269903184.16346.15038651436338921730.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 02, 2018 at 12:57:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Plumb in the pieces necessary to make the "scrub" subfunction of
> the scrub ioctl actually work.  This means that we make the IFLAG_REPAIR
> flag to the scrub ioctl actually do something, and we add an errortag
> knob so that xfstests can force the kernel to rebuild a metadata
> structure even if there's nothing wrong with it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Minor nit:

> +#ifndef __XFS_SCRUB_REPAIR_H__
> +#define __XFS_SCRUB_REPAIR_H__
> +
> +#ifdef CONFIG_XFS_ONLINE_REPAIR
> +
> +int xfs_repair_probe(struct xfs_scrub_context *sc);
> +
> +#else
> +
> +#define xfs_repair_probe		(NULL)

static inline that returns -EOPNOTSUPP?

That way this code:

....
> +/*
> + * Attempt to repair some metadata, if the metadata is corrupt and userspace
> + * told us to fix it.  This function returns -EAGAIN to mean "re-run scrub",
> + * and will set *fixed to true if it thinks it repaired anything.
> + */
> +STATIC int
> +xfs_repair_attempt(
> +	struct xfs_inode		*ip,
> +	struct xfs_scrub_context	*sc,
> +	bool				*fixed)
> +{
> +	int				error = 0;
> +
> +	trace_xfs_repair_attempt(ip, sc->sm, error);
> +
> +	/* Repair needed but not supported, just exit. */
> +	if (!sc->ops->repair) {
> +		error = -EOPNOTSUPP;
> +		trace_xfs_repair_done(ip, sc->sm, error);
> +		return error;
> +	}

Can go away completely as there would be no need to special case the
"repair not build in" configuration here.

Otherwise it looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

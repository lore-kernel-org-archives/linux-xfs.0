Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:59138 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751188AbdJCXhK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 19:37:10 -0400
Date: Wed, 4 Oct 2017 10:32:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/25] xfs: probe the scrub ioctl
Message-ID: <20171003233247.GQ3666@dastard>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706326848.19351.10670988265979551239.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150706326848.19351.10670988265979551239.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 03, 2017 at 01:41:08PM -0700, Darrick J. Wong wrote:
> +/*
> + * Scrub probe -- userspace uses this to probe if we're willing to
> + * scrub or repair a given mountpoint.
> + */
> +int
> +xfs_scrub_probe(
> +	struct xfs_scrub_context	*sc)
> +{
> +	if (sc->sm->sm_ino || sc->sm->sm_agno)
> +		return -EINVAL;
> +	if (sc->sm->sm_gen & ~XFS_SCRUB_FLAGS_OUT)

sm_flags?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

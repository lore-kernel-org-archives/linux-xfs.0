Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:42432 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726527AbfDPBJI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Apr 2019 21:09:08 -0400
Date: Tue, 16 Apr 2019 11:09:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: scrub/repair should update filesystem metadata
 health
Message-ID: <20190416010905.GJ29573@dread.disaster.area>
References: <155537397092.27935.16073573221774618735.stgit@magnolia>
 <155537399567.27935.2695652869908662243.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155537399567.27935.2695652869908662243.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Mon, Apr 15, 2019 at 05:19:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we have the ability to track sick metadata in-core, make scrub
> and repair update those health assessments after doing work.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
...
> +/*
> + * Scrub and In-Core Filesystem Health Assessments
> + * ===============================================
> + *
> + * Online scrub and repair have the time and the ability to perform stronger
> + * checks than we can do from the metadata verifiers, because they can
> + * cross-reference records between data structures.  Therefore, scrub is in a
> + * good position to update the online filesystem health assessments to reflect
> + * the good/bad state of the data structure.
> + *
> + * We therefore extend scrub in the following ways to achieve this:
> + *
> + * 1. Create a "sick_mask_update" field in the scrub context.  When we're
> + * setting up a scrub call, set this to the default XFS_SICK_* flag(s) for the
> + * selected scrub type (call it A).  Scrub and repair functions can override
> + * the default sick_mask_update value if they choose.

The name of this field seems ... non-obvious. It's the current
health state of the object as the scrubber has scanned it, right?
And that if the scrubber has detected an error, it will contain
the things that wrong with the object?

I guess it's the "update" part of the name that I don't quite
understand. "update" is an action, not a state.  we update the
object with the current sickness state mask, the mask itself is not
doing any updating. Just calling it "sick_mask" gets rid of that
icky feeling I have about it's name....

> + * 2. If the scrubber returns a runtime error code, we exit making no changes
> + * to the incore sick state.
> + *
> + * 3. If the scrubber finds that A is clean, use sick_mask_update to clear the
> + * incore sick flags before exiting.
> + *
> + * 4. If the scrubber finds that A is corrupt, use sick_mask_update to set the
> + * incore sick flags.  If the user didn't want to repair then we exit, leaving
> + * the metadata structure unfixed and the sick flag set.
> + *
> + * 5. Now we know that A is corrupt and the user wants to repair, so run the
> + * repairer.  If the repairer returns an error code, we exit with that error
> + * code, having made no further changes to the incore sick state.
> + *
> + * 6. If repair rebuilds A correctly and the subsequent re-scrub of A is
> + * clean, use sick_mask_update to clear the incore sick flags.  This should
> + * have the effect that A is no longer marked sick.

.... so it really does hold "current state" and not an "update"
operation :)

> + * 7. If repair rebuilds A incorrectly, the re-scrub will find it corrupt and
> + * use sick_mask_update to set the incore sick flags.  This should have no
> + * externally visible effect since we already set them in step (4).
> + *
> + * There are some complications to this story, however.  For certain types of
> + * complementary metadata indices (e.g. inobt/finobt), it is easier to rebuild
> + * both structures at the same time.  The following principles apply to this
> + * type of repair strategy:
> + *
> + * 8. Any repair function that rebuilds multiple structures should update
> + * sick_mask_visible to reflect whatever other structures are rebuilt, and
> + * verify that all the rebuilt structures can pass a scrub check.  The
> + * outcomes of 5-7 still apply, but with a sick_mask_update that covers
> + * everything being rebuilt.
> + */

Otherwise this all makes sense and the patch is pretty straight
forward...

> +static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
> +	[XFS_SCRUB_TYPE_SB]		= { XHG_AG,  XFS_SICK_AG_SB },
> +	[XFS_SCRUB_TYPE_AGF]		= { XHG_AG,  XFS_SICK_AG_AGF },
> +	[XFS_SCRUB_TYPE_AGFL]		= { XHG_AG,  XFS_SICK_AG_AGFL },
> +	[XFS_SCRUB_TYPE_AGI]		= { XHG_AG,  XFS_SICK_AG_AGI },
> +	[XFS_SCRUB_TYPE_BNOBT]		= { XHG_AG,  XFS_SICK_AG_BNOBT },
> +	[XFS_SCRUB_TYPE_CNTBT]		= { XHG_AG,  XFS_SICK_AG_CNTBT },
> +	[XFS_SCRUB_TYPE_INOBT]		= { XHG_AG,  XFS_SICK_AG_INOBT },
> +	[XFS_SCRUB_TYPE_FINOBT]		= { XHG_AG,  XFS_SICK_AG_FINOBT },
> +	[XFS_SCRUB_TYPE_RMAPBT]		= { XHG_AG,  XFS_SICK_AG_RMAPBT },
> +	[XFS_SCRUB_TYPE_REFCNTBT]	= { XHG_AG,  XFS_SICK_AG_REFCNTBT },
> +	[XFS_SCRUB_TYPE_INODE]		= { XHG_INO, XFS_SICK_INO_CORE },
> +	[XFS_SCRUB_TYPE_BMBTD]		= { XHG_INO, XFS_SICK_INO_BMBTD },
> +	[XFS_SCRUB_TYPE_BMBTA]		= { XHG_INO, XFS_SICK_INO_BMBTA },
> +	[XFS_SCRUB_TYPE_BMBTC]		= { XHG_INO, XFS_SICK_INO_BMBTC },
> +	[XFS_SCRUB_TYPE_DIR]		= { XHG_INO, XFS_SICK_INO_DIR },
> +	[XFS_SCRUB_TYPE_XATTR]		= { XHG_INO, XFS_SICK_INO_XATTR },
> +	[XFS_SCRUB_TYPE_SYMLINK]	= { XHG_INO, XFS_SICK_INO_SYMLINK },
> +	[XFS_SCRUB_TYPE_PARENT]		= { XHG_INO, XFS_SICK_INO_PARENT },
> +	[XFS_SCRUB_TYPE_RTBITMAP]	= { XHG_RT,  XFS_SICK_RT_BITMAP },
> +	[XFS_SCRUB_TYPE_RTSUM]		= { XHG_RT,  XFS_SICK_RT_SUMMARY },
> +	[XFS_SCRUB_TYPE_UQUOTA]		= { XHG_FS,  XFS_SICK_FS_UQUOTA },
> +	[XFS_SCRUB_TYPE_GQUOTA]		= { XHG_FS,  XFS_SICK_FS_GQUOTA },
> +	[XFS_SCRUB_TYPE_PQUOTA]		= { XHG_FS,  XFS_SICK_FS_PQUOTA },
> +};

/me wonders if the primary superblock is XHG_FS or XHG_AG....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

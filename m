Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:42563 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752311AbeC0XzR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 19:55:17 -0400
Date: Wed, 28 Mar 2018 10:55:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/20] xfs: implement the metadata repair ioctl flag
Message-ID: <20180327235514.GZ18129@dastard>
References: <152210855435.13184.6475770131389744177.stgit@magnolia>
 <152210860614.13184.13848520110703401019.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152210860614.13184.13848520110703401019.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 26, 2018 at 04:56:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Plumb in the pieces necessary to make the "scrub" subfunction of
> the scrub ioctl actually work.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Can you list the pieces here - the ioctl, the errtag for debug, etc?

....

> +config XFS_ONLINE_REPAIR
> +	bool "XFS online metadata repair support"
> +	default n
> +	depends on XFS_FS && XFS_ONLINE_SCRUB
> +	help
> +	  If you say Y here you will be able to repair metadata on a
> +	  mounted XFS filesystem.  This feature is intended to reduce
> +	  filesystem downtime even further by fixing minor problems

s/even further//

> +	  before they cause the filesystem to go down.  However, it
> +	  requires that the filesystem be formatted with secondary
> +	  metadata, such as reverse mappings and inode parent pointers.
> +
> +	  This feature is considered EXPERIMENTAL.  Use with caution!
> +
> +	  See the xfs_scrub man page in section 8 for additional information.
> +
> +	  If unsure, say N.

.....

> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index faf1a4e..8bf3ded 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -542,13 +542,20 @@ struct xfs_scrub_metadata {
>  /* o: Metadata object looked funny but isn't corrupt. */
>  #define XFS_SCRUB_OFLAG_WARNING		(1 << 6)
>  
> +/*
> + * o: IFLAG_REPAIR was set but metadata object did not need fixing or
> + *    optimization and has therefore not been altered.
> + */
> +#define XFS_SCRUB_OFLAG_UNTOUCHED	(1 << 7)

bikeshed: CLEAN rather than UNTOUCHED?

> +#ifndef __XFS_SCRUB_REPAIR_H__
> +#define __XFS_SCRUB_REPAIR_H__
> +
> +#if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)

Don't we use the form 

#ifdef XFS_ONLINE_REPAIR

elsewhere? We should be consistent on how we detect config options,
if IS_ENABLED() is the prefered way of doing it now, should we
change everything to do this?

> +/* Online repair only works for v5 filesystems. */
> +static inline bool xfs_repair_can_fix(struct xfs_mount *mp)
> +{
> +	return xfs_sb_version_hascrc(&mp->m_sb);
> +}
> +
> +/* Did userspace want us to repair /and/ we found something to fix? */
> +static inline bool xfs_repair_should_fix(struct xfs_scrub_metadata *sm)
> +{
> +	return (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
> +	       (sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
> +				XFS_SCRUB_OFLAG_XCORRUPT |
> +				XFS_SCRUB_OFLAG_PREEN));
> +}
> +
> +/* Did userspace tell us to fix something and it didn't get fixed? */
> +static inline bool xfs_repair_unfixed(struct xfs_scrub_metadata *sm)
> +{
> +	return (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
> +	       (sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
> +				XFS_SCRUB_OFLAG_XCORRUPT));
> +}

Ok, so I don't understand how these determine whether something
wants repair and then didn't get repaired? Clearly there's some
context related thing I'm not seeing in the way these are called,
but looking at the code I don't understand the difference between
"want to do" and "did not do".

> +int xfs_repair_probe(struct xfs_scrub_context *sc, uint32_t scrub_oflags);
> +
> +#else
> +
> +# define xfs_repair_can_fix(mp)		(false)
> +# define xfs_repair_should_fix(sm)	(false)
> +# define xfs_repair_probe		(NULL)
> +# define xfs_repair_unfixed(sm)		(false)

static inline is preffered for these, right? So we still get type
checking even when they aren't enabled?

> @@ -120,6 +125,24 @@
>   * XCORRUPT flag; btree query function errors are noted by setting the
>   * XFAIL flag and deleting the cursor to prevent further attempts to
>   * cross-reference with a defective btree.
> + *
> + * If a piece of metadata proves corrupt or suboptimal, the userspace
> + * program can ask the kernel to apply some tender loving care (TLC) to
> + * the metadata object by setting the REPAIR flag and re-calling the
> + * scrub ioctl.  "Corruption" is defined by metadata violating the
> + * on-disk specification; operations cannot continue if the violation is
> + * left untreated.  It is possible for XFS to continue if an object is
> + * "suboptimal", however performance may be degraded.  Repairs are
> + * usually performed by rebuilding the metadata entirely out of
> + * redundant metadata.  Optimizing, on the other hand, can sometimes be
> + * done without rebuilding entire structures.
> + *
> + * Generally speaking, the repair code has the following code structure:
> + * Lock -> scrub -> repair -> commit -> re-lock -> re-scrub -> unlock.
> + * The first check helps us figure out if we need to rebuild or simply
> + * optimize the structure so that the rebuild knows what to do.  The
> + * second check evaluates the completeness of the repair; that is what
> + * is reported to userspace.
>   */
>  
>  /*
> @@ -155,7 +178,10 @@ xfs_scrub_teardown(
>  {
>  	xfs_scrub_ag_free(sc, &sc->sa);
>  	if (sc->tp) {
> -		xfs_trans_cancel(sc->tp);
> +		if (error == 0 && (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
> +			error = xfs_trans_commit(sc->tp);
> +		else
> +			xfs_trans_cancel(sc->tp);
>  		sc->tp = NULL;
>  	}
>  	if (sc->ip) {
> @@ -180,6 +206,7 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
>  		.type	= ST_NONE,
>  		.setup	= xfs_scrub_setup_fs,
>  		.scrub	= xfs_scrub_probe,
> +		.repair = xfs_repair_probe,
>  	},
>  	[XFS_SCRUB_TYPE_SB] = {		/* superblock */
>  		.type	= ST_PERAG,
> @@ -379,15 +406,107 @@ xfs_scrub_validate_inputs(
>  	if (!xfs_sb_version_hasextflgbit(&mp->m_sb))
>  		goto out;
>  
> -	/* We don't know how to repair anything yet. */
> -	if (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
> -		goto out;
> +	/*
> +	 * We only want to repair read-write v5+ filesystems.  Defer the check
> +	 * for ops->repair until after our scrub confirms that we need to
> +	 * perform repairs so that we avoid failing due to not supporting
> +	 * repairing an object that doesn't need repairs.
> +	 */
> +	if (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) {
> +		error = -EOPNOTSUPP;
> +		if (!xfs_repair_can_fix(mp))
> +			goto out;
> +
> +		error = -EROFS;
> +		if (mp->m_flags & XFS_MOUNT_RDONLY)
> +			goto out;
> +	}
>  
>  	error = 0;
>  out:
>  	return error;
>  }
>  
> +/*
> + * Attempt to repair some metadata, if the metadata is corrupt and userspace
> + * told us to fix it.  This function returns -EAGAIN to mean "re-run scrub",
> + * and will set *fixed if it thinks it repaired anything.
> + */
> +STATIC int
> +xfs_repair_attempt(
> +	struct xfs_inode		*ip,
> +	struct xfs_scrub_context	*sc,
> +	bool				*fixed)
> +{
> +	uint32_t			scrub_oflags;
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
> +
> +	xfs_scrub_ag_btcur_free(&sc->sa);
> +
> +	/*
> +	 * Repair whatever's broken.  We have to clear the out flags during the
> +	 * repair call because some of our iterator functions abort if any of
> +	 * the corruption flags are set.
> +	 */
> +	scrub_oflags = sc->sm->sm_flags & XFS_SCRUB_FLAGS_OUT;
> +	sc->sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
> +	error = sc->ops->repair(sc, scrub_oflags);

Urk, that's a bit messy. Shouldn't we drive that inwards to just the
iterator methods that have this problem? Then we can slowly work
over the iterators that are problematic and fix them?

> +	trace_xfs_repair_done(ip, sc->sm, error);
> +	sc->sm->sm_flags |= scrub_oflags;
> +
> +	switch (error) {
> +	case 0:
> +		/*
> +		 * Repair succeeded.  Commit the fixes and perform a second
> +		 * scrub so that we can tell userspace if we fixed the problem.
> +		 */
> +		sc->sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
> +		*fixed = true;
> +		return -EAGAIN;
> +	case -EDEADLOCK:
> +	case -EAGAIN:
> +		/* Tell the caller to try again having grabbed all the locks. */
> +		if (!sc->try_harder) {
> +			sc->try_harder = true;
> +			return -EAGAIN;
> +		}
> +		/*
> +		 * We tried harder but still couldn't grab all the resources
> +		 * we needed to fix it.  The corruption has not been fixed,
> +		 * so report back to userspace.
> +		 */
> +		return -EFSCORRUPTED;
> +	default:
> +		return error;
> +	}
> +}
> +
> +/*
> + * Complain about unfixable problems in the filesystem.  We don't log
> + * corruptions when IFLAG_REPAIR wasn't set on the assumption that the driver
> + * program is xfs_scrub, which will call back with IFLAG_REPAIR set if the
> + * administrator isn't running xfs_scrub in no-repairs mode.
> + *
> + * Use this helper function because _ratelimited silently declares a static
> + * structure to track rate limiting information.
> + */
> +static void
> +xfs_repair_failure(
> +	struct xfs_mount		*mp)
> +{
> +	xfs_alert_ratelimited(mp,
> +"Corruption not fixed during online repair.  Unmount and run xfs_repair.");
> +}

Using the general rate limiting message functions means this message
can be dropped when there is lots of other ratelimited alert level
messages being emitted. IMO, this is not a message we want dropped,
so if it needs rate limiting, it should use it's own private
ratelimit structure.

>  /* Dispatch metadata scrubbing. */
>  int
>  xfs_scrub_metadata(
> @@ -397,6 +516,7 @@ xfs_scrub_metadata(
>  	struct xfs_scrub_context	sc;
>  	struct xfs_mount		*mp = ip->i_mount;
>  	bool				try_harder = false;
> +	bool				already_fixed = false;
>  	int				error = 0;
>  
>  	BUILD_BUG_ON(sizeof(meta_scrub_ops) !=
> @@ -446,9 +566,44 @@ xfs_scrub_metadata(
>  	} else if (error)
>  		goto out_teardown;
>  
> -	if (sc.sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
> -			       XFS_SCRUB_OFLAG_XCORRUPT))
> -		xfs_alert_ratelimited(mp, "Corruption detected during scrub.");
> +	/* Let debug users force us into the repair routines. */
> +	if ((sc.sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) && !already_fixed &&
> +			XFS_TEST_ERROR(false, mp,
> +					XFS_ERRTAG_FORCE_SCRUB_REPAIR)) {
> +		sc.sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
> +	}
> +
> +	/*
> +	 * If userspace asked for a repair but it wasn't necessary, report
> +	 * that back to userspace.
> +	 */
> +	if ((sc.sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) && !already_fixed &&
> +	    !(sc.sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
> +				 XFS_SCRUB_OFLAG_XCORRUPT |
> +				 XFS_SCRUB_OFLAG_PREEN)))
> +		sc.sm->sm_flags |= XFS_SCRUB_OFLAG_UNTOUCHED;

Duplicate checks, could be done like this:

	if ((sc.sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) && !already_fixed) {
		/* Let debug users force us into the repair routines. */
		if (XFS_TEST_ERROR(false, mp,
			.....

		/*
		 * If userspace asked for a repair but it wasn't
		 * necessary,
		.....
	}

> +	/*
> +	 * If it's broken, userspace wants us to fix it, and we haven't already
> +	 * tried to fix it, then attempt a repair.
> +	 */
> +	if (xfs_repair_should_fix(sc.sm) && !already_fixed) {

You could reduce indent by doing:

	if (!xfs_repair_should_fix(sc.sm) || already_fixed)
		goto out_check_unfixed;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

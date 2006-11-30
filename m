Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Nov 2006 14:39:13 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAUMd3aG023758
	for <xfs@oss.sgi.com>; Thu, 30 Nov 2006 14:39:05 -0800
Date: Fri, 1 Dec 2006 09:38:11 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Reduce in-core superblock lock contention near ENOSPC
Message-ID: <20061130223810.GO37654165@melbourne.sgi.com>
References: <20061123044122.GU11034@melbourne.sgi.com> <456F1CFC.2060705@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <456F1CFC.2060705@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Thu, Nov 30, 2006 at 06:03:40PM +0000, Lachlan McIlroy wrote:
> Dave,
> 
> Could you have changed the SB_LOCK from a spinlock to a blocking
> mutex and have achieved a similar effect?

Sort of - it would still be inefficient and wouldn't help solve the
underlying causes of contention.  Also, everything else that uses
the SB_LOCK would now have a sleep point where there wasn't one
previously. If we are nesting the SB_LOCK somewhere else inside a
another spinlock (not sure if we are) then we can't sleep. I'd
prefer not to change the semantics of such a lock if I can avoid it.

I think the slow path code is somewhat clearer with a separate
mutex - it clearly documents the serialisation barrier that
the slow path uses and allows us to do slow path checks on the
per-cpu counters without needing the SB_LOCK.

It also means that in future, we can slowly remove the need for
holding the SB_LOCK across the entire rebalance operation and only
use it when referencing the global superblock fields during
the rebalance.

If the need arises, it also means we can move to a mutex per counter
so we can independently rebalance different types of counters at the
same time (which we can't do right now).

> Has this change had much testing on a large machine?

8p is the largest I've run it on (junkbond) and it's been ENOSPC
tested on a 2.7GB/s filesystem (junkbond once again) as well
as one single, slow disks.

I've tried and tried to get the ppl that reported the problem to
test this fix but no luck so far (this bug has been open for months
and most of that time has been me waiting for someone to run a
test). I've basically got sick of waiting and I just want to
move this on. It's already too late for sles10sp1 because of
the lack of response.

> These changes wouldn't apply cleanly to tot (3 hunks failed in
> xfs_mount.c) but I couldn't see why.

Whitespace issue? Try setting:

$ export QUILT_PATCH_OPTS="--ignore-whitespace"

I'll apply the patch to a separate tree and see if I hit the same
problem....

> The changes look fine to me, couple of comments below.
> 
> Lachlan
> 
> 
> @@ -1479,9 +1479,11 @@ xfs_mod_incore_sb_batch(xfs_mount_t *mp,
>  		case XFS_SBS_IFREE:
>  		case XFS_SBS_FDBLOCKS:
>  			if (!(mp->m_flags & XFS_MOUNT_NO_PERCPU_SB)) {
> -				status = xfs_icsb_modify_counters_locked(mp,
> +				XFS_SB_UNLOCK(mp, s);
> +				status = xfs_icsb_modify_counters(mp,
>  							msbp->msb_field,
>  							msbp->msb_delta, 
>  							rsvd);
> +				s = XFS_SB_LOCK(mp);
>  				break;
>  			}
>  			/* FALLTHROUGH */
> 
> Is it safe to be releasing the SB_LOCK?

Yes.

> Is it assumed that the
> superblock wont change while we process the list of xfs_mod_sb
> structures?

No. We are applying deltas - it doesn't matter if other deltas are
applied at the same time by other callers because in the end all
the deltas get applied and it adds up to the same thing.

> @@ -1515,11 +1517,12 @@ xfs_mod_incore_sb_batch(xfs_mount_t *mp,
>  			case XFS_SBS_IFREE:
>  			case XFS_SBS_FDBLOCKS:
>  				if (!(mp->m_flags & XFS_MOUNT_NO_PERCPU_SB)) 
>  				{
> -					status =
> -					    
> xfs_icsb_modify_counters_locked(mp,
> +					XFS_SB_UNLOCK(mp, s);
> +					status = xfs_icsb_modify_counters(mp,
>  							msbp->msb_field,
>  							-(msbp->msb_delta),
>  							rsvd);
> +					s = XFS_SB_LOCK(mp);
>  					break;
>  				}
>  				/* FALLTHROUGH */
> 
> Same as above.

Ditto ;)

Thanks for looking at this, Lachlan.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

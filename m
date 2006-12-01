Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Dec 2006 11:23:16 -0800 (PST)
Received: from internal-mail-relay1.corp.sgi.com (internal-mail-relay1.corp.sgi.com [198.149.32.52])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB1JN9aG002122
	for <xfs@oss.sgi.com>; Fri, 1 Dec 2006 11:23:09 -0800
Message-ID: <457080EA.1010807@sgi.com>
Date: Fri, 01 Dec 2006 19:22:18 +0000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: Review: Reduce in-core superblock lock contention near ENOSPC
References: <20061123044122.GU11034@melbourne.sgi.com> <456F1CFC.2060705@sgi.com> <20061130223810.GO37654165@melbourne.sgi.com>
In-Reply-To: <20061130223810.GO37654165@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

David Chinner wrote:
> On Thu, Nov 30, 2006 at 06:03:40PM +0000, Lachlan McIlroy wrote:
> 
>>Dave,
>>
>>Could you have changed the SB_LOCK from a spinlock to a blocking
>>mutex and have achieved a similar effect?
> 
> 
> Sort of - it would still be inefficient and wouldn't help solve the
> underlying causes of contention.  Also, everything else that uses
> the SB_LOCK would now have a sleep point where there wasn't one
> previously. If we are nesting the SB_LOCK somewhere else inside a
> another spinlock (not sure if we are) then we can't sleep. I'd
> prefer not to change the semantics of such a lock if I can avoid it.

That's fair enough and I can't disagree with you.  I think the SB_LOCK
was/is being abused anyway and was used too genericly (if there's such
a word).  Using separate locks for specific purposes like you've done
with the new mutex is a great start to cleaning this code up.

> 
> I think the slow path code is somewhat clearer with a separate
> mutex - it clearly documents the serialisation barrier that
> the slow path uses and allows us to do slow path checks on the
> per-cpu counters without needing the SB_LOCK.

It's certainly an improvement over the original code.

> 
> It also means that in future, we can slowly remove the need for
> holding the SB_LOCK across the entire rebalance operation and only
> use it when referencing the global superblock fields during
> the rebalance.

Sounds good.

> 
> If the need arises, it also means we can move to a mutex per counter
> so we can independently rebalance different types of counters at the
> same time (which we can't do right now).

That seems so obvious - I'm surprised we can't do it now.

> 
> 
>>Has this change had much testing on a large machine?
> 
> 
> 8p is the largest I've run it on (junkbond) and it's been ENOSPC
> tested on a 2.7GB/s filesystem (junkbond once again) as well
> as one single, slow disks.
> 
> I've tried and tried to get the ppl that reported the problem to
> test this fix but no luck so far (this bug has been open for months
> and most of that time has been me waiting for someone to run a
> test). I've basically got sick of waiting and I just want to
> move this on. It's already too late for sles10sp1 because of
> the lack of response.

If it's important to them they'll test it.  If the change doesn't fix
their problem then I'm sure we'll hear from them again.

> 
> 
>>These changes wouldn't apply cleanly to tot (3 hunks failed in
>>xfs_mount.c) but I couldn't see why.
> 
> 
> Whitespace issue? Try setting:
> 
> $ export QUILT_PATCH_OPTS="--ignore-whitespace"
> 
> I'll apply the patch to a separate tree and see if I hit the same
> problem....
> 
> 
>>The changes look fine to me, couple of comments below.
>>
>>Lachlan
>>
>>
>>@@ -1479,9 +1479,11 @@ xfs_mod_incore_sb_batch(xfs_mount_t *mp,
>> 		case XFS_SBS_IFREE:
>> 		case XFS_SBS_FDBLOCKS:
>> 			if (!(mp->m_flags & XFS_MOUNT_NO_PERCPU_SB)) {
>>-				status = xfs_icsb_modify_counters_locked(mp,
>>+				XFS_SB_UNLOCK(mp, s);
>>+				status = xfs_icsb_modify_counters(mp,
>> 							msbp->msb_field,
>> 							msbp->msb_delta, 
>> 							rsvd);
>>+				s = XFS_SB_LOCK(mp);
>> 				break;
>> 			}
>> 			/* FALLTHROUGH */
>>
>>Is it safe to be releasing the SB_LOCK?
> 
> 
> Yes.
> 
> 
>>Is it assumed that the
>>superblock wont change while we process the list of xfs_mod_sb
>>structures?
> 
> 
> No. We are applying deltas - it doesn't matter if other deltas are
> applied at the same time by other callers because in the end all
> the deltas get applied and it adds up to the same thing.

Okay.

> 
> 
>>@@ -1515,11 +1517,12 @@ xfs_mod_incore_sb_batch(xfs_mount_t *mp,
>> 			case XFS_SBS_IFREE:
>> 			case XFS_SBS_FDBLOCKS:
>> 				if (!(mp->m_flags & XFS_MOUNT_NO_PERCPU_SB)) 
>> 				{
>>-					status =
>>-					    
>>xfs_icsb_modify_counters_locked(mp,
>>+					XFS_SB_UNLOCK(mp, s);
>>+					status = xfs_icsb_modify_counters(mp,
>> 							msbp->msb_field,
>> 							-(msbp->msb_delta),
>> 							rsvd);
>>+					s = XFS_SB_LOCK(mp);
>> 					break;
>> 				}
>> 				/* FALLTHROUGH */
>>
>>Same as above.
> 
> 
> Ditto ;)
> 
> Thanks for looking at this, Lachlan.
> 
> Cheers,
> 
> Dave.

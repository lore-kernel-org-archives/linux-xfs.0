Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38751C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 02:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17B826109F
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 02:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhJNCCm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Oct 2021 22:02:42 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51102 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229496AbhJNCCl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Oct 2021 22:02:41 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id AADA158C060;
        Thu, 14 Oct 2021 13:00:33 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1maq2q-005ytz-Cz; Thu, 14 Oct 2021 13:00:32 +1100
Date:   Thu, 14 Oct 2021 13:00:32 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 07/12] xfs: Rename inode's extent counter fields based
 on their width
Message-ID: <20211014020032.GM2361455@dread.disaster.area>
References: <20210927234637.GM1756565@dread.disaster.area>
 <20210928040431.GP1756565@dread.disaster.area>
 <87czors49w.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20210930004015.GM2361455@dread.disaster.area>
 <20210930043117.GO2361455@dread.disaster.area>
 <87zgrubjwn.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20210930225523.GA54211@dread.disaster.area>
 <87pmshrtsm.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20211010214907.GK54211@dread.disaster.area>
 <874k9nwt6i.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874k9nwt6i.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61678f42
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=7-415B0cAAAA:8
        a=H_x7StwpDtLDX9g3Q6gA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 13, 2021 at 08:14:01PM +0530, Chandan Babu R wrote:
> On 11 Oct 2021 at 03:19, Dave Chinner wrote:
> > On Thu, Oct 07, 2021 at 04:22:25PM +0530, Chandan Babu R wrote:
> >> On 01 Oct 2021 at 04:25, Dave Chinner wrote:
> >> > On Thu, Sep 30, 2021 at 01:00:00PM +0530, Chandan Babu R wrote:
> >> >> On 30 Sep 2021 at 10:01, Dave Chinner wrote:
> >> >> > On Thu, Sep 30, 2021 at 10:40:15AM +1000, Dave Chinner wrote:
> >> >> >
> >> >> 
> >> >> Ok. The above solution looks logically correct. I haven't been able to come up
> >> >> with a scenario where the solution wouldn't work. I will implement it and see
> >> >> if anything breaks.
> >> >
> >> > I think I can poke one hole in it - I missed the fact that if we
> >> > upgrade and inode read time, and then we modify the inode without
> >> > modifying the inode core (can we even do that - metadata mods should
> >> > at least change timestamps right?) then we don't log the format
> >> > change or the NREXT64 inode flag change and they only appear in the
> >> > on-disk inode at writeback.
> >> >
> >> > Log recovery needs to be checked for correct behaviour here. I think
> >> > that if the inode is in NREXT64 format when read in and the log
> >> > inode core is not, then the on disk LSN must be more recent than
> >> > what is being recovered from the log and should be skipped. If
> >> > NREXT64 is present in the log inode, then we logged the core
> >> > properly and we just don't care what format is on disk because we
> >> > replay it into NREXT64 format and write that back.
> >> 
> >> xfs_inode_item_format() logs the inode core regardless of whether
> >> XFS_ILOG_CORE flag is set in xfs_inode_log_item->ili_fields. Hence, setting
> >> the NREXT64 bit in xfs_dinode->di_flags2 just after reading an inode from disk
> >> should not result in a scenario where the corresponding
> >> xfs_log_dinode->di_flags2 will not have NREXT64 bit set.
> >
> > Except that log recovery might be replaying lots of indoe changes
> > such as:
> >
> > log inode
> > commit A
> > log inode
> > commit B
> > log inode
> > set NREXT64
> > commit C
> > writeback inode
> > <crash before log tail moves>
> >
> > Recovery will then replay commit A, B and C, in which case we *must
> > not recover the log inode* in commit A or B because the LSN in the
> > on-disk inode points at commit C. Hence replaying A or B will result
> > in the on-disk inode going backwards in time and hence resulting in
> > an inconsistent state on disk until commit C is recovered.
> >
> >> i.e. there is no need to compare LSNs of the checkpoint
> >> transaction being replayed and that of the disk inode.
> >
> > Inncorrect: we -always- have to do this, regardless of the change
> > being made.
> >
> >> If log recovery comes across a log inode with NREXT64 bit set in its di_flags2
> >> field, then we can safely conclude that the ondisk inode has to be updated to
> >> reflect this change
> >
> > We can't assume that. This makes an assumption that NREXT64 is
> > only ever a one-way transition. There's nothing in the disk format that
> > prevents us from -removing- NREXT64 for inodes that don't need large
> > extent counts.
> >
> > Yes, the -current implementation- does not allow going back to small
> > extent counts, but the on-disk format design still needs to allow
> > for such things to be done as we may need such functionality and
> > flexibility in the on-disk format in the future.
> >
> > Hence we have to ensure that log recovery handles both set and reset
> > transistions from the start. If we don't ensure that log recovery
> > handles reset conditions when we first add the feature bit, then
> > we are going to have to add a log incompat or another feature bit
> > to stop older kernels from trying to recover reset operations.
> >
> 
> Ok. I had never considered the possibility of transitioning an inode back into
> 32-bit data fork extent count format. With this new requirement, I now
> understand the reasoning behind comparing ondisk inode's LSN and checkpoint
> transaction's LSN.
> 
> As you have mentioned earlier, comparing LSNs is required not only for the
> change introduced in this patch, but also for any other change in value of any
> of the inode's fields. Without such a comparison, the inode can temporarily
> end up being in an inconsistent state during log replay.
> 
> To that end, The following code snippet from xlog_recover_inode_commit_pass2()
> skips playing back xfs_log_dinode entries when ondisk inode's LSN is greater
> than checkpoint transaction's LSN,
> 
>         if (dip->di_version >= 3) {
>                 xfs_lsn_t       lsn = be64_to_cpu(dip->di_lsn);
> 
>                 if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) > 0) {
>                         trace_xfs_log_recover_inode_skip(log, in_f);
>                         error = 0;
>                         goto out_owner_change;
>                 }
>         }
> 
> 
> However, if the commits in the sequence below belong to three different
> checkpoint transactions having the same LSN,
> 
> log inode
> commit A
> log inode
> commit B
> set NREXT64
> log inode
> commit C
> writeback inode
> <crash before log tail moves>
> 
> Then the above code snippet won't prevent an inode from becoming temporarily
> inconsistent due to commits A and B being replayed.

Ah, this is a very special corner case.  You snipped out the most
important part of the comment above that code:

	/*
         * If the inode has an LSN in it, recover the inode only if the on-disk
         * inode's LSN is older than the lsn of the transaction we are
         * replaying. We can have multiple checkpoints with the same start LSN,
         * so the current LSN being equal to the on-disk LSN doesn't necessarily
         * mean that the on-disk inode is more recent than the change being
         * replayed.
....

This is exactly the situation you are asking about here - what
happens in recovery when the LSNs are the same and there are
multiple checkpoints with the same LSN.

The first thing to understand here is "how do we get checkpoints
with the same LSN" and then understand what it implies.

We get checkpoints with the same start/commit LSNs when multiple
checkpoints are written in the same iclog. The start/commit LSNs are
determined by the LSN of the iclog they are written in, and hence if
they are the same they were written to the journal in a single
"atomic" IO.

I say "atomic" because it's not an atomic IO at the hardware level.
It's atomic in that the entire iclog is protected by a CRC and hence
if the CRC check for the iclog passes at recovery, then the iclog write has been
recovered intact. If the write was torn, misdirected
or some other physical media failure occurred, then we don't
recovery the iclog at all. IOWs, none of the changes in the iclog
are recovered. IOWs, we have atomic "all or nothing" iclog recovery
semantics.

Next, the fact that the inode has been written back and is up to
date on disk means that the iclog is entirely on stable storage.
The inode isn't unpinned until the flush/FUA associtate with the
iclog was completed, which happens before the iclog IO is completed
and the callbacks to unpin the inode are run. Hence ordering tells
us the entire iclog is on disk and should be recovered.

What this really means is that we cannot possibly see the
intermediate commit A or commit B states on disk at runtime or
before recovery is run. The metadata is not unpinned until the iclog
that also contains commit C is written to the journal. Hence from
the POV of the on-disk inode, we go from the original version to
commit C in one step and we never, ever see A or B as intermediate
states. IOWs, the iclog contents defines old -> C as an atomic
on-disk modification, even though the contents are spread across
multiple checkpoints.[1]

Hence in this specific case, we have 3 individual modifications to
the inode and it's related metadata sitting in the journal waiting
for log recovery to replay them as an atomic unit. They will all get
recovered, and each change that is replayed will be internally
consistent. Therefore, after replaying commit A, the inode and it's
metadata will be reverted to whatever was in that commit and it will
be consistent in that context. Then replay of commit B and commit C
bring it back up to being up to date on disk and providing the step
change from old -> C as the runtime code would have also done.

Hence at the end of replay, the inode and all it's related metadata
will be consistent with commit C and so so this special transient
corner case should resolve itself correctly (at least, as far as my
poor dumb brain can reason about it being correct).

> To handle this, we should
> probably go with the additional rule of "Replay log inode if both the log
> inode and the ondisk inode have the same value for NREXT64 bit".

No, we do not want case specific logic in recovery code like this
because inode core updates are simply overwrites. As long as the
overwrites are all replayed from A to C, we end up with the correct
result of an "atomic" step change from old to C on disk...

Cheers,

Dave.

[1] There's more really subtle, complex details around start LSN vs
commit LSN ordering with AIL, iclog and recovery LSNs and how to
treat same start/different commit LSNs, different start/same commit
LSNs, etc, but that's way beyond the scope of what is needed to be
understood here. These play into why we replay all the changes at
the same LSN as per above rather than skip them. Commit 32baa63d82ee
("xfs: logging the on disk inode LSN can make it go backwards")
might give you some more insight into the complexities here.
-- 
Dave Chinner
david@fromorbit.com

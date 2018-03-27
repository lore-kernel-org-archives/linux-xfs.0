Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:61293 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751020AbeC0V4W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 17:56:22 -0400
Date: Wed, 28 Mar 2018 08:56:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: implement cgroup writeback support
Message-ID: <20180327215614.GQ18129@dastard>
References: <f13839700d372a4663a08a11883e9c89b13056ca.1521752282.git.shli@fb.com>
 <CAJDdQW29Vjs9=PqREJZa_xHyA33Qdjf6NN95yGyan3ENwDfGZw@mail.gmail.com>
 <20180325215904.GH18129@dastard>
 <20180326162830.GF34912@bfoster.bfoster>
 <20180327005526.qa5dnkdzaxyardd7@kernel.org>
 <20180327113648.GA3498@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180327113648.GA3498@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Shaohua Li <shli@kernel.org>, =?utf-8?B?5byg5pys6b6Z?= <zbl.lkml@gmail.com>, linux-xfs@vger.kernel.org

On Tue, Mar 27, 2018 at 07:36:48AM -0400, Brian Foster wrote:
> On Mon, Mar 26, 2018 at 05:55:26PM -0700, Shaohua Li wrote:
> > On Mon, Mar 26, 2018 at 12:28:31PM -0400, Brian Foster wrote:
> > > On Mon, Mar 26, 2018 at 08:59:04AM +1100, Dave Chinner wrote:
> > > > On Fri, Mar 23, 2018 at 10:24:03PM +0800, 张本龙 wrote:
> > > > > Hi Shaohua and XFS,
> > > > > 
> > > > > May I ask how are we gonna handle REQ_META issued from XFS? As you
> > > > > mentioned about charging to root cgroup (also in an earlier email
> > > > > discussion), and seems the 4.16.0-rc6 code is not handling it
> > > > > separately.
> > > > > 
> > > > > In our case to support XFS cgroup writeback control, which was ported
> > > > > and slightly adapted to 3.10.0, ignoring xfs log bios resulted in
> > > > > trouble. Threads from throttled docker might submit_bio in following
> > > > > path by its own identity, this docker blkcg accumulated large amounts
> > > > > of data (e.g., 20GB), thus such log gets blocked.
> > > > 
> > > > And thus displaying the reason why I originally refused to merge
> > > > this code until regression tests were added to fstests to exercise
> > > > these sorts of issues. This stuff adds new internal filesystem IO
> > > > ordering constraints, so we need tests that exercise it and ensure
> > > > we don't accidentally break it in future.
> > > > 
> > > 
> > > Hmm, but if the user issues fsync from the throttled cgroup then won't
> > > that throttling occur today, regardless of cgroup aware writeback? My
> > > understanding is that cgawb just accurately accounts writeback I/Os to
> > > the owner of the cached pages. IOW, if the buffered writer and fsync
> > > call are in the same throttled cgroup, then the throttling works just as
> > > it would with cgawb and the writer being in a throttled cgroup.
> > > 
> > > So ISTM that this is an independent problem. What am I missing?
> > > 
> > > Shaohua,
> > > 
> > > Do you have a reference to the older metadata related patch mentioned in
> > > the commit log that presumably addressed this?
> > 
> > The problem is about priority reversion. Say you do a fsync in a low prio
> > cgroup, the IO will be submitted with low prio. Now you do a fsync in a high
> > prio cgroup, the cgroup will wait for fsync IO finished, which is already
> > submitted by the low prio cgroup and run in low prio. This makes the high prio
> > cgroup run slow. The proposed patch is to force all metadata write submitted
> > from root cgroup regardless which task submitted, which can fix this issue.
> > 
> 
> Right, but it seems to me that this can happen with or without cgroup
> aware writeback. This patch just introduces the final bits required to
> carry the page owner from however it is tracked in the writeback machine
> to the bio submitted by the fs. It doesn't introduce/enable/implement
> I/O throttling itself, which is already in place and usable (outside of
> the buffered write page owner problem fixed by this patch), right?
> 
> So without this patch, if a task in throttled cgroup A does a bunch of
> buffered writes and calls fsync, then another task in unthrottled cgroup
> B calls fsync, aren't we (XFS) susceptible to priority inversion via
> these same log I/O serialization points? If not, then what am I missing?

Well, I was originally told that bios send by a filesystem without
cgroup info would be accounted to the root cgroup and hence not
throttled at all. i.e. metadata, and any untagged data IO. In that
case, there should be no problems what-so-ever as all XFS IO should
be issued at the same priority

However, given the way people are talking about needing to bypass
block cgroup throttling via REQ_META hacks, I'm guessing that it
doesn't actually work that way. i.e. somewhere in the block layer it
attaches the current task cgroup to bios without existing cgroup
information, and so we end up with priority inversion problems
whenever cgroups and throttling are in use regardless of whether the
filesystem supports it or not....

Ah, yeah, the task cgroup gets added through this path:

submit_bio
  generic_make_request
    generic_make_request_checks
      blkcg_bio_issue_check
        bio_blkcg

> I'm not saying this isn't a problem that needs fixing, I just want to
> make sure I understand the fundamental problem(s), what this cgawb patch
> actually does and doesn't do and whether there is a logical dependency
> between this patch and the proposed metadata filtering patch.

Seems like there's a lot more work to be done to make this stuff
work reliably than anyone has been telling us. Without regression
tests, we're never going to know if it actually works or not....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

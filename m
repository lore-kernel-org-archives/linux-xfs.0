Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47768 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751114AbeC1Lcd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Mar 2018 07:32:33 -0400
Date: Wed, 28 Mar 2018 07:32:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] xfs: implement cgroup writeback support
Message-ID: <20180328113231.GB37272@bfoster.bfoster>
References: <f13839700d372a4663a08a11883e9c89b13056ca.1521752282.git.shli@fb.com>
 <CAJDdQW29Vjs9=PqREJZa_xHyA33Qdjf6NN95yGyan3ENwDfGZw@mail.gmail.com>
 <20180325215904.GH18129@dastard>
 <20180326162830.GF34912@bfoster.bfoster>
 <20180327005526.qa5dnkdzaxyardd7@kernel.org>
 <20180327113648.GA3498@bfoster.bfoster>
 <20180327215614.GQ18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180327215614.GQ18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Shaohua Li <shli@kernel.org>, =?utf-8?B?5byg5pys6b6Z?= <zbl.lkml@gmail.com>, linux-xfs@vger.kernel.org

On Wed, Mar 28, 2018 at 08:56:14AM +1100, Dave Chinner wrote:
> On Tue, Mar 27, 2018 at 07:36:48AM -0400, Brian Foster wrote:
> > On Mon, Mar 26, 2018 at 05:55:26PM -0700, Shaohua Li wrote:
> > > On Mon, Mar 26, 2018 at 12:28:31PM -0400, Brian Foster wrote:
> > > > On Mon, Mar 26, 2018 at 08:59:04AM +1100, Dave Chinner wrote:
> > > > > On Fri, Mar 23, 2018 at 10:24:03PM +0800, 张本龙 wrote:
> > > > > > Hi Shaohua and XFS,
> > > > > > 
> > > > > > May I ask how are we gonna handle REQ_META issued from XFS? As you
> > > > > > mentioned about charging to root cgroup (also in an earlier email
> > > > > > discussion), and seems the 4.16.0-rc6 code is not handling it
> > > > > > separately.
> > > > > > 
> > > > > > In our case to support XFS cgroup writeback control, which was ported
> > > > > > and slightly adapted to 3.10.0, ignoring xfs log bios resulted in
> > > > > > trouble. Threads from throttled docker might submit_bio in following
> > > > > > path by its own identity, this docker blkcg accumulated large amounts
> > > > > > of data (e.g., 20GB), thus such log gets blocked.
> > > > > 
> > > > > And thus displaying the reason why I originally refused to merge
> > > > > this code until regression tests were added to fstests to exercise
> > > > > these sorts of issues. This stuff adds new internal filesystem IO
> > > > > ordering constraints, so we need tests that exercise it and ensure
> > > > > we don't accidentally break it in future.
> > > > > 
> > > > 
> > > > Hmm, but if the user issues fsync from the throttled cgroup then won't
> > > > that throttling occur today, regardless of cgroup aware writeback? My
> > > > understanding is that cgawb just accurately accounts writeback I/Os to
> > > > the owner of the cached pages. IOW, if the buffered writer and fsync
> > > > call are in the same throttled cgroup, then the throttling works just as
> > > > it would with cgawb and the writer being in a throttled cgroup.
> > > > 
> > > > So ISTM that this is an independent problem. What am I missing?
> > > > 
> > > > Shaohua,
> > > > 
> > > > Do you have a reference to the older metadata related patch mentioned in
> > > > the commit log that presumably addressed this?
> > > 
> > > The problem is about priority reversion. Say you do a fsync in a low prio
> > > cgroup, the IO will be submitted with low prio. Now you do a fsync in a high
> > > prio cgroup, the cgroup will wait for fsync IO finished, which is already
> > > submitted by the low prio cgroup and run in low prio. This makes the high prio
> > > cgroup run slow. The proposed patch is to force all metadata write submitted
> > > from root cgroup regardless which task submitted, which can fix this issue.
> > > 
> > 
> > Right, but it seems to me that this can happen with or without cgroup
> > aware writeback. This patch just introduces the final bits required to
> > carry the page owner from however it is tracked in the writeback machine
> > to the bio submitted by the fs. It doesn't introduce/enable/implement
> > I/O throttling itself, which is already in place and usable (outside of
> > the buffered write page owner problem fixed by this patch), right?
> > 
> > So without this patch, if a task in throttled cgroup A does a bunch of
> > buffered writes and calls fsync, then another task in unthrottled cgroup
> > B calls fsync, aren't we (XFS) susceptible to priority inversion via
> > these same log I/O serialization points? If not, then what am I missing?
> 
> Well, I was originally told that bios send by a filesystem without
> cgroup info would be accounted to the root cgroup and hence not
> throttled at all. i.e. metadata, and any untagged data IO. In that
> case, there should be no problems what-so-ever as all XFS IO should
> be issued at the same priority
> 

It sounds like this was actually the plan at some point but the
associated patch (to which there is still no reference?) was never
committed. I have no idea why that is.. whether it was just lost or
nacked with outstanding issues..?

> However, given the way people are talking about needing to bypass
> block cgroup throttling via REQ_META hacks, I'm guessing that it
> doesn't actually work that way. i.e. somewhere in the block layer it
> attaches the current task cgroup to bios without existing cgroup
> information, and so we end up with priority inversion problems
> whenever cgroups and throttling are in use regardless of whether the
> filesystem supports it or not....
> 
> Ah, yeah, the task cgroup gets added through this path:
> 
> submit_bio
>   generic_make_request
>     generic_make_request_checks
>       blkcg_bio_issue_check
>         bio_blkcg
> 

Right, this is what I thought based on the code. For anything not
explicitly associated with a cgroup, it pretty much depends on the user
context of the I/O submission.

> > I'm not saying this isn't a problem that needs fixing, I just want to
> > make sure I understand the fundamental problem(s), what this cgawb patch
> > actually does and doesn't do and whether there is a logical dependency
> > between this patch and the proposed metadata filtering patch.
> 
> Seems like there's a lot more work to be done to make this stuff
> work reliably than anyone has been telling us. Without regression
> tests, we're never going to know if it actually works or not....
> 

I'm wondering if there's something simple/high-level we can do in the
filesystem to sort of flip the default block layer condition above on
its head with regard to metadata. For example, forcibly associate all
metadata bios to the root cgroup somewhere down in the xfs_buf_submit()
path. So rather than doing metadata I/O on behalf of a variety of random
cgroups based purely on userspace configuration and activity, we start
with a consistent and predictable base behavior.

The former (current) behavior leaves us open to these kinds of
problematic blocked states. The latter approach changes those gaps into
something that instead may just not honor the throttling limits for
certain metadata heavy workloads until finer grained control is
implemented in the fs (which can be implemented as needed). That's also
advantageous because by default we won't throttle certain I/Os that
might have complex locking/transaction dependencies and instead opt-in
to such metadata throttling in the obvious contexts where it's
appropriate. For example, the directory read example you mentioned
before could set a state on the buffer that prevents preemptive
association so the bio is actually associated with current userspace
context in the block layer and throttled appropriately.

Of course, I haven't looked into how reasonable any of that is to
implement. It would be nice to see whatever patch was previously
proposed for reference. :/

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

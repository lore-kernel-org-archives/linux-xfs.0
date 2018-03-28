Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53774 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750753AbeC1LYU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Mar 2018 07:24:20 -0400
Date: Wed, 28 Mar 2018 07:24:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] xfs: implement cgroup writeback support
Message-ID: <20180328112417.GA37272@bfoster.bfoster>
References: <f13839700d372a4663a08a11883e9c89b13056ca.1521752282.git.shli@fb.com>
 <CAJDdQW29Vjs9=PqREJZa_xHyA33Qdjf6NN95yGyan3ENwDfGZw@mail.gmail.com>
 <20180325215904.GH18129@dastard>
 <20180326162830.GF34912@bfoster.bfoster>
 <20180327005526.qa5dnkdzaxyardd7@kernel.org>
 <20180327113648.GA3498@bfoster.bfoster>
 <CAJDdQW3Gv=1fouW=j+xTPufWRb4QK50a6VmvPeJOoAwykTW7Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJDdQW3Gv=1fouW=j+xTPufWRb4QK50a6VmvPeJOoAwykTW7Ag@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?utf-8?B?5byg5pys6b6Z?= <zbl.lkml@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Wed, Mar 28, 2018 at 12:37:32PM +0800, 张本龙 wrote:
> 2018-03-27 19:36 GMT+08:00 Brian Foster <bfoster@redhat.com>:
> > On Mon, Mar 26, 2018 at 05:55:26PM -0700, Shaohua Li wrote:
> >> On Mon, Mar 26, 2018 at 12:28:31PM -0400, Brian Foster wrote:
> >> > On Mon, Mar 26, 2018 at 08:59:04AM +1100, Dave Chinner wrote:
> >> > > On Fri, Mar 23, 2018 at 10:24:03PM +0800, 张本龙 wrote:
> >> > > > Hi Shaohua and XFS,
> >> > > >
> >> > > > May I ask how are we gonna handle REQ_META issued from XFS? As you
> >> > > > mentioned about charging to root cgroup (also in an earlier email
> >> > > > discussion), and seems the 4.16.0-rc6 code is not handling it
> >> > > > separately.
> >> > > >
> >> > > > In our case to support XFS cgroup writeback control, which was ported
> >> > > > and slightly adapted to 3.10.0, ignoring xfs log bios resulted in
> >> > > > trouble. Threads from throttled docker might submit_bio in following
> >> > > > path by its own identity, this docker blkcg accumulated large amounts
> >> > > > of data (e.g., 20GB), thus such log gets blocked.
> >> > >
> >> > > And thus displaying the reason why I originally refused to merge
> >> > > this code until regression tests were added to fstests to exercise
> >> > > these sorts of issues. This stuff adds new internal filesystem IO
> >> > > ordering constraints, so we need tests that exercise it and ensure
> >> > > we don't accidentally break it in future.
> >> > >
> >> >
> >> > Hmm, but if the user issues fsync from the throttled cgroup then won't
> >> > that throttling occur today, regardless of cgroup aware writeback? My
> >> > understanding is that cgawb just accurately accounts writeback I/Os to
> >> > the owner of the cached pages. IOW, if the buffered writer and fsync
> >> > call are in the same throttled cgroup, then the throttling works just as
> >> > it would with cgawb and the writer being in a throttled cgroup.
> >> >
> >> > So ISTM that this is an independent problem. What am I missing?
> >> >
> >> > Shaohua,
> >> >
> >> > Do you have a reference to the older metadata related patch mentioned in
> >> > the commit log that presumably addressed this?
> >>
> >> The problem is about priority reversion. Say you do a fsync in a low prio
> >> cgroup, the IO will be submitted with low prio. Now you do a fsync in a high
> >> prio cgroup, the cgroup will wait for fsync IO finished, which is already
> >> submitted by the low prio cgroup and run in low prio. This makes the high prio
> >> cgroup run slow. The proposed patch is to force all metadata write submitted
> >> from root cgroup regardless which task submitted, which can fix this issue.
> >>
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
> >
> 
> Ok first let's agree we're not talking about 2 groups fsync the same
> file. What's demonstrated in the original post, is that group-A MIGHT
> submit xlog in the fsync path via xlog_sync() -> xfs_buf_submit().
> Threads from group-B are waiting for the log from flush_work(), at the
> same time kworkers from xlog_cil_push_work().
> 
> The problem is not about fsync get stuck on the target file. Actually
> group-B should be waiting on filemap_write_and_wait_range() if it
> were, as xfs_file_fsync() would flush the real data before
> _xfs_log_force_lsn.
> 

Yes, I don't mean to suggest we're contending on the same file across
different cgroups. Rather, we're getting stuck on a dependency of a
global resource (the log) between groups with very different priorities.

> Here is the setup: group-A has 10 fio jobs each running on 20GB files,
> and also some agents with not much IO; group-B just has the agents.
> With this patch we set a bps=20Mb/s to A, thus the large amounts of
> fio traffic are blocking the group (Note the fio are not doing any
> fsync though). At this time, one agent does an fsync to a non-dirty
> file, bypassing filemap_write_and_wait_range() and doing xlog_sync().
> Here we go, log bios are stuck in group-A. Then group-B and kworkers
> are waiting for log integrity indefinitely from various paths. Without
> this patch fio should writeout at full disk speed, say 200MB/s, so
> it's not accumulated in group-A.
> 

I see. So in your particular setup, cgawb is required to reproduce
because you aren't actually pushing data through the cgroup via fsync.
Therefore, cgawb is what actually enables the throttling for your use
case. The throttling slows down further I/O from group A and thus
creates the problematic conditions for contention on the log.

However, it looks like the only requirement to cause this particular
condition is that an fsync submits a log bio in an active and throttled
cgroup that ends up blocked for a period of time. Other log serializing
tasks in other cgroups are now susceptible to the first cgroup's
throttle if they have to wait on log I/O completion. So replace your
cgawb use case with one that creates similar conditions by somebody else
waiting on fsync -> filemap_write_and_wait_range() on a separate file in
the same (throttled) group and afaict the same thing can occur without
cgawb in the picture at all.

But between this and your other email I think I see how this isn't what
you are actually reproducing. Thanks for the explanation.

Brian

> > I'm not saying this isn't a problem that needs fixing, I just want to
> > make sure I understand the fundamental problem(s), what this cgawb patch
> > actually does and doesn't do and whether there is a logical dependency
> > between this patch and the proposed metadata filtering patch.
> >
> > Brian
> >
> >> Thanks,
> >> Shaohua
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

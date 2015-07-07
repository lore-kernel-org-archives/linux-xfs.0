Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 39F1E7CBF
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 19:45:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 190E48F8052
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 17:45:43 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	DWerotRS8sD67jyY for <xfs@oss.sgi.com>;
	Mon, 06 Jul 2015 17:45:36 -0700 (PDT)
Date: Tue, 7 Jul 2015 10:35:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Failing XFS filesystem underlying Ceph OSDs
Message-ID: <20150707003542.GW7943@dastard>
References: <CADb9451tB71D3XCqcOkDxzpzbdEHqwj7XCZUpL8yg1DzYbpwBw@mail.gmail.com>
	<20150703235141.GQ7943@dastard>
	<CADb9451j0WEeL4m-fEHzrOf3ys+eSHJKNzcN9oHAOs2kDLL_kQ@mail.gmail.com>
	<20150704233802.GS7943@dastard>
	<CADb9452UYPqo_i2M=-sSwPKwqUrRSMJ4bhV10S=1k0sNCKCVfg@mail.gmail.com>
	<20150705232443.GA3902@dastard>
	<CADb9453iT7+2zgKDqY7gpHGjQ6nayqQFES1AJHn0G2FMFjYX-A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADb9453iT7+2zgKDqY7gpHGjQ6nayqQFES1AJHn0G2FMFjYX-A@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Alex Gorbachev <ag@iss-integration.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 06, 2015 at 03:20:19PM -0400, Alex Gorbachev wrote:
> On Sun, Jul 5, 2015 at 7:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sun, Jul 05, 2015 at 12:25:47AM -0400, Alex Gorbachev wrote:
> > > > > sysctl vm.swappiness=20 (can probably be 1 as per article)
> > > > >
> > > > > sysctl vm.min_free_kbytes=262144
> > > >
> > [...]
> > >
> > > We have experienced the problem in various guises with kernels 3.14,
> > 3.19,
> > > 4.1-rc2 and now 4.1, so it's not new to us, just different error stack.
> > > Below are some other stack dumps of what manifested as the same error.
> > >
> > >  [<ffffffff817cf4b9>] schedule+0x29/0x70
> > >  [<ffffffffc07caee7>] _xfs_log_force+0x187/0x280 [xfs]
> > >  [<ffffffff810a4150>] ? try_to_wake_up+0x2a0/0x2a0
> > >  [<ffffffffc07cb019>] xfs_log_force+0x39/0xc0 [xfs]
> > >  [<ffffffffc07d6542>] xfsaild_push+0x552/0x5a0 [xfs]
> > >  [<ffffffff817d2264>] ? schedule_timeout+0x124/0x210
> > >  [<ffffffffc07d662f>] xfsaild+0x9f/0x140 [xfs]
> > >  [<ffffffffc07d6590>] ? xfsaild_push+0x5a0/0x5a0 [xfs]
> > >  [<ffffffff81095e29>] kthread+0xc9/0xe0
> > >  [<ffffffff81095d60>] ? flush_kthread_worker+0x90/0x90
> > >  [<ffffffff817d3718>] ret_from_fork+0x58/0x90
> > >  [<ffffffff81095d60>] ? flush_kthread_worker+0x90/0x90
> > >  INFO: task xfsaild/sdg1:2606 blocked for more than 120 seconds.
> > >        Not tainted 3.19.4-031904-generic #201504131440
> > >  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> > message.
> >
> > That's indicative of IO completion problems, but not a crash.
> >
> > >  BUG: unable to handle kernel NULL pointer dereference at
> >  (null)
> > >  IP: [<ffffffffc04be80f>] xfs_count_page_state+0x3f/0x70 [xfs]
> > ....
> > >   [<ffffffffc04be880>] xfs_vm_releasepage+0x40/0x120 [xfs]
> > >   [<ffffffff8118a7d2>] try_to_release_page+0x32/0x50
> > >   [<ffffffff8119fe6d>] shrink_page_list+0x69d/0x720
> > >   [<ffffffff811a058d>] shrink_inactive_list+0x1dd/0x5d0
> > ....
> >
> > Again, this is indicative of a page cache issue: a page without
> > buffers has been passed to xfs_vm_releasepage(), which implies the
> > page flags are not correct. i.e PAGE_FLAGS_PRIVATE is set but
> > page->private is null...
> >
> > Again, this is unlikely to be an XFS issue.
> >
> 
> Sorry for my ignorance, but would this likely come from Ceph code or a
> hardware issue of some kind, such as a disk drive?  I have reached out to
> RedHat and Ceph community on that as well.

More likely a kernel bug somewhere in the page cache or memory
reclaim paths. The issue is that we only notice the problem long
after it has occurred. i.e. when XFS goes to tear down the page it has
been handed, the page is already in a bad state and so it doesn't
really tell us anything about the cause of the problem.

Realisticaly, we need a script that reproduces the problem (that
doesn't require a Ceph cluster) to be able to isolate the cause.
In the mean time, you can always try running  CONFIG_XFS_WARN=y to
see if that catches problems earlier, and you might also want to do
things like turn on memory poisoning and other kernel debugging
options to try to isolate the cause of the issue....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

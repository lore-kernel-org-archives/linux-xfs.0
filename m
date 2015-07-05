Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 01F437F59
	for <xfs@oss.sgi.com>; Sun,  5 Jul 2015 18:25:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 92117AC004
	for <xfs@oss.sgi.com>; Sun,  5 Jul 2015 16:25:01 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	sJ4FvbLIiJv7ykt8 for <xfs@oss.sgi.com>;
	Sun, 05 Jul 2015 16:24:59 -0700 (PDT)
Date: Mon, 6 Jul 2015 09:24:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Failing XFS filesystem underlying Ceph OSDs
Message-ID: <20150705232443.GA3902@dastard>
References: <CADb9451tB71D3XCqcOkDxzpzbdEHqwj7XCZUpL8yg1DzYbpwBw@mail.gmail.com>
	<20150703235141.GQ7943@dastard>
	<CADb9451j0WEeL4m-fEHzrOf3ys+eSHJKNzcN9oHAOs2kDLL_kQ@mail.gmail.com>
	<20150704233802.GS7943@dastard>
	<CADb9452UYPqo_i2M=-sSwPKwqUrRSMJ4bhV10S=1k0sNCKCVfg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADb9452UYPqo_i2M=-sSwPKwqUrRSMJ4bhV10S=1k0sNCKCVfg@mail.gmail.com>
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

[ Please turn off line wrap when pasting kernel traces ]

On Sun, Jul 05, 2015 at 12:25:47AM -0400, Alex Gorbachev wrote:
> > > sysctl vm.swappiness=20 (can probably be 1 as per article)
> > >
> > > sysctl vm.min_free_kbytes=262144
> >
> > That's not an explanation for what looks to be page cache radix
> > tree coruption. Memory reclaim still occurs with the settings you
> > have now and, well, those changes occurred back in 3.5 - some
> > 3 years ago - so it's not really an explanation for a problem with a
> > recent 4.1 kernel...
> >
> > > So far no issues, but I need to wait a week to see if anything shows up.
> > > Thank you for reviewing the error codes.
> >
> > I expect that you'll see the problems again...
> 
> We have experienced the problem in various guises with kernels 3.14, 3.19,
> 4.1-rc2 and now 4.1, so it's not new to us, just different error stack.
> Below are some other stack dumps of what manifested as the same error.
> 
>  [<ffffffff817cf4b9>] schedule+0x29/0x70
>  [<ffffffffc07caee7>] _xfs_log_force+0x187/0x280 [xfs]
>  [<ffffffff810a4150>] ? try_to_wake_up+0x2a0/0x2a0
>  [<ffffffffc07cb019>] xfs_log_force+0x39/0xc0 [xfs]
>  [<ffffffffc07d6542>] xfsaild_push+0x552/0x5a0 [xfs]
>  [<ffffffff817d2264>] ? schedule_timeout+0x124/0x210
>  [<ffffffffc07d662f>] xfsaild+0x9f/0x140 [xfs]
>  [<ffffffffc07d6590>] ? xfsaild_push+0x5a0/0x5a0 [xfs]
>  [<ffffffff81095e29>] kthread+0xc9/0xe0
>  [<ffffffff81095d60>] ? flush_kthread_worker+0x90/0x90
>  [<ffffffff817d3718>] ret_from_fork+0x58/0x90
>  [<ffffffff81095d60>] ? flush_kthread_worker+0x90/0x90
>  INFO: task xfsaild/sdg1:2606 blocked for more than 120 seconds.
>        Not tainted 3.19.4-031904-generic #201504131440
>  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

That's indicative of IO completion problems, but not a crash.

>  BUG: unable to handle kernel NULL pointer dereference at           (null)
>  IP: [<ffffffffc04be80f>] xfs_count_page_state+0x3f/0x70 [xfs]
....
>   [<ffffffffc04be880>] xfs_vm_releasepage+0x40/0x120 [xfs]
>   [<ffffffff8118a7d2>] try_to_release_page+0x32/0x50
>   [<ffffffff8119fe6d>] shrink_page_list+0x69d/0x720
>   [<ffffffff811a058d>] shrink_inactive_list+0x1dd/0x5d0
....

Again, this is indicative of a page cache issue: a page without
buffers has been passed to xfs_vm_releasepage(), which implies the
page flags are not correct. i.e PAGE_FLAGS_PRIVATE is set but
page->private is null...

Again, this is unlikely to be an XFS issue.

> Do you think we need to look at RAM handling by this Supermicro machine
> type?

Not sure what you mean by that. Problems like this can be caused by
bad hardware, but it's unusual for a machine using ECC memory to
have undetected RAM problems...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

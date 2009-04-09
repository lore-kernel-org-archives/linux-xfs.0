Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n39FRxch255482 for <xfs@oss.sgi.com>; Thu, 9 Apr 2009 10:28:10 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B65332009ED
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2009 08:27:39 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id oa9B17PvBrJDJhu8 for
	<xfs@oss.sgi.com>; Thu, 09 Apr 2009 08:27:39 -0700 (PDT)
Message-ID: <49DE13E9.6040605@sandeen.net>
Date: Thu, 09 Apr 2009 10:27:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [BUG] spinlock lockup on CPU#0
References: <200903301936.08477.cova@ferrara.linux.it>
	<19f34abd0904090707v7eb8b677gbda42595aa04a090@mail.gmail.com>
In-Reply-To: <19f34abd0904090707v7eb8b677gbda42595aa04a090@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Fabio Coatti <cova@ferrara.linux.it>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Vegard Nossum wrote:
> 2009/3/30 Fabio Coatti <cova@ferrara.linux.it>:
>> Hi all, I've got the following BUG: report on one of our servers running
>> 2.6.28.8; some background:
>> we are seeing several lockups in db (mysql) servers that shows up as a sudden
>> load increase and then, very quickly, the server freezes. It happens in a
>> random way, sometimes after weeks, sometimes very quickly after a system
>> reboot. Trying to discover the problem we installed latest (at the time of
>> test) 2.6.28.X kernel and loaded it with some high disk I/O operations (find,
>> dd, rsync and so on).
>> We have been able  to crash a server with these tests; unfortunately we have
>> been able to capture only a remote screen snapshot so I copied by hand
>> (hopefully without typos) the data and this is the result is the following:
> 
> Hi,
> 
> Thanks for the report.
> 
>>  [<ffffffff80213590>] ? default_idle+0x30/0x50
>>  [<ffffffff8021358e>] ? default_idle+0x2e/0x50
>>  [<ffffffff80213793>] ? c1e_idle+0x73/0x120
>>  [<ffffffff80259f11>] ? atomic_notifier_call_chain+0x11/0x20
>>  [<ffffffff8020a31f>] ? cpu_idle+0x3f/0x70
>> BUG: spinlock lockup on CPU#0, find/13114, ffff8801363d2c80
>> Pid: 13114, comm: find Tainted: G      D W  2.6.28.8 #5
>> Call Trace:
>>  [<ffffffff8041a02e>] _raw_spin_lock+0x14e/0x180
>>  [<ffffffff8060b691>] _spin_lock+0x51/0x70
>>  [<ffffffff80231ca4>] ? task_rq_lock+0x54/0xa0
>>  [<ffffffff80231ca4>] task_rq_lock+0x54/0xa0
>>  [<ffffffff80234501>] try_to_wake_up+0x91/0x280
>>  [<ffffffff80234720>] wake_up_process+0x10/0x20
>>  [<ffffffff803bf863>] xfsbufd_wakeup+0x53/0x70
>>  [<ffffffff802871e0>] shrink_slab+0x90/0x180
>>  [<ffffffff80287526>] try_to_free_pages+0x256/0x3a0
>>  [<ffffffff80285280>] ? isolate_pages_global+0x0/0x280
>>  [<ffffffff80281166>] __alloc_pages_internal+0x1b6/0x460
>>  [<ffffffff802a186d>] alloc_page_vma+0x6d/0x110
>>  [<ffffffff8028d3ab>] handle_mm_fault+0x4ab/0x790
>>  [<ffffffff80225293>] do_page_fault+0x463/0x870
>>  [<ffffffff8060b199>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>>  [<ffffffff8060bf52>] error_exit+0x0/0xa9
> 
> Seems like you hit this:

In _xfs_buf_lookup_pages?  that's not on the stack, and we didn't see
the below printk...

> /*
>  * This could deadlock.
>  *
>  * But until all the XFS lowlevel code is revamped to
>  * handle buffer allocation failures we can't do much.
>  */
> if (!(++retries % 100))
>         printk(KERN_ERR
>                         "XFS: possible memory allocation "
>                         "deadlock in %s (mode:0x%x)\n",
>                         __func__, gfp_mask);
> 
...

so I don't think so.  From the trace:

>>  [<ffffffff803bf863>] xfsbufd_wakeup+0x53/0x70
>>  [<ffffffff802871e0>] shrink_slab+0x90/0x180

this is the shrinker kicking off:

static struct shrinker xfs_buf_shake = {
        .shrink = xfsbufd_wakeup,
        .seeks = DEFAULT_SEEKS,
};


> ...so my guess is that you ran out of memory (and XFS simply can't
> handle it -- an error in the XFS code, of course).

Wrong guess, I think.  XFS has been called via the shrinker mechanisms
to *free* memory, and we're not able to get the task rq lock in the
wakeup path, but not sure why...

> My first tip, if you simply want your servers not to crash, is to
> switch to another filesystem. You could at least try it and see if it
> helps your problem -- that's the most straight-forward solution I can
> think of.
> 
>> The machine is a dual 2216HE (2 cores) AMD with 4 Gb ram; below you can find
>> the .config file. (from /proc/config.gz)
>>
>> we are seeing similar lockups (at least similar for the results) since several
>> kernel revisions (starting from 2.6.25.X) and on different hardware. Several
>> machines are hit by this, mostly databases (maybe for the specific usage, other
>> machines being apache servers, I don't know).
>>
>> Could someone give us some hints about this issue, or at least some
>> suggestions on how to dig it? Of course we can do any sort of testing and
>> tries.

If sysrq-t (show all running tasks) still works post-oops, capturing
that might help to see where other threads are at.  Hook up a serial
console to make capturing the output possible.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

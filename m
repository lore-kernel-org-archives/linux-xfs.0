Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A69577F3F
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 16:59:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B562304067
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 14:59:35 -0700 (PDT)
Received: from mail-ig0-f176.google.com (mail-ig0-f176.google.com
	[209.85.213.176]) by cuda.sgi.com with ESMTP id
	7HvRoaEXg00CP3an (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 May 2014 14:59:31 -0700 (PDT)
Received: by mail-ig0-f176.google.com with SMTP id hl10so6807552igb.9
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 14:59:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <537CFECF.9070701@ccur.com>
References: <537CFECF.9070701@ccur.com>
Date: Wed, 21 May 2014 14:59:30 -0700
Message-ID: <CANGgnMYCFVQ7aR2Qjo+c5B=Jyi3QfyhAHd6y3imSN_7a3Y4Ekg@mail.gmail.com>
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
From: Austin Schuh <austin@peloton-tech.com>
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
To: John Blackwood <john.blackwood@ccur.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>, linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, xfs <xfs@oss.sgi.com>

On Wed, May 21, 2014 at 12:30 PM, John Blackwood
<john.blackwood@ccur.com> wrote:
>> Date: Wed, 21 May 2014 03:33:49 -0400
>> From: Richard Weinberger <richard.weinberger@gmail.com>
>> To: Austin Schuh <austin@peloton-tech.com>
>> CC: LKML <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>, rt-users
>>       <linux-rt-users@vger.kernel.org>
>> Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
>
>>
>> CC'ing RT folks
>>
>> On Wed, May 21, 2014 at 8:23 AM, Austin Schuh <austin@peloton-tech.com>
>> wrote:
>> > > On Tue, May 13, 2014 at 7:29 PM, Austin Schuh
>> > > <austin@peloton-tech.com> wrote:
>> >> >> Hi,
>> >> >>
>> >> >> I am observing a filesystem lockup with XFS on a CONFIG_PREEMPT_RT
>> >> >> patched kernel.  I have currently only triggered it using dpkg.
>> >> >> Dave
>> >> >> Chinner on the XFS mailing list suggested that it was a rt-kernel
>> >> >> workqueue issue as opposed to a XFS problem after looking at the
>> >> >> kernel messages.
>> >> >>
>> >> >> The only modification to the kernel besides the RT patch is that I
>> >> >> have applied tglx's "genirq: Sanitize spurious interrupt detection
>> >> >> of
>> >> >> threaded irqs" patch.
>> > >
>> > > I upgraded to 3.14.3-rt4, and the problem still persists.
>> > >
>> > > I turned on event tracing and tracked it down further.  I'm able to
>> > > lock it up by scping a new kernel debian package to /tmp/ on the
>> > > machine.  scp is locking the inode, and then scheduling
>> > > xfs_bmapi_allocate_worker in the work queue.  The work then never gets
>> > > run.  The kworkers then lock up waiting for the inode lock.
>> > >
>> > > Here are the relevant events from the trace.  ffff8803e9f10288
>> > > (blk_delay_work) gets run later on in the trace, but ffff8803b4c158d0
>> > > (xfs_bmapi_allocate_worker) never does.  The kernel then warns about
>> > > blocked tasks 120 seconds later.
>
> Austin and Richard,
>
> I'm not 100% sure that the patch below will fix your problem, but we
> saw something that sounds pretty familiar to your issue involving the
> nvidia driver and the preempt-rt patch.  The nvidia driver uses the
> completion support to create their own driver's notion of an internally
> used semaphore.
>
> Some tasks were failing to ever wakeup from wait_for_completion() calls
> due to a race in the underlying do_wait_for_common() routine.

Hi John,

Thanks for the suggestion and patch.  The issue is that the work never
gets run, not that the work finishes but the waiter never gets woken.
I applied it anyways to see if it helps, but I still get the lockup.

Thanks,
    Austin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

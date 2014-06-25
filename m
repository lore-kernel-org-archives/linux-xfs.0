Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AF3197F3F
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 22:05:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A38AC8F804B
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 20:05:30 -0700 (PDT)
Received: from mail-ie0-f169.google.com (mail-ie0-f169.google.com
	[209.85.223.169]) by cuda.sgi.com with ESMTP id
	Qqv8ZGmsSaQCf3Fs (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 20:05:28 -0700 (PDT)
Received: by mail-ie0-f169.google.com with SMTP id at1so1122260iec.14
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 20:05:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140624032521.GA12164@htj.dyndns.org>
References: <CANGgnMb=2dYGQO4K36pQ9LEb8E4rT6S_VskLF+n=ndd0_kJr_g@mail.gmail.com>
	<CANGgnMa80WwQ8zSkL52yYegmQURVQeZiBFv41=FQXMZJ_NaEDw@mail.gmail.com>
	<20140513034647.GA5421@dastard>
	<CANGgnMZ0q9uE3NHj2i0SBK1d0vdKLx7QBJeFNb+YwP-5EAmejQ@mail.gmail.com>
	<20140513063943.GQ26353@dastard>
	<CANGgnMYn++1++UyX+D2d9GxPxtytpQJv0ThFwdxM-yX7xDWqiA@mail.gmail.com>
	<20140513090321.GR26353@dastard>
	<CANGgnMZqQc_NeaDpO_aX+bndmHrQ9VWo9mkfxhPBkRD-J=N6sQ@mail.gmail.com>
	<CANGgnMZ8OwzfBj5m9H7c6q2yahGhU7oFZLsJfVxnWoqZExkZmQ@mail.gmail.com>
	<20140624030240.GB9508@dastard> <20140624032521.GA12164@htj.dyndns.org>
From: Austin Schuh <austin@peloton-tech.com>
Date: Tue, 24 Jun 2014 20:05:07 -0700
Message-ID: <CANGgnMY5cBSXOayDbbOvqNXEG8e6sAYEjpWEQO2X8XPxx2R5-Q@mail.gmail.com>
Subject: Re: On-stack work item completion race? (was Re: XFS crash?)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8614171302363527970=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, xfs <xfs@oss.sgi.com>

--===============8614171302363527970==
Content-Type: multipart/alternative; boundary=089e0115ebd02914c004fca05925

--089e0115ebd02914c004fca05925
Content-Type: text/plain; charset=UTF-8

[Adding tglx to the cc]

On Mon, Jun 23, 2014 at 8:25 PM, Tejun Heo <tj@kernel.org> wrote:

> Hello,
>
> On Tue, Jun 24, 2014 at 01:02:40PM +1000, Dave Chinner wrote:
> > start_flush_work() is effectively a special queue_work()
> > implementation, so if if it's not safe to call complete() from the
> > workqueue as the above patch implies then this code has the same
> > problem.
> >
> > Tejun - is this "do it yourself completion" a known issue w.r.t.
> > workqueues? I can't find any documentation that says "don't do
> > that" so...?
>
> It's more complex than using flush_work() but there's nothing
> fundamentally wrong with it.  A work item is completely unlinked
> before its execution starts.  It's safe to free the work item once its
> work function started, whether through kfree() or returning.
>
> One difference between flush_work() and manual completion would be
> that if the work item gets requeued, flush_work() would wait for the
> queued one to finish but given the work item is one-shot this doesn't
> make any difference.
>
> I can see no reason why manual completion would behave differently
> from flush_work() in this case.
>

I went looking for a short trace in my original log to show the problem,
and instead found evidence of the second problem.  I still like the shorter
flush_work call, but that's not my call.

I did find this comment in the process_one_work function.  Sounds like this
could be better documented.

  /*
   * It is permissible to free the struct work_struct from
   * inside the function that is called from it, this we need to
   * take into account for lockdep too.  To avoid bogus "held
   * lock freed" warnings as well as problems when looking into
   * work->lockdep_map, make a copy and use that here.
   */

 > As I understand it, what then happens is that the workqueue code
> > grabs another kworker thread and runs the next work item in it's
> > queue. IOWs, work items can block, but doing that does not prevent
> > execution of other work items queued on other work queues or even on
> > the same work queue. Tejun, did I get that correct?
>
> Yes, as long as the workqueue is under its @max_active limit and has
> access to an existing kworker or can create a new one, it'll start
> executing the next work item immediately; however, the guaranteed
> level of concurrency is 1 even for WQ_RECLAIM workqueues.  IOW, the
> work items queued on a workqueue must be able to make forward progress
> with single work item if the work items are being depended upon for
> memory reclaim.


I mentioned this to Dave when I initially started this thread, but I'm
running a RT patched kernel.  I don't see forwards progress.  The workqueue
is only used in 1 spot (xfs_alloc_wq), and has WQ_MEM_RECLAIM set.  I
started with a 10,000,000 line trace and pulled out the entries which
referenced the workqueue and pool leading up to the lockup.

             scp-4110  [001] ....1.3   101.184640: workqueue_queue_work:
work struct=ffff8803c782d900 function=xfs_bmapi_allocate_worker
workqueue=ffff88040c9f5a00 pool=ffff88042dae3fc0 req_cpu=512 cpu=1
             scp-4110  [001] ....1.3   101.184641: workqueue_activate_work:
work struct ffff8803c782d900
     kworker/1:1-89    [001] ....1.1   101.184883: workqueue_nr_running:
pool=ffff88042dae3fc0 nr_running=1
     kworker/1:1-89    [001] ....1..   101.184885: workqueue_execute_start:
work struct ffff8803c782d900: function xfs_bmapi_allocate_worker
     irq/44-ahci-275   [001] ....1.5   101.185086: workqueue_queue_work:
work struct=ffff8800ae3f01e0 function=xfs_end_io workqueue=ffff88040b459a00
pool=ffff88042dae3fc0 req_cpu=512 cpu=1
     irq/44-ahci-275   [001] ....1.5   101.185088: workqueue_activate_work:
work struct ffff8800ae3f01e0
             scp-4110  [001] ....1..   101.187911: xfs_ilock: dev 8:5 ino
0xf9e flags ILOCK_EXCL caller xfs_iomap_write_allocate
             scp-4110  [001] ....1.3   101.187914: workqueue_queue_work:
work struct=ffff8803c782d900 function=xfs_bmapi_allocate_worker
workqueue=ffff88040c9f5a00 pool=ffff88042dae3fc0 req_cpu=512 cpu=1
             scp-4110  [001] ....1.3   101.187915: workqueue_activate_work:
work struct ffff8803c782d900
             scp-4110  [001] ....1.4   101.187926: workqueue_queue_work:
work struct=ffff88040a6a01c8 function=blk_delay_work
workqueue=ffff88040c9f4a00 pool=ffff88042dae44c0 req_cpu=512 cpu=1
             scp-4110  [001] ....1.4   101.187926: workqueue_activate_work:
work struct ffff88040a6a01c8
     kworker/1:1-89    [001] ....1..   101.187998: workqueue_execute_end:
work struct ffff8803c782d900
     kworker/1:1-89    [001] ....1..   101.188000: workqueue_execute_start:
work struct ffff8800ae3f01e0: function xfs_end_io
     kworker/1:1-89    [001] ....1..   101.188001: xfs_ilock: dev 8:5 ino
0xf9e flags ILOCK_EXCL caller xfs_setfilesize

The last work never runs.  Hangcheck triggers shortly after.

I spent some more time debugging, and I am seeing that tsk_is_pi_blocked is
returning 1 in sched_submit_work (kernel/sched/core.c).  It looks
like sched_submit_work is not detecting that the worker task is blocked on
a mutex.

This looks very RT related right now.  I see 2 problems from my reading
(and experimentation).  The first is that the second worker isn't getting
started because tsk_is_pi_blocked is reporting that the task isn't blocked
on a mutex.  The second is that even if another worker needs to be
scheduled because the original worker is blocked on a mutex, we need the
pool lock to schedule another worker.  The pool lock can be acquired by any
CPU, and is a spin_lock.  If we end up on the slow path for the pool lock,
we hit BUG_ON(rt_mutex_real_waiter(task->pi_blocked_on))
in task_blocks_on_rt_mutex in rtmutex.c.  I'm not sure how to deal with
either problem.

Hopefully I've got all my facts right...  Debugging kernel code is a whole
new world from userspace code.

Thanks!
Austin

--089e0115ebd02914c004fca05925
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">[Add=
ing tglx to the cc]</div><div class=3D"gmail_quote"><br></div><div class=3D=
"gmail_quote">On Mon, Jun 23, 2014 at 8:25 PM, Tejun Heo <span dir=3D"ltr">=
&lt;<a href=3D"mailto:tj@kernel.org" target=3D"_blank">tj@kernel.org</a>&gt=
;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex">
Hello,<br>
<div><br>
On Tue, Jun 24, 2014 at 01:02:40PM +1000, Dave Chinner wrote:<br>
&gt; start_flush_work() is effectively a special queue_work()<br>
&gt; implementation, so if if it&#39;s not safe to call complete() from the=
<br>
&gt; workqueue as the above patch implies then this code has the same<br>
&gt; problem.<br>
&gt;<br>
&gt; Tejun - is this &quot;do it yourself completion&quot; a known issue w.=
r.t.<br>
&gt; workqueues? I can&#39;t find any documentation that says &quot;don&#39=
;t do<br>
&gt; that&quot; so...?<br>
<br>
</div>It&#39;s more complex than using flush_work() but there&#39;s nothing=
<br>
fundamentally wrong with it. =C2=A0A work item is completely unlinked<br>
before its execution starts. =C2=A0It&#39;s safe to free the work item once=
 its<br>
work function started, whether through kfree() or returning.<br>
<br>
One difference between flush_work() and manual completion would be<br>
that if the work item gets requeued, flush_work() would wait for the<br>
queued one to finish but given the work item is one-shot this doesn&#39;t<b=
r>
make any difference.<br>
<br>
I can see no reason why manual completion would behave differently<br>
from flush_work() in this case.<br></blockquote><div><br></div><div>I went =
looking for a short trace in my original log to show the problem, and inste=
ad found evidence of the second problem. =C2=A0I still like the shorter flu=
sh_work call, but that&#39;s not my call.</div>

<div><br></div><div>I did find this comment in the=C2=A0process_one_work fu=
nction. =C2=A0Sounds like this could be better documented.</div>
<div><br></div><div>=C2=A0 /*</div><div>=C2=A0 =C2=A0* It is permissible to=
 free the struct work_struct from</div><div>=C2=A0 =C2=A0* inside the funct=
ion that is called from it, this we need to</div><div>=C2=A0 =C2=A0* take i=
nto account for lockdep too. =C2=A0To avoid bogus &quot;held</div>


<div>=C2=A0 =C2=A0* lock freed&quot; warnings as well as problems when look=
ing into</div><div>=C2=A0 =C2=A0* work-&gt;lockdep_map, make a copy and use=
 that here.</div><div>=C2=A0 =C2=A0*/</div><div><br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;bo=
rder-left-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex">


<div>
&gt; As I understand it, what then happens is that the workqueue code<br>
&gt; grabs another kworker thread and runs the next work item in it&#39;s<b=
r>
&gt; queue. IOWs, work items can block, but doing that does not prevent<br>
&gt; execution of other work items queued on other work queues or even on<b=
r>
&gt; the same work queue. Tejun, did I get that correct?<br>
<br>
</div>Yes, as long as the workqueue is under its @max_active limit and has<=
br>
access to an existing kworker or can create a new one, it&#39;ll start<br>
executing the next work item immediately; however, the guaranteed<br>
level of concurrency is 1 even for WQ_RECLAIM workqueues. =C2=A0IOW, the<br=
>
work items queued on a workqueue must be able to make forward progress<br>
with single work item if the work items are being depended upon for<br>
memory reclaim.</blockquote><div><br></div><div>I mentioned this to Dave wh=
en I initially started this thread, but I&#39;m running a RT patched kernel=
. =C2=A0I don&#39;t see forwards progress. =C2=A0The workqueue is only used=
 in 1 spot (xfs_alloc_wq), and has WQ_MEM_RECLAIM set. =C2=A0I started with=
 a 10,000,000 line trace and pulled out the entries which referenced the wo=
rkqueue and pool leading up to the lockup.</div>

<div><br></div><div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sc=
p-4110 =C2=A0[001] ....1.3 =C2=A0 101.184640: workqueue_queue_work: work st=
ruct=3Dffff8803c782d900 function=3Dxfs_bmapi_allocate_worker workqueue=3Dff=
ff88040c9f5a00 pool=3Dffff88042dae3fc0 req_cpu=3D512 cpu=3D1</div>

<div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scp-4110 =C2=A0[001] .=
...1.3 =C2=A0 101.184641: workqueue_activate_work: work struct ffff8803c782=
d900</div><div>=C2=A0 =C2=A0 =C2=A0kworker/1:1-89 =C2=A0 =C2=A0[001] ....1.=
1 =C2=A0 101.184883: workqueue_nr_running: pool=3Dffff88042dae3fc0 nr_runni=
ng=3D1</div>

<div>=C2=A0 =C2=A0 =C2=A0kworker/1:1-89 =C2=A0 =C2=A0[001] ....1.. =C2=A0 1=
01.184885: workqueue_execute_start: work struct ffff8803c782d900: function =
xfs_bmapi_allocate_worker</div><div>=C2=A0 =C2=A0 =C2=A0irq/44-ahci-275 =C2=
=A0 [001] ....1.5 =C2=A0 101.185086: workqueue_queue_work: work struct=3Dff=
ff8800ae3f01e0 function=3Dxfs_end_io workqueue=3Dffff88040b459a00 pool=3Dff=
ff88042dae3fc0 req_cpu=3D512 cpu=3D1</div>

<div>=C2=A0 =C2=A0 =C2=A0irq/44-ahci-275 =C2=A0 [001] ....1.5 =C2=A0 101.18=
5088: workqueue_activate_work: work struct ffff8800ae3f01e0</div><div>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scp-4110 =C2=A0[001] ....1.. =
=C2=A0 101.187911: xfs_ilock: dev 8:5 ino 0xf9e flags ILOCK_EXCL caller xfs=
_iomap_write_allocate</div>

<div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scp-4110 =C2=A0[001] .=
...1.3 =C2=A0 101.187914: workqueue_queue_work: work struct=3Dffff8803c782d=
900 function=3Dxfs_bmapi_allocate_worker workqueue=3Dffff88040c9f5a00 pool=
=3Dffff88042dae3fc0 req_cpu=3D512 cpu=3D1</div><div>=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0scp-4110 =C2=A0[001] ....1.3 =C2=A0 101.187915: =
workqueue_activate_work: work struct ffff8803c782d900</div>

<div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scp-4110 =C2=A0[001] .=
...1.4 =C2=A0 101.187926: workqueue_queue_work: work struct=3Dffff88040a6a0=
1c8 function=3Dblk_delay_work workqueue=3Dffff88040c9f4a00 pool=3Dffff88042=
dae44c0 req_cpu=3D512 cpu=3D1</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0scp-4110 =C2=A0[001] ....1.4 =C2=A0 101.187926: workqueue_acti=
vate_work: work struct ffff88040a6a01c8</div>

<div>=C2=A0 =C2=A0 =C2=A0kworker/1:1-89 =C2=A0 =C2=A0[001] ....1.. =C2=A0 1=
01.187998: workqueue_execute_end: work struct ffff8803c782d900</div><div>=
=C2=A0 =C2=A0 =C2=A0kworker/1:1-89 =C2=A0 =C2=A0[001] ....1.. =C2=A0 101.18=
8000: workqueue_execute_start: work struct ffff8800ae3f01e0: function xfs_e=
nd_io</div>

<div>=C2=A0 =C2=A0 =C2=A0kworker/1:1-89 =C2=A0 =C2=A0[001] ....1.. =C2=A0 1=
01.188001: xfs_ilock: dev 8:5 ino 0xf9e flags ILOCK_EXCL caller xfs_setfile=
size</div></div><div><br></div><div>The last work never runs. =C2=A0Hangche=
ck triggers shortly after.</div>

<div><br></div><div>I spent some more time debugging, and I am seeing that=
=C2=A0tsk_is_pi_blocked is returning 1 in=C2=A0sched_submit_work (kernel/sc=
hed/core.c). =C2=A0It looks like=C2=A0sched_submit_work is not detecting th=
at the worker task is blocked on a mutex.</div>

<div><br></div><div>This looks very RT related right now. =C2=A0I see 2 pro=
blems from my reading (and experimentation). =C2=A0The first is that the se=
cond worker isn&#39;t getting started because tsk_is_pi_blocked is reportin=
g that the task isn&#39;t blocked on a mutex. =C2=A0The second is that even=
 if another worker needs to be scheduled because the original worker is blo=
cked on a mutex, we need the pool lock to schedule another worker. =C2=A0Th=
e pool lock can be acquired by any CPU, and is a spin_lock. =C2=A0If we end=
 up on the slow path for the pool lock, we hit=C2=A0BUG_ON(rt_mutex_real_wa=
iter(task-&gt;pi_blocked_on)) in=C2=A0task_blocks_on_rt_mutex in rtmutex.c.=
 =C2=A0I&#39;m not sure how to deal with either problem.</div>

<div><br></div><div>Hopefully I&#39;ve got all my facts right... =C2=A0Debu=
gging kernel code is a whole new world from userspace code.</div></div></di=
v><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">Thanks!</=
div>
<div class=3D"gmail_extra">
Austin</div></div>

--089e0115ebd02914c004fca05925--


--===============8614171302363527970==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8614171302363527970==--

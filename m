Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 449E77F3F
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2014 15:06:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F36BC304059
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2014 13:06:20 -0700 (PDT)
Received: from mail-ig0-f175.google.com (mail-ig0-f175.google.com
	[209.85.213.175]) by cuda.sgi.com with ESMTP id
	wUawa5mjsztKLThE (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Jun 2014 13:06:15 -0700 (PDT)
Received: by mail-ig0-f175.google.com with SMTP id h3so3484181igd.14
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2014 13:06:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANGgnMZqQc_NeaDpO_aX+bndmHrQ9VWo9mkfxhPBkRD-J=N6sQ@mail.gmail.com>
References: <CANGgnMYPLF+8616Rs9eQOXUc9He2NSgFnNrvHvepV-x+pWS6oQ@mail.gmail.com>
	<20140305233551.GK6851@dastard>
	<CANGgnMb=2dYGQO4K36pQ9LEb8E4rT6S_VskLF+n=ndd0_kJr_g@mail.gmail.com>
	<CANGgnMa80WwQ8zSkL52yYegmQURVQeZiBFv41=FQXMZJ_NaEDw@mail.gmail.com>
	<20140513034647.GA5421@dastard>
	<CANGgnMZ0q9uE3NHj2i0SBK1d0vdKLx7QBJeFNb+YwP-5EAmejQ@mail.gmail.com>
	<20140513063943.GQ26353@dastard>
	<CANGgnMYn++1++UyX+D2d9GxPxtytpQJv0ThFwdxM-yX7xDWqiA@mail.gmail.com>
	<20140513090321.GR26353@dastard>
	<CANGgnMZqQc_NeaDpO_aX+bndmHrQ9VWo9mkfxhPBkRD-J=N6sQ@mail.gmail.com>
From: Austin Schuh <austin@peloton-tech.com>
Date: Mon, 23 Jun 2014 13:05:54 -0700
Message-ID: <CANGgnMZ8OwzfBj5m9H7c6q2yahGhU7oFZLsJfVxnWoqZExkZmQ@mail.gmail.com>
Subject: Re: XFS crash?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3975242351288368846=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <xfs@oss.sgi.com>

--===============3975242351288368846==
Content-Type: multipart/alternative; boundary=089e0149baaa134ec604fc8660a6

--089e0149baaa134ec604fc8660a6
Content-Type: text/plain; charset=UTF-8

Hi Dave,

On Tue, May 13, 2014 at 10:11 AM, Austin Schuh <austin@peloton-tech.com>
wrote:

> On Tue, May 13, 2014 at 2:03 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, May 13, 2014 at 12:02:18AM -0700, Austin Schuh wrote:
> >> On Mon, May 12, 2014 at 11:39 PM, Dave Chinner <david@fromorbit.com>
> wrote:
> >> > On Mon, May 12, 2014 at 09:03:48PM -0700, Austin Schuh wrote:
> >> >> On Mon, May 12, 2014 at 8:46 PM, Dave Chinner <david@fromorbit.com>
> wrote:
> >> >> > On Mon, May 12, 2014 at 06:29:28PM -0700, Austin Schuh wrote:
> >> >> >> On Wed, Mar 5, 2014 at 4:53 PM, Austin Schuh <
> austin@peloton-tech.com> wrote:
> >> >> >> > Hi Dave,
> >> >> >> >
> >> >> >> > On Wed, Mar 5, 2014 at 3:35 PM, Dave Chinner <
> david@fromorbit.com> wrote:
> >> >> >> >> On Wed, Mar 05, 2014 at 03:08:16PM -0800, Austin Schuh wrote:
> >> >> >> >>> Howdy,
> >> >> >> >>>
> >> >> >> >>> I'm running a config_preempt_rt patched version of the
> 3.10.11 kernel,
> >> >> >> >>> and I'm seeing a couple lockups and crashes which I think are
> related
> >> >> >> >>> to XFS.
> >> >> >> >>
> >> >> >> >> I think they ar emore likely related to RT issues....
> >> >> >> >>
> >> >> >> >
> >> >> >> > That very well may be true.
> >> >> >> >
> >> >> >> >> Cheers,
> >> >> >> >>
> >> >> >> >> Dave.
> >> >> >> >> --
> >> >> >> >> Dave Chinner
> >> >> >>
> >> >> >> I had the issue reproduce itself today with just the main SSD
> >> >> >> installed.  This was on a new machine that was built this morning.
> >> >> >> There is a lot less going on in this trace than the previous one.
> >> >> >
> >> >> > The three blocked threads:
> >> >> >
> >> >> >         1. kworker running IO completion waiting on an inode lock,
> >> >> >            holding locked pages.
> >> >> >         2. kworker running writeback flusher work waiting for a
> page lock
> >> >> >         3. direct flush work waiting for allocation, holding page
> >> >> >            locks and the inode lock.
> >> >> >
> >> >> > What's the kworker thread running the allocation work doing?
> >> >> >
> >> >> > You might need to run `echo w > proc-sysrq-trigger` to get this
> >> >> > information...
> >> >>
> >> >> I was able to reproduce the lockup.  I ran `echo w >
> >> >> /proc/sysrq-trigger` per your suggestion.  I don't know how to figure
> >> >> out what the kworker thread is doing, but I'll happily do it if you
> >> >> can give me some guidance.
> >> >
> >> > There isn't a worker thread blocked doing an allocation in that
> >> > dump, so it doesn't shed any light on the problem at all. try
> >> > `echo l > /proc/sysrq-trigger`, followed by `echo t >
> >> > /proc/sysrq-trigger` so we can see all the processes running on CPUs
> >> > and all the processes in the system...
> >> >
> >> > Cheers,
> >> >
> >> > Dave.
> >>
> >> Attached is the output of the two commands you asked for.
> >
> > Nothing there. There's lots of processes waiting for allocation to
> > run, and no kworkers running allocation work. This looks more
> > like a rt-kernel workqueue issue, not an XFS problem.
> >
> > FWIW, it woul dbe really helpful if you compiled your kernels with
> > frame pointers enabled - the stack traces are much more precise and
> > readable (i.e. gets rid of all the false/stale entrys) and that
> > helps understanding where things are stuck immensely.
> >
> > Cheers,
> >
> > Dave.
>
> Thanks Dave.
>
> I'll go check with the rt-kernel guys and take it from there.  Thanks
> for the frame pointers suggestion.  I'll make that change the next
> time I build a kernel.
>
> Austin
>

I found 1 bug in XFS which I fixed, and I've uncovered something else that
I'm not completely sure how to fix.

In xfs_bmapi_allocate, you create a completion, and use that to wait until
the work has finished.  Occasionally, I'm seeing a case where I get a
context switch after the completion has been completed, but before the
workqueue has finished doing it's internal book-keeping.  This results in
the work being deleted before the workqueue is done using it, corrupting
the internal data structures.  I fixed it by waiting using flush_work and
removing the completion entirely.

--- a/fs/xfs/xfs_bmap_util.c        2014-06-23 12:59:10.008678410 -0700
+++ b/fs/xfs/xfs_bmap_util.c      2014-06-23 12:59:14.116678239 -0700
@@ -263,7 +263,6 @@
        current_set_flags_nested(&pflags, PF_FSTRANS);

        args->result = __xfs_bmapi_allocate(args);
-       complete(args->done);

        current_restore_flags_nested(&pflags, PF_FSTRANS);
 }
@@ -277,16 +276,13 @@
 xfs_bmapi_allocate(
        struct xfs_bmalloca     *args)
 {
-       DECLARE_COMPLETION_ONSTACK(done);
-
        if (!args->stack_switch)
                return __xfs_bmapi_allocate(args);


-       args->done = &done;
        INIT_WORK_ONSTACK(&args->work, xfs_bmapi_allocate_worker);
        queue_work(xfs_alloc_wq, &args->work);
-       wait_for_completion(&done);
+       flush_work(&args->work);
        destroy_work_on_stack(&args->work);
        return args->result;
 }
--- a/fs/xfs/xfs_bmap_util.h        2014-06-23 12:59:10.008678410 -0700
+++ b/fs/xfs/xfs_bmap_util.h      2014-06-23 12:59:11.708678340 -0700
@@ -57,7 +57,6 @@
        char                    conv;   /* overwriting unwritten extents */
        char                    stack_switch;
        int                     flags;
-       struct completion       *done;
        struct work_struct      work;
        int                     result;
 };

I enabled event tracing (and added a new event which lists the number of
workers running in a queue whenever that is changed).

To me, it looks like work is scheduled from irq/44-ahci-273 that will
acquire an inode lock.  scp-3986 then acquires the lock, and then goes and
schedules work.  That work is then scheduled behind the work from
irq/44-ahci-273 in the same pool.  The first work blocks waiting on the
lock, and scp-3986 won't finish and release that lock until the second work
gets run.

Any ideas on how to deal with this?  I think we need to create a new pool
to make sure that xfs_bmapi_allocate_worker gets run in a separate thread
to avoid this.

     irq/44-ahci-273   [000] ....1.5    76.340300: workqueue_queue_work:
work struct=ffff880406a6b998 function=xfs_end_io workqueue=ffff88040af82000
pool=ffff88042da63fc0 req_cpu=512 cpu=0
     irq/44-ahci-273   [000] ....1.5    76.340301: workqueue_activate_work:
work struct ffff880406a6b998

             scp-3986  [000] ....1..    76.342711: xfs_ilock_nowait: dev
8:5 ino 0x9794 lock_addr ffff880409fe0090 flags ILOCK_SHARED caller
xfs_map_blocks
             scp-3986  [000] ....1..    76.342714: xfs_iunlock: dev 8:5 ino
0x9794 lock_addr ffff880409fe0090 flags ILOCK_SHARED caller xfs_map_blocks
             scp-3986  [000] ....1..    76.342722: xfs_ilock: dev 8:5 ino
0x9794 lock_addr ffff880409fe0090 flags ILOCK_EXCL caller
xfs_iomap_write_allocate
             scp-3986  [000] ....1.3    76.342729: workqueue_queue_work:
work struct=ffff8800a5b8d900 function=xfs_bmapi_allocate_worker
workqueue=ffff88040bb36000 pool=ffff88042da63fc0 req_cpu=512 cpu=0
             scp-3986  [000] ....1.3    76.342730: workqueue_activate_work:
work struct ffff8800a5b8d900
             scp-3986  [000] ....1.4    76.342754: workqueue_queue_work:
work struct=ffff88040a6a01c8 function=blk_delay_work
workqueue=ffff88040c9f4a00 pool=ffff88042da644c0 req_cpu=512 cpu=0
             scp-3986  [000] ....1.4    76.342755: workqueue_activate_work:
work struct ffff88040a6a01c8

     kworker/0:2-757   [000] ....1.1    76.342868: workqueue_nr_running:
pool=ffff88042da63fc0 nr_running=1
     kworker/0:2-757   [000] ....1..    76.342869: workqueue_execute_start:
work struct ffff880406a6b998: function xfs_end_io
     kworker/0:2-757   [000] ....1..    76.342870: xfs_ilock: dev 8:5 ino
0x9794 lock_addr ffff880409fe0090 flags ILOCK_EXCL caller xfs_setfilesize

     irq/44-ahci-273   [003] ....1.5    76.419037: workqueue_queue_work:
work struct=ffff8800aebc3588 function=xfs_end_io workqueue=ffff88040af82000
pool=ffff88042dbe3fc0 req_cpu=512 cpu=3
     irq/44-ahci-273   [003] ....1.5    76.419038: workqueue_activate_work:
work struct ffff8800aebc3588

     kworker/3:1-119   [003] ....1.1    76.419105: workqueue_nr_running:
pool=ffff88042dbe3fc0 nr_running=1
     kworker/3:1-119   [003] ....1..    76.419106: workqueue_execute_start:
work struct ffff8800aebc3588: function xfs_end_io
     kworker/3:1-119   [003] ....1..    76.419107: xfs_ilock: dev 8:5 ino
0x9794 lock_addr ffff880409fe0090 flags ILOCK_EXCL caller xfs_setfilesize

     irq/44-ahci-273   [002] ....1.5    76.426120: workqueue_queue_work:
work struct=ffff880406a6b930 function=xfs_end_io workqueue=ffff88040af82000
pool=ffff88042db63fc0 req_cpu=512 cpu=2
     irq/44-ahci-273   [002] .N..1.5    76.426127: workqueue_activate_work:
work struct ffff880406a6b930
     kworker/2:1-72    [002] ....1.1    76.426242: workqueue_nr_running:
pool=ffff88042db63fc0 nr_running=1
     kworker/2:1-72    [002] ....1..    76.426243: workqueue_execute_start:
work struct ffff880406a6b930: function xfs_end_io
     kworker/2:1-72    [002] ....1..    76.426244: xfs_ilock: dev 8:5 ino
0x9794 lock_addr ffff880409fe0090 flags ILOCK_EXCL caller xfs_setfilesize

Thanks,
  Austin

--089e0149baaa134ec604fc8660a6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">Hi D=
ave,</div><div class=3D"gmail_quote"><br></div><div class=3D"gmail_quote">O=
n Tue, May 13, 2014 at 10:11 AM, Austin Schuh <span dir=3D"ltr">&lt;<a href=
=3D"mailto:austin@peloton-tech.com" target=3D"_blank">austin@peloton-tech.c=
om</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex"><div class=3D""><div class=3D"h5">On Tue, May 13, 2014 at =
2:03 AM, Dave Chinner &lt;<a href=3D"mailto:david@fromorbit.com">david@from=
orbit.com</a>&gt; wrote:<br>


&gt; On Tue, May 13, 2014 at 12:02:18AM -0700, Austin Schuh wrote:<br>
&gt;&gt; On Mon, May 12, 2014 at 11:39 PM, Dave Chinner &lt;<a href=3D"mail=
to:david@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br>
&gt;&gt; &gt; On Mon, May 12, 2014 at 09:03:48PM -0700, Austin Schuh wrote:=
<br>
&gt;&gt; &gt;&gt; On Mon, May 12, 2014 at 8:46 PM, Dave Chinner &lt;<a href=
=3D"mailto:david@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br>
&gt;&gt; &gt;&gt; &gt; On Mon, May 12, 2014 at 06:29:28PM -0700, Austin Sch=
uh wrote:<br>
&gt;&gt; &gt;&gt; &gt;&gt; On Wed, Mar 5, 2014 at 4:53 PM, Austin Schuh &lt=
;<a href=3D"mailto:austin@peloton-tech.com">austin@peloton-tech.com</a>&gt;=
 wrote:<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt; Hi Dave,<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt; On Wed, Mar 5, 2014 at 3:35 PM, Dave Chinne=
r &lt;<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a>&gt; wr=
ote:<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; On Wed, Mar 05, 2014 at 03:08:16PM -080=
0, Austin Schuh wrote:<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; Howdy,<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; I&#39;m running a config_preempt_rt=
 patched version of the 3.10.11 kernel,<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; and I&#39;m seeing a couple lockups=
 and crashes which I think are related<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;&gt; to XFS.<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; I think they ar emore likely related to=
 RT issues....<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt; That very well may be true.<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; Cheers,<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; Dave.<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; --<br>
&gt;&gt; &gt;&gt; &gt;&gt; &gt;&gt; Dave Chinner<br>
&gt;&gt; &gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; &gt;&gt; I had the issue reproduce itself today with just=
 the main SSD<br>
&gt;&gt; &gt;&gt; &gt;&gt; installed. =C2=A0This was on a new machine that =
was built this morning.<br>
&gt;&gt; &gt;&gt; &gt;&gt; There is a lot less going on in this trace than =
the previous one.<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; The three blocked threads:<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 1. kworker running IO co=
mpletion waiting on an inode lock,<br>
&gt;&gt; &gt;&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0holding loc=
ked pages.<br>
&gt;&gt; &gt;&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 2. kworker running write=
back flusher work waiting for a page lock<br>
&gt;&gt; &gt;&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 3. direct flush work wai=
ting for allocation, holding page<br>
&gt;&gt; &gt;&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0locks and t=
he inode lock.<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; What&#39;s the kworker thread running the allocation=
 work doing?<br>
&gt;&gt; &gt;&gt; &gt;<br>
&gt;&gt; &gt;&gt; &gt; You might need to run `echo w &gt; proc-sysrq-trigge=
r` to get this<br>
&gt;&gt; &gt;&gt; &gt; information...<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; I was able to reproduce the lockup. =C2=A0I ran `echo w &=
gt;<br>
&gt;&gt; &gt;&gt; /proc/sysrq-trigger` per your suggestion. =C2=A0I don&#39=
;t know how to figure<br>
&gt;&gt; &gt;&gt; out what the kworker thread is doing, but I&#39;ll happil=
y do it if you<br>
&gt;&gt; &gt;&gt; can give me some guidance.<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; There isn&#39;t a worker thread blocked doing an allocation i=
n that<br>
&gt;&gt; &gt; dump, so it doesn&#39;t shed any light on the problem at all.=
 try<br>
&gt;&gt; &gt; `echo l &gt; /proc/sysrq-trigger`, followed by `echo t &gt;<b=
r>
&gt;&gt; &gt; /proc/sysrq-trigger` so we can see all the processes running =
on CPUs<br>
&gt;&gt; &gt; and all the processes in the system...<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; Cheers,<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; Dave.<br>
&gt;&gt;<br>
&gt;&gt; Attached is the output of the two commands you asked for.<br>
&gt;<br>
&gt; Nothing there. There&#39;s lots of processes waiting for allocation to=
<br>
&gt; run, and no kworkers running allocation work. This looks more<br>
&gt; like a rt-kernel workqueue issue, not an XFS problem.<br>
&gt;<br>
&gt; FWIW, it woul dbe really helpful if you compiled your kernels with<br>
&gt; frame pointers enabled - the stack traces are much more precise and<br=
>
&gt; readable (i.e. gets rid of all the false/stale entrys) and that<br>
&gt; helps understanding where things are stuck immensely.<br>
&gt;<br>
&gt; Cheers,<br>
&gt;<br>
&gt; Dave.<br>
<br>
</div></div>Thanks Dave.<br>
<br>
I&#39;ll go check with the rt-kernel guys and take it from there. =C2=A0Tha=
nks<br>
for the frame pointers suggestion. =C2=A0I&#39;ll make that change the next=
<br>
time I build a kernel.<br>
<span class=3D""><font color=3D"#888888"><br>
Austin<br>
</font></span></blockquote></div><br></div><div class=3D"gmail_extra">I fou=
nd 1 bug in XFS which I fixed, and I&#39;ve uncovered something else that I=
&#39;m not completely sure how to fix.</div><div class=3D"gmail_extra"><br>

</div><div class=3D"gmail_extra">In=C2=A0xfs_bmapi_allocate, you create a c=
ompletion, and use that to wait until the work has finished. =C2=A0Occasion=
ally, I&#39;m seeing a case where I get a context switch after the completi=
on has been completed, but before the workqueue has finished doing it&#39;s=
 internal book-keeping. =C2=A0This results in the work being deleted before=
 the workqueue is done using it, corrupting the internal data structures. =
=C2=A0I fixed it by waiting using=C2=A0flush_work and removing the completi=
on entirely.</div>

<div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra"><div class=
=3D"gmail_extra"><div class=3D"gmail_extra">--- a/fs/xfs/xfs_bmap_util.c =
=C2=A0 =C2=A0 =C2=A0 =C2=A02014-06-23 12:59:10.008678410 -0700</div><div cl=
ass=3D"gmail_extra">+++ b/fs/xfs/xfs_bmap_util.c =C2=A0 =C2=A0 =C2=A02014-0=
6-23 12:59:14.116678239 -0700</div>

<div class=3D"gmail_extra">@@ -263,7 +263,6 @@</div><div class=3D"gmail_ext=
ra">=C2=A0 =C2=A0 =C2=A0 =C2=A0 current_set_flags_nested(&amp;pflags, PF_FS=
TRANS);</div><div class=3D"gmail_extra">=C2=A0</div><div class=3D"gmail_ext=
ra">=C2=A0 =C2=A0 =C2=A0 =C2=A0 args-&gt;result =3D __xfs_bmapi_allocate(ar=
gs);</div>

<div class=3D"gmail_extra">- =C2=A0 =C2=A0 =C2=A0 complete(args-&gt;done);<=
/div><div class=3D"gmail_extra">=C2=A0</div><div class=3D"gmail_extra">=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 current_restore_flags_nested(&amp;pflags, PF_FSTRA=
NS);</div><div class=3D"gmail_extra">=C2=A0}</div>

<div class=3D"gmail_extra">@@ -277,16 +276,13 @@</div><div class=3D"gmail_e=
xtra">=C2=A0xfs_bmapi_allocate(</div><div class=3D"gmail_extra">=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 struct xfs_bmalloca =C2=A0 =C2=A0 *args)</div><div class=
=3D"gmail_extra">=C2=A0{</div><div class=3D"gmail_extra">

- =C2=A0 =C2=A0 =C2=A0 DECLARE_COMPLETION_ONSTACK(done);</div><div class=3D=
"gmail_extra">-</div><div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 if (!args-&gt;stack_switch)</div><div class=3D"gmail_extra">=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return __xfs_bmapi_allocate(args)=
;</div>

<div class=3D"gmail_extra">=C2=A0</div><div class=3D"gmail_extra">=C2=A0</d=
iv><div class=3D"gmail_extra">- =C2=A0 =C2=A0 =C2=A0 args-&gt;done =3D &amp=
;done;</div><div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0 =C2=A0 INIT_WOR=
K_ONSTACK(&amp;args-&gt;work, xfs_bmapi_allocate_worker);</div>

<div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0 =C2=A0 queue_work(xfs_alloc=
_wq, &amp;args-&gt;work);</div><div class=3D"gmail_extra">- =C2=A0 =C2=A0 =
=C2=A0 wait_for_completion(&amp;done);</div><div class=3D"gmail_extra">+ =
=C2=A0 =C2=A0 =C2=A0 flush_work(&amp;args-&gt;work);</div>

<div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0 =C2=A0 destroy_work_on_stac=
k(&amp;args-&gt;work);</div><div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return args-&gt;result;</div><div class=3D"gmail_extra">=C2=A0}</di=
v><div><div>--- a/fs/xfs/xfs_bmap_util.h =C2=A0 =C2=A0 =C2=A0 =C2=A02014-06=
-23 12:59:10.008678410 -0700</div>

<div>+++ b/fs/xfs/xfs_bmap_util.h =C2=A0 =C2=A0 =C2=A02014-06-23 12:59:11.7=
08678340 -0700</div><div>@@ -57,7 +57,6 @@</div><div>=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 char =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0conv; =C2=A0 /* overwriting unwritten extents */</div><div>=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 char =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0stack_switch;</div>

<div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 flags;</div><div>- =C2=A0 =C2=A0 =C2=A0 str=
uct completion =C2=A0 =C2=A0 =C2=A0 *done;</div><div>=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 struct work_struct =C2=A0 =C2=A0 =C2=A0work;</div><div>=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 result;</div><div>=C2=A0};</div></div></div>

</div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">I ena=
bled event tracing (and added a new event which lists the number of workers=
 running in a queue whenever that is changed).</div><div class=3D"gmail_ext=
ra">

<br></div><div class=3D"gmail_extra">To me, it looks like work is scheduled=
 from irq/44-ahci-273 that will acquire an inode lock. =C2=A0scp-3986 then =
acquires the lock, and then goes and schedules work. =C2=A0That work is the=
n scheduled behind the work from irq/44-ahci-273 in the same pool. =C2=A0Th=
e first work blocks waiting on the lock, and scp-3986 won&#39;t finish and =
release that lock until the second work gets run.</div>

<div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">Any ideas o=
n how to deal with this? =C2=A0I think we need to create a new pool to make=
 sure that xfs_bmapi_allocate_worker gets run in a separate thread to avoid=
 this.</div>

<div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra"><div class=
=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0irq/44-ahci-273 =C2=A0 [000] ....1.5 =
=C2=A0 =C2=A076.340300: workqueue_queue_work: work struct=3Dffff880406a6b99=
8 function=3Dxfs_end_io workqueue=3Dffff88040af82000 pool=3Dffff88042da63fc=
0 req_cpu=3D512 cpu=3D0</div>

<div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0irq/44-ahci-273 =C2=A0 [000]=
 ....1.5 =C2=A0 =C2=A076.340301: workqueue_activate_work: work struct ffff8=
80406a6b998</div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_e=
xtra">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scp-3986 =C2=A0[000] =
....1.. =C2=A0 =C2=A076.342711: xfs_ilock_nowait: dev 8:5 ino 0x9794 lock_a=
ddr ffff880409fe0090 flags ILOCK_SHARED caller xfs_map_blocks</div>

<div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
scp-3986 =C2=A0[000] ....1.. =C2=A0 =C2=A076.342714: xfs_iunlock: dev 8:5 i=
no 0x9794 lock_addr ffff880409fe0090 flags ILOCK_SHARED caller xfs_map_bloc=
ks</div><div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0scp-3986 =C2=A0[000] ....1.. =C2=A0 =C2=A076.342722: xfs_ilock: d=
ev 8:5 ino 0x9794 lock_addr ffff880409fe0090 flags ILOCK_EXCL caller xfs_io=
map_write_allocate</div>

<div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
scp-3986 =C2=A0[000] ....1.3 =C2=A0 =C2=A076.342729: workqueue_queue_work: =
work struct=3Dffff8800a5b8d900 function=3Dxfs_bmapi_allocate_worker workque=
ue=3Dffff88040bb36000 pool=3Dffff88042da63fc0 req_cpu=3D512 cpu=3D0</div>

<div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
scp-3986 =C2=A0[000] ....1.3 =C2=A0 =C2=A076.342730: workqueue_activate_wor=
k: work struct ffff8800a5b8d900</div><div class=3D"gmail_extra">=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scp-3986 =C2=A0[000] ....1.4 =C2=A0 =
=C2=A076.342754: workqueue_queue_work: work struct=3Dffff88040a6a01c8 funct=
ion=3Dblk_delay_work workqueue=3Dffff88040c9f4a00 pool=3Dffff88042da644c0 r=
eq_cpu=3D512 cpu=3D0</div>

<div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
scp-3986 =C2=A0[000] ....1.4 =C2=A0 =C2=A076.342755: workqueue_activate_wor=
k: work struct ffff88040a6a01c8</div><div class=3D"gmail_extra"><br></div><=
div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0kworker/0:2-757 =C2=A0 [000] =
....1.1 =C2=A0 =C2=A076.342868: workqueue_nr_running: pool=3Dffff88042da63f=
c0 nr_running=3D1</div>

<div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0kworker/0:2-757 =C2=A0 [000]=
 ....1.. =C2=A0 =C2=A076.342869: workqueue_execute_start: work struct ffff8=
80406a6b998: function xfs_end_io</div><div class=3D"gmail_extra">=C2=A0 =C2=
=A0 =C2=A0kworker/0:2-757 =C2=A0 [000] ....1.. =C2=A0 =C2=A076.342870: xfs_=
ilock: dev 8:5 ino 0x9794 lock_addr ffff880409fe0090 flags ILOCK_EXCL calle=
r xfs_setfilesize</div>

<div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">=C2=A0 =C2=
=A0 =C2=A0irq/44-ahci-273 =C2=A0 [003] ....1.5 =C2=A0 =C2=A076.419037: work=
queue_queue_work: work struct=3Dffff8800aebc3588 function=3Dxfs_end_io work=
queue=3Dffff88040af82000 pool=3Dffff88042dbe3fc0 req_cpu=3D512 cpu=3D3</div=
>

<div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0irq/44-ahci-273 =C2=A0 [003]=
 ....1.5 =C2=A0 =C2=A076.419038: workqueue_activate_work: work struct ffff8=
800aebc3588</div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_e=
xtra">=C2=A0 =C2=A0 =C2=A0kworker/3:1-119 =C2=A0 [003] ....1.1 =C2=A0 =C2=
=A076.419105: workqueue_nr_running: pool=3Dffff88042dbe3fc0 nr_running=3D1<=
/div>

<div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0kworker/3:1-119 =C2=A0 [003]=
 ....1.. =C2=A0 =C2=A076.419106: workqueue_execute_start: work struct ffff8=
800aebc3588: function xfs_end_io</div><div class=3D"gmail_extra">=C2=A0 =C2=
=A0 =C2=A0kworker/3:1-119 =C2=A0 [003] ....1.. =C2=A0 =C2=A076.419107: xfs_=
ilock: dev 8:5 ino 0x9794 lock_addr ffff880409fe0090 flags ILOCK_EXCL calle=
r xfs_setfilesize</div>

<div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">=C2=A0 =C2=
=A0 =C2=A0irq/44-ahci-273 =C2=A0 [002] ....1.5 =C2=A0 =C2=A076.426120: work=
queue_queue_work: work struct=3Dffff880406a6b930 function=3Dxfs_end_io work=
queue=3Dffff88040af82000 pool=3Dffff88042db63fc0 req_cpu=3D512 cpu=3D2</div=
>

<div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0irq/44-ahci-273 =C2=A0 [002]=
 .N..1.5 =C2=A0 =C2=A076.426127: workqueue_activate_work: work struct ffff8=
80406a6b930</div><div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0kworker/2:1=
-72 =C2=A0 =C2=A0[002] ....1.1 =C2=A0 =C2=A076.426242: workqueue_nr_running=
: pool=3Dffff88042db63fc0 nr_running=3D1</div>

<div class=3D"gmail_extra">=C2=A0 =C2=A0 =C2=A0kworker/2:1-72 =C2=A0 =C2=A0=
[002] ....1.. =C2=A0 =C2=A076.426243: workqueue_execute_start: work struct =
ffff880406a6b930: function xfs_end_io</div><div class=3D"gmail_extra">=C2=
=A0 =C2=A0 =C2=A0kworker/2:1-72 =C2=A0 =C2=A0[002] ....1.. =C2=A0 =C2=A076.=
426244: xfs_ilock: dev 8:5 ino 0x9794 lock_addr ffff880409fe0090 flags ILOC=
K_EXCL caller xfs_setfilesize</div>

<div><br></div><div>Thanks,</div><div>=C2=A0 Austin</div></div></div>

--089e0149baaa134ec604fc8660a6--


--===============3975242351288368846==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3975242351288368846==--

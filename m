Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8E9C429E0E
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2015 07:23:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 646F48F8049
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2015 05:23:16 -0700 (PDT)
Received: from mail-ig0-f175.google.com (mail-ig0-f175.google.com
	[209.85.213.175]) by cuda.sgi.com with ESMTP id
	yAv4jyYyGHvMOkTn (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Jul 2015 05:23:13 -0700 (PDT)
Received: by igbij6 with SMTP id ij6so134925562igb.1
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2015 05:23:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150707003542.GW7943@dastard>
References: <CADb9451tB71D3XCqcOkDxzpzbdEHqwj7XCZUpL8yg1DzYbpwBw@mail.gmail.com>
	<20150703235141.GQ7943@dastard>
	<CADb9451j0WEeL4m-fEHzrOf3ys+eSHJKNzcN9oHAOs2kDLL_kQ@mail.gmail.com>
	<20150704233802.GS7943@dastard>
	<CADb9452UYPqo_i2M=-sSwPKwqUrRSMJ4bhV10S=1k0sNCKCVfg@mail.gmail.com>
	<20150705232443.GA3902@dastard>
	<CADb9453iT7+2zgKDqY7gpHGjQ6nayqQFES1AJHn0G2FMFjYX-A@mail.gmail.com>
	<20150707003542.GW7943@dastard>
Date: Wed, 22 Jul 2015 08:23:12 -0400
Message-ID: <CADb9453G6=+k0SGj4Q_xJ8KmA4es0_ABHmwk5GFymJ4nEYoo4g@mail.gmail.com>
Subject: Re: Failing XFS filesystem underlying Ceph OSDs
From: Alex Gorbachev <ag@iss-integration.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2804397914870347393=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============2804397914870347393==
Content-Type: multipart/alternative; boundary=001a113f8eb6a41018051b75d5fd

--001a113f8eb6a41018051b75d5fd
Content-Type: text/plain; charset=UTF-8

Hi Dave,

On Mon, Jul 6, 2015 at 8:35 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Jul 06, 2015 at 03:20:19PM -0400, Alex Gorbachev wrote:
> > On Sun, Jul 5, 2015 at 7:24 PM, Dave Chinner <david@fromorbit.com>
> wrote:
> > > On Sun, Jul 05, 2015 at 12:25:47AM -0400, Alex Gorbachev wrote:
> > > > > > sysctl vm.swappiness=20 (can probably be 1 as per article)
> > > > > >
> > > > > > sysctl vm.min_free_kbytes=262144
> > > > >
> > > [...]
> > > >
> > > > We have experienced the problem in various guises with kernels 3.14,
> > > 3.19,
> > > > 4.1-rc2 and now 4.1, so it's not new to us, just different error
> stack.
> > > > Below are some other stack dumps of what manifested as the same
> error.
> > > >
> > > >  [<ffffffff817cf4b9>] schedule+0x29/0x70
> > > >  [<ffffffffc07caee7>] _xfs_log_force+0x187/0x280 [xfs]
> > > >  [<ffffffff810a4150>] ? try_to_wake_up+0x2a0/0x2a0
> > > >  [<ffffffffc07cb019>] xfs_log_force+0x39/0xc0 [xfs]
> > > >  [<ffffffffc07d6542>] xfsaild_push+0x552/0x5a0 [xfs]
> > > >  [<ffffffff817d2264>] ? schedule_timeout+0x124/0x210
> > > >  [<ffffffffc07d662f>] xfsaild+0x9f/0x140 [xfs]
> > > >  [<ffffffffc07d6590>] ? xfsaild_push+0x5a0/0x5a0 [xfs]
> > > >  [<ffffffff81095e29>] kthread+0xc9/0xe0
> > > >  [<ffffffff81095d60>] ? flush_kthread_worker+0x90/0x90
> > > >  [<ffffffff817d3718>] ret_from_fork+0x58/0x90
> > > >  [<ffffffff81095d60>] ? flush_kthread_worker+0x90/0x90
> > > >  INFO: task xfsaild/sdg1:2606 blocked for more than 120 seconds.
> > > >        Not tainted 3.19.4-031904-generic #201504131440
> > > >  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> > > message.
> > >
> > > That's indicative of IO completion problems, but not a crash.
> > >
> > > >  BUG: unable to handle kernel NULL pointer dereference at
> > >  (null)
> > > >  IP: [<ffffffffc04be80f>] xfs_count_page_state+0x3f/0x70 [xfs]
> > > ....
> > > >   [<ffffffffc04be880>] xfs_vm_releasepage+0x40/0x120 [xfs]
> > > >   [<ffffffff8118a7d2>] try_to_release_page+0x32/0x50
> > > >   [<ffffffff8119fe6d>] shrink_page_list+0x69d/0x720
> > > >   [<ffffffff811a058d>] shrink_inactive_list+0x1dd/0x5d0
> > > ....
> > >
> > > Again, this is indicative of a page cache issue: a page without
> > > buffers has been passed to xfs_vm_releasepage(), which implies the
> > > page flags are not correct. i.e PAGE_FLAGS_PRIVATE is set but
> > > page->private is null...
> > >
> > > Again, this is unlikely to be an XFS issue.
> > >
> >
> > Sorry for my ignorance, but would this likely come from Ceph code or a
> > hardware issue of some kind, such as a disk drive?  I have reached out to
> > RedHat and Ceph community on that as well.
>
> More likely a kernel bug somewhere in the page cache or memory
> reclaim paths. The issue is that we only notice the problem long
> after it has occurred. i.e. when XFS goes to tear down the page it has
> been handed, the page is already in a bad state and so it doesn't
> really tell us anything about the cause of the problem.
>
> Realisticaly, we need a script that reproduces the problem (that
> doesn't require a Ceph cluster) to be able to isolate the cause.
> In the mean time, you can always try running  CONFIG_XFS_WARN=y to
> see if that catches problems earlier, and you might also want to do
> things like turn on memory poisoning and other kernel debugging
> options to try to isolate the cause of the issue....
>

We have been error free for almost 3 weeks now with these changes:

vm.swappiness=1
vm.min_free_kbytes=262144

I wonder if this is related to us using high speed Areca HBAs with RAM
writeback cache and having had vm.swappiness=0 previously.  POssibly the
HBA handing down a large chunk of IO very fast and page cache not being to
handle it with swappiness=0.  I will keep monitoring, but thank you very
much for the analysis and info.

Alex



>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001a113f8eb6a41018051b75d5fd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Dave,<div class=3D"gmail_extra"><br><div class=3D"gmail=
_quote">On Mon, Jul 6, 2015 at 8:35 PM, Dave Chinner <span dir=3D"ltr">&lt;=
<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.co=
m</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margi=
n:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204=
);border-left-style:solid;padding-left:1ex">On Mon, Jul 06, 2015 at 03:20:1=
9PM -0400, Alex Gorbachev wrote:<br>
<span>&gt; On Sun, Jul 5, 2015 at 7:24 PM, Dave Chinner &lt;<a href=3D"mail=
to:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt; wrote=
:<br>
&gt; &gt; On Sun, Jul 05, 2015 at 12:25:47AM -0400, Alex Gorbachev wrote:<b=
r>
&gt; &gt; &gt; &gt; &gt; sysctl vm.swappiness=3D20 (can probably be 1 as pe=
r article)<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; sysctl vm.min_free_kbytes=3D262144<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; [...]<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; We have experienced the problem in various guises with kerne=
ls 3.14,<br>
&gt; &gt; 3.19,<br>
&gt; &gt; &gt; 4.1-rc2 and now 4.1, so it&#39;s not new to us, just differe=
nt error stack.<br>
&gt; &gt; &gt; Below are some other stack dumps of what manifested as the s=
ame error.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;=C2=A0 [&lt;ffffffff817cf4b9&gt;] schedule+0x29/0x70<br>
&gt; &gt; &gt;=C2=A0 [&lt;ffffffffc07caee7&gt;] _xfs_log_force+0x187/0x280 =
[xfs]<br>
&gt; &gt; &gt;=C2=A0 [&lt;ffffffff810a4150&gt;] ? try_to_wake_up+0x2a0/0x2a=
0<br>
&gt; &gt; &gt;=C2=A0 [&lt;ffffffffc07cb019&gt;] xfs_log_force+0x39/0xc0 [xf=
s]<br>
&gt; &gt; &gt;=C2=A0 [&lt;ffffffffc07d6542&gt;] xfsaild_push+0x552/0x5a0 [x=
fs]<br>
&gt; &gt; &gt;=C2=A0 [&lt;ffffffff817d2264&gt;] ? schedule_timeout+0x124/0x=
210<br>
&gt; &gt; &gt;=C2=A0 [&lt;ffffffffc07d662f&gt;] xfsaild+0x9f/0x140 [xfs]<br=
>
&gt; &gt; &gt;=C2=A0 [&lt;ffffffffc07d6590&gt;] ? xfsaild_push+0x5a0/0x5a0 =
[xfs]<br>
&gt; &gt; &gt;=C2=A0 [&lt;ffffffff81095e29&gt;] kthread+0xc9/0xe0<br>
&gt; &gt; &gt;=C2=A0 [&lt;ffffffff81095d60&gt;] ? flush_kthread_worker+0x90=
/0x90<br>
&gt; &gt; &gt;=C2=A0 [&lt;ffffffff817d3718&gt;] ret_from_fork+0x58/0x90<br>
&gt; &gt; &gt;=C2=A0 [&lt;ffffffff81095d60&gt;] ? flush_kthread_worker+0x90=
/0x90<br>
&gt; &gt; &gt;=C2=A0 INFO: task xfsaild/sdg1:2606 blocked for more than 120=
 seconds.<br>
</span>&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 Not tainted <a href=3D"tel=
:3.19.4-031904" value=3D"+13194031904" target=3D"_blank">3.19.4-031904</a>-=
generic #201504131440<br>
<span>&gt; &gt; &gt;=C2=A0 &quot;echo 0 &gt; /proc/sys/kernel/hung_task_tim=
eout_secs&quot; disables this<br>
&gt; &gt; message.<br>
&gt; &gt;<br>
&gt; &gt; That&#39;s indicative of IO completion problems, but not a crash.=
<br>
&gt; &gt;<br>
&gt; &gt; &gt;=C2=A0 BUG: unable to handle kernel NULL pointer dereference =
at<br>
&gt; &gt;=C2=A0 (null)<br>
&gt; &gt; &gt;=C2=A0 IP: [&lt;ffffffffc04be80f&gt;] xfs_count_page_state+0x=
3f/0x70 [xfs]<br>
&gt; &gt; ....<br>
&gt; &gt; &gt;=C2=A0 =C2=A0[&lt;ffffffffc04be880&gt;] xfs_vm_releasepage+0x=
40/0x120 [xfs]<br>
&gt; &gt; &gt;=C2=A0 =C2=A0[&lt;ffffffff8118a7d2&gt;] try_to_release_page+0=
x32/0x50<br>
&gt; &gt; &gt;=C2=A0 =C2=A0[&lt;ffffffff8119fe6d&gt;] shrink_page_list+0x69=
d/0x720<br>
&gt; &gt; &gt;=C2=A0 =C2=A0[&lt;ffffffff811a058d&gt;] shrink_inactive_list+=
0x1dd/0x5d0<br>
&gt; &gt; ....<br>
&gt; &gt;<br>
&gt; &gt; Again, this is indicative of a page cache issue: a page without<b=
r>
&gt; &gt; buffers has been passed to xfs_vm_releasepage(), which implies th=
e<br>
&gt; &gt; page flags are not correct. i.e PAGE_FLAGS_PRIVATE is set but<br>
&gt; &gt; page-&gt;private is null...<br>
&gt; &gt;<br>
&gt; &gt; Again, this is unlikely to be an XFS issue.<br>
&gt; &gt;<br>
&gt;<br>
&gt; Sorry for my ignorance, but would this likely come from Ceph code or a=
<br>
&gt; hardware issue of some kind, such as a disk drive?=C2=A0 I have reache=
d out to<br>
&gt; RedHat and Ceph community on that as well.<br>
<br>
</span>More likely a kernel bug somewhere in the page cache or memory<br>
reclaim paths. The issue is that we only notice the problem long<br>
after it has occurred. i.e. when XFS goes to tear down the page it has<br>
been handed, the page is already in a bad state and so it doesn&#39;t<br>
really tell us anything about the cause of the problem.<br>
<br>
Realisticaly, we need a script that reproduces the problem (that<br>
doesn&#39;t require a Ceph cluster) to be able to isolate the cause.<br>
In the mean time, you can always try running=C2=A0 CONFIG_XFS_WARN=3Dy to<b=
r>
see if that catches problems earlier, and you might also want to do<br>
things like turn on memory poisoning and other kernel debugging<br>
options to try to isolate the cause of the issue....<br></blockquote><div><=
br></div><div>We have been error free for almost 3 weeks now with these cha=
nges:</div><div><br></div><div><div style=3D"font-size:12.8000001907349px">=
vm.swappiness=3D1</div><div style=3D"font-size:12.8000001907349px">vm.min_f=
ree_kbytes=3D262144</div></div><div style=3D"font-size:12.8000001907349px">=
<br></div><div style=3D"font-size:12.8000001907349px">I wonder if this is r=
elated to us using high speed Areca HBAs with RAM writeback cache and havin=
g had vm.swappiness=3D0 previously.=C2=A0 POssibly the HBA handing down a l=
arge chunk of IO very fast and page cache not being to handle it with swapp=
iness=3D0.=C2=A0 I will keep monitoring, but thank you very much for the an=
alysis and info.</div><div style=3D"font-size:12.8000001907349px"><br></div=
><div style=3D"font-size:12.8000001907349px">Alex</div><div><br></div><div>=
=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0=
.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-left-s=
tyle:solid;padding-left:1ex">
<span><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
</span><a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromo=
rbit.com</a><br>
</blockquote></div><br></div></div>

--001a113f8eb6a41018051b75d5fd--


--===============2804397914870347393==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2804397914870347393==--

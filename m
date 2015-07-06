Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A92817F54
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 14:20:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 87D2F3040DE
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 12:20:22 -0700 (PDT)
Received: from mail-ig0-f176.google.com (mail-ig0-f176.google.com
	[209.85.213.176]) by cuda.sgi.com with ESMTP id
	VBfG9Awcl29ANP5Q (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Jul 2015 12:20:20 -0700 (PDT)
Received: by igcqs7 with SMTP id qs7so17262037igc.0
	for <xfs@oss.sgi.com>; Mon, 06 Jul 2015 12:20:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150705232443.GA3902@dastard>
References: <CADb9451tB71D3XCqcOkDxzpzbdEHqwj7XCZUpL8yg1DzYbpwBw@mail.gmail.com>
	<20150703235141.GQ7943@dastard>
	<CADb9451j0WEeL4m-fEHzrOf3ys+eSHJKNzcN9oHAOs2kDLL_kQ@mail.gmail.com>
	<20150704233802.GS7943@dastard>
	<CADb9452UYPqo_i2M=-sSwPKwqUrRSMJ4bhV10S=1k0sNCKCVfg@mail.gmail.com>
	<20150705232443.GA3902@dastard>
Date: Mon, 6 Jul 2015 15:20:19 -0400
Message-ID: <CADb9453iT7+2zgKDqY7gpHGjQ6nayqQFES1AJHn0G2FMFjYX-A@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============3581923235794988827=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============3581923235794988827==
Content-Type: multipart/alternative; boundary=001a11c2c4cae3fa7e051a39cbba

--001a11c2c4cae3fa7e051a39cbba
Content-Type: text/plain; charset=UTF-8

Thank you Dave,

On Sun, Jul 5, 2015 at 7:24 PM, Dave Chinner <david@fromorbit.com> wrote:

> [ Please turn off line wrap when pasting kernel traces ]
>

Noted, sorry, I thought wrap was off, but Google must have it on by default.


>
> On Sun, Jul 05, 2015 at 12:25:47AM -0400, Alex Gorbachev wrote:
> > > > sysctl vm.swappiness=20 (can probably be 1 as per article)
> > > >
> > > > sysctl vm.min_free_kbytes=262144
> > >
> [...]
> >
> > We have experienced the problem in various guises with kernels 3.14,
> 3.19,
> > 4.1-rc2 and now 4.1, so it's not new to us, just different error stack.
> > Below are some other stack dumps of what manifested as the same error.
> >
> >  [<ffffffff817cf4b9>] schedule+0x29/0x70
> >  [<ffffffffc07caee7>] _xfs_log_force+0x187/0x280 [xfs]
> >  [<ffffffff810a4150>] ? try_to_wake_up+0x2a0/0x2a0
> >  [<ffffffffc07cb019>] xfs_log_force+0x39/0xc0 [xfs]
> >  [<ffffffffc07d6542>] xfsaild_push+0x552/0x5a0 [xfs]
> >  [<ffffffff817d2264>] ? schedule_timeout+0x124/0x210
> >  [<ffffffffc07d662f>] xfsaild+0x9f/0x140 [xfs]
> >  [<ffffffffc07d6590>] ? xfsaild_push+0x5a0/0x5a0 [xfs]
> >  [<ffffffff81095e29>] kthread+0xc9/0xe0
> >  [<ffffffff81095d60>] ? flush_kthread_worker+0x90/0x90
> >  [<ffffffff817d3718>] ret_from_fork+0x58/0x90
> >  [<ffffffff81095d60>] ? flush_kthread_worker+0x90/0x90
> >  INFO: task xfsaild/sdg1:2606 blocked for more than 120 seconds.
> >        Not tainted 3.19.4-031904-generic #201504131440
> >  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message.
>
> That's indicative of IO completion problems, but not a crash.
>
> >  BUG: unable to handle kernel NULL pointer dereference at
>  (null)
> >  IP: [<ffffffffc04be80f>] xfs_count_page_state+0x3f/0x70 [xfs]
> ....
> >   [<ffffffffc04be880>] xfs_vm_releasepage+0x40/0x120 [xfs]
> >   [<ffffffff8118a7d2>] try_to_release_page+0x32/0x50
> >   [<ffffffff8119fe6d>] shrink_page_list+0x69d/0x720
> >   [<ffffffff811a058d>] shrink_inactive_list+0x1dd/0x5d0
> ....
>
> Again, this is indicative of a page cache issue: a page without
> buffers has been passed to xfs_vm_releasepage(), which implies the
> page flags are not correct. i.e PAGE_FLAGS_PRIVATE is set but
> page->private is null...
>
> Again, this is unlikely to be an XFS issue.
>

Sorry for my ignorance, but would this likely come from Ceph code or a
hardware issue of some kind, such as a disk drive?  I have reached out to
RedHat and Ceph community on that as well.

Thank you,
Alex



>
> > Do you think we need to look at RAM handling by this Supermicro machine
> > type?
>
> Not sure what you mean by that. Problems like this can be caused by
> bad hardware, but it's unusual for a machine using ECC memory to
> have undetected RAM problems...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001a11c2c4cae3fa7e051a39cbba
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thank you Dave,<div class=3D"gmail_extra"><br><div class=
=3D"gmail_quote">On Sun, Jul 5, 2015 at 7:24 PM, Dave Chinner <span dir=3D"=
ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fro=
morbit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">[ Please=
 turn off line wrap when pasting kernel traces ]<br></blockquote><div><br><=
/div><div>Noted, sorry, I thought wrap was off, but Google must have it on =
by default.</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<span class=3D""><br>
On Sun, Jul 05, 2015 at 12:25:47AM -0400, Alex Gorbachev wrote:<br>
&gt; &gt; &gt; sysctl vm.swappiness=3D20 (can probably be 1 as per article)=
<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; sysctl vm.min_free_kbytes=3D262144<br>
&gt; &gt;<br>[...]<br>
&gt;<br>
&gt; We have experienced the problem in various guises with kernels 3.14, 3=
.19,<br>
&gt; 4.1-rc2 and now 4.1, so it&#39;s not new to us, just different error s=
tack.<br>
&gt; Below are some other stack dumps of what manifested as the same error.=
<br>
&gt;<br>
</span>&gt;=C2=A0 [&lt;ffffffff817cf4b9&gt;] schedule+0x29/0x70<br>
&gt;=C2=A0 [&lt;ffffffffc07caee7&gt;] _xfs_log_force+0x187/0x280 [xfs]<br>
&gt;=C2=A0 [&lt;ffffffff810a4150&gt;] ? try_to_wake_up+0x2a0/0x2a0<br>
&gt;=C2=A0 [&lt;ffffffffc07cb019&gt;] xfs_log_force+0x39/0xc0 [xfs]<br>
&gt;=C2=A0 [&lt;ffffffffc07d6542&gt;] xfsaild_push+0x552/0x5a0 [xfs]<br>
&gt;=C2=A0 [&lt;ffffffff817d2264&gt;] ? schedule_timeout+0x124/0x210<br>
&gt;=C2=A0 [&lt;ffffffffc07d662f&gt;] xfsaild+0x9f/0x140 [xfs]<br>
&gt;=C2=A0 [&lt;ffffffffc07d6590&gt;] ? xfsaild_push+0x5a0/0x5a0 [xfs]<br>
&gt;=C2=A0 [&lt;ffffffff81095e29&gt;] kthread+0xc9/0xe0<br>
&gt;=C2=A0 [&lt;ffffffff81095d60&gt;] ? flush_kthread_worker+0x90/0x90<br>
&gt;=C2=A0 [&lt;ffffffff817d3718&gt;] ret_from_fork+0x58/0x90<br>
&gt;=C2=A0 [&lt;ffffffff81095d60&gt;] ? flush_kthread_worker+0x90/0x90<br>
<span class=3D"">&gt;=C2=A0 INFO: task xfsaild/sdg1:2606 blocked for more t=
han 120 seconds.<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 Not tainted <a href=3D"tel:3.19.4-03=
1904" value=3D"+13194031904">3.19.4-031904</a>-generic #201504131440<br>
<span class=3D"">&gt;=C2=A0 &quot;echo 0 &gt; /proc/sys/kernel/hung_task_ti=
meout_secs&quot; disables this message.<br>
<br>
</span>That&#39;s indicative of IO completion problems, but not a crash.<br=
>
<span class=3D""><br>
&gt;=C2=A0 BUG: unable to handle kernel NULL pointer dereference at=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(null)<br>
</span>&gt;=C2=A0 IP: [&lt;ffffffffc04be80f&gt;] xfs_count_page_state+0x3f/=
0x70 [xfs]<br>
....<br>
&gt;=C2=A0 =C2=A0[&lt;ffffffffc04be880&gt;] xfs_vm_releasepage+0x40/0x120 [=
xfs]<br>
&gt;=C2=A0 =C2=A0[&lt;ffffffff8118a7d2&gt;] try_to_release_page+0x32/0x50<b=
r>
&gt;=C2=A0 =C2=A0[&lt;ffffffff8119fe6d&gt;] shrink_page_list+0x69d/0x720<br=
>
&gt;=C2=A0 =C2=A0[&lt;ffffffff811a058d&gt;] shrink_inactive_list+0x1dd/0x5d=
0<br>
....<br>
<br>
Again, this is indicative of a page cache issue: a page without<br>
buffers has been passed to xfs_vm_releasepage(), which implies the<br>
page flags are not correct. i.e PAGE_FLAGS_PRIVATE is set but<br>
page-&gt;private is null...<br>
<br>
Again, this is unlikely to be an XFS issue.<br></blockquote><div><br></div>=
<div>Sorry for my ignorance, but would this likely come from Ceph code or a=
 hardware issue of some kind, such as a disk drive?=C2=A0 I have reached ou=
t to RedHat and Ceph community on that as well.</div><div><br></div><div>Th=
ank you,</div><div>Alex</div><div><br></div><div>=C2=A0</div><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;p=
adding-left:1ex">
<span class=3D""><br>
&gt; Do you think we need to look at RAM handling by this Supermicro machin=
e<br>
&gt; type?<br>
<br>
</span>Not sure what you mean by that. Problems like this can be caused by<=
br>
bad hardware, but it&#39;s unusual for a machine using ECC memory to<br>
have undetected RAM problems...<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div></div>

--001a11c2c4cae3fa7e051a39cbba--


--===============3581923235794988827==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3581923235794988827==--

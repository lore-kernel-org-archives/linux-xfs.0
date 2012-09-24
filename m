Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8OCnmFs144964 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 07:49:48 -0500
Received: from mail-vc0-f181.google.com (mail-vc0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	1HbUEJ6NTlNw3jm7 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Sep 2012 05:51:03 -0700 (PDT)
Received: by vchn11 with SMTP id n11so6381522vch.26
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 05:51:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120924075551.GF20960@dastard>
References: <CAHt31_9K_vrzoqwSVsz-6VNVmMUzMyGCFEZfviRV-xPcUqv8-w@mail.gmail.com>
	<505BF45D.5050909@sandeen.net> <20120924075551.GF20960@dastard>
Date: Mon, 24 Sep 2012 06:51:03 -0600
Message-ID: <CAHt31_8rEc93vpnbbKngY4uS0kAct3Z5A+2G0LmBzv5rWKdSfA@mail.gmail.com>
Subject: Re: xfs_repair deleting realtime files.
From: Anand Tiwari <tiwarikanand@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6404597985959001559=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--===============6404597985959001559==
Content-Type: multipart/alternative; boundary=bcaec5015e8bd3754104ca720af9

--bcaec5015e8bd3754104ca720af9
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Sep 24, 2012 at 1:55 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Sep 21, 2012 at 12:00:13AM -0500, Eric Sandeen wrote:
> > On 9/20/12 7:40 PM, Anand Tiwari wrote:
> > > Hi All,
> > >
> > > I have been looking into an issue with xfs_repair with realtime sub
> volume. some times while running xfs_repair I see following errors
> > >
> > > ----------------------------
> > > data fork in rt inode 134 claims used rt block 19607
> > > bad data fork in inode 134
> > > would have cleared inode 134
> > > data fork in rt inode 135 claims used rt block 29607
> > > bad data fork in inode 135
> > > would have cleared inode 135
> .....
> > > xfs_db> inode 135
> > > xfs_db> bmap
> > > data offset 0 startblock 13062144 (12/479232) count 2097000 flag 0
> > > data offset 2097000 startblock 15159144 (14/479080) count 2097000 flag
> 0
> > > data offset 4194000 startblock 17256144 (16/478928) count 2097000 flag
> 0
> > > data offset 6291000 startblock 19353144 (18/478776) count 2097000 flag
> 0
> > > data offset 8388000 startblock 21450144 (20/478624) count 2097000 flag
> 0
> > > data offset 10485000 startblock 23547144 (22/478472) count 2097000
> flag 0
> > > data offset 12582000 startblock 25644144 (24/478320) count 2097000
> flag 0
> > > data offset 14679000 startblock 27741144 (26/478168) count 2097000
> flag 0
> > > data offset 16776000 startblock 29838144 (28/478016) count 2097000
> flag 0
> > > data offset 18873000 startblock 31935144 (30/477864) count 1607000
> flag 0
> > > xfs_db> inode 134
> > > xfs_db> bmap
> > > data offset 0 startblock 7942144 (7/602112) count 2097000 flag 0
> > > data offset 2097000 startblock 10039144 (9/601960) count 2097000 flag 0
> > > data offset 4194000 startblock 12136144 (11/601808) count 926000 flag 0
> >
> > It's been a while since I thought about realtime, but -
> >
> > That all seems fine, I don't see anything overlapping there, they are
> > all perfectly adjacent, though of interesting size.
>
> Yeah, the size is the problem.
>
> ....
> > Every extent above is length 2097000 blocks, and they are adjacent.
> > But you say your realtime extent size is 512 blocks ... which doesn't go
> > into 2097000 evenly.   So that's odd, at least.
>
> Once you realise that the bmapbt is recording multiples of FSB (4k)
> rather than rtextsz (2MB), it becomes more obvious what the problem
> is: rounding of the extent size at MAXEXTLEN - 2097000 is only 152
> blocks short of 2^21 (2097152).
>
> I haven't looked at the kernel code yet to work out why it is
> rounding to a non-rtextsz multiple, but that is the source of the
> problem.
>
> The repair code is detecting that extents are not of the
> correct granularity, but the error message indicates that this was
> only ever expected for duplicate blocks occurring rather than a
> kernel bug. So "fixing repair" is not what is needd here - finding
> and fixing the kernel bug is what you shoul be looking at.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>


thanks, I started looking at allocator code and and will report if see
something

--bcaec5015e8bd3754104ca720af9
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Mon, Sep 24, 2012 at 1:55 AM, Dave Ch=
inner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=
=3D"_blank">david@fromorbit.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
<div class=3D"im">On Fri, Sep 21, 2012 at 12:00:13AM -0500, Eric Sandeen wr=
ote:<br>
&gt; On 9/20/12 7:40 PM, Anand Tiwari wrote:<br>
&gt; &gt; Hi All,<br>
&gt; &gt;<br>
&gt; &gt; I have been looking into an issue with xfs_repair with realtime s=
ub volume. some times while running xfs_repair I see following errors<br>
&gt; &gt;<br>
&gt; &gt; ----------------------------<br>
&gt; &gt; data fork in rt inode 134 claims used rt block 19607<br>
&gt; &gt; bad data fork in inode 134<br>
&gt; &gt; would have cleared inode 134<br>
&gt; &gt; data fork in rt inode 135 claims used rt block 29607<br>
&gt; &gt; bad data fork in inode 135<br>
&gt; &gt; would have cleared inode 135<br>
</div>.....<br>
<div class=3D"im">&gt; &gt; xfs_db&gt; inode 135<br>
&gt; &gt; xfs_db&gt; bmap<br>
&gt; &gt; data offset 0 startblock 13062144 (12/479232) count 2097000 flag =
0<br>
&gt; &gt; data offset 2097000 startblock 15159144 (14/479080) count 2097000=
 flag 0<br>
&gt; &gt; data offset 4194000 startblock 17256144 (16/478928) count 2097000=
 flag 0<br>
&gt; &gt; data offset 6291000 startblock 19353144 (18/478776) count 2097000=
 flag 0<br>
&gt; &gt; data offset 8388000 startblock 21450144 (20/478624) count 2097000=
 flag 0<br>
&gt; &gt; data offset 10485000 startblock 23547144 (22/478472) count 209700=
0 flag 0<br>
&gt; &gt; data offset 12582000 startblock 25644144 (24/478320) count 209700=
0 flag 0<br>
&gt; &gt; data offset 14679000 startblock 27741144 (26/478168) count 209700=
0 flag 0<br>
&gt; &gt; data offset 16776000 startblock 29838144 (28/478016) count 209700=
0 flag 0<br>
&gt; &gt; data offset 18873000 startblock 31935144 (30/477864) count 160700=
0 flag 0<br>
&gt; &gt; xfs_db&gt; inode 134<br>
&gt; &gt; xfs_db&gt; bmap<br>
&gt; &gt; data offset 0 startblock 7942144 (7/602112) count 2097000 flag 0<=
br>
&gt; &gt; data offset 2097000 startblock 10039144 (9/601960) count 2097000 =
flag 0<br>
&gt; &gt; data offset 4194000 startblock 12136144 (11/601808) count 926000 =
flag 0<br>
&gt;<br>
&gt; It&#39;s been a while since I thought about realtime, but -<br>
&gt;<br>
&gt; That all seems fine, I don&#39;t see anything overlapping there, they =
are<br>
&gt; all perfectly adjacent, though of interesting size.<br>
<br>
</div>Yeah, the size is the problem.<br>
<br>
....<br>
<div class=3D"im">&gt; Every extent above is length 2097000 blocks, and the=
y are adjacent.<br>
&gt; But you say your realtime extent size is 512 blocks ... which doesn&#3=
9;t go<br>
&gt; into 2097000 evenly. =A0 So that&#39;s odd, at least.<br>
<br>
</div>Once you realise that the bmapbt is recording multiples of FSB (4k)<b=
r>
rather than rtextsz (2MB), it becomes more obvious what the problem<br>
is: rounding of the extent size at MAXEXTLEN - 2097000 is only 152<br>
blocks short of 2^21 (2097152).<br>
<br>
I haven&#39;t looked at the kernel code yet to work out why it is<br>
rounding to a non-rtextsz multiple, but that is the source of the<br>
problem.<br>
<br>
The repair code is detecting that extents are not of the<br>
correct granularity, but the error message indicates that this was<br>
only ever expected for duplicate blocks occurring rather than a<br>
kernel bug. So &quot;fixing repair&quot; is not what is needd here - findin=
g<br>
and fixing the kernel bug is what you shoul be looking at.<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br><div><br></div><div>thanks, I started =
looking at allocator code and and will report if see something=A0</div>

--bcaec5015e8bd3754104ca720af9--


--===============6404597985959001559==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6404597985959001559==--

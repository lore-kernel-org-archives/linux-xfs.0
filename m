Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8Q1PGvi128187 for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 20:25:16 -0500
Received: from mail-vb0-f46.google.com (mail-vb0-f46.google.com
	[209.85.212.46]) by cuda.sgi.com with ESMTP id W7j0CQQcCWOxM2Qw
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 25 Sep 2012 18:26:33 -0700 (PDT)
Received: by vbbff1 with SMTP id ff1so80194vbb.5
	for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 18:26:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHt31_8rEc93vpnbbKngY4uS0kAct3Z5A+2G0LmBzv5rWKdSfA@mail.gmail.com>
References: <CAHt31_9K_vrzoqwSVsz-6VNVmMUzMyGCFEZfviRV-xPcUqv8-w@mail.gmail.com>
	<505BF45D.5050909@sandeen.net> <20120924075551.GF20960@dastard>
	<CAHt31_8rEc93vpnbbKngY4uS0kAct3Z5A+2G0LmBzv5rWKdSfA@mail.gmail.com>
Date: Tue, 25 Sep 2012 19:26:32 -0600
Message-ID: <CAHt31__s2TNhXPa9JfDLdWPqr60Te9VDPKb4ieORF8JAL07YmQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============6802240741703706942=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--===============6802240741703706942==
Content-Type: multipart/alternative; boundary=20cf307ca01c80176e04ca90b600

--20cf307ca01c80176e04ca90b600
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Sep 24, 2012 at 6:51 AM, Anand Tiwari <tiwarikanand@gmail.com>wrote:

>
>
> On Mon, Sep 24, 2012 at 1:55 AM, Dave Chinner <david@fromorbit.com> wrote:
>
>> On Fri, Sep 21, 2012 at 12:00:13AM -0500, Eric Sandeen wrote:
>> > On 9/20/12 7:40 PM, Anand Tiwari wrote:
>> > > Hi All,
>> > >
>> > > I have been looking into an issue with xfs_repair with realtime sub
>> volume. some times while running xfs_repair I see following errors
>> > >
>> > > ----------------------------
>> > > data fork in rt inode 134 claims used rt block 19607
>> > > bad data fork in inode 134
>> > > would have cleared inode 134
>> > > data fork in rt inode 135 claims used rt block 29607
>> > > bad data fork in inode 135
>> > > would have cleared inode 135
>> .....
>> > > xfs_db> inode 135
>> > > xfs_db> bmap
>> > > data offset 0 startblock 13062144 (12/479232) count 2097000 flag 0
>> > > data offset 2097000 startblock 15159144 (14/479080) count 2097000
>> flag 0
>> > > data offset 4194000 startblock 17256144 (16/478928) count 2097000
>> flag 0
>> > > data offset 6291000 startblock 19353144 (18/478776) count 2097000
>> flag 0
>> > > data offset 8388000 startblock 21450144 (20/478624) count 2097000
>> flag 0
>> > > data offset 10485000 startblock 23547144 (22/478472) count 2097000
>> flag 0
>> > > data offset 12582000 startblock 25644144 (24/478320) count 2097000
>> flag 0
>> > > data offset 14679000 startblock 27741144 (26/478168) count 2097000
>> flag 0
>> > > data offset 16776000 startblock 29838144 (28/478016) count 2097000
>> flag 0
>> > > data offset 18873000 startblock 31935144 (30/477864) count 1607000
>> flag 0
>> > > xfs_db> inode 134
>> > > xfs_db> bmap
>> > > data offset 0 startblock 7942144 (7/602112) count 2097000 flag 0
>> > > data offset 2097000 startblock 10039144 (9/601960) count 2097000 flag
>> 0
>> > > data offset 4194000 startblock 12136144 (11/601808) count 926000 flag
>> 0
>> >
>> > It's been a while since I thought about realtime, but -
>> >
>> > That all seems fine, I don't see anything overlapping there, they are
>> > all perfectly adjacent, though of interesting size.
>>
>> Yeah, the size is the problem.
>>
>> ....
>> > Every extent above is length 2097000 blocks, and they are adjacent.
>> > But you say your realtime extent size is 512 blocks ... which doesn't go
>> > into 2097000 evenly.   So that's odd, at least.
>>
>> Once you realise that the bmapbt is recording multiples of FSB (4k)
>> rather than rtextsz (2MB), it becomes more obvious what the problem
>> is: rounding of the extent size at MAXEXTLEN - 2097000 is only 152
>> blocks short of 2^21 (2097152).
>>
>> I haven't looked at the kernel code yet to work out why it is
>> rounding to a non-rtextsz multiple, but that is the source of the
>> problem.
>>
>> The repair code is detecting that extents are not of the
>> correct granularity, but the error message indicates that this was
>> only ever expected for duplicate blocks occurring rather than a
>> kernel bug. So "fixing repair" is not what is needd here - finding
>> and fixing the kernel bug is what you shoul be looking at.
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>>
>
>
> thanks, I started looking at allocator code and and will report if see
> something
>


I think this is what happening.  If we have following conditions,
  1) we have more than 8gb contiguous space available to allocate. ( i.e.
more than 2^21 4k blocks)
  2) only one file is open for writing in real-time volume.

To satisfy first condition, I just took empty file-system.

Now lets start allocating, lets say in chucks of 25000, realtime allocator
will have no problem allocating "exact" block while searching forward.
xfs_rtfind_forw(). It will allocate 49 "real-time extents", where the 49th
"real-time extent" is partially full.  (25000/512 = 48)

everything is fine for first 83 allocations, as we were able to grow the
extent. Now we have 2075000 (25000*83) blocks in first extent ie 4053
"real-time extents" (where last "real-time extent" is partially full).

for 84th allocation, real-time allocator will allocate another 49
"real-time extents" as it does not know about maximum extent size, but we
can not grow the extent in xfs_bmap_add_extent_unwritten_real().  so we
insert a new extent (case BMAP_LEFT_FILLING).  now the new extent starts
from 2075000, which is not aligned with rextsize (512 in this case).

To fix this, I see two options,
1) fix real-time allocator and teach it about maximum extent size.
2) for real-time files, aligned new extent before inserting.

In my opinion, we should not worry about either of above, as this looks
good method for allocation.  I can fix xfs_repair tool and make it aware of
these conditions ("real-time extents" shared by two or more extents).

Let me know what you guys think,

anand

--20cf307ca01c80176e04ca90b600
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Mon, Sep 24, 2012 at 6:51 AM, Anand T=
iwari <span dir=3D"ltr">&lt;<a href=3D"mailto:tiwarikanand@gmail.com" targe=
t=3D"_blank">tiwarikanand@gmail.com</a>&gt;</span> wrote:<br><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;p=
adding-left:1ex">
<div class=3D"HOEnZb"><div class=3D"h5"><br><br><div class=3D"gmail_quote">=
On Mon, Sep 24, 2012 at 1:55 AM, Dave Chinner <span dir=3D"ltr">&lt;<a href=
=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&g=
t;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<div>On Fri, Sep 21, 2012 at 12:00:13AM -0500, Eric Sandeen wrote:<br>
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
<div>&gt; &gt; xfs_db&gt; inode 135<br>
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
<div>&gt; Every extent above is length 2097000 blocks, and they are adjacen=
t.<br>
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
<span><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.co=
m</a><br>
</font></span></blockquote></div><br><div><br></div></div></div><div>thanks=
, I started looking at allocator code and and will report if see something=
=A0</div>
</blockquote></div><br><br>I think this is what happening.=A0 If we have fo=
llowing conditions,<br>=A0 1) we have more than 8gb contiguous space availa=
ble to allocate. ( i.e. more than 2^21 4k blocks)<br>=A0 2) only one file i=
s open for writing in real-time volume.<br>
<br>To satisfy first condition, I just took empty file-system.<br><br>Now l=
ets start allocating, lets say in chucks of 25000, realtime allocator will =
have no problem allocating &quot;exact&quot; block while searching forward.=
<br>
xfs_rtfind_forw(). It will allocate 49 &quot;real-time extents&quot;, where=
 the 49th &quot;real-time extent&quot; is partially full.=A0 (25000/512 =3D=
 48)<br><br>everything is fine for first 83 allocations, as we were able to=
 grow the extent. Now we have 2075000 (25000*83) blocks in first extent ie =
4053 &quot;real-time extents&quot; (where last &quot;real-time extent&quot;=
 is partially full).<br>
<br>for 84th allocation, real-time allocator will allocate another 49 &quot=
;real-time extents&quot; as it does not know about maximum extent size, but=
 we can not grow the extent in xfs_bmap_add_extent_unwritten_real().=A0 so =
we insert a new extent (case BMAP_LEFT_FILLING).=A0 now the new extent star=
ts from 2075000, which is not aligned with rextsize (512 in this case).<br>
<br>To fix this, I see two options,<br>1) fix real-time allocator and teach=
 it about maximum extent size.<br>2) for real-time files, aligned new exten=
t before inserting.<br><br>In my opinion, we should not worry about either =
of above, as this looks good method for allocation.=A0 I can fix xfs_repair=
 tool and make it aware of these conditions (&quot;real-time extents&quot; =
shared by two or more extents). <br>
<br>Let me know what you guys think, <br><br>anand<br><br>

--20cf307ca01c80176e04ca90b600--


--===============6802240741703706942==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6802240741703706942==--

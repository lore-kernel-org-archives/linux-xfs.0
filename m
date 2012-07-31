Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6VN1GBP222125 for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 18:01:16 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	zkdlVyZBLZvNGaNo (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 31 Jul 2012 16:01:14 -0700 (PDT)
Received: by obbup19 with SMTP id up19so12340051obb.26
	for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 16:01:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGou9MheeBWxajd65szNfDB2L+VVoZ7SypEdUKj7np3L0H8fHA@mail.gmail.com>
References: <CAGou9MgezsS=2+SngGWBJv5Npsuqacx1VPJwvMuf0FS+XnXt8A@mail.gmail.com>
	<20120730030333.GE2877@dastard>
	<CAGou9MheeBWxajd65szNfDB2L+VVoZ7SypEdUKj7np3L0H8fHA@mail.gmail.com>
Date: Tue, 31 Jul 2012 16:01:13 -0700
Message-ID: <CAGou9MgMHbTPebFUDXdyLvrUr4T9wo-geNtaPUft9uUmOaju6Q@mail.gmail.com>
Subject: realtime section bugs still around
From: Jason Newton <nevion@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3710755711546744011=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

--===============3710755711546744011==
Content-Type: multipart/alternative; boundary=e89a8fb20322abf0bd04c62827c4

--e89a8fb20322abf0bd04c62827c4
Content-Type: text/plain; charset=UTF-8

On Sun, Jul 29, 2012 at 8:03 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Jul 27, 2012 at 01:14:17AM -0700, Jason Newton wrote:
> > Hi,
> >
> > I think the following bug is still around:
> >
> > http://oss.sgi.com/archives/xfs/2011-11/msg00179.html
> >
> > I get the same stack trace.
>
> Not surprising, I doubt anyone has looked at it much. Indeed,
> xfs/090 assert fails immediately in the rt allocator for me....
>
> > There's another report out there somewhere
> > with another similar stack trace.  I know the realtime code is not
> > maintained so much but it seems to be a waste to let it fall out of
> > maintenance when it's the only thing on linux that seems to fill the
> > realtime io niche.
>
> The XFS "realtime" device has nothing to do with "realtime IO".
>
> If anything, it's probably much worse at "realtime IO" than the
> normal data device, especially at scale, because it is bitmap rather
> than btree based. And it is single threaded.
>
> That's why it really isn't maintained - the data device is as good
> or better in RT workloads as the "realtime" device....
>

This wasn't expected, thanks for the clarifications.   What was the
original point of RT files?

>
> > So this email is mainly about the null pointer deref on the spinlock in
> > _xfs_buf_find on realtime files, but I figure I might also ask a few more
> > questions.
> >
> > What kind of differences should one expect between GRIO and realtime
> files?
>
> Linux doesn't support GRIO. It's an Irix only thing, and that
> required special hardware support for bandwidth reservation, special
> frame schedulers in the IO path, etc. The XFS realtime device was
> just one part of the whole GRIO framework. Anyway, if you don't have
> 15 year old SGI hardware you can't use GRIO.
>
> If you are talking about GRIOv2, then, well, you aren't running
> CXFS...
>
> > What kind of on latencies of writes should one expect for realtime files
> vs
> > normal?
>
> How long is a piece of string?
>
Well, I had meant with say one block of io.


>
> > raw video to disk (3 high res 10bit video streams, 5.7MB per frame, at
> 20hz
> > so effectively 60fps total).   I use 2 512GB OCZ vertex 4 SSDs which
> > support ~450MB/s each.  I've soft-raided them together (raid 0) with a 4k
> > chunksize
>
> There's your first problem. You are storing 5.7MB files, so why
> would you use a 4k chunk size? You'd do better with something on the
> order of 1MB chunk size (2MB stripe width) so that you are forming
> as large IOs as possible with the minimum of software overhead (i.e
> no merging of 4k IOs into larger IOs in the IO scheduler).
>
> I went to the intel builtin raid0 and I found chunksize 4k, 64k, and 128k,
doesn't actually affect much in terms of latency, throughput with the
simulation application I've written - nor CPU.  Even directly streaming to
the raid partition still gobbles 40% cpu (single thread, single stream @
60fps, higher avg latency than xfs).  XFS on any of these chunksizes is
60-70% CPU with 3 streams, 1 per thread.  For XFS single thread, single
stream @ 60fps it looked like the same as direct, maybe getting up to 45,
and 50% CPU occasionally. All these numbers are seemingly dependent on the
mood of the SSD, along with how often there were latency overruns
(sometimes none for 45 minutes, sometimes every second - perhaps there's a
pattern to the behavior).  I'd be interested in trying larger blocksizes
than 4k (I don't mean raid0 chunksize) but that doesn't seem possible with
x86_64 and linux...


> Note that you are also writing hundreds of GB to the SSDs, which
> will be triggering internal garbage collection, and that will have
> significant impact on Io completion latency. It's not uncommon to
> see 500ms IO latencies occur on consumer level SSDs when garbage
> collect kicks in. If you are going to use SATA SSDs, then you're
> going to have to design your application to be able to handle such
> write latencies...
>
> 500ms does look like to be in the neighborhood for the garbage collection
for these drives.  Maybe 4-450 on the avg.  This neighborhood is an obvious
outlier in some tests.


> > and I get about 900MB/s avg in a benchmark program I wrote to
> > simulate my videostream logging needs.  I only save one file per
> > videostream (only 1 videostream modeled in simulation), which I append to
> > in a loop with a single write call, which records the frame, over and
> over
> > while keeping track of timing.
>
> The typical format for high bandwidth video stream is file per
> frame. That's exactly what the filestreams allocator is designed for
> - ingest of multiple streams and keeping them in separate locations
> (AGs) on disk. This means allocation remains concurrent and doesn't
> serialise, causing excess, unpredicatble latencies.
>
> Ah, that is interesting.  I used to save tiffs but I figured that would be
more variable in latency and cpu usage since it's opening and closing files
constantly.  However you have a definite point since it's not serialized to
one stream, that there's some extra concurrency to exploit.  I'll have to
benchmark with multiple files again.


> Indeed, if you use file per frame, and a RAID0 chunk size of 3MB
> (6MB stripe width), then XFs will align the data in each file to the
> same stripe unit boundary for all files. There will be 300kb of free
> space between them, but having everything nicely aligned to the
> underlying geometry tends to help maintain allocation determinism
> until the filesystem is 5.7/6 * 100% = 95% full.....
>
>
> The frame is in memory and nonzero with
> > some interesting pattern to defeat compression if its in the pipeline
> > anywhere.  I get 180-300MB/s with O_DIRECT, so better performance without
> > O_DIRECT (maybe because it's soft-raid?).
>
> It sounds like you are using in line write(2) calls, which means the
> IO is synchronous (i.e. occurs within the write syscall), which
> means throughput is bound by IO completion latency. AIO+DIO solves
> this problem as it implies application level frame buffering - this
> is a common way of ensuring that IO latencies don't cause dropped
> frames
>
> Yes, I don't really want to convolute the main program with AIO, it's
complex enough as is.


> Using buffered IO means the write(2) operates at memory speed, but
> you then have no control over allocation and writeback, and memory
> allocation and reclaim becomes a major source of latency that direct
> IO does not have. Doing buffered IO to the realtime device is, well,
> even less well tested than the realtime device, as historically the
> RT device only supported direct IO. It's supposed to work, but it's
> never really been well tested, and I don't know anyone who uses it
> in production....
>
> > The problem is that I
> > occationally get hickups in latency... there's nothing else using the
> disk
> > (embedded system, no other pid's running + root is RO).  I use the
> deadline
> > io scheduler on both my SSDs.
>
> Yep, that'll be because you are using buffered IO. It'll be faster
> than a naive Direct IO implementation, but you'll have latency
> issues that cannot be avoided or predicted.
>

Interesting, what constitutes a proper Direct IO implementation? AIO + an
recording structures who's size is a multiple of in this case 4k?

>
> > xfs_info of my video raid:
> > meta-data=/dev/md2               isize=256    agcount=32, agsize=7380047
>
> Lots of little AGs - that will stress the freespace management of
> the filesystem pretty quickly.....
>
> > blks
> >          =                       sectsz=512   attr=2
> > data     =                       bsize=4096   blocks=236161504,
> imaxpct=25
> >          =                       sunit=1      swidth=2 blks
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =internal               bsize=4096   blocks=115313, version=2
> >          =                       sectsz=512   sunit=1 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
>
> And no realtime device. It doesn't look like you're testing what you
> think you are testing....
>
> Sorry, the topic quickly moved from something of a bug report / query to
an involved benchmark and testing.  This xfs_info was not when I had the
realtime section, it was just for 4k chunksize raid0.  After a few crashes
on the realtime section I moved on to other testing since I doubted there
was little that could be done.  I've since performed alot of testing (to be
discussed hopefully in the next week, I'm getting to be pretty short on
time) and rewrote the framelogging component of the application with
average bandwidth in mind and decoupled the saving of frame data from the
framegrabber threads.  Basically I just have a configurable circular buffer
of up to 2 seconds of frames.  I think that is the best answer for now as
from my naive point of view, its some combination of linux related (FS path
was never RT)  and SSD (garbage collection was unplanned... who knows what
else the firmware is doing).

I'm still interested in finding out why streaming a few hundred MB to disk
has so much over head in comparison to the calculations I do in userspace,
though.  Straight copies of frames (in the real program, copied because of
limitations of the framegrabber driver's DMA engine) don't use as much cpu
as writing to a single SSD.  It takes a little over a millisecond to copy a
frame.  On hardware, while it's an embedded system it's got an 2.2ghz
2-core i7 in it, the southbridge is BD82QM67-PCH.

-Jason

--e89a8fb20322abf0bd04c62827c4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><div class=3D"gmail_quote"><div class=3D"gmail_quote"><div class=3D"im"=
>On Sun, Jul 29, 2012 at 8:03 PM, Dave Chinner <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&=
gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<div>On Fri, Jul 27, 2012 at 01:14:17AM -0700, Jason Newton wrote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; I think the following bug is still around:<br>
&gt;<br>
&gt; <a href=3D"http://oss.sgi.com/archives/xfs/2011-11/msg00179.html" targ=
et=3D"_blank">http://oss.sgi.com/archives/xfs/2011-11/msg00179.html</a><br>
&gt;<br>
&gt; I get the same stack trace.<br>
<br>
</div>Not surprising, I doubt anyone has looked at it much. Indeed,<br>
xfs/090 assert fails immediately in the rt allocator for me....<br>
<div><br>
&gt; There&#39;s another report out there somewhere<br>
&gt; with another similar stack trace. =C2=A0I know the realtime code is no=
t<br>
&gt; maintained so much but it seems to be a waste to let it fall out of<br=
>
&gt; maintenance when it&#39;s the only thing on linux that seems to fill t=
he<br>
&gt; realtime io niche.<br>
<br>
</div>The XFS &quot;realtime&quot; device has nothing to do with &quot;real=
time IO&quot;.<br>
<br>
If anything, it&#39;s probably much worse at &quot;realtime IO&quot; than t=
he<br>
normal data device, especially at scale, because it is bitmap rather<br>
than btree based. And it is single threaded.<br>
<br>
That&#39;s why it really isn&#39;t maintained - the data device is as good<=
br>
or better in RT workloads as the &quot;realtime&quot; device....<br></block=
quote></div><div><br>This wasn&#39;t expected, thanks for the clarification=
s.=C2=A0=C2=A0 What was the original point of RT files?<br></div><div class=
=3D"im">
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">

<div><br>
&gt; So this email is mainly about the null pointer deref on the spinlock i=
n<br>
&gt; _xfs_buf_find on realtime files, but I figure I might also ask a few m=
ore<br>
&gt; questions.<br>
&gt;<br>
&gt; What kind of differences should one expect between GRIO and realtime f=
iles?<br>
<br>
</div>Linux doesn&#39;t support GRIO. It&#39;s an Irix only thing, and that=
<br>
required special hardware support for bandwidth reservation, special<br>
frame schedulers in the IO path, etc. The XFS realtime device was<br>
just one part of the whole GRIO framework. Anyway, if you don&#39;t have<br=
>
15 year old SGI hardware you can&#39;t use GRIO.<br>
<br>
If you are talking about GRIOv2, then, well, you aren&#39;t running<br>
CXFS...<br>
<div><br>
&gt; What kind of on latencies of writes should one expect for realtime fil=
es vs<br>
&gt; normal?<br>
<br>
</div>How long is a piece of string?<br></blockquote></div><div>Well, I had=
 meant with say one block of io.<br>=C2=A0</div><div class=3D"im"><blockquo=
te class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc so=
lid;padding-left:1ex">

<div><br>
&gt; raw video to disk (3 high res 10bit video streams, 5.7MB per frame, at=
 20hz<br>
&gt; so effectively 60fps total). =C2=A0 I use 2 512GB OCZ vertex 4 SSDs wh=
ich<br>
&gt; support ~450MB/s each. =C2=A0I&#39;ve soft-raided them together (raid =
0) with a 4k<br>
&gt; chunksize<br>
<br>
</div>There&#39;s your first problem. You are storing 5.7MB files, so why<b=
r>
would you use a 4k chunk size? You&#39;d do better with something on the<br=
>
order of 1MB chunk size (2MB stripe width) so that you are forming<br>
as large IOs as possible with the minimum of software overhead (i.e<br>
no merging of 4k IOs into larger IOs in the IO scheduler).<br>
<br></blockquote></div><div>I went to the intel builtin raid0 and I found c=
hunksize 4k, 64k, and 128k, doesn&#39;t actually affect much in terms of la=
tency, throughput with the simulation application I&#39;ve written - nor CP=
U.=C2=A0 Even directly streaming to the raid partition still gobbles 40% cp=
u (single thread, single stream @ 60fps, higher avg latency than xfs).=C2=
=A0 XFS on any of these chunksizes is 60-70% CPU with 3 streams, 1 per thre=
ad.=C2=A0 For XFS single thread, single stream @ 60fps it looked like the s=
ame as direct, maybe getting up to 45, and 50% CPU occasionally. All these =
numbers are seemingly dependent on the mood of the SSD, along=20
with how often there were latency overruns (sometimes none for 45 minutes, =
sometimes=20
every second - perhaps there&#39;s a pattern to the behavior).=C2=A0 I&#39;=
d be interested in trying larger blocksizes than 4k (I don&#39;t mean raid0=
 chunksize) but that doesn&#39;t seem possible with x86_64 and linux...<br>

=C2=A0</div><div class=3D"im"><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
Note that you are also writing hundreds of GB to the SSDs, which<br>
will be triggering internal garbage collection, and that will have<br>
significant impact on Io completion latency. It&#39;s not uncommon to<br>
see 500ms IO latencies occur on consumer level SSDs when garbage<br>
collect kicks in. If you are going to use SATA SSDs, then you&#39;re<br>
going to have to design your application to be able to handle such<br>
write latencies...<br>
<div><br></div></blockquote></div><div>500ms does look like to be in the ne=
ighborhood for the garbage collection for these drives.=C2=A0 Maybe 4-450 o=
n the avg.=C2=A0 This neighborhood is an obvious outlier in some tests.<br>
=C2=A0</div><div class=3D"im"><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div>
&gt; and I get about 900MB/s avg in a benchmark program I wrote to<br>
&gt; simulate my videostream logging needs. =C2=A0I only save one file per<=
br>
&gt; videostream (only 1 videostream modeled in simulation), which I append=
 to<br>
&gt; in a loop with a single write call, which records the frame, over and =
over<br>
&gt; while keeping track of timing.<br>
<br>
</div>The typical format for high bandwidth video stream is file per<br>
frame. That&#39;s exactly what the filestreams allocator is designed for<br=
>
- ingest of multiple streams and keeping them in separate locations<br>
(AGs) on disk. This means allocation remains concurrent and doesn&#39;t<br>
serialise, causing excess, unpredicatble latencies.<br>
<br></blockquote></div><div>Ah, that is interesting.=C2=A0 I used to save t=
iffs but I figured that would be more variable in latency and cpu usage sin=
ce it&#39;s opening and closing files constantly.=C2=A0 However you have a =
definite point since it&#39;s not serialized to one stream, that there&#39;=
s some extra concurrency to exploit.=C2=A0 I&#39;ll have to benchmark with =
multiple files again.<br>

=C2=A0<br></div><div class=3D"im"><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
Indeed, if you use file per frame, and a RAID0 chunk size of 3MB<br>
(6MB stripe width), then XFs will align the data in each file to the<br>
same stripe unit boundary for all files. There will be 300kb of free<br>
space between them, but having everything nicely aligned to the<br>
underlying geometry tends to help maintain allocation determinism<br>
until the filesystem is 5.7/6 * 100% =3D 95% full.....<br>
<div>=C2=A0<br></div></blockquote><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div>
&gt; The frame is in memory and nonzero with<br>
&gt; some interesting pattern to defeat compression if its in the pipeline<=
br>
&gt; anywhere. =C2=A0I get 180-300MB/s with O_DIRECT, so better performance=
 without<br>
&gt; O_DIRECT (maybe because it&#39;s soft-raid?).<br>
<br>
</div>It sounds like you are using in line write(2) calls, which means the<=
br>
IO is synchronous (i.e. occurs within the write syscall), which<br>
means throughput is bound by IO completion latency. AIO+DIO solves<br>
this problem as it implies application level frame buffering - this<br>
is a common way of ensuring that IO latencies don&#39;t cause dropped<br>
frames<br>
<br></blockquote></div><div>Yes, I don&#39;t really want to convolute the m=
ain program with AIO, it&#39;s complex enough as is.<br>=C2=A0<br></div><di=
v class=3D"im"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex=
;border-left:1px #ccc solid;padding-left:1ex">


Using buffered IO means the write(2) operates at memory speed, but<br>
you then have no control over allocation and writeback, and memory<br>
allocation and reclaim becomes a major source of latency that direct<br>
IO does not have. Doing buffered IO to the realtime device is, well,<br>
even less well tested than the realtime device, as historically the<br>
RT device only supported direct IO. It&#39;s supposed to work, but it&#39;s=
<br>
never really been well tested, and I don&#39;t know anyone who uses it<br>
in production....<br>
<div><br>
&gt; The problem is that I<br>
&gt; occationally get hickups in latency... there&#39;s nothing else using =
the disk<br>
&gt; (embedded system, no other pid&#39;s running + root is RO). =C2=A0I us=
e the deadline<br>
&gt; io scheduler on both my SSDs.<br>
<br>
</div>Yep, that&#39;ll be because you are using buffered IO. It&#39;ll be f=
aster<br>
than a naive Direct IO implementation, but you&#39;ll have latency<br>
issues that cannot be avoided or predicted.<br></blockquote></div><div><br>=
Interesting, what constitutes a proper Direct IO implementation? AIO + an r=
ecording structures who&#39;s size is a multiple of in this case 4k?<br>
</div><div class=3D"im">
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<div><br>
&gt; xfs_info of my video raid:<br>
&gt; meta-data=3D/dev/md2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
isize=3D256 =C2=A0 =C2=A0agcount=3D32, agsize=3D7380047<br>
<br>
</div>Lots of little AGs - that will stress the freespace management of<br>
the filesystem pretty quickly.....<br>
<div><br>
&gt; blks<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 attr=3D2<=
br>
&gt; data =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D236161504, ima=
xpct=3D25<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sunit=3D1 =C2=A0 =C2=A0 =C2=
=A0swidth=3D2 blks<br>
&gt; naming =C2=A0 =3Dversion 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0bsize=3D4096 =C2=A0 ascii-ci=3D0<br>
&gt; log =C2=A0 =C2=A0 =C2=A0=3Dinternal =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D115313, version=3D2<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 sunit=3D1=
 blks, lazy-count=3D1<br>
&gt; realtime =3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 extsz=3D4096 =C2=A0 blocks=3D0, rtextents=3D0<br>
<br>
</div>And no realtime device. It doesn&#39;t look like you&#39;re testing w=
hat you<br>
think you are testing....<br>
<br></blockquote></div><div>Sorry, the topic quickly moved from something o=
f a bug report / query to an involved benchmark and testing.=C2=A0 This xfs=
_info was not when I had the realtime section, it was just for 4k chunksize=
 raid0.=C2=A0 After a few crashes on the realtime section I moved on to oth=
er testing since I doubted there was little that could be done.=C2=A0 I&#39=
;ve since performed alot of testing (to be discussed hopefully in the next =
week, I&#39;m getting to be pretty short on time) and rewrote the framelogg=
ing component of the application with average bandwidth in mind and decoupl=
ed the saving of frame data from the framegrabber threads.=C2=A0 Basically =
I just have a configurable circular buffer of up to 2 seconds of frames.=C2=
=A0 I think that is the best answer for now as from my naive point of view,=
 its some combination of linux related (FS path was never RT)=C2=A0 and SSD=
 (garbage collection was unplanned... who knows what else the firmware is d=
oing).<br>

<br>I&#39;m still interested in finding out why streaming a few hundred MB =
to disk has so much over head in comparison to the calculations I do in use=
rspace, though.=C2=A0 Straight copies of frames (in the real program, copie=
d because of limitations of the framegrabber driver&#39;s DMA engine) don&#=
39;t use as much cpu as writing to a single SSD.=C2=A0 It takes a little ov=
er a millisecond to copy a frame.=C2=A0 On hardware, while it&#39;s an embe=
dded system it&#39;s got an 2.2ghz 2-core i7 in it, the southbridge is BD82=
QM67-PCH.<span class=3D"HOEnZb"><font color=3D"#888888"><br>

<br>-Jason<br></font></span></div></div>
</div><br>

--e89a8fb20322abf0bd04c62827c4--


--===============3710755711546744011==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3710755711546744011==--

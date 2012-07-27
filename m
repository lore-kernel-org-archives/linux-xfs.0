Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6R8EJGS192177 for <xfs@oss.sgi.com>; Fri, 27 Jul 2012 03:14:19 -0500
Received: from mail-qa0-f46.google.com (mail-qa0-f46.google.com
	[209.85.216.46]) by cuda.sgi.com with ESMTP id t1a2bBrG15TRRB0X
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 27 Jul 2012 01:14:18 -0700 (PDT)
Received: by qadb17 with SMTP id b17so4605464qad.5
	for <xfs@oss.sgi.com>; Fri, 27 Jul 2012 01:14:17 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 27 Jul 2012 01:14:17 -0700
Message-ID: <CAGou9MgezsS=2+SngGWBJv5Npsuqacx1VPJwvMuf0FS+XnXt8A@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============3797258425765593629=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3797258425765593629==
Content-Type: multipart/alternative; boundary=00248c71180564e60304c5cb4ca1

--00248c71180564e60304c5cb4ca1
Content-Type: text/plain; charset=UTF-8

Hi,

I think the following bug is still around:

http://oss.sgi.com/archives/xfs/2011-11/msg00179.html

I get the same stack trace.  There's another report out there somewhere
with another similar stack trace.  I know the realtime code is not
maintained so much but it seems to be a waste to let it fall out of
maintenance when it's the only thing on linux that seems to fill the
realtime io niche.

So this email is mainly about the null pointer deref on the spinlock in
_xfs_buf_find on realtime files, but I figure I might also ask a few more
questions.

What kind of differences should one expect between GRIO and realtime files?

What kind of on latencies of writes should one expect for realtime files vs
normal?

My use case is diagnostic tracing on an embedded system as well as saving
raw video to disk (3 high res 10bit video streams, 5.7MB per frame, at 20hz
so effectively 60fps total).   I use 2 512GB OCZ vertex 4 SSDs which
support ~450MB/s each.  I've soft-raided them together (raid 0) with a 4k
chunksize and I get about 900MB/s avg in a benchmark program I wrote to
simulate my videostream logging needs.  I only save one file per
videostream (only 1 videostream modeled in simulation), which I append to
in a loop with a single write call, which records the frame, over and over
while keeping track of timing.  The frame is in memory and nonzero with
some interesting pattern to defeat compression if its in the pipeline
anywhere.  I get 180-300MB/s with O_DIRECT, so better performance without
O_DIRECT (maybe because it's soft-raid?).  The problem is that I
occationally get hickups in latency... there's nothing else using the disk
(embedded system, no other pid's running + root is RO).  I use the deadline
io scheduler on both my SSDs.

I only have 50 milliseconds per frame and latencies exceeding this would
result in dropped frames (bad).

Benchmarks (all time values in milliseconds per frame for the write call to
complete), with 4k chunksizes for raid-0 (85-95% CPU):
[04:42:08.450483000] [6] min: 4 max: 375 avg: 6.6336148 std: 4.6589185
count = 163333, transferred 900.33G
[07:52:21.204783000] [6] min: 4 max: 438 avg: 6.4564963 std: 3.9554192
count = 34854, transferred 192.12G (total time=226.65sec, ~154fps)

O_DIRECT (60-80% CPU):
[07:46:08.912902000] [6] min: 13 max: 541 avg: 25.9286739 std: 10.3084094
count = 17527, transferred 96.61G


Some benchmarks of last nights 32k chunksizes for raid-0:
vectorized write (prior to d_mem aligned, tightly packed frames):
[05:46:02.481997000] [6] min: 4 max: 50 avg: 6.3724173 std: 3.1656021 count
= 3523, transferred 19.42G
[06:14:19.416474000] [6] min: 4 max: 906 avg: 6.6565749 std: 9.2845644
count = 22538, transferred 124.23G
[06:15:58.029818000] [6] min: 4 max: 485 avg: 6.4346011 std: 5.6314630
count = 12180, transferred 67.14G
[06:33:24.125104000] [6] min: 4 max: 1640 avg: 6.7820190 std: 9.9053959
count = 40862, transferred 225.24G
[06:47:00.812176000] [6] min: 4 max: 503 avg: 6.7217849 std: 5.8866980
count = 13099, transferred 72.20G
[07:03:55.334832000] [6] min: 4 max: 505 avg: 6.5297441 std: 8.0027016
count = 14636, transferred 80.68G

non vectorized (many write calls):
[05:46:55.839896000] [6] min: 5 max: 341 avg: 7.1133700 std: 7.3144947
count = 2878, transferred 15.86G
[06:03:00.353392000] [6] min: 5 max: 464 avg: 7.8846180 std: 5.5350027
count = 27966, transferred 154.16G

O_DIRECT:
[07:51:45.467037000] [6] min: 9 max: 486 avg: 11.6206933 std: 6.9021786
count = 9603, transferred 52.93G
[07:59:04.404820000] [6] min: 9 max: 490 avg: 11.8425485 std: 6.6553718
count = 32172, transferred 177.34G


xfs_info of my video raid:
meta-data=/dev/md2               isize=256    agcount=32, agsize=7380047
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=236161504, imaxpct=25
         =                       sunit=1      swidth=2 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=115313, version=2
         =                       sectsz=512   sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

I'm using 3.2.22 with the rt34 patchset.

If it's desired I can post my benchmark code. I intend to rework it a
little so it only does 60fps capped since this is my real workload.

If anyone has any tips for reducing latencies of the write calls or cpu
usage, I'd be interested for sure.

Apologies for the long email!  I figured I had an interesting use case with
lots of numbers at my disposal.

-Jason

--00248c71180564e60304c5cb4ca1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,<br><br>I think the following bug is still around:<br><br><a href=3D"htt=
p://oss.sgi.com/archives/xfs/2011-11/msg00179.html">http://oss.sgi.com/arch=
ives/xfs/2011-11/msg00179.html</a><br><br>I get the same stack trace.=C2=A0=
 There&#39;s another report out there somewhere with another similar stack =
trace.=C2=A0 I know the realtime code is not maintained so much but it seem=
s to be a waste to let it fall out of maintenance when it&#39;s the only th=
ing on linux that seems to fill the realtime io niche.<br>
<br>So this email is mainly about the null pointer deref on the spinlock in=
 _xfs_buf_find on realtime files, but I figure I might also ask a few more =
questions.<br><br>What kind of differences should one expect between GRIO a=
nd realtime files?<br>
<br>What kind of on latencies of writes should one expect for realtime file=
s vs normal?<br><br>My use case is diagnostic tracing on an embedded system=
 as well as saving raw video to disk (3 high res 10bit video streams, 5.7MB=
 per frame, at 20hz so effectively 60fps total).=C2=A0=C2=A0 I use 2 512GB =
OCZ vertex 4 SSDs which support ~450MB/s each.=C2=A0 I&#39;ve soft-raided t=
hem together (raid 0) with a 4k chunksize and I get about 900MB/s avg in a =
benchmark program I wrote to simulate my videostream logging needs.=C2=A0 I=
 only save one file per videostream (only 1 videostream modeled in simulati=
on), which I append to in a loop with a single write call, which records th=
e frame, over and over while keeping track of timing.=C2=A0 The frame is in=
 memory and nonzero with some interesting pattern to defeat compression if =
its in the pipeline anywhere.=C2=A0 I get 180-300MB/s with O_DIRECT, so bet=
ter performance without O_DIRECT (maybe because it&#39;s soft-raid?).=C2=A0=
 The problem is that I occationally get hickups in latency... there&#39;s n=
othing else using the disk (embedded system, no other pid&#39;s running + r=
oot is RO).=C2=A0 I use the deadline io scheduler on both my SSDs.=C2=A0 <b=
r>
<br>I only have 50 milliseconds per frame and latencies exceeding this woul=
d result in dropped frames (bad).<br><br>Benchmarks (all time values in mil=
liseconds per frame for the write call to complete), with 4k chunksizes for=
 raid-0 (85-95% CPU):<br>
[04:42:08.450483000] [6] min: 4 max: 375 avg: 6.6336148 std: 4.6589185 coun=
t =3D 163333, transferred 900.33G<br>[07:52:21.204783000] [6] min: 4 max: 4=
38 avg: 6.4564963 std: 3.9554192 count =3D 34854, transferred 192.12G (tota=
l time=3D226.65sec, ~154fps)<br>
<br>O_DIRECT (60-80% CPU):<br>[07:46:08.912902000] [6] min: 13 max: 541 avg=
: 25.9286739 std: 10.3084094 count =3D 17527, transferred 96.61G<br><br><br=
>Some benchmarks of last nights 32k chunksizes for raid-0:<br>vectorized wr=
ite (prior to d_mem aligned, tightly packed frames):<br>
[05:46:02.481997000] [6] min: 4 max: 50 avg: 6.3724173 std: 3.1656021 count=
 =3D 3523, transferred 19.42G<br>[06:14:19.416474000] [6] min: 4 max: 906 a=
vg: 6.6565749 std: 9.2845644 count =3D 22538, transferred 124.23G<br>[06:15=
:58.029818000] [6] min: 4 max: 485 avg: 6.4346011 std: 5.6314630 count =3D =
12180, transferred 67.14G<br>
[06:33:24.125104000] [6] min: 4 max: 1640 avg: 6.7820190 std: 9.9053959 cou=
nt =3D 40862, transferred 225.24G<br>[06:47:00.812176000] [6] min: 4 max: 5=
03 avg: 6.7217849 std: 5.8866980 count =3D 13099, transferred 72.20G<br>[07=
:03:55.334832000] [6] min: 4 max: 505 avg: 6.5297441 std: 8.0027016 count =
=3D 14636, transferred 80.68G<br>
<br>non vectorized (many write calls):<br>[05:46:55.839896000] [6] min: 5 m=
ax: 341 avg: 7.1133700 std: 7.3144947 count =3D 2878, transferred 15.86G<br=
>[06:03:00.353392000] [6] min: 5 max: 464 avg: 7.8846180 std: 5.5350027 cou=
nt =3D 27966, transferred 154.16G<br>
<br>O_DIRECT:<br>[07:51:45.467037000] [6] min: 9 max: 486 avg: 11.6206933 s=
td: 6.9021786 count =3D 9603, transferred 52.93G<br>[07:59:04.404820000] [6=
] min: 9 max: 490 avg: 11.8425485 std: 6.6553718 count =3D 32172, transferr=
ed 177.34G<br>
<br><br>xfs_info of my video raid:<br>meta-data=3D/dev/md2=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 isize=
=3D256=C2=A0=C2=A0=C2=A0 agcount=3D32, agsize=3D7380047 blks<br>=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 sectsz=3D512=C2=A0=C2=A0 attr=3D2<br>data=C2=A0=
=C2=A0=C2=A0=C2=A0 =3D=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 bsize=3D4096=C2=A0=C2=A0 blocks=3D236161504, imaxpct=3D25<br>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sunit=3D1=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 swidth=3D2 blks<br>naming=C2=A0=C2=A0 =3Dversion 2=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bsize=3D4096=C2=
=A0=C2=A0 ascii-ci=3D0<br>log=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3Dinternal=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 bsize=3D4096=C2=A0=C2=A0 blocks=3D115313, version=3D2<br>=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 sectsz=3D512=C2=A0=C2=A0 sunit=3D1 blks, lazy-c=
ount=3D1<br>
realtime =3Dnone=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extsz=3D4096=C2=A0=C2=
=A0 blocks=3D0, rtextents=3D0<br><br>I&#39;m using 3.2.22 with the rt34 pat=
chset.<br><br>If it&#39;s desired I can post my benchmark code. I intend to=
 rework it a little so it only does 60fps capped since this is my real work=
load.<br>
<br>If anyone has any tips for reducing latencies of the write calls or cpu=
 usage, I&#39;d be interested for sure.<br><br>Apologies for the long email=
!=C2=A0 I figured I had an interesting use case with lots of numbers at my =
disposal.<br>
<br>-Jason<br>

--00248c71180564e60304c5cb4ca1--


--===============3797258425765593629==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3797258425765593629==--

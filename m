Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8S1Fsqj213480 for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 20:15:54 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D2801D960C3
	for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 18:16:49 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	DHCGcSw97xdBgGtr for <xfs@oss.sgi.com>;
	Mon, 27 Sep 2010 18:16:49 -0700 (PDT)
Date: Tue, 28 Sep 2010 11:16:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Contiguous file sequences
Message-ID: <20100928011646.GD5665@dastard>
References: <AANLkTikHqjvEGJb0XnNy+nz7+nHLVLwjF_wp5RZdk_1-@mail.gmail.com>
	<4C9A6298.106@sandeen.net>
	<AANLkTinz4rYCb8cHH69pYy-oPT-041y+DmVaWm3N_1hu@mail.gmail.com>
	<4CA018D9.1030803@sandeen.net>
	<AANLkTi=xPjAtjP5E6XK8Xhgvo1FoqAEUKLvDrNJO3-OH@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=xPjAtjP5E6XK8Xhgvo1FoqAEUKLvDrNJO3-OH@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Daire Byrne <daire.byrne@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, Sep 27, 2010 at 05:30:35PM +0100, Daire Byrne wrote:
> Eric,
> =

> On Mon, Sep 27, 2010 at 5:08 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> > Daire Byrne wrote:
> >>> Why is this the goal, what are you trying to achieve?
> >>
> >> I am essentially trying to play back a large frame sequence and trying
> >> to minimise seeks as it can lead to sporadic slowdowns on a SATA based
> >> RAID.
> >
> > Ok - and you've really seen allocation patterns that cause the playback
> > to slow down? =A0xfs_bmap information for a few sequential files that w=
ere
> > this far off would be interesting to see.
> >
> > Are you certain that it's seekiness causing the problem? =A0A great way
> > to visualize it would be to use the seekwatcher application while you
> > run a problematic file sequence.
> =

> I'm certain that the seekiness is the culprit. The image files are
> pretty big and require 400MB/s+ speeds to play them back at full rate.

Ah, so you're doing ingest and real-time playback of 30fps uncompressed 2k
HD video streams?

> >>> You can't specify a starting block for any given file I'm afraid.
> >>
> >> Somebody pointed me at this which looks fairly promising:
> >>
> >> =A0 http://oss.sgi.com/archives/xfs/2006-07/msg01005.html
> >
> > Yeah, that never got merged, but I think it still could be.
> >
> > It's only half your battle though, you need to find that contiguous
> > space first, then specify the start block for it with the interface
> > above.
> =

> I played around with the patch and I think I have a way to do what I
> want using something like:
> =

> # allocate a big file that all the frames can fit into and hope it is con=
tiguous
> BLOCK=3D`xfs_io -f -c "resvsp 0 $TOTALSIZE" -c "freesp $FRAMESIZE 0" -c
> "pwrite 0 1" -c "bmap" $DIR/test.0 | grep "0: \[" | sed 's/\../ /g' |
> cut -f5 -d" "`
> for x in `seq 1 $FRAMES`; do
>     allocnear $DIR/test.$x $BLOCK
>     BLOCK=3D`xfs_io -f -c "bmap" $DIR/test.$x | grep "0: \[" | sed
> 's/\../ /g' | cut -f5 -d" "`
>     dd if=3D/dev/zero of=3D$DIR/test.$x bs=3D1M count=3D13 conv=3Dnotrunc=
,nocreat
>     sync
> done

I think you're doing it all wrong. You're using buffered IO, and
that is simply does not give control of the order of writeback of files
and hence where they might be allocated. Use direct IO, and you get
allocation occuring in the context of the write() syscall, and
if your application is single threaded, you'll see something like this:

$ for i in `seq 0 1 200`; do \
> dd if=3D/dev/zero of=3D/mnt/scratch/test.$i bs=3D1M count=3D13 oflag=3Ddi=
rect
> done
......
$ for i in `seq 0 1 200`; do \
> sudo xfs_bmap -vp /mnt/scratch/test.$i |grep "0: \[";
> done
   0: [0..26623]:      96..26719         0 (96..26719)      26624 00000
   0: [0..26623]:      26720..53343      0 (26720..53343)   26624 00000
   0: [0..26623]:      53344..79967      0 (53344..79967)   26624 00000
   0: [0..26623]:      79968..106591     0 (79968..106591)  26624 00000
   0: [0..26623]:      106592..133215    0 (106592..133215) 26624 00000
   0: [0..26623]:      133216..159839    0 (133216..159839) 26624 00000
   0: [0..26623]:      159840..186463    0 (159840..186463) 26624 00000
   0: [0..26623]:      186464..213087    0 (186464..213087) 26624 00000
   0: [0..26623]:      213088..239711    0 (213088..239711) 26624 00000
   0: [0..26623]:      239712..266335    0 (239712..266335) 26624 00000
   0: [0..26623]:      266336..292959    0 (266336..292959) 26624 00000
   0: [0..26623]:      292968..319591    0 (292968..319591) 26624 00000
   0: [0..26623]:      319592..346215    0 (319592..346215) 26624 00000
   0: [0..26623]:      346216..372839    0 (346216..372839) 26624 00000
   0: [0..26623]:      372840..399463    0 (372840..399463) 26624 00000
   0: [0..26623]:      399464..426087    0 (399464..426087) 26624 00000
   0: [0..26623]:      426088..452711    0 (426088..452711) 26624 00000
   0: [0..26623]:      452712..479335    0 (452712..479335) 26624 00000
   0: [0..26623]:      479336..505959    0 (479336..505959) 26624 00000
   0: [0..26623]:      505960..532583    0 (505960..532583) 26624 00000
   0: [0..26623]:      532584..559207    0 (532584..559207) 26624 00000
   0: [0..26623]:      559208..585831    0 (559208..585831) 26624 00000
   0: [0..26623]:      585832..612455    0 (585832..612455) 26624 00000
   0: [0..26623]:      612456..639079    0 (612456..639079) 26624 00000
   0: [0..26623]:      639080..665703    0 (639080..665703) 26624 00000
   0: [0..26623]:      665704..692327    0 (665704..692327) 26624 00000
   0: [0..26623]:      692328..718951    0 (692328..718951) 26624 00000
   0: [0..26623]:      718952..745575    0 (718952..745575) 26624 00000
   0: [0..26623]:      745576..772199    0 (745576..772199) 26624 00000
   0: [0..26623]:      772200..798823    0 (772200..798823) 26624 00000 =

.....

Looks pretty contiguous across files to me, and this was using
default mkfs and mount options. i.e. without needing preallocation,
hints or even the filestreams allocator.

FWIW, the filestreams allocator was designed to work optimally with
direct IO - it mostly works with buffered IO but you give up strict
ordering of allocation. That is, buffered IO does not strictly write
back files in exactly the same order that they were originally
written.

Further, the way you read the files using direct IO makes a very big
difference to performance. Reading them using 13x 1MB direct IOs:

$ time for i in `seq 0 1 200`; do \
> dd of=3D/dev/null if=3D/mnt/scratch/test.$i bs=3D1M count=3D13 iflag=3Ddi=
rect;
> done
....
13+0 records in
13+0 records out
13631488 bytes (14 MB) copied, 0.12288 s, 111 MB/s

real    0m31.477s
user    0m0.276s
sys     0m0.628s

Which looks pretty bad considering the disk subsystem can do
1.6GB/s. However, even with buffered IO, the same read pattern could
not sustain 30fps uncompressed 2k video rates:

$ time for i in `seq 0 1 200`; do \
> dd of=3D/dev/null if=3D/mnt/scratch/test.$i bs=3D13M count=3D1;
> done
.....
1+0 records in
1+0 records out
13631488 bytes (14 MB) copied, 0.0649989 s, 210 MB/s

real    0m13.649s
user    0m0.072s
sys     0m4.100s

So you'd still need to do application level per-file readahead and
buffering.

However, being smart about direct IO, lets do a single 13MB IO per
frame:

$ time for i in `seq 0 1 200`; do \
> dd of=3D/dev/null if=3D/mnt/scratch/test.$i bs=3D13M count=3D1 iflag=3Ddi=
rect;
> done
.....
1+0 records in
1+0 records out
13631488 bytes (14 MB) copied, 0.0211065 s, 646 MB/s

real    0m6.545s
user    0m0.044s
sys     0m1.808s

It's an awful lot faster with IO times being 3x lower than for
buffered IO. IOWs, you could probably play a video stream straight
off the disk without buffering or readahead....

IOWs, what I'm showing you here is that even with a disk subsystem
that does far in excess of your target throughput, the way you read
the files has a massive impact on IO latency. Even for perfect
layout, the above example shows that a single (optimal) direct IO
read has 3x lower IO latency than the same (optimal) buffered IO.
Direct Io is going to be a lot more deterministic, as well...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

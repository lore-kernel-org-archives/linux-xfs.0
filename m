Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3EMtmCf023030 for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 17:55:49 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBE1C1EC01C3
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 15:59:08 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	eYdkPzWyPpMoY8hC for <xfs@oss.sgi.com>;
	Thu, 14 Apr 2011 15:59:08 -0700 (PDT)
Date: Fri, 15 Apr 2011 08:59:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Message-ID: <20110414225904.GK21395@dastard>
References: <20110414102608.GA1678@x4.trippels.de>
	<20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DA717B2.3020305@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-ext4@vger.kernel.org, =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>, coreutils@gnu.org, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs-oss <xfs@oss.sgi.com>

On Thu, Apr 14, 2011 at 10:50:10AM -0500, Eric Sandeen wrote:
> On 4/14/11 9:59 AM, P=E1draig Brady wrote:
> > On 14/04/11 15:02, Markus Trippelsdorf wrote:
> >>>> Hi P=E1draig,
> >>>>
> >>>> here you go:
> >>>> + filefrag -v unwritten.withdata                                    =
                                                                           =
      =

> >>>> Filesystem type is: ef53                                            =
                                                                           =
      =

> >>>> File size of unwritten.withdata is 5120 (2 blocks, blocksize 4096)  =
                                                                           =
      =

> >>>>  ext logical physical expected length flags                         =
                                                                           =
      =

> >>>>    0       0   274432            2560 unwritten,eof                 =
                                                                           =
      =

> >>>> unwritten.withdata: 1 extent found
> >>>>
> >>>> Please notice that this also happens with ext4 on the same kernel. =

> >>>> Btrfs is fine.
> >>>
> >> `filefrag -vs` fixes the issue on both xfs and ext4.
> > =

> > So in summary, currently on (2.6.39-rc3), the following
> > will (usually?) report a single unwritten extent,
> > on both ext4 and xfs
> > =

> >   fallocate -l 10MiB -n k
> >   dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullblock of=
=3Dk
> >   filefrag -v k # grep for an extent without unwritten || fail
> =

> right, that's what I see too in testing.
> =

> But would the coreutils install have done a preallocation of the destinat=
ion file?
> =

> Otherwise this looks like a different bug...
> =

> > This particular issue has been discussed so far at:
> > http://debbugs.gnu.org/cgi/bugreport.cgi?bug=3D8411
> > Note there it was stated there that ext4 had this
> > fixed as of 2.6.39-rc1, so maybe there is something lurking?
> =

> ext4 got a fix, but not xfs, I guess.  My poor brain can't remember, I th=
ink I started looking into it, but it's clearly still broken.
> =

> Still, I don't know for sure what happened to Markus - did something prea=
llocate, in his case?

Unwritten extent mapping behaves in an unexpected way due to
buffered writeback not occurring immediately. Extent conversion
doesn't occur until the data is on disk, and for buffered IO you
need an fdatasync to ensure that has occurred.

That is: =


$ xfs_io -f -c "resvsp 0 10m" -c "pwrite 0 5120" -c "bmap -vp" /mnt/test/foo
wrote 5120/5120 bytes at offset 0
5 KiB, 2 ops; 0.0000 sec (62.600 MiB/sec and 25641.0256 ops/sec)
/mnt/test/foo:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..20479]:      268984..289463    0 (268984..289463) 20480 10000

Data has not been written yet, so it is still unwritten. The same
test with a fsync shows:

$ sudo xfs_io -f -c "resvsp 0 10m" -c "pwrite 0 5120" -c fsync -c "bmap -vp=
" /mnt/test/foo
wrote 5120/5120 bytes at offset 0
5 KiB, 2 ops; 0.0000 sec (87.193 MiB/sec and 35714.2857 ops/sec)
/mnt/test/foo:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..15]:         268984..268999    0 (268984..268999)    16 00000
   1: [16..20479]:     269000..289463    0 (269000..289463) 20464 10000

Everything is fine.

So this seems like an application error to me. If you are going to
use fiemap to determine what ranges to copy, then you have to
fdatasync the source file first to guarantee that preallocated
extents have been converted to written state before mapping the
file....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

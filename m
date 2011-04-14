Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3FDUNSr069702 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 08:30:23 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 556923E3C1E
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 06:33:45 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id mo8AECDvtKW5BgTO for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2011 06:33:45 -0700 (PDT)
Date: Thu, 14 Apr 2011 16:02:22 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Message-ID: <20110414140222.GB1679@x4.trippels.de>
References: <20110414102608.GA1678@x4.trippels.de>
	<20110414120635.GB1678@x4.trippels.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110414120635.GB1678@x4.trippels.de>
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
To: coreutils@gnu.org
Cc: xfs@oss.sgi.com

On 2011.04.14 at 14:53 +0100, P=E1draig Brady wrote:
> On 14/04/11 14:48, Markus Trippelsdorf wrote:
> > On 2011.04.14 at 14:34 +0100, P=E1draig Brady wrote:
> >> Hi Markus,
> >>
> >> I noticed your fiemap issues here:
> >> http://oss.sgi.com/pipermail/xfs/2011-April/050102.html
> >>
> >> FAIL: cp/fiemap-empty (exit: 1)
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> >> ...
> >> + fallocate -l 10MiB -n unwritten.withdata
> >> + dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullblock
> >> of=3Dunwritten.withdata
> >> 10+0 records in
> >> 10+0 records out
> >> 5120 bytes (5.1 kB) copied, 0.00219578 s, 2.3 MB/s
> >> + cp unwritten.withdata cp.test
> >> ++ stat -c %s unwritten.withdata
> >> ++ stat -c %s cp.test
> >> + test 5120 =3D 5120
> >> + cmp unwritten.withdata cp.test
> >> unwritten.withdata cp.test differ: char 1, line 1
> >> + fail=3D1
> >>
> >> cp was changed in 8.11 to not bother reading
> >> an extent if it is marked as UNWRITTEN.
> >> The comment in fiemap.h says that this means that the
> >> space is allocated, but zero.
> >>
> >> We tested on XFS, on F15 x86_64, which is earlier
> >> than your 2.6.39-rc3 and didn't notice this issue.
> >>
> >> I'm guessing so that XFS is reporting the extent
> >> as UNWRITTEN, even though there is data in it now,
> >> and that it might sort itself out after a while,
> >> or after a sync I suppose (note we also stopped
> >> using sync before fiemap for 2.6.39).
> >>
> >> It would help a lot if you could insert this command
> >> into the test above (just before the failing cp)
> >> and show the test output again:
> >>
> >>   filefrag -v unwritten.withdata
> > =

> > Hi P=E1draig,
> > =

> > here you go:
> > + filefrag -v unwritten.withdata                                       =
                                                                           =
   =

> > Filesystem type is: ef53                                               =
                                                                           =
   =

> > File size of unwritten.withdata is 5120 (2 blocks, blocksize 4096)     =
                                                                           =
   =

> >  ext logical physical expected length flags                            =
                                                                           =
   =

> >    0       0   274432            2560 unwritten,eof                    =
                                                                           =
   =

> > unwritten.withdata: 1 extent found
> > =

> > Please notice that this also happens with ext4 on the same kernel. =

> > Btrfs is fine.
> =

> That looks like a bug in XFS :(
> I presume if you change `filefrag -v` to `filefrag -vs` that
> the output will change, and the test will pass.
> I'm a bit surprised that ext4 shows the same thing
> as there was supposedly a patch for this issue already
> applied for 2.6.39.
> =

> It would be great if we got these fixed up before
> 2.6.29 was released, so that the checks in coreutils 8.11
> were valid.

You're right `filefrag -vs` fixes the issue on both xfs and ext4.

-- =

Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

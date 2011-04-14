Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3FFuui6075886 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 10:56:57 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 280CF1B1D33E
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 09:00:19 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id F6Hwa5V2lfBH7Hru for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2011 09:00:19 -0700 (PDT)
Date: Thu, 14 Apr 2011 18:28:56 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Message-ID: <20110414162856.GA21658@x4.trippels.de>
References: <20110414102608.GA1678@x4.trippels.de>
	<20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net>
	<4DA7182B.8050409@draigBrady.com> <4DA71920.9@sandeen.net>
	<20110414160343.GA12787@x4.trippels.de>
	<BANLkTimRxvBMp9M7zwiUY_UmmFOY5N58+A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTimRxvBMp9M7zwiUY_UmmFOY5N58+A@mail.gmail.com>
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
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Cc: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigbrady.com>, linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, coreutils@gnu.org, xfs-oss <xfs@oss.sgi.com>

On 2011.04.15 at 00:21 +0800, Yongqiang Yang wrote:
> On Fri, Apr 15, 2011 at 12:03 AM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> > On 2011.04.14 at 10:56 -0500, Eric Sandeen wrote:
> >> On 4/14/11 10:52 AM, P=E1draig Brady wrote:
> >> > On 14/04/11 16:50, Eric Sandeen wrote:
> >> >> On 4/14/11 9:59 AM, P=E1draig Brady wrote:
> >> >>> On 14/04/11 15:02, Markus Trippelsdorf wrote:
> >> >>>>>> Hi P=E1draig,
> >> >>>>>>
> >> >>>>>> here you go:
> >> >>>>>> + filefrag -v unwritten.withdata
> >> >>>>>> Filesystem type is: ef53
> >> >>>>>> File size of unwritten.withdata is 5120 (2 blocks, blocksize 40=
96)
> >> >>>>>> =A0ext logical physical expected length flags
> >> >>>>>> =A0 =A00 =A0 =A0 =A0 0 =A0 274432 =A0 =A0 =A0 =A0 =A0 =A02560 u=
nwritten,eof
> >> >>>>>> unwritten.withdata: 1 extent found
> >> >>>>>>
> >> >>>>>> Please notice that this also happens with ext4 on the same kern=
el.
> >> >>>>>> Btrfs is fine.
> >> >>>>>
> >> >>>> `filefrag -vs` fixes the issue on both xfs and ext4.
> >> >>>
> >> >>> So in summary, currently on (2.6.39-rc3), the following
> >> >>> will (usually?) report a single unwritten extent,
> >> >>> on both ext4 and xfs
> >> >>>
> >> >>> =A0 fallocate -l 10MiB -n k
> >> >>> =A0 dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullblo=
ck of=3Dk
> >> >>> =A0 filefrag -v k # grep for an extent without unwritten || fail
> >> >>
> >> >> right, that's what I see too in testing.
> >> >>
> >> >> But would the coreutils install have done a preallocation of the de=
stination file?
> >> >>
> >> >> Otherwise this looks like a different bug...
> >> >>
> >> >>> This particular issue has been discussed so far at:
> >> >>> http://debbugs.gnu.org/cgi/bugreport.cgi?bug=3D8411
> >> >>> Note there it was stated there that ext4 had this
> >> >>> fixed as of 2.6.39-rc1, so maybe there is something lurking?
> >> >>
> >> >> ext4 got a fix, but not xfs, I guess. =A0My poor brain can't rememb=
er, I think I started looking into it, but it's clearly still broken.
> >> >>
> >> >> Still, I don't know for sure what happened to Markus - did somethin=
g preallocate, in his case?
> >> >
> >> > Well that preallocate test is failing for him
> >> > when the source file is either on ext4 or xfs.
> >> > He noticed the issue initially on XFS when copying
> >> > none preallocated files, so XFS probably just has
> >> > the general issue of needing a sync before fiemap,
> >> > where as EXT4 just has this preallocate one
> >> > (though I've not seen it myself).
> >> >
> >> > cheers,
> >> > P=E1draig.
> >> >
> >>
> >> well, if I simply take the preallocation step out of the testcase, it =
works fine on xfs without a sync.
> >>
> >> So I still don't know what Markus hit...
> >
> > Maybe it's delalloc:
> >
> > x4 /tmp # dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullbl=
ock of=3Dk
> > 10+0 records in
> > 10+0 records out
> > 5120 bytes (5.1 kB) copied, 0.0021822 s, 2.3 MB/s
> > x4 /tmp # filefrag -v k
> > Filesystem type is: 58465342
> > File size of k is 5120 (2 blocks, blocksize 4096)
> > =A0ext logical physical expected length flags
> > =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A0 =A0 =A0 =A016 unkn=
own,delalloc,eof
> > k: 1 extent found
> > x4 /tmp # sync
> > x4 /tmp # filefrag -v k
> > Filesystem type is: 58465342
> > File size of k is 5120 (2 blocks, blocksize 4096)
> > =A0ext logical physical expected length flags
> > =A0 0 0 26960045 16 eof
> > k: 1 extent found
> There is no preallocation in this case. Problem comes when fallocate
> and dealloc work together.

Yes, but we're still trying to find out what caused the zeros in the
binaries that coreutils installed on my system.

Now the failure only happens when I use "gold" as my linker. With GNU ld
everything is OK. But I thought this must be a timing issue, because
gold is faster and the binaries in coreutils-8.11/src are all fine.

-- =

Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

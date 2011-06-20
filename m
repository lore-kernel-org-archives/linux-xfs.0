Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5K22dFL100146 for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 21:02:39 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B6BB172B4EC
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 19:02:37 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id YzWaxw8UH4cCkGaM for
	<xfs@oss.sgi.com>; Sun, 19 Jun 2011 19:02:37 -0700 (PDT)
Date: Mon, 20 Jun 2011 04:02:36 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: long hangs when deleting large directories (3.0-rc3)
Message-ID: <20110620020236.GB1730@x4.trippels.de>
References: <20110618141950.GA1685@x4.trippels.de>
	<20110619222447.GI561@dastard>
	<20110620005415.GA1730@x4.trippels.de>
	<20110620013449.GO561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110620013449.GO561@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 2011.06.20 at 11:34 +1000, Dave Chinner wrote:
> On Mon, Jun 20, 2011 at 02:54:15AM +0200, Markus Trippelsdorf wrote:
> > On 2011.06.20 at 08:24 +1000, Dave Chinner wrote:
> > > On Sat, Jun 18, 2011 at 04:19:50PM +0200, Markus Trippelsdorf wrote:
> > > > Running the latest git kernel (3.0-rc3) my machine hangs for long
> > > > periods (1-2 sec) whenever I delete a large directory recursively o=
n my
> > > > xfs partition. During the hang I cannot move the mouse pointer or u=
se
> > > > the keyboard (but the music keeps playing without stuttering). A qu=
ick
> > > > way to reproduce is to "rm -fr" a kernel tree. =

> > > =

> > > So what is the system doing when it "hangs"? Is it CPU bound (e.g.
> > > cpu scheduler issue)? Is the system running out of memory and
> > > stalling everything in memory reclaim? What IO is occurring?
> > =

> > It's totally idle otherwise; just a desktop with a single xterm. The
> > machine has four cores (and also runs with "CONFIG_PREEMPT=3Dy"), so I
> > don't think it is CPU bound at all. It has 8GB of memory (and the
> > "hangs" even occur after reboot when most of it is free). No other IO
> > activity is occurring.
> =

> Sure, the system might be otherwise idle, but what I was asking is
> what load does the "rm -rf" cause. What IO does it cause? is it cpu
> bound? etc.

I have not measured this, so I cannot tell.

> > > > This happens on a 4kb SATA hard drive:
> > > =

> > > How does this appear to the OS? as a 512/512, 512/4k or 4k/4k
> > > logical/physical sector size drive?
> > =

> > It unfortunately appears as 512/512, but because I know it's a 4KB
> > drive, I formated it with "-s size=3D4096".
> =

> Oh, joy. Another user having strange performance problems on a 4k
> sector drive that lies to the OS about it's geometry....
> =

> > > > xfs_info /var
> > > > meta-data=3D/dev/sda1              isize=3D256    agcount=3D4, agsi=
ze=3D12800000 blks
> > > >          =3D                       sectsz=3D4096  attr=3D2
> > > > data     =3D                       bsize=3D4096   blocks=3D51200000=
, imaxpct=3D25
> > > >          =3D                       sunit=3D0      swidth=3D0 blks
> > > > naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
> > > > log      =3Dinternal               bsize=3D4096   blocks=3D25000, v=
ersion=3D2
> > > >          =3D                       sectsz=3D4096  sunit=3D1 blks, l=
azy-count=3D1
> > > > realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtext=
ents=3D0
> > > > =

> > > > /dev/sda1 on /var type xfs (rw,noatime,attr2,delaylog,logbsize=3D25=
6k,noquota)
> > > =

> > > Is your partition correctly sector aligned for however your drive
> > > maps it's 4k sectors?
> > =

> > Yes, it's a GPT partition that is aligned to 1MB.
> =

> Ok, that is fine, but the big question now is how does the drive
> align sector 0? Is that 4k aligned, or is it one of those drives
> that aligns an odd 512 byte logical sector to the physical 4k sector
> boundary (i.e. sector 63 is 4k aligned to work with msdos
> partitions). FYI, some drives have jumpers on them to change this
> odd/even sector alignment configuration.....

No, it's none of those (it's a Seagate Barracuda Green ST1500). Sector 0
is 4k aligned for sure. The odd 512 byte offset was present only on some
first generation drives. =

But I think the whole alignment issue is a red herring, because I cannot
reproduce the "hangs" on the next partition on the same drive. This
partition is larger and contains my music and film collection (so mostly
static content and no traffic). And as I wrote in my other reply to this
thread: =BBit appears that the observed "hangs" are the result of a
strongly aged file-system.=AB

-- =

Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

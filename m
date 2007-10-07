Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 10:42:22 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.176])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l97HgHhZ015538
	for <linux-xfs@oss.sgi.com>; Sun, 7 Oct 2007 10:42:19 -0700
Received: by wa-out-1112.google.com with SMTP id k22so1453023waf
        for <linux-xfs@oss.sgi.com>; Sun, 07 Oct 2007 10:42:17 -0700 (PDT)
Message-ID: <5d96567b0710071042paa1f804o5914250b1e18aa13@mail.gmail.com>
Date: Sun, 7 Oct 2007 19:42:17 +0200
From: Raz <raziebe@gmail.com>
Subject: Re: mounting raid5 with different unit values
In-Reply-To: <Pine.LNX.4.64.0710070416160.741@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d96567b0710070015j723810aag20dc3e2866868684@mail.gmail.com>
	 <Pine.LNX.4.64.0710070416160.741@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-xfs@oss.sgi.com

On 10/7/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> On Sun, 7 Oct 2007, Raz wrote:
>
> > Hello
> > I am trying to mount xfs over raid5. I am trying to mount it with
> > different values than
> > the true ones. the mount fails with a general error of :
> > mount -osunit=6144,swidth=18432 /dev/md1 /d1/
> > mount: wrong fs type, bad option, bad superblock on /dev/md1,
> >        or too many mounted file systems
> >
> > the true values are:
> > xfs_info /d1/
> > meta-data=/dev/md1               isize=256    agcount=32, agsize=5687296 blks
> >          =                       sectsz=4096  attr=0
> > data     =                       bsize=4096   blocks=181989888, imaxpct=25
> >          =                       sunit=256    swidth=768 blks, unwritten=1
> > naming   =version 2              bsize=4096
> > log      =internal               bsize=4096   blocks=32768, version=2
> >          =                       sectsz=4096  sunit=1 blks
> > realtime =none                   extsz=3145728 blocks=0, rtextents=0
> >
> >
> > this same command did work on 2.6.15  while it failing on 2.6.17 .
> > why ?
> > --
> > Raz
> >
> >
>
> Good question but also be alert that 2.6.17-2.6.17.6 will/may corrupt your
> XFS filesystem due to a nasty bug.
>
> Justin.
>
I am using patched xfs ( the patch of 2.6.17.7)

-- 
Raz

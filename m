Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Dec 2007 09:04:45 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBVH4Y5T012775
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 09:04:38 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D9334D089C
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 09:04:48 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id V5wV2w73jDTznD8i for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 09:04:48 -0800 (PST)
Date: Mon, 31 Dec 2007 12:04:17 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: raid 10 su, sw settings
In-Reply-To: <1199059239.13944.65.camel@up>
Message-ID: <Pine.LNX.4.64.0712311203220.23402@p34.internal.lan>
References: <1199059239.13944.65.camel@up>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-731421917-1199120657=:23402"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Brad Langhorst <brad@langhorst.com>
Cc: xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-731421917-1199120657=:23402
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 30 Dec 2007, Brad Langhorst wrote:

> I have this system
> - 3ware 9650 controller
> - 4 disk raid 10
> - 64k stripe size
> - this is a vmware host, so lots of r/w on a few big files.
>
> I'm not entirely satisfied with its performance.
>
> Typical blocks/sec from iostat during large file movements is about
> 100M/s read and 80M/s write.
>
> When I set this up, I did not fully understand all the details... so I
> want to check a few things.
>
> - is the partition aligned correctly? i fear not...
>        /dev/sda1   *           1          24      192748+  83  Linux
>        /dev/sda2              25       19449   156031312+  83  Linux
>
>        Is this where I'm losing performance?
>
> - What should the sunit and swidth settings be during mount?
>        I guess with raid 10 the width is 2 so...
>        sunit =3D 128 (64k/512) and swidth =3D 256 (2*64k/512)
>
>        Or maybe I should use width 1 ?
>        =FF=FF
>        Remounting (mount -o remount) with these options does not lead
>        to a noticeable change in performance. Must I recreate the fs or
>        unmount and remount?
>
> Here's the output of xfsinfo in case it's relevant.
>
> xfs_info  /
> meta-data=3D/dev/sda2              isize=3D256    agcount=3D16, agsize=3D=
2437989
> blks
>         =3D                       sectsz=3D512   attr=3D0
> data     =3D                       bsize=3D4096   blocks=3D39007824,
> imaxpct=3D25
>         =3D                       sunit=3D0      swidth=3D0 blks, unwritt=
en=3D1
> naming   =3Dversion 2              bsize=3D4096
> log      =3Dinternal               bsize=3D4096   blocks=3D19046, version=
=3D1
>         =3D                       sectsz=3D512   sunit=3D0 blks
> realtime =3Dnone                   extsz=3D65536  blocks=3D0, rtextents=
=3D0
>
>
>
>
>
>
>
>

#1 What type of performance do you expect with a 4-disk raid10?
#2 You should be able to umount/mount with the new sizes, although I have=
=20
not tested it myself b/c I typically use sw raid here (sunit/etc is=20
optimized for sw raid).

Justin.
---1463747160-731421917-1199120657=:23402--

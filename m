Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 89FEA7F47
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 17:59:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2021EAC004
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 15:59:00 -0700 (PDT)
Received: from mail-wg0-f48.google.com (mail-wg0-f48.google.com
	[74.125.82.48]) by cuda.sgi.com with ESMTP id I2V8XoOXF55vR8Se
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Jun 2014 15:58:58 -0700 (PDT)
Received: by mail-wg0-f48.google.com with SMTP id k14so7572408wgh.7
	for <xfs@oss.sgi.com>; Tue, 03 Jun 2014 15:58:57 -0700 (PDT)
Message-ID: <538E532E.7050008@gmail.com>
Date: Wed, 04 Jun 2014 01:58:54 +0300
From: Martin Papik <mp6058@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem claims to be mounted after a disconnect
References: <5363E65C.6010006@sandeen.net> <5363ECE8.6030706@gmail.com>
	<20140502233512.GE26353@dastard> <536432A0.6000405@gmail.com>
	<20140503030221.GJ26353@dastard> <538C5E67.6090005@gmail.com>
	<20140602234135.GO6677@dastard> <538D9412.3040009@gmail.com>
	<CAAxjCEzz5n85zAH5HuUQkfxKvzZt5_+cPCj3uzZR7U69H+2tDw@mail.gmail.com>
	<538DA7FF.4080002@gmail.com> <20140603212834.GG14410@dastard>
In-Reply-To: <20140603212834.GG14410@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512



>> [3096069.218830] XFS (sdf100): Log I/O Error Detected.  Shutting
>> down filesystem [3096069.218833] XFS (sdf100): Please umount the
>> filesystem and rectify the problem(s)
> 
> triggered a shutdown and told you what to do next.

Okay, here I'll pick nits. I hope you're not sick of me yet.

1) I would LOVE to unmount the FS, but how? umount /dev/xxx ... device
no longer there. umount /media/xxx ... mount point no longer there.

2) I can't rectify the problems exactly because the FS is mounted
(according to xfs_repair [ustat]), yet not mounted (according to
/proc/mounts). .... unless rectifying the problem means reporting this
as a bug. :-)

3) "Shutting down filesystem" ... isn't this when the new device
should no longer be detected as mounted?

4) come to think of it, if XFS is shutting down, why isn't it
unmounting itself?

Anyway, sorry if I'm being annoying, but I'm really really convinced
this is wrong. :-)

Martin
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTjlMuAAoJELsEaSRwbVYrzOAP/36uqrKeKBlAss8ILg9cwdtI
cXxGG7kAPCI2r+jTNCmHnMsJW4ujptVB3jllIlNPiF+oglZHEFf2bhfoYL8D5q+0
oxHiaOuvU590hBfELf+yPHNxkTPpUirhF5VymwqD+ZvV/TEjuw/VvGZ8pAU4bZHv
v4vfDX2ExCHqK3d5j7D5u5YF4wD754yTq+5Qz5L944JKubXCK2uo0xt7i3QluIMJ
dcEHPw1LXIKjjmsTZ2BaCSUwtfLGnQhGp2mHQY2Oe8KeRx8Jog7reNjazcFqI5hn
Ap6Q9ugSbtSn200e4P2pBbQOEsaHgfA9HzAQYZ6rhQk/Wrjr2I34uVxySNDn0RQk
EbjBFV04DjoiLPfff/tWvHtUNR3yZ3X0ssV5kLbfub4nPk0dMApaDI/pB8j//+Qu
4CHZgtodi//9hOFaBX9h/3vJl5aD6XddUVznZGP+0W/W2Gifev5xr+jSiUK00xk6
xLGelmUdtkq5IlFNizXZU/QcTzLW2gcB2oyW0NpoMBqEhsGCFG6IE85H/POtV7Io
otgBiWxBgxYEzGm73krja3yQlflKfuPK+SKJZue/liK5eNuIt8FRFmMH8jK/dGTc
6BMZ66Mnt2Pn7UkewLFmH0XtAPcMO7lyCEBBN0iG0s3f7Vg1T7b0tamNcaThkPt/
476Ebh9LGukDmcNXeyXo
=C9nD
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

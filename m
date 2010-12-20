Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBK08XYF026626 for <xfs@oss.sgi.com>; Sun, 19 Dec 2010 18:08:34 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 912721466A1D
	for <xfs@oss.sgi.com>; Sun, 19 Dec 2010 16:10:28 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	v0Yk8QFgv09urIPV for <xfs@oss.sgi.com>;
	Sun, 19 Dec 2010 16:10:28 -0800 (PST)
Date: Mon, 20 Dec 2010 11:10:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problem with XFS on USB 2TB HD
Message-ID: <20101220001024.GH5193@dastard>
References: <4D0C9A4F.4040108@pzystorm.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D0C9A4F.4040108@pzystorm.de>
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
To: Kevin Richter <xfs@pzystorm.de>
Cc: xfs@oss.sgi.com

On Sat, Dec 18, 2010 at 12:26:07PM +0100, Kevin Richter wrote:
> Hi,
> =

> I have an external USB 2TB harddisk with an XFS filesystem connected to
> a Debian Lenny with a 2.6.33.4 kernel.
> =

> 5 days ago I backuped my data to this external drive. While this backup
> process the USB port got reset and now all the data on the xfs is lost.

There's been garbage written all over this superblock:

> The current XFS header bytes of the /dev/mapper/backup volume:
> 00000000  58 46 53 42 00 00 10 00  00 00 00 00 1c d8 c3 a4 |XFSB.........=
=D8=C3=A4|
> 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 |.............=
...|
> 00000020  ec 24 29 ae 9c 2f 4a 75  a8 59 58 14 b5 2d 5e ac |=EC$)=AE./Ju=
=A8YX.=B5-^=AC|
> 00000030  00 00 00 00 10 00 00 04  00 00 00 00 00 00 00 80 |.............=
...|

Ok up to here (first 64 bytes)

> 00000040  98 55 e4 53 ef e6 e9 03  9a 71 4f 19 3f 8b 6f 14 |.U=E4S=EF=E6=
=E9..qO.?.o.|
> 00000050  75 d6 51 9a dd 84 53 3e  c4 80 ae a1 c2 83 53 5e |u=D6Q.=DD.S>=
=C4.=AE=A1=C2.S^|
> 00000060  69 c3 f8 1b 35 0b 15 f2  4f 15 46 42 79 6f 8b 13 |i=C3=F8.5..=
=F2O.FByo..|
> 00000070  4c 65 64 ba 38 cd 51 8b  00 00 00 00 2c f9 ac 2c |Led=BA8=CDQ..=
...,=F9=AC,|
> 00000080  47 91 80 45 73 3e 93 77  8f 95 80 81 ab 8b b8 eb |G..Es>.w....=
=AB.=B8=EB|

This is all garbage (second 64 bytes)

> 00000090  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 |.............=
...|

Might be ok.

> 000000a0  ec 24 29 ae 9c 2f 4a 75  a8 59 58 14 b5 2d 5e ac |=EC$)=AE./Ju=
=A8YX.=B5-^=AC|

Garbage

> 000000b0  00 00 00 00 10 00 00 04  00 00 00 00 00 00 00 80 |.............=
...|

Might be ok

> 000000c0  98 55 e4 53 ef e6 e9 03  9a 71 4f 19 3f 8b 6f 14 |.U=E4S=EF=E6=
=E9..qO.?.o.|
> 000000d0  75 d6 51 9a dd 84 53 3e  c4 80 ae a1 c2 83 53 5e |u=D6Q.=DD.S>=
=C4.=AE=A1=C2.S^|
> 000000e0  69 c3 f8 1b 35 0b 15 f2  4f 15 46 42 79 6f 8b 13 |i=C3=F8.5..=
=F2O.FByo..|
> 000000f0  4c 65 64 ba 38 cd 51 8b  00 00 00 00 2c f9 ac 2c |Led=BA8=CDQ..=
...,=F9=AC,|
> 00000100  47 91 80 45 73 3e 93 77  8f 95 80 81 ab 8b b8 eb |G..Es>.w....=
=AB.=B8=EB|

Garbage.

> 00000110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 |.............=
...|
> 00000120  ec 24 29 ae 9c 2f 4a 75  a8 59 58 14 b5 2d 5e ac |=EC$)=AE./Ju=
=A8YX.=B5-^=AC|
> 00000130  00 00 00 00 10 00 00 04  00 00 00 00 00 00 00 80 |.............=
...|
> 00000140  98 55 e4 53 ef e6 e9 03  9a 71 4f 19 3f 8b 6f 14 |.U=E4S=EF=E6=
=E9..qO.?.o.|
> 00000150  75 d6 51 9a dd 84 53 3e  c4 80 ae a1 c2 83 53 5e |u=D6Q.=DD.S>=
=C4.=AE=A1=C2.S^|
> 00000160  69 c3 f8 1b 35 0b 15 f2  4f 15 46 42 79 6f 8b 13 |i=C3=F8.5..=
=F2O.FByo..|
> 00000170  4c 65 64 ba 38 cd 51 8b  00 00 00 00 2c f9 ac 2c |Led=BA8=CDQ..=
...,=F9=AC,|
> 00000180  47 91 80 45 73 3e 93 77  8f 95 80 81 ab 8b b8 eb |G..Es>.w....=
=AB.=B8=EB|
> 00000190  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 |.............=
...|
> 000001a0  ec 24 29 ae 9c 2f 4a 75  a8 59 58 14 b5 2d 5e ac |=EC$)=AE./Ju=
=A8YX.=B5-^=AC|
> 000001b0  00 00 00 00 10 00 00 04  00 00 00 00 00 00 00 80 |.............=
...|
> 000001c0  98 55 e4 53 ef e6 e9 03  9a 71 4f 19 3f 8b 6f 14 |.U=E4S=EF=E6=
=E9..qO.?.o.|
> 000001d0  75 d6 51 9a dd 84 53 3e  c4 80 ae a1 c2 83 53 5e |u=D6Q.=DD.S>=
=C4.=AE=A1=C2.S^|
> 000001e0  69 c3 f8 1b 35 0b 15 f2  4f 15 46 42 79 6f 8b 13 |i=C3=F8.5..=
=F2O.FByo..|
> 000001f0  4c 65 64 ba 38 cd 51 8b  00 00 00 00 2c f9 ac 2c |Led=BA8=CDQ..=
...,=F9=AC,|

These should all be zero.

Basically, whatever happened to cause the USB reset has resulted in
corruption of various sectors of the hard drive. If you can't get
your usb drive to work reliably, then don't expect the filesystem to
stay intact.  I'd start by replacing the USB cable and probably the
enclosure, writing a pattern to the entire harddrive (e.g.
0xa5a55a5a) and verifying you can read it back without corruption or
USB resets. If you can't get your USB drive to work reliably, then
it's not a good medium for storing backups....

If that is fine, mkfs the filesystem on it and redo your backup
again.

> It is a problem with the interaction of LUKS, XFS and USB?

You are encrypting the external drive? That would explain the
garbage then - a single bit error in a sector will render it
completely incorrect....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

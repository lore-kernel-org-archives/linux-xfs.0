Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7VCPB8Z061116 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 07:25:12 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF96212D0218
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 05:36:16 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id LZxiJBPPzwWtoPuI
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 05:36:16 -0700 (PDT)
Message-ID: <4C7CF4C4.9030105@profihost.ag>
Date: Tue, 31 Aug 2010 14:25:40 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: XFS Quota Check OOM
References: <4C7BA0A0.5090202@profihost.ag>	<4C7CB0FE.1020302@profihost.ag>
	<20100831104418.058ab6b5@galadriel.home>
In-Reply-To: <20100831104418.058ab6b5@galadriel.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

Hi!

Disk Size:
/dev/sda3             4.8T  2.7T  2.2T  55% /

uname -a:
Linux abc 2.6.32.19intel #1 SMP Wed Aug 18 15:46:03 CEST 2010 x86_64 =

GNU/Linux

xfs_info /dev/sda3

meta-data=3D/dev/sda3              isize=3D256    agcount=3D32, =

agsize=3D40038461 blks
          =3D                       sectsz=3D512   attr=3D0
data     =3D                       bsize=3D4096   blocks=3D1281230752, imax=
pct=3D25
          =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096
log      =3Dinternal               bsize=3D4096   blocks=3D32768, version=
=3D2
          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-cou=
nt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

xfs_utils: Actual Debian Version:
xfs_quota -V
xfs_quota version 2.9.8

Mein Task is nothing - just to store a lot of Data once per day.

Stefan

Am 31.08.2010 10:44, schrieb Emmanuel Florac:
> Le Tue, 31 Aug 2010 09:36:30 +0200 vous =E9criviez:
>
>> Can really nobody help :-(
>
> What is the size of the filesystem, output of xfs_info, output of uname
> -a, version of xfs_utils?
> What are the main tasks of the system, memory wise?
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9QM3qBl000343 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 17:03:52 -0500
Received: from smtp-tls.univ-nantes.fr (smtptls1-lmb.cpub.univ-nantes.fr
	[193.52.103.110]) by cuda.sgi.com with ESMTP id
	4CJIWHy41GYnGdrV for <xfs@oss.sgi.com>;
	Fri, 26 Oct 2012 15:05:37 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTP id 115D7C036AD
	for <xfs@oss.sgi.com>; Sat, 27 Oct 2012 00:05:36 +0200 (CEST)
Received: from smtp-tls.univ-nantes.fr ([127.0.0.1])
	by localhost (smtptls1-lmb.cpub.univ-nantes.fr [127.0.0.1])
	(amavisd-new, port 10024)
	with LMTP id 2tiNNPrNVeT5 for <xfs@oss.sgi.com>;
	Sat, 27 Oct 2012 00:05:36 +0200 (CEST)
Received: from [IPv6:2001:660:7220:0:218f:fc6a:8268:15d7] (unknown
	[IPv6:2001:660:7220:0:218f:fc6a:8268:15d7])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTPSA id DA2E3C036A1
	for <xfs@oss.sgi.com>; Sat, 27 Oct 2012 00:05:35 +0200 (CEST)
Message-ID: <508B092E.6070209@univ-nantes.fr>
Date: Sat, 27 Oct 2012 00:05:34 +0200
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: Problems with kernel 3.6.x (vm ?) (was : Is kernel 3.6.1 or
	filestreams option toxic ?)
References: <508554AF.5050005@univ-nantes.fr> <50865453.5080708@univ-nantes.fr>
	<508958FF.4000007@univ-nantes.fr> <20121025211047.GD29378@dastard>
	<508A600C.1020109@univ-nantes.fr>
In-Reply-To: <508A600C.1020109@univ-nantes.fr>
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
To: xfs@oss.sgi.com

Le 26/10/2012 12:03, Yann Dupont a =E9crit :
> Le 25/10/2012 23:10, Dave Chinner a =E9crit :
>
> I'll try now to reproduce this kind of behaviour on a verry little =

> volume (10 GB for exemple) so I can confirm or inform the given =

> scenario .
>

This is reproductible. Here is how to do it :

- Started a 3.6.2 kernel.

- I created a fresh lvm volume on localdisk of 20 GB.
- mkfs.xfs on it, with default options
- mounted with default options
- launch something that hammers this volume. I launched compilebench =

0.6  on it
- wait some time to fill memory,buffers, and be sure your disks are =

really busy. I waited some minutes after the initial 30 kernel unpacking =

in compilebench
- hard reset the server (I'm using the Idrac of the server to generate a =

power cycle)
- After some try, I finally had the impossibility to mount the xfs =

volume, with the error reported in previous mails. So far this is normal .

xfs_logprint don't say much :

xfs_logprint:
     data device: 0xfe02
     log device: 0xfe02 daddr: 10485792 length: 20480

Header 0x7c wanted 0xfeedbabe
**********************************************************************
* ERROR: header cycle=3D124         block=3D5414 *
**********************************************************************

I tried xfs_logprint -c , it gaves a 22M file. You can grab it here :
http://filex.univ-nantes.fr/get?k=3DQnBXivz2J3LmzJ18uBV

- Rebooted 3.4.15
- xfs_logprint gives the exact same result that with 3.6.2 (diff tells =

no differences)

but on 3.4.15, I can mount the volume without problem, log is replayed.


for information here is xfs_info of the volume :

here is xfs_info output

root@label5:/mnt/debug# xfs_info /mnt/tempo
meta-data=3D/dev/mapper/LocalDisk-crashdisk isize=3D256    agcount=3D8, =

agsize=3D655360 blks
          =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D5242880, imaxpct=
=3D25
          =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D2560, version=3D2
          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-cou=
nt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0


Does this helps you ?
Cheers,

-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

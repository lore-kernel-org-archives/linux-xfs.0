Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5ECjUNC041102 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 07:45:30 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD15314A1804
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 05:51:31 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id ELA9sBEmqRadjhf8 for
	<xfs@oss.sgi.com>; Mon, 14 Jun 2010 05:51:31 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 0CAF817C
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 14:48:02 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 31DBF83C829
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 14:47:54 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_repair 3.1.2 crashing
Date: Mon, 14 Jun 2010 14:47:57 +0200
References: <201006101306.07587@zmi.at> <4C12E520.6040008@sandeen.net>
	<201006121533.36684@zmi.at>
In-Reply-To: <201006121533.36684@zmi.at>
MIME-Version: 1.0
Message-Id: <201006141448.01367@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8063089404631220657=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8063089404631220657==
Content-Type: multipart/signed;
  boundary="nextPart1746527.Gxl1BZt8Vn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1746527.Gxl1BZt8Vn
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Samstag, 12. Juni 2010 Michael Monnerie wrote:
> [167981.222861]  [<ffffffff8000c868>]
>  system_call_fastpath+0x16/0x1b                                     =20

Now it's becoming weird. I had that crash with a directory named
/disks/daten/samba/backup/uranus/WindowsImageBackup/uranus/Backup\=20
2010-06-12\ 010016/ /bigbackup/Backup\ 2010-06-05\ 010014/
and the file in there is
852c2690-cf1a-11de-b09b-806e6f6e6963.vhd

I moved that broken dir away to /, and did a new rsync. And, guess what,=20
I got the same again: the file inside this dir is broken. The 3rd rsync=20
did not make the same error, it seems good. The problem is that the dump=20
is not the same any more, as that PC made a new image in the meantime.=20
But as I got the same error twice on copy via rsync from one PC to=20
another, it looks like I triggered the error just by copying via "rsync=20
=2DaPvHAXy source destpc::dest/".

I did an xfs_metadump and just left the 2 broken dirs inside, so you can=20
easily verify:
http://zmi.at/backup-metadump-20100614-broken.bz2

xfs_repair 3.1.2 can't repair that, it crashes.

The filesystem is mounted with these options:
relatime,logbufs=3D8,logbsize=3D256k,attr2,barrier,largeio,swalloc,allocsiz=
e=3D256k

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1746527.Gxl1BZt8Vn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwWJQEACgkQzhSR9xwSCbQ7GgCfTo6JR+xPxUrlhlkqF1tAGIGq
PTwAn1deDhFrW8IyRNUuRotKOl1TqmMp
=a+aM
-----END PGP SIGNATURE-----

--nextPart1746527.Gxl1BZt8Vn--


--===============8063089404631220657==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8063089404631220657==--

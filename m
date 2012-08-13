Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7DGid2N021901 for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 11:44:39 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id Q7mlAHjLm673GuDK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Aug 2012 09:44:37 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: howto keep xfs directory searches fast for a long time
Date: Mon, 13 Aug 2012 18:44:34 +0200
Message-ID: <2561870.uQFC4XLYQm@saturn>
In-Reply-To: <5028057F.3090007@hardwarefreak.com>
References: <6344220.LKveJofnHA@saturn> <5028057F.3090007@hardwarefreak.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3438916301066845530=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, stan@hardwarefreak.com, Peter Grandi <pg_xf2@xf2.for.sabi.co.uk>


--===============3438916301066845530==
Content-Type: multipart/signed; boundary="nextPart1891292.tA8Q3eGQiF"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart1891292.tA8Q3eGQiF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

First, thanks to both of you.

Am Sonntag, 12. August 2012, 14:35:27 schrieb Stan Hoeppner:
> So the problem here is max vmdk size?  Just use an RDM.

That would have been an option before someone created the VDMK space=20=

over the full RAID ;-)

> Peter Grandi:
> Ah the usual goal of a single large storage pool for cheap.

I don't need O_PONIES or 5.000 IOPS. I've just been trying to figure ou=
t=20
if there's anything I can do to "optimize" a given VM and storage space=
=20
via xfs formatting. This I guess is what 95% of admins worldwide have t=
o=20
do these days: Generic, virtualized environments with a given storage,=20=

and customer wants X. Where X is sometimes a DB, sometimes a file store=
,=20
sometimes archive store. And customer expects endless IOPS, sub-zero=20=

delay, and endless disk space. I tend to destroy their ponies quickly,=20=

but that doesn't mean you can't try to keep systems quick.

That particular VM is not important, but I want to keep user=20
satisfaction at a quality level. About 10 times a week someone connects=
=20
to that machine, searches a file and downloads it over the Internet. So=
=20
download or read speed is of no value. But access/find times are.

I guess the best I can do is run du/find every morning to pre-fill the=20=

inode caches on that VM, so when someone connects the search runs fast.=


The current VM shows this:

# df -i /disks/big1/
Filesystem                    Inodes   IUsed      IFree IUse% Mounted o=
n
/dev/mapper/sp1--sha 1717934464 1255882 1716678582    1% /disks/big1
# df /disks/big1/
Filesystem               1K-blocks       Used  Available Use% Mounted o=
n
/dev/mapper/sp1--sha 8587585536 6004421384 2583164152  70% /disks/big1

So 6TB data in 1.3 mio inodes. The VM caches that easily, seems that's=20=

the only real thing to optimize against.

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_f=
or_.3Csomething.3E

CFQ seems bad, but there's no documented way out of that. I've edited=20=

that, and added a short vm.vfs_cache_pressure description. Please=20
someone recheck.

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart1891292.tA8Q3eGQiF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAlApLvIACgkQzhSR9xwSCbST5QCgmK1fM3AHE8Y/JXEaTzP2yrY5
/zsAnRWdE5CBcTc2qwS4r5M4CVcbaGeD
=j8an
-----END PGP SIGNATURE-----

--nextPart1891292.tA8Q3eGQiF--


--===============3438916301066845530==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3438916301066845530==--

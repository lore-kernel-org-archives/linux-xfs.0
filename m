Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8IK4khb075088 for <xfs@oss.sgi.com>; Fri, 18 Sep 2009 15:04:47 -0500
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1D12C114A72F
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2009 13:06:00 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id gcMCIfv793GoOnRU for
	<xfs@oss.sgi.com>; Fri, 18 Sep 2009 13:06:00 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: zero size file after power failure with kernel 2.6.30.5
Date: Fri, 18 Sep 2009 22:05:56 +0200
References: <200908292102.21710@zmi.at> (sfid-20090829_215558_810960_219D3757)
In-Reply-To: <200908292102.21710@zmi.at>
MIME-Version: 1.0
Message-Id: <200909182205.56647.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1423071597918967925=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Michael Monnerie <michael.monnerie@is.it-management.at>

--===============1423071597918967925==
Content-Type: multipart/signed;
  boundary="nextPart1316324.QlQuTBvcQi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1316324.QlQuTBvcQi
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Samstag 29 August 2009 schrieb Michael Monnerie:
> I have /home mounted like this:
> /dev/sda3 on /disks/work1 type xfs
> (rw,noatime,logbufs=3D8,logbsize=3D256k,attr2,barrier,largeio,swalloc)
>=20
> Hardware: onboard SATA with a single WD VelociRaptor drive.
>=20
> My power supply melted and so I had a power fail and a sudden death
> crash.
> ( So please remember: even when you have a UPS, your power can fail ! )

[...]

> But almost is not good enough: Exactly my kmail config file was 0 sized
> - obviously: at least when I started kmail, it started fresh without
>  any accounts or config, but once I exited kmail the config was created
>  with the default values and about 12KB size, while my config has
>  >200KB.

Most likely missing-fsync() issue that still could happen with XFS. Thats=20
a long discussion ;-).

Try

# KDE Sync
# http://oss.sgi.com/pipermail/xfs/2009-March/040628.html
export KDE_EXTRA_FSYNC=3D1

This environment variable didn't have any effect with KDE 3 but should work=
=20
with recent KDE versions. See also:
http://bugs.kde.org/187172

I switched to Ext4 for my work notebook in the meantime, but my Amarok=20
laptop is still using XFS. Ext4 skips delayed allocation for certain=20
cases, AFAIR truncates and renames, since kernel 2.6.30 as Linus and=20
others urged Theodore T'so to make Ext4 behave nicely with applications.=20
XFS only does so for truncates and there is a little race still, AFAIK.

In the meantime I tend to agree that the filesystem should play it safe -=20
POSIX semantics or not. But I did not completely made up my mind yet.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1316324.QlQuTBvcQi
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqz6CQACgkQmRvqrKWZhMfsoQCgqw9FRiFrbEiaiMuq+ARbO3rj
ET0AniGZJCzz65XS0NVcugY0z8ph5gmL
=KF/j
-----END PGP SIGNATURE-----

--nextPart1316324.QlQuTBvcQi--


--===============1423071597918967925==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1423071597918967925==--

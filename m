Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3RLSRmS209476 for <xfs@oss.sgi.com>; Fri, 27 Apr 2012 16:28:28 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 6GrE7rJYIdti1SyV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Apr 2012 14:28:24 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 11.1
Date: Fri, 27 Apr 2012 23:28:21 +0200
Message-ID: <17581099.Xa2dmGhCPu@saturn>
In-Reply-To: <1335383079.55171.YahooMailNeo@web126001.mail.ne1.yahoo.com>
References: <1335383079.55171.YahooMailNeo@web126001.mail.ne1.yahoo.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2392303820051065611=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Paul Jones <ntdeveloper2002@yahoo.com>


--===============2392303820051065611==
Content-Type: multipart/signed; boundary="nextPart3666988.Uqhd6af5Kl"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart3666988.Uqhd6af5Kl
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Mittwoch, 25. April 2012, 12:44:39 schrieb Paul Jones:
> I am running stock Suse 11.1, which is pretty old. Is there a way for=

> me to take the latest version of the xfs code and compile it for
> 11.1, or os there a dependency on later kernel versions/Suse versions=

> somehow? I am running 2.6-32..I wanted to get all the latest
> scalability and performance fixes..

We're on openSUSE since the beginning, and we have several openSUSE 11.=
1=20
still running, but with actual 3.3 kernels. It's possible. Depending on=
=20
your hardware, there can be some corners, but they are solveable. In ou=
r=20
case, those servers are on VMware ESXi 5, that's no problem.

Basically, just download the newest kernel, go to=20
/usr/src/linux-<version>/ and
gzip -cd /proc/config.gz >.config
(this copies your current .config), then do
make menuconfig
and change what you like/need, compile and install the kernel.

It's good to keep the old one in the /boot/grub/menu.lst, so you're=20
easily able to start that should the new one not start at first.

But this is a bit OT, so we should end it on the xfs list.

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart3666988.Uqhd6af5Kl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk+bD3UACgkQzhSR9xwSCbR49wCg5Mc3IAsBX1xWbVacGmwvQARI
gWwAnR+rvevjJnu5pDH35ukxSupPWFmb
=NZQy
-----END PGP SIGNATURE-----

--nextPart3666988.Uqhd6af5Kl--


--===============2392303820051065611==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2392303820051065611==--

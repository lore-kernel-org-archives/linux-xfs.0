Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBR6DC24003062 for <xfs@oss.sgi.com>; Mon, 27 Dec 2010 00:13:13 -0600
Received: from dal02.mx.dnspark.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 802D41531449
	for <xfs@oss.sgi.com>; Sun, 26 Dec 2010 22:15:12 -0800 (PST)
Received: from dal02.mx.dnspark.net (dal02.mx.dnspark.net [67.228.184.121]) by
	cuda.sgi.com with ESMTP id ifrmZkQILC0I1ZtN for
	<xfs@oss.sgi.com>; Sun, 26 Dec 2010 22:15:12 -0800 (PST)
Date: Mon, 27 Dec 2010 08:16:29 +0200
From: Petre Rodan <petre.rodan@simplex.ro>
Subject: Re: xfssyncd and disk spin down
Message-ID: <20101227061629.GA2275@pandora.simplex.ro>
References: <20101223165532.GA23813@peter.simplex.ro>
	<20101227021904.GA24828@dastard>
MIME-Version: 1.0
In-Reply-To: <20101227021904.GA24828@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4660457280212616640=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


--===============4660457280212616640==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello Dave,

On Mon, Dec 27, 2010 at 01:19:04PM +1100, Dave Chinner wrote:
> On Thu, Dec 23, 2010 at 06:55:32PM +0200, Petre Rodan wrote:
> >=20
> > Hello,
[..]
> > upon closer inspection it turns out that after the first Write
> > action to that partition, an xfssyncd process continues to write
> > to that partition each 36 seconds and it doesn't stop doing that,
> > even if there are no more Writes from the exterior. this keeps the
> > drive busy with varying consequences. more about that later.
>=20
> Should be fixed in 2.6.37 by the commit:
>=20
> 1a387d3 xfs: dummy transactions should not dirty VFS state

nice that someone else was also keen on having this bug fixed, but this par=
ticular fix is already present in 2.6.36 [1], [2]

unfortunately something is still written to the log every 36s, as per the f=
irst mail in this thread.

I guess we're getting closer.

[1] http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.36
[2] http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-2.6.36.y.git;a=
=3Dcommit;h=3D871eae4891a844e1fd065467b940f98dbf7aad1c


cheers,
peter


--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk0YLz0ACgkQixMPpwVd7zGMqACfeWaW8a37KFpgq9boy2Uhlexp
SZUAn2s+c38widpGyLgYqMTq7OxP3ac2
=U46I
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--


--===============4660457280212616640==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4660457280212616640==--

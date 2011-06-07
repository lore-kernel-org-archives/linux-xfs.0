Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p577hUim012518 for <xfs@oss.sgi.com>; Tue, 7 Jun 2011 02:43:30 -0500
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: bug in xfs: can't recovery metadata log
Date: Tue, 7 Jun 2011 09:43:18 +0200
References: <BANLkTinX_BO94CdQsdmj=atFc-typqr0xg@mail.gmail.com>
	<BANLkTi=y2V4ZUyP02p_r_scqdSbprjbLsQ@mail.gmail.com>
In-Reply-To: <BANLkTi=y2V4ZUyP02p_r_scqdSbprjbLsQ@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201106070943.21004@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5877819728289898438=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Drunkard Zhang <gongfan193@gmail.com>, xfs-masters@oss.sgi.com, linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>

--===============5877819728289898438==
Content-Type: multipart/signed;
  boundary="nextPart1653724.kM9ukQj4WN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1653724.kM9ukQj4WN
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 7. Juni 2011 Drunkard Zhang wrote:
> With 2.6.39.1 too, output not the same thing.

I'm not a developer, but have you tries xfs_repair -n ? As you crashed,=20
probably the xfs log is damaged, needing a "xfs_repair -L", but wait for=20
a more competent answer before you do this.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart1653724.kM9ukQj4WN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk3t1pgACgkQzhSR9xwSCbR3LQCggGekCvYKvSgMEnA7QXCP5bm7
q1QAoOOrZUa70PS2oeE7ZRTxGG9z4LIu
=Tkyj
-----END PGP SIGNATURE-----

--nextPart1653724.kM9ukQj4WN--


--===============5877819728289898438==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5877819728289898438==--

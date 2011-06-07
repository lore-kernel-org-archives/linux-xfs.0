Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p578V8xK013565 for <xfs@oss.sgi.com>; Tue, 7 Jun 2011 03:31:08 -0500
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: bug in xfs: can't recovery metadata log
Date: Tue, 7 Jun 2011 10:30:59 +0200
References: <BANLkTinX_BO94CdQsdmj=atFc-typqr0xg@mail.gmail.com>
	<201106070943.21004@zmi.at>
	<BANLkTikrmbe9X3Weyb8ikhn1RX_Tn_NuAg@mail.gmail.com>
In-Reply-To: <BANLkTikrmbe9X3Weyb8ikhn1RX_Tn_NuAg@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201106071031.02928@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6633194060776385096=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Drunkard Zhang <gongfan193@gmail.com>
Cc: xfs-masters@oss.sgi.com, Alex Elder <aelder@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

--===============6633194060776385096==
Content-Type: multipart/signed;
  boundary="nextPart9287929.ziTybSKarZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart9287929.ziTybSKarZ
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 7. Juni 2011 Drunkard Zhang wrote:
> Oops, I already did "xfs_repair -L", successed. It's in production
> environment, didn't have too much time to figure out why :-(

That was probably the only chance anyway.

I'm wondering about the crash. Even if the log is full of shit because=20
of a crash, xfs should not drive to hell but better report the fact and=20
exit. But maybe such strict checking is not worth the effort, as every=20
competent admin does xfs_repair then anyway?

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart9287929.ziTybSKarZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk3t4cYACgkQzhSR9xwSCbSIygCffq+fnymmTsywcGoOx4vrrsdb
E/0AoN/q5gfyXV5IhdJjdFGhMQRkVhdy
=pbSI
-----END PGP SIGNATURE-----

--nextPart9287929.ziTybSKarZ--


--===============6633194060776385096==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6633194060776385096==--

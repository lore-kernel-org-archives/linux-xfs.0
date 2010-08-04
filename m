Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o749FrBv026588 for <xfs@oss.sgi.com>; Wed, 4 Aug 2010 04:15:53 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 904DA1D6DB76
	for <xfs@oss.sgi.com>; Wed,  4 Aug 2010 02:16:11 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 7Mqum8cO79yDpDyz for
	<xfs@oss.sgi.com>; Wed, 04 Aug 2010 02:16:11 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
	vg/lv - xfs
Date: Wed, 4 Aug 2010 11:16:09 +0200
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
In-Reply-To: <20100804073546.GA7494@comet.dominikbrodowski.net>
MIME-Version: 1.0
Message-Id: <201008041116.09822@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9095939192444127230=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dominik Brodowski <linux@dominikbrodowski.net>, linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

--===============9095939192444127230==
Content-Type: multipart/signed;
  boundary="nextPart41331569.taeFQ0rjha";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart41331569.taeFQ0rjha
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 4. August 2010 Dominik Brodowski wrote:
> The read performance is abysmal. The ata devices can be ruled out, as
>  hdparm
>=20
> resulted in acceptable performance:
> > Timing cached reads:   9444 MB in  2.00 seconds =3D 4733.59 MB/sec
> > Timing buffered disk reads:  298 MB in  3.02 seconds =3D  98.73
> > MB/sec

Has that system been running acceptable before? If yes, what has been=20
changed that performance is down now?

Or is it a new setup? Then why is it in production already?

Can you run bonnie on that system?
What does "dd if=3D<your device> of=3D/dev/null bs=3D1m count=3D1024" say?
What does "dd if=3D/dev/zero of=3D<your device> bs=3D1m count=3D1024" say?


=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart41331569.taeFQ0rjha
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxZL9kACgkQzhSR9xwSCbTecACeIaIGfwqb9W43UiPu6DtTRiXr
RWQAn0J6cBGwcUqCSGFRDblkJA/XaA/s
=7bjv
-----END PGP SIGNATURE-----

--nextPart41331569.taeFQ0rjha--


--===============9095939192444127230==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9095939192444127230==--

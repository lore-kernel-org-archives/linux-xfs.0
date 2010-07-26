Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6Q922EU110128 for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 04:02:02 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 99D40C287A1
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 02:12:18 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id MdqWCzwbBAEAbH3I for
	<xfs@oss.sgi.com>; Mon, 26 Jul 2010 02:12:18 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 4k drives: benefits and models?
Date: Mon, 26 Jul 2010 11:05:02 +0200
References: <20100726082141.GA8239@apartia.fr>
In-Reply-To: <20100726082141.GA8239@apartia.fr>
MIME-Version: 1.0
Message-Id: <201007261105.02689@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7191379032120900501=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7191379032120900501==
Content-Type: multipart/signed;
  boundary="nextPart3044400.iNKUnuxUTx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3044400.iNKUnuxUTx
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 26. Juli 2010 Louis-David Mitterrand wrote:
> - what are the benefits of these new drives? Speed, temperature,
>   reliability?
>=20
> - what specific HD models are truely 4k for purchase right now? I'm
>  on the market for a bunch of 2Tb drives, what is a good choice?
>=20
> - what options do I need when creating my raid6 array and xfs
>  filesystem to fully take advantage of 4k sectors?
=20
ATM we are in a transition phase - there are first drives available, and=20
it will take some time until every hardware and software piece is fully=20
able to support 4K sectors. Probably all hard disk manufacturers will=20
switch to 4K sectors within the next years, as the advantage is that=20
more data can be saved onto a hard drive, and speed slightly increases=20
(when used correctly). But that will be a long transition.

It's not necessary to buy 4k sector drives, I'd only recommend it if you=20
are a techie and want to play around with it. Stay at normal drives,=20
that's proven technology and works.

=46or a hardware RAID-6 controller, it shouldn't matter, as the stripe=20
size is usually 16k or higher, which is 32 sectors (or 8x 4K sectors),=20
and as a multiple of the sector size there's no speed difference to=20
normal drives.

I use my 2 4k drives with a software RAID-0 in Linux, it's mostly to=20
play around (sometimes I'm still a techie), and get an idea of how good=20
the technology can be used already.

I have no idea about Windows support for 4k sector drives.

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

--nextPart3044400.iNKUnuxUTx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxNT74ACgkQzhSR9xwSCbShEACgsQHSNWG1NCqHBzgdxDb22ZBg
DwQAn13P1Hz7P92MZEmyRg8f54DFjyH+
=tVKq
-----END PGP SIGNATURE-----

--nextPart3044400.iNKUnuxUTx--


--===============7191379032120900501==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7191379032120900501==--

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0C7V10N229689 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 01:31:02 -0600
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id ht5j0NIb0Fls4MMg for
	<xfs@oss.sgi.com>; Wed, 11 Jan 2012 23:30:59 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: sunit/swidth for HP P4500 Lefthand Networks storage arrays
Date: Thu, 12 Jan 2012 08:30:56 +0100
References: <4F0E5E73.9070308@hardwarefreak.com>
In-Reply-To: <4F0E5E73.9070308@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201201120830.56858@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0555816455564902313=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

--===============0555816455564902313==
Content-Type: multipart/signed;
  boundary="nextPart4302986.nCAjBBFqPr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4302986.nCAjBBFqPr
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 12. Januar 2012 Stan Hoeppner wrote:
> What is the best mkfs.xfs configuration for this scenario?
>=20
> I'm guessing it would be best to simply use mostly, if not
> completely, the defaults, due to the way iSCSI packets are
> redirected on the fly to any storage node depending on load, by the
> Lefthand special sauce.

I'd use defaults. We've recently switched to a NetApp storage, and with=20
all the specialities it has also use the defaults.

> What about mount options?
>=20
> Should I use barriers with the P4500s or disable them?
> TTBOMK the internal PCIe RAID controllers have BBWC, but the ~6GB of
> RAM on the P4500 mobos isn't battery backed, but for the typical
> external UPS.  In this setup, from a physical hardware standpoint,
> iSCSI packets will be making at least 2 ethernet switch hops between
> the ESX nodes and the P4500s, with redundant links between
> everything, if that's a factor at all.

Turn off barriers, I'd say. We use the NetApp over NFS (to VMware=20
stores), and turned them off. I guess that's also correct to do.

As I understand them, barriers help to not loose blocks which the=20
storage already received, so it doesn't matter how it's connected=20
because the packets must have arrived there already. Can someone=20
confirm?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart4302986.nCAjBBFqPr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk8OjDAACgkQzhSR9xwSCbSy1ACgr8Y/5G2X/1vf5boQkpY3wZRV
958An2jkcxPUb8Zu84XkKh64F0xsERsJ
=p9Zh
-----END PGP SIGNATURE-----

--nextPart4302986.nCAjBBFqPr--


--===============0555816455564902313==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0555816455564902313==--

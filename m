Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAUDh9io011919 for <xfs@oss.sgi.com>; Mon, 30 Nov 2009 07:43:10 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 79C7814EB039
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2009 05:43:37 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id ygCBUi8WrL40kuRk for
	<xfs@oss.sgi.com>; Mon, 30 Nov 2009 05:43:37 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS & LVM: unexpected cp when issuing mv
Date: Mon, 30 Nov 2009 14:42:20 +0100
References: <200911291452.20646@zmi.at>
	<20091129232716.GC30608@discord.disaster>
In-Reply-To: <20091129232716.GC30608@discord.disaster>
MIME-Version: 1.0
Message-Id: <200911301442.20807@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8585584204111663324=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============8585584204111663324==
Content-Type: multipart/signed;
  boundary="nextPart1595429.RBePYuXen7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1595429.RBePYuXen7
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 30. November 2009 Dave Chinner wrote:
> > 1) why this happens
>=20
> It happens if you move from one project directory heirarchy to
> another - rename is not allowed across project quota boundaries as
> the moved data has to be correctly attributed to the new project.
> Hence it causes a mv to do a copy/unlink by returning a EXDEV error
> to the rename.
>=20
> > 2) how I can prevent this?
>=20
> You can't if you are moving from one project to another. If you
> move within the project heirarchy, then it will be a rename as per
> normal.
=20
Shit. So I have to turn project quotas off. I can't accept the extra=20
load for a simple move, as there are tons of data. Maybe the projet code=20
could be redesigned to allow a simple move? Is it that complicated?

If I change from project to user quota - I guess the same would still=20
happen? If so, I have to drop quota support, and build a script to check=20
quotas manually. It's a pity. :-(

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4

--nextPart1595429.RBePYuXen7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAksTy7wACgkQzhSR9xwSCbQBVQCfX8W2Rnk0JDq7YiOKwe2mJjQQ
vaQAoIa45bRnRzpkCJFe0Tgsv1a3TRye
=Qq7S
-----END PGP SIGNATURE-----

--nextPart1595429.RBePYuXen7--


--===============8585584204111663324==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8585584204111663324==--

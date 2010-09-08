Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o88NThJb071700 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 18:29:43 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A61014EE658
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 16:41:40 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id paSOThqNatXhvvsY for
	<xfs@oss.sgi.com>; Wed, 08 Sep 2010 16:41:40 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs mount/create options (was: XFS status update for August 2010)
Date: Thu, 9 Sep 2010 01:30:15 +0200
References: <20100902145959.GA27887@infradead.org> <201009081538.54488@zmi.at>
	<20100908145148.GB705@dastard>
In-Reply-To: <20100908145148.GB705@dastard>
MIME-Version: 1.0
Message-Id: <201009090130.22983@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6479083267095927087=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6479083267095927087==
Content-Type: multipart/signed;
  boundary="nextPart7663428.vXVoHdNets";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart7663428.vXVoHdNets
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 8. September 2010 Dave Chinner wrote:
> Dynamically changing the RAID array geometry is a Bad Idea.  Yes,
> you can do it, but if you've got a filesystem full of data and
> metadata aligned to the old geometry then after the modification
> it won't be aligned anymore.
>=20
> If you want to do this, then either don't bother about geomtry hints
> in the first place, or dump, rebuild the array, mkfs and restore so
> everything is properly aligned with the new world order. Hell,
> dump/mkfs/restore might even be faster than reshaping a large
> array...
=20
You're right. But there are some customers who don't want to spend the=20
money for a 2nd array, and can't afford the downtime of backup, rebuild=20
raid (takes 8-48 hours), restore. So an online upgrade is needed. We're=20
not in an ideal world.

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

--nextPart7663428.vXVoHdNets
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyIHI4ACgkQzhSR9xwSCbRXhACgjnLyPRvj3MaHqv9RlB5coNrZ
xSAAoJ2V2i3tKxiLqqf8qTyw7AQpsvGG
=fwwp
-----END PGP SIGNATURE-----

--nextPart7663428.vXVoHdNets--


--===============6479083267095927087==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6479083267095927087==--

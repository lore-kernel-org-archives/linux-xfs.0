Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3ULl1pM139828 for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 16:47:01 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14F3A14C5120
	for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 14:50:34 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id UBGlYvugBbBEHN5w for
	<xfs@oss.sgi.com>; Sat, 30 Apr 2011 14:50:34 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: RAID6 r-m-w, op-journaled fs, SSDs
Date: Sat, 30 Apr 2011 23:50:31 +0200
References: <19900.10868.583555.849181@tree.ty.sabi.co.UK>
	<20110430180213.6dcfc41c@galadriel2.home>
	<4DBC68DA.1090708@hardwarefreak.com>
In-Reply-To: <4DBC68DA.1090708@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201104302350.32287@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7065203672834555327=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Stan Hoeppner <stan@hardwarefreak.com>

--===============7065203672834555327==
Content-Type: multipart/signed;
  boundary="nextPart46599110.ylCEUtaVep";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart46599110.ylCEUtaVep
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Samstag, 30. April 2011 Stan Hoeppner wrote:
> Poor cache management, I'd guess, is one reason why you see Areca
> RAID  cards with 1-4GB cache DRAM whereas competing cards w/ similar
> price/performance/features from LSI, Adaptec, and others sport
> 512MB.

On one server (XENserver virtualized with ~14 VMs running Linux) which=20
suffered from slow I/O on RAID-6 during heavy times, I upgraded the=20
cache from 1G to 4G using an Areca ARC-1260 controller (somewhat=20
outdated now), and couldn't see any advantage. Maybe it would have been=20
measurable, but the damn thing was still pretty slow, so using more hard=20
disks is still the better option than upgrading the cache.

Just for documentation if someone sees slow I/O on Areca. More spindles=20
rock. That server had 8x 10krpm WD Raptor 150G drives by the time.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// ****** Radiointerview zum Thema Spam ******
// http://www.it-podcast.at/archiv.html#podcast-100716
//=20
// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart46599110.ylCEUtaVep
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk28hCgACgkQzhSR9xwSCbS2qQCgmp1e3wO9ylz2NKPFNZ57rb9H
yzgAoNUe2S4ZiusyaO5LqzCEYEiQcTMW
=ptPW
-----END PGP SIGNATURE-----

--nextPart46599110.ylCEUtaVep--


--===============7065203672834555327==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7065203672834555327==--

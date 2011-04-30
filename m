Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3UKXDoX137081 for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 15:33:13 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F14A15CF5A8
	for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 13:36:46 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id Ob2XNjdmgm1xTzmx for
	<xfs@oss.sgi.com>; Sat, 30 Apr 2011 13:36:46 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 3B521623
	for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 22:36:45 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id E7CBB401C33
	for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 23:36:41 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs performance problem
Date: Sat, 30 Apr 2011 22:36:39 +0200
References: <4DB72084.8020205@inf.ethz.ch> <4DB75C6D.1080901@inf.ethz.ch>
	<19898.53907.842827.480883@tree.ty.sabi.co.UK>
In-Reply-To: <19898.53907.842827.480883@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Message-Id: <201104302236.43960@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2401367912861276201=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2401367912861276201==
Content-Type: multipart/signed;
  boundary="nextPart5961636.AKCYjGzS5C";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart5961636.AKCYjGzS5C
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 29. April 2011 Peter Grandi wrote:
> Despite decades of seeing it happen, I keep being astonished by
> how many people (some with decades of "experience") just don't
> understand IOPS and metadata and commits and caching and who
> think "performance" is whatever number they can get with their
> clever "benchmarks".

Although I understand your arguing, the OP just said that with ext3 the=20
process returns after 22s, while on xfs he has to wait 2m20s to have the=20
command prompt back.

That's not a benchmark, but user experience. I'm also surprised by that=20
big difference, and given the numbers are correct I would say ext3 does=20
something "better" here than xfs. I'd guess it's only an effect of=20
caching, and in thruth the disks are still running like crazy in the=20
background. But hey, if I decompress a kernel I'm more happy if it=20
returns after 22s and I can start "make menuconfig", than having to wait=20
2m20s. The damn thing should write in the background, that doesn't hurt=20
(in this specific case).

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// ****** Radiointerview zum Thema Spam ******
// http://www.it-podcast.at/archiv.html#podcast-100716
//=20
// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart5961636.AKCYjGzS5C
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk28ctsACgkQzhSR9xwSCbTQZQCghActc1Jo3QphH/AnLYFjRBnv
1RwAn2FJDMvq2jDy9PgA8YDmJYEoz5Fg
=8gGN
-----END PGP SIGNATURE-----

--nextPart5961636.AKCYjGzS5C--


--===============2401367912861276201==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2401367912861276201==--

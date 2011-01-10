Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ADNfF4255265 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 07:23:42 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E0681484EC7
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 05:25:51 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id O7HeoFlje3aemEv0 for
	<xfs@oss.sgi.com>; Mon, 10 Jan 2011 05:25:51 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [PATCH] xfs_repair: multithread phase 2
Date: Mon, 10 Jan 2011 14:25:47 +0100
References: <1294620248-17098-1-git-send-email-david@fromorbit.com>
	<201101100857.53421@zmi.at> <20110110084122.GF28803@dastard>
In-Reply-To: <20110110084122.GF28803@dastard>
MIME-Version: 1.0
Message-Id: <201101101425.48134@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3542928119913523708=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3542928119913523708==
Content-Type: multipart/signed;
  boundary="nextPart1650099.Et3F0g51rS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1650099.Et3F0g51rS
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 10. Januar 2011 Dave Chinner wrote:
> Pretty much
> every sata disk supports NCQ these days, and default to a depth of
> 32, which means we can have 32 concurrent reads in progress at once.
> Phase 2 is all synchronous IO, so the only way to hide the IO
> latency is to queue work to multiple threads and switch between the
> threadsto work on another queue when the current one blocks waiting
> for IO.

This is interesting. Did you measure this with a rotating single disk?=20
Is the idle time between two synchronous reads bigger than the time=20
needed to move the disk head to another cylinder and read a sector? That=20
takes ~15ms on a normal disk, incredibly long compared to cpu speed.=20
Even with NCQ, the disk would have to swing the head a lot, and just=20
from thinking about it I wouldn't believe that it's faster like this.

But I'm sure you tested it so I take it as given that it's like that.=20
Cool improvement, btw :-)

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

--nextPart1650099.Et3F0g51rS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk0rCNwACgkQzhSR9xwSCbSyCACdHz+28KANhrkKs8oS88W5NstK
Kv0AmgJmVOsY12MjCcTv1vdalkJ3G8cU
=WhJO
-----END PGP SIGNATURE-----

--nextPart1650099.Et3F0g51rS--


--===============3542928119913523708==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3542928119913523708==--

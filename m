Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KB1Wr9016478 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 06:01:33 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E2991132613F
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 04:11:12 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 4mOFljbVKQcIojdo for
	<xfs@oss.sgi.com>; Tue, 20 Jul 2010 04:11:12 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Slow delete
Date: Tue, 20 Jul 2010 13:04:28 +0200
References: <AANLkTinPmhJRD3CDdsHtkLFzYd2jF9ee7gPqgO6XBSfl@mail.gmail.com>
	<201007121417.14097@zmi.at> <1279565697.1855.136.camel@doink>
In-Reply-To: <1279565697.1855.136.camel@doink>
MIME-Version: 1.0
Message-Id: <201007201304.28490@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2305289845468598042=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, aelder@sgi.com

--===============2305289845468598042==
Content-Type: multipart/signed;
  boundary="nextPart75283663.7B2g9x0SSA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart75283663.7B2g9x0SSA
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 19. Juli 2010 Alex Elder wrote:
> Assuming your single head is still in good enough shape
> to understand this, here's a high-level (though imprecise)
> explanation.
=20
Thank you Alex for the summary, but that was the part I understood. I=20
didn't understand the in-depth explanation later, where XFS internals=20
were described. But I guess it's not something I must understand. The=20
short summary is: XFS will be faster, but really shouldn't crash when=20
using delayed logging.

It will be interesting to see what happens on a busy system during a=20
crash. Deleted files will appear again, some file changes won't be=20
committed, and again the big problem: some config files might be gone as=20
the rename/recreate transaction will not be done safe via fsync, and=20
people will cry. The plus in performance might be worth it.

Can someone guess the exact problems that can happen with delayed=20
transaction on a crash?

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

--nextPart75283663.7B2g9x0SSA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxFgrwACgkQzhSR9xwSCbSs3ACbBW1BUM2yGNyjTId+2W6Uaux6
MfwAn0dRLwMEbnpP77aF/uBCiv/Vy30g
=xf3R
-----END PGP SIGNATURE-----

--nextPart75283663.7B2g9x0SSA--


--===============2305289845468598042==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2305289845468598042==--

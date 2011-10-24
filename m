Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9OGjngw090508 for <xfs@oss.sgi.com>; Mon, 24 Oct 2011 11:45:49 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C05A01EBAAD
	for <xfs@oss.sgi.com>; Mon, 24 Oct 2011 09:45:46 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id YJMQatYojr66DACl for
	<xfs@oss.sgi.com>; Mon, 24 Oct 2011 09:45:46 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 2.6.38.8 kernel bug in XFS or megaraid driver with heavy I/O load
Date: Mon, 24 Oct 2011 18:45:41 +0200
References: <20111011091757.GA32589@otto.nzcorp.net>
	<20111011133448.GA10692@infradead.org>
	<e78a7c38af135cee4b742c99ecd1c011.squirrel@shrek.krogh.cc>
In-Reply-To: <e78a7c38af135cee4b742c99ecd1c011.squirrel@shrek.krogh.cc>
MIME-Version: 1.0
Message-Id: <201110241845.44463@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5298821847046490954=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, aradford@gmail.com, linux-kernel@vger.kernel.org, jesper@krogh.cc

--===============5298821847046490954==
Content-Type: multipart/signed;
  boundary="nextPart1887112.sravnr3J3p";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1887112.sravnr3J3p
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 17. Oktober 2011 jesper@krogh.cc wrote:
> Over the weekend, we have run memtest for 4 hours (50% of the
> complete tests according to memtest) and it didnt find anything.

This is a bit OT, but you *must* run at least one full loop of memtest=20
in order to have significant output. I've had PCs that only broke on=20
test 7, and sometimes even a PC could run 2-3 loops before a bad bit was=20
found on the 4th loop or so. Only if there's a nasty error, like a=20
physically broken mainboard, you'll gets errors quickly.

Despite that, I think your problem is not memory based, as you said you=20
use ECC, and I'd believe you've turned on background scrubbing.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart1887112.sravnr3J3p
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk6lljgACgkQzhSR9xwSCbQmIwCcC1K76s65zfCBCXtiXmAx5Hms
tPsAmQGA+qWyjULB2R2eX3W8xGGLt8U1
=IXhx
-----END PGP SIGNATURE-----

--nextPart1887112.sravnr3J3p--


--===============5298821847046490954==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5298821847046490954==--

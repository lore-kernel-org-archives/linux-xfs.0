Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p05M5YSf237685 for <xfs@oss.sgi.com>; Wed, 5 Jan 2011 16:05:35 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 542961D0EF9C
	for <xfs@oss.sgi.com>; Wed,  5 Jan 2011 14:07:41 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id ZSlgp4e5ZS3O6Wjg for
	<xfs@oss.sgi.com>; Wed, 05 Jan 2011 14:07:41 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs: add FITRIM support
Date: Wed, 5 Jan 2011 23:07:35 +0100
References: <20101125112304.GA4195@infradead.org>
	<20110103232514.GF15179@dastard>
	<alpine.LFD.2.00.1101051105120.3095@dhcp-lab-213.englab.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.1101051105120.3095@dhcp-lab-213.englab.brq.redhat.com>
MIME-Version: 1.0
Message-Id: <201101052307.38379@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0241467482660919816=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Lukas Czerner <lczerner@redhat.com>

--===============0241467482660919816==
Content-Type: multipart/signed;
  boundary="nextPart6264039.utRq0FKL5I";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart6264039.utRq0FKL5I
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 5. Januar 2011 Lukas Czerner wrote:
> If we
> notice that we are running out of space in advance (how much in
> advance?), we can start trimming smaller chunks, until we reach
> reasonable a reasonable pool of reclaimed space, or until we trim
> the whole device.

Would it be possible that all blocks that have been in use since the=20
last FITRIM run can be logged? Like this, we would only need to clean=20
those. If you have a 2TB volume, probably only 25% of it have been=20
rewritten (=3D500GB) since the last run, and of that maybe 80% are still=20
in use at the time we run FITRIM, so only 100GB would need the cleanup.
Maybe each AG could store a bitmap of written blocks, that are reset by=20
a FITRIM run. That could be an asynchronous written bitmap and shouldn't=20
disturb performance too much. Maybe it's even only needed to store a bit=20
per sunit*swidth blocks, to keep that table small. A mount option could=20
be used to enable that feature, so only those which use thin=20
provisioning or SSDs or similar devices enable it at wish.

Especially for 100TB size devices that seems like something that should=20
be thought of, as maybe if you run FITRIM once a week there, only <10TB=20
have been rewritten, if at all, and such a table would boost a FITRIM=20
run a lot.

But maybe this is just bullshit of my tired brain, and I'm not a dev so=20
I have no idea how hard it would be to implement that.

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

--nextPart6264039.utRq0FKL5I
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk0k66oACgkQzhSR9xwSCbTPQQCePaTJgyVeTouFU2CEzBNl2t84
I3oAoIwSXbxQIvHxywdrFn5uef0fqwm4
=lssH
-----END PGP SIGNATURE-----

--nextPart6264039.utRq0FKL5I--


--===============0241467482660919816==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0241467482660919816==--

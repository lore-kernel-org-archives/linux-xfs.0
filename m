Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7VM6nw4085424 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 17:06:49 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9DD75407BA
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 15:07:25 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 4KBJQvkkYB4jt9qQ for
	<xfs@oss.sgi.com>; Tue, 31 Aug 2010 15:07:25 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id E365B602
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 00:07:24 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 97E89401C2F
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 00:07:24 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 4K drives, sectsz=512, bsize=4096
Date: Wed, 1 Sep 2010 00:07:20 +0200
References: <201008300956.21264@zmi.at> <201008312301.38103@zmi.at>
	<4C7D7141.4070406@sandeen.net>
In-Reply-To: <4C7D7141.4070406@sandeen.net>
MIME-Version: 1.0
Message-Id: <201009010007.23899@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5627730084169894422=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5627730084169894422==
Content-Type: multipart/signed;
  boundary="nextPart4209108.hUK4E06rom";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4209108.hUK4E06rom
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 31. August 2010 Eric Sandeen wrote:
> Just be sure your first sector of your top-level block device
> is 4k aligned, and then yes you'll want to set sector size to 4k
> so that xfs will do all log IO in 4k blocks as well.

I can only hope LVM does it right, I have no idea how it aligns.
=20
> If you do it right (and especially vs. if you do it wrong) it should
> be a bit faster if all IOs are 4k aligned on the disk.
=20
And that's what's interesting me: why? Won't XFS do all I/Os at minimum=20
for a given block size? Or is it possible XFS does write only a single=20
sector? I'd expect the smallest I/O size to be the block size, but it=20
seems I'm wrong?

I guess there's no way to "convert" an existing XFS with=20
sectsz=3D512,bsize=3D4096 to sectsz=3D4096,bsize=3D4096? Maybe that's only =
a=20
flag that can be changed?


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

--nextPart4209108.hUK4E06rom
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkx9fRsACgkQzhSR9xwSCbT4/wCfW/7qzxALjUrvTGIaNMC95krJ
muQAn2x5yQ2SoDRQMpOs3tKwHWZRvzbE
=1wnB
-----END PGP SIGNATURE-----

--nextPart4209108.hUK4E06rom--


--===============5627730084169894422==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5627730084169894422==--

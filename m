Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7QHK1WW025705 for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 12:20:12 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D14A83FF229
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 10:20:40 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id G8yJ674xSAZGTKDc for
	<xfs@oss.sgi.com>; Wed, 26 Aug 2009 10:20:40 -0700 (PDT)
Received: from mailsrv.i.zmi.at (unknown [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 779AF538C
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 19:20:36 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 626C3400166
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 19:20:36 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: disk performance strange/low
Date: Wed, 26 Aug 2009 19:20:36 +0200
References: <200908172311.07660@zmi.at> <200908180408.10738@zmi.at>
	<20090818024350.GA3591@infradead.org>
In-Reply-To: <20090818024350.GA3591@infradead.org>
MIME-Version: 1.0
Message-Id: <200908261920.47054@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8908697021400585368=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8908697021400585368==
Content-Type: multipart/signed;
  boundary="nextPart1640778.TIoIjraX38";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1640778.TIoIjraX38
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Dienstag 18 August 2009 Christoph Hellwig wrote:
> On Tue, Aug 18, 2009 at 04:08:05AM +0200, Michael Monnerie wrote:
> > On Montag 17 August 2009 Christoph Hellwig wrote:
> > > Yes, that sounds like the problem of the VM not feeding us enough
> > > pages to write. ?What kernel is this on? ?Latest 2.6.31-rc has a
> > > workaround for it.
> >
> > 2.6.27.23-0.1-xen from openSUSE 11.1
> > I can't switch as I use it with the free Xen. Thanks for the info.
>
> Try backporting commit c8a4051c3731b6db224482218cfd535ab9393ff8 from
> mainline - it should apply just fine to a 2.6.27-ish kernel.

Thank you. I'm not a patcher, could you tell me how to do that?

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart1640778.TIoIjraX38
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkqVbu8ACgkQzhSR9xwSCbT4lQCaA2iy+tQ3JeHwt6cGMLjDZ+aJ
I+AAoONKjM8qNCL7D/cKwHhjDdET3We6
=Vtv+
-----END PGP SIGNATURE-----

--nextPart1640778.TIoIjraX38--


--===============8908697021400585368==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8908697021400585368==--

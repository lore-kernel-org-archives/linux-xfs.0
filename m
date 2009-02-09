Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n198ZeDh234696 for <xfs@oss.sgi.com>; Mon, 9 Feb 2009 02:35:42 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48ADFFD21E
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2009 00:35:01 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id kV2jtbJ6GEWHd9ty for
	<xfs@oss.sgi.com>; Mon, 09 Feb 2009 00:35:01 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id A310E3E74
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2009 09:34:59 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 2D599400160
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2009 09:35:00 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Does XFS support the sync mount option?
Date: Mon, 9 Feb 2009 09:34:59 +0100
References: <884979c90902050643m78d2e0dbt85aa7f4369e243ef@mail.gmail.com>
	<20090206230502.GQ24173@disturbed>
In-Reply-To: <20090206230502.GQ24173@disturbed>
MIME-Version: 1.0
Message-Id: <200902090934.59738@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5387797638980187275=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5387797638980187275==
Content-Type: multipart/signed;
  boundary="nextPart9027189.6jedKY3HOG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart9027189.6jedKY3HOG
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Samstag 07 Februar 2009 Dave Chinner wrote:
>>  I would be interested to know whether it is reasonable to use XFS in
> > the way I have outlined.
> No, it's not really a reasonable way to use any filesystem.

But what would be? Of course people will pull out an USB stick/drive=20
wihtout unmounting, and it should be save anyway if
1) disk write cache=3Doff and/or barrier enabled
2) they wait until the light of the USB stick/drive stops blinking after=20
copying the file onto it. That usually means it's finished.

There will be logs about problems, because it's not a nice way to=20
shutdown the filesystem, but it should be safe I'd say.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart9027189.6jedKY3HOG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmP6rMACgkQzhSR9xwSCbQ+twCfVaiIFVwg/nqinyOeU2xHmXSf
M5MAnR20A+19pZG0TuvIuZbNsiolPDYh
=Cqxz
-----END PGP SIGNATURE-----

--nextPart9027189.6jedKY3HOG--


--===============5387797638980187275==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5387797638980187275==--

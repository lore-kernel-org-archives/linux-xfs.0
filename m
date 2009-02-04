Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n14F44An157782 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 09:04:05 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4AD4D18C21D7
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 07:03:24 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id AGsPVHKFBalvOIbt for
	<xfs@oss.sgi.com>; Wed, 04 Feb 2009 07:03:24 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 273183D47
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 16:03:23 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id E9CA8400171
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 16:03:22 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_force_shutdown after Raid crash
Date: Wed, 4 Feb 2009 16:03:22 +0100
References: <498376CF.8020806@renderforce.de> <200902041127.46714@zmi.at>
	<20090204122625.GM24173@disturbed>
In-Reply-To: <20090204122625.GM24173@disturbed>
MIME-Version: 1.0
Message-Id: <200902041603.22541@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3215244644591558857=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3215244644591558857==
Content-Type: multipart/signed;
  boundary="nextPart4131192.kjtSvqH3vs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4131192.kjtSvqH3vs
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Mittwoch 04 Februar 2009 Dave Chinner wrote:
> > What just comes to my mind: what about XEN/VMware?
> >
> > What settings should be used within a virtual machine? Even if I
> > have battery backed cache and nobarrier on the host, the VM itself
> > could crash, or the whole host freeze. Is "nobarrier" save within a
> > VM?
>
> Depends on the implementation of the hypervisor.

OK, so we don't know?=20
I guess VMware will be the most used for Linux systems, and XEN usage=20
will soon grow a lot as it's directly in the kernel now. Does anybody=20
know for those two, whether "nobarrier" is save/needed/a bad thing?

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart4131192.kjtSvqH3vs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmJrjoACgkQzhSR9xwSCbTDcwCgs4dPquiLURx2rdkfCEm5Crye
srsAniOxT5NISyvo7jDBkn23mQ2bUsN2
=hccy
-----END PGP SIGNATURE-----

--nextPart4131192.kjtSvqH3vs--


--===============3215244644591558857==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3215244644591558857==--

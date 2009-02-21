Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1L93itf234924 for <xfs@oss.sgi.com>; Sat, 21 Feb 2009 03:03:45 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 25F851BC0549
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2009 01:03:10 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id lH6CunDOuCIWFoJj for
	<xfs@oss.sgi.com>; Sat, 21 Feb 2009 01:03:10 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id F1E4541E0
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2009 10:03:09 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id EB2B840016F
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2009 10:03:09 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS and XEN
Date: Sat, 21 Feb 2009 10:03:05 +0100
References: <20090217091124.GA7118@infradead.org>
	<93532303b1bb223328b2aaf712e0022f@webmail.zmi.at>
	<20090219193552.GB22736@infradead.org>
In-Reply-To: <20090219193552.GB22736@infradead.org>
MIME-Version: 1.0
Message-Id: <200902211003.09474@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6492044984343564831=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6492044984343564831==
Content-Type: multipart/signed;
  boundary="nextPart1503621.2zNR0j5RLF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1503621.2zNR0j5RLF
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Donnerstag 19 Februar 2009 Christoph Hellwig wrote:
> Barriers are disabled using hdparm. =A0To make sure qemu/kvm doesn't
> cache your image file specify cache=3Doff on the command line
> specifying that virtual disk.

I have "nobarriers" for XFS, and a RAID controller with writeback cache.=20
The "cache=3Doff" seems to be for kvm only, so doesn't help me with XEN.

> make sure you do not cache the virtual block device in the host
> pagecache, and that in doubt the write cache of the disk is turned off
> as barriers most likely won't work through the virtualization stack.

Isn't that what "tap:aio" in XEN does?

I really want and need to find a secure way to run XEN clients. Is that=20
data loss I had the fault of XFS, XEN or something else?

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart1503621.2zNR0j5RLF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmfw00ACgkQzhSR9xwSCbRDKwCg0a8ZwTcNwmWOr/cIcPIOmQSD
8moAn1Y8IfEV4R/pHG7gLdMXie2AQlW/
=cc+/
-----END PGP SIGNATURE-----

--nextPart1503621.2zNR0j5RLF--


--===============6492044984343564831==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6492044984343564831==--

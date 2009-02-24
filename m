Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1OF5ZPO150111 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 09:05:35 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70F3A1994BB2
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 07:05:03 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id pjjjPvxDVyPWfWtE for
	<xfs@oss.sgi.com>; Tue, 24 Feb 2009 07:05:03 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id DA0DA4288
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 16:04:30 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 0374D400174
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 16:04:30 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS and XEN
Date: Tue, 24 Feb 2009 16:04:24 +0100
References: <200902170959.55077@zmi.at>
In-Reply-To: <200902170959.55077@zmi.at>
MIME-Version: 1.0
Message-Id: <200902241604.29566@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0795217156157677486=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0795217156157677486==
Content-Type: multipart/signed;
  boundary="nextPart2185654.PKAF2mE20u";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2185654.PKAF2mE20u
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Dienstag 17 Februar 2009 Michael Monnerie wrote:
> Now I'm sure that the following configuration can destroy a
> PostgreSQL 8.3.5 database:
>
> * Linux host with XEN, XFS filesystem with "nobarrier", RAID
> controller with battery backed cache.
> * XEN vm with XFS filesystem with "nobarrier" with postgresql
> * your daughter with 3.5 years switching off the power supply of the
> server

I got this answer on the XEN list. It looks like XFS in not very secure.=20
Do you share that opinion? I am still searching for a way to make sure=20
the above never happens again. Should I use ext3/reiserfs/ocfs2 within a=20
XEN domU, or is it not the fault of XFS my database got destroyed? Don't=20
want to blame anyone, but I need a secure environment for the machines=20
that should be in production soon, don't have time to recover databases=20
or whatever just because of a crash.

from XEN list:
********************************************
if you don't have highly reliable hardware, with redundant channels and=20
battery backed caches, etc. stay away from XFS.

it's a pity, but XFS is only as reliable as the hardware you give it. =20
in other words: you can be really sure that a software issue won't trash=20
your XFS filesystem; but also that a hardware failure definitely will.

ext3, OTOH, might not have such an impressive record of correctness; but=20
it's designed with redundancy in mind.  almost all vital structures are=20
either replicated or reconstructable from other hints.  that makes fsck=20
slow but effective, and in most cases, the journal analysis done when=20
remounting after an unclean shutdown is enough to put it back on track.

i sure wish i could use XFS in more circumstances, but the needed=20
hardware is prohibitive.
********************************************

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart2185654.PKAF2mE20u
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmkDH0ACgkQzhSR9xwSCbT4OQCgqxJbHaSSqvIjKoeDEXAHD0Pi
QfsAoLGO1ZAte3UJ7pEo7fCAGJyF3U8n
=HJ5+
-----END PGP SIGNATURE-----

--nextPart2185654.PKAF2mE20u--


--===============0795217156157677486==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0795217156157677486==--

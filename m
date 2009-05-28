Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4S9AExA245226 for <xfs@oss.sgi.com>; Thu, 28 May 2009 04:10:15 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 476861A34774
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 02:10:25 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id IDfbAQ3dFFZwnQXU for
	<xfs@oss.sgi.com>; Thu, 28 May 2009 02:10:25 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217106033.dyn.cm.kabsi.at
	[81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 7ABB353AF
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 11:10:23 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 1F73240DC06
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 11:10:23 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Incorrect Free Space / xfs_growfs on RAID5 Volume ?
Date: Thu, 28 May 2009 11:10:14 +0200
References: <BC442FE9-64FC-4F3C-A5AA-25C890AABD3C@fiton.is>
	<4A1BE48F.9020107@dermichi.com>
	<59D949A6-71F6-4C4C-B5F9-B5B22B189771@fiton.is>
In-Reply-To: <59D949A6-71F6-4C4C-B5F9-B5B22B189771@fiton.is>
MIME-Version: 1.0
Message-Id: <200905281110.22697@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4326692677041697493=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4326692677041697493==
Content-Type: multipart/signed;
  boundary="nextPart2312739.B8rEvcBCie";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2312739.B8rEvcBCie
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Mittwoch 27 Mai 2009 Svavar =D6rn Eysteinsson wrote:
> Is there a simple way for me to check if my kernel has this option =A0
> compiled in ?

gzip -cd /proc/config.gz | grep CONFIG_LBD
if your kernel provides /proc/config.gz

> And the FINAL question.... Is there any way for me to alter the raid
> =A0 volume, partitions to GPT or just format the /dev/sdb without
> loosing any data ?
> Maby it's just not possible without backup up data, and restore'ing ?

I googled this once, and found the anser "no". If you find a solution,=20
please post it, I'd be very interested in it.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart2312739.B8rEvcBCie
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkoeVP4ACgkQzhSR9xwSCbRFQQCeMHgfvVSsb8gcVreyIcY6R49c
YRUAoKJQfVsgypKdtQLW8RuSVYk72b6A
=dvKK
-----END PGP SIGNATURE-----

--nextPart2312739.B8rEvcBCie--


--===============4326692677041697493==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4326692677041697493==--

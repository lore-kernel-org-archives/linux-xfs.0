Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Sep 2007 07:44:48 -0700 (PDT)
Received: from amanpulo.fs3.ph (amanpulo.fs3.ph [72.51.42.241])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l82Eih4p012910
	for <xfs@oss.sgi.com>; Sun, 2 Sep 2007 07:44:45 -0700
Received: from localhost (localhost [127.0.0.1])
	by amanpulo.fs3.ph (Postfix) with ESMTP id 8E7E61E0D5953
	for <xfs@oss.sgi.com>; Sun,  2 Sep 2007 21:46:50 +0800 (PHT)
Received: from amanpulo.fs3.ph ([127.0.0.1])
	by localhost (amanpulo.fs3.ph [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id dCbeMq+GSUE3 for <xfs@oss.sgi.com>;
	Sun,  2 Sep 2007 21:46:41 +0800 (PHT)
Received: from auctoritas.local (unknown [222.127.47.132])
	(using SSLv3 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by amanpulo.fs3.ph (Postfix) with ESMTP id D832D1E0E08B5
	for <xfs@oss.sgi.com>; Sun,  2 Sep 2007 21:46:40 +0800 (PHT)
Subject: Re: ZFS, XFS, and EXT4 compared
From: Federico Sevilla III <jijo@fs3.ph>
In-Reply-To: <1188513751.24970.109.camel@edge.yarra.acx>
References: <1188454611.23311.13.camel@toonses.gghcwest.com>
	 <1188457666.24970.94.camel@edge.yarra.acx>
	 <20070830132002.GA4086@infradead.org>
	 <1188513751.24970.109.camel@edge.yarra.acx>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WuH1W4y6xpJyStAd+cd0"
Date: Sat, 01 Sep 2007 23:07:23 +0800
Message-Id: <1188659243.4430.8.camel@auctoritas.fs3.ph>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--=-WuH1W4y6xpJyStAd+cd0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-31 at 08:42 +1000, Nathan Scott wrote:
> Possibly.  Far more importantly for XFS, there really needs to be some
> way for RAID drivers to say "even though I support write barriers, its
> not a good idea for filesystems to enable write barriers by default on
> me".  Enabling write barriers everywhere, by default, seems to have a
> far worse impact than any mkfs/mount option tweaking.

On all my systems with software RAID or dm-crypt (or both), mounting XFS
gives me a message about barriers being disabled because the underlying
device doesn't support it. For good measure I disable write caching on
all my systems with either software RAID or dm-crypt (or both).

Am I reading the thread correctly that even with this message showing
up, I still need to mount with nobarrier explicitly to improve
performance?

I also think it would be nice to add something like a modern-day tuning
FAQ for XFS. I know there's a bit on the FAQ already but perhaps it
needs an update?

Thanks.

--=20
Federico Sevilla III
F S 3 Consulting Inc.
http://www.fs3.ph

--=-WuH1W4y6xpJyStAd+cd0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG2YAr5rCBSJO3Rr4RAkH6AJ9sUGdQkS8qnaoY/Cb6i51vRtVTvgCZATVY
l9LKoNVPbMi16yxXZ7Nx8uI=
=Ymg2
-----END PGP SIGNATURE-----

--=-WuH1W4y6xpJyStAd+cd0--

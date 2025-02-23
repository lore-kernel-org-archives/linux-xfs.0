Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A68376F1
	for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2025 08:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740299833; cv=none; b=OB7IW8etoYp6anj6UuD4fQCSCkitX1HQXNi77I0T6qCpMpg8/w07qXhX1PBtTZQFDXcFH+fRbCR5TJlywt1rCZafJucLbbvVMryHyAjGphI0/mCI/KoN4ncMcJMCS444Rkdxb9bzz39lGvuTJxQnp0BEsLfiG4UCqP4wanYbmJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740299833; c=relaxed/simple;
	bh=6rz45HIb056NdnfPIVHbbppVRpll5FC9XsVShzI9S70=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=q+Uw/ZSf9wPbllT/VbS9LGTJkdYvt7MEq4JqT4qTpq548hN3xxm6luhwSOERk5tqwHxlWG86izfGyK2RJ1+eEFBGg2Q1VGnGDozOOyHMApLo3OWk73iVvTHFzGa0gqobHArutifkeZkohof0+xjNuqd+QjEML0OerHhrPsJulec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=Rwo0Not8; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="Rwo0Not8"
Received: from [192.91.235.231] (port=54560 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1tm7Ty-007ZXZ-EK
	for linux-xfs@vger.kernel.org; Sun, 23 Feb 2025 08:37:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=JKePPsy93oShciYpXMfy1jnXQsOXicIpiHf0DHOjZMs=; b=Rwo0Not8dEOsLwSsWW47B3kMAP
	TKx9XyV2i4Aeq9Ms4Dd73bFJZ16F1+Bcbxpu7s0NNJ9rVT0qIlF4BMyLK0hYAnyBeVjMpvWBaVcpu
	sreiNhAVADYgAuuUJxNFq20UEuKKdtWM3Qq46bQiz0wzxEve1/3sf6TkcMv/AMZ0LHzRjRt+7xJQ0
	FqjvaCMOxs17KkWw8OV5a+xo1E1xQJB3J8rBv+os6NtzoYHcvsfP9PwDVts9TJgRMtGk5aTHo43Hi
	z9Tww5KqtNvTakCb9MS6mLBGLq5kwcLJMi0NQ2N7scrCr2SwgrTKoO7jT6+wIPdj6VrYV0bkjDoz3
	ZsD4lUlw==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1tm7Tu-00DbEo-99; Sun, 23 Feb 2025 08:36:58 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: Anibal Monsalve Salazar <anibal@debian.org>,
 XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.13.0-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.13.0-1
Debian-Architecture: source
Debian-Suite: unstable
Debian-Archive-Action: accept
Precedence: bulk
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: xfsprogs_6.13.0-1_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============1523317811657548471=="
Message-Id: <E1tm7Tu-00DbEo-99@fasolo.debian.org>
Date: Sun, 23 Feb 2025 08:36:58 +0000

--===============1523317811657548471==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Sun, 23 Feb 2025 18:45:28 +1100
Source: xfsprogs
Architecture: source
Version: 6.13.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Anibal Monsalve Salazar <anibal@debian.org>
Changes:
 xfsprogs (6.13.0-1) unstable; urgency=3Dlow
 .
   [ Nathan Scott ]
   * New upstream release
Checksums-Sha1:
 ad64ea32ac1a5ca25369c9985822038347099c9d 2198 xfsprogs_6.13.0-1.dsc
 31d4f7ab5d84c6322375b17b10970be649afa7a7 1506676 xfsprogs_6.13.0.orig.tar.xz
 0bd730a7c8cdb904cb9f5311697d6ad6451469f9 13528 xfsprogs_6.13.0-1.debian.tar.=
xz
 d15c9574172f8c2edd6fa9631f99aec542e9366b 7655 xfsprogs_6.13.0-1_amd64.buildi=
nfo
Checksums-Sha256:
 63b0048f09ac497852ef0af6d4d29407c74ba24bfa7481e9a9b3bae20454818b 2198 xfspro=
gs_6.13.0-1.dsc
 0459933f93d94c82bc2789e7bd63742273d9d74207cdae67dc3032038da08337 1506676 xfs=
progs_6.13.0.orig.tar.xz
 9221825afc4cdf27efcfb45fad111aab05a8dd505cc8597425e7132d1664acd0 13528 xfspr=
ogs_6.13.0-1.debian.tar.xz
 cd3461494c301e44e0b9dae99c0d6dc8fbd1b248148fbfbc3684b43f5448d144 7655 xfspro=
gs_6.13.0-1_amd64.buildinfo
Files:
 c4bc3853e3b9ce846f15a8ac4b47e21d 2198 admin optional xfsprogs_6.13.0-1.dsc
 42b00213982d16c6df3fc17a0706b773 1506676 admin optional xfsprogs_6.13.0.orig=
.tar.xz
 41d539d5991fbacc4484869523758382 13528 admin optional xfsprogs_6.13.0-1.debi=
an.tar.xz
 d4fef531bf932820a7b55d8edfb9880e 7655 admin optional xfsprogs_6.13.0-1_amd64=
.buildinfo

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEExgRcgTiHt3wt/5elfFas/pR4l9gFAme601MACgkQfFas/pR4
l9i2uBAAxHGLYsBqzMalo2Z5wBhv8faXj2qEZXl3oYdNqssBbmSGL5JcQU0bkvwH
9Cvn6htUlLWtrdplzWvI5vFst8WkYvZau7x9BTXd38z8ANOh9PFldeUABwEOTxl6
s6LXA2xsfWfcwp+XlTRDhWw9aTqiddfah/WWQ0Pq1gfx5KRykCpMv1vssYvFkPLa
5u5jB6G05rWN/NSPxWwvbPGugRdPN7Oqs+8oMLL0aSrhltJOEyKPdRY0J25YTEGF
DAbQmQeREtW8AwAfWd0nKa7zvSapBhCg16JnyJwC6ewZ2XqNM5Hlv1/CeJoT8bTi
/p2IfzUFaM0A4P+ndCArPFNwhC47rRuDS5z+JqwkqY/xoUrW14hloprLCLUzvrYf
lsZ+qYVaP6biXzp0TQL/OEyZ8RQVw8YP7mbLxrLfooqpMklF/F96GW1/7PfoRoqj
CCKuGmIGisOwEwodmMb27KKEu834x5nAiZ6d6BqsmjArlf2ls+8YxPkVc/v+IKMV
0OWL0QN3qRLWVpi9DuBKuSCHwMN0nq6AYm4Xcv/ujzUEm0Tt8nlLIxJhlyvJ4mES
/ZPcTfIuWCxeou6eNI4XE6WKmmb9VxIHfSp9AqFzgnpVjZOfP71XadsE5ZZK4O37
cfzAYEg3/Smo/Hz9x0eVn491Ba+ff4Oqm2aRlAKpZzpK/syZ+00=3D
=3Dj6pI
-----END PGP SIGNATURE-----


--===============1523317811657548471==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCZ7reKgAKCRCb9qggYcy5
IfRIAQCBFfYehsCLb9TL0hhI+QmIIc8/mxdmi4PXIOEBGbjWAAD/cJS2yVloQPEm
MjlUGnsQ2ybHc/PYgH6wBPHLKechsgM=
=8ERt
-----END PGP SIGNATURE-----

--===============1523317811657548471==--

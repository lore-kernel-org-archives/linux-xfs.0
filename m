Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ACF51120F
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 15:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782607; cv=none; b=Nircq3Zm1uNPwc5e01eKJxUSJT0SuIpxwBc9iT8jmf2tgBSH4OLBJiHPlW/18DT/ekv9+asJMHnP21BJoH91jvczvyvXvKqlmuaB7vIjF5/180snIXXOIfoGkrFSSCqFNdFS42l0kI2JGjCrpz3ut4Q4YibhbKPjkIon7REkNz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782607; c=relaxed/simple;
	bh=epU9CgPs/xYvIgZZaUYhQFzV6qzgIA685M9E+ETEL7U=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=HxtvIW+mEVtqj5Zl2hn8dRvnIK+J7ZvOShU3kwNnSnlIh+XLewal5FOBpAJviByzGwpWynfM7p2ohrAitERX39kup2GF+D973sw1GDHsg4JKnYAMTl8TO2BhpWK6+r1Rz0SiuVhLNge0q6qZQCJa3MpRZ9laMFg0RDLe2qaoiYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ftp-master.debian.org; spf=pass smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=m87s21Pu; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="m87s21Pu"
Received: via submission
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1xBwMA-00CPx2-0y
	for linux-xfs@vger.kernel.org;
	Wed, 30 Sep 2026 15:36:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=/Jxc690/tNvv3hsOIcB9Nfipw0H7jnBsjJ2in1dBApU=; b=m87s21Pu3Sd9rGZXv2aYm5YRhs
	MMM7CWTpWqiNqBuni86FTlPOw8YZ6sy5RxZSSOznVRpsaUR3nIyjGu5AfveW/11VX09pw1T2FEZjr
	DjWicVLU2WtsVchwpA2Jhv0WpqmVcOqUZKvyPSM5UHvr1T16mLl2pQM3N3D0p3TUzJ23+XClhFO0y
	vkDbSuTDOCXCRApcGDqohIZoR6iV1VlVtd3Hc+vD50uQfTkcIuRbYgIwot3YtQWQKjn7La8fQb72C
	KJ3GWaZAKF+EOXUcXAvhylc0H2LIwJIwzsYsfNoYHdpymfJwT3+QuFRrQCPEXn807cHVAm2rog5Nd
	eypBTFwA==;
Received: from dak by fasolo.debian.org with local (Exim 4.98.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1xBwM6-0000000D3l3-2Gf6;
	Wed, 30 Sep 2026 15:36:26 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: <bage@debian.org>, Nathan Scott <nathans@debian.org>,
 XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_7.2.0-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 7.2.0-1
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
Subject: xfsprogs_7.2.0-1_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============0280979636866161193=="
Message-Id: <E1xBwM6-0000000D3l3-2Gf6@fasolo.debian.org>
Date: Wed, 30 Sep 2026 15:36:26 +0000

--===============0280979636866161193==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Wed, 16 Sep 2026 13:11:30 +0200
Source: xfsprogs
Architecture: source
Version: 7.2.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (7.2.0-1) unstable; urgency=3Dlow
 .
   * New upstream release
Checksums-Sha1:
 63f8e2c8059222a517698b4072e8195361869ded 2148 xfsprogs_7.2.0-1.dsc
 13fc430318d41e8dec218ba8f9637e9adb54fba9 1599484 xfsprogs_7.2.0.orig.tar.xz
 54a0ace3e9ce13b17f2291e3dec90ac58b0d1b44 12304 xfsprogs_7.2.0-1.debian.tar.xz
 3830cdb161d57d63c8dd4f3f1a041251a402a048 5140 xfsprogs_7.2.0-1_source.buildi=
nfo
Checksums-Sha256:
 f8b4a00f6dc130285baecdf79cf48fa4fb247f54d0ec28c285c6e952e42597ca 2148 xfspro=
gs_7.2.0-1.dsc
 501dfa363cd8e19997a4a1a71f70ded88241b45e9db233e8875c23b80520cc83 1599484 xfs=
progs_7.2.0.orig.tar.xz
 691b183783d5b1f8ad82e246316295a6e1f1472190d3ba402b7a60cf0d39c6bb 12304 xfspr=
ogs_7.2.0-1.debian.tar.xz
 b84529a90b8e4c53e6e35789dc8e7a6bc66a56cc160d0c301cd0415df9443db9 5140 xfspro=
gs_7.2.0-1_source.buildinfo
Files:
 fb848a8eb24f71a08d91c16afb7b4d2d 2148 admin optional xfsprogs_7.2.0-1.dsc
 6837d20d00079e6cee40b663c9bf50d7 1599484 admin optional xfsprogs_7.2.0.orig.=
tar.xz
 9b788011df7fca94721360d240fe2c18 12304 admin optional xfsprogs_7.2.0-1.debia=
n.tar.xz
 6f369da074620e05a67502ab64601b38 5140 admin optional xfsprogs_7.2.0-1_source=
.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmq9JlUQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFJZODADE2QVozWzGHDygL6l2lLh8roRnBnshmQ5B
nb8++zwDh5B2O/zxQtlblOcf31vaP8jakFXRwQZvhDhCY4uQjzBRPhbE3e7RwQnq
yHIJXcgTF95xIEje/VBB97EB903FXezJTXKDuNqwg7yce4joKgIOIJm139C+YoUQ
AXuS2ZJpcTZfo9wKCS9Axl7GAjVwRAHFhurvoctfdnRfV/TL88US1A1yh4qEPABH
4vFkfASIFcfKjABfnjyNhS3buWc7BZYlKd57eHJvmsfLllnxq7LdZV/q8+PiWelx
wmhGo3JU21e5kbp5YvuBjPOSpdIk11kV5spIQ5EuBOV4du/mpxXIUkK3z4mFGnz2
mefWKehx77qIkHVOkoNtdygH7bGlSVBeeBJ91CRAJwc8kmMw4Bk/jCGDPYXyj9GB
blXE67wgwG8iwbB7ZwVFM6DtZH4DCpoVSvJdwLiRNKOAwF4WmM8bCUPevgDcHsmR
q/t0W9VIRYVUHk3TAnd+43nxH8gY/hw=3D
=3DTkRZ
-----END PGP SIGNATURE-----


--===============0280979636866161193==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCar0segAKCRCb9qggYcy5
ITSXAP0a0+RoBVqe3vXq3dRX866R4cmkWEeHQUPIFmbv3rWtMAEA6hq/FCyjEfnd
8Q+OQxdhED4SEKJoLuycypQkRUb+agA=
=NtMW
-----END PGP SIGNATURE-----

--===============0280979636866161193==--

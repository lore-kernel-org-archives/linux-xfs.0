Received: from muffat.debian.org (muffat.debian.org [209.87.16.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9162054E1
	for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2025 15:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740323490; cv=none; b=oqb/wqtfRsPunIxFXnTA65grfF6R7fCyaBnevl6aTFXZUycBWJyujgBQYbB90nnWwVKGdwf7nOxFsAY4owzyGiFKSbr4RteJFI1O9JvRDKXvv549NaAsH8DSHDpflbblItBld01RF3kMRnObn8nN3W7PSWsArO2klHXRMp4q0TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740323490; c=relaxed/simple;
	bh=fqx/CzjGkY1JLnSjfe27sjdET+GHr25Bg8BqIGLp7b4=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=MGHJ9k5Xl3tU71UEIpgFvvvdOn1GK5Yt49WQtZl2nFjd+C8j/r8/hcpjW2ypL7p2hkWnRmespvyh3HNsmAQDhqsu/y2VQjAyPyYSTArf9v10hHYlZBljluDEQA9bMbeSzrcGhjuEtVVJeDWjz2E1ZV8LMEoX6FOWGhqoF10Z47I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=Mxboz+ae; arc=none smtp.client-ip=209.87.16.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="Mxboz+ae"
Received: from [192.91.235.231] (port=50066 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1tmDdf-005vdr-DD
	for linux-xfs@vger.kernel.org; Sun, 23 Feb 2025 15:11:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=u353mwYQEK1U3nGb2caQ+GV9QY4eyqg6At/BnbiOZdw=; b=Mxboz+aevdMPGXqnesx3/iEm/H
	kcmMsJPakABaSGNATtmU+sETqzgnvUI/EZOjLgFyLttQRHFpf9lesneiT9kL2t3sXFXhfLXgF8b7I
	wLmZIkbNMZJDJC6q8zH4c1dXnW3uV6IYgi2tCNQHPM1oe7JLOoSIV6BSzOOJzLVa0szRltr4mvzXM
	q1eB1HiTOjmWJNdn+3D23JYHC2MP2TlEWW/8S/mNnks3G8qa93tdE5zej2n4EuHnxHSrqvuqFN6eR
	flZA1vaYppKqaq53G/gvwCyFiMM+8mgi6JxdWSvnniaZFAlU6MKe0eybdRKZwTAEeYyJrEesV7otl
	USIJUNaA==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1tmDdd-00Esne-3X; Sun, 23 Feb 2025 15:11:25 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: XFS Development Team <linux-xfs@vger.kernel.org>,
 Bastian Germann <bage@debian.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.13.0-2_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.13.0-2
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
Subject: xfsprogs_6.13.0-2_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============7144654639967051485=="
Message-Id: <E1tmDdd-00Esne-3X@fasolo.debian.org>
Date: Sun, 23 Feb 2025 15:11:25 +0000

--===============7144654639967051485==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Sun, 23 Feb 2025 14:32:04 +0000
Source: xfsprogs
Architecture: source
Version: 6.13.0-2
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bage@debian.org>
Changes:
 xfsprogs (6.13.0-2) unstable; urgency=3Dmedium
 .
   * Patch: mkfs: Correct filesize declaration
Checksums-Sha1:
 92eb36614ab4bd378f1ed33b55f2beea946b20ff 2048 xfsprogs_6.13.0-2.dsc
 d08caf1c5d09080e9ca978b1ee9e99900c3ebe61 13996 xfsprogs_6.13.0-2.debian.tar.=
xz
 2bfc66d50ded3724dd493053b1502f5887a3f908 6059 xfsprogs_6.13.0-2_source.build=
info
Checksums-Sha256:
 cbd59967d673d5ee50f77b72d998a46dd2888710471a1fc824da32fc836ee61b 2048 xfspro=
gs_6.13.0-2.dsc
 36a6e2cd26939cd22ae584b440ced0cdffdcea6851f121cb0d5204800671f97c 13996 xfspr=
ogs_6.13.0-2.debian.tar.xz
 95c5f423913d96f179cd58abd40146faf65da26bee2dd5b52c124827aa849b43 6059 xfspro=
gs_6.13.0-2_source.buildinfo
Files:
 0928d3a2db5da22c95ac0d5c6cc01eec 2048 admin optional xfsprogs_6.13.0-2.dsc
 f7b30c69faf4279b0c7a3be2222a6add 13996 admin optional xfsprogs_6.13.0-2.debi=
an.tar.xz
 94f2b1d6a43e2bfb9e615c43c62f8739 6059 admin optional xfsprogs_6.13.0-2_sourc=
e.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAme7NB8QHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFKDtDADSgOKRjpCrDkFsaquI4zzFVD5j9Z23yMxr
kbayVUzM2BVkKZ33ehB5uweiqniTSwjjEhdors5MabsxVJd2SDaNQ+xEanJxaRSu
9UDGgl1KfwJqpSGY6yC5SY4utzVXKXAvHzv+REh2kak51TYaDYW+gbhYkjhBUs10
dtmEPX4yaQCMIRd0XVPf/LkfSYvHwP9BnPsIGvZi3jzjbAJpQOYBqnXB+giDJ2xz
42PgmtjDMuFVQA1UyjhWfUoS+d4sYAtakAGa5FEVI+4jjGMImecf9eNaGq/dhQeA
n7s2EuY0tmGAwy4LtE+3V77zV5B0uf86W7mp5e6MPQ+AGKJ8V5qXYiP5Jhg7Op24
583qnNsafi8kUG7ZbH+vHBAKnB52CB+oggUD5xeW9D+yZdhF7rVw/Rb/182xI5uu
ulzkau+kr+rCCLXhyFuCuLk2cuFXZJxz6Y/iqVhB23UvaBmup69xXWLunFmu1i1C
1pcw6g/f0BeziJ5cBFzQLprda12hqtE=3D
=3DC9Bv
-----END PGP SIGNATURE-----


--===============7144654639967051485==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCZ7s6nQAKCRCb9qggYcy5
Id8OAQCOq43/I7SL7C4Jkx65cRxZNDj3SBHhrdf/w7sNG/SWigEAoHKabd+Zv77z
qoRcexSJcUg85qwJUvEYGLHJa5URMAw=
=Fskb
-----END PGP SIGNATURE-----

--===============7144654639967051485==--

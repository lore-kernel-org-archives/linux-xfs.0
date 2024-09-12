Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7855D186E58
	for <linux-xfs@vger.kernel.org>; Thu, 12 Sep 2024 07:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726127367; cv=none; b=Y9xetAaUzFP8SRKIkl3tdnuE4bhBkT+kJNBNaaFOkpXT1LuNferV6HdC/HPNyM4c1ro7i8ENKRK+b7NceZvXeWxWE8XobyGvtoQY6Z0bY6jbfYeVFcI7R2+M6PUiAXt8mig1E6uZwmeU5TsvHgQgcntbv/5198s8nf6C9/g2ZjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726127367; c=relaxed/simple;
	bh=9s/Lfd4QTWmwxB35Q3To5LWDKMk0DP6uRy4PNDSgBG4=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=lFrg/JBF7Gyhj+CXZeT+sXZtKBB+1+af24WW0waO/Blbhf6Hl4S0rygv1vymxZWelWcQQgJSJCdAzga3FRqK2iUpaAAd2z/v2pJTfJ0TW0491Xh9oZQGtrQRZwMZC3IO80iHc7geo4ThFVWCEtO4AMpfDFp2IZSosjr8YXcvwNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=NzJ0MwBM; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="NzJ0MwBM"
Received: from [192.91.235.231] (port=50350 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1soeZw-006rQu-Js
	for linux-xfs@vger.kernel.org; Thu, 12 Sep 2024 07:49:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=ghtUhrEE8Ve1wuP874x1QGp2wcPbG1FMzvkw2Q3F/oA=; b=NzJ0MwBMMTk8vflSg2p4rlOjVp
	TAaaZ5Jhp8fBgT40LuwQfITLQ0nfiy64BR1JAtuHJ6yp/9qH33X15te8DR+k2p/Q9U5+uqJ+tzeUV
	xH0qhKwXCdil7d+hasCJqvldUUPaMKw7YM2cv//bmEd1OnfMjgxc8uYmfLGzqm+nDm7g+4Ffkzj4a
	9SOTc3AVtgheh3onKAMqSeb2FcAEBcOGCNPAgkmvEGDAxiE3gsWqFW3qeFG69AKkz5bEA4MMS7KYL
	ErUX6gumWL+zhWpxdmjQsidOPLq8jNIsamdMX5EkM4YBnAHGFa3O+C8qMxzX8aCs4J+MZgjfKpkV+
	/LBG2jLQ==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1soeZr-00B2CM-Fj; Thu, 12 Sep 2024 07:49:19 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: <bage@debian.org>, XFS Development Team <linux-xfs@vger.kernel.org>,
 Nathan Scott <nathans@debian.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.10.1-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.10.1-1
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
Subject: xfsprogs_6.10.1-1_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============3981214592972766885=="
Message-Id: <E1soeZr-00B2CM-Fj@fasolo.debian.org>
Date: Thu, 12 Sep 2024 07:49:19 +0000

--===============3981214592972766885==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Wed, 04 Sep 2024 14:00:00 +0100
Source: xfsprogs
Architecture: source
Version: 6.10.1-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (6.10.1-1) unstable; urgency=3Dlow
 .
   * New upstream release
Checksums-Sha1:
 3da01271cf00b0ad7be2972fea3e52a7675b6d49 2039 xfsprogs_6.10.1-1.dsc
 adb625ea852c8d9c80a22618892c7c9311417d54 1449932 xfsprogs_6.10.1.orig.tar.xz
 8106a8a3be97123d0aa860b56dbc2aa616a464e5 13460 xfsprogs_6.10.1-1.debian.tar.=
xz
 7b30fa442095e1d4bfbdccb52b3b26eb3cef9109 6169 xfsprogs_6.10.1-1_source.build=
info
Checksums-Sha256:
 f3eba12a60694aea2b12fccdf08d2ec1ab5ae364ffa6cb18adb67a8a1a54fbb5 2039 xfspro=
gs_6.10.1-1.dsc
 6cb839be1a9535f8352441b3f6eea521ead5c5c7c913e8106cdfac96aa117041 1449932 xfs=
progs_6.10.1.orig.tar.xz
 fc2819d518083cd9d3e3df669c88ad00fbd39280cafcae576605c0dee902e94b 13460 xfspr=
ogs_6.10.1-1.debian.tar.xz
 855c618021a91dd12260fb90b880bac62bb505eb6702ce9a8305cd21f1bd3bf7 6169 xfspro=
gs_6.10.1-1_source.buildinfo
Files:
 0e7cf3571fff4ea07f2b19ed12d02216 2039 admin optional xfsprogs_6.10.1-1.dsc
 d1ae9f461cedf440473d422bf8407efa 1449932 admin optional xfsprogs_6.10.1.orig=
.tar.xz
 ee15a4d13a7e850c463fe26a58aa008f 13460 admin optional xfsprogs_6.10.1-1.debi=
an.tar.xz
 3daaf8df2382d7c67a49c8e982b6005f 6169 admin optional xfsprogs_6.10.1-1_sourc=
e.buildinfo
-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmbil1sQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFAOnDADzFmBcIsn1zvfjGL9LSdemnVcj9i1HjKqh
1r38szDhRkcl9l/YU2M29D5qzcK7lMxZY1+1UKHdUgRm1mtLWnKcuMnwfo5BDprr
OUZzBeevvZ/MKMqNlc+YUgLJS8wQROJYpp79eEyHtlFgjrs2asV2g64K4rGPA8TL
3ljk8En3HRF9QYmvr6Sob0TYpqdUJ9uK2ZcZGe94gdhV55coiQwhVIwKtuAdQJ6z
9yzJV9RvUIRK5AASCeASGcIrS1aYltzsLWsbv/QusGU/kXWH2VytxyKIPyDqBDvX
KWCdHvc0LqWCtb3N4l20nXWpNQyKJwPyPbEw94Jnm6UGCeBzElMy6ytJGaCO5wU9
NHNvqv9CDaqUaKwug8bp/bX3SsCdxHSh7o5F5LQoO3Em6+r23r57v/N6KbZEQp4T
SKdhZwmvkzilh8WRtkrDRbW8C5yHihkDQVvlPHzzvnKpJSbKlct2zAJKeMmlrL5b
l7OosniIpgy+l+Zd6MCOJ6EHleo1EFU=3D
=3DHR97
-----END PGP SIGNATURE-----


--===============3981214592972766885==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCZuKc/wAKCRCb9qggYcy5
IVpGAPwNtVKxRH4xGcIkeL7d3PuswtJ5g778n3QWJ5Egrs4jkQD/ZICCniq76QFq
U8ZBJp0r77/KRdAYx1RYb8/Mxcbi2g0=
=PaqW
-----END PGP SIGNATURE-----

--===============3981214592972766885==--

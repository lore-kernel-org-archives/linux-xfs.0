Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77F4230268
	for <linux-xfs@vger.kernel.org>; Sun, 31 Aug 2025 20:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756672627; cv=none; b=OtUq5GFkZcXg2v3nGXgov1VrM6SU36lLMxpKRAPOVGnUCsvNI25d24jLFq23mXHUZfS4vPQHiFMa2aIYvjcuEvkA+d0fVjm++NROZahCO415FmGN0uz9EjE+N5cuYHlMrPupvZOBH15QZzLKxCvpTZsKZ8OIJz5nWgFdipdu0VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756672627; c=relaxed/simple;
	bh=k1gnOQy/BhX84JGI25xQvvJWY5tyj2M1pMd8WOv826U=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=YidUZ09xzMY0vBI+Quo/kOsT2FcFkaTRW/OI2wYNtAklF4ljnXzHRT/wNODL2klmEPU6TVEKmnGsywGKIsZB83GPKrtOEjUerjHoHN2JwScpMv8Y22fKL4EjI5uzwhrHruruTo+xW5xOrPuICQJ7ToUYjAV6G0yIzzof06fBGa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=QTjLURfF; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="QTjLURfF"
Received: from [192.91.235.231] (port=54120 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1usonP-006RpQ-RG
	for linux-xfs@vger.kernel.org; Sun, 31 Aug 2025 20:37:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=g2krv3e1MITUDlQGgwCQbxAM/0RfvJKFCEtAA1svJzk=; b=QTjLURfFmp7xnm+v16bunrkWjE
	KSRKyB39dkeifOlVKXmVHqZbqzgZDDxCrnN06Ui3eHnYpKOaZ5RO5XdXgdr08p/niPSvvrqTDb1mU
	2lRRmZS1MuFNQQ+Mr93dtwaTlyqxfDyq/Nh50r4trHx8Zuyh/PQW9LbxLdK037wq8CekltNk7CF1A
	fmxUVj3hXvkLWteGpmCY64Ogvz/rijucP3FcmL7mpsa/CiUpJbHXRM/YkPkmSLI8CeKjfQUKeucph
	8HZhDikfHLicdW0P1uV2/LcyQMckuy7wX/MTGMjXXMOovYNxBVS0cJyOwEbK6C+agTK0Om2KNzLy/
	I/rBWpAw==;
Received: from dak by fasolo.debian.org with local (Exim 4.96)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1usonM-00317b-2E;
	Sun, 31 Aug 2025 20:37:00 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: <bage@debian.org>, XFS Development Team <linux-xfs@vger.kernel.org>,
 Nathan Scott <nathans@debian.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.16.0-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.16.0-1
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
Subject: xfsprogs_6.16.0-1_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============4431543996303626594=="
Message-Id: <E1usonM-00317b-2E@fasolo.debian.org>
Date: Sun, 31 Aug 2025 20:37:00 +0000

--===============4431543996303626594==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Tue, 26 Aug 2025 20:27:13 +0200
Source: xfsprogs
Architecture: source
Version: 6.16.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (6.16.0-1) unstable; urgency=3Dlow
 .
   * New upstream release
Checksums-Sha1:
 201133cab5580cb5be4db60ca5ef0a24b529bc49 2048 xfsprogs_6.16.0-1.dsc
 63cfd9d1b0acf117567107df361df7e9ed8a1c40 1557452 xfsprogs_6.16.0.orig.tar.xz
 8da45579b1f305654c3059f1712f892ec64ea3ce 11996 xfsprogs_6.16.0-1.debian.tar.=
xz
 a9825931f952ec42f0621b15d0359e356d53417a 5400 xfsprogs_6.16.0-1_source.build=
info
Checksums-Sha256:
 baabfdd329497bcd043a0e4591cfceefd4302e5224128fb0ab149c541d6e63b1 2048 xfspro=
gs_6.16.0-1.dsc
 fa7ba8c35cb988e7d65b7e7630fe9d0e17e8d79799d3b98db7e19f2b9b150506 1557452 xfs=
progs_6.16.0.orig.tar.xz
 c513cf32425c65887ea7dc9f2951724518a6879a0fa17d65043b6fd0887c1d71 11996 xfspr=
ogs_6.16.0-1.debian.tar.xz
 ac00b4429da14e1498fd5763c7bc1ce3042835d41697fb68ea4b35c2389cab73 5400 xfspro=
gs_6.16.0-1_source.buildinfo
Files:
 25463ce2316779a93c908370fedfe847 2048 admin optional xfsprogs_6.16.0-1.dsc
 5d1efa7dc863d4b0e9db3dab5c78be45 1557452 admin optional xfsprogs_6.16.0.orig=
.tar.xz
 79786e5fe71c283ac24281723c88b1f2 11996 admin optional xfsprogs_6.16.0-1.debi=
an.tar.xz
 44c05e63745af3f7f9af8198bd1ad5a6 5400 admin optional xfsprogs_6.16.0-1_sourc=
e.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmi0pcwQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFAPJC/95KAQphbjatzNeT4Ej/8B+1CXONbEr7N3H
bLC+Q+OuKApvQoyxP0BzhC5vw4nD8MIqSFY45dFzNHS6Nw9IPqmE9ib1ZRb+Mjii
uyeC3j3awQVGaZGKV9JwEBUS/AStByMP8Lo9OrqfPJUa5i/FkOpS+yrE70CaShWD
xF9+etXzuZMuGvkGjWJ5X+Cs0/2kJn1V9e7qOwf+reVVCQ+6/CQN29Ao2Ds23pWU
HOTjcVEX6T0lvltq2EsM4+fDO3wtrxsdLfVVvYZeywnj36qR8TyTSaypZQcXycoE
s1/vBYNA6eqYvEtRzziT9xAUI4BNrCeJE9qAJXO+IETy3F2p/asI8f5Ek/BWRlSi
Ds17ppukwPZDYW/KItyzkPMKQglEXuOb+sQtSRBnXgF06zelVGzeSkeYPt/j6YER
Qzb/jeyRUzWRq4wuYkPE8vW5W4cRf6iTB4XojPIWKKM/tnKZ6RWykfQiKMPgAmGb
a8XigFbDNPkM6i9Sh0siV6P0ROoE8FY=3D
=3DmUKf
-----END PGP SIGNATURE-----


--===============4431543996303626594==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCaLSybAAKCRCb9qggYcy5
Ic17AQCBLzSEjzIydCOM1MElIcSRsbtS0aZeVWOe1SBBvwtGqQD7B2zM6IMpEYh3
eG9diXOSGBpyVayvkuDBwmZOIz3ghw4=
=TLzA
-----END PGP SIGNATURE-----

--===============4431543996303626594==--

Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F1C15217B
	for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 16:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718641390; cv=none; b=qM0E9WRNYTTeuwlQyM4Ctq1jTmBvqcsLPQpmS5nYUUVPAZzuL/yb9kamkUPE810P+A0LHjmtKeu58obavG4AvKSfytu51Q/PG00115QITjqk4m/bFwMyL+UxKfpfTSyDGqcu+wJwrkwi3GjV8t4A7WY2ZAUmVNyYDrGyXVnGdf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718641390; c=relaxed/simple;
	bh=ONQzirn9Qde7uL+Y1odGkfMHwT1U2yp1dC327VnfzZI=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=fES5Qj+AaF2Loy8EOKmQzQp0EBsDfXIl/VsxltVYshQzMeyHkPIkyrbNcuMOoPm1Qayp4xL6cA0f7VXIAk0jT23Vn/7kVmzlrTuExPY+6H5wlGL9l3kDz+snDo3SIEBbo3ALhMUYDbXxrpQ0N7CMHUmkebVhj8/SpyBzzb8G8v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=UFJGj/vf; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="UFJGj/vf"
Received: from [192.91.235.231] (port=59504 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1sJF8G-00EN1o-WE
	for linux-xfs@vger.kernel.org; Mon, 17 Jun 2024 16:23:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=Zqz89B8KsiiqWHzojF2HaPNo2jk/MvAEm42uTEBRWcU=; b=UFJGj/vfY7Zb0iWMetWZe2pIud
	x6Mpk8lfD4VP9qcyYQJ8UY+uW5ZySTrcRCh5SYDNnhEx6kknR9s3WmAkb02ChAWKvmiv6fxUFU3w0
	mXGY3A8pG2FGGfHfqu1NsD27acSz0e0PTj0OiF10AmXpfiyrh64yu8Ou0RicpLhrEkxuh6gz+yDAL
	tVIxE5/7B/8meFsg0IHVlSIzyZspSNwbpLC3f20Rf1BAdGS3E+PdyMdjGsguo5IZ880m1kBqg3fmd
	mvQJhZQwq7zthx8NajXms//Ai/XmmRApbDJ3GbnDPv5b8RGXslD5UAl7yRktzFT4U8gteLBNQkAEz
	nI4ezaNQ==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1sJF8E-0002nY-FF; Mon, 17 Jun 2024 16:22:58 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: XFS Development Team <linux-xfs@vger.kernel.org>,
 Chris Hofstaedtler <zeha@debian.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.8.0-2.1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.8.0-2.1
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
Subject: xfsprogs_6.8.0-2.1_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============4007159559922598559=="
Message-Id: <E1sJF8E-0002nY-FF@fasolo.debian.org>
Date: Mon, 17 Jun 2024 16:22:58 +0000

--===============4007159559922598559==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 1.8
Date: Wed, 12 Jun 2024 17:50:50 +0200
Source: xfsprogs
Architecture: source
Version: 6.8.0-2.1
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Chris Hofstaedtler <zeha@debian.org>
Closes: 1060352
Changes:
 xfsprogs (6.8.0-2.1) unstable; urgency=3Dmedium
 .
   * Non-maintainer upload.
   * Install all files into UsrMerged layout. (Closes: #1060352)
Checksums-Sha1:
 6f80ee2eb415c1717f9d0156a369bfa1cb8b9389 2192 xfsprogs_6.8.0-2.1.dsc
 a970eace1d63f2dc5236f8c8d913d132c1270667 14644 xfsprogs_6.8.0-2.1.debian.tar=
.xz
 56f65b5049ed4fce8fc862a49f476e051b50dfbd 7392 xfsprogs_6.8.0-2.1_arm64.build=
info
Checksums-Sha256:
 fd74481d928bf432c1373593c607a484cfe4193f50c90a706e53232478edd276 2192 xfspro=
gs_6.8.0-2.1.dsc
 1d2d6cf2053c0a6b09d8da0458837cef664732187696f309b02a91d20add90d0 14644 xfspr=
ogs_6.8.0-2.1.debian.tar.xz
 fd92ba7b95f5291cde6240ac2e5f3149daa427381e78d990c6808b552d44843b 7392 xfspro=
gs_6.8.0-2.1_arm64.buildinfo
Files:
 2dafece8c9173dc0905a4fbff94ae617 2192 admin optional xfsprogs_6.8.0-2.1.dsc
 f6578101e58c8438720e933446b62a56 14644 admin optional xfsprogs_6.8.0-2.1.deb=
ian.tar.xz
 7153a8d78762454fcd4104a685f753d7 7392 admin optional xfsprogs_6.8.0-2.1_arm6=
4.buildinfo

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEfRrP+tnggGycTNOSXBPW25MFLgMFAmZpxRwACgkQXBPW25MF
LgPYjg/+KtmnrAGGBBSywkEWchtrTbywgmADuAZtEYLsnPeKpV3sN3cHaELdIyuo
MOZqyO7CAqctZw/rZUyR8Q1MHNKJK33U5uLX5STH5KFIWf94r119Lh+api/TkrFv
yNmJa9Sc8tNZu9maNivUs/yjpdA1vPHq1jc/A261KA+FCxU22KdUQABnEiR7uCJy
BDyPcZeua31a3G2DCHi/EtOqPa6XqXUNM4qND2bxOxplf77f/6Su/CS3fNMNVJNF
tEci6e8j5THwW2Nb56b79xLF4ssjh/yhM3QkkCWj/EgkdMQg6d7Xh9FQ3YagaHSv
T/P9UturIqj3F2XPBL+HslS98pwZRsVCi2k/QddxWP/o7g2VNub47BXn5+VhWyxd
GSSZEF7gabkZYv6V1wB9Yp7Dx9BGQl8MU5W8HIyaVcemEh17iwxcL9Y+ijWtlwLB
ymQgNRjNb5bWAvbCaA7TYq5/3FP1JBz8ySLuSMO+8wAKaESbouyFkAoAgUiPF1HJ
YbTXiLKaXr6u8cypgIjasdDiDRdQMwd2P7GOwN3kY8Oa2jrgDiUwiMspAaLqN/F9
JiFalvXqfRO266SnU5DAg7OTKauNs6Z+8VDHLFytq5UAn5LDoqeWx09v9PDHQBtS
5r+jKp9SZIs+44e8Ettiv2Ahcg1xS/BaLXkC5rx13w1lD4aScxI=3D
=3D+TID
-----END PGP SIGNATURE-----


--===============4007159559922598559==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCZnBi4gAKCRCb9qggYcy5
IbavAP453vjGBve2NuJqVCk93LfkQJQaRfUVGDCblbACGpC62gD/XHGFHoMFbXwO
vThfMHrMLSxYDH+iI2y/ekFFB2lk7Q4=
=zxfc
-----END PGP SIGNATURE-----

--===============4007159559922598559==--

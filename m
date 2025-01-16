Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF741DE2AD
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 13:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737033515; cv=none; b=XHKWaa/5sephnJsAVksnc+gwSQjZuG2SvJFLqVUGIVGvpcfuv9tHtpnZa8Niy/HV/lvNbqVt93w/Ye7gG9Cct+d/8gMeGzptwXsBi48LoEMKPX03wCFcjnXQVNEhQAkB5npLNbQG0a0fP0foTsluC8sGSSycnyNqhLy/AKL/HrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737033515; c=relaxed/simple;
	bh=dxSPitmFCtvwr/C9BnMXgejRuDL9H8xQcWqPk19N6fM=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=i4knS4/7aQCABGAeaoIl33/AKniAhNN/D4ZG30HnhUGSPGmMRpEgK3O/KzTKXaVA4a4eJjmHMqO21/Zmf+M2TCUv6Dte287eAefmAW8UKUIw9DSNLjBvMDQ0ePJ5HKqKXQ0uVx+iAavoldQQYy4RoHQVZmNBNZ/mdt9bBzgP8NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=OrOd7qUE; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="OrOd7qUE"
Received: from [192.91.235.231] (port=58380 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1tYPlQ-001N8D-Ng
	for linux-xfs@vger.kernel.org; Thu, 16 Jan 2025 13:18:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=FW8g3AeAsbZnVrpkmbEA5kGqqN+z0LF5w4IJY+h+JUY=; b=OrOd7qUExg5Wc7AvDSTk2ScxhV
	0P+BCXLOpDb2tiMK1kdd8CQrcr5HxJQlDxq9QYlEgcwdNS+jCDmskvCH846QcUoCqr19fjYcQAbQE
	VmT+vdNtbXyldET2q4bMjNRiTNkotJfiSc6I43OJLCeM2JoPKdXNDK+m1b/fBN/+s6NRCJI8v9pKJ
	4ri6IbebIGw9wxsVwHglQ0QcE1TDNByIklpYVZQT1zI/QaGb+N4WZNvhGOtrmCJtENhiulxmtyQlC
	h6EfmOTk3NfC8qCbDaVv+NKc2+bSntYJ3k5b69IN+kWoSmb8NpXweD2r8vaqq1imSN6hWG+e/B+BO
	ZYbe4mUA==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1tYPlM-00DaWv-5f; Thu, 16 Jan 2025 13:18:20 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: Anibal Monsalve Salazar <anibal@debian.org>,
 XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsdump
Debian: DAK
Debian-Changes: xfsdump_3.2.0-2_source.changes
Debian-Source: xfsdump
Debian-Version: 3.2.0-2
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
Subject: xfsdump_3.2.0-2_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============3745622071988500178=="
Message-Id: <E1tYPlM-00DaWv-5f@fasolo.debian.org>
Date: Thu, 16 Jan 2025 13:18:20 +0000

--===============3745622071988500178==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Thu, 16 Jan 2025 10:53:24 +1100
Source: xfsdump
Architecture: source
Version: 3.2.0-2
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Anibal Monsalve Salazar <anibal@debian.org>
Changes:
 xfsdump (3.2.0-2) unstable; urgency=3Dmedium
 .
   * Standards-Version: 4.7.0
 .
   [ Zixing Liu <zixing.liu@canonical.com> ]
   * debain/compat: 7 -> 13 and also switches to use debhelper's
     autoreconf template, this makes the build script respect build flags
     and also without overriding the hand-written config.h.in file
     (LP: #2073548).
Checksums-Sha1:
 1ec09561aaac301ece04fcdfa90b17fe429d7726 1869 xfsdump_3.2.0-2.dsc
 8b24d71ef6303f0583dc0d711c979c9e1b2ca4da 5392 xfsdump_3.2.0-2.debian.tar.xz
 36597b34d7fb9b55b53d2af2c4f4e460e5b4664f 7217 xfsdump_3.2.0-2_amd64.buildinfo
Checksums-Sha256:
 4dcd9d416946606e29a620e7ff2e7dbffd3f11917ee00d181f77e16feedb5a9b 1869 xfsdum=
p_3.2.0-2.dsc
 ac8cfd76cfb597262168f6e082a7f49da177de3b78c74f763645bb610dba3e4a 5392 xfsdum=
p_3.2.0-2.debian.tar.xz
 3088ad6fe650c42ff2abc3248ed88a9e18047f5d6b69b2be89d33946efad6dbb 7217 xfsdum=
p_3.2.0-2_amd64.buildinfo
Files:
 254bbf0848f8044bae5fcbb9df799f31 1869 admin optional xfsdump_3.2.0-2.dsc
 fba97d88172e27352732176f86be0e0b 5392 admin optional xfsdump_3.2.0-2.debian.=
tar.xz
 9117ba3fdabc1ec03ea2542f3e945402 7217 admin optional xfsdump_3.2.0-2_amd64.b=
uildinfo

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEExgRcgTiHt3wt/5elfFas/pR4l9gFAmeIS2IACgkQfFas/pR4
l9gqIw//a+FvBpE/QXAvXzieTH3RIu2QcQtmgN8Ha3yvmsXklsrCHU4guB+O7krd
oCnQ50TsVJmRkFXDOKJnrQkyG+95jK9bxpFpGTd+UGK9U4jQbGEW7MsHRo6g/XYN
GkldjpcTxbh6g6uPPpJafDnhtSjnwKzAn2yKQSdaNVkhhxBozS3EBDKOymeX7Ghm
AHovn56SSxp7KxmpPjltHL6ET8eEx4DXPs/vzlsSyIQKhoausgEzIOsdllgbwTMP
yUsXotZBld/g2mTonTzqHEdWurvfFM7PnA3S/IS0foobO9ZtKl6Ce6hH/tgL5Mqj
THCe7T+3sHYun19Zel7KQI5JGoAwsECd8fA4phZe20/7SMT8XYvmObMfyMHPmnzU
HC9VikpVeHt2NAeKgJNEEpAy/8H42vLYdhh+lGRNG5XRTwfSZj1PJ+owKb3wgt8V
owyI9Mn0lTJG9UuZ19uKAuIuIAsxwfXyw5+LpjkQWxc7uoyro9XsR0KS9EpcglvZ
hfFgirJIHw4PUh662qZ/fKy+dBMwlyPSzKw/S3uwEzhkVQPoiaUXZE8qo47nGUFr
CQ22gQhR+P/PGlqCSJ3BTOUhvVZUJ9aaSkOKQfWsSLIGCsgh1Lg5+Jb3S06nHq+d
Ol845CnNUl4EAcWJ26sDHCyKNpO36ubqmWlnL0B9Ca0qUuGroLs=3D
=3De5n+
-----END PGP SIGNATURE-----


--===============3745622071988500178==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCZ4kHHAAKCRCb9qggYcy5
IXguAP9p0RgPcdCKCRHE1ZWLgtRUdh9vlpSqYAt+4lwdlB0eqAD6A1NawDBoPUHT
HigcyFjvFfsnhPq/FcpYCUb5swcDrg8=
=BEfa
-----END PGP SIGNATURE-----

--===============3745622071988500178==--

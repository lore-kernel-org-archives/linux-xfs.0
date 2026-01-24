Received: from muffat.debian.org (muffat.debian.org [209.87.16.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801D91A2C0B
	for <linux-xfs@vger.kernel.org>; Sat, 24 Jan 2026 13:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769259925; cv=none; b=NAyWwgjnyiUN+EkpS3w9wbRu8QvL6Bjw+cVlVMpNR2yaGy+v4+i3K7Zg0UZYHaGm7f+W97QQkN5APw2QH5/I9Eo2OMkCQtVsroz4weZzxkqR1I50LPPo41RGNzkMp+broDNujOYauAageiPNOSpeyF+3Z4ax9Yr3iSU31vNG31E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769259925; c=relaxed/simple;
	bh=bwoEjbXTpKq1borgVIPxfpDJovGnpokid3OVEB6rXds=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=S3CuklVawep44l6fkQqHxga7FPYIog6a7/FLAAIJHXuiYCzMEhR4DMJKsRMNMBewOb4LAyQoYa2g/GaxhEIKebZxoMtZckuXzWXV+wu91a2ID6/IxStu3oCKqsj6rqaBLqLYLVfWkRNQPcPRC2VGfFhBxM5SJAQFfUmXarNiO8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=TCjwaw0C; arc=none smtp.client-ip=209.87.16.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="TCjwaw0C"
Received: from [192.91.235.231] (port=35854 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1vjdKH-000xUq-0b
	for linux-xfs@vger.kernel.org;
	Sat, 24 Jan 2026 13:05:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=LeHhJGfT77vzHGhyTO1AQh7eHKBnJyANIZ9W5B1u0ZA=; b=TCjwaw0CM+uDaoK1jts+0dTKT7
	Oo7YIsxX1skZq2+DrFeIcWeX3LneKWgKD2qGLZmEA0A2hpRACw7NqwtcwdEySDtWi1+h3HZ1/u9Xr
	PqMYt7DkoVn2gv3V7iGibQmne/Z58UDQ42fPSO+IrQyRhM2/DMRyqDfhUKLy6eZIiBO0CVofVQJ1e
	TsAkvoYr23dAUjNedQ2LH61adPSFnBGuOUjmw/H2JNeeCY0GCFxy5b151xNqWyAjTLnrQuLx72/MJ
	nVK8hvj3u/9Fozqvbjd+LoCKU6aqhMCXUmN0+cci3hxkRBPRIpykwkxfrs5AV5u4c+BF0SCtV/VYF
	bn7EjM8w==;
Received: from dak by fasolo.debian.org with local (Exim 4.98.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1vjdKE-00000001bTW-1fnF;
	Sat, 24 Jan 2026 13:05:14 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: <bage@debian.org>, XFS Development Team <linux-xfs@vger.kernel.org>,
 Nathan Scott <nathans@debian.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.18.0-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.18.0-1
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
Subject: xfsprogs_6.18.0-1_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============3725845484149867839=="
Message-Id: <E1vjdKE-00000001bTW-1fnF@fasolo.debian.org>
Date: Sat, 24 Jan 2026 13:05:14 +0000

--===============3725845484149867839==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Wed, 24 Dec 2025 16:34:32 +0100
Source: xfsprogs
Architecture: source
Version: 6.18.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (6.18.0-1) unstable; urgency=3Dlow
 .
   * New upstream release
Checksums-Sha1:
 55a45ce24645fa238c59fe0f8131d9ac4c18b6a2 2048 xfsprogs_6.18.0-1.dsc
 bf759bf1b98adc31df27d424a1bfdf5b7ae3a64b 1563944 xfsprogs_6.18.0.orig.tar.xz
 3359b0bc0c38b491f3de2be4e91f426c669f7a4b 12024 xfsprogs_6.18.0-1.debian.tar.=
xz
 7fa8f4d53432334ab600ba76c90e4e29f2be2a09 6383 xfsprogs_6.18.0-1_source.build=
info
Checksums-Sha256:
 d8ca2e98f41476a0b83925e5d338bfa84418e7db98281eece61a16e7fcc8716a 2048 xfspro=
gs_6.18.0-1.dsc
 3a6dc7b1245ce9bccd197bab00691f1b190bd3694d3ccc301d21b83afc133199 1563944 xfs=
progs_6.18.0.orig.tar.xz
 06d215bc6f3405bb30bb9380ca7b246cfd3ee877755b983490bc5ee4782a2da6 12024 xfspr=
ogs_6.18.0-1.debian.tar.xz
 fc9ca55cfe70827324335c42c9f9722aa5b71943e4a0a0eca447721fa0f0c0c6 6383 xfspro=
gs_6.18.0-1_source.buildinfo
Files:
 dc0c7791be62e3df4c3b01419ba78a88 2048 admin optional xfsprogs_6.18.0-1.dsc
 f538782c07c81db5607db8c435348166 1563944 admin optional xfsprogs_6.18.0.orig=
.tar.xz
 984d0adb1d987a2a5ee9f84c493bbdc0 12024 admin optional xfsprogs_6.18.0-1.debi=
an.tar.xz
 a69f9f7cd951456cf6e4aead576e249d 6383 admin optional xfsprogs_6.18.0-1_sourc=
e.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAml0vV8QHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFN1BDACMMOtBQ+3ADuewHzLcCTgGcseL5ozKaDVZ
J9YGRuq6/wg/7QaPmy78rbOFhOamcmVnGVJnDvueT0rLase95XmE+EWVCTJHCM9H
FCrsTeEpYqpXruEOCnkYjXMn+zMhXPKwWA/y/mABUKfJfwPppN7EaMU3+uY+D2kG
OUMc5WVdAw461yYYmkASuViikWi0FcTMFVRz+jWoJYLwVE/sLjXU6owqsGD+d9jb
9M6Y5/PxXbRzcKYPGLd+tYyNgX7pIz24mM3MjXWYg8XM6029Vv0D8rj9xRjaSXsS
3/AQ2k6cQkho4pU2c2kesC9iVoaWKJRUDU39qrC3Pq08tykLVeTps/iV9un6kebg
gOHhETaz8DHQ3cWy05q1Wknk2osvESLQjvZCTxb0i67K9dJ7jxnx+CN1mvEdp4ht
q/AsBFuA+R1ZRg3LIbyqz60+qpKXoX71CGZUPji9TZaI/bWPIcVMXCGGIltTkpAY
8uX4wiht/oDRtlTC9xeAA/9WBJFhKac=3D
=3DUM9R
-----END PGP SIGNATURE-----


--===============3725845484149867839==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCaXTDigAKCRCb9qggYcy5
IXy4AQC4Rtj7qr6oA/0Y+34Af/gtjE+90ct9jsBt+CDcB1UYygEA4mBgfP2VMv6g
ecpV1sLUdeXBEmZLC+WDmD+cJLp2cgQ=
=ui/a
-----END PGP SIGNATURE-----

--===============3725845484149867839==--

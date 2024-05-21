Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05191CD20
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 12:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716294049; cv=none; b=p5mXWIJ/+r2ne3FXUIkZP0aGCV4p029t0pf2u4bfGUN0prBaYcIwc0HOpdHXbRl0wROpUdSoz+GMetN5oGgM3cuVcn3pqjC0s+s54Th5vUg9U7NKBrcEokTjuQiEy4yGJ+dH6uw+sk/214jJVWwurfCr2+tbgz3kVTWlJRJu4n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716294049; c=relaxed/simple;
	bh=3adnb5MDtphayHmzUPx6APBuhvpw9V/3VxXVw/PynOA=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=XM2bIPya0P3yUk2NwviNaXINKUalCpZGuDEMTT4Nu+Tf0cMbXDydmD5ZmTaHZAQC2FuQHp46w7zGeFw8DRok47vz9vMpjIULmvt3sM5HVnBpkPQv3+3jjSEC/KtN0RWeZm32IA1cgNAwYN/KvH8zlYKJPa8jAG0GDE7yusNno34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=WdN4rAmW; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="WdN4rAmW"
Received: from [192.91.235.231] (port=46404 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1s9OTt-00FIn9-8V
	for linux-xfs@vger.kernel.org; Tue, 21 May 2024 12:20:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=DIdsMD/OhN6nSazaYPDN5rSFJfL0GvKPIq0gkY+KBDE=; b=WdN4rAmW8nygJkumZi7mh+VB1P
	YYHyoqAChefYxZnmIaW2CzNJXHjpZoE7nqR0KZUF+LIEceXw4ddksOecZfAC+aoSq+114bxXlq6pe
	otryKle6fpinqInPuzYv0OFbvsSJOsBc3RQGckPeHqpaBMuXofi52pG0rA5Uf1rZPXgrhX01QzueR
	mPNOp3Y99iZqp6CwvWQztrKCv92N2pbF6N+A7WafgUh9J3ggU8FIo5sDUHBmNK0q8NWQr3fnF+uTQ
	jmespg5mzmU/EQBy2zw/R2lOExFWIKYnOxwApJzscK2LA+q9pPGZ/05t4sVaUPP1l/7mZ9tCUAh/K
	FlOAtWPQ==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1s9OTm-008p7e-QK; Tue, 21 May 2024 12:20:30 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: <bage@debian.org>, Nathan Scott <nathans@debian.org>,
 XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.8.0-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.8.0-1
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
Subject: xfsprogs_6.8.0-1_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============7735892087816389432=="
Message-Id: <E1s9OTm-008p7e-QK@fasolo.debian.org>
Date: Tue, 21 May 2024 12:20:30 +0000

--===============7735892087816389432==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Mon, 17 May 2024 14:00:00 +0100
Source: xfsprogs
Architecture: source
Version: 6.8.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (6.8.0-1) unstable; urgency=3Dlow
 .
   * New upstream release
Checksums-Sha1:
 cb85149658765ec4fe17ac482d563aaa79ce5589 2034 xfsprogs_6.8.0-1.dsc
 605662f5d674f64cebaa7db2e9566509b690fa0b 1367196 xfsprogs_6.8.0.orig.tar.xz
 e5afc37db9e42770bc3dbb55ba2b172e34006e39 13588 xfsprogs_6.8.0-1.debian.tar.xz
 2e24753bee1190afda2de31185a45073236cfe94 6357 xfsprogs_6.8.0-1_source.buildi=
nfo
Checksums-Sha256:
 3ba96852852a9d733af93e980cf79590c3ebfe184f0d590c3815b2eeb13416fd 2034 xfspro=
gs_6.8.0-1.dsc
 78b6ab776eebe5ab52e0884a70fa1b3633e64a282b1ecfae91f5dd1d9ec5f07d 1367196 xfs=
progs_6.8.0.orig.tar.xz
 b3b6dfebe55679f1304d310a47f9f2544b1b2cb569cb55deef9098e500bd9b77 13588 xfspr=
ogs_6.8.0-1.debian.tar.xz
 2c7e5a5aee3308c298aea75fcaad1b48d48197ed1e0d36e70b28d8bbd7c7fa17 6357 xfspro=
gs_6.8.0-1_source.buildinfo
Files:
 7facf07133c591a7b4250bcbeff1f2a1 2034 admin optional xfsprogs_6.8.0-1.dsc
 26fc29481cb1934ea659c327b2228f71 1367196 admin optional xfsprogs_6.8.0.orig.=
tar.xz
 e7cd967b4c0402375ba42065b09cf91f 13588 admin optional xfsprogs_6.8.0-1.debia=
n.tar.xz
 8e0b18c9f043ba9d7f2925afa119fd1e 6357 admin optional xfsprogs_6.8.0-1_source=
.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmZMjCMQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFOXQDACpavQnRV3TUdPmvk2zQAf9VDVjzucC8D6M
JYDdSagUYBcBiMF9n3YA3w7+VvxaiBQvPn2/guLgZ6ZmsWtHbYhepOVLSTk6F7hq
3rN9T6cNWrjYvqsh+QOS6S+bFxuqV9nvIyPsVvy+p28uaD19AFNB8Zh9rmCeMecu
1+kHUpCOUkzxchYVJqfK6IwjPrtb4V7S6JsF/wwUH+DhUNPZM/z6idqAaXhLAknL
3DNnjP6+TEXV1965cDdYyPBOqFS89wAGwrjMzfqYr/7R8o/PysNLdSaSdFPHtIwg
5fYD0Y/J7yrc+ZMtaKEUGLaNbo1YlLfkufqrLXvxiEOrztYjVmygwXj1eYutPKbH
ctyehZMwDvjrowNuBSkzsz5KymOBdOxN8+YOg2Gv4NFawIYX2g5i1/zh7uRXjxz0
reEXMF1ipDk4IdvNfLUqZjjK9poo8wGWVjudHJYTLInCa3mOmPdLhVYNGc+YV8XR
iyzcpDTfYSLOOOSI7mjRjKgDEjLTmBc=3D
=3DAtD1
-----END PGP SIGNATURE-----


--===============7735892087816389432==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCZkyRjgAKCRCb9qggYcy5
IYFeAQDrPxEtPF7vfcRPFBY3V1ayb6JgJ/XgjJ+WOUJ5nnl8nQEAqbWyhLBe9HBU
Apts+KH6KEMQZdXBmiEawD/cEU5/jgQ=
=lpxP
-----END PGP SIGNATURE-----

--===============7735892087816389432==--

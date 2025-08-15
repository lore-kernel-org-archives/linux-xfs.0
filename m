Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21ABB3019BC
	for <linux-xfs@vger.kernel.org>; Fri, 15 Aug 2025 13:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755263458; cv=none; b=I8h5NDYkHCTlyDcCJUTdqF85OHrzTpna0bbV63RvNoYWTHDPWbXf4DQ1mmsezCSzcwFbqALe2yZVF4lo3TtS0+a5FxGExMKs6scFbfhy0Bzp9Y3mYsT92tOjEP127qBc0mDiHHRsRIGZVvsoKCKRmEASZROPBAq4ftBT0nMoMqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755263458; c=relaxed/simple;
	bh=PE4vZdjuTuTC9zspGt02zo69UdTFX08iJhgVPHzbkOc=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=sXd81uSkExnQsH65d1v9D+EAAjyTKJk0WT6mmNJki/aXsoXBjVA3izldcD0Aa/FFs7zxcQnAPyO2L80u/HIXyh0c4XlX69yDEeEIRbD6ZTqmirbcxB9mbB2vu/4I0MyMNSdkoErcL3UhXGDudKpAOEBZhYx/nBBAWssacsqtRS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=Fh3rCJbb; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="Fh3rCJbb"
Received: from [192.91.235.231] (port=51970 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1umuCs-006bft-KI
	for linux-xfs@vger.kernel.org; Fri, 15 Aug 2025 13:10:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=vmm5cb+qtk2wTTMBiSF5cvqxQh2kkjaanBTAM8qjQn8=; b=Fh3rCJbbeLv+/9I3HQ8nnH3Mgd
	L8hIUUrzOiVdp9fLbQUkW6UIsAZPY7ExLSZZVZ+woFCGgb3Kj1RpZGlbMz7MG+EfQ16qX+9Wvh/W9
	wgOvRK7MPem29GWzLBWx+7JVvcWHxNHf2Pgc+1nBf7kWIkkpXckagNV3QWSMvBQMc7d+ROqWA5ZZK
	Qtgypu8UzaruEfd60sAVh/bxx4l3p8OWALohcnWdjsN2/nvobtpQyHrIUfNhQexBMhDWNJo8cibyk
	DK6uCo4Sp2/T8oyBURLoX9KTtqSZiKV94/u9MtFu+RUwDL0LiofQMj0xF1STvKM12hdwiUIKPLPxq
	DQhj3tag==;
Received: from dak by fasolo.debian.org with local (Exim 4.96)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1umuCo-000VW4-2N;
	Fri, 15 Aug 2025 13:10:50 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: <bage@debian.org>, XFS Development Team <linux-xfs@vger.kernel.org>,
 Nathan Scott <nathans@debian.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.14.0-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.14.0-1
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
Subject: xfsprogs_6.14.0-1_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============2114286052729289041=="
Message-Id: <E1umuCo-000VW4-2N@fasolo.debian.org>
Date: Fri, 15 Aug 2025 13:10:50 +0000

--===============2114286052729289041==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Tue, 08 Apr 2025 16:14:08 +0200
Source: xfsprogs
Architecture: source
Version: 6.14.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (6.14.0-1) unstable; urgency=3Dlow
 .
   * New upstream release
Checksums-Sha1:
 982eedef89380fd6ff3b722ebfeb40eec5d1b50d 2048 xfsprogs_6.14.0-1.dsc
 8dc4a1967581723b0403358d12d5f81d9763613b 1543640 xfsprogs_6.14.0.orig.tar.xz
 4ffa42f586f26ee2ba4a5e8770398ce25683bec9 11964 xfsprogs_6.14.0-1.debian.tar.=
xz
 2f446bd36aa8dd539d7ad40cb524f64cbfe164d8 5555 xfsprogs_6.14.0-1_source.build=
info
Checksums-Sha256:
 367496287d5a42ed34880cc3d20b2b0ad43b0bd487c9dca480faa8d2e9b408a4 2048 xfspro=
gs_6.14.0-1.dsc
 fa5ab77f8b5169ce48dd8de09446ad7e29834a05b8f52012bae411cf53ec1f58 1543640 xfs=
progs_6.14.0.orig.tar.xz
 30fabfd6367c0b8cdc6408160e65947976894e138a8a57981898813a4fea269c 11964 xfspr=
ogs_6.14.0-1.debian.tar.xz
 f31c564a9ed2f5dbc323ceff855d08b52b82c7eff75c0d895c28fc082cc507d4 5555 xfspro=
gs_6.14.0-1_source.buildinfo
Files:
 adc0b1087e4336f6d138a746deeb11f6 2048 admin optional xfsprogs_6.14.0-1.dsc
 339b90d4716d5f1e3e9d31f3c68f830d 1543640 admin optional xfsprogs_6.14.0.orig=
.tar.xz
 9080fee16fb3f2f7d011833abfd4d39a 11964 admin optional xfsprogs_6.14.0-1.debi=
an.tar.xz
 1173ab39881c8bcbf1e3ee3e19e30a88 5555 admin optional xfsprogs_6.14.0-1_sourc=
e.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmifKeIQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFPy3C/9x8EdITjnSMc0tz50qDU5JbGg1lnfIE9+1
31zeYs3DLHc9At6DQ4A1BiIO3LP/GKDYRnr8NCQbZwKj7qyX4J+v7JioqID2tzxC
ggP5hYBQsF6ZIQeWn0TA55R8hGo1BJTn9hxputBmCIRb9ekYfZ6Ks/E8j+S/4fkX
ZxgEdhBkBRV0GcrFvnahnVDigPNZMctgor7x0nA+EznI+tlc6qM0OTNDG3/bpTbr
G/3znHf466M1qyq6ybhQDi+9HEzmeM9uba+bpZNW2tirXCMGWi1Ke+ntJ6uvTobV
ZWkRt20f2aY+nUg0Qp5EySxOU8JuYqo72Qt+Wq7/K1iaRhSFg1TurxcyJBkN51a/
LH7ntgsCKsvlY7h/LRGztmkD2Lg7PmKCZiTKJfQkER/Y4jkME4PULTx/0fqsMEdy
JX0o1epfmWlXSfODpsl0nEkhlcP1nx7R1pj/nlznSs8/lod12N/gK93i8K1CMMGB
VvfhMZbZZkALQbjiLPwpyief7Z/TJr0=3D
=3Dq4LD
-----END PGP SIGNATURE-----


--===============2114286052729289041==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCaJ8x2gAKCRCb9qggYcy5
IfZKAP9pH7frPmn50rXYmD/+mNj17rlw11lsEVBi1xspGujkJwEAv7fcAr3b2cy+
+5U2Vs6dwp5mFj9/na8nK1DO+9jaAA4=
=6CZs
-----END PGP SIGNATURE-----

--===============2114286052729289041==--

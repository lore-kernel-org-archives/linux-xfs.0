Received: from muffat.debian.org (muffat.debian.org [209.87.16.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59ED14C8A
	for <linux-xfs@vger.kernel.org>; Tue,  7 May 2024 19:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715110153; cv=none; b=paFkFE74+9YhapZrKaCsap9JmyW8EFm8gf+sKhgsNJTI3o3FD1H1925ALPLEBfg+X2Mv6EVI5BlV1rNw3vctAIko/sBQ+NHSjNxDugcjiDncvY2nvKOnJywvG7logbecupQDdd8QjM8w/FNZhdhlXGJwxEyCPOd6Sh+S0gyzIrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715110153; c=relaxed/simple;
	bh=E53L65SBqCF9gLCFglfkx9I65aiUfDoDO7NRMTPof+A=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=DCondBuFwR2fFo3RoC5SJGL7rSjBeeZhxupjZptY8TdWatWYGgJm9sVDELkagAdYEu+Ej0fc0SkzFwp9ro0SnLIj0nev9s9x1CDHuPS1a8J9Hz3T+4Fc00RZBp3gNMH3w+rdiwlWoAntxvfznV1fV7Se0TknvybFC33H1zuHHnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=d9sAse5L; arc=none smtp.client-ip=209.87.16.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="d9sAse5L"
Received: from [192.91.235.231] (port=60428 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1s4QUy-0014Gz-Ek
	for linux-xfs@vger.kernel.org; Tue, 07 May 2024 19:29:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=9o85ZN1vE7VoSM/LtDFUsMdtEv9qqrLYfEHhmj1BdUU=; b=d9sAse5LfTuVLhpOqi6SKvZxqo
	ngNZiDwxwOKRN6k7QgJDZuqSSfZ7qXp5vTqxIae/dsaBeHmPcmY9thg42LSh/KmNe6EMqzA1iUvWq
	+vyXsCgfq1Ima6MUv+56+70wCK0j2baff5N9vxfv11a/LabS30k1ZTn1bvgp0H+t8DBxdbgXLTSRV
	Kx6UqhNPNDVLl1SZKNK7Icsv56H/Xt91nwjQR4qIumsguuh4+effa0fsj99q7OEA/9ZIm/34ijqTS
	ybfWyP8z4Q2pQIKJ3mEnT30lLq4WtDrx1pim2EU3cjabPESXQbntv1xuelbE0EOigdZlGiIolYSgU
	onDYsFyg==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1s4QUs-00HGOH-OW; Tue, 07 May 2024 19:29:06 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: Nathan Scott <nathans@debian.org>,
 XFS Development Team <linux-xfs@vger.kernel.org>,  <bage@debian.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.7.0-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.7.0-1
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
Subject: xfsprogs_6.7.0-1_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============5470367745677417626=="
Message-Id: <E1s4QUs-00HGOH-OW@fasolo.debian.org>
Date: Tue, 07 May 2024 19:29:06 +0000

--===============5470367745677417626==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Mon, 17 Apr 2024 14:00:00 +0100
Source: xfsprogs
Architecture: source
Version: 6.7.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (6.7.0-1) unstable; urgency=3Dlow
 .
   * New upstream release
Checksums-Sha1:
 ee8f50409cac3dbb5e7ee1f79b8bf4a11c852bec 2034 xfsprogs_6.7.0-1.dsc
 721c6ef736a1b10fddf3ca2c7a5d42075b23c4bd 1349748 xfsprogs_6.7.0.orig.tar.xz
 bc725313eee0071b535ecdf492ebde12a1789487 13580 xfsprogs_6.7.0-1.debian.tar.xz
 413c84cc814c0df90f7b39fcd4daf567611e81ce 6525 xfsprogs_6.7.0-1_source.buildi=
nfo
Checksums-Sha256:
 40a17c8a044db8b89d2d5f919659b8560ebd79a2e9833cfd72c6bed5a20523d8 2034 xfspro=
gs_6.7.0-1.dsc
 e75d1e012853e11597411cfcb80e26c811881cf0ca03715e852b42946cc61e1f 1349748 xfs=
progs_6.7.0.orig.tar.xz
 8316f05c286abfc5507735de936c48cb871f93db74c994c07f4f9c2be3f62472 13580 xfspr=
ogs_6.7.0-1.debian.tar.xz
 df38d262e747977753e6505ed7bb87656e35146d27fecf4ff39d42e65df84037 6525 xfspro=
gs_6.7.0-1_source.buildinfo
Files:
 0b6a2778f63301efb04b2dd12765ba2a 2034 admin optional xfsprogs_6.7.0-1.dsc
 0bde7bc8b3d8cbbd01064f756f67911f 1349748 admin optional xfsprogs_6.7.0.orig.=
tar.xz
 595e7a8dbbee9d71c0da06a913af048b 13580 admin optional xfsprogs_6.7.0-1.debia=
n.tar.xz
 afa0794e27cb41a2e32216240ad048fb 6525 admin optional xfsprogs_6.7.0-1_source=
.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmY6YfoQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFODGDAC2jc7CSrCjEUG6Q46Ylp84aJNgA7fUZxcx
8WAmW0DXZ0KWKGD64iU0GpqC7mpnXpRKwWPkwDNFW0HjbY9+KNt3rs4hq8pjE8M4
JZG7xdRXBFuVNaBdNq15Pt9fJuRTwM6FlrJRdtZuMdjOP4FkQtWn7F++aVs6RiJI
pM6kuZ5SygZWYvfqdnA2yYRhXtKlfFVI5FYgbdHsNSWRt6UAMclGviSzy9R6TQIg
7rqPK7YHssA3bC0z+NzQDEl9o1BmkMeYY0/4aauck92GTgWNXJU2EcM19Y0uJafC
5Q9bSACloiCwyeabuY00iNbdbAymBc/YkBbrATaOVn2Ef5X8f1UJxur5FRTQz1JE
mhkQujWpExxtwnMSswKALnHKZUaAegxHVq7BW3ptVtBOV2rJU1fz/sZ0iAc8lHJS
xJ0Ld8l5Hu3NW2oaEG+GwdX4CahMaw5sVx+fZnpQKlnaoJstopKRce1qfjYuCyh3
rk6ZYE1n7yeAx8ny2Hxp9iYsmMUY4cQ=3D
=3D3/KN
-----END PGP SIGNATURE-----


--===============5470367745677417626==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCZjqBAgAKCRCb9qggYcy5
IcRDAP9874PwjMghkeF4RXtvKFRsVDHouTD49CxNSG5s68pdBwD+PHydx2mBzlmm
+GNvvomRDez9DpX9Ms3gpY/fXDiw6As=
=P1Ly
-----END PGP SIGNATURE-----

--===============5470367745677417626==--

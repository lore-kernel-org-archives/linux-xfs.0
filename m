Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FF91D86DC
	for <linux-xfs@vger.kernel.org>; Sun,  1 Mar 2026 16:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772384072; cv=none; b=W1pf0JTU+2eqRmkUYR0tDeQARR5WtEbGTBPOTw6hlH2alAZ1yd2u5JeR4D3CHQAHJSHMf+Abvo7yGFA89k8VKtaSia26ncgNzq21h/zyP+NTSsIcYzXm7+PdFkLzhW34xxSN8gyXLaCj7ww4gYgMKi2HPPn7ubkjydKkg7bxaRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772384072; c=relaxed/simple;
	bh=nX/Tol3EX/GxQv65KpsJoP4FAX8Djnef3sljLfpnLDA=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=TlBBwQWt5bP7SLRArKwB/aDaV/Zh4SB76Orb6+DNN7TlMSRZbrUcUsvtZJO5lRmYGfmum9NQXAW3TSfpjg56EwaFHfZehM+A5dz8AChqwyC35dmxFDURhljrkq57kBSn11qH6JjNX2PuVhKCYsrf4nM6aMMrJsmBlxSvV7HEFMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=oHgfn4Oa; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="oHgfn4Oa"
Received: via submission
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1vwk3p-0049CP-2w
	for linux-xfs@vger.kernel.org;
	Sun, 01 Mar 2026 16:54:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=253Wcn8KD4r4ybThQmZ6kckwBJBCARjCahksvqkJLm4=; b=oHgfn4OaT5nbX6LF4LbFgmPK2X
	9yOPUlgaIo+G4EdJn1CjYcmvYNUytQaQa4vrO5yaOEcZk6Urxu9WR1Z0+3mtWootsWZGIrQEZDry+
	l3HHm0Z7GFgSa5yF/KYa7kwZyVqE+3snP2frennrBLCcsNkaNioCgVuF3l4iWXg2QsQ+YZdFmzXcV
	z/oLmL8DyjSDuTaS/vqmjoyfPyQSMPpiXCKYuPBhdML+FTFZsbC0pKn1YMAxjBpyiLM3IGwBZ61sJ
	VebF0Pq95QreN3INgdVhMT1LFhnjR4Hgbzyi+3MGxNZsrC5rNeDvMCVB2cd1LKoVEW7y+4dNMe0Xw
	HqtbKZzA==;
Received: from dak by fasolo.debian.org with local (Exim 4.98.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1vwk3n-00000008CO6-3zTs;
	Sun, 01 Mar 2026 16:54:27 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: XFS Development Team <linux-xfs@vger.kernel.org>,
 Bastian Germann <bage@debian.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.18.0-5_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.18.0-5
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
Subject: xfsprogs_6.18.0-5_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============2671192208208613656=="
Message-Id: <E1vwk3n-00000008CO6-3zTs@fasolo.debian.org>
Date: Sun, 01 Mar 2026 16:54:27 +0000

--===============2671192208208613656==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Sun, 01 Mar 2026 17:24:22 +0100
Source: xfsprogs
Architecture: source
Version: 6.18.0-5
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bage@debian.org>
Closes: 1116595
Changes:
 xfsprogs (6.18.0-5) unstable; urgency=3Dmedium
 .
   * Reduce security lockdowns to avoid postfix problems (Closes: #1116595)
Checksums-Sha1:
 1848fbd775d35c158e29d58fa8f188ecf2b741b1 2048 xfsprogs_6.18.0-5.dsc
 36fa79b13269b9e220e5c7dd057a7518c02cb713 13436 xfsprogs_6.18.0-5.debian.tar.=
xz
 d433e4aa48a990047854e170629323fa32a00e71 5336 xfsprogs_6.18.0-5_source.build=
info
Checksums-Sha256:
 60e05a6890c3118d62419415daf7d89ae74bcbf3ee10eddc6ad7263662d0ee58 2048 xfspro=
gs_6.18.0-5.dsc
 6561d1cf29dbce1d099bc30806e09bdd9328c4906028f6e4dd26d80438574fa6 13436 xfspr=
ogs_6.18.0-5.debian.tar.xz
 8a1c74b2a4b5923a10fa08ddf02c638373ddaf9bd98762c47340b4dc7061d2cc 5336 xfspro=
gs_6.18.0-5_source.buildinfo
Files:
 7a83952394e9c1f6b6134e50ee1e86d0 2048 admin optional xfsprogs_6.18.0-5.dsc
 f213e5bb671959fae5f61725bb5e8358 13436 admin optional xfsprogs_6.18.0-5.debi=
an.tar.xz
 5189e704d5f4c36f44546f7d406e4bd4 5336 admin optional xfsprogs_6.18.0-5_sourc=
e.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmmkaGgQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFK8FDADbeNnhhcNBnGA8oacIPEkGfZGVL2hbqj+M
d3rLT3I6NrqZUkEefOHZB+smK4zegy2cG+Eeg/OOl1IuRYlC7+MMJxRZ54rQ5SUq
gFvZOOGu+xmx0MFa3hld0g/UZylH0ZftljYQ7H4QMg7NfEjsPlZWnQu0i1aWJe9K
8je1vihtG5uGyKAoOdMtk1EAnDnYdJpfSyi3PvfyU4rcwfhVQy1u6m6DwtwLluao
OaRvTelxZkIIMmW6hVC9YRYyxX136HYl8X3Vuv+JRLPP0ZGxgaOHBed+ik1sFGsG
nvR4NeWOK1+yvIbb3vlkjLmldZ589ETQ+HKsKk+7iuzYPWRTQRmzV62KMJYOZ83h
iBa0LcsdL8sNFnfblcIR1PIK3rLDuQGEcTzZPrAkyIruW2nLiYBiylOotZzlsuoE
uec0zbPgIIHljx9hp+7GM/9tM8aBmdCDtjH/eETRiKIT9BnkWSA4i56XEGUC18zr
BPiMzQKTCdP6lJRNq/UbQoQ+bdp76kE=3D
=3Dczyv
-----END PGP SIGNATURE-----


--===============2671192208208613656==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCaaRvQwAKCRCb9qggYcy5
IVOdAQDn1n6rp5lyy+PWOeK+vTzJBIdovcLtAe4YVJ1/XkLpYwEA31j8B4H2fHMU
xw79m9q+AHyZ9kXf5FyrTho5HS2BwwU=
=oOVi
-----END PGP SIGNATURE-----

--===============2671192208208613656==--

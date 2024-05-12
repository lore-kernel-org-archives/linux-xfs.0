Received: from muffat.debian.org (muffat.debian.org [209.87.16.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7FB4D5B0
	for <linux-xfs@vger.kernel.org>; Sun, 12 May 2024 17:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715536528; cv=none; b=kJrr+LkXO92y4rOWVWJ4x5ZzvCyN/K5cE1kzUFB6DwbOeY0dCNjR39r9qAqpQClafCwCMlhbuWk5Uh1GzEMKc++HYYwc030dDYSvjB76LAlXshbSXZmHnpn2jMK4wmYB4y2nk2abW0vV3RT0aUVN7y79YHajS/IWQqxubVeX2B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715536528; c=relaxed/simple;
	bh=gfBPfLnj/8OZWe9Ee8bMUZ2cDyeTAQpTXkxf/WTkuKU=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=VfzCYXpbTvox+BN6duQnRQFBd3tSZA8Gh4wyd7AouYzlRddkuzU+99xs5XxWmt/JtQZQ6HYl9vnSHUpuQggBkGYedOuj2Ttx24NNq5eC8tt3YkpvKqjsM1nZYbFlxljJ0Ly7newJkfHMY9Q+icnB5xrQEc5D0CcHlvU8EqWtD04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=r8t4eQLp; arc=none smtp.client-ip=209.87.16.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="r8t4eQLp"
Received: from [192.91.235.231] (port=36574 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1s6DPy-006RJx-M8
	for linux-xfs@vger.kernel.org; Sun, 12 May 2024 17:55:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=xX7ZQWd2xQasSWzOpSxChq9QrDqjzYM/VmuZzQdY+Sw=; b=r8t4eQLpzlL5RgbLC8h2ffh0Hc
	SKvlNd4Rr1xiaw/zTfh/SQeJFA7b9rJWsjxgnvGnL+bO5st99T3RORw2rgR9uQLyE0jhjt6P2NGW1
	Q/pZzkgg9Jx6hZgEJI0GQ1gULGWE3b0f5BSIyICoGQa4DrnKnwXwEqyIGV/h1P27nehVsFBM9lbnu
	cClwDFmX+9Gx0sYR8lKmExzZzGZsM7GMmaG1t0zDA3md+mN06DlymU2cv6dn5dfJeOgdw0eChJz22
	dNNGaNvW1f3RJc1uHJF/tTXjfEw87RnbMF0x9m67Pzgww7yMRucokU6dP41+3gC07BZJGnCG/bdOO
	J9xX9+iw==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1s6DPs-000EWi-Tm; Sun, 12 May 2024 17:55:20 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: Bastian Germann <bage@debian.org>,
 XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.7.0-3_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.7.0-3
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
Subject: xfsprogs_6.7.0-3_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============8887205321855696530=="
Message-Id: <E1s6DPs-000EWi-Tm@fasolo.debian.org>
Date: Sun, 12 May 2024 17:55:20 +0000

--===============8887205321855696530==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Sun, 12 May 2024 17:03:34 +0000
Source: xfsprogs
Architecture: source
Version: 6.7.0-3
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bage@debian.org>
Closes: 1070795
Changes:
 xfsprogs (6.7.0-3) unstable; urgency=3Dmedium
 .
   * Fix empty xfsprogs-udeb (Closes: #1070795)
Checksums-Sha1:
 eb095522ba437f27eae583448be35e5952b91c54 2034 xfsprogs_6.7.0-3.dsc
 12716845067eede5c50261c3052d9f7137c16e88 14884 xfsprogs_6.7.0-3.debian.tar.xz
 8a49ac6c79aaea35cadf4a8bd2f14374ee0e77d2 6350 xfsprogs_6.7.0-3_source.buildi=
nfo
Checksums-Sha256:
 00c6fb0d0a734561583a3fc522aa5c5547b9af80cca217aad2e658a20cd0cade 2034 xfspro=
gs_6.7.0-3.dsc
 e1890152c36827dc0a19183e5e706346d51b8b4e85f1993ea5451e76b7225f10 14884 xfspr=
ogs_6.7.0-3.debian.tar.xz
 86f8a32b063dcbaba71d1510e94d95d83713a0cc2bd28fe40764235b1465bacc 6350 xfspro=
gs_6.7.0-3_source.buildinfo
Files:
 bcffa221aff4395099a8ab4523e29e57 2034 admin optional xfsprogs_6.7.0-3.dsc
 6f31e1d62cc2e6945239c2e28461a976 14884 admin optional xfsprogs_6.7.0-3.debia=
n.tar.xz
 3ed5f4f3968c59720aa857926f251ed1 6350 admin optional xfsprogs_6.7.0-3_source=
.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmZA+NMQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFCXDC/96k/V7dLlqlvhhevTYdZLwxfmlwNhGQ1Lt
SCrrIOtcSEvks5vR+XNVfCvgtiDTRf2ymr5xuMzq+GEbT+L25j2+yqBdLIDSJDn/
bpAJF7RWEFZSzzXYfnwFymeJeaevDmC+6dE7M97SwKgxgozOJY1jL48Sa4JQDOv1
Pfmp17w8vyNoSi1KtNhSB2MLbtzCNq2ok/eQ37k41M+2rW1rLe569rXJBViEfepW
TJrX4gyKJgV1IKN4A7VoC5Fqb2lyzDTNc7hcOe4R/AF1uaBbuA3Ca+9tstK/2eBm
4LnXwLEY8J7D3BSPB0ApUSUYhVvqoSvd3wDrc+i9puZ+/VNQehWO6S4tpfHciuz/
RMDm2t5N8P1Wbvvw+Yrdnvh1O1LniJlMPhYGqxRf1AbziDIFmow8U9CDohk1ho3f
Xq0aD+LzAm+94ebCHxhtDnWSJr97dx3cLLTC8PsC7phlg/QcxAvfFSVtAcfAOjNI
R+tsLBEJ9o5Os3RwT/pSlJFiXgXmpqU=3D
=3DDtC9
-----END PGP SIGNATURE-----


--===============8887205321855696530==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCZkECiAAKCRCb9qggYcy5
IXiGAP43XPVWOdnVZtmqqDQAE+FLh1Rks1T+WT9bgQi60sQYwgEAg9k0uT+bGMcb
q8N9I+j5a7uGZh5NdOT/AQelEwJwewY=
=QhKn
-----END PGP SIGNATURE-----

--===============8887205321855696530==--

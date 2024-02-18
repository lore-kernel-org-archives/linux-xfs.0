Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3B8360
	for <linux-xfs@vger.kernel.org>; Sun, 18 Feb 2024 00:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708217259; cv=none; b=ezaok3a69fjNC+n2RYrjRFNkygEzyXl4+JZPIi8+IHMTUVt6Z1HHmzbVgVfAq0w8ZDDemqkPgHYQrUoq/mxSoW+jYklhHxmf/sk/ojY5VvuSsXlxKeUyqe/Asd3Kpuu1Pk3feawXYXSN66PKd0o2Lb2Ubazjgtp2t2iivaBT604=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708217259; c=relaxed/simple;
	bh=fhYzaCWJNG4iW+A3Eq7ERgVHZKo8+JPShoYaWKGMXzQ=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=lQifBCZjLiamk5el+7i6AuQD3diJ0dgYrg3pMXSsTMxAbjHcq5vItx7O2HT1i0uCRka7S1fbUI3pvgvJh8eYPLkQLGVgoPwNQFwqs+t+0YN3NNe7/d+dgrrhoGVmTevfitMz6TkSh5TBH0mNNja/2rEJdJCy2yX73AGilr9i5nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=QN4CKdTq; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="QN4CKdTq"
Received: from [192.91.235.231] (port=36044 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1rbVLB-007grV-Rl
	for linux-xfs@vger.kernel.org; Sun, 18 Feb 2024 00:47:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=NfUK/vHKQXNcLQWwCxTzgjblS92gXeuqPUcN1xXO0jw=; b=QN4CKdTqxUrbuuwWC0ztQA+FlX
	26tfSg3OrW2M2IJIqd1hp48QF3jwesX+GqrLfzxtgG+JbBoO/w6evW8Q7w1CpwS7N1xACRJX/a6dc
	X//sq335pVOuMskhKK8FFNdcNbLYVCZmws0ZIGGMlCY6T+WM9kkG3iiXO/zx81gJTU2JuDZ4/le/h
	vYtzau/r8W84SQF/QrFU5DvHlccC90maHycdPbjH2QDP5CO6GNO3EiTd0e8TEqJIbvL3FjDLH6yYg
	AzldMA/67w2NygvGSH55SODl4lI4aMrVIdPlrjS4dADWMhqxcWt0JH/w1noVGseYnH/eQr981fvkN
	MBCK/AGA==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1rbVL7-004lcH-9h; Sun, 18 Feb 2024 00:47:29 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: <bage@debian.org>, XFS Development Team <linux-xfs@vger.kernel.org>,
 Nathan Scott <nathans@debian.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.6.0-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.6.0-1
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
Subject: xfsprogs_6.6.0-1_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============6570957258389215080=="
Message-Id: <E1rbVL7-004lcH-9h@fasolo.debian.org>
Date: Sun, 18 Feb 2024 00:47:29 +0000

--===============6570957258389215080==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Mon, 05 Feb 2024 14:00:00 +0100
Source: xfsprogs
Architecture: source
Version: 6.6.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (6.6.0-1) unstable; urgency=3Dlow
 .
   * New upstream release
Checksums-Sha1:
 0a6355e8c6e98fd389c8b3ca6647e410a2128ba0 2034 xfsprogs_6.6.0-1.dsc
 19e134405419a4868d40bd5ec150f01bb9315fa8 1351792 xfsprogs_6.6.0.orig.tar.xz
 c29a33ee90d9c9ed77ca5fca0d3872ab470e2066 12616 xfsprogs_6.6.0-1.debian.tar.xz
 7612541ad1b6d3f1e8bebd033f13e6f1401b3882 5859 xfsprogs_6.6.0-1_source.buildi=
nfo
Checksums-Sha256:
 795fdcfe1a37a004d7d185fa65e5da0f2dc495809bf846150e0b2354cd11d5a4 2034 xfspro=
gs_6.6.0-1.dsc
 50ca2f4676df8fab4cb4c3ef3dd512d5551e6844d40a65a31d5b8e03593d22df 1351792 xfs=
progs_6.6.0.orig.tar.xz
 34c34307b99f2788580e63055cebcf493894a246f4bf3b3ec4e37ad723b030d3 12616 xfspr=
ogs_6.6.0-1.debian.tar.xz
 49960f0e4724956ba149856bfeec3eaec704d87475f8101fb6b614a03cf9c23d 5859 xfspro=
gs_6.6.0-1_source.buildinfo
Files:
 81c88ace1d798470bcbde0a23ccc4966 2034 admin optional xfsprogs_6.6.0-1.dsc
 c008a752fae65aaf761096eb4698df86 1351792 admin optional xfsprogs_6.6.0.orig.=
tar.xz
 9b2eae2662227f23068ec9531c9c6e40 12616 admin optional xfsprogs_6.6.0-1.debia=
n.tar.xz
 1b3c9407c4d30890a4761705b9b1f63e 5859 admin optional xfsprogs_6.6.0-1_source=
.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmXQdM4QHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFOuNDACbat7df3I6b2VFVMOBkPeWte4hndnJt04Y
M7gYNbpdhwDTgFQ2SC1HxN6N3hjTsBVdOrz5I9yWLcHdc+mqQRWO5RRGPjSjSGrf
d5eXpeTvEyNvXLMni9XfX1mjPfpsDfWK5JZrHjxW0Z9+DZQHw4yvTeHXWqHDAyUI
p7J/bYvPqkB+wuJaQfv9dv6mCGpsERic3YQyTPcyoykrU81kmnzfYB6ofjKpSU0v
inq3OuIDEz/2vmKLzY+B4NLMviHXF+1cdJbz8QYTBe2Izkxb52036KPIx3+JShAF
hxNV329RiNeGvSYiieNdbebF5//b3tIFMkwv8J8M1RCFVv4DFZV6MktGXrF6YjzZ
A+lMr7XKpFIh9DPBOqxxukvOa7RoR8UNFMnJxqn7VGWjqpVYIgGw5HX8x5ELDzuT
GTarWFfqkMPwJKbFboLCuexNhGAfuyI84PdId9MGYTtoKV3tTLS9BYunP7Txf3wt
OKgZ86UvQ5zruzhhtcTvpMMj6tOOR20=3D
=3Dols1
-----END PGP SIGNATURE-----


--===============6570957258389215080==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCZdFToQAKCRCb9qggYcy5
IezDAQC4e753miyCGuhjoQaDCZAxDyCwbQXDrzaRx/xdXHgBagEAyTYIJGhqjvjG
Un0g7Zes5zIOe1CgtYdfZSYlGtYlzg4=
=0teK
-----END PGP SIGNATURE-----

--===============6570957258389215080==--

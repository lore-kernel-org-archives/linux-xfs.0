Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59B13B4EB0
	for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 12:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773835522; cv=none; b=tuR76GXFgu6hw/7VULW2kIBytoUba8v/BZC9FqiuJJ9KSRdzEco4yYKwU2ZazxYw3v6nGqiGEmgge8cTpudqfUD8lChx/OYp91gaVI098EB/+cN0KP65Z4v3rdfUtpK7eRAkDV2pipd7utnHqVLVwmbGejfjWQ++5vca3QD7HSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773835522; c=relaxed/simple;
	bh=J/S4ZXr7Hz+nOYk7Na08LC/777WAtuJX5wGloIW5tB4=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=cz5/PMpJ5H9kLO4CvGiYA2r30e9EYDvQ2IiiAm/MMLM4z6gV+9SOjNRhn65fbwGBZXz2KyxXbfWyGQusO3vCUoDMvhHvu+kkxxiKrjgF59YN1kGASTksFc3qV149hSNM8Nf69CpmQ/KYCqFrRb0u+kQgDzcJLPZODUIHpDJqJ/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=HpaUJbDG; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="HpaUJbDG"
Received: via submission
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1w2peG-006Qz5-15
	for linux-xfs@vger.kernel.org;
	Wed, 18 Mar 2026 12:05:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=mannaCoWxXLx7EB4WJc7fZNC7ZGLTFkei9XM+K4xeX8=; b=HpaUJbDGZOszprVwt3Q5gb81Pq
	PLb+Jijs3XgChPkkkHedtCSx7woxRRuCJQg0kU+vQz8xcyvMCfVBz8zfIejXJzGu3mmj3Fn8afJbd
	z118H6l+dFB2rzgOubfjhJn2adcFf3GTWMAoEqWStqGwlLDgD3CIgzfGY9Nppt5mOzVJZhKVQ/FQu
	V3Su2qIekhn2xwwMeN/hUY8OwGscyEGgztzMiL44xVK6Ai/hLhuT/8aX8O0OJZ1Wfv89bbnx22v4A
	pkM2vl8t7fINPp5ehyScOKAe/6QL6CyjM6Jw/DTqeEe8672px/+u1LWAf2HBoXSEUtl0N04yxYa1J
	CYeod37A==;
Received: from dak by fasolo.debian.org with local (Exim 4.98.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1w2peE-00000007S8O-1SzJ;
	Wed, 18 Mar 2026 12:05:14 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: XFS Development Team <linux-xfs@vger.kernel.org>,
 Nathan Scott <nathans@debian.org>,  <bage@debian.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.19.0-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.19.0-1
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
Subject: xfsprogs_6.19.0-1_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============8109340434263689073=="
Message-Id: <E1w2peE-00000007S8O-1SzJ@fasolo.debian.org>
Date: Wed, 18 Mar 2026 12:05:14 +0000

--===============8109340434263689073==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Wed, 18 Mar 2026 09:49:35 +0100
Source: xfsprogs
Architecture: source
Version: 6.19.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (6.19.0-1) unstable; urgency=3Dlow
 .
   * New upstream release
Checksums-Sha1:
 3528baafc5fc89c29413bd71663f2a5890ba1081 2013 xfsprogs_6.19.0-1.dsc
 ae5f5638f21c646614cc9cf726428473f83ae80f 1564764 xfsprogs_6.19.0.orig.tar.xz
 9777863db473082964d0da932d159c5b2419b7ec 13288 xfsprogs_6.19.0-1.debian.tar.=
xz
 94beb18d672b90d05f0086c8848f761112431c5f 6527 xfsprogs_6.19.0-1_source.build=
info
Checksums-Sha256:
 4c9439f48aec109a35a51995cd844c2c197efe4dd06175873e613fdadaca9423 2013 xfspro=
gs_6.19.0-1.dsc
 f3b0d758ed3802b20f838fefc42bbff431e0f0df2fe03cd50d0aa4ad86dcd0fc 1564764 xfs=
progs_6.19.0.orig.tar.xz
 122872c585955030d034c5a15e83755318df4601750494d210a7ac8b3be84d74 13288 xfspr=
ogs_6.19.0-1.debian.tar.xz
 5aecc3e65083aed3745aa3544f4b883a3fd826bc989b677f865c6400afa9f998 6527 xfspro=
gs_6.19.0-1_source.buildinfo
Files:
 ae5ba197274fbba17bb5b62db287b308 2013 admin optional xfsprogs_6.19.0-1.dsc
 ca1e1fe285aa73d54c60aafc15ad3eec 1564764 admin optional xfsprogs_6.19.0.orig=
.tar.xz
 31fb38ed0b622ac657458b4ac6745102 13288 admin optional xfsprogs_6.19.0-1.debi=
an.tar.xz
 4c80cb4a9452f27d3eb5929458beb27f 6527 admin optional xfsprogs_6.19.0-1_sourc=
e.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmm6kKoQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFLEjDACfjPRXXq58BACLhGnV9ze0oQMI/3DN6sK/
7P3nyd6l2tf3JyreOLUzidtjy8EKbeM25fEopPYoyF45NiV16zXeQosD+iSVcVZU
z6Gi+HygxQ4E6d5uVh1fYG7gZkGDIJofNMKdCZ9+Nzg4hOGwoY4Bc+VGO+sHQTv3
2ZisHEwhqyAHy/Ji8GFmkGbvRekxh/7JKji2m1pqaLUsC6OGlL6qm9hwusV8NUc4
CfCpR2yqsu4Z3VRucjyHpXUM5vcNMcTOydXViWfou7Lv0gzXpeJ2HHR2l9SpB2k0
2dmiQYMSRFcc8uo4AevG2afkVAwK2u0fxgqXc2CBriAigIUv4NEu7EIP6bDBkq8P
BsRXwuyVvgNIeAnbG2rWMtpcJPfledbwuvR+6LEyC+PfazP9bmOs/VzO28YKL3+w
/npbtEPhSOHoLyjB95h8DGQoKBXTckg+Mi1bLPGN3Ov6aatOCVsEGj10NEahjfmV
UKo/gsODoQB52VaHJffQ5De4nE9jdtI=3D
=3DkHE8
-----END PGP SIGNATURE-----


--===============8109340434263689073==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCabqU+gAKCRCb9qggYcy5
IZtHAQDACfsbJRbWbYsK/PDUwEoJCVQ5Hw8wDzARqhK/TBBJggD/YCRxV+MWP3Vv
N0YT12UYrRoe0J2rPVw5MHThW8upHAU=
=pUiu
-----END PGP SIGNATURE-----

--===============8109340434263689073==--

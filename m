Received: from muffat.debian.org (muffat.debian.org [209.87.16.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C5E361DDF
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 22:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769725151; cv=none; b=BC9YhpDVxqruyEQbcBjcV79Ikh3IiIcxOKj/yt6GdEuTR0+dXlvZ04paiggP90t4cn1RbKHNY9H1b87/T4HsJXc3iEYwkoOh+CUK0Vup5u1A/RL60+1NwPIEolh1IqWWUSsa4RwK/moFGIL7m5JE2WttW+o5R65sUx2kuJngaSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769725151; c=relaxed/simple;
	bh=3j6YzFZbHS/Nn3nTDQ16oM+qso81i6ggF+zFdMAIguQ=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=YsV7VqnXOzN9aklZf9lPm9v8eacbuIgBqdl9sjtEtH8z0yNDt6M7QOsUtI4+vS+HeNv6mOPWz4dMBcakw7AGG4HtmC1mNUIE14t37IlVKVoOBsDhu0qq4s3eZ7c0Wju1qUqcXjnIAcGPBR+TQcqXiCSX07qS/g0GbWo+CT9Ndrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=WTNT3X7s; arc=none smtp.client-ip=209.87.16.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="WTNT3X7s"
Received: from [192.91.235.231] (port=37534 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1vlaM1-007SMI-1E
	for linux-xfs@vger.kernel.org;
	Thu, 29 Jan 2026 22:19:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=bPuujfF70KaMm7eexQSIEo/yE58tLYp1MvNi1ZTLrSc=; b=WTNT3X7sQzwR2pBsKD2EYsJPW9
	2017bn3w+dlDBrYuyyCZttKw1DeVCi7IpPpNnnK6NIkz5zE6/6IiCOaSDmvIlyieg3IUbDDrk6jZM
	8dhoW0FLNNISzywj4XPsThPtsSakeZ9gyEkDi/uey15bbxTEvb/kA9y9iIIG8DxuBnFNCPC9sXehv
	nS572CM4wsgNe1DBPkYqX/NZr/sKyt5M1cFNaFM/W/s57KO+suX5f/+pXc75eFk6F/e3VbWh8U6cb
	VkdR5AS6K6aLHIi5+9V7OVwq+Vw15ojgVOim8VBRBS4brujc3A6/EeMe/Eq42tUXVxf2ZVPTYyfE0
	0UzPoolg==;
Received: from dak by fasolo.debian.org with local (Exim 4.98.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1vlaLx-0000000Aziq-2tvk;
	Thu, 29 Jan 2026 22:19:05 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: Bastian Germann <bage@debian.org>,
 XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.18.0-3_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.18.0-3
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
Subject: xfsprogs_6.18.0-3_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============7114662324644175105=="
Message-Id: <E1vlaLx-0000000Aziq-2tvk@fasolo.debian.org>
Date: Thu, 29 Jan 2026 22:19:05 +0000

--===============7114662324644175105==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Thu, 29 Jan 2026 23:05:48 +0100
Source: xfsprogs
Architecture: source
Version: 6.18.0-3
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bage@debian.org>
Changes:
 xfsprogs (6.18.0-3) unstable; urgency=3Dmedium
 .
   * Disable exchange-range as well
Checksums-Sha1:
 0d11f075d1482d9deab9fd7eb955c882bc392b1b 2048 xfsprogs_6.18.0-3.dsc
 6a581be1f6fbd0d6802d896969975a8b8bbe7324 12540 xfsprogs_6.18.0-3.debian.tar.=
xz
 bc35898425b2610e81b4acd2ce75dbff2bae686f 5917 xfsprogs_6.18.0-3_source.build=
info
Checksums-Sha256:
 87a54c722327bbcd9b01ae552e14dcbb89078ca0a3403e6bc8ac687dc2d165a8 2048 xfspro=
gs_6.18.0-3.dsc
 f9d7ea09a36658297d75f874c553df4cb0f9b4c03e3503291b214df09adb2e31 12540 xfspr=
ogs_6.18.0-3.debian.tar.xz
 fc9bd95d74ba2afb4cc9bfbb29da0f5079397f629d0fd16fc84434940e74eea6 5917 xfspro=
gs_6.18.0-3_source.buildinfo
Files:
 615e23c3084c7d454742d8d38c30891d 2048 admin optional xfsprogs_6.18.0-3.dsc
 97cf1223d2d7609da635a5c8a062ab04 12540 admin optional xfsprogs_6.18.0-3.debi=
an.tar.xz
 c44aa118b07a553f79fedd39fd22933a 5917 admin optional xfsprogs_6.18.0-3_sourc=
e.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAml72esQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFJtHC/44/6LaIk3U2fSOjVMyrqHq8TOnBBMOd62c
T/gv1XlkJkkbpM1kAFk50DIw1AXFwZ1cTGS4nBQeFW723L+kEPoKGgdIwx6kmn0q
qtEjK8n40GnZPbjvfjACr3NeQd1X3uYX5xwLXyYHtMW9KPlQIoEXfPE2WA/EQcLp
TRq8gcXsABiTcGPfnpvv3+KxUM1duYL4U/vx2e6NCo4ch/HPjeJcAxs0eKbWmdM8
OB93itmQgB8/IUYW58YHYxroEeDIEgHvbUsPwAzX+22izCdTj2LYR5F9a7LGShBj
Iccnqq/+zzatKoirK9CPuTV6h+xyo4PgO+sV63MNqt8UnAA3/rrCJIzJeAofg/+O
AXfrRzT5spwiFwAefhM1kdyf0djywe68B37B4KL9SXncWjZb01KktLrzChIWDGOW
l++gwq3hmYejLkHogkttS3ub9YQZyNPiTGUSO4UUe/737abhq2v768JKx+z7s8Nn
0sUuFhaHUv7HwCwRaG0n3aoXcGuOrII=3D
=3DYvW7
-----END PGP SIGNATURE-----


--===============7114662324644175105==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCaXvc2QAKCRCb9qggYcy5
IV21AQCoea80hzFsA7XzpryLJZOwx+9ROI/pInOrFL2AbfoojwEAvrQ3BEDu2aMb
uZycYo/bkyqrOcccXiKvCsFzkJZKNQs=
=L+qE
-----END PGP SIGNATURE-----

--===============7114662324644175105==--

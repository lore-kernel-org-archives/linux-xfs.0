Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF14E365A18
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 17:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771608829; cv=none; b=Jq4K16NKfXJ1nyxF9Ju/AeWm5wI3pPs4WXYlA80qMocEIFBaLukHjNh0FG7KGemxa93kFMzTwSBcz6j3z55iXf1wjOXwpLJ/Vcxr+HNDLuJB4q7OMcZ8MoJ4OnjkQ2NMyuiWtK1pPeavuMr4L4tqKR8YJwPbTQY2HY0kpfqdCfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771608829; c=relaxed/simple;
	bh=zikbnsWJ3TIgIKZV55r7x2NqU+NddWmL32JjgJxCIT8=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=QSSz117oA9RDWlt3kcbS1jvs1Sx+iJ8f+qiLubxT/boKLzatTguyzbQkKleU4SYrr5ECKpADp32VEjEpffNOo9l1+RJKM9xraCzfCzHILULq8I9eYwY9AJIFW41Noxn7vEtGloCavafgA4fkLtjb8f3RjF6u54fLKXWjRdpOkGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=r66fkeq/; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="r66fkeq/"
Received: from [192.91.235.231] (port=38452 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1vtUNn-00BkWy-1o
	for linux-xfs@vger.kernel.org;
	Fri, 20 Feb 2026 17:33:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=v3ck70r3lBa2peK9ON/WclcloSaDdP+rVUvOm6lbdyI=; b=r66fkeq/dGWFL2PnH7BwZgNshI
	AHIskuZc5dVmrWuCybv190VUCHMtNzydLcH2XJU99YEQEl9lKF6wPcw4zl9UNixkKIWcySVQJZPSe
	I+TWaDfvC9k5eTPXRMUDvEKR6dkDIfGR91LC1Hl3lQ2QhMa4okVYAC/Bv2fHksHEQlLZAUHHZ0tC6
	AQHlolc3aAJGYTeojOS7gIwnJHaUjYV1jzPKJRXP6fASb4Q7sMSY2nv9pzRaSppmjHtPlQ19sK+P+
	rLnRXOh8UIb0K2SKr5dsTgio1hiME4oEYxUHzTg4kYIdYTOvG8C4JPK/gRRVToMRSfSO5xi7nOGIA
	21I0VUrA==;
Received: from dak by fasolo.debian.org with local (Exim 4.98.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1vtUNk-00000000AzN-20e1;
	Fri, 20 Feb 2026 17:33:36 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: Bastian Germann <bage@debian.org>,
 XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.18.0-4_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.18.0-4
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
Subject: xfsprogs_6.18.0-4_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============2846991371207014941=="
Message-Id: <E1vtUNk-00000000AzN-20e1@fasolo.debian.org>
Date: Fri, 20 Feb 2026 17:33:36 +0000

--===============2846991371207014941==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Fri, 20 Feb 2026 18:09:05 +0100
Source: xfsprogs
Architecture: source
Version: 6.18.0-4
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bage@debian.org>
Changes:
 xfsprogs (6.18.0-4) unstable; urgency=3Dmedium
 .
   * Drop the patch for parent pointers and exchange-range.
Checksums-Sha1:
 f18de77cdc92c5be5d7855dc5d27971d71b00650 2048 xfsprogs_6.18.0-4.dsc
 43681e9bb9ec0ec0ff9e101f9ee8649149ef8a9d 12144 xfsprogs_6.18.0-4.debian.tar.=
xz
 fbc5dd0e2fa4ef2065227960b5df195eb5c9b799 5862 xfsprogs_6.18.0-4_source.build=
info
Checksums-Sha256:
 c70b2e6c8d97e8a9656db2e095b9c398e32681f2906892291183a6dfd041dc5b 2048 xfspro=
gs_6.18.0-4.dsc
 9e10fa82b58600950ddf30b463c8999a2e148edc39526046cfcbac023fe12a71 12144 xfspr=
ogs_6.18.0-4.debian.tar.xz
 64c074a791c93a85fa832a45751d0459b08aa46bf03160e3364b685155410997 5862 xfspro=
gs_6.18.0-4_source.buildinfo
Files:
 20f9dc48fd232cdfb742649a5113eb99 2048 admin optional xfsprogs_6.18.0-4.dsc
 9ed67eaaa9791b9f95d708aa53a641dd 12144 admin optional xfsprogs_6.18.0-4.debi=
an.tar.xz
 61336ef5e7f2aea443cc1c5850a07f91 5862 admin optional xfsprogs_6.18.0-4_sourc=
e.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmmYlcQQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFFMgC/4t+akrY+eV3QjUN212x8vLqvwt9D9eln3q
2+B2tU/fGyIGita5q13BzVJaKJ+74Nnp6O9ymHOZzEWtx7Ab1WUzAC+qWlxzQ/Ng
zWEXxjVle8Ze7hCvn3peYaIypKP5QDIfWDNmtNKds5TeM5DTnWlHkMN2agbrz9xR
qAat35voWMfTJtg5NEm0jNEGhRKjPASGyf4ALAih4/OyRhJeg26lx5a6jjuo+/8n
LpJyw9/4EMsbgXyFcasO0wgrMF0VFzsn5enAw476wmjXQvL0B4e3DqsJHDIWmWM6
njxj35Z4zAYELZIbhUrirTxHUr9Tupjwgc6FjkmrRF/yoifWHJysZ9ZJNrmIqfTS
LKJm45gDW+CwWXXmUju5kIJ5MmNaMmXoWaaH1eVGv5ZITvVqVLL5EN2O7BLXRuJn
IEeUT5uDHIdqfbCxppMRg1z5I/GxxAf2SEQanKMsErmL217ey5q1v9fMzzmOo0Lw
7Jibdlu0aQbmO5xI5wl7U1ETz2GV1eY=3D
=3Dv2kv
-----END PGP SIGNATURE-----


--===============2846991371207014941==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCaZia8AAKCRCb9qggYcy5
IeDFAP9cXY8D64PUcuY7KvRLANcvt+tk1YUHbzRjUyXKD71mLAD/fx9NjI7eHVXx
MwG01dAY6g/syVmDHxy6FGhkJ4i4VgE=
=+y9H
-----END PGP SIGNATURE-----

--===============2846991371207014941==--

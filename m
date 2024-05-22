Received: from muffat.debian.org (muffat.debian.org [209.87.16.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728431494B6
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 23:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716419146; cv=none; b=RS56tYityb3KVoiosxbgmHIbpktV52anfhR8HNw/P7XxnYT7yz9zeXJjZKnooa7la7fErIgA4J4MSOJ657zeTJEnOpe6O2ZtRZbgypubKQK6Vp+QvjZEXQyRs+uotuQRQoIQClO+xQvWymXWkDrZjOx5txZBMSLn9MEPtIYZkQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716419146; c=relaxed/simple;
	bh=tiBreC4C1YUI4pmi3y2ZHCLAGpEEE5JkOQnOKvKvjvA=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=SOPokOfBR7TG4Yx0FIXIUjgaElCHWiO8WlaYOlbotomE8FF1dPJLDKxGm7qnjzdRNf+sawkHNgkFUvdca6DWXAwxeP9gzJCHaSI4gR6B6NIsAo0ucsjT8qSYZ1XsTdxxfLXsiFyE+1LVWi3ILK4LQ7BYTNmWEgKY03KF73MFo+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=NDZMgxYT; arc=none smtp.client-ip=209.87.16.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="NDZMgxYT"
Received: from [192.91.235.231] (port=40598 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1s9v1e-0000G1-AX
	for linux-xfs@vger.kernel.org; Wed, 22 May 2024 23:05:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=5VpyDtYIfdNHBu+cP8IqtKdBFlTjBTRGISTd01N3tpc=; b=NDZMgxYThGsqS5f2Yzq8XeON6p
	WShlyXlC4BVJ2gdQYMJ514IO/dkScW+33Ek4ZIVlHv/Yc7JVLZpIYnZE92+Xj9RNmO0WP0h30UhlY
	3CBA/bdEZKToOGeimplXSbT80Eckj/OoiYuDSf5PYGo3BBUKe+l2FETCL1jutFxTOpMqVHd8rDBTd
	CBsH31+agB/u3mIgBLm+V1ytzAg5WLvL6nlVRWof5N3bEO0hJGTLKT4MpYbuJ7J1HuD9GmyqqE+18
	zgnsspra6SY9d+xTg0L9YXmyvGm8ydljcRnish0OctpiciVR40AseMtE8lg9MNOI3BoMZf0BNrxTC
	rzfcYQrQ==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1s9v1Z-000NUm-Dp; Wed, 22 May 2024 23:05:33 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: Bastian Germann <bage@debian.org>,
 XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.8.0-2_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.8.0-2
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
Subject: xfsprogs_6.8.0-2_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============1637208704852889351=="
Message-Id: <E1s9v1Z-000NUm-Dp@fasolo.debian.org>
Date: Wed, 22 May 2024 23:05:33 +0000

--===============1637208704852889351==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Wed, 22 May 2024 22:44:14 +0000
Source: xfsprogs
Architecture: source
Version: 6.8.0-2
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bage@debian.org>
Changes:
 xfsprogs (6.8.0-2) unstable; urgency=3Dmedium
 .
   * Fix build on mips64el
Checksums-Sha1:
 df0994f248e30a636e3ea0433d20ab37fc9c17b7 2034 xfsprogs_6.8.0-2.dsc
 154da395ee40037351c203c664b47095939b4024 14200 xfsprogs_6.8.0-2.debian.tar.xz
 4a61dca5bfad8312bd145b142ddab3bfc50754a4 6418 xfsprogs_6.8.0-2_source.buildi=
nfo
Checksums-Sha256:
 387b087e68082f3f4e1a3eaff97644e923edd686928a877f86b23eea347bea38 2034 xfspro=
gs_6.8.0-2.dsc
 993808ce25a5b79c1ea83c00a3a7fa05ed8631b37ea82775704c476eb13ddadb 14200 xfspr=
ogs_6.8.0-2.debian.tar.xz
 bd962c1ae5bf6c5e74cd1d17dea1dd2528ffb1879704574f1fff8ab64567bb6e 6418 xfspro=
gs_6.8.0-2_source.buildinfo
Files:
 e7a5389a7dce60e96eef18d5ecac1214 2034 admin optional xfsprogs_6.8.0-2.dsc
 51e84cd7df255d7f811106bfacbf7727 14200 admin optional xfsprogs_6.8.0-2.debia=
n.tar.xz
 beec52267c3006e127dfc303ace90aaa 6418 admin optional xfsprogs_6.8.0-2_source=
.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmZOdfMQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFGRtDACAePncHd9+XawFwfrHGBwvWpUpp+CBrR5j
BKr9sgLBlR1824TzUxD/emHwXdOP0CmOvJGx2PGApvCE80qJrn1tzMyfveVg4a4w
xlYTIn76Tnk6boDK4n3VaRQPv++2c/MqckeOmku0+LSLAnZvWRmlJC3/ZtA8o6va
jpLx3apV+y42ar2rEHixpcSvqrQ3tOBKBVRIDSBMQ/7HkViR410pXHJQcX4kgbkh
onsVxVK5PpXgVRnJRRkjFNiiL1goJHUyD834TELQf4h/yWAMoIxn2rtWcrFFpGhO
3UP8boV3BIMxOlMujN/r72OBrW5sQplqIWL56RbFb+ICTdCy6cLQ/WWkEXf5s9gq
aVos3CqC9ZN+6caqC0A/7k2xB6va28yzzGGxpZrpVmJ/jbq3wYgrHYVCNMSMqZOt
GNZwwV7i1PFnd5xMQu++xPt78jPTpXqvs9gJJvYMU0ooOIvebRDc+dPZ1ioeBSjB
JD12cG2QFJJtmfoIDEsqhyV1uxoL8+Y=3D
=3Dv3+g
-----END PGP SIGNATURE-----


--===============1637208704852889351==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCZk56PQAKCRCb9qggYcy5
IRArAP461gUkA2qxQi6gsDe8bH6LV8a4k996xlwV/sc3ZQA4QgEApFjqWV4VYfX4
Wl/IaWQQMloiPpJA1dJefE2Cb1IRUQs=
=WV7V
-----END PGP SIGNATURE-----

--===============1637208704852889351==--

Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B2B34D3B6
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 16:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778777; cv=none; b=dEaE5rg5QM0zHTtjps7CAI+0DO4294RQ9Wf3Yk1MLksBgCEr78NBEnq23Ocz8wvRlHcvnN3/tWy3EDMn2KprBQURyNoVW45WQ+2NLuqLQ7lwOigfCmgqqMlvzEZV70TRMprBfXDgHXn1LoR2bPOZ6T+ybWGuyh/WXLHdVn/jxEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778777; c=relaxed/simple;
	bh=xg63OM1HHdPZxIq5uVwxn3ZdIIb+doYdWfpLCbJHjts=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=SNk5Nmsh3nwOZIavwX/huYyFY8TUk5EZqNsGs7Q7IChkXClVTXcnvpr6mChc+w6JkSK+b6T8niP9RrNVegSlA1t3ze7ld74eWXC4DV+UhqtcKFOknoipYLfQ6I85VGlUcw4kXRYe+6hq1uR+P2uWmZWjwgKoUDXW2hpiizjJy8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=VRAA2tx5; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="VRAA2tx5"
Received: from [192.91.235.231] (port=48346 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1vQpZl-003amV-0H
	for linux-xfs@vger.kernel.org;
	Wed, 03 Dec 2025 16:19:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=noNnfQgjSbxgrvxXaXTg2BamexR/g7DzIdh47ap0Zvg=; b=VRAA2tx5gdD4+dmXiyKWOunfgz
	v+P5TXHqgHtFt8gCqhEzM6wOohrOFRuR3w79IZHW0eEJ2FTKp7HAdA98WmObN2p1D1HZobr+Jk5Vn
	eIpOywFS/1Akdcomki2IfDu+I8ta1kxqzVvhRWymEN4zwubwEWvKAWmq5CrSpboLh4fS38gHMrb2b
	hrhBdud1BnBUMJDlOAN7SQEprlUQe5cMokUpoRIWX7XEwSVuunAxNoHqD/OF2DrsKLb6vPNz8/Sq5
	Ds65GXsrG9OBV4QvWZJEG3eFm11GcDN7SUA2ONrRC9NtzKYQOZWpQMA0i1URm+zak4S47AEClI3cI
	JHxJbZNg==;
Received: from dak by fasolo.debian.org with local (Exim 4.96)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1vQpZg-008QhA-3A;
	Wed, 03 Dec 2025 16:19:28 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: Nathan Scott <nathans@debian.org>,
 XFS Development Team <linux-xfs@vger.kernel.org>,  <bage@debian.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.17.0-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.17.0-1
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
Subject: xfsprogs_6.17.0-1_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============4360717165832518639=="
Message-Id: <E1vQpZg-008QhA-3A@fasolo.debian.org>
Date: Wed, 03 Dec 2025 16:19:28 +0000

--===============4360717165832518639==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Mon, 20 Oct 2025 16:48:52 +0200
Source: xfsprogs
Architecture: source
Version: 6.17.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (6.17.0-1) unstable; urgency=3Dlow
 .
   * New upstream release
Checksums-Sha1:
 96e75036ddcffefabaca88aa704237fae1806ce1 2048 xfsprogs_6.17.0-1.dsc
 95f85c969beac6e5473982fb074f5cabe99f4cd7 1563092 xfsprogs_6.17.0.orig.tar.xz
 f2bbd07881cd90ff89410f2f40cc07f7c9ecf687 12016 xfsprogs_6.17.0-1.debian.tar.=
xz
 439690d25e07631e92c03c9ea316eea25cd22c32 5771 xfsprogs_6.17.0-1_source.build=
info
Checksums-Sha256:
 151dab53f52aff5db127162f1abeae95a745c4d8c9e10ee3f280c894bd308afe 2048 xfspro=
gs_6.17.0-1.dsc
 5b0f56a81f641326266f762ae8a563b29d95cdbcda83bc7938f68ce122f1edd9 1563092 xfs=
progs_6.17.0.orig.tar.xz
 d3cfb2cbfc48535ab6896f8afc1daf5a10a0c9a600359a08ada1003f83f91c01 12016 xfspr=
ogs_6.17.0-1.debian.tar.xz
 dcfa84b208ce4aea8179a6d52e5e760fa54ad54db93f10e982c1bfe384ffdbe5 5771 xfspro=
gs_6.17.0-1_source.buildinfo
Files:
 225a12fe004cdbe481ff938c80fdf913 2048 admin optional xfsprogs_6.17.0-1.dsc
 86b74d5d24d3f2d3d3bd87bc712698dd 1563092 admin optional xfsprogs_6.17.0.orig=
.tar.xz
 8bf000a0afce975a484344213a81f3fa 12016 admin optional xfsprogs_6.17.0-1.debi=
an.tar.xz
 1d1af7203e75ad176af0980fde1487ce 5771 admin optional xfsprogs_6.17.0-1_sourc=
e.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmkwXmMQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFBb7DACosTKuOugW957q52eJTMrYca8qrZrcc4bO
3h3Q4s8lf2i7hQgF/jiFm4ptLMaR7Ofv/d+YbkRqMTSDZo7SwQrr+rLcDFqJEf+R
tsTNXmpY8TdsM2SrfeBVHbRL8Sb/Vs51SjKxQMtdn8QFriDbbkaXgetLXhGDjpVJ
iT6qu8ZVLJXHkItv+DOoYz0C+HpJmNJm1qNtnnAzc2yq5vnYATiIC0yH7L7dE2X/
qzfJJau5t4Bdfz2nUtEgkmGjHYYTlF2c3P1Lj1CMp+169lHPM4CWycMnRWIJsnXM
HzhHqOSyynrUlOtrJq+q0beQuozTk85ia1bgY8JmzA7lqz8U/2w2tiKNV859qAI2
r1aG+2ryBY7QIt1jozHicI65f1rDQ8bjnOAdLkUwB738FdAMDTPRZ8AyIWOWr6KW
+ssZYb3aa/Q0WOc00HM8q98zMBbW058SfmZTmKXQrsdByg+lMfBxLnDyxp0dJnT9
w6dMipTsaaez/HT6EFjUb2T9OE/OUy4=3D
=3DpLDM
-----END PGP SIGNATURE-----


--===============4360717165832518639==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCaTBjEAAKCRCb9qggYcy5
IXhAAP0cgQaItb+9d/JZpBFzFIGdxFCus3mGudJaHF7S6WBUmQEA3QXSwU2BFcfb
WQrwSY8Iexd/SeaC06tIGJzIJbwNZQk=
=4yQX
-----END PGP SIGNATURE-----

--===============4360717165832518639==--

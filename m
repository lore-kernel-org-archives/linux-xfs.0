Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E891E1C1B
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 14:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734101292; cv=none; b=OIHDJT8p44vJZ1NWRBFgQZjO400OyFviw86KAHW4+aJ3eYLCI1ylQkIgIESXlrHJTTEUe413a1x7DHKWdORSbwn2eq+wDedVuXQx62+c1gqiYRGankgu3AXgL7VsmVgY9j023aOWKOgYdlyqNF7MksHbgOULGNmR2NUUMehtRzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734101292; c=relaxed/simple;
	bh=KqApKtqXpwruadm4yo2t/YebGuN5wU4uuQ9Pu8I5vOE=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=RWrs6SlgkmHJxmqYJfVdRuOLgtWtWAWkHyxODI+r/MpE7hYFArt4op1tsHGL2/qjQqn6Wp1Dd5gWAaGg1vG2R6dcXi3YYKXf1v/gFhQ535QNAz3bZ0kfnnI1MJ2LnD2mEb2cnFmu9pRxj/nTUTf30hiy/iVlG45+eXzTe5p0yuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=EvXy1YtC; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="EvXy1YtC"
Received: from [192.91.235.231] (port=45772 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1tM6xW-004lbV-1M
	for linux-xfs@vger.kernel.org; Fri, 13 Dec 2024 14:48:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=j1fljZ+rUdVrzEjuOWkgAtN6u5FYh4u+gtL7QZraZDY=; b=EvXy1YtCGVHZdWZOJq1vcX10l1
	ZXoHcqIu0tw16xfjuUu+qCHMWPLCAONORejQY+JUgYMwe9EYU8TGvlILWBJW8CwkzRVfFrLOJMJ8g
	l5FYnKBpAfQv5NuR42VJZpJ+zaJqua7Gef+Cq/buxTfMN/ynCEcewexI3gucxIBSPwvNM0ab61Zue
	A80JgEC26IpWaSenuq+w7i7Ok2qem29WWSlAISjYWZo/ALUqR+CohKimGickGhCBYkOS9ZwzyiKts
	QPG/FlAyuF8swC+4enCqsb4u1sZkf7tnNTBHEkHgmwx0ksjscJHR9++MjBdc/P2P96dln0U/kIaD7
	JcoYHfRw==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1tM6xT-003XOh-Bc; Fri, 13 Dec 2024 14:47:59 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: XFS Development Team <linux-xfs@vger.kernel.org>,
 Nathan Scott <nathans@debian.org>,  <bage@debian.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.12.0-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.12.0-1
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
Subject: xfsprogs_6.12.0-1_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============7428874396575157552=="
Message-Id: <E1tM6xT-003XOh-Bc@fasolo.debian.org>
Date: Fri, 13 Dec 2024 14:47:59 +0000

--===============7428874396575157552==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Thu, 02 Dec 2024 14:00:00 +0100
Source: xfsprogs
Architecture: source
Version: 6.12.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (6.12.0-1) unstable; urgency=3Dlow
 .
   * New upstream release
Checksums-Sha1:
 76bc43fac699e93246de8f1540ff0b191189b287 2048 xfsprogs_6.12.0-1.dsc
 12ffbc6118feeca6b747412a8aaffa35c746d053 1471672 xfsprogs_6.12.0.orig.tar.xz
 e311e8aee5834fc1c85ec224970f39156e6db80d 13196 xfsprogs_6.12.0-1.debian.tar.=
xz
 31392d40b52eafd086558be980e805155fcd4976 6637 xfsprogs_6.12.0-1_source.build=
info
Checksums-Sha256:
 1a58cd8f82b046e4e978f6deb6b3986cc921ad547d6d49456c0c443f11c18523 2048 xfspro=
gs_6.12.0-1.dsc
 0832407247db791cc70def96e7e254bd6edf043dc84a80a62f3ccd6e3dffd329 1471672 xfs=
progs_6.12.0.orig.tar.xz
 df4b604e1dc7445806d0bd2b96d00d9dad0a41b36f385e1ecc0c4b07a4cfa10a 13196 xfspr=
ogs_6.12.0-1.debian.tar.xz
 0eccfa59a96e44557bcd76bd7d34804263a4266c1830014c47392aab5fc027f3 6637 xfspro=
gs_6.12.0-1_source.buildinfo
Files:
 dcdafffdbe45600defdbbc1b3183c84d 2048 admin optional xfsprogs_6.12.0-1.dsc
 c2f1ddf241f2ce7ea2669de595a4f766 1471672 admin optional xfsprogs_6.12.0.orig=
.tar.xz
 31fe0919679c011abadad346397e291d 13196 admin optional xfsprogs_6.12.0-1.debi=
an.tar.xz
 68da45e13490d61f9248e4b23b5cf370 6637 admin optional xfsprogs_6.12.0-1_sourc=
e.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmdcPoMQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFDKlDACFFzCidl7oAJGeepOCWmeRP+Ypnc2zpLc5
ro54xStUOfrOgmnHJjnIO8jmsF3QYvimf1KrmqZrJ8u4ZhclTE606svDvCZAfTga
4wCiImSdoQA17iqeZ43fHKWp6FegWbjZGBLGWUA7U2jdfWqtOIDh0EbScbTiLUPd
aZ81z0c0MyZKTb0KqFr63tynNVVdsWxu6hfqtdx1bJ+BysPScm32e/liYDeu92oN
E+Q8y0OZJR0myNZanL0X96/52ulxiuw2cZYpuCKzaASLO82EWTJGYC5mNx7eh0Y6
w0Dw0eG8otRoYxgqIt1sEsp+fFlPd5yVva2IM0mpCTGWx3pS6UM4SN6jHN+NWb9l
Qb+1S5jpNs3LAbnR5V34qISuEYUdz2LtpWiuUPJfT7YmREfKyAehxZD1lgoaLhoc
zXCQ0tied/FSM5fGSchvEwffK/Gn/RVBFEmQApTYeBVK5wv75VPx1dEuL5KGEf51
P+PzCCRYvZYsT/aXTA/TkMK4yv8Fx4k=3D
=3DxDLy
-----END PGP SIGNATURE-----


--===============7428874396575157552==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCZ1xJHwAKCRCb9qggYcy5
IcPYAP4yvmDX4Py14zZSz04w9DvKQE9w40vj0xVKBT1zAo4DwQD/WadfHmYlGOPw
8BJJm/Pc93rGKhhj94kIuVCEMGRsWgY=
=iIdQ
-----END PGP SIGNATURE-----

--===============7428874396575157552==--

Received: from muffat.debian.org (muffat.debian.org [209.87.16.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F84315278E
	for <linux-xfs@vger.kernel.org>; Fri, 15 Aug 2025 14:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755269248; cv=none; b=SysBWpE7XE1m3XVG3pZdrqFuSP8hPaxoaEmH0mcW4MU+VNfl9dRgiFgmh1mj4Dc+jVf2KoBQ8m4a4Y/nYwNUR+LPxTPoQlkoEoDTM4O220gHJbkqv8QICxbSljXxJMD6u0lepYy6fPQhGzvW0g2fLoyjdKjJeVvIN8ABjffVMGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755269248; c=relaxed/simple;
	bh=4DukySNyk96YDxW3SC8BEllmA9M8kYgjwNmQYeoLIpU=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=gqgEU6NYuhWutLf01RrqahiQbqDP1yBQHk9R6IXKIbFVIKvePhRI2Oo3s/uOXAwQ17n9S4CAvJhmf8wgSfNJj0WpBr4JyO6goC+pHB9/X+1/eSKxVOG6dGxCyrpag/l9trILFEeLq+fIDyZyQMlYXxamrxdfqHF6tb00Wor8gWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=Ujhub4MA; arc=none smtp.client-ip=209.87.16.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="Ujhub4MA"
Received: from [192.91.235.231] (port=60778 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1umviH-006gzQ-A4
	for linux-xfs@vger.kernel.org; Fri, 15 Aug 2025 14:47:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=S9d5Uz4/mWQBkP8XWUlXCkod0SdH8jJqBMsJBk4ZlM8=; b=Ujhub4MA+NkpiE2sfPXwCBgE9/
	B2Un99lHdKJRM+dLBfq2Rw0eEj4j0WBTwd4SFNS/5J9TqTwgaimdeeYaOPi7MMrePMnMtJFXF4h6z
	JE0zkqiWRC+quXgYxIiW8ZLUweFQDG/PdjnLEju9RkzvtACFxiR2s9z96wXIv4ie6I0DIAt8JZn1x
	0XSJe288WdKXfU8NkSVe5/JHADxS6arWsd2+W851MGy6LzbF2yC0dPN1sFJYOmVGeGmQEzeafzZqm
	bZeoMeeuQd+5S9Jkd0mDAZRddzMMoamVrKrpbyp5gTb5dysLs9/vbEPI4BKDGQy71XtAP4DbxEbvM
	bu4Qt+7w==;
Received: from dak by fasolo.debian.org with local (Exim 4.96)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1umviF-0011ug-1B;
	Fri, 15 Aug 2025 14:47:23 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: XFS Development Team <linux-xfs@vger.kernel.org>,  <bage@debian.org>,
 Nathan Scott <nathans@debian.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.15.0-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.15.0-1
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
Subject: xfsprogs_6.15.0-1_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============6900375933151469011=="
Message-Id: <E1umviF-0011ug-1B@fasolo.debian.org>
Date: Fri, 15 Aug 2025 14:47:23 +0000

--===============6900375933151469011==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Mon, 23 Jun 2025 13:56:27 +0200
Source: xfsprogs
Architecture: source
Version: 6.15.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (6.15.0-1) unstable; urgency=3Dlow
 .
   * New upstream release
Checksums-Sha1:
 9beb8c624b4a3b43cc1370a69482ebd38b1ec8af 2048 xfsprogs_6.15.0-1.dsc
 eab15ebfe870175ecbe89b9abdd9164530d08bcb 1550568 xfsprogs_6.15.0.orig.tar.xz
 5b8b1d824f0137c3d9d4b085d1c472998e48aabf 11992 xfsprogs_6.15.0-1.debian.tar.=
xz
 9ff61aec85cdb64a049ee847bfec81a25fa32ff5 5555 xfsprogs_6.15.0-1_source.build=
info
Checksums-Sha256:
 cb30420eb8bbb0cce06206c9b72143af660240c3387ed939766f2ebbe85e12d6 2048 xfspro=
gs_6.15.0-1.dsc
 13b91f74beef8ad11137f7d9d71055573d91e961bc55bb0245956f69b84cd704 1550568 xfs=
progs_6.15.0.orig.tar.xz
 fc96aa7249ef44ce97d74e795e03e13a30a663c0f976b7639cfb4b759f4631d7 11992 xfspr=
ogs_6.15.0-1.debian.tar.xz
 78355cd4554c03abf64b092b43cd714d416d7b5dd28a5b0bde1c0235ef06ed3e 5555 xfspro=
gs_6.15.0-1_source.buildinfo
Files:
 aa93c73b7de7f5e92c0df7d03f0b8dab 2048 admin optional xfsprogs_6.15.0-1.dsc
 5a0ce9d3544fbabb8b0feb77dde05d62 1550568 admin optional xfsprogs_6.15.0.orig=
.tar.xz
 6f77554bd2cce3fc880ae41aaf12db46 11992 admin optional xfsprogs_6.15.0-1.debi=
an.tar.xz
 bed5a3469377a030a5912df5f8161414 5555 admin optional xfsprogs_6.15.0-1_sourc=
e.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmifMWoQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFMOzDAClfFf+DHye4jQsdSeson/U3kF/p4BoDmEv
wAvIs9vbOa1kEOvSuAitEN6Ba1B0XBOy4+/4LNlizb6U6CxnjNYRfkqwT1ppGzIO
DXVz1O2vVxyNr7DcRWvsj+udvBf0KC8wMyjZyXqm3EY48RjuHCi2afvrstjlS60O
J7hZWkNbUgOfzTTxi2pFafTjqpop0uToZ96+afdm0t9ST5Gx83WYdjnEVdhnw/Eo
z6DFf9AHxk6I5WG0KFS2X0FiU5BsDs3ZRR4q1kASTsUOMjstinTpCEwlBHJvYP5O
jw0rh278iwitcS6/r1eNp5ggi603h9Lb6tlmJpPP8P6j8Z9RCKTppwNkddVwyD1w
qsUPba9k3U52MtjSf+zP/nak7xL9nvjYpLXI0cbEoBRWTcHzZ/36wZ/+HzMlbRa9
OL3lyxR8wWHN43BmlpPbVg5QLQ3sXi//n2V1pyCXFsChpsTLPFTL7955yR2ly2v5
4C2Xa2Eq7Q5zw8Mroh0CUvjDH7ODQdc=3D
=3Do2ni
-----END PGP SIGNATURE-----


--===============6900375933151469011==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCaJ9IewAKCRCb9qggYcy5
IRk1AP4gBtBWjCKgJTfoo/NlPjC6cNW5Z6JOkwKtCWvF80rQwgEArhliYq5K34zr
qUcEuXyokkoKWLooVWtRYsl5Knm0KQw=
=Ph5M
-----END PGP SIGNATURE-----

--===============6900375933151469011==--

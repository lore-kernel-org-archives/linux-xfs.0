Received: from muffat.debian.org (muffat.debian.org [209.87.16.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A051A254A
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 22:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719269887; cv=none; b=IbLyGBUglhf5fn+/qpjeilemhcF035KjlERxUVL9qDu2yDPQrsy/NfMDWH+BeOOn+TaS/nITgNWRZtXGo0wvkKMnw4SFuc1Ju1mVYnan8OhCwVjKOrRTlEpOFsuNDTC2NhR2363ia37rPP/qwgj7US+Ol+c2t8WNdR3JUxe/jD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719269887; c=relaxed/simple;
	bh=KDNmpquaoFNQo/KI3TbMxuMhWDhzXfnt+juUX4MrPsg=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=sIqUjQhGXNAK52cqJ9RButaKuKRlbZVlI+Xm/X1F84LcvRIwzaMmXYcSPJhKeoIvwczuafKOBr56l5YIusDmaOPfdAaG5Rh1mx5waJpiB8L+kFn2ZATNeGJ2OVFkP0o/XFNMApg9gAGf2hEJFOWzRMPzmelkvzYM7ntVCNkgeD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=QEupPw/U; arc=none smtp.client-ip=209.87.16.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="QEupPw/U"
Received: from [192.91.235.231] (port=33332 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1sLsdK-004WwM-JT
	for linux-xfs@vger.kernel.org; Mon, 24 Jun 2024 22:57:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=x0fRU/QR7vctlr0fwJ3BfZOyjHTTxISoVoY22PIq9GY=; b=QEupPw/U/55oFcopRPjQMF7Irr
	c4LFqXwZd/kC5pOaOk/Hej3VNSCBBa7Xz23K/aVvHXQz1dM3a7FZua5Z3njRiJqvM5FZWDdTXoGMK
	CbqZHzVYOt9CJaUKw87TyqInl3O1mec42CA3wLtNYS/D3tDUmBRlK2j4gOYvNyVIgHWSYj9TfdQlu
	yYsYgPykv9RS8Z3zFQGBmD3E70DSi3Z4Jt5wzzxtJHIQcNx0876klbhUCO4ffzynqHPjjuQr/5WUa
	7JNw42KXx1oYeWEVPrFFMLqs38kaPCUdVDeUHd4fte5X+mN0mUlnKOYWzXZPKX3ercAIbJspzmEgx
	1Dx3wyUg==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1sLsdG-000W7s-BB; Mon, 24 Jun 2024 22:57:54 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: Chris Hofstaedtler <zeha@debian.org>,
 XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.8.0-2.2_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.8.0-2.2
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
Subject: xfsprogs_6.8.0-2.2_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============4280636238333136686=="
Message-Id: <E1sLsdG-000W7s-BB@fasolo.debian.org>
Date: Mon, 24 Jun 2024 22:57:54 +0000

--===============4280636238333136686==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 1.8
Date: Wed, 19 Jun 2024 23:33:58 +0200
Source: xfsprogs
Architecture: source
Version: 6.8.0-2.2
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Chris Hofstaedtler <zeha@debian.org>
Closes: 1073831
Changes:
 xfsprogs (6.8.0-2.2) unstable; urgency=3Dmedium
 .
   * Non-maintainer upload.
   * Fix installation of files into xfslibs-dev (Closes: #1073831)
Checksums-Sha1:
 d684bac728187bcc2b7098eae5ffbcd8dc9050cf 2192 xfsprogs_6.8.0-2.2.dsc
 f2c3de94afbce3281d1cf2cb0e01d091e0a767a6 14676 xfsprogs_6.8.0-2.2.debian.tar=
.xz
 09b62b733552d58fafbed0cb63d6dd59b62aa676 7459 xfsprogs_6.8.0-2.2_arm64.build=
info
Checksums-Sha256:
 f0a6efe3c078b23cbb5f340a096e2850942778e77af1389c08e0d6026e50e91b 2192 xfspro=
gs_6.8.0-2.2.dsc
 2e778d52565ef6c3691b483545e0c226c513049f9fe2d3553bd52dd1cefed1af 14676 xfspr=
ogs_6.8.0-2.2.debian.tar.xz
 e6b0bcd7104d8576a47483db25ea572cf89447e928828a077d038e396c9e7519 7459 xfspro=
gs_6.8.0-2.2_arm64.buildinfo
Files:
 fb5563c0996268f7600741f1ab3408fe 2192 admin optional xfsprogs_6.8.0-2.2.dsc
 a63a8fe47b7095b46f0a0bf8682d1251 14676 admin optional xfsprogs_6.8.0-2.2.deb=
ian.tar.xz
 ba5172afe40fbac73990db0c18712a75 7459 admin optional xfsprogs_6.8.0-2.2_arm6=
4.buildinfo

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEfRrP+tnggGycTNOSXBPW25MFLgMFAmZzVkkACgkQXBPW25MF
LgNmIw//VMGQjxhHC0SjSU8s66PETN5Q0etCW82y76pDl6Lek/UuFhKteAUvudCw
YJU0XR3X7k1LF6K/m/63ucSxq7HDx22Ce+GoICTcyqbbvwTm924p/GoQ9Tk0YLUu
wkoYjEBUBnHLcDbNfJBy5vESmUvnh48rfBkp/mfGHmSUx/y1mFpYpVpmSi9edSuj
6YFFIW3mzYX5bPwA7a/PTIcCmncsWUapn1PYCWBkOBf48rvD2p7Gv5g2rO3YfYZ+
m3eRS8+UiTSZ0PJ0A5kHbaNdqDsHeJoaF5VeEEvqYfYEyYcq+Ud5y5HC5cGngapO
INtp02mXzWBPKjGuIyo3kY2H1SXRQbr3IbmxxblN4v2FwWApx4psaL33k0OEyCSc
gQEekkfKdkkLhnLiSUfk4L4rvfvW7ZI5O3KZIuO6h+NGrWyfJb4lkON6Puq4J/JB
/awJFaM1l7thCUVWltBOI8IpWsJGjiI3AOLyAM91DD0GiNQE5KiZVPm4qPAsoR/3
LCyF/0ydzfVTS21dJPbpBWPxKK1s39I04HRN11ncr9++dF5efh0CejLdp3AuNPAt
ykwaOnhE8tcE0Nh0WMNsNHMKbsj+5BN4XV5d6AmIzw6wwtSphXOC34XI4MUwFp//
4fHabkQXhQOlRnw+vUXGRDju4gmBrUyEOL8mDPlKl/jq+xmSDrk=3D
=3DR75l
-----END PGP SIGNATURE-----


--===============4280636238333136686==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCZnn58gAKCRCb9qggYcy5
IcaeAQDtvmajPaMoH+eElB3JM/nATMRB04O1F77/CWEwRVHhzwD/UUiO+a20rSMx
QCpDM91tXyWa35rs2vusyS/HbhYUXQc=
=zJpl
-----END PGP SIGNATURE-----

--===============4280636238333136686==--

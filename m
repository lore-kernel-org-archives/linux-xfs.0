Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762D474433
	for <linux-xfs@vger.kernel.org>; Tue,  7 May 2024 21:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715118037; cv=none; b=AJoCSThRZlp9r8jnq1STvObsagG9aj9b6FjFrX9OY5yOglmOPPnL3kg941VWSJiupkzGVZPCbmr240dWbooW/fe3qgnWluUhLFHS8WYWAKsBIN1LqDkgtzFWPLMl0uuD4+9UW21iZZdVznpbMJDFc9q2tu0VWtBj//ROFqxEAVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715118037; c=relaxed/simple;
	bh=G9IHzFxQg15yonoOxEH3yYpfKf0aRQd3mOY7/VW6bUc=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=cgZ/QRaKjQblo4BAwCja/92oGKWW9nyQgsc7u07EFCC+FxWpXLAZLFNDSncL+50BfEdyiGKru6nGIe6VSquqha/ooeNYRlzal8zuJTJvLHPT9zcuFA+tr5YTXRH4D//epB5iViK01XIzjvFO2KvPGcD85oVa5fMrQa5zyyRKtVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=sinJibRD; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="sinJibRD"
Received: from [192.91.235.231] (port=49774 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1s4SY5-00194r-Qt
	for linux-xfs@vger.kernel.org; Tue, 07 May 2024 21:40:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=bsBKRo7yeRwjgmFcdMdILV+97p4e1Ya7idXevyhtQ7U=; b=sinJibRDOYD/wEkv8S/jxqw+Gz
	5ldvfPKcKwbx2zR0D1oJ40T1cFnBt0LH+VRQHWQL1wS6mhWP+mWSB4ddPYlRSxL0IZzKbw+0c3IH4
	QV9OKiYbwZdIDsr/7G0krYaG97z2rcpl2Ze8ZOmCAIlHMKgAPAG39XAxXsSLs7W2TbNK9gjREtT+g
	K6YBHsWqlVlFaqw32aN4rCxOVxVrXvEikE5eXLrerI5p0o0y4uJlDd6bYTT2MkWCwFbU2Y0PmWWXa
	eiSkn5dmN0DInXPpc9Jh9lrHlOVGKa3TWrcuaOw0/pTllVIUZCyf70XfX0kXmXVdPqe+Wp/YWAD2k
	rJmhpcow==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1s4SY2-000IIS-8t; Tue, 07 May 2024 21:40:30 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: XFS Development Team <linux-xfs@vger.kernel.org>,
 Bastian Germann <bage@debian.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.7.0-2_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.7.0-2
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
Subject: xfsprogs_6.7.0-2_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============5444453429209423812=="
Message-Id: <E1s4SY2-000IIS-8t@fasolo.debian.org>
Date: Tue, 07 May 2024 21:40:30 +0000

--===============5444453429209423812==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Tue, 07 May 2024 20:53:14 +0000
Source: xfsprogs
Architecture: source
Version: 6.7.0-2
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bage@debian.org>
Changes:
 xfsprogs (6.7.0-2) unstable; urgency=3Dmedium
 .
   * d/rules: Fix target binary-arch
Checksums-Sha1:
 126752b8694a961b1ec15d484ee27dae8aac933d 2034 xfsprogs_6.7.0-2.dsc
 55397206015d67087cb6af48cbcfbfbac988ed93 13612 xfsprogs_6.7.0-2.debian.tar.xz
 5e23fecc23042b5d3708013098bd87ea43ecb140 6350 xfsprogs_6.7.0-2_source.buildi=
nfo
Checksums-Sha256:
 43db23a27e81b7cead29ad67e909e8b6a375c3ca804a65b4ef4a4a44d9e64377 2034 xfspro=
gs_6.7.0-2.dsc
 545e4dfc325c66081a8c82daf15de67297be23c60fc3dbed13505f357305d145 13612 xfspr=
ogs_6.7.0-2.debian.tar.xz
 1d18d76769d9c108cf3184815cc262fffe6cb297ec318a905577564695795ff4 6350 xfspro=
gs_6.7.0-2_source.buildinfo
Files:
 e72211ea126d7ca3809ebb0ddfae433e 2034 admin optional xfsprogs_6.7.0-2.dsc
 f75aa0729115af97bbef10ec9f850df3 13612 admin optional xfsprogs_6.7.0-2.debia=
n.tar.xz
 99bf5142b4253de1767fd44c8ce30056 6350 admin optional xfsprogs_6.7.0-2_source=
.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmY6lnMQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFKhDDACdBzrsr3UvOSlUQY7G4Y5gvA5ABb9x8pwf
7uOeZLZIiOzQiblsZMqy3Wcp7U1twDteUExPnNjj4Q0dRdZ0S9hU1MxIdkAj0UWx
BeDThVujRoQgBAmvdAYCvYFypJf/tHTy8RTafUWAsjyBM7vOf0A5ikcz5gepCxwC
jRmvWn3XvdP99qWKjc2GoetXtGI6vvYDGSD8OwZiIlNFDOy84d4CyVUwlP3+luJi
lF2C5Eo3CLdxEwVRq2+ZGx9+HqIXVqovRoO/6en5NkdiktdzerEqz6gvCWyk1qCy
uknkb8mCQ6JsEQkqwFaebxYLevgdlO9cYZRHuDsjhLqeokkfAt6GoNtmLzqVOHTB
hEdhhPKHOhsKLH3f/weJ/ztG1X3gS14x9EEXYjebweq2MDTryw0ZJnC54Jl9H84u
HUIDK52UQzG/GdDSELO2muKTDvYgh4kJ9S0HXumMOYVAJdvlZxpk6N6nTagGW9VD
NCjSvCqb7dwoOObfX2Idz1xC9IbX1kk=3D
=3DxJp0
-----END PGP SIGNATURE-----


--===============5444453429209423812==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCZjqfzgAKCRCb9qggYcy5
IcORAP9wFf/+V4bq9NpwyJOQVrUhEwqWEXHgqXpl+IGE7X5tZwEA6UTCbcN3edZs
PcvQAd/0irPvBPtaRd7IswuEK2DBgwE=
=Yt68
-----END PGP SIGNATURE-----

--===============5444453429209423812==--

Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97703DD51C
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 09:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783933713; cv=none; b=qlhoGv8/fQ55taAuHzJMtsqa/vVEL0mRpF8eQ5HQEhj1z3zD3oXzqslZfwnZYqziBholEgmngmZHxuIyV6f9Tf5njlB18q52b8TeH1ZMOTn8SU6sJ5CkX003/csxguqAI2BeBkFNhr6EJKxNLWm/e67Fh1o7gE+LzUXFA6aDDio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783933713; c=relaxed/simple;
	bh=6dMQWVfveL2qUsRNgtwUF08DuaZP58CpIUV4iQf0KEc=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=lWnRJ6TUnAU/9UFvSSlI5o4m6yLsM04v6cBNz/Vu8B71Ga6PgEeVK85fhB2lIoKGGfqzLeZP8fG6mYGv7HR9snH69O7tjjzUweBkDTMxGmRF4ULbYDcaax1lDbrrtQvLc3WNx4ODXR6nrYTaTjKS858AN7naxjSI1as15og2lfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ftp-master.debian.org; spf=pass smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=scTEtQxG; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="scTEtQxG"
Received: via submission
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1wjCeG-001jB0-1m
	for linux-xfs@vger.kernel.org;
	Mon, 13 Jul 2026 09:08:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=f3hh19AqqxbyPcsr8CyWm78vlGjejopM8H5+SZWP7ZQ=; b=scTEtQxGFlwieYC7+EbGOM+3Mt
	3wWW7sRG9oNCrNroLl1LHEePA7exRbyowvbYiErig3rHKccKi44gqvUroSlckIx05U0keP5fpxfIw
	RQnEk1D1F8tCoFDU8gCiG5N//XWtlfqvvGdUuhoVdG6PVm+l8+MFoiuopZOf2Tmzc6UXrgqHEyvwr
	tr6c/7re9lfgZwYcvbU7QjqrrRlyFajHKOy+WIZyl18OmzbcafuABDDTQ3qowxTeq0E5f6Ye2uFX+
	bdzS2h5m0EoAUm096plaKd6MjY6jJg4Lw782RhP55mbN/BkG0W6/QZiR64lUzPDNTq099+buxTkCX
	HlLIJTHA==;
Received: from dak by fasolo.debian.org with local (Exim 4.98.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1wjCeD-0000000FFyI-1v2d;
	Mon, 13 Jul 2026 09:08:21 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: Bastian Germann <bage@debian.org>,
 XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.13.0-2+deb13u1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.13.0-2+deb13u1
Debian-Architecture: source
Debian-Suite: proposed-updates->stable-new
Debian-Archive-Action: policy
Precedence: bulk
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: xfsprogs_6.13.0-2+deb13u1_source.changes ACCEPTED into
 proposed-updates->stable-new
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============3445168246815686324=="
Message-Id: <E1wjCeD-0000000FFyI-1v2d@fasolo.debian.org>
Date: Mon, 13 Jul 2026 09:08:21 +0000

--===============3445168246815686324==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.

Mapping trixie to stable.
Mapping stable to proposed-updates.

Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Wed, 04 Mar 2026 12:28:29 +0100
Source: xfsprogs
Architecture: source
Version: 6.13.0-2+deb13u1
Distribution: trixie
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bage@debian.org>
Closes: 1116595
Changes:
 xfsprogs (6.13.0-2+deb13u1) trixie; urgency=3Dmedium
 .
   * xfs_scrub_fail: reduce security lockdowns to avoid postfix problems
     (Closes: #1116595)
Checksums-Sha1:
 02f392d1756a3c7af524b6e9b09aaab34abbe99f 2080 xfsprogs_6.13.0-2+deb13u1.dsc
 31d4f7ab5d84c6322375b17b10970be649afa7a7 1506676 xfsprogs_6.13.0.orig.tar.xz
 be67f479c6e94db18f2127c800dcc3d7491a3d3a 16100 xfsprogs_6.13.0-2+deb13u1.deb=
ian.tar.xz
 9768ef24b97ccbfc2b1861867cbf2f1be14e6389 5863 xfsprogs_6.13.0-2+deb13u1_sour=
ce.buildinfo
Checksums-Sha256:
 f3137052af84bbaee33566ac47600c54db908c384b3f2d30c7d98673b9e8150f 2080 xfspro=
gs_6.13.0-2+deb13u1.dsc
 0459933f93d94c82bc2789e7bd63742273d9d74207cdae67dc3032038da08337 1506676 xfs=
progs_6.13.0.orig.tar.xz
 7d68f9d00e225c7a426559995268f4d6efcc925cf7b33cb61f1dca1bb9a02d75 16100 xfspr=
ogs_6.13.0-2+deb13u1.debian.tar.xz
 fb5fd8b0e93e07e19119b7fcbd2cbf32bc58381d0ad563414acb3d0df9dc8a19 5863 xfspro=
gs_6.13.0-2+deb13u1_source.buildinfo
Files:
 080b9023b61275658df5bc986689a1e1 2080 admin optional xfsprogs_6.13.0-2+deb13=
u1.dsc
 42b00213982d16c6df3fc17a0706b773 1506676 admin optional xfsprogs_6.13.0.orig=
.tar.xz
 c87f52c49a0322036392860d65278288 16100 admin optional xfsprogs_6.13.0-2+deb1=
3u1.debian.tar.xz
 2b3a1dfb6c04768857a4f3edceacb75f 5863 admin optional xfsprogs_6.13.0-2+deb13=
u1_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmpUo8IQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFJl9DAC+hF6iq2GWs8RWyKOduq2lcERy1/gnU7YE
Qd8wtYx9OL682vKIrcYty4CzBQzdm4I0PizvnhnepB15SHugDMpyzJRkYuhCidDt
v1fLZ/r7Hid3k6FmPOzRs5e7YT3y8eexrJHbcOtvAC/FfdraedpW7LMbteq/SDgd
xYoxfIgwslFOOkLBlVRZcxBSlYvY8AHeEDx+jnVs6FxHZUEr7Z7nQblbMhhu6vYc
JxavBGwvT9f3DR1LNPAF86uRYBh8G3M2atfwPJtIzSYKsJpWf+ia7hPkWzJ8mTmq
SbOln3K4dKqHMa/p5ReqSW4HApj6IXvcjs7GM6gGLbHKTnu3610YOMIx9o2O17Gk
NAfUsA0+EPLuTfY9FC7s2EuQQcRcXQoCJswzVlatyVEl6FjmqzrbiPrcTaytHSxd
09hZWLqxY0+PDlDfY5cjPTjUw/HtPK3CO5DjeMQrOPoI3d7hDE0XOCDdik0CF1W5
7EYYi5toLulIIo97nOvwwAUcKnqMyqE=3D
=3D+M9s
-----END PGP SIGNATURE-----


--===============3445168246815686324==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCalSrBQAKCRCb9qggYcy5
IUyeAQCfpFrIN005MFHShPG33I6KzV69QiFaptf8iL7wOJJePgEAnOzpf9nLft4S
6IilBSw4WuP3HgHVnJkLIQ7oa/CR4QQ=
=1PVC
-----END PGP SIGNATURE-----

--===============3445168246815686324==--

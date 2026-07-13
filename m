Received: from muffat.debian.org (muffat.debian.org [209.87.16.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BF1437451
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 14:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783953132; cv=none; b=XyYf983IUs1VjWKgmGzaOSEox/ZhQ5OY6ZEmFuOruYNsUgOAjL5xHCe5l1vbzOtv+L/CIvpz9H4FQWCH+DyLqcd7A5s8m1QSpNH3OLFReeLY8XXgmaci0GKFJ1DtfGgGsxbXj/uEvmrNHsOPZpfUytZ5Lc1w90iuVmiu5ruFmbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783953132; c=relaxed/simple;
	bh=vRy/wL3qLEUpzbBFz+cuWzJyeszNUbbCgOAgjPEuOzM=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=BwqRH7K/GwLCpnmirx7S8NEGEj7TsQ1gGM35kUvXGmVZjNqDT+SwcMAVsVfWG00fG9LkJ8aseIw1/TCyyfUKb8msH8I/1oE080s4920EzzePPgiVGWr/pQyrtSF4XyiUAV6q3FPwyjVrV2VvD1kEItPh4MhCVtgCQlZdCrz6Ejs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ftp-master.debian.org; spf=pass smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=bQITMwFh; arc=none smtp.client-ip=209.87.16.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="bQITMwFh"
Received: via submission
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1wjHha-0027pc-2y
	for linux-xfs@vger.kernel.org;
	Mon, 13 Jul 2026 14:32:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=bz5AWrY8gj8zWhVkRIRxO8E1J0hpoiqT0c5tOKF/amA=; b=bQITMwFhD+XQzGGivxAFKuJHVv
	oJD1YZPedQBlKPtprukI1I+7swKIj321c2bjNdwZgoZ4xv9Q+hrMYNp5hCsKv/zZPtL1vVrVQfEgh
	uIzcGpLBNX1OSh7qhwRpNN9zAOv5iFN6COT6T8ZXYCiqEqOkhQvj0o5/10Y3Otb/TXUbIQtZy7pIQ
	90Oz5YFA3sgtQf6M3GnBWw0BmgFzKuJu6xFw1Sfu6/weot1p3stynJXMEkE5zkdn/s1GZ3boqyztd
	uucTPHVZhuZtIG7WlOQZgAVLHEtLrQdyMtAx49GOJNeHMJl4CRh6+UwSa4suAOI0Se9bGchQlip3A
	GhcKww2w==;
Received: from dak by fasolo.debian.org with local (Exim 4.98.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1wjHhW-0000000GKSx-285G;
	Mon, 13 Jul 2026 14:32:06 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: Bastian Germann <bage@debian.org>,
 XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK: dak process-policy
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.13.0-2+deb13u1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.13.0-2+deb13u1
Debian-Architecture: source
Debian-Suite: proposed-updates
Debian-Archive-Action: accept
Precedence: bulk
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject:
 xfsprogs_6.13.0-2+deb13u1_source.changes ACCEPTED into proposed-updates
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============0986466235824958526=="
Message-Id: <E1wjHhW-0000000GKSx-285G@fasolo.debian.org>
Date: Mon, 13 Jul 2026 14:32:06 +0000

--===============0986466235824958526==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



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


--===============0986466235824958526==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCalT25gAKCRCb9qggYcy5
Ie7vAQCLWLsOt0YgcsJFX8cNEHjc7qmTZZ4Lw/0Iw0blaC2VNwEA/RuzGdU90CGC
8ou+KU6zGiH2qXEmEDi0HieSAFoJWAI=
=VgM2
-----END PGP SIGNATURE-----

--===============0986466235824958526==--

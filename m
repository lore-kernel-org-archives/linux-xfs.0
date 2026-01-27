Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A0130B53B
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 11:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769511944; cv=none; b=dYRqpEheiGrqpanxrSf58Jmz4S5bQZZ/WuIV9FjvlCGY1zpUGJHpy7lH+hVwsXIQF0RLHmc4wzYfVwQa95JxjQej76X8bKbtXLvoZIXkPFd7r3I9Lh02mKTfNYQji6RUlP4sO3+TkZccgulFt/YSFtH9O/s/Yt5bK6RxyYiHmTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769511944; c=relaxed/simple;
	bh=pXMPQ4J5IbjqROIxYN99tRR+JCCsiEQJpZ/lPrubEWQ=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=lqvvRqXoSaEqlshGfvorziazT3bk/73YqzrCdNuIjwx3Gll+4riUJxuhW4f33lJwH0XcwRKSKOeiLJsnHgBLWNqZIPh/lctg34jYNnDaDokVQ3/+5qHvuzRxNFtTKdYtrhGhq97ME/P6JNbTMW5MZCoVQFqQISijEeqZaalyuoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=j4FCpsOW; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="j4FCpsOW"
Received: from [192.91.235.231] (port=50548 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1vkgt5-002gnU-0z
	for linux-xfs@vger.kernel.org;
	Tue, 27 Jan 2026 11:05:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=RlDUAF6ej1KNaBrmv+x6ZuA/HTTug+DVYOHhr99OwMs=; b=j4FCpsOWuhWNECwFc2NBxk1/zT
	vNy7yg4oGiKQ2NwcaxjheNmclEFPcvLzFsWDUsBaRALi+nCM0hOCwrHGmTrlTMMWLyaNYmkvX700t
	dQtSXf8e3Ow4TpJ5/oF8Yy2VT/987De+dWg5R9Br+q77wllkSjJb/0g/NPgddQ0gPiDdRqhFv+4EI
	6TyWoz4q3uvE5BVA7Xjf591OJ5ynbLdT7cUPXQQ4LDkIQLh6pmiroJ6floFdpJI9rHQc7YTiCZhwe
	aMQ8YUwNNtruOihLzc9UtwuETIy3P6xqso0fOtuSzpkBieBU11P/pzz0fNRpaspJVGX1Hdusr832P
	ZxLkIGAg==;
Received: from dak by fasolo.debian.org with local (Exim 4.98.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1vkgt1-0000000GLBt-22s7;
	Tue, 27 Jan 2026 11:05:31 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: Bastian Germann <bage@debian.org>,
 XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.18.0-2_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.18.0-2
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
Subject: xfsprogs_6.18.0-2_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============4110463095977542298=="
Message-Id: <E1vkgt1-0000000GLBt-22s7@fasolo.debian.org>
Date: Tue, 27 Jan 2026 11:05:31 +0000

--===============4110463095977542298==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Tue, 27 Jan 2026 11:47:02 +0100
Source: xfsprogs
Architecture: source
Version: 6.18.0-2
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bage@debian.org>
Changes:
 xfsprogs (6.18.0-2) unstable; urgency=3Dmedium
 .
   * Disable parent pointers by default as in versions < 6.18
Checksums-Sha1:
 f854986842491ae4eee44e8f00ff215c0a5a4d52 2048 xfsprogs_6.18.0-2.dsc
 db5b4b033b26f22213b7637611b6d4cdf16bb57a 12432 xfsprogs_6.18.0-2.debian.tar.=
xz
 e184cc2045ec0f178ab0ae8d7fe1d022966c458b 5875 xfsprogs_6.18.0-2_source.build=
info
Checksums-Sha256:
 d6249a8a6cba7f725743f8d74f161fe19b6c930011d13135fd30210bd82b31a8 2048 xfspro=
gs_6.18.0-2.dsc
 b8dff55af2e9e4641b55ea2baf402aae0d8f9362c660fabd85c54e659da3cec8 12432 xfspr=
ogs_6.18.0-2.debian.tar.xz
 34d072326416cbfa3b7201dc85a369efd0e468316d0afb8d05d8954c131e1484 5875 xfspro=
gs_6.18.0-2_source.buildinfo
Files:
 dd46fd8f9903b1aab2d77a2fc6701e02 2048 admin optional xfsprogs_6.18.0-2.dsc
 98cd31f4bb1d0d5c6665e7731ec142a5 12432 admin optional xfsprogs_6.18.0-2.debi=
an.tar.xz
 8c81d4d54f58cd760a5f2794e00aed76 5875 admin optional xfsprogs_6.18.0-2_sourc=
e.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAml4l+cQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFJDeDADPCHy59uTNpD5YHF67PHexGfQjMk/fnG7F
81JKP2ZAYeIhDGoLA+KW8PV2iy5MrTcY1ewBaUyWFQ0LGq0GLkV2NVMqX8n4acgq
UYwZVL7gpIJ9cCeC4hqG8K9UV731e0I36tuPrc0V4ELIwJpS2Z1mrdljHMEdfGWv
tzmHJCJVx7EGngyoGglZa9m03L6gXf58yZOioNZwRRHJSPQP/pXEKMEtwMEky20s
JGM5Rdvti5EeyLKWyJtQSLKIW9dg8tgBjz3rRSb+1Y6Y6lTqsedqDHD17JD1t0oh
fphb2clY17ZhuXkYLkPbyuiDzeRk4z0XFKp2xtFlj8goGAhuYW2n6roQKVNJliiy
qa4br6vkfvVGVkwsxsMaAWp1Qjp9KGnhrOgVhg3IX3q0CDr3JGRRamU0OuIorBt9
ZEB7Tnaka3sck7wtXyVx6FLiFDLma6B/0VafCClXAnhHCRrMDmuMpI8VIMNnGNPt
BeO5Z1gZUKU7jpxrnCElIETVbl1BqQA=3D
=3D6Nf6
-----END PGP SIGNATURE-----


--===============4110463095977542298==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCaXib+wAKCRCb9qggYcy5
IXB9APwOVwPjUKNlygqWHQM2M2Ijf1LIZJGbimlFYwjqTqi4pQD/aTErtVvJMuN8
yMfnGmbZN16BEDUCFnavSRQmubzC4ws=
=C8hi
-----END PGP SIGNATURE-----

--===============4110463095977542298==--

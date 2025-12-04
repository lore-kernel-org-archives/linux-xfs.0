Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24B229C321
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 16:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764865274; cv=none; b=V5o2VCQilXijVOxJpC1IPwuJCdRzOkilS6y+W9cyjLpPbyX6HUmIFVqMr4Oj97VLjYgwIZShEx+eidnVoYbiyifZ2s0Z5swy+qNbYlNK9oK/ueYjxSKymJL4nnhxul0PaPsWsA8dDmbrYMKrPL3iKkFqL8XRiCzGtKwM+SnQikQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764865274; c=relaxed/simple;
	bh=N/Xl15LgvkHCionbnFC9jhv6k/KFY0EYbTw/0LapN7k=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=F+/npXsrleghQjRZvdkPD3EjoLAH/0GlCULIr6smLjq/6u6tKIRpSbKwnNHRbZFMp2JF/GVPzhGjniuaOQT5kJHNvlSkE1fnSGm3n9NQEkEavkzaqvxIINHDYuyH+3JL6lAeFSyvBkjGNIliI+cAfyeFtT1KY4GsCErGoK5jfMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=saTzCrpa; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="saTzCrpa"
Received: from [192.91.235.231] (port=45290 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1vRC4t-004uFl-0r
	for linux-xfs@vger.kernel.org;
	Thu, 04 Dec 2025 16:21:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=htLPLjV8cvUM+D+gn6VPypO2+joRrIoPXnrx8aORTFQ=; b=saTzCrpauCE3oid3FcSU/kusPt
	Run3wEGJg74wX2+uh9oTTxejs11QKcZsOo1/2KkRmPU7DLkvckTJ+jrA8D0iF2a92ng3YOhdeeqEp
	L4pCfN4FZvVK2lGwtRP137LtU/bEJ/K8eezyaQ5KIFICU92DXyEHqCf9IOh0kzKsZgP5KmmTcZ/su
	kwjVi/0I6qW69K/GtF9mmEpoqaATLEOjRiQdd32RMw/iGLF2rinX3bzp6eJRfrDw7/aU89YSh7+t8
	TbNW6rDoyXhsGKtsSk3P7OJJwVDTvUpBrPDTJcuHKDcenaDomQ/cKRNlj0tim/+z1E69t+uFu+x+I
	B3Jd4Aag==;
Received: from dak by fasolo.debian.org with local (Exim 4.96)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1vRC4p-00DVQP-03;
	Thu, 04 Dec 2025 16:21:07 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: Bastian Germann <bage@debian.org>,
 XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.17.0-2_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.17.0-2
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
Subject: xfsprogs_6.17.0-2_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============8700196210919139498=="
Message-Id: <E1vRC4p-00DVQP-03@fasolo.debian.org>
Date: Thu, 04 Dec 2025 16:21:07 +0000

--===============8700196210919139498==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Thu, 04 Dec 2025 16:30:59 +0100
Source: xfsprogs
Architecture: source
Version: 6.17.0-2
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bage@debian.org>
Changes:
 xfsprogs (6.17.0-2) unstable; urgency=3Dmedium
 .
   * Fix broken quota that is caused by a bad ioctl
Checksums-Sha1:
 22e785c15862f77521eb8c20c6fd7b75b75b5e5e 2048 xfsprogs_6.17.0-2.dsc
 d8e04a34f8fe78e0fb23dace40f3ab979a7b947d 12724 xfsprogs_6.17.0-2.debian.tar.=
xz
 45b90ac9197654522032fca5b0b8ad5ca58e3710 5808 xfsprogs_6.17.0-2_source.build=
info
Checksums-Sha256:
 8660d85384146cad8db56fcb1093e11c9351a004eb14ed2b0d94d4142f5013f0 2048 xfspro=
gs_6.17.0-2.dsc
 e0f8735a43bc24ad45d36957aca0ca4ec8c404f1862309ff31a34c1b12316d11 12724 xfspr=
ogs_6.17.0-2.debian.tar.xz
 b0705f8f9c04f4c26eef64472ff0241ff02c2d27e8b7fef6217fafde7bb2be16 5808 xfspro=
gs_6.17.0-2_source.buildinfo
Files:
 350ffba0cd4e039c98b88bf939b96231 2048 admin optional xfsprogs_6.17.0-2.dsc
 c1850d8c88919b70d93fbf8f45028747 12724 admin optional xfsprogs_6.17.0-2.debi=
an.tar.xz
 610f8b7aac6f7fa82a937f21a27fc875 5808 admin optional xfsprogs_6.17.0-2_sourc=
e.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmkxshUQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFBzSC/9ECYo4AHmDlUrY1gTnaM0eX7XSGhrUZqcB
eZvmRrf42MsxVcqAJlAUM5e8kTT6xQJCxrmh6fiQZKHwHZ9aPXVyM29StqLnG54K
/58Pf0IsGRoJ7CKD0xVcEsCBPQtfFB73lTTEVTT/5gJ8hg6QA1CWEjHZj4aGnULb
ZMTz1AoAafdqXtNZwwr3laAbgSuDZ3/UTqk7Gvazyxev5uUtXwsQpEUaINvoGe5V
JR0bGueuwvhK7M2toAc+psM8cnFu5HwS7eZi1sT/P7s7soD794zgGZB5CdQnspW2
DLOMwYJyvAfErAhOzPacPjm41icr2+dyFwBr34BM/XtpY/tGIllurM8AV4EGszK6
lWbAiVSMAa2LtV5OCqI/KoKxCVey6ojcON+CU6fCsHvVdIbbt1HXUtOjzWC3vDH6
udI1ITcKiEdeKPohbbD9UuMiuS2RHiPgEuzxvxM1gp3p5nxEXJWZNGoFBaA2mBZH
iRQzMVq0YOYEj4aco0JVwbiOoi4JJvE=3D
=3Drr9/
-----END PGP SIGNATURE-----


--===============8700196210919139498==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCaTG08gAKCRCb9qggYcy5
IV1NAQD+Yj2g4M3iCnYDTizjuI9QWc8TgPCy5NxJj/789pNlnAEAlh1t1RimExx5
RzDO+BF/auO2lQa/aZzM8rrL3PP3eAQ=
=GP2o
-----END PGP SIGNATURE-----

--===============8700196210919139498==--

Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE3E154C19
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 08:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730363214; cv=none; b=BeVX62vaWLJ1AcxLw2IOWSICqsfiBMuMbhFVA7vLW4KEn2nRrYM3kw8EnMf750K30zNjJA+9Hfnq42FvDgS0cyKCUCt8MGfjfjO9v3AS2A48Qx70BIiCmHAAvtn7Tbda0r0krz7YdHY61vREQ2DTKmZhxO0DKdTQstJmdrRYqCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730363214; c=relaxed/simple;
	bh=s8iQsWI4FsdRYNKbYmNqZtYsenR+kALpHduG5Pf9xVU=;
	h=From:To:MIME-Version:Subject:Content-Type:Message-Id:Date; b=DTd8e+rviLyxD9xVgjD8b5HkxxmmPz84n+bqW3XhwmiLgSa9NyNZxlIqilN7stPFIdeBhnSgCqEvzshyOpGA9So9HQRGZBMsQf+6iMjJYy6L2isCiufOP1PuhGiRkFko91SZGZDdYWNJM8JbTFhdk75CCfFgE9cCSp96NGIujQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=A4L6anyR; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="A4L6anyR"
Received: from [192.91.235.231] (port=33928 helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1t6QVx-00C5bV-Aq
	for linux-xfs@vger.kernel.org; Thu, 31 Oct 2024 08:26:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Content-Type:
	Subject:MIME-Version:To:From:Reply-To:Cc:Content-Transfer-Encoding:Content-ID
	:Content-Description:In-Reply-To:References;
	bh=SAzP2crfmAplp0hk3CnQaW2zFdNzES7LF3QnmFG1Wnk=; b=A4L6anyRQ+xvfFFndqlFU3q759
	XVMxIptDKyxPkKMU+K5Zp11NQXaPetSH4ie8bR5zefEQa2iH/cJ6IMZ+unmvfdp8mOd4qWfx7E89A
	eujZ+k+mrVhVtCa3Gnp3FgythFYrs66BFi932V4fJIps/elbGVy4ibodFFheMOqWPiWezAgN5dfEz
	UGqRK2nXiABRe4XQs7/Q4kAGVQgOSwmRM9/fzHMluwjjdk86mgS7/sOcQgo/8/jGijuXkbnIoYIUl
	CUd8WzIrpv9nxSuwXDb3nH8cvo1qAMGr9S11SlavocrwiBaSD7yI9S9eiZduxMdjzABRt8QGpdyGz
	uWpXWYgg==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1t6QVs-00DPij-4i; Thu, 31 Oct 2024 08:26:40 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To: Nathan Scott <nathans@debian.org>,  <bage@debian.org>,
 XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.11.0-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.11.0-1
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
Subject: xfsprogs_6.11.0-1_source.changes ACCEPTED into unstable
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature";
 boundary="===============6470262756498299867=="
Message-Id: <E1t6QVs-00DPij-4i@fasolo.debian.org>
Date: Thu, 31 Oct 2024 08:26:40 +0000

--===============6470262756498299867==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Thu, 19 Oct 2024 14:00:00 +0100
Source: xfsprogs
Architecture: source
Version: 6.11.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (6.11.0-1) unstable; urgency=3Dlow
 .
   * New upstream release
Checksums-Sha1:
 f2ddb65569c31a27d99bc32bbfe9b482b60bb19a 2048 xfsprogs_6.11.0-1.dsc
 13f1c9ec9d5da9cf453395100c303271094f2638 1457084 xfsprogs_6.11.0.orig.tar.xz
 aad1ef159263f6ecfbf1d1c140835e833f1749f5 13168 xfsprogs_6.11.0-1.debian.tar.=
xz
 e0f668258ff34129a83acff0e70f4ec48847c8d5 6339 xfsprogs_6.11.0-1_source.build=
info
Checksums-Sha256:
 a2c1d740c1bf2bc85a835eaafb35d079e4e7584f78804185e6d05fe9fc08f66f 2048 xfspro=
gs_6.11.0-1.dsc
 dae3bb432196f7b183b2e6bd5dc44bf33edbd7d0e85bd37d25c235df81b8100a 1457084 xfs=
progs_6.11.0.orig.tar.xz
 6a5693da476f0db2488b44b22384be0fa979daab210fb24a593ad3983f16194d 13168 xfspr=
ogs_6.11.0-1.debian.tar.xz
 1004ff67b589f5e2446d8ee462e43ec4d9ac24a7afa72b0b0a71f76c4138a1c4 6339 xfspro=
gs_6.11.0-1_source.buildinfo
Files:
 752d7dd3da1596167693eb86890046c4 2048 admin optional xfsprogs_6.11.0-1.dsc
 01ac717e8ecffbbb313a20242da9c98d 1457084 admin optional xfsprogs_6.11.0.orig=
.tar.xz
 cc8cd5f831cfb73b46f22f1736c14baa 13168 admin optional xfsprogs_6.11.0-1.debi=
an.tar.xz
 05835b16edef1163dd486a5c9d870539 6339 admin optional xfsprogs_6.11.0-1_sourc=
e.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmciyx8QHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFOeADACPRjpKTYJqKlBmqdYnIR0HiBOE1CGaTsQp
Ne+EVM2P0AXAQiK1Nulk49BUwW+QhlpfRF7lE2kljdjIIOxQayRUyHIRd3Je9tpF
bTxHzjIYvU2zcSV9Qn4G98EmhkyK5OjDjevbajkBSO33spRXyZmy63xgdgiioNQr
57MtJMNo52oboJB2LWyj+qlSS7EID8ATZIABoI/6URZd4AjGoXCmGE9TQR8YTNeu
uJUnEXFckepSg2ljWmy43/iUELXbmtBAkCoLKa8P2mozpCYoPG/C6t5KKcNFf3sK
ABbH1Wak+HimaM9Fw/oYdrnziej/ztKiMcgWqSCj23n/qAYPGzuCXfM6HeoWn56i
QgrXYvI/XxHSwclaCkbx9bxieRfKtptIP5Sp5SO4N4JTIhPofqVJcF7aIilLek/l
ab5K2W9sV74PpopOYhPGsHTkf2AeZr5phDot3U3jSbqP+UoBxIlh0F9vvW2Cc0VF
4wrdhKf0l+6cPV14amcfOLuViD6k/ww=3D
=3DGTBZ
-----END PGP SIGNATURE-----


--===============6470262756498299867==
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTziqJOuF8J+ZI8pJSb9qggYcy5IQUCZyM/QAAKCRCb9qggYcy5
IXOUAQDV52MOOxknKs30d2SXONmjYk6ZdkSDZW7wfwQhojPGxgEA3fwMm/f7eTCw
uPo/w8rpBoI+qPB8ojYk0MbnTULw2Qk=
=wAON
-----END PGP SIGNATURE-----

--===============6470262756498299867==--

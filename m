Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD8C0C25B0E
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Aug 2022 11:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbiHPLEi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 07:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235220AbiHPLEK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 07:04:10 -0400
Received: from mailly.debian.org (mailly.debian.org [IPv6:2001:41b8:202:deb:6564:a62:52c3:4b72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512293334D
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 03:11:58 -0700 (PDT)
Received: from [192.91.235.231] (port=55036 helo=fasolo.debian.org)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1oNtYC-009rBr-Oc
        for linux-xfs@vger.kernel.org; Tue, 16 Aug 2022 10:11:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:To:From:Reply-To:Cc:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=r+ZhG/M7DZcreU6QQc7e9yD2ZVdMm1VtgnIdcDPkDzM=; b=G2cQGPOlg2nzwW0aT+epo7EEmH
        q6iYMPNrQqBy7SIhsoBvCcKw6C7gbzaWcVrTZFda4maqGutU1Hnwfa9T/om2WwyfoaWkZj70sSrTu
        M26nvFYsp6RSVRsgGng6oEopQtMc5kvdZOD4jeABEC0f5mFkC5fAqoEKlI6R9Lu6ybdH+NV49Eb5d
        dDCc/Tzr80Vpv4EHluhXZpJuaGtNvD/HRGsNC7KFnTQ0Mtf6K3DBvfanFOXh5s0nxdlZ1a8jZyciL
        iuNvqkwl+fxtmbOWmHbJ4mj4AkSJ5G42OUuQziwawjyaiCSsWyWonPMq20Vq0wcvu418oSBjEMYFk
        IPYrsHlA==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1oNtYA-003K1B-7J; Tue, 16 Aug 2022 10:11:54 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     XFS Development Team <linux-xfs@vger.kernel.org>,
        <bage@debian.org>, Nathan Scott <nathans@debian.org>
X-DAK:  dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Auto-Submitted: auto-generated
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: xfsprogs_5.19.0-1_source.changes ACCEPTED into unstable
Message-Id: <E1oNtYA-003K1B-7J@fasolo.debian.org>
Date:   Tue, 16 Aug 2022 10:11:54 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Fri, 12 Aug 2022 13:40:25 -0500
Source: xfsprogs
Architecture: source
Version: 5.19.0-1
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (5.19.0-1) unstable; urgency=medium
 .
   * New upstream release
Checksums-Sha1:
 2d23b468701fe1978c6e173ac01df35b3a6705e0 2041 xfsprogs_5.19.0-1.dsc
 12afbdd497603b98945ea18f9aa5a78c671a6e4c 1325160 xfsprogs_5.19.0.orig.tar.xz
 4dd3f9a23d29dc6b40296029c25e30051a48f4b7 14376 xfsprogs_5.19.0-1.debian.tar.xz
 192461f42a870863bd202e18ca3abf1b5fc68976 6445 xfsprogs_5.19.0-1_source.buildinfo
Checksums-Sha256:
 95b49c7ea794ddd25b627bb4ab43d7f138f46e1247207509edf9f9d474873b31 2041 xfsprogs_5.19.0-1.dsc
 4b6c6c98c036a37f6d90c82cb7fe9405d3b5856d9345662032d01ff4b140592c 1325160 xfsprogs_5.19.0.orig.tar.xz
 b8374b4f0807fe30d8c2bc3c29511331380c7dc5c2d7757cf34116feaa1724cd 14376 xfsprogs_5.19.0-1.debian.tar.xz
 c99c4460f564ba056bec2a002a8ab3aafcd37a60e4e6d0027daf2478e6175374 6445 xfsprogs_5.19.0-1_source.buildinfo
Files:
 d3ec9e1d9e07fd15d94bf2f9411ca572 2041 admin optional xfsprogs_5.19.0-1.dsc
 a55ac9550225b863c263852a4dcfd2fb 1325160 admin optional xfsprogs_5.19.0.orig.tar.xz
 9d52ba10f7ce6427cecc98409a951fad 14376 admin optional xfsprogs_5.19.0-1.debian.tar.xz
 428f6b43771c5360bb84da12e6a05c41 6445 admin optional xfsprogs_5.19.0-1_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmL7aYMQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFHVzC/40DQnG4auQP9jS4ksD+GttMWaNulDTdtX7
2hHeQFbqZubyBbAY86Xh3Fu6FFb+GRKoxsqEOjZ155sCRClx1ALNM2hv+PKFbbGa
Wd1hSFsclj19+071kdEuPqq4uJtQdAFVTNMxHjpEZvIp7jJUf8q4YpPv7FhHVzJI
2sHvLU8YLeyVURJsDaV1ASJnK77Xf5+5BSHGU98XQc44K5vTSGUVjQ+cn4WpmIaI
0OTRrSEYymGlS+H/+kvHFKdocEKy5noEkedpBmV0eNZ+9cFvocUs05i5eP9NfosV
BTYUSj7HLWcC5ZEmWKa0OKQ5vKbjrFhrxRqFy6J/JkBFBpbTM6SMID8QGxA+Fxla
BfTAKLLm/SABt+5y0hV6G6BOM0A9Wed3QpHATWJqBzgwEk419K8u1OQl0H1ch18n
W2XxJID2kuyA8uMHKvEMcsgMVF75E80mG//YHc6wkXsPGVtnrNZvMxKW0tAJaUUN
klQc8J85BmYoPRIqajh3efEyuZgd/OY=
=assI
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.

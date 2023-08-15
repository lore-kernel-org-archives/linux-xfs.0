Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8650C04FDF
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Aug 2023 20:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239378AbjHOUrE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Aug 2023 16:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239861AbjHOUqz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2023 16:46:55 -0400
Received: from mailly.debian.org (mailly.debian.org [IPv6:2001:41b8:202:deb:6564:a62:52c3:4b72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147EF2684
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2023 13:46:33 -0700 (PDT)
Received: from [192.91.235.231] (port=42464 helo=fasolo.debian.org)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1qW0vs-004hYd-Sw
        for linux-xfs@vger.kernel.org; Tue, 15 Aug 2023 20:46:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:
        Content-Transfer-Encoding:Content-Type:Subject:MIME-Version:To:From:Reply-To:
        Cc:Content-ID:Content-Description:In-Reply-To:References;
        bh=vQHSrHsqIlxHHkbSD+WzDvUxfQMp0Pab5MUgegECWoQ=; b=T6cAbduVeIB5FKg4qQM8ydygyC
        kZkxXyHAyvOBBMZgqIii3gb+1/U9NMb0FRceEexfggSI8nBJpuFEg/2gR6OipWFoT7yolo/CMCwa+
        im//giUW5gR64/MsYwu9py9oLyDKq6P8/SR/lvr6J2uDiiwI/RAFTHXQzCuh4e2EUrqjYyYVfBaUx
        6rj/kDSWnGw3QGYHxi1scidhcTLIjTKptUa9c0xyJG8dQMMIKVxkMbNU/e7axn1RXdD0i5Z8/Whku
        8Hk4WRr7BQBzbINuzkJmT/k8wwnR3wAUUrnhTt0dlvvA/bLdTiARijovxEa0zVz6gb0XNVryUTqhn
        NgxrZctg==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1qW0vp-00BQg3-8D; Tue, 15 Aug 2023 20:46:25 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     XFS Development Team <linux-xfs@vger.kernel.org>,
        <bage@debian.org>, Nathan Scott <nathans@debian.org>
X-DAK:  dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.4.0-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.4.0-1
Debian-Architecture: source
Debian-Suite: unstable
Debian-Archive-Action: accept
Auto-Submitted: auto-generated
MIME-Version: 1.0
Subject: xfsprogs_6.4.0-1_source.changes ACCEPTED into unstable
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <E1qW0vp-00BQg3-8D@fasolo.debian.org>
Date:   Tue, 15 Aug 2023 20:46:25 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Wed, 19 Jul 2023 14:00:00 -0400
Source: xfsprogs
Architecture: source
Version: 6.4.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (6.4.0-1) unstable; urgency=3Dlow
 .
   * New upstream release
Checksums-Sha1:
 3a7dede9d6d72f9c86ce8a632b3679a7a156a8b2 2034 xfsprogs_6.4.0-1.dsc
 04935475fff6580d7e1919bf9a19331951edf529 1344720 xfsprogs_6.4.0.orig.tar.xz
 f5fb5f9916e81e307378fba53a9ff041f18e2705 12568 xfsprogs_6.4.0-1.debian.tar.xz
 7998466649a6450fce4a9fd9593c2386166b27cb 6360 xfsprogs_6.4.0-1_source.buildi=
nfo
Checksums-Sha256:
 24cf19ae328cc66991386244cce0661509373404080a8d05cd2c1dbe8192e161 2034 xfspro=
gs_6.4.0-1.dsc
 c31868418bfbf49a3a9c47fc70cdffde9d96f4ff0051bd04a0881e6654648104 1344720 xfs=
progs_6.4.0.orig.tar.xz
 51dc757830b64aae55774fa844d9c45fa5df790aba5d57b17ee465ee327b4b41 12568 xfspr=
ogs_6.4.0-1.debian.tar.xz
 16466eb5ad1ab6edeab3e5d9c20ea746e9e33ea85f624593493935cc20eedc54 6360 xfspro=
gs_6.4.0-1_source.buildinfo
Files:
 5ebe38a12f3b23a82715119575ed1f41 2034 admin optional xfsprogs_6.4.0-1.dsc
 81c09e5ea47412c3a109a316cf4dd39d 1344720 admin optional xfsprogs_6.4.0.orig.=
tar.xz
 56cbf5b63aaa0e8435edcad1a0299c18 12568 admin optional xfsprogs_6.4.0-1.debia=
n.tar.xz
 b06e2bd0abd1a64137840a18a4a5a3c4 6360 admin optional xfsprogs_6.4.0-1_source=
.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmTb3QwQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFCfbDACbxLp6xasc8eaBKhxjohoGr/W5wmiqcaG1
A6+rpqtSoFMJJRQFdks4N3H7imBi6LGzc2PLGGgdm/4ff1cKt0DIEuM4Iuiv6ORK
64eg8e5fQ1kVjSRS83Mny8SZykKBOnjLrhssrU8fn36Tyba5wmvASRXHUVHYpBoN
rTI88cD2D0WQaEG0iDkWGGXmCtCs5JxYI08zWAC1Bemr8P+9oiWbVNnMAaxjeSFp
AANEusO2Y+nCXFh8Hf7t4q6xfi+qT3QsIRXOY7kSEqqtmynFXAA+yvWJjKNFU4Gw
cI/j77i9ccW+aGxKfVF3gbrTVfxzepXZmiuzQycas/x4A71lj/bDgdyP+v85po0H
yRty5mgRds0V0lGXTsyc0Vr7bmaHiipg3EHfbUalm0SnqstiNg5A+D7jcVNpP2XG
u0j55uxFYR4VLdSVgfSKzijB6/yD7TW2JoGTAs4HMLGyECKknYX3N/WAhcOump64
RcLWBwfnC3q41LKY1FQlGzpdChXBWPQ=3D
=3Du8+g
-----END PGP SIGNATURE-----


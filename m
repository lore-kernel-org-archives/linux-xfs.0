Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D09C25B45
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Oct 2023 20:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjJWUtt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Oct 2023 16:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjJWUtt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2023 16:49:49 -0400
Received: from muffat.debian.org (muffat.debian.org [IPv6:2607:f8f0:614:1::1274:33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B410FBC
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2023 13:49:47 -0700 (PDT)
Received: from [192.91.235.231] (port=43220 helo=fasolo.debian.org)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1qv1rt-00HRhn-7F
        for linux-xfs@vger.kernel.org; Mon, 23 Oct 2023 20:49:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:
        Content-Transfer-Encoding:Content-Type:Subject:MIME-Version:To:From:Reply-To:
        Cc:Content-ID:Content-Description:In-Reply-To:References;
        bh=CHwU+yWeF1MzFXN2P+/PxPUXUb6xRO60BhRftfd27Oc=; b=HquNUqg625bf1r+DXy4UVt1VVd
        fKW/98v//9XA7aJt7/k70BBHWMp7iynDKcbVlnn2BCJAEMeHBynQytGuxGsOezrWeZm+TFFfrugo9
        tg0huPNfndAiOnk7oqC4HRnsn7IrhoT4Tu7d3gIcL0a99AIedPLSBhWT/IYzd18hGXaqjOCOAvFeL
        lEiUrKqDsnu8k/u6/n2Ka+LFa++d/o5Vnkg6NMX3FQ6/mivsr72f+j0dwc6h7/ckdL2S/3uFCA5fp
        xJe6A5GNaG19FOdt2iLKYPkoN4B3IroDCv94dSX4nYjxHqlGXdacjaiCRsWclx+1R8NxElEUHAadN
        OPN7qTlA==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1qv1rq-00CHQp-CF; Mon, 23 Oct 2023 20:49:42 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     XFS Development Team <linux-xfs@vger.kernel.org>,
        Nathan Scott <nathans@debian.org>, <bage@debian.org>
X-DAK:  dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.5.0-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.5.0-1
Debian-Architecture: source
Debian-Suite: unstable
Debian-Archive-Action: accept
Auto-Submitted: auto-generated
MIME-Version: 1.0
Subject: xfsprogs_6.5.0-1_source.changes ACCEPTED into unstable
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <E1qv1rq-00CHQp-CF@fasolo.debian.org>
Date:   Mon, 23 Oct 2023 20:49:42 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Wed, 12 Oct 2023 14:00:00 +0200
Source: xfsprogs
Architecture: source
Version: 6.5.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (6.5.0-1) unstable; urgency=3Dlow
 .
   * New upstream release
Checksums-Sha1:
 67cbbf4df148fdfe87830895f402a74e6b988260 2034 xfsprogs_6.5.0-1.dsc
 d6f99518d6c88994d7d4cad318b67cb69bc4ddfa 1348452 xfsprogs_6.5.0.orig.tar.xz
 c0acce0da898499c21ea26f7e631cf198f51e263 12604 xfsprogs_6.5.0-1.debian.tar.xz
 02c2351433dd033f04c28d2ea13ebe24f0681180 6367 xfsprogs_6.5.0-1_source.buildi=
nfo
Checksums-Sha256:
 694d3c572f23e8d1c21f3668131b1680258ff46b56b370c1e7f6072f9f3d9f74 2034 xfspro=
gs_6.5.0-1.dsc
 8db81712b32756b97d89dd9a681ac5e325bbb75e585382cd4863fab7f9d021c6 1348452 xfs=
progs_6.5.0.orig.tar.xz
 676116d002f257e117efd816026f96176fde2a941167f10aca315f12b8aa6921 12604 xfspr=
ogs_6.5.0-1.debian.tar.xz
 340dcec7bdba21aee8bc1a6074bcf072315bbf691699c6f2b82b72eb4ad38cee 6367 xfspro=
gs_6.5.0-1_source.buildinfo
Files:
 034f1cd62738c7c0eec7ded3bfe2a1d5 2034 admin optional xfsprogs_6.5.0-1.dsc
 312d4f63c02c63a6b8b8b80a9ada11c6 1348452 admin optional xfsprogs_6.5.0.orig.=
tar.xz
 0e6363f1f7496df3eb4284a3cf3b86d6 12604 admin optional xfsprogs_6.5.0-1.debia=
n.tar.xz
 5daf4c240a127cbcb2cd757f025cd059 6367 admin optional xfsprogs_6.5.0-1_source=
.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmU2w2EQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFMJOC/0TnDD7amW3jfpWLibNMsMnAVQEy5WhvJgb
q0pYbq3J6gu8wMgotilgZuhL2NM5i0MP7BX4A3E8leDQ7VcU4Wnos8X35tPIQ54y
wyH1sfd4A5tR/V20CJNJ2vqtFssk2o8uL6vWYm6EpJNa582tRQMdc6PoLucE1nil
uum+uduBxOI+wcEKm/XHs3PfkmEpBIW53AUqtHX2kAb8nFF+xlJXwxp+MiB97qd0
5iC5MarTixoVtCqkZAMi8GmdYB2xnrMw/YderAKo2lc8uGn1eBZwgmfP5Al6OeMT
ZcBHD1qs8AbnfLhFZEhknYe+GjOthH38UosVl+dzqIja01tEBzohicf2CdI6lFvt
gWMupM/9OIwU2gyXV/5HXJb67Z/OVG7sExmCqdK5PcDmrarrKcDyFwz3UlglYNYu
UeFrLrxVSh6PqB4AaczEnW6JIiZ4VeRXRpuHmYllTXi0cMrvTv1lm1eE/fUNBDuJ
v0CXv/zhKdXTDgQ0IXnn0iwE/hv3MgQ=3D
=3D0eQ7
-----END PGP SIGNATURE-----


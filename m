Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE96DC53210
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Jan 2023 10:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbjAHK32 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Jan 2023 05:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjAHK31 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2023 05:29:27 -0500
Received: from mailly.debian.org (mailly.debian.org [IPv6:2001:41b8:202:deb:6564:a62:52c3:4b72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4628DFDE
        for <linux-xfs@vger.kernel.org>; Sun,  8 Jan 2023 02:29:26 -0800 (PST)
Received: from [192.91.235.231] (port=34594 helo=fasolo.debian.org)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1pESvZ-005yu6-Mg
        for linux-xfs@vger.kernel.org; Sun, 08 Jan 2023 10:29:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:
        Content-Transfer-Encoding:Content-Type:Subject:MIME-Version:To:From:Reply-To:
        Cc:Content-ID:Content-Description:In-Reply-To:References;
        bh=p1QoI6eW2JRDz6lTmn/gqyaHSCXx3CddadFdruTVtOg=; b=XPZZy9MLQLQdQp6XjewIB7j1j8
        kNTYRz9U/grPM7bf4zRaZjuRJcuRkNp1vLai8yGeL12LPLEaoLa43rDGoYiUxTMxybQTJ3hdehKRb
        VgAtK6ksKg7yr+G3KNBqNryJm0K68H4pwPNcA+V4TLYRywvz97RW+Nc32Abyt8iqM5kSk85p+/xvc
        w6KXIjTdiOhpACFejiwvM4WmFWRKyPxVSjjv2pEWVLSwPq8PHQHAt2RSYXzpxHCNG0xZREKJRG2LM
        XdCsKWf/e9MMwbauxEZ/dke0LuusqQx3hpDa5tlWkwqXTlCB5BwzcjoIggt29vIrSDaE53Kx34hjI
        dax1TLow==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1pESvU-006076-H9; Sun, 08 Jan 2023 10:29:16 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     <bage@debian.org>, Nathan Scott <nathans@debian.org>,
        XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK:  dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.1.0-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.1.0-1
Debian-Architecture: source
Debian-Suite: unstable
Debian-Archive-Action: accept
Auto-Submitted: auto-generated
MIME-Version: 1.0
Subject: xfsprogs_6.1.0-1_source.changes ACCEPTED into unstable
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <E1pESvU-006076-H9@fasolo.debian.org>
Date:   Sun, 08 Jan 2023 10:29:16 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Fri, 23 Dec 2022 12:00:00 +0100
Source: xfsprogs
Architecture: source
Version: 6.1.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (6.1.0-1) unstable; urgency=3Dlow
 .
   * New upstream release
Checksums-Sha1:
 c50113a0d2f0aa5f2e0708a9b73ae1587bf9d31c 2034 xfsprogs_6.1.0-1.dsc
 1df880341fe1280ffafae5c387ba01720ae0fd12 1322908 xfsprogs_6.1.0.orig.tar.xz
 ee319f7d255887cc708ae2fb33219c4058550012 12464 xfsprogs_6.1.0-1.debian.tar.xz
 199635bb498edff144cc4c15da00af6ac28839a9 6404 xfsprogs_6.1.0-1_source.buildi=
nfo
Checksums-Sha256:
 ca83d22029b4956aad1956907917fea09676b7996969d8fa79931562fcc468d9 2034 xfspro=
gs_6.1.0-1.dsc
 eceb9015c4ebefa56fa85faff756ccb51ed2cf9c39ba239767f8e78705e85251 1322908 xfs=
progs_6.1.0.orig.tar.xz
 a9701ee09a75306d0cb797fc0a8d706da5a61d84476ff670ed3ec6048f9b0bb9 12464 xfspr=
ogs_6.1.0-1.debian.tar.xz
 7f4769e20c1e38b651dca1df7c1098448f7d2f49bf88b35eeba821d0a136ea67 6404 xfspro=
gs_6.1.0-1_source.buildinfo
Files:
 62a3f477cfb5093d5eabbc38b5b40068 2034 admin optional xfsprogs_6.1.0-1.dsc
 267f09f8b2b0c286d49693841f48400c 1322908 admin optional xfsprogs_6.1.0.orig.=
tar.xz
 31f538545083cb687fa8f7c38b927915 12464 admin optional xfsprogs_6.1.0-1.debia=
n.tar.xz
 592d41e6c1854130168952c05b46916c 6404 admin optional xfsprogs_6.1.0-1_source=
.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmO6jboQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFB4cC/9XOZ5p2Nvou2uEWqFe7A5anXn8GfuiShuT
7J8dVyrdQ7fadWWEK+z1Y/Zrt4BhwjqjsYQEaIXljdXwB91tXYEfA7yM5k5cSiSH
eh2lzYDoMAW6QXzxFao9FUeZAYh0PwZ7bTZb3oNx066QPq7RlY2HxY/JquuTV9SE
pjLD4uxDiPpIc80WD/ktw7PBXiaR6Sk9Kk8P4+e9x3wy81uklAXSsddw3Q6SG1NF
gX/PTg3z3YMozEMR1SAqXTea+BisgpYcLA3cmtnqb+q5v8NEe0wyMifyhRnzyq+w
WBNCOHvYBmLA4DxJ8/lE7EFbDDU6rRjmd9DCMjMyf6hADGnsTFUlmYXHcT992twa
pomlUdBEVU523IzLiyNjRO9S18nHEEfJGb62x7C0u2sunG8ZNDZniQj5CxqqBrwL
97lVzBNZu9PbqdMOQodn9o97ENmELL4WDn2uhj1KKD11AH8dOj1ZA8XTk5uiH41m
zVA3FgJMxvrw6+KxOVaM6w3o0tcmWYs=3D
=3Dd1UY
-----END PGP SIGNATURE-----


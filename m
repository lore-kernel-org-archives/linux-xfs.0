Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10331C7EE2E
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jun 2023 09:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238623AbjFMJRb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jun 2023 05:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239783AbjFMJR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jun 2023 05:17:29 -0400
Received: from mailly.debian.org (mailly.debian.org [IPv6:2001:41b8:202:deb:6564:a62:52c3:4b72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D19121
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jun 2023 02:17:27 -0700 (PDT)
Received: from [192.91.235.231] (port=33822 helo=fasolo.debian.org)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1q909V-00Ej1n-NY
        for linux-xfs@vger.kernel.org; Tue, 13 Jun 2023 09:17:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:
        Content-Transfer-Encoding:Content-Type:Subject:MIME-Version:To:From:Reply-To:
        Cc:Content-ID:Content-Description:In-Reply-To:References;
        bh=ZIT2/jf6Im1X/nc0YPXDgd0S6jLO8D6ocGjOcPBG+u0=; b=R0FwaUX5Li+DpGCpnLOkKGClEB
        jKx6C2pbCHpw+eqIBOF+s2911L8pd9EVqSN/eg8/B6LUbMNmo0DEwUgCXw80rWOttoC4XlUj7EKq1
        7bwEPmqIStBjimPTU0JGMzRe+MtZCvjwqLMEduiZEzP94RnXqQKwxD8hWm9m8W+lh/Z8gftfjSDaq
        svMmwfkO/06z0bLR1xgjVJs44tcqMhDLnDUayNyd4d32eApMqhIzwHnvRDH+81TtwfAOhIspsYS8B
        H7c1JVxPm0jfMXSbc2m3lJIfX/XnBLkrtb/Y4Tz2VNncOC/174WZRu4/0qffYkev+Yf8YJuG/bHOa
        OTbudyyw==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1q909T-002UwN-7L; Tue, 13 Jun 2023 09:17:23 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     XFS Development Team <linux-xfs@vger.kernel.org>,
        <bage@debian.org>, Nathan Scott <nathans@debian.org>
X-DAK:  dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.3.0-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.3.0-1
Debian-Architecture: source
Debian-Suite: unstable
Debian-Archive-Action: accept
Auto-Submitted: auto-generated
MIME-Version: 1.0
Subject: xfsprogs_6.3.0-1_source.changes ACCEPTED into unstable
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <E1q909T-002UwN-7L@fasolo.debian.org>
Date:   Tue, 13 Jun 2023 09:17:23 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thank you for your contribution to Debian.



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Mon, 22 May 2023 11:45:00 -0400
Source: xfsprogs
Architecture: source
Version: 6.3.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (6.3.0-1) unstable; urgency=3Dlow
 .
   * New upstream release
Checksums-Sha1:
 f425c3bba84b2da54dcbf20c75c30233546ca25d 2034 xfsprogs_6.3.0-1.dsc
 e976c2c41a957ee16094690596ee210dd45951fa 1328452 xfsprogs_6.3.0.orig.tar.xz
 31fca71e6b3c41582a5f61f7e89408516688be74 12548 xfsprogs_6.3.0-1.debian.tar.xz
 d4ac387340f2ae055bb0d6771a538554ae2ed84b 6233 xfsprogs_6.3.0-1_source.buildi=
nfo
Checksums-Sha256:
 aaf561fddac3390c560f5cde1facaf5bec5b8ad8cfc0c3175d8b48078a0404fd 2034 xfspro=
gs_6.3.0-1.dsc
 ec987c9f0bcb2db2991bffb80d353150b389c3a2b79b6830411f7042adf6990c 1328452 xfs=
progs_6.3.0.orig.tar.xz
 6b82418a87b699571f30fa6e84f606b268a665c832297093dcba13bdc0d54230 12548 xfspr=
ogs_6.3.0-1.debian.tar.xz
 65464258ff893123fb70593f385b4ee90f38a6ebcdc909c82e49a4b98a88da74 6233 xfspro=
gs_6.3.0-1_source.buildinfo
Files:
 8e9727d34f0024c1188598cb3b6d66bc 2034 admin optional xfsprogs_6.3.0-1.dsc
 4bb3f51310a54282a92c61ce7d2c8cd8 1328452 admin optional xfsprogs_6.3.0.orig.=
tar.xz
 24ce948e91522cb45c22fb11214c0632 12548 admin optional xfsprogs_6.3.0-1.debia=
n.tar.xz
 2c6b105b46768a646a299f2abba1a4f0 6233 admin optional xfsprogs_6.3.0-1_source=
.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmSILqYQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFN2KC/9CeexK//9vyxtJokoA/PJOSpo+Ty3y5SBg
ep4SzQ8nOLAdd4LQzLKQTaXL4y8eLKDVTCb2zyCVj6fASSn9YHqjzhcZZyaNSdne
8bjwfgKFa7JGx2wQeQVbQf091IRw7Oq49PgU6RIEhxaROCFRPWyTUyA3at0PWQyH
OvdrnHFpb6mVl85K7CkPx9lzzDKilQ4n/atQjJRAafsW47S9wxrA4wUNaGdsZDvO
6i83BEdF+wWmoGlaKtnPgKbJLOOzX9dbYb55BIKGpMKd1ObE0QTCROs8TN+kV3jK
kXFDpSMMPIhQQGGOKKvYYbinXF9NcuRph4bwNUf3ahJcXwnnwpaoBY/b2kVrE3fp
XoUpf2PNG4lGvQqCqjT7bMBpdV6mGDO1Jd/qKd3ENPC2B7rre8Fx3eMGAQYPK3a6
JBU+DvAWpeTlSUDw2zvGUHkCwQaoZ/D+NR4KoPSSNXIfbK+a4QAbrgl1CrK9RDnx
p+ZubBykKBfGmfFhzSN1rR9EpRTcQtg=3D
=3D5qjQ
-----END PGP SIGNATURE-----


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC5CC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Nov 2021 00:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C909761205
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Nov 2021 00:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243496AbhKPAps (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Nov 2021 19:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343851AbhKOTWQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Nov 2021 14:22:16 -0500
Received: from muffat.debian.org (muffat.debian.org [IPv6:2607:f8f0:614:1::1274:33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883A0C048760
        for <linux-xfs@vger.kernel.org>; Mon, 15 Nov 2021 10:25:26 -0800 (PST)
Received: from fasolo.debian.org ([138.16.160.17]:52728)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by muffat.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1mmgfR-0005qs-AR; Mon, 15 Nov 2021 18:25:21 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1mmgfP-0004qt-LH; Mon, 15 Nov 2021 18:25:19 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     <bage@linutronix.de>,
        XFS Development Team <linux-xfs@vger.kernel.org>,
        Bastian Germann <bage@debian.org>
X-DAK:  dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Auto-Submitted: auto-generated
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: xfsprogs_5.14.0-rc1-1_source.changes ACCEPTED into unstable
Message-Id: <E1mmgfP-0004qt-LH@fasolo.debian.org>
Date:   Mon, 15 Nov 2021 18:25:19 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Sun, 14 Nov 2021 23:18:22 +0100
Source: xfsprogs
Architecture: source
Version: 5.14.0-rc1-1
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bage@debian.org>
Closes: 794158 997656
Changes:
 xfsprogs (5.14.0-rc1-1) unstable; urgency=medium
 .
   [ Dave Chinner ]
   * New build dependency: liburcu-dev
 .
   [ Helmut Grohne ]
   * Fix FTCBFS (Closes: #794158)
     + Pass --build and --host to configure
 .
   [ Boian Bonev ]
   * Fix FTBFS (Closes: #997656)
     + Keep custom install-sh after autogen
Checksums-Sha1:
 d3c15cd8386cbeb793838196efa329c31f67b170 2045 xfsprogs_5.14.0-rc1-1.dsc
 38f986a3f49a914f81f65cf3a09553f565ac2c0d 1536948 xfsprogs_5.14.0-rc1.orig.tar.gz
 cca1668fde70c881cb28d1e0d612229150293889 14232 xfsprogs_5.14.0-rc1-1.debian.tar.xz
 80932400488c0408da8b03f5ef3df87bea6ddd05 6251 xfsprogs_5.14.0-rc1-1_source.buildinfo
Checksums-Sha256:
 7ba6ebb4446bfd8257e185ef3b15172a9dec870f25dca875939fc2092792169e 2045 xfsprogs_5.14.0-rc1-1.dsc
 fccadafbf8c609fec5f6b38f452879b83647dff640a16bca939777ea4e81bc04 1536948 xfsprogs_5.14.0-rc1.orig.tar.gz
 7eede3f2cb24fecc5419762b4e2493afc856a850f47adfc0ea4a6b044f768885 14232 xfsprogs_5.14.0-rc1-1.debian.tar.xz
 516f6e2eb6e94804e0b7e6849507786b2af7bf5af45795c1daaefd980f250d0e 6251 xfsprogs_5.14.0-rc1-1_source.buildinfo
Files:
 c584f503002c94b4375d63a65eeeda79 2045 admin optional xfsprogs_5.14.0-rc1-1.dsc
 5170e9971709bb1847b2b5363d3d2807 1536948 admin optional xfsprogs_5.14.0-rc1.orig.tar.gz
 d2939ac3e1db87942907ba9b6953b016 14232 admin optional xfsprogs_5.14.0-rc1-1.debian.tar.xz
 c0a1a12e94c11239a1c696a7df4bb7bb 6251 admin optional xfsprogs_5.14.0-rc1-1_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmGSmlcACgkQH1x6i0VW
QxRcagv+JRdcKjx/4J8TDXt6wRS9GY9Qx1AcgsjpaY5auCzCXN/l4AzkBHinlVzO
JFUy/icg7c2jQq22rEkyMD/uHkURp/O0Kz7Ld73wghYBbTmLs+czLa66cA9eVPYQ
cu0X/biC2DTGASHvp0FuetHgvO4KUQvTYDIINEeDnfVgwSjSHzMkHTIPlHj/X74d
GBNH7++IV8MpqKlZBDfgKYSUeE9Hm0zssCjlgZudA4+dal/cF3gq31omcE0lFjAE
p3OBDzn9fOOei1jEwDtwV9K3y+5NP5tBVsOSG2EkLJEhRRS+VqbpQCUUQwAzpKNF
RpqIZ+JQZH3cyOnVpqidae/oABN/oEXAHDlZ/X52bT2tlH4wSGMRtz6rXC5hp0jd
j2phekA8lHaW+7ACPH1rNYE7e8Vg0hUdOCAzxNu2FDnPLzC/GfInlSBoHojWhTt2
2oBo/Z16ejjShcuuaTM2RWJSEopY2X9ouz1ea/nTdOCVV3F8kYGnORWScj16QzPo
vdJg1PlB
=GJZC
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.

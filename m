Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 810DEC433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 21:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D16E64FBA
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 21:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhBEVOc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Feb 2021 16:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbhBETXo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Feb 2021 14:23:44 -0500
Received: from muffat.debian.org (muffat.debian.org [IPv6:2607:f8f0:614:1::1274:33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E557C06174A
        for <linux-xfs@vger.kernel.org>; Fri,  5 Feb 2021 13:05:30 -0800 (PST)
Received: from fasolo.debian.org ([138.16.160.17]:51902)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by muffat.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1l88IB-000547-LO; Fri, 05 Feb 2021 21:05:27 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1l88IA-0006CX-OP; Fri, 05 Feb 2021 21:05:26 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>,
        XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK:  dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Auto-Submitted: auto-generated
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: xfsprogs_5.10.0-3_source.changes ACCEPTED into unstable
Message-Id: <E1l88IA-0006CX-OP@fasolo.debian.org>
Date:   Fri, 05 Feb 2021 21:05:26 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Fri, 05 Feb 2021 00:18:31 +0100
Source: xfsprogs
Architecture: source
Version: 5.10.0-3
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bastiangermann@fishpost.de>
Closes: 570704 981361
Changes:
 xfsprogs (5.10.0-3) unstable; urgency=medium
 .
   * Drop unused dh-python from Build-Depends (Closes: #981361)
   * Only build for Linux
   * Prevent installing duplicate changelog (Closes: #570704)
Checksums-Sha1:
 900af5be1841442f9be8a64e9f29d9b961bb53da 2047 xfsprogs_5.10.0-3.dsc
 318931355b60145dbb335852c8848830ed13429e 13884 xfsprogs_5.10.0-3.debian.tar.xz
 df3f27fb3acb4a0c092d9620948a90fde44bc198 6145 xfsprogs_5.10.0-3_source.buildinfo
Checksums-Sha256:
 5515e789676e657d92fde061a40875313bbc906f30343e35a164d2df699db4da 2047 xfsprogs_5.10.0-3.dsc
 8ff1807e228afe92f489d19ddbc415358b03375320ceead38debd4408511862a 13884 xfsprogs_5.10.0-3.debian.tar.xz
 d796004671c464b0dc82ff31c3e0dd4464d44e6e7a235cde59eaa47b740fc421 6145 xfsprogs_5.10.0-3_source.buildinfo
Files:
 3eb63eadc5601aa0f5d6a6b32479a45c 2047 admin optional xfsprogs_5.10.0-3.dsc
 be5f3ab288c96161d358308e7c810a89 13884 admin optional xfsprogs_5.10.0-3.debian.tar.xz
 e5eca5118bf2497e0cfc13812c07558f 6145 admin optional xfsprogs_5.10.0-3_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHPBAEBCgA5FiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmAdr2MbHGJhc3RpYW5n
ZXJtYW5uQGZpc2hwb3N0LmRlAAoJEB9ceotFVkMU0vYL/iRxjvSoq8/YdiozpiYP
D7ZVU4R75eq5l97NkAw8KqA81yYjYLsLNFLG4FPdFAagl4M2FbdoLYmPsl7XmaB+
Bz40dlxYoNV9u/JyqpnJEL9MpDalfc0FGHpdz3xCbjg0d/28DOuHXOzjy48o7Ac5
G+eQMEu/XcHLD+c0O00odPngq1blNiRWt6nINpXH7CU5q49Cv/UiqDOI6CjMnqnm
2AhqQbCP3//jCIIyYpGqawyh0RcslmigYWc0vGTtanuhe6JOi+CFKP5JpCIQ7fi3
5aJgTJRhsBSKO6YV33bTGRxW6rZgiLUehKQOqyYS0f2IaaGYGxMquoLjCoOvrD4H
Ove4eq/6z+Ad33+KBtIQV/zwsOjXAjgejPzQiTJOWfv7Rq9/o1Bl8dlKSz8KZYWu
dovtOxiVyh/jj2XTaR42l8XiR6mF1vdnWB5+A8Uom1FkykOfNE4JMmRVp9++DyH5
F8DcQabeYYPttu+C+i+llhqhJVOQGm7E6rltXpy4IX1Eaw==
=n4pB
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.

Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F277BC433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 10:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390986AbiEFKin (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 06:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379956AbiEFKin (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 06:38:43 -0400
Received: from mailly.debian.org (mailly.debian.org [IPv6:2001:41b8:202:deb:6564:a62:52c3:4b72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE2963398
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 03:35:00 -0700 (PDT)
Received: from [192.91.235.231] (port=33148 helo=fasolo.debian.org)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1nmvIa-002qRM-4b; Fri, 06 May 2022 10:34:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:To:From:Reply-To:Cc:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=QoyhzKAeSk3bxqqe85WBdKY4TuSuIc9ARmGeQ5mnOw8=; b=O3PEb7LUjUbhJi/VWhqgG5iLgA
        ikEMD9MJDWZZKROwkW/Uz9hLbEzWYf1FGMwlYDYhM/nJ8rbJXsx50DAJVmyFx5dcZ4XCMfSd3IPnU
        rkr28lA1yjOL7nBx+rTrgh6DJ1lOrj2uChJUZJOn82S4j0RIISsWM6vPsAy5U0pw6Ekn+fd+rvr0T
        RUXb9wvnvxxjz7HbDzBTrhUHP+4N56YW1/3nU7QOLjoLZTaIsJe5zL1mO4t0wvTFYfGt9CJFTjNpg
        JaIx89vuoJ5QfsiEGumbRyAwbC+fAiEfbR3/lNMwCXQJJO1d/AqMpCkDqfdQyLJ6s5y64YmCEa9bk
        +sQ/hAvw==;
Received: from dak by fasolo.debian.org with local (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1nmvIX-0008ri-G8; Fri, 06 May 2022 10:34:57 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     Nathan Scott <nathans@debian.org>,
        XFS Development Team <linux-xfs@vger.kernel.org>,
        <bage@debian.org>
X-DAK:  dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Auto-Submitted: auto-generated
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: xfsprogs_5.16.0-1_source.changes ACCEPTED into unstable
Message-Id: <E1nmvIX-0008ri-G8@fasolo.debian.org>
Date:   Fri, 06 May 2022 10:34:57 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Wed, 04 May 2022 14:50:48 -0400
Source: xfsprogs
Architecture: source
Version: 5.16.0-1
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Closes: 999743
Changes:
 xfsprogs (5.16.0-1) unstable; urgency=medium
 .
   * New upstream release
 .
   [ Bastian Germann ]
   * debian: Generate .gitcensus instead of .census (Closes: #999743)
Checksums-Sha1:
 eb15265bf458c6c43916b43c9f2a415c59b92e43 2041 xfsprogs_5.16.0-1.dsc
 259a52b8be50d3cf762d70ec24501c2b5d5c90b3 1306100 xfsprogs_5.16.0.orig.tar.xz
 644eaa249e755bb569cb77eda7ee8549295f74d5 14348 xfsprogs_5.16.0-1.debian.tar.xz
 567c88ac03589102f6c1cf49b2ba9de0dde82e18 6366 xfsprogs_5.16.0-1_source.buildinfo
Checksums-Sha256:
 95fea80d092a3e37466b3584bb11140c0ab17efff48ae716e6a43fc1fb7995fa 2041 xfsprogs_5.16.0-1.dsc
 78b8c899999bd690441cb53d7c02ab671294940319c694ff7c82e23e8e46bb9f 1306100 xfsprogs_5.16.0.orig.tar.xz
 ca6e21010865e1f1e069feeb49cc72aa0eaf9b7eeebcd4b5eeb4e49072c4f7c2 14348 xfsprogs_5.16.0-1.debian.tar.xz
 167d979bab05a00928bedebcc7f5d0f4eac095fe8aa78b271649f03b0635c09a 6366 xfsprogs_5.16.0-1_source.buildinfo
Files:
 82b9e303c192256d97306cbaa21f2ee9 2041 admin optional xfsprogs_5.16.0-1.dsc
 20446fd3e857d1568c0ead3e88453f86 1306100 admin optional xfsprogs_5.16.0.orig.tar.xz
 26a5dd49f4fc4cb044eab19d35b89ac0 14348 admin optional xfsprogs_5.16.0-1.debian.tar.xz
 4d57accf043b529cd6eaf9f5ed9feef9 6366 admin optional xfsprogs_5.16.0-1_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmJ07e4QHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFJJbDADN6iot0JkmTZdB1ATg5Lm+mHZf8Bt2W/kb
gTAi1DrT0cbOhO1mDzIdIMLg+QEbic2MQxNTTc3eG6dhfzmZrXsW6ReV+OUhilwF
FfXd6nf19z2Zxz+wdW3URvJmEwiOA53NOYwmiby3/mvKwQYEpwvpMWBiAhOeTKgS
aT5BuM8eYVBxBJKSNcNM+K5wH7YSq0OxdBTDR4zvKfIs1oAPrns3xOX970DeSU+j
04meleEAKiCPMbv5Qh/BZqUeXSOIbvfftCsQbPymm7ZNM0o1ueH2wXR+2ZGawvNC
VLQH/hfaWiBX7w5xJBjnt7+/n5i3aOxMYkK2yeUviJxp4AhYHsRUcPbWIFFBtrWb
60kXAikzDK0Y13QXMca2+LuFgtzRsQ0rW7pr60tXO2vESjXaWa6bhMUiTVa+A7t/
0mUEHPLxs2AuN1v7anDUMO5Yy91OFIEn5rUnh5qMtVpyT8O9DVgyGLJ+HFKI2Uyq
/pv2chnGDK6FRL9rbPJsKM9x0n/07fI=
=3q95
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.

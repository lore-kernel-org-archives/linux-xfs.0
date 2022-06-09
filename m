Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A1B7C43334
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jun 2022 16:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbiFIQgQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jun 2022 12:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344772AbiFIQgQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jun 2022 12:36:16 -0400
Received: from mailly.debian.org (mailly.debian.org [IPv6:2001:41b8:202:deb:6564:a62:52c3:4b72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA53648E56
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jun 2022 09:36:14 -0700 (PDT)
Received: from [192.91.235.231] (port=50992 helo=fasolo.debian.org)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1nzL8k-006Lzn-Ad; Thu, 09 Jun 2022 16:36:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:To:From:Reply-To:Cc:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=h7rs5Lolrvc/SUg9BMoNYML+pKEVvK9SpDdDv1X0RPI=; b=tqrfA7XXhmRGhx+KabDjr6NZKX
        h4kdd+DlPGUTzYLhN6q+Aw3sdCc34do1LIoySQzq0ojNl0k0xgEAlGzOFOy2j6HMMyck8KxtjEf+r
        E9sm/cXa/2Q1cvoPZjuSmiwNqCRkAnF2mWFCeuj9xDN7IGJonz8Ye1Cy2eFedeDjCL80Z84ojdlIT
        S0h+G03DVyj49XPcb1D1gIMwtmMntKbRFc5XAK4CJhyhFmY5po51OTUGZ6oQqX9caCv7p7ena7n7o
        7u3Tv78KrGCWljd6xsqPewt0B0+ayhfoXdp5R5Kozvem05qES4+JE0FeZkt8KPNuIvKQtSsvqrfAa
        XNGGUV3w==;
Received: from dak by fasolo.debian.org with local (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1nzL8j-0002ZV-41; Thu, 09 Jun 2022 16:36:09 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     <bage@debian.org>,
        XFS Development Team <linux-xfs@vger.kernel.org>,
        Nathan Scott <nathans@debian.org>
X-DAK:  dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Auto-Submitted: auto-generated
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: xfsprogs_5.18.0-1_source.changes ACCEPTED into unstable
Message-Id: <E1nzL8j-0002ZV-41@fasolo.debian.org>
Date:   Thu, 09 Jun 2022 16:36:09 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Fri, 03 Jun 2022 15:18:30 -0400
Source: xfsprogs
Architecture: source
Version: 5.18.0-1
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (5.18.0-1) unstable; urgency=medium
 .
   * New upstream release
Checksums-Sha1:
 021f76d5551a4e98d039753ce0db81b36ce15a99 2041 xfsprogs_5.18.0-1.dsc
 31ace06bcf1ff14eaf0e5c858d138374b8311dc8 1310008 xfsprogs_5.18.0.orig.tar.xz
 5252b95791be20b4175eadadf6f253b8e1886932 14372 xfsprogs_5.18.0-1.debian.tar.xz
 d1e2e6e028f84ac822c76e05e187b9cb91451dfd 6423 xfsprogs_5.18.0-1_source.buildinfo
Checksums-Sha256:
 1062b87b2969c43cb04011ec5d645ab9e824218ccc3a96fd4b96f3d567a58536 2041 xfsprogs_5.18.0-1.dsc
 1e8d8801bdec8cd4cad360ce3bbd12c35a97f2bc8f7c8c9580d1903b0e8cc35b 1310008 xfsprogs_5.18.0.orig.tar.xz
 1dc56f07a9015d491d85c173b94e8715e354dc2072b3ade553e67cbff864c59d 14372 xfsprogs_5.18.0-1.debian.tar.xz
 deba51cbf9de004a23e091c53875494c153abd9348223c145d2b73537890eb12 6423 xfsprogs_5.18.0-1_source.buildinfo
Files:
 30771725d96736b3ddc63056bda09114 2041 admin optional xfsprogs_5.18.0-1.dsc
 548d7740deef0c8df0fb5a7e1945121e 1310008 admin optional xfsprogs_5.18.0.orig.tar.xz
 0cdea92b2ad071706e5f94f17fd3ba21 14372 admin optional xfsprogs_5.18.0-1.debian.tar.xz
 43dcfc8f52956a89c46eb95074c0fa3a 6423 admin optional xfsprogs_5.18.0-1_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmKiHicQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFJUUDADZItz6+60qbWQwmA1gxFGFpy5FKheadwwp
Lk3WuVdlQ7/RxDhM6x84yE2Z4WYQH3EgTf19zXtDh480BGAzxINlDV87Z/s1ppA3
ltYxn+akfhuBbyO3COS5SaDLWkSJ2IYCyoW5/16PcX+78ngqvLdCGtRjd21rkGkQ
ap8WJwwMBz7oKlBjkutu0nv2A7EPg3nVQidwtF8GsHO8rVw0hyQvLyIBYQN2x1U9
H/6pS4/GzPm3mrbG9mABOoCk390lNNjpsYK8ZpQF5aSA8Os1bkCBAJwiTXv2duce
eThjInVD7RCmoAq3apbICa8VXyoTGTUYU2keDFXwcP62HSGwUGwcJDVTDyp4sGOQ
js8m9CaLWjcWka5EDDtk9GuyDrype5YtgbgGRHxt4TO2BH45p751wBVWHuH9FDr7
OQu11QZpmtwloIJINbq6c8jK4w/lJGJ0Pq1EEzdhWXhKwRTaLJhCnGuVJuTnQ8K0
dx60IzkMxk3iIzF+mNj9I6rR0NAkVDA=
=b66C
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.

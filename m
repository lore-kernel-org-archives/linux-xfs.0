Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A14C43217
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 13:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239324AbiKQNeo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Nov 2022 08:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240130AbiKQNen (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2022 08:34:43 -0500
Received: from muffat.debian.org (muffat.debian.org [IPv6:2607:f8f0:614:1::1274:33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B642C100A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 05:34:42 -0800 (PST)
Received: from [192.91.235.231] (port=60880 helo=fasolo.debian.org)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1ovf2R-00Bu4o-9l
        for linux-xfs@vger.kernel.org; Thu, 17 Nov 2022 13:34:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ftp-master.debian.org; s=smtpauto.fasolo; h=Date:Message-Id:
        Content-Transfer-Encoding:Content-Type:Subject:MIME-Version:To:From:Reply-To:
        Cc:Content-ID:Content-Description:In-Reply-To:References;
        bh=B41s1Co0k4q9HxLaRd3TKR37XHZbqam0laHKjPSBiUI=; b=tUauv3h680bGV1Qwb6svdm+YFd
        hHYx9MvW88GksFTjyjVZg99Yg24hRagYscZTTAyV2cZ0pidoos6gziZ64GdxF1RciKAOIiYDhCL78
        /vFBm3TiUNiwP2TxozL1DqHl5i8MT1h0tWOyfqElrEC3cll4bdfRHqSmSTPP++0ns7vVaUakvTySM
        p7eJI5exr8mhcOgJ2PslP2Z0Yme2O47ahNhqCNF0e5AkQ7z2rYeHtxnhpyB2gMvF2h/OZZ+u0glq6
        RKWKFqqULb7NxrnmZoaPWu97nuRPCb+9i1uf5kfFO3Zv4Nj/IAefWmyuIA7/wDuvPUqSZFhdNiFBw
        I09ySAKQ==;
Received: from dak by fasolo.debian.org with local (Exim 4.94.2)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1ovf2N-008xIy-DB; Thu, 17 Nov 2022 13:34:39 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     XFS Development Team <linux-xfs@vger.kernel.org>,
        <bage@debian.org>, Nathan Scott <nathans@debian.org>
X-DAK:  dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Debian: DAK
Debian-Changes: xfsprogs_6.0.0-1_source.changes
Debian-Source: xfsprogs
Debian-Version: 6.0.0-1
Debian-Architecture: source
Debian-Suite: unstable
Debian-Archive-Action: accept
Auto-Submitted: auto-generated
MIME-Version: 1.0
Subject: xfsprogs_6.0.0-1_source.changes ACCEPTED into unstable
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <E1ovf2N-008xIy-DB@fasolo.debian.org>
Date:   Thu, 17 Nov 2022 13:34:39 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Fri, 11 Nov 2022 11:29:37 +0100
Source: xfsprogs
Architecture: source
Version: 6.0.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (6.0.0-1) unstable; urgency=3Dlow
 .
   * New upstream release
Checksums-Sha1:
 34ba4e1c252f1fbbf7ea5abb288441fc92497533 2034 xfsprogs_6.0.0-1.dsc
 dd63dd87c5d30e50d20d6a5237e818d462ada141 1320744 xfsprogs_6.0.0.orig.tar.xz
 303f9eaefeada3f8a6d19c518a3e94b686c7566f 12436 xfsprogs_6.0.0-1.debian.tar.xz
 6fc4f50df7c0918cc3b0e123e13ef928c4652cb5 6420 xfsprogs_6.0.0-1_source.buildi=
nfo
Checksums-Sha256:
 f295927ff905ff79d829b188956468e648dfa76167b1dbc6ad16d1a3d3139ffb 2034 xfspro=
gs_6.0.0-1.dsc
 b77cec2364aab0b8ae8d8c67daac7fdb3801e0979f1d8328d9c3469e57ca9ca0 1320744 xfs=
progs_6.0.0.orig.tar.xz
 8e06d156df7d8094961af0865c830732240a7a720b5a3f7932c2317806443b30 12436 xfspr=
ogs_6.0.0-1.debian.tar.xz
 95d063de3b1a44f2128aebf0a69b1b3dd4f33cafeecc16b811c55ef6bc4f70e6 6420 xfspro=
gs_6.0.0-1_source.buildinfo
Files:
 f65d16db3a1762808fd6f0a43c3457ea 2034 admin optional xfsprogs_6.0.0-1.dsc
 2908d7433cd2aafec9cd69846ef6df9c 1320744 admin optional xfsprogs_6.0.0.orig.=
tar.xz
 f79243235b85a15bf13390dfaf55f6ba 12436 admin optional xfsprogs_6.0.0-1.debia=
n.tar.xz
 381a49c88e9b256071f337153025a54f 6420 admin optional xfsprogs_6.0.0-1_source=
.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmN2NSgQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFJBsC/9GFO5518v5EzrMT+KSzHzHElor2pQu4X2n
enm9AZ72ne5ujwYqRnwa3M67E8uZoipkjByxZMZ6HpzeQeS8mVqGw4Nsm9Ykxjk7
dnuSnVNUs8waaDMACi353NU7/STo6qiGtv81MFB5v2DkW/WdZQ3opz5eK9LUoH+I
OLp8mr//u3qYJx9+zaA1FyhjQDCyiEQ4O2J2D5dU3nXyhZaKlSloIkqlSnbOrt5k
bFLAonB4MQ1UYWDmYyBNJ7B7CjVpA4a4huy2SmrAZ9e8zPdgdviBHqlXx+aIJGOE
a11xQRrzkG4/cKAfERNNnLucYuw/ThEJ5aieYFxWcK4iIW5aIuDTlsGjBbLsPZHx
x6dx7ndou0LvZab1ewYuoRjuLaqRe6vQvWMZGc+gcTqySusQKYq4fjJ5JspBspjb
BuPXX2mxJs4Sg8k5B8Ns5BQGBxywj25UttQd0NYkHMQ1DsOxIgaoUkDXuL/vdkl9
0I7SNE/jQ+3x3PXi1s9BNXvoVkTwJ14=3D
=3Dggg6
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.

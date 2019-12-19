Return-Path: <SRS0=RLxe=2J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658BAC43603
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Dec 2019 20:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3899924679
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Dec 2019 20:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="qOx+odyg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbfLSUtK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Dec 2019 15:49:10 -0500
Received: from ozlabs.org ([203.11.71.1]:49389 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbfLSUtK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Dec 2019 15:49:10 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47f3rg1Cbkz9sPT;
        Fri, 20 Dec 2019 07:49:07 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1576788547;
        bh=NcjTJwJC9GjtYt/2hokQNOc4AWT4U7JCnDH3TlJvTGs=;
        h=Date:From:To:Cc:Subject:From;
        b=qOx+odygpMLwN08HcA6UKXq0hpUaKhPJAfFj3AKQudQdwm4kdZy+3fG9scMZNZFx2
         TISs9EswiL5g8yiR+Gyrx9Avf7kseE385aNbo8K+lTlxiuyomhTltP6SnBPKqm7t5S
         4YSML7dWDMaUnlN111kB9WIRFx7tZndCn1//6USpdKLp3/RTP7sZiUs5UCXQ2itRKf
         EUZ5h6W56EbAUzYOCYmafPi/uWUcn7/W0+kpSGA402+IoJaJ0IBHenUnCjQManuCMT
         Bs8VPkMALBcZZVg16r8Ar1SYyV0mzYL+prcoifL1ryo2ai2NZhNNzEFSl3PSsT9Dc0
         6/uyCV2kGZJww==
Date:   Fri, 20 Dec 2019 07:48:56 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>
Subject: linux-next: Fixes tag needs some work in the xfs tree
Message-ID: <20191220074856.434eba23@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/74iFm+IlPAN20YC+Ky+K9+3";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--Sig_/74iFm+IlPAN20YC+Ky+K9+3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  826f7e34130a ("xfs: use bitops interface for buf log item AIL flag check")

Fixes tag

  Fixes: 22525c17ed ("xfs: log item flags are racy")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/74iFm+IlPAN20YC+Ky+K9+3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl374jgACgkQAVBC80lX
0GwbXQf/YkIxGihdWiJ/Zdzq97KNc27aBR8g0dcqetJ1BvaqsezQDR2qfOD03GEn
/wUKmBnyUGEhKxzEJBgga1bs4uOIajX3Wg69vjmOGdXPuRs+jCZTqRoV4T6pHxaJ
paLjWJXInIXOF0ZL7QrZwFBXq/xqHXf/Ea2P10yI3F7zB+5cG8EXVYgoSoxv3mxr
k7Rbkpt9F3qVOFH6+WVAyJTKnVh2S3K8toht5VFQNHLas/7Whe+gbtCLHEviF1NR
7wPif/fedugIh9I+6Qwlc2ja9sAzhkXDQqQorpru7UthiKkr5v0tN44dU6emUdlh
XISc8e3L+IoyZDdn0jRinSnzw0SFPQ==
=+z+V
-----END PGP SIGNATURE-----

--Sig_/74iFm+IlPAN20YC+Ky+K9+3--

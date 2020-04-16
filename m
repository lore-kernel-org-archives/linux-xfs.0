Return-Path: <SRS0=bcFD=6A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD94C352BE
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Apr 2020 22:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6719121973
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Apr 2020 22:19:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="f5J9MBFI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgDPWT0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 18:19:26 -0400
Received: from ozlabs.org ([203.11.71.1]:44215 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728982AbgDPWT0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Apr 2020 18:19:26 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 493DCv0b80z9sRN;
        Fri, 17 Apr 2020 08:19:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1587075563;
        bh=uD3XGVR745G/z5OXTjHFa2cFPMbl/b4si7y+VRMxGNc=;
        h=Date:From:To:Cc:Subject:From;
        b=f5J9MBFIL+OVDZsuAvNTTFMikMTVBdZmDS6zkz/aMZO8++ah4GKbGsuu8HSflwlkd
         li94a216zhf1FaHvKgE9E0DR30w6/WYux2aepoZaA0xD/7UtX4B5mXCo3WTSKx6jJj
         SPgGI8yIZj8WwV6Fx5VuDmy/c1mSNXFIUgj9LEmEtKUrjdMs1hTBhqmUM9z/pj4nZS
         VKr9EZnoGueCg5AvI1VuK5d/ppzWHIaqHPswau6h1Ey9TBhXV9Bt1jCDdIL4biOYRB
         cH10PsThObX+5Ss/Fs+y9kRTchhBSZYx+AdXEopY7AAUc1veX7hieoGfRU8w9D9lPU
         wFvadNKI5Sj+A==
Date:   Fri, 17 Apr 2020 08:19:22 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the xfs tree
Message-ID: <20200417081922.3b539711@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/yCK/bVt__4zEY.GbscHcnsv";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--Sig_/yCK/bVt__4zEY.GbscHcnsv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  63dc90feaa20 ("xfs: move inode flush to the sync workqueue")

Fixes tag

  Fixes: bdd4ee4f8407 ("xfs: ratelimit inode flush on buffered write ENOSPC=
")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: c6425702f21e ("xfs: ratelimit inode flush on buffered write ENOSPC")

--=20
Cheers,
Stephen Rothwell

--Sig_/yCK/bVt__4zEY.GbscHcnsv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6Y2eoACgkQAVBC80lX
0GwZtwf9EZfqnje/VCx4ilazW38G2AlNbDOasNxzIfxpOShuwrHavN3BaVWrVi1M
Jv9YyJfhci5FDgFu5hRR+ifoAwfhlVvFcAwN8faCNvEOtQiLgNTY7FvKcQXjE5Yl
jTj3cG1g00lsjklOykO5IJ6y+CXE+g9SSH3/PJMzefsfeEGUdkYov8xfuovEIOjB
N5UOonJNmg4/24O+sHse+BzXRfT61CPpJMycOJBu4mZ5bkAGewEWN0uHs8+zp/C4
SQ4ujDtJy2s4P/HIWzxmEeleDNnLMpKG5YlXF7wKOBwe8XlMo1sfPYrUlW1jGlP+
4WPVzC/wHxBHIYswOdYSkVzeQU3YYw==
=CjB5
-----END PGP SIGNATURE-----

--Sig_/yCK/bVt__4zEY.GbscHcnsv--

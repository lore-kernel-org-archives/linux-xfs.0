Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFEA1C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Aug 2021 07:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADBB460FC0
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Aug 2021 07:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbhHKHm5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Aug 2021 03:42:57 -0400
Received: from ozlabs.org ([203.11.71.1]:43731 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235037AbhHKHm5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Aug 2021 03:42:57 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Gl1xh0gTNz9sRN;
        Wed, 11 Aug 2021 17:42:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1628667752;
        bh=XxLeYOO9r6/Tx7msepMC925/W01uVr5GmXFaF1BjPRY=;
        h=Date:From:To:Cc:Subject:From;
        b=MSHKaMbEn7v9X7JWKUGU7rv2T/l/USKZKrx7zdZdzzy+Mj1ZcoSE+0jO09kQxINAF
         iHadEfdowpRQEkNKkEJumVjfQlpecptAuY+jTCdgV2OKSztLo8eBpLOyYEmsPldXE/
         StsuPbr02hMgqhy+0zKf9b8tLJqHTNLSMIvr3v82/dxAK8q4D1qb/h451vOV4+ExBm
         x8lMIudJoHgyiGmFX4z5ocS14FkexIPvF6dC2hBaT3yQWzjZ7GkLAtD0pqt8oJfvvn
         m/jiM14CTgX6Bu0iQ7U2WKrFgAtVWuVrAE4Xn/q6dMF1WjaT2U6PQeejOXD+Ujnroa
         OQVyV7LhAVDzw==
Date:   Wed, 11 Aug 2021 17:42:31 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Matthew Wilcox <willy@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the folio tree with the xfs tree
Message-ID: <20210811174231.688566de@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/zNL9098Oi9+eZ/2k2801XnW";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--Sig_/zNL9098Oi9+eZ/2k2801XnW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the folio tree got a conflict in:

  mm/util.c

between commit:

  de2860f46362 ("mm: Add kvrealloc()")

from the xfs tree and commit:

  3bc0556bade4 ("mm: Add folio_raw_mapping()")

from the folio tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc mm/util.c
index d06e48b28eec,e8fa30e48447..000000000000
--- a/mm/util.c
+++ b/mm/util.c
@@@ -660,31 -635,6 +660,21 @@@ void kvfree_sensitive(const void *addr
  }
  EXPORT_SYMBOL(kvfree_sensitive);
 =20
 +void *kvrealloc(const void *p, size_t oldsize, size_t newsize, gfp_t flag=
s)
 +{
 +	void *newp;
 +
 +	if (oldsize >=3D newsize)
 +		return (void *)p;
 +	newp =3D kvmalloc(newsize, flags);
 +	if (!newp)
 +		return NULL;
 +	memcpy(newp, p, oldsize);
 +	kvfree(p);
 +	return newp;
 +}
 +EXPORT_SYMBOL(kvrealloc);
 +
- static inline void *__page_rmapping(struct page *page)
- {
- 	unsigned long mapping;
-=20
- 	mapping =3D (unsigned long)page->mapping;
- 	mapping &=3D ~PAGE_MAPPING_FLAGS;
-=20
- 	return (void *)mapping;
- }
-=20
  /* Neutral page->mapping pointer to address_space or anon_vma or other */
  void *page_rmapping(struct page *page)
  {

--Sig_/zNL9098Oi9+eZ/2k2801XnW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmETf2cACgkQAVBC80lX
0GxrFgf+MD4GAinMH2jEgYSb4K0og6PMl6bskMP4zyoWcEKIrcfLoXgLZtAxw9bz
TbiWuXl+58ng3GRSR1N0hKuEVqfdwASJM4XG2dMhTMu9wYUVGmAbepxcLnmZRmaM
VElLjuw9357RVPZ0ZNWLVVoNWwgqclr2mX5HyRJ2ZJ+z2K5W1xeAK23wMDiganIh
lsBXTNdOZXXBWFNlYOpk3EO6qp+385Q3L/IFOnOT+K/KirbmCfIxqjz4faB3hZ89
Cd5EyVfANXLnPZoclWJFM1v8ZlsxMOT7HLMqFGPShrqLxYFaQr5OOGs/oZgWe3/u
7P+D2nEjaqUxY9wC86n5xVpXAv5EcQ==
=H4WB
-----END PGP SIGNATURE-----

--Sig_/zNL9098Oi9+eZ/2k2801XnW--

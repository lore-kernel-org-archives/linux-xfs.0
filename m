Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38206 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751615AbeETXI1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 20 May 2018 19:08:27 -0400
From: NeilBrown <neilb@suse.com>
Date: Mon, 21 May 2018 09:08:10 +1000
Subject: Re: [PATCH 00/13] convert block layer to bioset_init()/mempool_init()
In-Reply-To: <20180520222558.7053-1-kent.overstreet@gmail.com>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
Message-ID: <87603i0vtx.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, colyli@suse.de, snitzer@redhat.com, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Sun, May 20 2018, Kent Overstreet wrote:

> Jens - this series does the rest of the conversions that Christoph wanted, and
> drops bioset_create().
>
> Only lightly tested, but the changes are pretty mechanical. Based on your
> for-next tree.
>
> It's also in the for-jens branch at https://evilpiepirate.org/git/bcachefs.git
>
> Kent Overstreet (12):
>   block: convert bounce, q->bio_split to bioset_init()/mempool_init()
>   drbd: convert to bioset_init()/mempool_init()
>   pktcdvd: convert to bioset_init()/mempool_init()
>   lightnvm: convert to bioset_init()/mempool_init()
>   bcache: convert to bioset_init()/mempool_init()
>   md: convert to bioset_init()/mempool_init()

Hi Kent,
 this conversion looks really good, thanks for Ccing me on it.
 However as Shaohua Li is now the maintainer of md, it probably should
 have gone to him as well.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlsB/9sACgkQOeye3VZi
gbmQjhAAkneDkZDXwI4jufoLm+ksYkuZ2yPsJX7lxD0w3gtDRQNk3uTIQEjMYQe8
8c3IjqNrxPnmcPx5wA2UmVokicHc/hcbsPyy8xkDSiWruqTEUgFqxnMlIN3xWGu7
ioQOpIxtvPT6wpnHG7lQfX+H+ghXWL0r4kACmxNFvQ4M0dSNJDubudWCmfNhVgm1
LM1rRYF287B73sBgsxAF1ilbiDWagpFksHNleKn/svSD0GaS4jLZ1QfYcG+8TLeW
RrXmPswflBrF3v70hJWXkPD5Z7yXgJUkOISoRS3oi+f5mXEyN92zPqKVUkPp+pzR
sVE+I4FNP8uwnZiVIlw89LvC7XMj8FyKyzup+YlWH+PwHsyFDEWVnj2b1053AbHJ
lacklAZzdWrfpLR4adCfbzynD+zs3yvL1abqazfgKakZsMtyxf0hmBKA/lJ1i9Zg
za62CbJhCPCGn1SR5oZ85rYxI3rsLTIIckYB5q5idt/99EECGBcvl2aNFZBxvgKm
qHWW1dP2glR3Mhn7S1hEiDlpR02ruF8fdvUNK03ezFHJMMEPypN8IgPBFYVxegBK
O/CjRA5XOHJpKNTrU4EFqs4lCyoJMExyfE+dNxAKTZGne92v2c3tRpneQyeoyc5k
41Dy/JEMrFfR+nQZ7OKNd1opOO4hu69gE3cJHEHUBi0xAH4GKk4=
=6JdX
-----END PGP SIGNATURE-----
--=-=-=--

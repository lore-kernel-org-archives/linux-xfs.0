Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([203.11.71.1]:47459 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727373AbfGAPtu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Jul 2019 11:49:50 -0400
Date: Tue, 2 Jul 2019 01:49:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Adding some trees to linux-next?
Message-ID: <20190702014944.79bd326a@canb.auug.org.au>
In-Reply-To: <20190701153552.GJ1404256@magnolia>
References: <20190701110603.5abcbb2c@canb.auug.org.au>
        <20190701153552.GJ1404256@magnolia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/fev+fzqjHW.N7FIhhlClsrz"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

--Sig_/fev+fzqjHW.N7FIhhlClsrz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Darrick,

On Mon, 1 Jul 2019 08:35:52 -0700 "Darrick J. Wong" <darrick.wong@oracle.co=
m> wrote:
>
> Could you add my iomap-for-next and vfs-for-next branches to linux-next,
> please?  They can be found here:
>=20
> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git#iomap-for-next
> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git#vfs-for-next
>=20
> I've decided that trying to munge all that through the xfs for-next
> branch is too much insanity and splitting them up will help me prevent
> my head from falling off.

Added from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgement of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

--Sig_/fev+fzqjHW.N7FIhhlClsrz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0aK5gACgkQAVBC80lX
0GwmMQf8CnI5xnqYrX8x9t5LBtRJq5gPcLukCc+FjM8GkphUoE/T8Xa2yPMyxnGs
6vpp/nGVX+UyYmvOkRbRNZfnIWY9WlBaXAfxK+If2jHjJy34Dmdm/yTu4WWgcCZu
Ji+/GSpH02b9J/Zn4DuVYymLtVLEPFgaWEVjWxm5nbYMgwrq6b+wMKvn2ybPHuOU
IDNFkRv33y1XN1o6m/AiMNK1J0ywcAJX3D4/qkUz4lAReQTPCZmWjAHbEBAVkOaL
2tdJcV03DFORsoiIzxYqEX5Sict5+r4Dph2nw5ysVPJ8Mz8DrZrj8btjhGJcXUq8
G+me/aG3McL+Js3NfdbaE/J25d8VqQ==
=lykB
-----END PGP SIGNATURE-----

--Sig_/fev+fzqjHW.N7FIhhlClsrz--

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bilbo.ozlabs.org ([203.11.71.1]:51361 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387623AbfGPXhB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Jul 2019 19:37:01 -0400
Date: Wed, 17 Jul 2019 09:36:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the xfs tree with Linus' tree
Message-ID: <20190717093657.37a4186e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/1gVKxdAeql9+nyt7jnlkzFp"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Sheriff Esseson <sheriffesseson@gmail.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jonathan Corbet <corbet@lwn.net>

--Sig_/1gVKxdAeql9+nyt7jnlkzFp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xfs tree got a conflict in:

  Documentation/admin-guide/index.rst

between commit:

  66f2a122c68d ("docs: Move binderfs to admin-guide")

from Linus' tree and commit:

  89b408a68b9d ("Documentation: filesystem: Convert xfs.txt to ReST")

from the xfs tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.



--=20
Cheers,
Stephen Rothwell

--Sig_/1gVKxdAeql9+nyt7jnlkzFp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0uX5kACgkQAVBC80lX
0GwmHwf/Xk4ev3lF3dqRLCX46J22k80G1RUiw0cgtFgPzbwVxYU1xVIaQUq5fPQ8
Zp1n3XnXmKnVJyMmP/ie72i/YNdxCWZYIu6rUxjWF+8/5jq8vXqRRSG5Vwnp41Jb
xV4Y7K0LhG5hSfoCen+E9rkGhM9NJ4d/heLmZXvdz4v4AP8dt+zHGfHEarjv3egC
Vyly8WW0dlITKnNYsB1MqaF6rC6XyD/F81N9VhHVXkQ4VudHECBFZlmt/lDsIiTX
E/5B8P3rIIfYmUj4As2RRrOqnboJQ/l7gHmc82yPwHs+ATXFtLbntM8hoOiUdQQ9
+8zmrWtk1gzXEY6IfHvrXKR7BR9jpw==
=0zfE
-----END PGP SIGNATURE-----

--Sig_/1gVKxdAeql9+nyt7jnlkzFp--

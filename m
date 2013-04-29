Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5AA547F37
	for <xfs@oss.sgi.com>; Sun, 28 Apr 2013 20:29:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47E82304064
	for <xfs@oss.sgi.com>; Sun, 28 Apr 2013 18:29:50 -0700 (PDT)
Received: from members.tip.net.au (haggis.pcug.org.au [203.10.76.10]) by
	cuda.sgi.com with ESMTP id mHXV6cYXLXbGrwNS for
	<xfs@oss.sgi.com>; Sun, 28 Apr 2013 18:29:49 -0700 (PDT)
Date: Mon, 29 Apr 2013 11:29:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the xfs tree
Message-Id: <20130429112943.afdd088c7bb8d80046bdfd2f@canb.auug.org.au>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5782329162330705435=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>, David Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

--===============5782329162330705435==
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Apr_2013_11_29_43_+1000_9uakL3EUbfUXjLcr"

--Signature=_Mon__29_Apr_2013_11_29_43_+1000_9uakL3EUbfUXjLcr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the xfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: "xfs_dquot_buf_ops" [fs/xfs/xfs.ko] undefined!

Probably caused by commit 3fe58f30b4fc ("xfs: add CRC checks for quota
blocks").

I have used the xfs tree from next-20130426 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Apr_2013_11_29_43_+1000_9uakL3EUbfUXjLcr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRfc0HAAoJEECxmPOUX5FEHjgP/0TBlVxlC2wyZ+Blha5ODu/C
vUJumRVXIl75EOJ2EsEXs9XwiP1/Tkv7LSKanWveahtwQx16LVGbuSbK8zQTxrGT
ZYTN8MCML8nD7P659EDa/KOyo0dOx7kiqPX0MV0XIjsdTqnggOqIbeqjZemjmLlX
/dZhwCbeIj8sFGj5jW14itstm0DpzpgLnilESZe1EZEKGuZVyj7TteI5qjxUH4wo
4qtOWN4KEDStc9Ye9SEl+p2N/S3duSs42+IA4G3XEeib+PSOamgKGZXCqhmZ5Kq4
L6HmcuYsYHUNpbQ5SqGtEN8KWSC4ri89AhbXWr+qnwVqYIsOOjtJAnhHMXgtbXkN
tIg67qWdtYPuyp69I29gZE3scKtkUUfub8aOMmNPZaTSang6I9hwtKeMf53fsPKk
mLX9fCv1wYYX9ygeUnQxUWJu3a6nuP9pl2m3XB3Xc2uu8C/20zvH/PC5g9csBnwM
4xPjwedqm9ThKHXrfuNDHf9FdJngc+LD2b+POOb8L3WAT5nSjXG6GM5BbplGDjh5
BTM5rwYptwGb1SzUYEC31xRJPN6erzaH67uWSlA3tG9035WlxQhC/CAq9ukDSFmi
c0cZf9+dfuCIo6sUaW7LeeHv3FOwB36gowykobvos415jVhTgeLSor07V2vPgHGB
Tm4sADvntX2DxQX1YvO0
=shlP
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Apr_2013_11_29_43_+1000_9uakL3EUbfUXjLcr--


--===============5782329162330705435==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5782329162330705435==--

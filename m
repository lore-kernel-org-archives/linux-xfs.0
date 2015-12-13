Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F07287CBF
	for <xfs@oss.sgi.com>; Sat, 12 Dec 2015 18:28:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 82206AC001
	for <xfs@oss.sgi.com>; Sat, 12 Dec 2015 16:27:59 -0800 (PST)
Received: from shadbolt.e.decadent.org.uk (shadbolt.e.decadent.org.uk
	[88.96.1.126]) by cuda.sgi.com with ESMTP id IL85WFCbb2ttMC3F
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Dec 2015 16:27:52 -0800 (PST)
Message-ID: <1449966459.3836.46.camel@decadent.org.uk>
Subject: [3.16] xfs: allow inode allocations in post-growfs disk space
From: Ben Hutchings <ben@decadent.org.uk>
Date: Sun, 13 Dec 2015 00:27:39 +0000
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1988182896793579417=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Eric Sandeen <sandeen@redhat.com>, 802885@bugs.debian.org, stable <stable@vger.kernel.org>, xfs@oss.sgi.com


--===============1988182896793579417==
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-miV9q4ob6pCNxpnkjNAL"


--=-miV9q4ob6pCNxpnkjNAL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Per the FAQ at
<http://xfs.org/index.php/XFS_FAQ#Q:_Why_do_I_receive_No_space_left_on_devi=
ce_after_xfs_growfs.3F>,
I think the following commit should be cherry-picked for 3.16-ckt:

commit 9de67c3ba9ea961ba420573d56479d09d33a7587
Author: Eric Sandeen <sandeen@redhat.com>
Date:=C2=A0=C2=A0=C2=A0Thu Jul 24 20:51:54 2014 +1000

=C2=A0=C2=A0=C2=A0=C2=A0xfs: allow inode allocations in post-growfs disk sp=
ace

Ben.

--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.

--=-miV9q4ob6pCNxpnkjNAL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVmy7e+e/yOyVhhEJAQq96g//bzkVOMwzGlk8/LpADNx5GwmlS42E4rSB
qtsTUUSMfqg7AXGSipTw23DwTS4Ckdprnl1GU8xoAZDmF9o58saYHpTKuqto2z0F
BAKLzm5kiz1iHpX0TllLH+is/QA2mONmzElFEG6FI4C7oUYEIFRo8uTzk46j/Yim
XhS1gZn2zfwhx4nnO3sUnt4Ad+2YZ7CCCGd7UtJUP9NjF8sqnV6/wcW5/n4EwAd9
NIPp3sekeJE6dbkbqnVK141MmkX+oLxl90ScEmlFmfSNZaRnn3tl7qVtAIMvC7qY
7QkdDAu4IhMgm3fRui23sR6Zef3b6IzS5v0pC8EByLMJT5CHQO78WkFTAGHnQdAz
VCzxwhdlyKXdkGJG0RvCcEbF68B4d6gIXk4PG3KzAJNMxNUDhUKF8+yYfsMunkoA
akrIdiQBp1GfAOtjYFdxcEs+HQ3PQnn0xX5ZZYPc5sNWvl+hf6rHv37+buxz+4HN
o2RcTD+JX/z154Vy4drYXUTeIF2Y+iXbVKXXxzvp5wDvSIdE9o8itOstAXhCLqFB
hYhHgUrSHm7LqtznLudN1zPezJGGDfkrklLus1GG4pVzTad7KCVKlEdIMPAUk5hG
rbgrLQ/CSBjOD4RJHs+o9nfPEFj3PvS+dbCzeO3m7v4Fcc6G7+seSfRkAgBnnc2m
TSCxExaUbEY=
=+lqP
-----END PGP SIGNATURE-----

--=-miV9q4ob6pCNxpnkjNAL--


--===============1988182896793579417==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1988182896793579417==--

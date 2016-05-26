Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1CE5C7CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 08:36:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E3D1F8F8040
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 06:36:32 -0700 (PDT)
Received: from mail.somenet.org (mail.somenet.org [213.143.98.34]) by
	cuda.sgi.com with ESMTP id TML5B9dvy4e1CnBv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 06:36:29 -0700 (PDT)
From: Jan Vales <jan@jvales.net>
Subject: remounting with "errors=remount-ro" in fstab fails.
Message-ID: <5746FBD1.8010605@jvales.net>
Date: Thu, 26 May 2016 15:36:17 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4997313189950135553=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============4997313189950135553==
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="S9j1RGFGSVNxIFkOF1okEiCxgBDxWOOnq"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--S9j1RGFGSVNxIFkOF1okEiCxgBDxWOOnq
Content-Type: multipart/mixed; boundary="t4LI3b4j0CJtqGlOt2GXxSf779nMQfovr"
From: Jan Vales <jan@jvales.net>
To: xfs@oss.sgi.com
Message-ID: <5746FBD1.8010605@jvales.net>
Subject: remounting with "errors=remount-ro" in fstab fails.

--t4LI3b4j0CJtqGlOt2GXxSf779nMQfovr
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi there,

I just updated to 4.6 kernel, and now i cannot remount / rw anymore.

root@... # mount / -o remount,rw
mount: / not mounted or bad option

root@... # dmesg
[...]
XFS (md2): unknown mount option [errors=3Dremount-ro].
[...]

root@... # cat /etc/fstab
[...]
/dev/sda / xfs ro,noatime,logbufs=3D8,errors=3Dremount-ro,inode64 0 1
[...]

Was that change intentional?
As in: shall i remove errors=3D... from fstab or is it a mistake?

cheers,
Jan Vales
--
I only read plaintext emails.

Someone @ irc://irc.fsinf.at:6667/tuwien
webIRC: https://frost.fsinf.at/iris/


--t4LI3b4j0CJtqGlOt2GXxSf779nMQfovr--

--S9j1RGFGSVNxIFkOF1okEiCxgBDxWOOnq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXRvvXAAoJEERD22thjA7q0WIQAL07J2iITAuS4qB14JtWQoRI
zDv4bZG7MJQxXwPdqUqPPxjpQTM9NZ0RwC51WpxHF27NMucPZ3vtx1BFsR93v0vx
TlosC0EUSZsg+9IiuCtWDD8/CKLNNr8OXzgqlFr188Jiu7N1pTAaPzUC/s6/zeX7
fVsyoK0E0ptuRWtQeLJQUZV37/GmeObsudgmHJXOOMfWtOLj2w/7B/TPM2+e+QPN
irWbsyZDKvLBjq94cO+n7vWNXUs6swRMmdE4+JIrfGDwnZC6+sSv42m+6M4o5RLe
I99Gxt1uUEia8NwpvW4t41wsSyOi05J0LVQDo17V20oF0HalxpM0iReMR/L3O4Ln
ES7xwyHO6TLby/+8ZZwQdwCoF9WzUjjJS88A+PpjdIg+q0i0Dw0IKeAk/09AJyIw
oXdv5vIEZWXoUcXf3PiR8Jizyese54dhghHGGciyB+mLIHYZfqHE+hQZnIITI5XG
+ngspgF8bk1Dw9DWU7FuP/yzRDovX0UB8ygXVOMQcy79HVl/YcesXhjylAfpW5sS
O6XZpJznFDKPG/UCGH5ipxUp0qfJX1TAWfKO5j6ayIauN+k9LLB4yTNu8WNJBCkA
annTGrzkbsNHTv5U3EKF3nVd9YCJ5vLA9v+CMFfDk3VY0WqK1ozh+8G9bHRvKU35
05GFumcnQxY4Bit1TOB6
=9XlR
-----END PGP SIGNATURE-----

--S9j1RGFGSVNxIFkOF1okEiCxgBDxWOOnq--


--===============4997313189950135553==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4997313189950135553==--

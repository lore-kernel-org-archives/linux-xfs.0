Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4BK09qt117619
	for <linux-xfs@oss.sgi.com>; Fri, 11 May 2012 15:00:09 -0500
Received: from smtp-3.hut.fi (smtp-3.hut.fi [130.233.228.93]) by cuda.sgi.com
	with ESMTP id VT5ZTjneWXDhQFHI (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Fri, 11 May 2012 13:00:06 -0700 (PDT)
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-3.hut.fi (8.13.6/8.12.10) with ESMTP id q4BK04ia019886
	for <linux-xfs@oss.sgi.com>; Fri, 11 May 2012 23:00:04 +0300
Received: from smtp-3.hut.fi ([130.233.228.93])
	by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new,
	port 10024) with LMTP id 14291-761 for <linux-xfs@oss.sgi.com>;
	Fri, 11 May 2012 23:00:03 +0300 (EEST)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-3.hut.fi (8.13.6/8.12.10) with ESMTP id q4BJxx6g019883
	for <linux-xfs@oss.sgi.com>; Fri, 11 May 2012 22:59:59 +0300
Date: Fri, 11 May 2012 22:59:58 +0300
From: Sami Liedes <sami.liedes@iki.fi>
Subject: XFS (dm-5): xfs_swap_extents: inode 0x35dbd267 format is
	incompatible for exchanging.
Message-ID: <20120511195958.GA7387@sli.dy.fi>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3136658793539830169=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com


--===============3136658793539830169==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I got this warning in dmesg, presumably while running xfs_fsr on the
filesystem, on kernel 3.3.5:

XFS (dm-5): xfs_swap_extents: inode 0x35dbd267 format is incompatible for exchanging.

The filesystem is new, created this week. find -xdev -inum 903598695
doesn't find any file with such an inode number.

	Sami

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPrW+9AAoJEKLT589SE0a0zCwP/2sYTUpm8RaumkVMgyx9UsYN
xzovr+lv1OLaG4Acz9qeURVfecBiD/yLbqfXPPlx3BQ/fX7Ny47Q9IVAbJZ5LPKJ
RxNLHDuEkbe/tTkVo/UQ4+J8BuZ+g3aG+infTRAtWzwAhP2qeszz+/2dWco4g6NN
S2Q67aKR3GIPxH6hS+byeQ+X2s9VZKU+eqldrN0ll2FnyKQC2nzaUl0JrOGc9cLL
4iMKep0h3sKGKNZEDKjFVcQjK+6JASVThNagUYvajJ5klJLigEnWqkMx8T7kEi7y
TH179cYN82E7YbaKQmZe/w38CZyW54f3c0kxt24aJjeGvNX8Fslcy3cBxGVvMLaD
s9nR711fjQCSW32bGKvJggd3ohfKk4Th6idyagZN/j9/sJtOJb9zXXINnJ79mPiT
jBgMIZZfw5e3y8+rg7uOdAAXu04tni5cYn77Sgy6GD31wxfFCw26lK/qpokFZ7En
NPTa+oEpeRq13iyRomJs3hHMXqiA/KCymHnJV6Sbowsi764177tLM9eVtjGoDXrm
YCk0ysTSpWz2Nfu6RlI2YezrjYBYQFRaWoEtthPHYqoTNG0NGt5qkusySPP490QL
0AhOSNu8vcHVXjKXLhGC3RD+7SodGJbPXUF1MP5K/mGTXAAMrTKlbCk2AYVEws6X
4ok+cE6u8r2oD7K0URI0
=BKqU
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--


--===============3136658793539830169==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3136658793539830169==--

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C74527CA0
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2016 04:44:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9863C304032
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2016 02:44:17 -0700 (PDT)
Received: from mail-lf0-f68.google.com (mail-lf0-f68.google.com
	[209.85.215.68]) by cuda.sgi.com with ESMTP id NZeWjvLGUvyczaDr
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Aug 2016 02:44:14 -0700 (PDT)
Received: by mail-lf0-f68.google.com with SMTP id l89so2850351lfi.2
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2016 02:44:14 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] PING...  mkfs.xfs: fix static-lib build 
In-Reply-To: <1470907976-2362-1-git-send-email-dmonakhov@openvz.org>
References: <1470907976-2362-1-git-send-email-dmonakhov@openvz.org>
Date: Fri, 19 Aug 2016 12:44:07 +0300
Message-ID: <87bn0p6ql4.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: billodo@redhat.com

--=-=-=
Content-Type: text/plain


I'm just want to double check that this list is still alive, and
not yet moved some where XXX-xfs@kernel.org  :)
Fellows, please take a look at the patch. This fix static build for
mkfs.xfs and break xfstests-bld build.


--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> Order is important for static libraries, libblkid depends on libuuid.
> We have to pass libuuid after libblkid, otherwise it fails like this:
> #make mkfs.xfs
>     [LD]     mkfs.xfs
>     /bin/bash ../libtool --quiet --tag=3DCC --mode=3Dlink gcc -o mkfs.xfs=
 -static -L/devel/xfstests-bld.git/bld/lib -static-libtool-libs  maxtrres.o=
 proto.o xfs_mkfs.o   ../libxfs/libxfs.la ../libxcmd/libxcmd.la -luuid -lrt=
 -lpthread -lblkid
>     /devel/xfstests-bld.git/bld/lib/libblkid.a(probe.o): In function `set=
_uuid':
>     /devel/xfstests-bld.git/e2fsprogs-libs/lib/blkid/probe.c:132: undefin=
ed reference to `uuid_is_null'
>     /devel/xfstests-bld.git/e2fsprogs-libs/lib/blkid/probe.c:133: undefin=
ed reference to `uuid_unparse'
>     /devel/xfstests-bld.git/bld/lib/libblkid.a(probe.o): In function `get=
_ext2_info':
>     /devel/xfstests-bld.git/e2fsprogs-libs/lib/blkid/probe.c:156: undefin=
ed reference to `uuid_is_null'
>     collect2: error: ld returned 1 exit status
>     ../include/buildrules:45: recipe for target 'mkfs.xfs' failed
>     make: *** [mkfs.xfs] Error 1
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  mkfs/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index 170e3c1..c13b903 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -10,7 +10,7 @@ LTCOMMAND =3D mkfs.xfs
>  HFILES =3D
>  CFILES =3D maxtrres.c proto.c xfs_mkfs.c
>=20=20
> -LLDLIBS +=3D $(LIBXFS) $(LIBXCMD) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) $(LI=
BBLKID)
> +LLDLIBS +=3D $(LIBXFS) $(LIBXCMD) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) $(L=
IBUUID)
>  LTDEPENDENCIES +=3D $(LIBXFS) $(LIBXCMD)
>  LLDFLAGS =3D -static-libtool-libs
>=20=20
> --=20
> 2.1.4

--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCgAGBQJXttTnAAoJELhyPTmIL6kBvQkH/0n3NAHetnJwcf50DUPQx8u6
4YdN6iO2VE3npZ76+T+qHmiR5sCYDVjS7dUlc5OgRrdb77mrlNYVBsv9B0qkbq3g
y9uqv5czcRfezSIBF+t+ZOCpsdR0M0mTUbIEYPM07GckS1pX8X00YQ5br30O3Cxq
8Yhp3gdWOCydrU3XGz7hkNTQbXzxrdMEQ8cXe7aGf7bLNGwP1zE2+8n8o/DYO9Sw
OXDsH5/kyqO2tHkcuStcu+EuWHuhdqmRDpMCLGhoaoIJGqJonQTumb6z3XYPTot2
m9UT+HXUSfoiTryL0DDy7HAKvoxvNJtgr8dPOEwrdxcHRGWW+J9c2RuoQp3ypYk=
=KS8U
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=-=-=--

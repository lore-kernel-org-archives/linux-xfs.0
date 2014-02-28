Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 59F7B7F3F
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 13:09:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 19B638F804C
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 11:09:12 -0800 (PST)
Received: from mail-pa0-f51.google.com (mail-pa0-f51.google.com
	[209.85.220.51]) by cuda.sgi.com with ESMTP id boNC0mwGQqzXzBNK
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 28 Feb 2014 11:09:11 -0800 (PST)
Received: by mail-pa0-f51.google.com with SMTP id kq14so1142463pab.24
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 11:09:11 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH 7/8] xfstests: Add fallocate zero range operation to fsx
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1393603865-26198-7-git-send-email-lczerner@redhat.com>
Date: Fri, 28 Feb 2014 12:08:47 -0700
Message-Id: <CB2787E8-CE9B-46BE-B649-4E38ABE27C2B@dilger.ca>
References: <1393603865-26198-1-git-send-email-lczerner@redhat.com>
	<1393603865-26198-7-git-send-email-lczerner@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6913547480573046926=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com


--===============6913547480573046926==
Content-Type: multipart/signed; boundary="Apple-Mail=_184D3A06-C043-4EEB-A918-C4941EF7584D"; protocol="application/pgp-signature"; micalg=pgp-sha1


--Apple-Mail=_184D3A06-C043-4EEB-A918-C4941EF7584D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 28, 2014, at 9:11 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> This commit adds fallocate FALLOC_FL_ZERO_RANGE support for fsx.

It looks like this patch breaks the option handling for these
fallocate features.

>  int     fallocate_calls =3D 1;            /* -F flag disables */
>  int     punch_hole_calls =3D 1;           /* -H flag disables */
> +int     zero_range_calls =3D 1;           /* -z flag disables */

So these fallocate tests are on by default...

> =08+int
> +test_fallocate(int mode)
>  {
>  #ifdef HAVE_LINUX_FALLOC_H
> +	int ret =3D 0;
> 	if (!lite && fallocate_calls) {
> +		if (fallocate(fd, mode, 0, 1) && errno =3D=3D =
EOPNOTSUPP) {
> 			if(!quiet)
> 				warn("main: filesystem does not support =
fallocate, disabling\n");
> 		} else {
> +			ret =3D 1;
> 			ftruncate(fd, 0);
> 		}
> 	}
> #endif
> }

And this returns 1 or 0 depending if they are supported or not...

> +	while ((ch =3D getopt(argc, argv, =
"b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHzLN:OP:RS:WZ"))
> 	       !=3D EOF)
> 		switch (ch) {
> 		case 'H':
> 			punch_hole_calls =3D 0;
> 			break;
> +		case 'z':
> +			zero_range_calls =3D 0;
> +			break;

And the option parsing sets the values to zero if they are disabled,
so far, so good...

> +	fallocate_calls =3D test_fallocate(0);
> +	punch_hole_calls =3D test_fallocate(FALLOC_FL_PUNCH_HOLE | =
FALLOC_FL_KEEP_SIZE);
> +	zero_range_calls =3D test_fallocate(FALLOC_FL_ZERO_RANGE);

But here, the values set by option parsing are clobbered and the
tests are only enabled or disabled depending on whether the kernel
supports that feature or not.  I think you need something like:

        if (fallocate_calls)
                fallocate_calls =3D test_fallocate(0);
        if (punch_hole_calls)
                punch_hole_calls =3D test_fallocate(FALLOC_FL_PUNCH_HOLE =
|
                                                  FALLOC_FL_KEEP_SIZE);
        if (zero_range_calls)
                zero_range_calls =3D =
test_fallocate(FALLOC_FL_ZERO_RANGE);

Cheers, Andreas






--Apple-Mail=_184D3A06-C043-4EEB-A918-C4941EF7584D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUxDewHKl2rkXzB/gAQI2Uw//f2roFEJGCHU3cO625PeeOYrLgD2j5j7Y
MV/ygwjDWl8H/tDhzMIijTW40X59SNDh+xj3ZnLOGokd7QDQToifTt9Jumpbek5T
sCRsxU96yysrZXOf59nDvPj1HsEXn/GeXCcDBqz5D0sq0sC8+WspY77xvjtY0M08
9RH0tHtTbPzH5uw/Fja4UINBvXMjlnrc2p9jAYZGKUv7PqrnANS19QCPVuetn9Qk
EHnn6pIRe746j13kdCdgvp7Nk6vR9bM6Vc6N2C613MGXt5vmathwD6fj5gFzUjC/
x538x+Rh/Uhh34TaMP8P6gxN+41SGqv3cNU89xzzZQD1YyBUYzf+9AZT+O7zL1iU
xTQrivY8HNp+rdp9vAxaiZnmcQlxU7ZOYqpKZXjiQIlRKNV99iutwBITP6jiurtL
Gdt0K/YwQQE7om1UXm2gw29Y/LYuHrES+6I3kuuJ7oMJefM/RxfVZ9//YFoQhyMV
nSEQsHHIJhhDRTjXExutiH9GhsLGQjyuTYIBfNYMyJjyKasDhFca5VY0EjDMUIkO
kR4Bv6aRFwqNvekekBVrQHp2QZ+8M9oGPHSWr6yjqijlOPS0mJDROdyJmM59Va2m
2CU47YXNj4qvVQiKdZgn+N0+jlh925zVrtwBSNOsGeAthWeS4rmUR4SW2Cfw7oaU
x46Ftn3PJkU=
=0yxr
-----END PGP SIGNATURE-----

--Apple-Mail=_184D3A06-C043-4EEB-A918-C4941EF7584D--


--===============6913547480573046926==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6913547480573046926==--

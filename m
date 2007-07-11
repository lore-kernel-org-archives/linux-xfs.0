Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jul 2007 19:35:47 -0700 (PDT)
Received: from smtps.tip.net.au (chilli.pcug.org.au [203.10.76.44])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6B2Zfbm026915
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2007 19:35:43 -0700
Date: Wed, 11 Jul 2007 12:10:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 2/7] fallocate() implementation in i386, x86_64 and
 powerpc
Message-Id: <20070711121034.a3b925b9.sfr@canb.auug.org.au>
In-Reply-To: <20070710202000.GB8797@amitarora.in.ibm.com>
References: <20070710201200.GA10255@amitarora.in.ibm.com>
	<20070710202000.GB8797@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_Jul_2007_12_10_34_+1000_5U2tHjshZm6024bl"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

--Signature=_Wed__11_Jul_2007_12_10_34_+1000_5U2tHjshZm6024bl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Jul 2007 01:50:00 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.c=
om> wrote:
>
> --- linux-2.6.22.orig/arch/x86_64/ia32/sys_ia32.c
> +++ linux-2.6.22/arch/x86_64/ia32/sys_ia32.c
> @@ -879,3 +879,11 @@ asmlinkage long sys32_fadvise64(int fd,=20
>  	return sys_fadvise64_64(fd, ((u64)offset_hi << 32) | offset_lo,
>  				len, advice);
>  }
> +
> +asmlinkage long sys32_fallocate(int fd, int mode, unsigned offset_lo,
> +				unsigned offset_hi, unsigned len_lo,
> +				unsigned len_hi)

Please call this compat_sys_fallocate in line with the powerpc version -
it gives us a hint that maybe we should think about how to consolidate
them.  I know other stuff in that file is called sys32_ ... but it is time
for a change :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__11_Jul_2007_12_10_34_+1000_5U2tHjshZm6024bl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGlDweTgG2atn1QN8RAsMWAJ0QGe/B34/KjrV593lYeDo/VsOYdQCfdMkc
mHS8nJDyRZd1RWYTVZ+6888=
=C6vS
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Jul_2007_12_10_34_+1000_5U2tHjshZm6024bl--

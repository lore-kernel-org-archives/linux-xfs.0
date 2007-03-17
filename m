Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Mar 2007 23:03:49 -0700 (PDT)
Received: from smtps.tip.net.au (chilli.pcug.org.au [203.10.76.44])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2H63d6p020297
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 23:03:40 -0700
Date: Sat, 17 Mar 2007 16:33:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Message-Id: <20070317163350.6b676c26.sfr@canb.auug.org.au>
In-Reply-To: <20070316143101.GA10152@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	<20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
	<20070316143101.GA10152@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__17_Mar_2007_16_33_50_+1100_RDGr9JcpHSSG4wvw"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com

--Signature=_Sat__17_Mar_2007_16_33_50_+1100_RDGr9JcpHSSG4wvw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Fri, 16 Mar 2007 20:01:01 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
>

> +asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
>
> --- linux-2.6.20.1.orig/include/asm-powerpc/systbl.h
> +++ linux-2.6.20.1/include/asm-powerpc/systbl.h
> @@ -305,3 +305,4 @@ SYSCALL_SPU(faccessat)
>  COMPAT_SYS_SPU(get_robust_list)
>  COMPAT_SYS_SPU(set_robust_list)
>  COMPAT_SYS(move_pages)
> +SYSCALL(fallocate)

It is going to need to be a COMPAT_SYS call in powerpc because 32 bit
powerpc will pass the two loff_t's in pairs of registers while
64bit passes them in one register each.

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__17_Mar_2007_16_33_50_+1100_RDGr9JcpHSSG4wvw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF+33HFdBgD/zoJvwRAsUAAJ4lt3jRPS6CE09R0kbH9uY2YBf1CwCcC71K
ciATEa4iyLt7aSVc9IaUZ6w=
=4vjD
-----END PGP SIGNATURE-----

--Signature=_Sat__17_Mar_2007_16_33_50_+1100_RDGr9JcpHSSG4wvw--

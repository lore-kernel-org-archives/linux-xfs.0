Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 May 2007 17:12:39 -0700 (PDT)
Received: from smtps.tip.net.au (chilli.pcug.org.au [203.10.76.44])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4F0CYfB022809
	for <xfs@oss.sgi.com>; Mon, 14 May 2007 17:12:35 -0700
Date: Tue, 15 May 2007 09:44:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/5][TAKE2] fallocate() implementation on i86, x86_64
 and powerpc
Message-Id: <20070515094436.d441098f.sfr@canb.auug.org.au>
In-Reply-To: <20070514144524.GA31748@amitarora.in.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org>
	<20070330071417.GI355@devserv.devel.redhat.com>
	<20070417125514.GA7574@amitarora.in.ibm.com>
	<20070418130600.GW5967@schatzie.adilger.int>
	<20070420135146.GA21352@amitarora.in.ibm.com>
	<20070420145918.GY355@devserv.devel.redhat.com>
	<20070424121632.GA10136@amitarora.in.ibm.com>
	<20070426175056.GA25321@amitarora.in.ibm.com>
	<20070514132926.GA30768@amitarora.in.ibm.com>
	<20070514142820.GA31468@amitarora.in.ibm.com>
	<20070514144524.GA31748@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_May_2007_09_44_36_+1000_FmQQEkgMAA8ZAwtk"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

--Signature=_Tue__15_May_2007_09_44_36_+1000_FmQQEkgMAA8ZAwtk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Mon, 14 May 2007 20:15:24 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
>
> This patch implements sys_fallocate() and adds support on i386, x86_64
> and powerpc platforms.

This patch no longer applies to Linus' tree - for a start there is no file
arch/x86_64/kernel/functionlist any more.

Can you rebase it, please?

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__15_May_2007_09_44_36_+1000_FmQQEkgMAA8ZAwtk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGSPRpFdBgD/zoJvwRAuHCAJsEB8TyYfKxqEtWnHM7smTPNqRiPwCfYj2B
kUd5qmBLOd+TYg003bKAuVw=
=ap96
-----END PGP SIGNATURE-----

--Signature=_Tue__15_May_2007_09_44_36_+1000_FmQQEkgMAA8ZAwtk--

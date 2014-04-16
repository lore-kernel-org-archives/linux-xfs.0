Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5B88D7F63
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 01:22:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 38DD78F8039
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 23:22:12 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id bYVsUrq0Txm95hsh (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 23:22:11 -0700 (PDT)
Date: Wed, 16 Apr 2014 16:22:01 +1000
From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 13/19] MM: set PF_FSTRANS while allocating per-cpu
	memory to avoid deadlock.
Message-ID: <20140416162201.5dc9ff5c@notabene.brown>
In-Reply-To: <20140416054942.GD15995@dastard>
References: <20140416033623.10604.69237.stgit@notabene.brown>
	<20140416040336.10604.67456.stgit@notabene.brown>
	<20140416054942.GD15995@dastard>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4008412213747970137=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

--===============4008412213747970137==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TpJzKIhGobsDEwUger9I.iQ"; protocol="application/pgp-signature"

--Sig_/TpJzKIhGobsDEwUger9I.iQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Apr 2014 15:49:42 +1000 Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Apr 16, 2014 at 02:03:36PM +1000, NeilBrown wrote:
> > lockdep reports a locking chain
> >=20
> >   sk_lock-AF_INET --> rtnl_mutex --> pcpu_alloc_mutex
> >=20
> > As sk_lock may be needed to reclaim memory, allowing that
> > reclaim while pcu_alloc_mutex is held can lead to deadlock.
> > So set PF_FSTRANS while it is help to avoid the FS reclaim.
> >=20
> > pcpu_alloc_mutex can be taken when rtnl_mutex is held:
> >=20
> >     [<ffffffff8117f979>] pcpu_alloc+0x49/0x960
> >     [<ffffffff8118029b>] __alloc_percpu+0xb/0x10
> >     [<ffffffff8193b9f7>] loopback_dev_init+0x17/0x60
> >     [<ffffffff81aaf30c>] register_netdevice+0xec/0x550
> >     [<ffffffff81aaf785>] register_netdev+0x15/0x30
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> This looks like a workaround to avoid passing a gfp mask around to
> describe the context in which the allocation is taking place.
> Whether or not that's the right solution, I can't say, but spreading
> this "we can turn off all reclaim of filesystem objects" mechanism
> all around the kernel doesn't sit well with me...

We are (effectively) passing a gfp mask around, except that it lives in
'current' rather than lots of other places.
I actually like the idea of discarding PF_MEMALLOC, PF_FSTRANS and
PF_MEMALLOC_NOIO, and just having current->gfp_allowed_mask (to match the
global variable of the same name).

>=20
> And, again, PF_FSTRANS looks plainly wrong in this code - it sure
> isn't a fs transaction context we are worried about here...

So would PF_MEMALLOC_NOFS work for you?

NeilBrown


--Sig_/TpJzKIhGobsDEwUger9I.iQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU04hijnsnt1WYoG5AQKhaw//Yc1D4fJSwJa8YNO+4NafUYk50u9cMoRi
WQjcopF1cKZmSifPbH/r5M3SKqOKf4kQklPb1pccCc6Nw2oPCD98rrpu2dePn6NM
9FaxI6xOkkT0z7VpDjeP4VA1C7ekhxqqDGOLi1ezu0aWmqu4sBsHxGAojmA8y7IX
A+VHECsFBgrz4sjLqfV0U/jml9sfGNoutZVzftRHpZJXCn1+vzMHKKp+6TdlriUZ
anJHOj+URUenE6hv6/4JDkSAb0F0awvjyjXvblLMzvLWagF9KpGwMPP94fxOp+kI
si2uP7CtQkhACfBPxhmuUXXB2k0Ueb20GIzguqGMp9Qj+mToGqcyBqmaBaP4NxKr
x+jKgmq5l7OfJO2ERlBD+j/AnKKGZXeGyxh7ed2DhYR03nc2f6Lx6sMKzXlUrOc6
a5GzSslT1EA/fmEPJ/D1oyoVnSXuPYGGC91DuDzV4SP13w6xdQoqMsShs+RxIKUr
dRsfkuuDw3Euef4VE6y0G7Ird/kmS1pvLN/A4ZqRVmpgKAHD8wPJiPKd6TqgAUfX
tq4usUTitBM1NRqHxagj+/MksyqC1sNZv0F8xlsicqM0/ygslKSUq6vpJlVLjk68
43QZbKAAQIkXaZ/yxOvYKPrUOUejOQGUbrjIuISGcu8M78KKxaIXSxCnLlYwsomj
YJ9hOBTRuiE=
=Ofmb
-----END PGP SIGNATURE-----

--Sig_/TpJzKIhGobsDEwUger9I.iQ--


--===============4008412213747970137==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4008412213747970137==--

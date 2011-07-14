Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6EBNSDA132080 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 06:23:28 -0500
Received: from arianus.sliepen.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1402C15F42B3
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 04:23:26 -0700 (PDT)
Received: from arianus.sliepen.org (arianus.sliepen.org [92.243.30.131]) by
	cuda.sgi.com with ESMTP id zHO3X8MNIes88jCq for
	<xfs@oss.sgi.com>; Thu, 14 Jul 2011 04:23:26 -0700 (PDT)
Date: Thu, 14 Jul 2011 13:23:24 +0200
From: Guus Sliepen <Guus.Sliepen@astro.su.se>
Subject: Re: BUG: soft lockup - is this XFS problem?
Message-ID: <20110714112324.GM30145@sliepen.org>
References: <20090105064838.GA5209@wotan.suse.de>
MIME-Version: 1.0
In-Reply-To: <20090105064838.GA5209@wotan.suse.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5428332539705186350=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Peter Klotz <peter.klotz@aon.at>, linux-kernel@vger.kernel.org, Roman Kononov <kernel@kononov.ftml.net>, xfs@oss.sgi.com


--===============5428332539705186350==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LG0Ll82vYr46+VA1"
Content-Disposition: inline


--LG0Ll82vYr46+VA1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I'm having a problem with a system having an XFS filesystem on RAID locking=
 up
fairly consistently when writing large amounts of data to it, with several
kernels, including 2.6.38.2 and 2.6.39.3, on both AMD and Intel multi-core
processors. The kernel always logs this several times:

BUG: soft lockup - CPU#2 stuck for 67s! [kswapd0:33]

With different CPU# numbers, but always in kswapd0. Eventually the system w=
ill
really lock up, requiring a reset. During soft lockups (when file transfer
apparently stalled), merely typing "ps aux" would often cause the lockup to=
 end
immediately. After googling I found this page:

https://patchwork.kernel.org/patch/789/

An unpatched vanilla 2.6.39.3 consistently locked up, however after patchin=
g it
(adding a barrier() after all 4 instances of if
(!page_cache_get_speculative(page))) the lockups never happened anymore, and
file transfer has been steady.

I also tested it with ext4, which doesn't give lockups on unpatched kernels,
but unfortunately mkfs.ext4 cannot create filesystems larger than 16TB yet,=
 so
I have to use XFS instead.

On Mon, Jan 05, 2009 at 06:48:38AM -0000, Nick Piggin wrote:

> I believe this patch should solve it. Please test and confirm before
> I send it upstream.

Further comments on that thread in 2009 indicated the patch was very useful,
but it doesn't seem to have been applied upstream. Is there any reason this
patch should not be applied?

If necessary I can submit a reworked patch for 2.6.39.3 or 3.0 when that co=
mes
out.

> ---
> An XFS workload showed up a bug in the lockless pagecache patch. Basicall=
y it
> would go into an "infinite" loop, although it would sometimes be able to =
break
> out of the loop! The reason is a missing compiler barrier in the "increme=
nt
> reference count unless it was zero" case of the lockless pagecache protoc=
ol in
> the gang lookup functions.
>=20
> This would cause the compiler to use a cached value of struct page pointe=
r to
> retry the operation with, rather than reload it. So the page might have b=
een
> removed from pagecache and freed (refcount=3D=3D0) but the lookup would n=
ot correctly
> notice the page is no longer in pagecache, and keep attempting to increme=
nt the
> refcount and failing, until the page gets reallocated for something else.=
 This
> isn't a data corruption because the condition will be detected if the pag=
e has
> been reallocated. However it can result in a lockup.=20
>=20
> Add a the required compiler barrier and comment to fix this.
[...]
> Index: linux-2.6/mm/filemap.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/mm/filemap.c	2009-01-05 17:22:57.000000000 +1100
> +++ linux-2.6/mm/filemap.c	2009-01-05 17:28:40.000000000 +1100
> @@ -794,8 +794,19 @@ repeat:
>  		if (unlikely(page =3D=3D RADIX_TREE_RETRY))
>  			goto restart;
> =20
> -		if (!page_cache_get_speculative(page))
> +		if (!page_cache_get_speculative(page)) {
> +			/*
> +			 * A failed page_cache_get_speculative operation does
> +			 * not imply any barriers (Documentation/atomic_ops.txt),
> +			 * and as such, we must force the compiler to deref the
> +			 * radix-tree slot again rather than using the cached
> +			 * value (because we need to give up if the page has been
> +			 * removed from the radix-tree, rather than looping until
> +			 * it gets reused for something else).
> +			 */
> +			barrier();
>  			goto repeat;
> +		}
> =20
>  		/* Has the page moved? */
>  		if (unlikely(page !=3D *((void **)pages[i]))) {
> @@ -850,8 +861,11 @@ repeat:
>  		if (page->mapping =3D=3D NULL || page->index !=3D index)
>  			break;
> =20
> -		if (!page_cache_get_speculative(page))
> +		if (!page_cache_get_speculative(page)) {
> +			/* barrier: see find_get_pages() */
> +			barrier();
>  			goto repeat;
> +		}
> =20
>  		/* Has the page moved? */
>  		if (unlikely(page !=3D *((void **)pages[i]))) {
> @@ -904,8 +918,11 @@ repeat:
>  		if (unlikely(page =3D=3D RADIX_TREE_RETRY))
>  			goto restart;
> =20
> -		if (!page_cache_get_speculative(page))
> +		if (!page_cache_get_speculative(page)) {
> +			/* barrier: see find_get_pages() */
> +			barrier();
>  			goto repeat;
> +		}
> =20
>  		/* Has the page moved? */
>  		if (unlikely(page !=3D *((void **)pages[i]))) {

--=20
Met vriendelijke groet / with kind regards,
Guus Sliepen <Guus.Sliepen@astro.su.se>

--LG0Ll82vYr46+VA1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4e0asACgkQAxLow12M2ntW5ACdH07WlqFnnnq2QL6enmc2yLsJ
Rr4Ani+J3a5vC6WfcQOf2MebiJaq/gtj
=X4Tp
-----END PGP SIGNATURE-----

--LG0Ll82vYr46+VA1--


--===============5428332539705186350==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5428332539705186350==--

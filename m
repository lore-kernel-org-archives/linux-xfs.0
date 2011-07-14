Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6EJTnqS157295 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 14:29:50 -0500
Received: from arianus.sliepen.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2E5D167F2EA
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 12:29:47 -0700 (PDT)
Received: from arianus.sliepen.org (arianus.sliepen.org [92.243.30.131]) by
	cuda.sgi.com with ESMTP id z6zpuXrdE3MgncQk for
	<xfs@oss.sgi.com>; Thu, 14 Jul 2011 12:29:47 -0700 (PDT)
Date: Thu, 14 Jul 2011 21:29:45 +0200
From: Guus Sliepen <Guus.Sliepen@astro.su.se>
Subject: Re: BUG: soft lockup - is this XFS problem?
Message-ID: <20110714192945.GX18364@sliepen.org>
References: <20090105064838.GA5209@wotan.suse.de>
	<20110714112324.GM30145@sliepen.org> <4E1F2F5D.8060505@gmail.com>
MIME-Version: 1.0
In-Reply-To: <4E1F2F5D.8060505@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7472846621250264065=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter Klotz <peter.klotz99@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Nick Piggin <npiggin@kernel.dk>, Roman Kononov <kernel@kononov.ftml.net>, linux-kernel@vger.kernel.org


--===============7472846621250264065==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L1EIGrW/+75u5Nmw"
Content-Disposition: inline


--L1EIGrW/+75u5Nmw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 14, 2011 at 08:03:09PM +0200, Peter Klotz wrote:

> On 07/14/2011 01:23 PM, Guus Sliepen wrote:
>=20
> >I'm having a problem with a system having an XFS filesystem on RAID lock=
ing up
> >fairly consistently when writing large amounts of data to it, with sever=
al
> >kernels, including 2.6.38.2 and 2.6.39.3, on both AMD and Intel multi-co=
re
> >processors. The kernel always logs this several times:
> >
> >BUG: soft lockup - CPU#2 stuck for 67s! [kswapd0:33]
[...]
> This Bugzilla entry documents the XFS bug from 2009 in detail
> including links:
>=20
> http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D805

Aha, I did not look at that before.

> The problem was finally solved by a patch proposed by Linus. This is
> the reason the original patch developed by Nick never made it into
> the kernel.
>=20
> My tests back then showed that both patches fixed the problem.
>=20
> It seems you have found a test case where just Nick's patch helps.

Yes. I agree with Linus that the root cause should be fixed, not the sympto=
ms.
I don't have time to dive in the kernel code myself, but I do have several
nearly identical machines where I can test things on. I will be happy to te=
st
out patches and/or different kernel versions or kernel configurations, and I
can provide dmesg output and perhaps other information if necessary.

--=20
Met vriendelijke groet / with kind regards,
Guus Sliepen <Guus.Sliepen@astro.su.se>

--L1EIGrW/+75u5Nmw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4fQ6kACgkQAxLow12M2nt0TgCgluSri0GsBwO/5BQHTWT3n10k
Li0AoJ+JGWW6TDhFX6CcHnl7cTqLHxrE
=k+8V
-----END PGP SIGNATURE-----

--L1EIGrW/+75u5Nmw--


--===============7472846621250264065==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7472846621250264065==--

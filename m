Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B848E7CA0
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 05:38:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 89227304051
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 03:38:48 -0700 (PDT)
Received: from mezzanine.sirena.org.uk (mezzanine.sirena.org.uk
	[106.187.55.193]) by cuda.sgi.com with ESMTP id
	YVdadxZy1mgFHf8D (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2016 03:38:45 -0700 (PDT)
Date: Fri, 22 Jul 2016 11:38:29 +0100
From: Mark Brown <broonie@kernel.org>
Message-ID: <20160722103829.GY6509@sirena.org.uk>
References: <E1bQXSf-0008Uu-Ej@optimist>
MIME-Version: 1.0
In-Reply-To: <E1bQXSf-0008Uu-Ej@optimist>
Subject: Re: next-20160722 build: 1 failures 5 warnings (next-20160722)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2874677902126593138=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Matthew Wilcox <matthew.r.wilcox@intel.com>, Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>
Cc: xfs@oss.sgi.com, linaro-kernel@lists.linaro.org, linux-next@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-build-reports@lists.linaro.org


--===============2874677902126593138==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="pEAjBjStGYT6H+Py"
Content-Disposition: inline


--pEAjBjStGYT6H+Py
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 22, 2016 at 11:13:41AM +0100, Build bot for Mark Brown wrote:

Today's -next fails to build an ARM allmodconfig due to:

> 	arm-allmodconfig
> ERROR: "dax_do_io" [fs/xfs/xfs.ko] undefined!

due to 16d4d43595b47 (xfs: split direct I/O and DAX path) which added an
unconditional reference to dax_do_io().  DAX is explicitly disabled on
32 bit ARM due to problems with virtual aliasing caches (it's not clear
to me that it shouldn't also be disabled for arm64 for the same reason).

--pEAjBjStGYT6H+Py
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXkfekAAoJECTWi3JdVIfQGPQH/i+nFfpAASn0YIlZ+0FcuS3o
xTGm+YTGKFNWFPlb2SIKSpjno8qvP7VJ7b/RUNYLTJqbw2+URrYEUPOf0I0OTY9/
JOpiadKohd12LxzM1xDOp7RTz8k2fCtrSaAWy5HgRWtdEdtedoFILLs8E1YjQW+T
UyYegdMkf04PrcoGZjt0q1iu+7ZvT2y2KOBc+BlWy5Xf2TMeevxNZXTzzY1FCgvS
/XMFjbe4Kr/NjTuh7anZwjX0uF7upVwLJ9XRd8/u1bNM8/I1DyNP2WqAP+DITYDd
l4KYOMrngXuAxWTRclgNZ5fU8BsX02SBDvGOMF58klZHPwVYmooXAvFKXIeuO7E=
=Jr/k
-----END PGP SIGNATURE-----

--pEAjBjStGYT6H+Py--


--===============2874677902126593138==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2874677902126593138==--

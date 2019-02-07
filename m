Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx.gwdg.de ([134.76.10.20]:54269 "EHLO mx.gwdg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbfBGJll (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Feb 2019 04:41:41 -0500
Date: Thu, 7 Feb 2019 10:41:38 +0100
From: Andre Noll <maan@tuebingen.mpg.de>
Subject: Re: bcache on XFS: metadata I/O (dirent I/O?) not getting cached at
 all?
Message-ID: <20190207094138.GZ24140@tuebingen.mpg.de>
References: <87h8dgefee.fsf@esperi.org.uk>
 <64f32487-5b8f-f6c2-37a9-84bb0717a9e1@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="F+wU6CH2q8RBGewX"
Content-Disposition: inline
In-Reply-To: <64f32487-5b8f-f6c2-37a9-84bb0717a9e1@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Coly Li <colyli@suse.de>
Cc: Nix <nix@esperi.org.uk>, linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>


--F+wU6CH2q8RBGewX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 07, 16:16, Coly Li wrote
> From: Coly Li <colyli@suse.de>
> Date: Thu, 7 Feb 2019 15:54:24 +0800
> Subject: [PATCH] bcache: use (REQ_META|REQ_PRIO) to indicate bio for meta=
data
>=20
> In 'commit 752f66a75aba ("bcache: use REQ_PRIO to indicate bio for
> metadata")' REQ_META is replaced by REQ_PRIO to indicate metadata bio.
> This assumption is not always correct, e.g. XFS uses REQ_META to mark
> metadata bio other than REQ_PRIO. This is why Nix reports a regression
> that bcache does not cache metadata for XFS after the above commit.

maybe s/reports a regression/noticed

> Thanks to Dave Chinner, he explains the difference between REQ_META and
> REQ_PRIO from view of file system developer. Here I quote part of his
> explanation from mailing list,
>    REQ_META is used for metadata. REQ_PRIO is used to communicate to
>    the lower layers that the submitter considers this IO to be more
>    important that non REQ_PRIO IO and so dispatch should be expedited.
>=20
>    IOWs, if the filesystem considers metadata IO to be more important
>    that user data IO, then it will use REQ_PRIO | REQ_META rather than
>    just REQ_META.
>=20
> Then it seems bios with REQ_META or REQ_PRIO should both be cached for
> performance optimation, because they are all probably low I/O latency
> demand by upper layer (e.g. file system).
>=20
> So in this patch, when we want to check whether a bio is metadata
> related, REQ_META and REQ_PRIO are both checked. Then both metadata and
> high priority I/O requests will be handled properly.

s/check whether a bio is metadata related/decide whether to bypass the cache

Apart from these two nitpicks, feel free to add my Reviewed-by.

Thanks
Andre
--=20
Max Planck Institute for Developmental Biology
Max-Planck-Ring 5, 72076 T=C3=BCbingen, Germany. Phone: (+49) 7071 601 829
http://people.tuebingen.mpg.de/maan/

--F+wU6CH2q8RBGewX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSHtF/cbZGyylvqq1Ra2jVAMQCTDwUCXFv9TwAKCRBa2jVAMQCT
D6iBAJ9Q49MNCE/vqkNWDbBeCJmj75/yuwCcCNgZSsoX/Q77BlBlvG43/qiOADE=
=/dXc
-----END PGP SIGNATURE-----

--F+wU6CH2q8RBGewX--

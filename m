Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx.gwdg.de ([134.76.10.20]:46075 "EHLO mx.gwdg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbfBGAx4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Feb 2019 19:53:56 -0500
Date: Thu, 7 Feb 2019 01:24:25 +0100
From: Andre Noll <maan@tuebingen.mpg.de>
Subject: Re: bcache on XFS: metadata I/O (dirent I/O?) not getting cached at
 all?
Message-ID: <20190207002425.GX24140@tuebingen.mpg.de>
References: <87h8dgefee.fsf@esperi.org.uk>
 <20190206234328.GH14116@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/T5g/TLNXpBPJeG6"
Content-Disposition: inline
In-Reply-To: <20190206234328.GH14116@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Nix <nix@esperi.org.uk>, linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Coly Li <colyli@suse.de>


--/T5g/TLNXpBPJeG6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 07, 10:43, Dave Chinner wrote
> File data readahead: REQ_RAHEAD
> Metadata readahead: REQ_META | REQ_RAHEAD
>=20
> drivers/md/bcache/request.c::check_should_bypass():
>=20
>         /*
>          * Flag for bypass if the IO is for read-ahead or background,
>          * unless the read-ahead request is for metadata (eg, for gfs2).
>          */
>         if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND) &&
>             !(bio->bi_opf & REQ_PRIO))
>                 goto skip;
>=20
> bcache needs fixing - it thinks REQ_PRIO means metadata IO. That's
> wrong - REQ_META means it's metadata IO, and so this is a bcache
> bug.

Do you think 752f66a75abad is bad (ha!) and should be reverted?

Thanks
Andre
--=20
Max Planck Institute for Developmental Biology
Max-Planck-Ring 5, 72076 T=C3=BCbingen, Germany. Phone: (+49) 7071 601 829
http://people.tuebingen.mpg.de/maan/

--/T5g/TLNXpBPJeG6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSHtF/cbZGyylvqq1Ra2jVAMQCTDwUCXFt6tgAKCRBa2jVAMQCT
D6DyAKCR1mgnr+k1DigFJ3ecqGlOH6enywCggXSpPLjRVepKu8maddVQk5KMF9I=
=1sEJ
-----END PGP SIGNATURE-----

--/T5g/TLNXpBPJeG6--

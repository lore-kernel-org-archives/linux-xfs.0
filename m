Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx.gwdg.de ([134.76.10.20]:45863 "EHLO mx.gwdg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbfBGJ2Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Feb 2019 04:28:24 -0500
Date: Thu, 7 Feb 2019 10:28:19 +0100
From: Andre Noll <maan@tuebingen.mpg.de>
Subject: Re: bcache on XFS: metadata I/O (dirent I/O?) not getting cached at
 all?
Message-ID: <20190207092819.GY24140@tuebingen.mpg.de>
References: <87h8dgefee.fsf@esperi.org.uk>
 <20190206234328.GH14116@dastard>
 <20190207002425.GX24140@tuebingen.mpg.de>
 <b982a23b-7225-d20a-2802-60bce314ccc2@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gBii9oQw/U9UOygZ"
Content-Disposition: inline
In-Reply-To: <b982a23b-7225-d20a-2802-60bce314ccc2@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Coly Li <colyli@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, Nix <nix@esperi.org.uk>, linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk


--gBii9oQw/U9UOygZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 07, 10:27, Coly Li wrote

> If different file system handles metadata flags in unified ways, it is
> OK to me to change the code to: !(bio->bi_opf & (REQ_META |REQ_PRIO)).

Yes, that's the smallest fix that should also go into 4.19-stable.

In the long run, we should try to get rid of the 45 instances of
REQ_PRIO. Most users specify REQ_META | REQ_PRIO anyway, which leaves
only a few other instances to look at.

I think the one in submit_bh_wbc() of fs/buffer.c can just be removed
while block/cfq-iosched.c does not use REQ_META at all, so the simple
s/REQ_PRIO/REQ_META should be OK. drivers/staging/erofs/data.c is
also easy to fix.

Best
Andre
--=20
Max Planck Institute for Developmental Biology
Max-Planck-Ring 5, 72076 T=C3=BCbingen, Germany. Phone: (+49) 7071 601 829
http://people.tuebingen.mpg.de/maan/

--gBii9oQw/U9UOygZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSHtF/cbZGyylvqq1Ra2jVAMQCTDwUCXFv6MAAKCRBa2jVAMQCT
D5coAKCcC0GuP2KTQi/SwEAsWqfUJw6gigCfX4CU1iFd0TsxJMy93V2ZSUUPpLg=
=ML1i
-----END PGP SIGNATURE-----

--gBii9oQw/U9UOygZ--

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40166 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730456AbfC2WW1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 18:22:27 -0400
Received: by mail-pf1-f193.google.com with SMTP id c207so1681565pfc.7
        for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2019 15:22:26 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <0FA09E34-400A-473D-9F3A-3014F79B2A82@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_2D543960-CD75-43F9-99DB-CED1525EC66B";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v3 1/3] block: introduce submit_bio_verify()
Date: Fri, 29 Mar 2019 16:22:18 -0600
In-Reply-To: <20190329142346.1677-2-bob.liu@oracle.com>
References: <20190329142346.1677-1-bob.liu@oracle.com>
 <20190329142346.1677-2-bob.liu@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bob Liu <bob.liu@oracle.com>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Martin Petersen <martin.petersen@oracle.com>, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, axboe@kernel.dk, tytso@mit.edu


--Apple-Mail=_2D543960-CD75-43F9-99DB-CED1525EC66B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 29, 2019, at 8:23 AM, Bob Liu <bob.liu@oracle.com> wrote:
>=20
> This patch adds a function verifier callback to submit_bio.  The
> filesystem layer can use submit_bio_verify to pass a call back
> to the block layer which can then be used to verify if the data
> read is correct.

How does this interact (if at all) with bio_integrity_verify() code?
Does it mean if e.g. XFS is on storage with T10-PI that only one or
the other can be used, or will it be possible to chain the verify
callbacks?

Cheers, Andreas

> Signed-off-by: Bob Liu <bob.liu@oracle.com>
> ---
> block/blk-core.c    | 13 ++++++++++---
> include/linux/bio.h |  2 ++
> 2 files changed, 12 insertions(+), 3 deletions(-)
>=20
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 6b78ec56a4f2..d265d2924c32 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1156,15 +1156,16 @@ blk_qc_t direct_make_request(struct bio *bio)
> EXPORT_SYMBOL_GPL(direct_make_request);
>=20
> /**
> - * submit_bio - submit a bio to the block device layer for I/O
> + * submit_bio_verify - submit a bio to the block device layer for I/O
>  * @bio: The &struct bio which describes the I/O
>  *
> - * submit_bio() is very similar in purpose to generic_make_request(), =
and
> + * submit_bio_verify() is very similar in purpose to =
generic_make_request(), and
>  * uses that function to do most of the work. Both are fairly rough
>  * interfaces; @bio must be presetup and ready for I/O.
>  *
>  */
> -blk_qc_t submit_bio(struct bio *bio)
> +blk_qc_t submit_bio_verify(struct bio *bio,
> +		int (*verifier_cb_func)(struct bio *))
> {
> 	/*
> 	 * If it's a regular read/write or a barrier with data attached,
> @@ -1197,6 +1198,12 @@ blk_qc_t submit_bio(struct bio *bio)
>=20
> 	return generic_make_request(bio);
> }
> +EXPORT_SYMBOL(submit_bio_verify);
> +
> +blk_qc_t submit_bio(struct bio *bio)
> +{
> +	return submit_bio_verify(bio, NULL);
> +}
> EXPORT_SYMBOL(submit_bio);
>=20
> /**
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 7380b094dcca..ddaadab74dcf 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -398,6 +398,8 @@ static inline struct bio *bio_kmalloc(gfp_t =
gfp_mask, unsigned int nr_iovecs)
> 	return bio_alloc_bioset(gfp_mask, nr_iovecs, NULL);
> }
>=20
> +extern blk_qc_t submit_bio_verify(struct bio *,
> +		int (*verifier_cb_func)(struct bio *));
> extern blk_qc_t submit_bio(struct bio *);
>=20
> extern void bio_endio(struct bio *);
> --
> 2.17.1
>=20


Cheers, Andreas






--Apple-Mail=_2D543960-CD75-43F9-99DB-CED1525EC66B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlyempsACgkQcqXauRfM
H+DRQhAAl1dcdhbWqUtnHIo/leZtKXrSub/TrhKQPmxC2iQJyX7GFo74uHRdRnQA
i3gZt96nht6EmAJokXyuadiYqzlCqpN5lkanEB/myeie27ggkKsH96QEBHoG9Gkr
2hocaDhP90vKFNhSQGSfPC9n3Q0u9X5r+MOgKkEl7x+4d4QzO5rQGH3f78vVAg86
TPVCCM5wQ0b06ubItOZgZe7ZypGVp92SXovUqoMhMZDeuB1FEonOj6T39TuCrnkf
N9pMnVUIEMFiH+aCCOv70RbEpL6OFCnxJhnTlUnCGoiczwWpWfUlP2hh9vx6pRSP
RNMSK7KM0Egvom0f6denbzvDrJ3/JTPlFyN3GpgYY1cah5wzdortAX+bk4v0yt1E
c1+eIttJBwQiXAPxURAtm9ULRFDo502fq5TGs9V+75qDRVuDIvo08797Ko6dWd3U
trgBvf1b63eoh8CTRuPipn1MHRUOBViLUqaw6jx4eTQgbCIxGmhk7FQ7KWhP3UM0
/0KxLhT6x60enj8aEUXmhAOjMA5OObIU5hT+oPrAUxeVqQ7FkL+jw1lElHlEt2rW
x1DvZJOFZxqPOMis9R2w2GEMPBPQtIHExRJBKsGH+gufUsCXPovsjB4u0ZiB3t3W
rWQ9RBtadBg5y9kOntaYldVZkbP6B1QL5UnyUjSSYHQ+oTWDiSM=
=a7IN
-----END PGP SIGNATURE-----

--Apple-Mail=_2D543960-CD75-43F9-99DB-CED1525EC66B--

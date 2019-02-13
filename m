Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39098 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733118AbfBMK0S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Feb 2019 05:26:18 -0500
Received: by mail-pl1-f194.google.com with SMTP id 101so959368pld.6
        for <linux-xfs@vger.kernel.org>; Wed, 13 Feb 2019 02:26:17 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <D2BD41DA-D7B3-4C76-B4BC-40B012E3D6A4@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_E0D7658E-65DD-4C51-93A2-A655AC5B8FF4";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [RFC PATCH v2 1/9] block: add nr_mirrors to request_queue
Date: Wed, 13 Feb 2019 03:26:14 -0700
In-Reply-To: <20190213095044.29628-2-bob.liu@oracle.com>
References: <20190213095044.29628-1-bob.liu@oracle.com>
 <20190213095044.29628-2-bob.liu@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bob Liu <bob.liu@oracle.com>
Cc: linux-block <linux-block@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Martin Petersen <martin.petersen@oracle.com>, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org


--Apple-Mail=_E0D7658E-65DD-4C51-93A2-A655AC5B8FF4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 13, 2019, at 2:50 AM, Bob Liu <bob.liu@oracle.com> wrote:
>=20
> When fs data/metadata checksum mismatch, lower block devices may have =
other
> correct copies. e.g if we did raid1 for protecting fs metadata.
> Then fs could try other copies of metadata instead of panic, but fs =
need be
> awared how many mirrors the block devices have.
>=20
> This patch add @nr_mirrors to struct request_queue which is similar as
> blk_queue_nonrot(), filesystem can grab device request queue and check =
the
> number of mirrors of this block device.
>=20
> @nr_mirrors is 1 by default which means only one copy, drivers e.g =
raid1 are
> responsible for setting the right value. The maximum value is
> BITS_PER_LONG which is 32 or 64. That should be big enough else retry =
lantency
> may be too high.
>=20
> Also added helper functions for get/set the number of mirrors for a =
specific
> device request queue.
>=20
> Todo:
> * Export nr_mirrors through /sysfs.
>=20
> Signed-off-by: Bob Liu <bob.liu@oracle.com>

> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 3e7038e475ee..38e4d7e675e6 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -844,6 +844,30 @@ void blk_queue_write_cache(struct request_queue =
*q, bool wc, bool fua)
> +/*
> + * Set the number of read redundant mirrors.
> + */
> +bool blk_queue_set_mirrors(struct request_queue *q, unsigned short =
mirrors)
> +{
> +	if(q->nr_mirrors >=3D BLKDEV_MAX_MIRRORS) {
> +		printk("blk_queue_set_mirrors: %d exceed max =
mirrors(%d)\n",
> +				mirrors, BLKDEV_MAX_MIRRORS);

Need to supply a KERN_ level here.

Cheers, Andreas






--Apple-Mail=_E0D7658E-65DD-4C51-93A2-A655AC5B8FF4
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxj8MYACgkQcqXauRfM
H+CRcA//a0CdSKWwc/HVXVC2l3nkn7Vv8PnaBcVBfTAzXaZFFH/AInHO9YWhjdge
0tHZ5UMWEe4JZ8qc+9M5g+LD5btA2CXPeimysqW2Rv29Rq86ASF0fqUU+Ayf0ouS
oxKYW4HfJpu6QzovSbltwFuw0rnRymeRV3wul4gqkJheFJkyDv509+OHzyh+BE8a
ImHKDfghT5y/w//2+h3uSz0Kp4MfOY/5W1omn0Cjg/CLUSJflYrj8LS4y+HTR56B
rkgZO2pdjEt17kkIQ8E4LWSHVdVwPgcX3GKzIDjcwEZaIpxH7ilV9AqjTQEABrYG
q6sRs/PRLyw6ag1KJRkbEz+qZ0U/kNB8E47PFuh9MKaT9o/d8z4SEvELvPjibnAb
fKrrgGJR90575B1GeK0Vif+vriwPUmi2GlukcbkSu7KAEn3NqAEwpIhAlIr4w4Eo
nLsmsS4V3hHMmypDzsiA5iuq8Ll16RR2RQFeVsZ0NcWR6l76PLRpv+dEHtzGRsxQ
S+yUPodcDJuL61OkHptCtpQQto3o/WVsKbI7aJMXyeSZhPZ8Hk1FvYW44976pARI
T+FkKkeHJSbujD8KPzHgmRis94nxKfKzCBHe4x59VvX1FOpXmuldNh9W2W2EOz52
Eb4oibGn3Wo4j9wbMsatYbcm3a9tvpO8LOxhXT9FQvrr13vIjqM=
=v45Z
-----END PGP SIGNATURE-----

--Apple-Mail=_E0D7658E-65DD-4C51-93A2-A655AC5B8FF4--

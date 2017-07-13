Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33058 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbdGMGIz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2017 02:08:55 -0400
Received: by mail-pf0-f193.google.com with SMTP id e199so5957243pfh.0
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2017 23:08:55 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <566E0688-E3D4-416A-B496-6B2F0FA3C85C@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_B77E4B35-FCE5-4B96-A813-A4FE70E6CF1B";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] vfs: in iomap seek_{hole,data}, return -ENXIO for
 negative offsets
Date: Wed, 12 Jul 2017 23:08:51 -0700
In-Reply-To: <20170712173650.GC4212@magnolia>
References: <20170712173650.GC4212@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>


--Apple-Mail=_B77E4B35-FCE5-4B96-A813-A4FE70E6CF1B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 12, 2017, at 10:36 AM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> In the iomap implementations of SEEK_HOLE and SEEK_DATA, make sure we
> return -ENXIO for negative offsets instead of badgering the iomap
> provider with garbage requests.

Hmm, wouldn't it be useful to be able to seek N bytes before the hole or =
data?
It would make more sense to verify the result after finding the hole or =
data
and adding the relative offset. It should only be an error if the =
resulting
offset is before the start or after the actual file end.  Of course, if
the passed offset > size from the start then there is no way it can get =
better
and that would be grounds for returning early.

Cheers, Andreas

> Inspired-by: Mateusz S <muttdini@gmail.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> fs/iomap.c |    8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 432eed8..16f5c074 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -610,8 +610,8 @@ iomap_seek_hole(struct inode *inode, loff_t =
offset, const struct iomap_ops *ops)
> 	loff_t length =3D size - offset;
> 	loff_t ret;
>=20
> -	/* Nothing to be found beyond the end of the file. */
> -	if (offset >=3D size)
> +	/* Nothing to be found before or beyond the end of the file. */
> +	if (offset < 0 || offset >=3D size)
> 		return -ENXIO;
>=20
> 	while (length > 0) {
> @@ -656,8 +656,8 @@ iomap_seek_data(struct inode *inode, loff_t =
offset, const struct iomap_ops *ops)
> 	loff_t length =3D size - offset;
> 	loff_t ret;
>=20
> -	/* Nothing to be found beyond the end of the file. */
> -	if (offset >=3D size)
> +	/* Nothing to be found before or beyond the end of the file. */
> +	if (offset < 0 || offset >=3D size)
> 		return -ENXIO;
>=20
> 	while (length > 0) {


Cheers, Andreas






--Apple-Mail=_B77E4B35-FCE5-4B96-A813-A4FE70E6CF1B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZZw5zpIg59Q01vtYRAnWdAJ9wrNmFvf5i0uSNfMO7oWCd00zaeACg5OrW
59Jw6IaTvWPG75yYFMIezag=
=qIVO
-----END PGP SIGNATURE-----

--Apple-Mail=_B77E4B35-FCE5-4B96-A813-A4FE70E6CF1B--

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52647 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752161AbdCDAAk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Mar 2017 19:00:40 -0500
From: NeilBrown <neil@brown.name>
Date: Sat, 04 Mar 2017 11:00:06 +1100
Subject: Re: [RFC PATCH v1 30/30] fs: convert i_version counter over to an atomic64_t
In-Reply-To: <1482339827-7882-31-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com> <1482339827-7882-31-git-send-email-jlayton@redhat.com>
Message-ID: <87zih1lxmh.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 21 2016, Jeff Layton wrote:

>=20=20
> +/*
> + * We borrow the top bit in the i_version to use as a flag to tell us wh=
ether
> + * it has been queried since we last bumped it. If it has, then we must =
bump
> + * it and set the flag. Note that this means that we have to handle wrap=
ping
> + * manually.
> + */
> +#define INODE_I_VERSION_QUERIED		(1ULL<<63)
> +

I would prefer that the least significant bit were used, rather than the
most significant.

Partly, this is because the "queried" state is less significant than
that "number has changed" state.
But most, this would mean we wouldn't need inode_cmp_iversion() at all.
We could just use "<" or ">=3D" or whatever.
The number returned by inode_get_iversion() would always be even (or
maybe odd) and wrapping (after the end of time) would "just work".

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAli6A4YACgkQOeye3VZi
gblBNA//dX+mAOOvNDvTqyQtKxXDIZlrQmK7oI+wSvSBbgpyOR6vwxMkmQboJXJ9
q8pIudntLXjyEykbXb+HA30AxSpL/X/7PQxG/ZllYJ1ImY2QMcvSNKnkfsNcUN0o
yv9334AIoShL8lEq35JLuoBQ3w2tVbDlNhFRTbW+lWW9hqzzNiWbSdgMuVg8qEAz
feGjCW0FqmfyhCEX4UIARUDM7qpqt71fmI1EYmriEU0hU/rFViMVAyLU7cWjF9WS
FxgYAR+QJFCHuA3OFB4Bg32jzj7qS35mI3bGG/v1X+RDjp8jQ0WwWI+8A45p0+vX
Zdw6ABbkW56vl5kM5x4j7UNG96AthXjOf1qJ5UK1dw7S3GQJb0MfLh+94v4ECWU1
SSZTvPC5OYfMcLThhew1CUx//f/p8CeG4Dfq3iBW6FHYWclWZoM0t3KRiC1dQJaT
njf0xd7CUIsXaLtlKbLXKC2vqY9wcMX62E7W74DGeffyfQ+maQaygRUW9yBiMPPe
Rh2akXxE5vpdPxm9rsP/PUJIStmTsM7MQl2oFb0zWxY5hY8PREpAXk8nD0QrrK/M
S6qNtgFevm4sPemwfe04EmumUJjX5/u1gypeHz02omdBO6Fk5XE2be6EeBC8aHtL
oxLnpA/JZxCrvoS+nvHAHvrPQHJ/EZYm1I+qDighBQN1NIxGVJI=
=HK7d
-----END PGP SIGNATURE-----
--=-=-=--

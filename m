Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41738 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751544AbcKYEUk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Nov 2016 23:20:40 -0500
Date: Thu, 24 Nov 2016 23:20:39 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Subject: Re: [RFC PATCH 0/2] Btrfs: make a source length of 0 imply EOF for
 dedupe
Message-ID: <20161125042038.GF8685@hungrycats.org>
References: <cover.1479427384.git.osandov@fb.com>
 <20161123020210.GW21290@hungrycats.org>
 <20161123042632.GQ31101@dastard>
 <20161123135559.GC8685@hungrycats.org>
 <20161123221328.GR31101@dastard>
 <20161123231446.GD8685@hungrycats.org>
 <20161123235324.GQ28177@dastard>
 <20161124012618.GH23680@birch.djwong.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oXNgvKVxGWJ0RPMJ"
Content-Disposition: inline
In-Reply-To: <20161124012618.GH23680@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>, Christoph Hellwig <hch@infradead.org>, kernel-team@fb.com


--oXNgvKVxGWJ0RPMJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23, 2016 at 05:26:18PM -0800, Darrick J. Wong wrote:
[...]
> Keep in mind that the number of bytes deduped is returned to userspace
> via file_dedupe_range.info[x].bytes_deduped, so a properly functioning
> userspace program actually /can/ detect that its 128MB request got cut
> down to only 16MB and re-issue the request with the offsets moved up by
> 16MB.  The dedupe client in xfs_io (see dedupe_ioctl() in io/reflink.c)
> implements this strategy.  duperemove (the only other user I know of)
> also does this.
>=20
> So it's really no big deal to increase the limit beyond 16MB, eliminate
> it entirely, or even change it to cap the total request size while
> dropping the per-item IO limit.
>=20
> As I mentioned in my other reply, the only hesitation I have for not
> killing XFS_MAX_DEDUPE_LEN is that I feel that 2GB is enough IO for a
> single ioctl call.

Everything's relative.  btrfs has ioctls that will do hundreds of
terabytes of IO and take months to run.  2GB of data is nothing.

Deduping entire 100TB files with a single ioctl call makes as much
sense to me as reflink copying them with a single ioctl call.  The only
reason I see to keep the limit is to work around something wrong with
the implementation.


--oXNgvKVxGWJ0RPMJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlg3vBYACgkQgfmLGlazG5xNfACgmwnLqgkMSEla5OODse8eUiHp
84UAmwVbqj3wz6AKqAPF4lWN3uGMoDOC
=QHr7
-----END PGP SIGNATURE-----

--oXNgvKVxGWJ0RPMJ--

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39814 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S933269AbcKWN4B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2016 08:56:01 -0500
Date: Wed, 23 Nov 2016 08:55:59 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Subject: Re: [RFC PATCH 0/2] Btrfs: make a source length of 0 imply EOF for
 dedupe
Message-ID: <20161123135559.GC8685@hungrycats.org>
References: <cover.1479427384.git.osandov@fb.com>
 <20161123020210.GW21290@hungrycats.org>
 <20161123042632.GQ31101@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VMt1DrMGOVs3KQwf"
Content-Disposition: inline
In-Reply-To: <20161123042632.GQ31101@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>, Christoph Hellwig <hch@infradead.org>, kernel-team@fb.com


--VMt1DrMGOVs3KQwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23, 2016 at 03:26:32PM +1100, Dave Chinner wrote:
> On Tue, Nov 22, 2016 at 09:02:10PM -0500, Zygo Blaxell wrote:
> > On Thu, Nov 17, 2016 at 04:07:48PM -0800, Omar Sandoval wrote:
> > > 3. Both XFS and Btrfs cap each dedupe operation to 16MB, but the
> > >    implicit EOF gets around this in the existing XFS implementation. I
> > >    copied this for the Btrfs implementation.
> >=20
> > Somewhat tangential to this patch, but on the dedup topic:  Can we raise
> > or drop that 16MB limit?
> >=20
> > The maximum btrfs extent length is 128MB.  Currently the btrfs dedup
> > behavior for a 128MB extent is to generate 8x16MB shared extent referen=
ces
> > with different extent offsets to a single 128MB physical extent.
> > These references no longer look like the original 128MB extent to a
> > userspace dedup tool.  That raises the difficulty level substantially
> > for a userspace dedup tool when it tries to figure out which extents to
> > keep and which to discard or rewrite.
>=20
> That, IMO, is a btrfs design/implementation problem, not a problem
> with the API. Applications are always going to end up doing things
> that aren't perfectly aligned to extent boundaries or sizes
> regardless of the size limit that is placed on the dedupe ranges.

Given that XFS doesn't have all the problems btrfs does, why does XFS
have the same aribitrary size limit?  Especially since XFS demonstrably
doesn't need it?

> > XFS may not have this problem--I haven't checked.
>=20
> It doesn't - it tracks shared blocks exactly and merges adjacent
> extent records whenever possible.
>=20
> > Even if we want to keep the 16MB limit, there's also no way to query the
> > kernel from userspace to find out what the limit is, other than by trial
> > and error.  It's not even in a header file, userspace just has to *know=
*.
>=20
> So add a define to the API to make it visible to applications and
> document it in the man page.

To answer some of my own questions on the btrfs side:  It looks like
the btrfs implementation does have a reason for it (fixed-size arrays).

> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com
>=20

--VMt1DrMGOVs3KQwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlg1n+8ACgkQgfmLGlazG5xAOQCghyuzCEmUK0gwanWn7rpQfMAy
nWUAoOGnK4M7B5myEYHeSYa/+vr8BqMZ
=0rpy
-----END PGP SIGNATURE-----

--VMt1DrMGOVs3KQwf--

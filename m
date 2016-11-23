Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46660 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S934824AbcKWXOt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2016 18:14:49 -0500
Date: Wed, 23 Nov 2016 18:14:47 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Subject: Re: [RFC PATCH 0/2] Btrfs: make a source length of 0 imply EOF for
 dedupe
Message-ID: <20161123231446.GD8685@hungrycats.org>
References: <cover.1479427384.git.osandov@fb.com>
 <20161123020210.GW21290@hungrycats.org>
 <20161123042632.GQ31101@dastard>
 <20161123135559.GC8685@hungrycats.org>
 <20161123221328.GR31101@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="k3qmt+ucFURmlhDS"
Content-Disposition: inline
In-Reply-To: <20161123221328.GR31101@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>, Christoph Hellwig <hch@infradead.org>, kernel-team@fb.com


--k3qmt+ucFURmlhDS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 24, 2016 at 09:13:28AM +1100, Dave Chinner wrote:
> On Wed, Nov 23, 2016 at 08:55:59AM -0500, Zygo Blaxell wrote:
> > On Wed, Nov 23, 2016 at 03:26:32PM +1100, Dave Chinner wrote:
> > > On Tue, Nov 22, 2016 at 09:02:10PM -0500, Zygo Blaxell wrote:
> > > > On Thu, Nov 17, 2016 at 04:07:48PM -0800, Omar Sandoval wrote:
> > > > > 3. Both XFS and Btrfs cap each dedupe operation to 16MB, but the
> > > > >    implicit EOF gets around this in the existing XFS implementati=
on. I
> > > > >    copied this for the Btrfs implementation.
> > > >=20
> > > > Somewhat tangential to this patch, but on the dedup topic:  Can we =
raise
> > > > or drop that 16MB limit?
> > > >=20
> > > > The maximum btrfs extent length is 128MB.  Currently the btrfs dedup
> > > > behavior for a 128MB extent is to generate 8x16MB shared extent ref=
erences
> > > > with different extent offsets to a single 128MB physical extent.
> > > > These references no longer look like the original 128MB extent to a
> > > > userspace dedup tool.  That raises the difficulty level substantial=
ly
> > > > for a userspace dedup tool when it tries to figure out which extent=
s to
> > > > keep and which to discard or rewrite.
> > >=20
> > > That, IMO, is a btrfs design/implementation problem, not a problem
> > > with the API. Applications are always going to end up doing things
> > > that aren't perfectly aligned to extent boundaries or sizes
> > > regardless of the size limit that is placed on the dedupe ranges.
> >=20
> > Given that XFS doesn't have all the problems btrfs does, why does XFS
> > have the same aribitrary size limit?  Especially since XFS demonstrably
> > doesn't need it?
>=20
> Creating a new-but-slightly-incompatible jsut for XFS makes no
> sense - we have multiple filesystems that support this functionality
> and so they all should use the same APIs and present (as far as is
> possible) the same behaviour to userspace.

OK.  Let's just remove the limit on all the filesystems then.
XFS doesn't need it, and btrfs can be fixed.

> IOWs it's more important to use existing APIs than to invent a new
> one that does almost the same thing. This way userspace applications
> don't need to be changed to support new XFS functionality and we
> make life easier for everyone.=20

Except removing the limit doesn't work that way.  An application that
didn't impose an undocumented limit on itself wouldn't break when moved
to a filesystem that imposed no such limit, i.e. if XFS had no limit,
an application that moved from btrfs to XFS would just work.

> A shiny new API without warts would
> be nice, but we've already got to support the existing one forever,
> it does the job we need and so it's less burden on everyone if we
> just use it as is.
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com
>=20

--k3qmt+ucFURmlhDS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlg2IuYACgkQgfmLGlazG5z6igCfcbLo9c9t6FiD0qKjyulRo+LO
AxQAoOrHThlk2rt2Q7PN5XXYTC2vRp0M
=Fu9L
-----END PGP SIGNATURE-----

--k3qmt+ucFURmlhDS--

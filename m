Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:37524 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750726AbcKXFQh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Nov 2016 00:16:37 -0500
Date: Thu, 24 Nov 2016 00:16:35 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Subject: Re: [RFC PATCH 0/2] Btrfs: make a source length of 0 imply EOF for
 dedupe
Message-ID: <20161124051634.GE8685@hungrycats.org>
References: <cover.1479427384.git.osandov@fb.com>
 <20161123020210.GW21290@hungrycats.org>
 <20161123024419.GQ16813@birch.djwong.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IvGM3kKqwtniy32b"
Content-Disposition: inline
In-Reply-To: <20161123024419.GQ16813@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>, Christoph Hellwig <hch@infradead.org>, kernel-team@fb.com


--IvGM3kKqwtniy32b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 22, 2016 at 06:44:19PM -0800, Darrick J. Wong wrote:
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
> >=20
> > XFS may not have this problem--I haven't checked.  On btrfs it's
> > definitely not as simple as "bang two inode/offset/length pairs together
> > with dedup and disk space will be freed automagically."  If dedup is
> > done incorrectly on btrfs, it can end up just making the filesystem slow
> > without freeing any space.
>=20
> I copied the 16M limit into xfs/ocfs2 because btrfs had it. :)

Finally, a clearly stated rationale.  ;)

> The VFS now limits the size of the incoming struct file_dedupe_range to
> whatever a page size is.  On x86 that only allows us 126 dedupe
> candidates, which means that a single call can perform up to ~2GB of IO.
> Storage is getting faster, but 2GB is still a fair amount for a single
> call.  Of course in XFS we do the dedupe one file and one page at a time
> to keep the memory footprint sane.
>=20
> On ppc64 with its huge 64k pages that comes out to 32GB of IO.
>=20
> One thing we (speaking for XFS, anyway) /could/ do is limit based on the
> theoretical IO count instead of clamping the length, e.g.
>=20
> if ((u64)dest_count * len >=3D (1ULL << 31))
> 	return -E2BIG;
>=20
> That way you /could/ specify a larger extent size if you pass in fewer
> file descriptors.  OTOH XFS will merge all the records together, so even
> if you deduped the whole 128M in 4k chunks you'll still end up with a
> single block mapping record and a single backref.

This is why I'm mystified that XFS has this limitation.  On btrfs there
were at least _reasons_ for it, even if they were just "we have a v0.3
implementation and nobody's even started optimizing it yet."

The btrfs code calls kzalloc (with size limited by MAX_DEDUPE_LEN) in
the context of the thread executing the ioctl.  It then loads up all the
pages, compares them, then decides whether to continue with clone_range
for the whole extent, or not.  btrfs doesn't seem to ever merge these.

> Were I starting from scratch I'd probably just dump the existing dedupe
> interface in favor of a non-vectorized dedupe_range call taking the same
> parameters as clone_range:
>=20
> int dedupe_range(src_fd, src_off, dest_fd, dest_off);
>=20
> I'd also change the semantics to "Find and share all identical blocks in
> this subrange.  Differing blocks are left alone." because it seems silly
> that duperemove can issue large requests but a single byte difference in
> the middle causes info->status to be set to FILE_DEDUPE_RANGE_DIFFERS
> and info->bytes_deduped only changes if the entire range was deduped.

It'd also be nice if it replaced all existing shared refs to the dst
blocks at the same time.  On btrfs, dedup agents have to find all the
shared refs (either through brute force or by using LOGICAL_INO to look
them all up through backrefs) and feed each one into extent_same until
the last reference to dst is removed.  But maybe this is only needed to
work around a btrfs thing that never happens on XFS... :-P

> > The 16MB limit doesn't seem to be useful in practice.  The two useful
> > effects of the limit seem to be DoS mitigation.  There is no checking of
> > the RAM usage that I can find (i.e. if you fire off 16 dedup threads,
> > they want 256MB of RAM; put another way, if you want to tie up 16GB of
> > kernel RAM, all you have to do is create 1024 dedup threads), so it's
> > not an effective DoS mitigation feature.  Internally dedup could verify
> > blocks in batches of 16MB and check for signals/release and reacquire
> > locks in between, so it wouldn't tie up the kernel or the two inodes
> > for excessively long periods.
>=20
> (Does btrfs actually do the extent_same stuff in parallel??)

A btrfs dedup agent can invoke multiple extent_sames in separate threads.
It's not a good idea on a single filesystem--they all end up blocking
on a disk IO or throttled in transaction commit--but in theory two users
could be running separate dedup agents simultaneously.

A malicious agent doesn't care about sanity if it just wants to tie
up resources.

> > Even if we want to keep the 16MB limit, there's also no way to query the
> > kernel from userspace to find out what the limit is, other than by trial
> > and error.  It's not even in a header file, userspace just has to *know=
*.
>=20
> -E2BIG?

That's how it currently works:  an application fills in the size it wants,
gets an error if it's too big (EINVAL?), and then has to guess which of
the parameters the kernel didn't like.  Btrfs has had maybe half a dozen
slight variations of this so far, always removing a restriction.

> --D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--IvGM3kKqwtniy32b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlg2d7IACgkQgfmLGlazG5wRBgCdGi4poHYE/g+WZ4y0XhLGsAY+
VIsAoOa861n/TWx9G7Wq7qnLYHXcizlV
=vepW
-----END PGP SIGNATURE-----

--IvGM3kKqwtniy32b--

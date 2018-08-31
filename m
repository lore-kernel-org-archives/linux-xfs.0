Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48816 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727106AbeHaJQ2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Aug 2018 05:16:28 -0400
Date: Fri, 31 Aug 2018 01:10:45 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Subject: Re: [patch] file dedupe (and maybe clone) data corruption (was Re:
 [PATCH] generic: test for deduplication between different files)
Message-ID: <20180831051045.GI26989@hungrycats.org>
References: <20180817083924.16916-1-fdmanana@kernel.org>
 <20180819231126.GU2234@dastard>
 <20180820010932.GV2234@dastard>
 <20180820153349.GA4334@magnolia>
 <20180823125849.GF13528@hungrycats.org>
 <20180830062743.GF5631@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ik0NlRzMGhMnxrMX"
Content-Disposition: inline
In-Reply-To: <20180830062743.GF5631@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, fdmanana@kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org


--ik0NlRzMGhMnxrMX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 30, 2018 at 04:27:43PM +1000, Dave Chinner wrote:
> On Thu, Aug 23, 2018 at 08:58:49AM -0400, Zygo Blaxell wrote:
> > On Mon, Aug 20, 2018 at 08:33:49AM -0700, Darrick J. Wong wrote:
> > > On Mon, Aug 20, 2018 at 11:09:32AM +1000, Dave Chinner wrote:
> > > > 	- is documenting rejection on request alignment grounds
> > > > 	  (i.e. EINVAL) in the man page sufficient for app
> > > > 	  developers to understand what is going on here?
> > >=20
> > > I think so.  The manpage says: "The filesystem does not support
> > > reflinking the ranges of the given files", which (to my mind) covers
> > > this case of not supporting dedupe of EOF blocks.
> >=20
> > Older versions of btrfs dedupe (before v4.2 or so) used to do exactly
> > this; however, on btrfs, not supporting dedupe of EOF blocks means small
> > files (one extent) cannot be deduped at all, because the EOF block holds
> > a reference to the entire dst extent.  If a dedupe app doesn't go all t=
he
> > way to EOF on btrfs, then it should not attempt to dedupe any part of t=
he
> > last extent of the file as the benefit would be zero or slightly negati=
ve.
>=20
> That's a filesystem implementation issue, not an API or application
> issue.

The API and application issue remains even if btrfs is not considered.
btrfs is just the worst case outcome.  Other filesystems still have
fragmentation issues, and applications have efficiency-vs-capability
tradeoffs to make if they can't rely on dedupe-to-EOF being available.

Tools like 'cp --reflink=3Dauto' work by trying the best case, then falling
back to a second choice if the first choice returns an error.  If the
second choice fails too, the surprising behavior can make inattentive
users lose data.

> > The app developer would need to be aware that such a restriction could
> > exist on some filesystems, and be able to distinguish this from other
> > cases that could lead to EINVAL.  Portable code would have to try a ded=
upe
> > up to EOF, then if that failed, round down and retry, and if that failed
> > too, the app would have to figure out which filesystem it's running on
> > to know what to do next.  Performance demands the app know what the FS
> > will do in advance, and avoid a whole class of behavior.
>=20
> Nobody writes "portable" applications like that.=20

As an app developer, and having studied other applications' revision
histories, and having followed IRC and mailing list conversations
involving other developers writing these applications, I can assure
you that is _exactly_ how portable applications get written around
the dedupe function.

Usually people start from experience with tools that use hardlinks to
implement dedupe, so the developer's mental model starts with deduping
entire files.  Their first attempt does this:

	stat(fd, &st);
	dedupe( ..., src_offset =3D 0, dst_offset =3D 0, length =3D st.st_size);

then subsequent revisions of their code cope with limits on length,
and then deal with EINVAL on odd lengths, because those are the problems
that are encountered as the code runs for the first time on an expanding
set of filesystems.  After that, they deal with implementation-specific
performance issues.

Other app developers start by ignoring incomplete blocks, then compare
their free-space-vs-time graphs with other dedupe apps on the same
filesystem, then either adapt to handle EOF properly, or just accept
being uncompetitive.

> They read the man
> page first, and work out what the common subset of functionality is
> and then code from that.=20

> Man page says:
>=20
> "Disk filesystems generally require the offset and length arguments
> to be aligned to the fundamental block size."

> IOWs, code compatible with starts with supporting the general case.
> i.e. a range rounded to filesystem block boundaries (it's already
> run fstat() on the files it wants to dedupe to find their size,
> yes?), hence ignoring the partial EOF block. Will just work on
> everything.

Will cause a significant time/space performance hit too.  EOFs are
everywhere, and they have a higher-than-average duplication rate
for their size.  If an application assumes EOF can't be deduped on
every filesystem, then it leaves a non-trivial amount of free space
unrecovered on filesystems that can dedupe EOF.  It also necessarily
increases fragmentation unless the filesystem implements file tails
(where it keeps fragmentation constant as the tail won't be stored
contiguously in any case).

> Code that then wants to optimise for btrfs/xfs/ocfs quirks runs
> fstatvfs to determine what fs it's operating on and applies the
> necessary quirks. For btrfs it can extend the range to include the
> partial EOF block, and hence will handle the implementation quirks
> btrfs has with single extent dedupe.
>=20
> Simple, reliable, and doesn't require any sort of flailing
> about with offsets and lengths to avoid unexpected EINVAL errors.

It would be better if the filesystem was given the EOF block by the
application if it is the application's intent to dedupe/clone the end
of the file.  If the filesystem isn't able to handle the EOF block, then
it can simply round the length down.  If the filesystem does handle the
EOF block specially then it simply does so.  This handles all the broken
btrfs behaviors as well as the behavior of better filesystems.

That is simple, reliable, doesn't require any sort of flailing about
with offsets and lengths to avoid unexpected EINVAL errors, and *also*
handles EOF consistently on all filesystems.

> > > > 	- should we just round down the EOF dedupe request to the
> > > > 	  block before EOF so dedupe still succeeds?
> > >=20
> > > I've often wondered if the interface should (have) be(en) that we sta=
rt
> > > at src_off/dst_off and share as many common blocks as possible until =
we
> > > find a mismatch, then tell userspace where we stopped... instead of l=
ike
> > > now where we compare the entire extent and fail if any part of it
> > > doesn't match.
> >=20
> > The usefulness or harmfulness of that approach depends a lot on what
> > the application expects the filesystem to do.
> >=20
> > In btrfs, the dedupe operation acts on references to data, not the
> > underlying data blocks.  If there are 1000 slightly overlapping referen=
ces
> > to a single contiguous range of data blocks in dst on disk, each dedupe
> > operation acts on only one of those, leaving the other 999 untouched.
> > If the app then submits 999 other dedupe requests, no references to the
> > dst blocks remain and the underlying data blocks can be deleted.
>=20
> Assuming your strawman is valid, if you have a thousand separate
> references across the same set of data blocks on disk, then that data is
> already heavily deduplicated.  Trying to optimise that further
> seems.... misguided, way down the curve of diminishing returns.

It is something that naive dedupe apps will do.  "naive" here meaning
"does not dive deeply into the filesystem's physical structure (or survey
the entire filesystem with FIEMAP) to determine that the thousand-refs
situation does not exist at dst prior to invoking the dedupe() call."

A lot of dedupe tools are just file tree walkers.  duperemove, bees, and
bedup are exceptions that look deeper into the filesystem structure, but
even duperemove can be configured to run as a simple file tree walker
to save time and memory (well, to spend time and memory
differently--nothing is ever free...).

File-tree-walking dedupe tools are typically given a collection of files
and told to locate duplicate data blocks inside the tree and use dedupe to
remove them.  These files may have already been deduped before by previous
runs of the tool, or by different tools, or by other block-sharing
filesystem primitives like clones or snapshots.  If a user does this
by accident:

	dedupe_tree_walker ... A/1/

	dedupe_tree_walker ... A/2/

	dedupe_tree_walker ... A

then the user not only hits the 'thousands of dst refs' case, but may
hit it thousands of times.  A/1 and A/2 will have lots of duplicate
blocks, but because they were deduped in separate runs, each tree
doesn't have references to the other tree's shared blocks.  The third
dedupe_tree_walker at the end will then present the kernel with src/dst
pairs that have thousands of refs to both src and dst.

If you plot the frequency of block contents on a histogram, there are
usually a few blocks that can appear thousands or even *millions* of
times per TB.

> XFS doesn't have partial overlaps, we don't have nodatacow hacks,
> and the subvol snapshot stuff I'm working on just uses shared data
> extents so it's 100% compatible with dedupe.

If you allow this sequence of operations, you get partial overlaps:

	dedupe(fd1, 0, fd2, 0, 1048576);

	dedupe(fd2, 16384, fd3, 0, 65536);

If you don't allow that, then you have more significant limitations
than I know what to do with from a dedupe application.

> [snip btrfs dedupe issues]
>=20
> Again, it just seems to me like the problems you are describing are
> complexity problems that arise from the filesystem implementation
> and all the hoops you have to jump through to work around them. It
> doesn't seem to have anything to do with problems in the dedupe
> API...

The current API man page doesn't explicitly say length can or cannot
include non-block-aligned EOF.  The original question was whether requests
to dedupe/clone unaligned EOF blocks should be allowed to return EINVAL,
and my answer is that they should not, because of accumulated experience
using historical versions of dedupe_file_range before and after
that change in behavior.

Unaligned EOF should always be accepted for dedupe, but a filesystem may
silently round down the length if the filesystem can't share a partial
block at EOF.  Note the dedupe man page already allows filesystems
to reduce the length without notice ("The maximum size of src_length
is filesystem dependent and is typically [i.e. not always] 16 MiB.
This limit will be enforced silently by the filesystem.").

If an app is relying on the "data differs" result to change app behavior
(merely printing the result doesn't count), then the app should already be
checking the length.  As far as I know I'm the only person who has written
such an app, and I didn't bother to publish it (it wasn't as fast as other
apps that invoke dedupe_file_range() only when they expect it to succeed).

I have no opinion on what should happen if offset + length !=3D st_size
for one or both files.  Any of DATA_DIFFERS, EINVAL, or dedupe success
with a reduced length is OK.  A typical dedupe app will avoid making
such a call intentionally, i.e. this case will only come up as a result
of losing a race with a change in file size.

For the clone case (specifically copy_file_range) it seems that from the
man page there is no expectation of EINVAL based on length alignment,
so a fallback to copy would be required if the filesystem can't share
blocks at EOF.

> > If we want to design a new interface, it should allow the app to specify
> > maximum and minimum length, so that the kernel knows how much flexibili=
ty
> > it is allowed by the application.  Maximum length lets one app say
> > "dedupe as much as you can find, up to EOF", while minimum length lets
> > another app say "don't bother if the match is less than 12K, the space
> > saving is not worth the write iops", and setting them equal lets the
> > third app say "I have a plan that requires you to do precisely what I
> > tell you or do nothing at all."
>=20
> OK, we didn't need a "btrfs is insane" story to justify this
> proposal=20

btrfs has a long list of issues, but many of the dedupe issues are
really problems that arise from manipulating shared references to blocks
in general.  Different filesystems can move the costs around (i.e. doing
more work inside the dedupe ioctl so it doesn't have to be done later by
other userspace or the kernel) but there are some pretty fundamental costs
common to any filesystem that implements CoW block sharing (e.g. data
fragmentation performance loss and/or extra iops for defragmentation if
dedupe is used too aggressively).

- it's an entirely reasonable set of control requests.
> IOWs, you want the current API (do exactly what I say),
> Darricks proposed API (do as much as you can) and a new behaviour
> (do at least this much) all rolled into one interface.

> So, cribbing from copy_file_range(), a syscall like:
>=20
> ssize_t dedupe_file_range(int fd_src, loff_t *off_src,
> 			 int fd_dst, loff_t *off_dst,
> 			 size_t len, unsigned int flags, u64 optval);
>=20
> With the control flags:
>=20
> #define DDFR_F_TRY		(0)	/* default: as much as possible */
> #define DDFR_F_EXACT		(1<<0)	/* exactly what is asked or fail */
> #define DDFR_F_MINLEN		(1<<1)	/* at least as much as optval says or fail =
*/
>=20
> And all return the number of bytes deduped in the range that was
> specified.

I think it would be a bad idea to make DDFR_F_TRY the default behavior--on
any filesystem.  It's not what any existing block-oriented dedupe app
design expects, or would even find useful if it was available.  It's a
special niche case that only works when you know in advance that you
have exactly two files (or big contiguous file offset ranges) and you
already know or suspect they are identical.

My unpublished app that used the "data_differs" response could have used
this behavior for this special case.  The original app was designed for
the special case of completely duplicate files, and looks like this:

	off_t find_next_same_block(int fd1, int fd2, off_t different_block, off_t =
file_size);

	for (pos =3D 0 .. file_size) {
		length =3D min(file_size - pos, SZ_16M);
		if (0 < (same_length =3D dedupe_file_range(fd1, &pos, fd2, &pos, length, =
DDFR_F_EXACT, 0))) {
			pos +=3D same_length;
		} else {
			// error handling deleted
			// skip over different blocks, or just exit here if we don't care
			pos =3D find_next_same_block(fd1, fd2, pos, file_size);
		}
	}

With DDFR_F_TRY, it would be changed to look like this:

	for (pos =3D 0 .. file_size) {
		length =3D file_size - pos;
		if (0 < (same_length =3D dedupe_file_range(fd1, &pos, fd2, &pos, length, =
DDFR_F_TRY, 0))) {
			// same_length is possibly different from (file_size - pos)
			// if we hit a different block somewhere, so keep looping
			pos +=3D same_length;
		} else {
			// error handling deleted
			// skip over different blocks, or just exit here if we don't care
			pos =3D find_next_same_block(fd1, fd2, pos, file_size);
		}
	}

In the case where the files are identical, the gain from eliding a few
loop iterations is negligible compared to the current API's DDFR_F_EXACT
behavior (microseconds per terabyte).

When there are differences between two files, the app may have to skip
over the different data, and that eats all the gains from making fewer
kernel calls for the duplicate data.  It's faster to do this with reads
than by calling the dedupe ioctl (with a DATA_DIFFERS result) because
reads require fewer and less expensive locks.

I've left out some other details in my simple two-file dedupe app: the
app looks at the structure of the file with FIEMAP, and occasionally
swaps src and dst fd's, or skips existing deduped ranges.  That behavior
doesn't work with DDFR_F_TRY at all.

Arguably we could just add more flags and behavior requirements
(DDFR_F_SWAP to swap src and dst FD automatically, and automatically
skip parts of src and dst that are already deduped) so that the kernel
does all this if requested.  In this case we would be building the
behavior of an entire simple file-oriented dedupe app into the kernel.
That seems like a lot of policy knobs given that these capabilities
1) already exist in userspace and 2) were abandoned by their author
for not being particularly performant or capable.

> Perhaps you'd like to write a man page describing how it should all
> work?

The expected behavior at EOF for the existing dedupe API should be
clearer.  I can contribute text for that.

The thing is, I like the existing dedupe as is.  It is useful precisely
because what it does is so tightly bounded.  Proposals like DDFR_F_MINLEN
are just responses to limit damage from other change proposals like
DDFR_F_TRY.  I see no pressing need for any of them.

I don't want to see what happened to the btrfs defrag ioctl happening to
the dedupe ioctl--there, the kernel accumulated so many quirky heuristics
that the ioctl became useless for any purpose other than implementing
'btrfs fi defrag', and I ended up having to emulate the defrag ioctl in
userspace to be able to combine it with dedupe.

For future development I've abandoned the entire dedupe_file_range
approach.  I need to be able to read and dedupe the data blocks of
the filesystem directly without having to deal with details like which
files those blocks belong to, especially on filesystems with lots of
existing deduped blocks and snapshots.  The file structure is frankly
just noise for dedupe on large filesystems.  I'm building a translation
layer for bees that does this--i.e. the main dedupe loop works only with
raw data blocks, and the translation layer maps read(blocknr, length)
and dedupe(block1, block2, length) requests onto the existing kernel
read(fd, offset, length) and dedupe(fd1, off1, fd2, off2, length) calls.
If the end result of that development work meets my performance
targets--I've built over a dozen dedupe apps, and only two were good
enough to release so far--then I'd propose moving those primitives into
the kernel.

> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com
>=20

--ik0NlRzMGhMnxrMX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCW4jN0gAKCRCB+YsaVrMb
nITYAJwOF5HTvdSnV7RX2B/PH0fFl6+LIgCdHnRKs5ul4rIFsKra3MzIuuhkwqE=
=E3uy
-----END PGP SIGNATURE-----

--ik0NlRzMGhMnxrMX--

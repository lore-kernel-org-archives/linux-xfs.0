Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46444 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725931AbeIGIcB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Sep 2018 04:32:01 -0400
Date: Thu, 6 Sep 2018 23:53:06 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Subject: Re: [patch] file dedupe (and maybe clone) data corruption (was Re:
 [PATCH] generic: test for deduplication between different files)
Message-ID: <20180907035305.GJ26989@hungrycats.org>
References: <20180817083924.16916-1-fdmanana@kernel.org>
 <20180819231126.GU2234@dastard>
 <20180820010932.GV2234@dastard>
 <20180820153349.GA4334@magnolia>
 <20180823125849.GF13528@hungrycats.org>
 <20180830062743.GF5631@dastard>
 <20180831051045.GI26989@hungrycats.org>
 <20180906083809.GF27618@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="N8NGGaQn1mzfvaPg"
Content-Disposition: inline
In-Reply-To: <20180906083809.GF27618@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, fdmanana@kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org


--N8NGGaQn1mzfvaPg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 06, 2018 at 06:38:09PM +1000, Dave Chinner wrote:
> On Fri, Aug 31, 2018 at 01:10:45AM -0400, Zygo Blaxell wrote:
> > On Thu, Aug 30, 2018 at 04:27:43PM +1000, Dave Chinner wrote:
> > > On Thu, Aug 23, 2018 at 08:58:49AM -0400, Zygo Blaxell wrote:
> > > > On Mon, Aug 20, 2018 at 08:33:49AM -0700, Darrick J. Wong wrote:
> > > > > On Mon, Aug 20, 2018 at 11:09:32AM +1000, Dave Chinner wrote:
> > > > > > 	- is documenting rejection on request alignment grounds
> > > > > > 	  (i.e. EINVAL) in the man page sufficient for app
> > > > > > 	  developers to understand what is going on here?
> > > > >=20
> > > > > I think so.  The manpage says: "The filesystem does not support
> > > > > reflinking the ranges of the given files", which (to my mind) cov=
ers
> > > > > this case of not supporting dedupe of EOF blocks.

[snip]

> tl;dr we don't need a new clone or dedupe API

Well, I wouldn't say _that_ yet.

It seems less likely that the API we need will be a minor revision of the
existing clone or dedupe and more likely that it will be a complementary
API for OOB dedupe engines, or a dedupe API that takes (device,
physical, length) tuples instead of (fd, offset, length) tuples.

> > For future development I've abandoned the entire dedupe_file_range
> > approach.  I need to be able to read and dedupe the data blocks of
> > the filesystem directly without having to deal with details like which
> > files those blocks belong to, especially on filesystems with lots of
> > existing deduped blocks and snapshots.=20
>=20
> IOWs, your desired OOB dedupe algorithm is:
>=20
> 	a) ask the filesystem where all it's file data is

Actually, it's "ask the filesystem where all the *new* file data is"
since we don't want to read any unique data twice on subsequent runs.

> 	b) read that used space to build a data hash index
> 	c) on all the data hash collisions find the owners of the
> 	   colliding blocks
> 	d) if the block data is the same dedupe it
>=20
> I agree - that's a simple and effective algorithm. It's also the
> obvious solution to an expert in the field.

It's obvious, but if you literally implement that, you end up with a
filesystem shattered into billions of fragments.

At step c) I need to figure out _which_ colliding block I want to keep.
That's where the algorithm needs to inspect the higher-level file
structure to determine the physical and logical situation for each block.
That leads to one of:

	a) store the hashes and block locations in the hash table
	b) relocate the blocks (defrag)
	c) replace some blocks with a reference to other blocks (dedupe)

This sounds a bit like what xfs_fsr does (or will do?).

Bees also operates under a constant-RAM constraint, so it doesn't operate
in two distinct "collect data" and "act on data collected" passes,
and cannot spend memory to store data about more than a few extents at
any time.  bees dedupes contiguous blocks pairwise as the second duplicate
block is discovered--sometimes keeping the second block, if the selection
algorithm prefers new blocks over blocks previously encountered (e.g. if
a defragmented version of an extent comes along, and we don't want to
undo the defrag operation by deduping non-defragged extents over it).

This does not produce the fastest possible OOB dedupe result--that comes
=66rom an algorithm that does operate in two passes and sorts duplicate
extents by length between the passes.  The fast algorithm produces a
free space vs time curve that starts with a long flat interval followed
by a steep slope that gradually flattens over time, and is suitable
for filesystems that are small enough that the entire filesystem can
be processed in a batch run.  The bees algorithm produces a continuous
straight-ish line that is more suitable for continuous incremental
operation using O(1) memory.

> > The file structure is frankly
> > just noise for dedupe on large filesystems.
>=20
> We learnt that lesson back in the late 1990s. xfsdump, xfs_fsr, all
> the SGI^WHPE HSM scanning tools, etc all avoid the directory
> structure because it's so slow. XFS's bulkstat interface, OTOH, can
> scan for target inodes at a over a million inodes/sec if you've got
> the IO and CPU to throw at it....

A million inodes/sec?  btrfs TREE_SEARCH_V2 barely manages 2000 inodes/sec
on a 2.2GHz AMD A6--and that's just in the kernel, not counting delivery
of the data to userspace.  I'm clearly using the wrong filesystem here.

> > I'm building a translation
> > layer for bees that does this--i.e. the main dedupe loop works only with
> > raw data blocks, and the translation layer maps read(blocknr, length)
> > and dedupe(block1, block2, length) requests onto the existing kernel
> > read(fd, offset, length) and dedupe(fd1, off1, fd2, off2, length)i
>=20
> That's FS_IOC_GETFSMAP. :P

No, that's the layer that _uses_ FS_IOC_GETFSMAP.  ;)

> FYI, in 2012 I came up with a plan for dedupe in XFS:
>=20
> 	a) GETFSMAP to query reverse map tree to find file
> 	   data blocks (don't try to dedupe unused space)
> 	b) read the underlying block device in ascending block
> 	   order and hash each block to build a collision tree.
> 	   Trivially parallelised.
> 	c) GETFSMAP to query rmap for the owners of colliding
> 	   blocks
> 	d) For all file data owner maps of a colliding block
> 		- bulkstat the inode numbers returned by GETFSMAP
> 		  and open_by_handle to get fd's
> 		- run dedupe syscall

I think steps c and d show room for improvement.

I'd like the filesystem to receive a pair of contiguous colliding block
ranges, and have the filesystem locate and update all the owners at once
after performing the comparison (skip updating any owners that have
changed after the comparison).  That effectively merges c and d into
a single syscall.  There are a few advantages to doing it this way,
especially when it comes to requirements for locking (e.g. no need to
lock files against modification during the block compare).

With the existing dedupe syscall, the app has to dig up from the (device,
physical) tuple through the filesystem to get (fd, offset) tuples to pass
to dedupe, which will dig down through the filesystem to turn them back
into (device, physical) tuples again for comparison and then dig back
up again to modify the (inode, offset) tuples for any other references.
It seems like the filesystem could skip one leg of this journey if it
starts with the block address.  If the data changed underneath so the
comparison fails, none of the other work is necessary, and most of the
other work requires seeks.

> You've taken a dozen or so failures to realise what was obvious to
> me at the outset

It was obvious to me too; however, I have to deliver a dedupe engine that
doesn't blow up the system it's running on, and calling LOGICAL_INO on
btrfs more than absolutely necessary has historically been a bad idea.

I tried many alternatives to avoid this (basically ordering the dedupe
syscalls to try to converge on the correct result eventually), but some
use cases (especially snapshots) cannot be done sanely any other way,
so I'm pressing ahead with pure physical block addressing and hoping
that the filesystems catch up.

> - your translation layer will essentially hold the
> same information that XFS already maintains on disk in it's rmap
> btrees. IIRC btrfs has semi-equivalent reverse mapping functionality
> on disk (back pointers?), so maybe your best bet would be to
> implement FSMAP for btrfs and then you have a dedupe app that works
> efficiently on both XFS and btrfs...

btrfs has LOGICAL_INO_V2 and TREE_SEARCH_V2 ioctls which provide the
same sort of data as GETFSMAP in a differently structured address space.
INO_PATHS lets me implement an equivalent of open_by_handle.

The existing translation layer in bees uses the information in the
existing filesystem structures to map logical to physical and back
as required.  The new translation layer operates _only_ in the physical
space at the top, so as far as the core dedupe/defrag engine is concerned,
the filesystem underneath is just an iterable collection of contiguous
data extents that can be read and deduped directly.

The only data bees stores outside of the filesystem is the dedupe block
hash table, the current value of the extent iterator (aka the low key for
the next GETFSMAP call), and the transid of the filesystem the last time
the extent iterator was reset.  btrfs embeds the transid (an indicator
of age) into every data extent record and into metadata page headers, so
bees can rapidly skip old extents in SEARCH_V2 for fast incremental scans.

The translation layer can work as long as every physical block has a
unique address in a data type that has addition, subtraction, less-than
and bisection operators, and the filesystem can map a position in physical
address space to a position in logical address space and back.  I only
need bisection for cases that require backward iteration from a known
key (btrfs csums require this, and the new translation layer enables the
dedupe code to use the existing csums instead of reading and hashing the
data blocks).

On btrfs I open the files to do reading instead of scraping the
block device directly--IMHO a reasonable decision, given that btrfs
implements RAID and compression to make raw block read from a device
very complicated.  Profiling so far has never shown open() to have
significant overhead compared to the other operations; however, if
btrfs had a "I am root, read this arbitrary data block for me" ioctl,
I'd eliminate even that little overhead.

It looks like "open device, seek to physical, read block" is sufficient
for XFS (no compression or other encoding to worry about).

btrfs uses a 64-bit virtual address space (compatible with FIEMAP),
GETFSMAP uses a 32-bit device ID and a 64-bit offset.  This means all
bees DDT entries are immediately 25% bigger on XFS, unless I enumerate the
device IDs and recycle some zero bits in .physical as a device ID index.

I wonder if a future btrfs implementation of GETFSMAP will use the
device ID and physical offset fields, or just return a constant device
ID with .physical carrying the 64-bit virtual address that the rest of
the filesystem uses.

I wonder how compressed data would work with GETFSMAP?  In btrfs the
LOGICAL_INO and FIEMAP ioctls treat the entire compressed extent as a
single entity with no distinct blocks inside.  Bees needs a unique address
for every block, even the compressed ones, so some of that is handled
by emulation using TREE_SEARCH_V2 in the translation layer (the physical
data type is 64-bit extent base plus an uncompressed block offset).

> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com
>=20

--N8NGGaQn1mzfvaPg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCW5H2HgAKCRCB+YsaVrMb
nO44AKCOKyD7XfD+uPnKcTRJcnhgcGhZ/QCgyvA7oiP/M7I30rAiIJbVx9C5o5M=
=3e+h
-----END PGP SIGNATURE-----

--N8NGGaQn1mzfvaPg--

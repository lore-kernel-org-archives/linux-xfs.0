Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46972 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726143AbeHXFvx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Aug 2018 01:51:53 -0400
Date: Thu, 23 Aug 2018 22:19:25 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Subject: Re: [patch] file dedupe (and maybe clone) data corruption (was Re:
 [PATCH] generic: test for deduplication between different files)
Message-ID: <20180824021925.GH13528@hungrycats.org>
References: <20180817083924.16916-1-fdmanana@kernel.org>
 <20180819231126.GU2234@dastard>
 <20180820010932.GV2234@dastard>
 <20180820153349.GA4334@magnolia>
 <20180823125849.GF13528@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="nFBW6CQlri5Qm8JQ"
Content-Disposition: inline
In-Reply-To: <20180823125849.GF13528@hungrycats.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, fdmanana@kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org


--nFBW6CQlri5Qm8JQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 23, 2018 at 08:58:49AM -0400, Zygo Blaxell wrote:
> On Mon, Aug 20, 2018 at 08:33:49AM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 20, 2018 at 11:09:32AM +1000, Dave Chinner wrote:
> > >   - should we just round down the EOF dedupe request to the
> > >     block before EOF so dedupe still succeeds?
> >=20
> > I've often wondered if the interface should (have) be(en) that we start
> > at src_off/dst_off and share as many common blocks as possible until we
> > find a mismatch, then tell userspace where we stopped... instead of like
> > now where we compare the entire extent and fail if any part of it
> > doesn't match.
>=20
> The usefulness or harmfulness of that approach depends a lot on what
> the application expects the filesystem to do.

Here are some concrete examples.

In the following, letters are 4K disk blocks and also inode offsets
(i.e. "A" means a block containing 4096 x "A" located at inode offset 0,
"B" contains "B" located at inode offset 1, etc).  "|" indicates
a physical discontinuity of the blocks on disk.  Lowercase "a" has
identical content to uppercase "A", but they are located in different
physical blocks on disk.

Suppose you have two identical files with different write histories,
so they have different on-disk layouts:

        Inode 1:  ABCDEFGH|IJ|KL|M|N|O|PQ|RST|UV|WX|YZ

        Inode 2:  a|b|c|d|e|f|g|hijklmnopqrstuvwxyz

A naive dedupe app might pick src and dst at random, and do this:

        // dedupe(length, src_ino, src_off, dst_ino, dst_off)

        dedupe(length 26, Inode 1, Offset 0, Inode 2, Offset 0)

with the result having 11 fragments in each file, all from the
original Inode 1:

        Inode 1:  ABCDEFGH|IJ|KL|M|N|O|PQ|RST|UV|WX|YZ

        Inode 2:  ABCDEFGH|IJ|KL|M|N|O|PQ|RST|UV|WX|YZ

A smarter dedupe app might choose src and dst based on logical proximity
and/or physical seek distance, or the app might choose dst with the
smallest number of existing references in the filesystem, or the app might
simply choose the longest available src extents to minimize fragmentation:

        dedupe(length 7, Inode 1, Offset 0, Inode 2, Offset 0)

        dedupe(length 19, Inode 2, Offset 7, Inode 1, Offset 7)

with the result having 2 fragments in each file, each chosen
=66rom a different original inode:

        Inode 1:  ABCDEFG|hijklmnopqrstuvwxyz

        Inode 2:  ABCDEFG|hijklmnopqrstuvwxyz

If the kernel continued past the 'length 7' size specified in the first
dedupe, then the 'hijklmnopqrstuvwxyz' would be *lost*, and the second
dedupe would be an expensive no-op because both Inode 1 and Inode 2
refer to the same physical blocks:

        Inode 1:  ABCDEFGH|IJ|KL|M|N|O|PQ|RST|UV|WX|YZ

                  [-------] - app asked for this
        Inode 2:  ABCDEFGH|IJ|KL|M|N|O|PQ|RST|UV|WX|YZ
    kernel does this too - [-------------------------]
    and "hijklmnopqrstuvwxyz" no longer exists for second dedupe

A dedupe app willing to spend more on IO can create its own better src
with only one fragment:

        open(with O_TMPFILE) -> Inode 3

        copy(length 7, Inode 1, Offset 0, Inode 3, Offset 0)
       =20
        copy(length 19, Inode 2, Offset 7, Inode 3, Offset 7)

        dedupe(length 26, Inode 3, Offset 0, Inode 1, Offset 0)

        dedupe(length 26, Inode 3, Offset 0, Inode 2, Offset 0)

        close(Inode 3)

Now there is just one fragment referenced from two places:

        Inode 1:  =CE=B1=CE=B2=CE=BE=CE=B4=CE=B5=CF=86=CE=B3=CE=B7=CE=B9=CF=
=82=CE=BA=CE=BB=CE=BC=CE=BD=CE=BF=CF=80=CE=B8=CF=81=CF=83=CF=84=CF=85=D0=B2=
=D1=88=CF=87=CF=88=CE=B6

        Inode 2:  =CE=B1=CE=B2=CE=BE=CE=B4=CE=B5=CF=86=CE=B3=CE=B7=CE=B9=CF=
=82=CE=BA=CE=BB=CE=BC=CE=BD=CE=BF=CF=80=CE=B8=CF=81=CF=83=CF=84=CF=85=D0=B2=
=D1=88=CF=87=CF=88=CE=B6

[If encoding goes horribly wrong, the above are a-z transcoded as a mix
of Greek and Cyrillic Unicode characters.]

Real filesystems sometimes present thousands of possible dedupe
src/dst permutations to choose from.  The kernel shouldn't be trying to
second-guess an application that may have access to external information
to make better decisions (e.g. the full set of src extents available,
or knowledge of other calls the app will issue in the future).

> In btrfs, the dedupe operation acts on references to data, not the
> underlying data blocks.  If there are 1000 slightly overlapping references
> to a single contiguous range of data blocks in dst on disk, each dedupe
> operation acts on only one of those, leaving the other 999 untouched.
> If the app then submits 999 other dedupe requests, no references to the
> dst blocks remain and the underlying data blocks can be deleted.
>=20
> In a parallel universe (or a better filesystem, or a userspace emulation
> built out of dedupe and other ioctls), dedupe could work at the extent
> data (physical) level.  The app points at src and dst extent references
> (inode/offset/length tuples), and the filesystem figures out which
> physical blocks these point to, then adjusts all the references to the
> dst blocks at once, dealing with partial overlaps and snapshots and
> nodatacow and whatever other exotic features might be lurking in the
> filesystem, ending with every reference to every part of dst replaced
> by the longest possible contiguous reference(s) to src.
>=20
> Problems arise if the length deduped is not exactly the length requested.
> If the search continues until a mismatch is found, where does the search
> for a mismatch lead?  Does the search follow physically contiguous
> blocks on disk, or would dedupe follow logically contiguous blocks in
> the src and dst files?  Or the intersection of those, i.e. physically
> contiguous blocks that are logically contiguous in _any_ two files,
> not limited to src and dst.
>=20
> There is also the problem where the files could have been previously
> deduped and then partially overwritten with identical data.  If the
> application cannot control where the dedupe search for identical data
> ends, it can end up accidentally creating new references to extents
> while it is trying to eliminate those extents.  The kernel might do a
> lot of extra work from looking ahead that the application has to undo
> immediately (e.g. after the first few blocks of dst, the app wants to
> do another dedupe with a better src extent elsewhere on the filesystem,
> but the kernel goes ahead and dedupes with an inferior src beyond the
> end of what the app asked for).
>=20
> bees tries to determine exactly the set of dedupe requests required to
> remove all references to duplicate extents (and maybe someday do defrag
> as well).  If the kernel deviates from the requested sizes (e.g. because
> the data changed on the filesystem between dedup requests), the final
> extent layout after the dedupe requests are finished won't match what
> bees expected it to be, so bees has to reexamine the filesystem and
> either retry with a fresh set of exact dedupe requests, or give up and
> leave duplicate extents on disk.  The retry loop is normal and ends
> quickly if the dedupe fails because data changed on disk, but if the
> kernel starts messing with the dedupe lengths then bees has to detect
> this and escape before it gets stuck in a nasty feedback loop.
>=20
> If we want to design a new interface, it should allow the app to specify
> maximum and minimum length, so that the kernel knows how much flexibility
> it is allowed by the application.  Maximum length lets one app say
> "dedupe as much as you can find, up to EOF", while minimum length lets
> another app say "don't bother if the match is less than 12K, the space
> saving is not worth the write iops", and setting them equal lets the
> third app say "I have a plan that requires you to do precisely what I
> tell you or do nothing at all."
>=20
> > > 	- should file cloning (i.e. reflink) be allow allowing the
> > > 	  EOF block to be shared somewhere inside EOF in the
> > > 	  destination file?
> >=20
> > I don't think we should.
> >=20
> > > That's stale data exposure, yes?
> >=20
> > Haven't tested that, but seems likely.
>=20
> It doesn't sound like a good idea, especially if mmap is involved.
>=20
> > > 	- should clone only allow sharing of the EOF block if it's a
> > > 	  either a full file clone or a matching range clone and
> > > 	  isize is the same for both src and dest files?
> >=20
> > The above sound reasonable for clone, though I would also allow clone to
> > share the EOF block if we extend isize of the dest file.
> >=20
> > The above also nearly sound reasonable for dedupe too.  If we encounter
> > EOF at the same places in the src range and the dest range, should we
> > allow sharing there?  The post-eof bytes are undefined by definition;
> > does undefined =3D=3D undefined?
>=20
> > >=20
> > > Discuss.
> > >=20
> > > Cheers,
> > >=20
> > > Dave.
> > > --=20
> > > Dave Chinner
> > > david@fromorbit.com
> > >=20
> > >=20
> > > [RFC] vfs: fix data corruption w/ unaligned dedupe ranges
> > >=20
> > > From: Dave Chinner <dchinner@redhat.com>
> > >=20
> > > Exposed by fstests generic/505 on XFS, caused by extending the
> > > bblock match range to include the partial EOF block, but then
> > > allowing unknown data beyond EOF to be considered a "match" to data
> > > in the destination file because the comparison is only made to the
> > > end of the source file. This corrupts the destination file when the
> > > source extent is shared with it.
> > >=20
> > > Open questions:
> > >=20
> > > 	- is documenting rejection on request alignment grounds
> > > 	  (i.e. EINVAL) in the man page sufficient for app
> > > 	  developers to understand what is going on here?
> > > 	- should we just silently round down the EOF dedupe request
> > > 	  to the block before EOF so dedupe still succeeds?
> > > 	- should file cloning (i.e. reflink) be allow allowing the
> > > 	  EOF block to be shared somewhere inside EOF in the
> > > 	  destination file? That's stale data exposure, yes?
> > > 	- should clone only allow sharing of the EOF block if it's a
> > > 	  either a full file clone or a matching range clone and
> > > 	  isize is the same for both src and dest files?
> > >=20
> > > Btrfs also has the same bug in extent_same_check_offsets() and
> > > btrfs_extent_same_range() that is not addressed by this patch.
> >=20
> > <nod> (xfs/ocfs2) clone ioctls tend to be bug-for-bug compatible with
> > btrfs more often than we probably ought to... :/
> >=20
> > (I also sorta wonder if btrfs should be ported to the common vfs
> > routines for clone prep and dedupe comparison...?)
> >=20
> > --D
> >=20
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/read_write.c | 13 +++++++++++--
> > >  1 file changed, 11 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/fs/read_write.c b/fs/read_write.c
> > > index 153f8f690490..3844359a4597 100644
> > > --- a/fs/read_write.c
> > > +++ b/fs/read_write.c
> > > @@ -1768,8 +1768,17 @@ int vfs_clone_file_prep_inodes(struct inode *i=
node_in, loff_t pos_in,
> > >  			return -EINVAL;
> > >  	}
> > > =20
> > > -	/* If we're linking to EOF, continue to the block boundary. */
> > > -	if (pos_in + *len =3D=3D isize)
> > > +	/* Reflink allows linking to EOF, so round the length up to allow u=
s to
> > > +	 * shared the last block in the file. We don't care what is beyond =
the
> > > +	 * EOF point in the block that gets shared, as we can't access it a=
nd
> > > +	 * attempts to extent the file will break the sharing.
> > > +	 *
> > > +	 * For dedupe, sharing the EOF block is illegal because the bytes b=
eyond
> > > +	 * EOF are undefined (i.e. not readable) and so can't be deduped. H=
ence
> > > +	 * we do not extend/align the length and instead let the alignment
> > > +	 * checks below reject it.
> > > +	 */
> > > +	if (!is_dedupe && pos_in + *len =3D=3D isize)
> > >  		blen =3D ALIGN(isize, bs) - pos_in;
> > >  	else
> > >  		blen =3D *len;



--nFBW6CQlri5Qm8JQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCW39rKAAKCRCB+YsaVrMb
nP52AJ0Zhfwh2eYAkpqbNnZJh1ckJakJaQCfSvtwJdFMwlDCrvyRK0EhICDr3GY=
=rAZN
-----END PGP SIGNATURE-----

--nFBW6CQlri5Qm8JQ--

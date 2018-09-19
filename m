Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:35070 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725870AbeISJsD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Sep 2018 05:48:03 -0400
Date: Wed, 19 Sep 2018 00:12:03 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Subject: Re: [patch] file dedupe (and maybe clone) data corruption (was Re:
 [PATCH] generic: test for deduplication between different files)
Message-ID: <20180919041203.GA11397@hungrycats.org>
References: <20180817083924.16916-1-fdmanana@kernel.org>
 <20180819231126.GU2234@dastard>
 <20180820010932.GV2234@dastard>
 <20180820153349.GA4334@magnolia>
 <20180823125849.GF13528@hungrycats.org>
 <20180830062743.GF5631@dastard>
 <20180831051045.GI26989@hungrycats.org>
 <20180906083809.GF27618@dastard>
 <20180907035305.GJ26989@hungrycats.org>
 <20180910090646.GB5631@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <20180910090646.GB5631@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, fdmanana@kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 10, 2018 at 07:06:46PM +1000, Dave Chinner wrote:
> On Thu, Sep 06, 2018 at 11:53:06PM -0400, Zygo Blaxell wrote:
> > On Thu, Sep 06, 2018 at 06:38:09PM +1000, Dave Chinner wrote:
> > > On Fri, Aug 31, 2018 at 01:10:45AM -0400, Zygo Blaxell wrote:
> > > > On Thu, Aug 30, 2018 at 04:27:43PM +1000, Dave Chinner wrote:
> > > > > On Thu, Aug 23, 2018 at 08:58:49AM -0400, Zygo Blaxell wrote:
> > > > For future development I've abandoned the entire dedupe_file_range
> > > > approach.  I need to be able to read and dedupe the data blocks of
> > > > the filesystem directly without having to deal with details like wh=
ich
> > > > files those blocks belong to, especially on filesystems with lots of
> > > > existing deduped blocks and snapshots.=20
> > >=20
> > > IOWs, your desired OOB dedupe algorithm is:
> > >=20
> > > 	a) ask the filesystem where all it's file data is
> >=20
> > Actually, it's "ask the filesystem where all the *new* file data is"
> > since we don't want to read any unique data twice on subsequent runs.
>=20
> Sorry, how do you read "unique data" twice? By definition, unique
> data only occurs once....

=2E..but once it has been read, we don't want to read it again.  Ever.
Even better would be to read unique data less than 1.0 times on average.

> Oh, and you still need to hash the old data so you can find
> collisions with the new data that got written. Unless, of course,
> you are keeping your hash tree in a persistent database=20

I do that.

> and can work out how to prune stale entries out of it efficiently....

I did that first.

Well, more like I found that even a bad algorithm can still find
most of the duplicate data in a typical filesystem, and there's a
steep diminishing returns curve the closer you get to 100% efficiency.
So I just used a bad algorithm (random drop with a bias toward keeping
hashes that matched duplicate blocks).  There's room to improve that,
but the possible gains are small, so it's at least #5 on the performance
whack-a-mole list and probably lower.

The randomness means each full-filesystem sweep finds a different subset
of duplicates, so I can arbitrarily cut hash table size in half and get
almost all of the match rate back by doing two full scans.  Or I cut
the filesystem up into a few large pieces and feed the pieces through in
different orders on different scan runs, so different subsets of data in
the hash table meet different subsets of data on disk during each scan.
An early prototype of bees worked that way, but single-digit efficiency
gains were not worth doubling iops, so I stopped.

> [...]I thought that "details omitted for
> reasons of brevity" would be understood, not require omitted details
> to be explained to me.

Sorry.  I don't know what you already know.

> > Bees also operates under a constant-RAM constraint, so it doesn't opera=
te
> > in two distinct "collect data" and "act on data collected" passes,
> > and cannot spend memory to store data about more than a few extents at
> > any time.
>=20
> I suspect that I'm thinking at a completely different scale to you.
> I don't really care for highly constrained or optimal dedupe
> algorithms  because those last few dedupe percentages really don't
> matter that much to me.=20

At large scales RAM is always constrained.  It's the dedupe triangle of
RAM, iops, and match hit rate--any improvement in one comes at the cost
of the others.  Any dedupe can go faster or use less RAM by raising the
block size or partitioning the input data set to make it smaller.

bees RAM usage is a bit more explicitly controlled--the admin tells bees
how much RAM to use, and bees scales the other parameters to fit that.
Other dedupe engines make the admin do math to set parameters to avoid
overflowing RAM with dynamic memory allocations, or leave the admin to
discover what their RAM constraint is the hard way.

One big difference I am noticing in our approaches is latency.  ZFS (and
in-kernel btrfs dedupe) provides minimal dedupe latency (duplicate
data occupies disk space for zero time as it is never written to disk
at all) but it requires more RAM for a given dedupe hit rate than any
other dedupe implementation I've seen.  What you've written tells me
XFS saves RAM by partitioning the data and relying on an existing but
very large source of iops (sharing scrub reads with dedupe), but then
the dedupe latency is the same as the scrub interval (the worst so far).
bees aims to have latency of a few minutes (ideally scanning data while
it's still dirty in cache, but there's no good userspace API for that)
though it's obviously not there yet.

> I care much more about using all the
> resources we can and running as fast as we possibly can, then
> providing the admin with means to throttle performance back to what
> they need.
>=20
> i.e. I'm concerned about how to effectively scan and dedupe PBs of
> data, where scan rates may need to be measured in tens of GB/s. =20

My targets are only one order of magnitude smaller--in the limit, I expect
bees will eventually reach a point where it has matched the btrfs scaling
limits and can go no further (I've bumped into some of them already).

I do have a very different latency goal and different optimization
opportunities because of different capabilities in the filesystems.

> In these cases the limiting factor is either suboptimal IO patterns
> (low IO throughput), or not having enough CPU and memory bandwidth
> for hashing the data the IO engine is streaming through memory.
> Once we get past a certain point, we'll gain far more by
> parallelising the dedupe scan over lots of CPU than we ever will by
> optimising an algorithm that cannot be parallelised.=20
> Hence we need to start with a parallelisable algorithm, not an artificial=
ly
> constrained one.

It's possible to parallelize reads on btrfs, it's just much more work
to get it done than on XFS.  I'll get around to that eventually, but
right now the gains are relatively small relative to the work required
to implement it.

> e.g. a soft requirement is that we need to scan the entire fs at
> least once a month.=20

I have to scan and dedupe multiple times per hour.  OK, the first-ever
scan of a non-empty filesystem is allowed to take much longer, but after
that, if you have enough spare iops for continuous autodefrag you should
also have spare iops for continuous dedupe.

btrfs has age information embedded in the metadata so I can skip scanning
blocks (or entire subtrees) that have not changed since an earlier scan.
This is the "read unique data only once" feature I'm working on.
That can be batched up and run during maintenance windows (one of bees'
most-requested features).

A lot of duplicate data tends to occur close together in time, so
sorting the data by age can also stretch the efficiency of a self-pruning
hash table.

> That will need to be broken up into nightly
> work, with a full 1PB filesystem needing 33+TB a night to be
> scanned. We typically get 1 hour a night to do this sort of thing,
> meaning the dedupe scan rate needs to sustain 1GB/s for that entire
> hour.  Doing this with a single threaded, few extents at a time
> algorithm is going to be a real stretch, so we need RAM and
> concurrency at both the IO and CPU level to acheive this.

On btrfs I can read the block checksums instead of the block data,
eliminating the need to read trivially unique data during scanning (i.e. I
only have to read a data block to calculate a strong hash after at least
one checksum collision).  This is the "read unique data less than once"
feature.

Parallel reading is around #4 on my performance whack-a-mole list.  #1 and
#2 are "read unique data less than once" and #3 is fixing sequential
reads (and somewhere in there is optimizing the scheduling of dedupe vs
scan so they don't slow each other down by seeking and probably half a
dozen btrfs workarounds).  The current read code is just a placeholder
=66rom the first prototype version of bees.  It burns egregious amounts
of CPU to work, but even that code is not the top of the performance
whack-a-mole list today.

Eventually bees will need fast raw parallel reading and maybe divide
big filesystems into smaller chunks for the first read (where bees
can't optimize by ignoring unchanged data).  Maybe btrfs will catch
up on big-filesystem performance, e.g. so that mounting a half-full PB
filesystem takes less than an hour and write amplification is below 1000%.
Maybe by then XFS will have checksums of data (maybe even with a lower
collision rate than crc32) and be able to efficiently select extents by
age so it doesn't have to burn petabytes of iops every month.  If the
feature sets converge, at that point XFS dedupe will probably be faster
just because it doesn't have to work around btrfs...  :-P

> A simple piece-wise per-AG scanning algorithm (like we use in
> xfs_repair) could easily work within a 3GB RAM per AG constraint and
> would scale very well. We'd only need to scan 30-40 AGs in the hour,
> and a single AG at 1GB/s will only take 2 minutes to scan. We can
> then do the processing while the next AG gets scanned. If we've got
> 10-20GB RAM to use (and who doesn't when they have 1PB of storage?)
> then we can scan 5-10AGs at once to keep the IO rate up, and process
> them in bulk as we scan more.

How do you match dupe blocks from different AGs if you only keep RAM for
the duration of one AG scan?  Do you not dedupe across AG boundaries?

I ask because one of the things I am deduping is multi-terabyte VM images,
and an AG sounds like it's smaller than one of those.

The algorithm could dump the sorted hash table (or just the blocks known
to be duplicates which is usually a much smaller list) to a file after
each AG, and merge the sorted hash tables to dedupe across AGs...unless
there's a gotcha there that makes dedupe across AGs undesirable or
impossible?

> Then consider that we can use that slowly iterating nightly dedupe
> block scan to replace the online media scrubber. i.e. We get a
> storage bitrot detecting scan for free with such a OOB dedupe
> algorithm.  That's a massive win for enterprise filesystems - we
> can cram all our maintenance tasks (defrag, scrubbing and dedupe)
> into a single nightly scan, then it's highly predictable and
> repeatable behaviour that admins can plan for and save themselves a
> lot of unnecessary pain.

That is a compelling argument for always doing the full-filesystem
dedupe scan even if you don't have to.

That gives me an idea to use later:  btrfs scrub is already parallelized
across devices.  Maybe btrfs scrub could be adapted to share the data
with userspace (as opposed to userspace trying to duplicate all the RAID
repair things that btrfs scrub does).  Then dedupe just follows the scrub
through the filesystem and resolves hash collisions as it goes (or queues
them up for later processing in sorted batches to minimize seeking).

> Yeah, 2.1GHZ Xeons can scan ~200,000 inodes/s each when CPU bound,
> and the above number comes from bulkstating 8 different AGs in
> parallel on a 100 million inode, 500TB filesystem. It's limited by
> lock contention on the sb inode list lock, so fixing that will allow
> it to go faster.
>=20
> > btrfs TREE_SEARCH_V2 barely manages 2000 inodes/sec on a 2.2GHz
> > AMD A6--and that's just in the kernel, not counting delivery of
> > the data to userspace.  I'm clearly using the wrong filesystem
> > here.
>=20
> Perhaps so.

Indeed.  Implement compression, online shrinking, data checksums, and
self-repair, and we can talk migrations.  ;)

[...]
> > I'd like the filesystem to receive a pair of contiguous colliding block
> > ranges, and have the filesystem locate and update all the owners at once
> > after performing the comparison (skip updating any owners that have
> > changed after the comparison).
>=20
> I'd like a pony, too.

I have friends with an assortment of horses.  What kind of pony would
you like?  ;)

> However, I think that such bottom up operations are nearly
> impossible to do atomically because they invert the locking orders
> of normal operations and are completely open-ended in scope in what
> they may need to update. =20

I don't think it needs to be atomic at all.  dedupe only needs a way
to know if it has lost a race and continue gracefully, and that can be
as simple as looping over each dst owner object in turn and atomically
asking "do you still own the data I compared?  If so, I update you to own
the other copy; otherwise, I skip you and move on with the next owner."

If the filesystem has CoW semantics (i.e. data blocks are read-only until
deleted) this is a matter of comparing block addresses in metadata to
see if they changed after the block read/compare operation.  There would
need to be a lock on the data extents to prevent deletion during the
dedupe call, or a generation number on the data extent that could be
compared to detect modification after the fact, but there _wouldn't_ be
deadlocks on inodes that arise from the current top-down implementation
(e.g. dedupe and rename on the same two inodes).

If any owner changes are missed--which can only happen if there happens
to be a concurrent data update on that specific data--the next dedupe scan
can deal with it.  In fact it probably has to, since there is new data.

What you've described so far means the scope isn't limited anyway.  If the
call is used to dedupe two heavily-reflinked extents together (e.g.
both duplicate copies are each shared by thousands of snapshots that
have been created during the month-long period between dedupe runs),
it could always be stuck doing a lot of work updating dst owners.
Was there an omitted detail there?

> Cheers,
>=20
> Dave,
> --=20
> Dave Chinner
> david@fromorbit.com

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCW6HMjgAKCRCB+YsaVrMb
nOUTAJwMAasf/fz3HOadd9llsTipAlcVTQCgi9rf9YBP3H/u6DDQzl+kxAh0OdE=
=nrpB
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--

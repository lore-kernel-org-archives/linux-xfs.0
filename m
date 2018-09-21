Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36418 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726160AbeIUK1U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Sep 2018 06:27:20 -0400
Date: Fri, 21 Sep 2018 00:40:13 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Subject: Re: [patch] file dedupe (and maybe clone) data corruption (was Re:
 [PATCH] generic: test for deduplication between different files)
Message-ID: <20180921044013.GD11392@hungrycats.org>
References: <20180820010932.GV2234@dastard>
 <20180820153349.GA4334@magnolia>
 <20180823125849.GF13528@hungrycats.org>
 <20180830062743.GF5631@dastard>
 <20180831051045.GI26989@hungrycats.org>
 <20180906083809.GF27618@dastard>
 <20180907035305.GJ26989@hungrycats.org>
 <20180910090646.GB5631@dastard>
 <20180919041203.GA11397@hungrycats.org>
 <20180921025931.GI16550@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="iVCmgExH7+hIHJ1A"
Content-Disposition: inline
In-Reply-To: <20180921025931.GI16550@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, fdmanana@kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org


--iVCmgExH7+hIHJ1A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 21, 2018 at 12:59:31PM +1000, Dave Chinner wrote:
> On Wed, Sep 19, 2018 at 12:12:03AM -0400, Zygo Blaxell wrote:
[...]
> With no DMAPI in the future, people with custom HSM-like interfaces
> based on dmapi are starting to turn to fanotify and friends to
> provide them with the change notifications they require....

I had a fanotify-based scanner once, before I noticed btrfs effectively
had timestamps all over its metadata.

fanotify won't tell me which parts of a file were modified (unless it
got that feature in the last few years?).  fanotify was pretty useless
when the only file on the system that was being modified was a 13TB
VM image.  Or even a little 16GB one.  Has to scan the whole file to
find the one new byte.  Even on desktops the poor thing spends most of
its time looping over /var/log/messages.  It was sad.

If fanotify gave me (inode, offset, length) tuples of dirty pages in
cache, I could look them up and use a dedupe_file_range call to replace
the dirty pages with a reference to an existing disk block.  If my
listener can do that fast enough, it's in-band dedupe; if it doesn't,
the data gets flushed to disk as normal, and I fall back to a scan of
the filesystem to clean it up later.

> > > e.g. a soft requirement is that we need to scan the entire fs at
> > > least once a month.=20
> >=20
> > I have to scan and dedupe multiple times per hour.  OK, the first-ever
> > scan of a non-empty filesystem is allowed to take much longer, but after
> > that, if you have enough spare iops for continuous autodefrag you should
> > also have spare iops for continuous dedupe.
>=20
> Yup, but using notifications avoids the for even these scans - you'd
> know exactly what data has changed, when it changed, and know
> exactly that you needed to read to calculate the new hashes.

=2E..if the scanner can keep up with the notifications; otherwise, the
notification receiver has to log them somewhere for the scanner to
catch up.  If there are missed or dropped notifications--or 23 hours a
day we're not listening for notifications because we only have an hour
a day maintenance window--some kind of filesystem scan has to be done
after the fact anyway.

> > > A simple piece-wise per-AG scanning algorithm (like we use in
> > > xfs_repair) could easily work within a 3GB RAM per AG constraint and
> > > would scale very well. We'd only need to scan 30-40 AGs in the hour,
> > > and a single AG at 1GB/s will only take 2 minutes to scan. We can
> > > then do the processing while the next AG gets scanned. If we've got
> > > 10-20GB RAM to use (and who doesn't when they have 1PB of storage?)
> > > then we can scan 5-10AGs at once to keep the IO rate up, and process
> > > them in bulk as we scan more.
> >=20
> > How do you match dupe blocks from different AGs if you only keep RAM for
> > the duration of one AG scan?  Do you not dedupe across AG boundaries?
>=20
> We could, but do we need too? There's a heap of runtime considerations
> at the filesystem level we need to take into consideration here, and
> there's every chance that too much consolidation creates
> unpredictable bottlenecks in overwrite workloads that need to break
> the sharing (i.e. COW operations).

I'm well aware of that.  I have a bunch of hacks in bees to not be too
efficient lest it push the btrfs reflink bottlenecks too far.

> e.g. An AG contains up to 1TB of data which is more than enough to
> get decent AG-internal dedupe rates. If we've got 1PB of data spread
> across 1000AGs, deduping a million copies of a common data pattern
> spread across the entire filesystem down to one per AG (i.e. 10^6
> copies down to 10^3) still gives a massive space saving.

That's true for 1000+ AG filesystems, but it's a bigger problem for
filesystems of 2-5 AGs, where each AG holds one copy of 20-50% of the
duplicates on the filesystem.

OTOH, a filesystem that small could just be done in one pass with a
larger but still reasonable amount of RAM.

> > What you've described so far means the scope isn't limited anyway.  If =
the
> > call is used to dedupe two heavily-reflinked extents together (e.g.
> > both duplicate copies are each shared by thousands of snapshots that
> > have been created during the month-long period between dedupe runs),
> > it could always be stuck doing a lot of work updating dst owners.
> > Was there an omitted detail there?
>=20
> As I said early in the discussion - if both copies of identical data
> are already shared hundreds or thousands of times each, then it
> makes no sense to dedupe them again. All that does is create huge
> amounts of work updating metadata for very little additional gain.

I've had a user complain about the existing 2560-reflink limit in bees,
because they were starting with 3000 snapshots of their data before they
ran dedupe for the first time, so almost all their data started above
the reflink limit before dedupe, and no dedupes occurred because of that.

Build servers end up with a 3-4 digit number of reflinks to every file
after dedupe, then they make snapshots of a subvol of a million such files
to back it up--instantly but temporarily doubling every reflink count.
Billions of reflink updates in only 10 TB of space.

Updating a thousand reflinks to an extent sounds like a stupid amount of
work, but in configurations like these it is just the price of deduping
anything.

Still, there has to be a limit somewhere--millions of refs to a block
might be a reasonable absurdity cutoff.


> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com
>=20

--iVCmgExH7+hIHJ1A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCW6R2JQAKCRCB+YsaVrMb
nFGdAKDCrCigLAUE/1ow/rDRWMdu6i/qwgCeLYmdgGfc8AQQCj62JvFQo09cqLc=
=GPz1
-----END PGP SIGNATURE-----

--iVCmgExH7+hIHJ1A--

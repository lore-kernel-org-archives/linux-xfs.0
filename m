Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547C62FBDE9;
	Tue, 14 Oct 2025 02:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760409149; cv=none; b=INm0dc7Spg1N0bNtD6jclmqM61YG5nmCwHH0Uh4FPwJ+lH4aH7PLK0jFRcLwnhLXE2ZPJFMzk2ha316232abxUSJ8DgneKaBy+sTJvaL6keTuuA4zYZircm73kI3NQfWn7BfI9zFRsr18IGqS2XpiBvUKeKa4vMhk+GgYVw72Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760409149; c=relaxed/simple;
	bh=su72gBkImdKZBIdIjJ210Mp/DwXHGma4OX6PPsHc4UU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iefFzI2ahAjXq8IGf37oautdiCTLTu7kDC7hZZT8umSSDzkFVk0X6y9qYz926KZIrq1HlRz4ueRSHFJ/v7PgvPOeL+qC1bZ4ck1dF//abe2tMYGoTNndefGsrqR5rKpsr2J8ISnf9HQXOr0JQjbVHP+TNoNxvZOx1hb0JTWmSbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kudkPD6o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kudkPD6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E92C4CEE7;
	Tue, 14 Oct 2025 02:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760409148;
	bh=su72gBkImdKZBIdIjJ210Mp/DwXHGma4OX6PPsHc4UU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kudkPD6od2QGb2R91+vsJvdnwvdb6kTLgcqs6fKlwqao6sz/wFXP8iEkOsXZFz0Gb
	 P6FCHtDbb+k/IDbklSjSMsikAJ+H+2tT6+QyjilPup0EKmKnWbw6ZfefOdGWgxKUk7
	 yprzsl7tqQpeTX3/+hljrFCZ2qQzuswtPmik6JRgCsGKf9u0wi85OSfVMaUAXif4q+
	 TxIaDNMZ/I5ehmJ1/czHqPf5rRS1hVd5+b/RzI/kK7ZJhK/nAPcGJ5dJPObtYaRS9k
	 DcnHZwgB8OKWCEHLmrCeZ/kEGnRE5/+itFY+YCRU4rYVaa7apOdvuJgSY4L2T2CR0g
	 7feD+OH7I79EA==
Date: Mon, 13 Oct 2025 19:32:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: mkfs.xfs "concurrency" change concerns
Message-ID: <20251014023228.GU6188@frogsfrogsfrogs>
References: <84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net>
 <20251010191713.GE6188@frogsfrogsfrogs>
 <f7d5eaab-c2fe-4a11-82d5-a7c5ca563e75@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7d5eaab-c2fe-4a11-82d5-a7c5ca563e75@sandeen.net>

On Fri, Oct 10, 2025 at 03:47:14PM -0500, Eric Sandeen wrote:
> On 10/10/25 2:17 PM, Darrick J. Wong wrote:
> > On Thu, Oct 09, 2025 at 03:13:47PM -0500, Eric Sandeen wrote:
> >> Hey all -
> >>
> >> this got long, so tl;dr:
> >>
> >> 1) concurrency geometry breaks some xfstests for me
> >> 2) concurrency behavior is not consistent w/ loopback vs. imagefile
> >> 3) concurrency defaults to the mkfs machine not the mount machine
> 
> ...
> 
> > Uggggh.  You're right, I see golden output changes in xfs/078 if I boost
> > the number of VM CPUs past four:
> > 
> > --- /run/fstests/bin/tests/xfs/078.out  2025-07-15 14:41:40.195202883 -0700
> > +++ /var/tmp/fstests/xfs/078.out.bad    2025-10-10 11:56:14.040263143 -0700
> > @@ -188,6 +188,6 @@
> >  *** mount loop filesystem
> >  *** grow loop filesystem
> >  xfs_growfs --BlockSize=4096 --Blocks=268435456
> > -data blocks changed from 268435456 to 4194304001
> > +data blocks changed from 268435456 to 4194304000
> >  *** unmount
> >  *** all done
> 
> Yeah I saw exactly that.
> 
> > Can this happen if RAID stripe parameters also get involved and change
> > the AG count?  This test could be improved by parsing the block counts
> > and using _within to get past those kinds of problems, if there's more
> > than one way to make the golden output wrong despite correct operation.
> 
> Maybe? Not sure tbh. I hadn't seen it fail before.
> 
> > What do your xfs/21[67] failures look like?
> 
> On a VM w/ 8 CPUs, like this:
> 
> xfs/216 4s ... - output mismatch (see /root/xfstests-dev/results//xfs/216.out.bad)
>     --- tests/xfs/216.out	2024-02-08 15:39:34.883667028 -0600
>     +++ /root/xfstests-dev/results//xfs/216.out.bad	2025-10-10 15:28:24.055130959 -0500
>     @@ -7,4 +7,4 @@
>      fssize=32g log      =internal log           bsize=4096   blocks=16384, version=2
>      fssize=64g log      =internal log           bsize=4096   blocks=16384, version=2
>      fssize=128g log      =internal log           bsize=4096   blocks=16384, version=2
>     -fssize=256g log      =internal log           bsize=4096   blocks=32768, version=2
>     +fssize=256g log      =internal log           bsize=4096   blocks=32767, version=2
>     ...
>     (Run 'diff -u /root/xfstests-dev/tests/xfs/216.out /root/xfstests-dev/results//xfs/216.out.bad'  to see the entire diff)
> Ran: xfs/216
> Failures: xfs/216
> Failed 1 of 1 tests
> 
> 217 was similarly off by one. So maybe _within works ...
> 
> >> One option might be to detect whether the "concurrency" args
> >> exist in mkfs.xfs, and set that back to 4, which is probably likely
> >> to more or less behave the old way, and match the current golden
> >> output which was (usually) based on 4 AGs. But that might break
> >> the purpose of some of the tests, if we're only validating behavior
> >> when a specific set of arguments is applied.
> > 
> > I think you're really asking to force the old behavior from before the
> > concurrency options existed, but only if fstests is running.  Or maybe
> > a little more than that; I'll get to that at the end.
> 
> Not so much asking for as musing about, and I don't think it's the
> best idea ...
> 
> ...
> 
> >> # losetup /dev/loop4 testfile.img
> >>
> >> # mkfs.xfs -f /dev/loop4 2>&1 | grep agcount
> >> meta-data=/dev/loop4             isize=512    agcount=6, agsize=11184810 blks
> >>
> >> # mkfs.xfs -f testfile.img 2>&1 | grep agcount
> >> meta-data=testfile.img           isize=512    agcount=4, agsize=16777216 blks
> >>
> >> so we get different behavior depending on how you access the image file.
> > 
> > What kernel is this?  6.17 sets ROTATIONAL by default and clears it if
> > the backing bdev (or the bdev backing the file) has ROTATIONAL set.
> > That might be why you see the discrepancy.  I think that behavior has
> > been in the kernel since ~6.11 or so.
> 
> This was 6.17. The backing file get the nonrotational/concurrency treatment
> but the loop device does. This probably says more about the xfsprogs test
> (ddev_is_solidstate) than the kernel.
> 
> ioctl(3, BLKROTATIONAL, 0x7ffd9d48f696) = -1 ENOTTY (Inappropriate ioctl for device)
> 
> fails, so ddev_is_solidstate returns false. For the loop dev, BLKROTATIONAL
> says rotational == 0 so we get true for solidstate.
> 
> But TBH this might be the right answer for mkfsing a file directly, as it is
> likely an image destined for another machine.
> 
> Perhaps ddev_is_solidstate() should default to "not solidstate" for regular
> files /and/ loopback devices if possible?

It's *possible*, but why would mkfs ignore what the kernel tells us?

Suppose you're creating an image file on a filesystem sitting on a SSD
with the intent of deploying the image in a mostly non-rotational
environment.  Now those people don't get any of the SSD optimizations
even though the creator had an SSD

> > [Aside: Obviously, checking inode->i_sb->sb_bdev isn't sufficient for
> > files on a multi-disk filesystem, but it's probably close enough here.]
> > 
> > (But see below)
> > 
> >> And speaking of image files, it's a pretty common use case to use mkfs.xfs
> >> on image files for deployment elsewhere.  Maybe the good news, even if
> > 
> > Yes, mkfs defaults to assuming rotational (and hence not computing a
> > concurrency factor) if the BLKROTATIONAL query fails.  So that might
> > be why you get 4 AGs on a regular file but 6 on a loop device pointing
> > to the same file.
> 
> Yes, exactly.
> 
> >> accidental, is that if you mkfs the file directly, you don't get system-
> >> specific "concurrence" geometry. But I am concerned that there is no
> >> guarantee that the machine performing mkfs is the machine that will mount
> >> the filesystem, so this seems like a slightly dangerous assumption for 
> >> default behavior.
> > 
> > What I tell our internal customers is:
> > 
> > 1. Defer formatting until deployment whenever possible so that mkfs can
> > optimize the filesystem for the storage and machine it actually gets.
> > 
> > 2. If you can't do that, then try to make the image creator machine
> > match the deployment hardware as much as possible in terms of
> > rotationality and CPU count.
> 
> I just don't think that's practical in real life when you're creating a
> generic OS image for wide distribution into unknown environments.

Uhhh well I exist in real life too.

> > 3. We shouldn't have a #3 because that's leaving performance on the
> > table.
> > 
> > They were very happy to see performance gains after adjusting their
> > WOS generation scripts towards #1.
> > 
> > But I think it's this #3 here that's causing the most concern for you?
> > I suppose if you really don't know what the deployment hardware is going
> > to look like then ... falling back to the default calculations (which
> > are mostly for spinning-rust) at least is familiar.
> > 
> > Would the creation of -[dlr] concurrency=never options to mkfs.xfs
> > address all of your concerns?
> 
> Not quite, because *defaults* have changed, and it's almost impossible
> to chase down every consumer who's going to happily update xfsprogs and
> suddenly get wildly different geometry which might really help them!
> Or might make no sense at all. But that horse has kind of left the barn,
> I guess.

I would say that the *hardware* has changed, and so should the defaults.

The pre-concurrency= defaults, FWIW, are what past xfs developers worked
out as a reasonable setting for spinning rust.

> I'm tempted to say "do not do the concurrency thing for regular files or
> for loopback files because that's a strong hint that this filesystem has
> at least a good chance of being destined for another machine." Thoughts?
> 
> (from your other email)
> 
> > Now that I've read the manpage, I'm reminded that -[dlr] concurrency=0
> > already disables the automatic calculation.  Does injecting that into
> > dparam (in xfs/078) fix the problem for you?  It does for me.
> 
> I'm sure it does. Gets back to my question about whether that is too
> detrimental to test coverage for the default behavior. I think probably
> a _within is better. _within would take a little work since we're comparing
> strings with numbers in them not just numbers but I think we really do
> care only about one number in the string, so it's probably fine.

Yeah.  Could we turn the last two digits in a sequence into "XX" so
that as long as it's not off by more than 100 fsblocks then everything
is ok?

> >> I understand the desire to DTRT by default, but I am concerned about
> >> test breakage, loopdev inconsistencies, and too-broad assumptions about
> >> where the resulting filesystem will actually be used.
> > 
> > That itself is a ... very broad statement considering that this code
> > landed in 6.8 and this is the first I've heard of complaints. ;)
> 
> Yeah, I started off with acking that I am very late to this. Been a million
> work distractions keeping me from this stuff, I'm sorry. :(
> 
> But as you said, any test env. with > 4 CPUs probably started failing tests
> since 6.8 so it's probably not all on me. ;)
> 
> I think where I'll go from here is do a big run with -d and -l concurrency
> set to something biggish in MKFS_OPTIONS, see what breaks, and see what sort
> of _within changes might help.

<nod>

> And then I might also see about a patch to make ddev_is_solidstate explicitly
> return false for loop devices and regular files, unless anyone sees issues
> with that approach.

As I said before, that might be surprising to anyone who saw that the
loop device is not rotational and didn't get nonrotational tuning.

--D

> thanks,
> -Eric
> 

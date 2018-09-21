Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:64443 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727141AbeIUIqU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Sep 2018 04:46:20 -0400
Date: Fri, 21 Sep 2018 12:59:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] file dedupe (and maybe clone) data corruption (was Re:
 [PATCH] generic: test for deduplication between different files)
Message-ID: <20180921025931.GI16550@dastard>
References: <20180819231126.GU2234@dastard>
 <20180820010932.GV2234@dastard>
 <20180820153349.GA4334@magnolia>
 <20180823125849.GF13528@hungrycats.org>
 <20180830062743.GF5631@dastard>
 <20180831051045.GI26989@hungrycats.org>
 <20180906083809.GF27618@dastard>
 <20180907035305.GJ26989@hungrycats.org>
 <20180910090646.GB5631@dastard>
 <20180919041203.GA11397@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180919041203.GA11397@hungrycats.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, fdmanana@kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Sep 19, 2018 at 12:12:03AM -0400, Zygo Blaxell wrote:
> On Mon, Sep 10, 2018 at 07:06:46PM +1000, Dave Chinner wrote:
> > On Thu, Sep 06, 2018 at 11:53:06PM -0400, Zygo Blaxell wrote:
> > > On Thu, Sep 06, 2018 at 06:38:09PM +1000, Dave Chinner wrote:
> > > > On Fri, Aug 31, 2018 at 01:10:45AM -0400, Zygo Blaxell wrote:
> > > > > On Thu, Aug 30, 2018 at 04:27:43PM +1000, Dave Chinner wrote:
> > > > > > On Thu, Aug 23, 2018 at 08:58:49AM -0400, Zygo Blaxell wrote:
> > > > > For future development I've abandoned the entire dedupe_file_range
> > > > > approach.  I need to be able to read and dedupe the data blocks of
> > > > > the filesystem directly without having to deal with details like which
> > > > > files those blocks belong to, especially on filesystems with lots of
> > > > > existing deduped blocks and snapshots. 
> > > > 
> > > > IOWs, your desired OOB dedupe algorithm is:
> > > > 
> > > > 	a) ask the filesystem where all it's file data is
> > > 
> > > Actually, it's "ask the filesystem where all the *new* file data is"
> > > since we don't want to read any unique data twice on subsequent runs.
> > 
> > Sorry, how do you read "unique data" twice? By definition, unique
> > data only occurs once....
> 
> ...but once it has been read, we don't want to read it again.  Ever.
> Even better would be to read unique data less than 1.0 times on average.
> 
> > Oh, and you still need to hash the old data so you can find
> > collisions with the new data that got written. Unless, of course,
> > you are keeping your hash tree in a persistent database 
> 
> I do that.

OK, so you're slowly re-inventing the typical HSM implementation
that keep a userspace database to keep track of what is happening in
the filesystem. They do this to make better decisions when moving
less frequently accessed data out to a slower teirs of storage to
keep space in the primary storage available as it fills up. You're
approaching dedupe in essentially the same way, for very similar
reasons.

> One big difference I am noticing in our approaches is latency.  ZFS (and
> in-kernel btrfs dedupe) provides minimal dedupe latency (duplicate
> data occupies disk space for zero time as it is never written to disk
> at all) but it requires more RAM for a given dedupe hit rate than any
> other dedupe implementation I've seen.  What you've written tells me
> XFS saves RAM by partitioning the data and relying on an existing but
> very large source of iops (sharing scrub reads with dedupe), but then
> the dedupe latency is the same as the scrub interval (the worst so far).

That's just the background maintenance implementation. xfs_fsr can
run this way, but it can also be run as a complete immediate scan,
or it can be pointed at a defined set of files to run on. We can
(and probably will) do exactly the same thing with dedupe.

> bees aims to have latency of a few minutes (ideally scanning data while
> it's still dirty in cache, but there's no good userspace API for that)
> though it's obviously not there yet.

Yup, this is pretty much the "I need immediate notification that a
file changed" problem that HSMs face. That's one of the things DMAPI
was used for - XFS has (now unused) dmapi event notification fields in
it's inode structure that were used by DMAPI to configure the
notifications the filesystem was supposed to send userspace....

With no DMAPI in the future, people with custom HSM-like interfaces
based on dmapi are starting to turn to fanotify and friends to
provide them with the change notifications they require....

> > e.g. a soft requirement is that we need to scan the entire fs at
> > least once a month. 
> 
> I have to scan and dedupe multiple times per hour.  OK, the first-ever
> scan of a non-empty filesystem is allowed to take much longer, but after
> that, if you have enough spare iops for continuous autodefrag you should
> also have spare iops for continuous dedupe.

Yup, but using notifications avoids the for even these scans - you'd
know exactly what data has changed, when it changed, and know
exactly that you needed to read to calculate the new hashes.

> > A simple piece-wise per-AG scanning algorithm (like we use in
> > xfs_repair) could easily work within a 3GB RAM per AG constraint and
> > would scale very well. We'd only need to scan 30-40 AGs in the hour,
> > and a single AG at 1GB/s will only take 2 minutes to scan. We can
> > then do the processing while the next AG gets scanned. If we've got
> > 10-20GB RAM to use (and who doesn't when they have 1PB of storage?)
> > then we can scan 5-10AGs at once to keep the IO rate up, and process
> > them in bulk as we scan more.
> 
> How do you match dupe blocks from different AGs if you only keep RAM for
> the duration of one AG scan?  Do you not dedupe across AG boundaries?

We could, but do we need too? There's a heap of runtime considerations
at the filesystem level we need to take into consideration here, and
there's every chance that too much consolidation creates
unpredictable bottlenecks in overwrite workloads that need to break
the sharing (i.e. COW operations).

e.g. An AG contains up to 1TB of data which is more than enough to
get decent AG-internal dedupe rates. If we've got 1PB of data spread
across 1000AGs, deduping a million copies of a common data pattern
spread across the entire filesystem down to one per AG (i.e. 10^6
copies down to 10^3) still gives a massive space saving.

However, still having multiple copies means that when an overwrite
occurs we don't have a single global block that everyone contends on
trying to COW it. i.e. dedupe within an AG means we can run both
dedupe and COW operations wholly within a single AG. That means
ENOSPC operation is much more reliable, we have less complex
locking, we don't do as much work, we only need to manage one set of
freelist blocks, etc.

> > I'd like a pony, too.
> 
> I have friends with an assortment of horses.  What kind of pony would
> you like?  ;)

Rainbow, please :P

> > However, I think that such bottom up operations are nearly
> > impossible to do atomically because they invert the locking orders
> > of normal operations and are completely open-ended in scope in what
> > they may need to update.  
> 
> I don't think it needs to be atomic at all.  dedupe only needs a way
> to know if it has lost a race and continue gracefully, and that can be

Detecting races reliably implies locking and/or making operational
state changes appear atomic to external observers.

> What you've described so far means the scope isn't limited anyway.  If the
> call is used to dedupe two heavily-reflinked extents together (e.g.
> both duplicate copies are each shared by thousands of snapshots that
> have been created during the month-long period between dedupe runs),
> it could always be stuck doing a lot of work updating dst owners.
> Was there an omitted detail there?

As I said early in the discussion - if both copies of identical data
are already shared hundreds or thousands of times each, then it
makes no sense to dedupe them again. All that does is create huge
amounts of work updating metadata for very little additional gain.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

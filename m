Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 75E3829DF8
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 16:27:17 -0500 (CDT)
Date: Tue, 4 Jun 2013 16:27:13 -0500
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: Debunking myths about metadata CRC overhead
Message-ID: <20130604212713.GB24897@sgi.com>
References: <20130603074452.GZ29466@dastard> <20130603200052.GB863@sgi.com>
	<20130604024329.GA29466@dastard> <20130604101937.GI29466@dastard>
	<20130603074452.GZ29466@dastard> <20130603200052.GB863@sgi.com>
	<20130604024329.GA29466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130604101937.GI29466@dastard> <20130604024329.GA29466@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 04, 2013 at 12:43:29PM +1000, Dave Chinner wrote:
| On Mon, Jun 03, 2013 at 03:00:53PM -0500, Geoffrey Wehrman wrote:
| > On Mon, Jun 03, 2013 at 05:44:52PM +1000, Dave Chinner wrote:
| > | Hi folks,
| > | 
| > | There has been some assertions made recently that metadata CRCs have
| > | too much overhead to always be enabled.  So I'll run some quick
| > | benchmarks to demonstrate the "too much overhead" assertions are
| > | completely unfounded.
| > 
| > Thank you, much appreciated.

| We've known about the VFS lock contention problem a lot longer than
| we've had the CRC code has been running.  In case you hadn't been
| keeping up with this stuff, here's a quick summary of the work I've
| been doing with Glauber:
| 
| http://lwn.net/Articles/550463/
| http://lwn.net/Articles/548092/
| 
| So, while CRCs might be a trigger that makes the system fall off the
| cliff it is on the edge of, it is most certainly not a CRC problem,
| it is not a problem we can solve by changing the CRC code and it is
| not a problem we can solve by turning off CRCs.  IOWs, CRCs are not
| the root cause of the degradation in performance.

Fair enough.  It is good to know that the VFS lock contention problem is
being addressed.  Thanks for the pointers to the summary of the work you
and Glauber have been doing.

| > Do I want to take a 5% performance hit in filesystem performance
| > and double the size of my inodes for an unproved feature?  I am
| > still unconvinced that CRCs are a feature that I want to use.
| > Others may see enough benefit in CRCs to accept the performance
| > hit.  All I want is to ensure that I the option going forward to
| > chose not to use CRCs without sacrificing other features
| > introduced XFS.
| 
| If you don't want to take the performance hit of SDM, the don't use
| it. You have that choice right now - either choose performance (v4
| superblocks) or reliability (v5 superblocks) at mkfs time.

That is exactly the capability I want.

| If new features are introduced that you want that are dependent on
| v5 superblocks and you want to stick with v4 superblocks for
| performance reasons, then you have to make a hard choice unless you
| address your concerns about v5 superblocks. Indeed, none of the
| performance issues you've mentioned are unsolvable problems - you
| just have to identify them and fix them before your customers need
| v5 superblocks.

This is the type of hard choice I want to avoid as much as possible.
My concern is that all future XFS features will be introduced as v5
superblock only features, regardless of whether they are directly
dependent on CRC or not.  I'm not expecting all future features to be
implemented for both v4 and v5 superblocks, but I would like to have new
features available for v4 superblocks available when possible, at least
until the vast majority of systems deployed are v5 superblock capable.
Unfortunately this will take much longer than we like.

| IOWs, you need to quantify the specific performance degradations you
| are concerned about and help fix them. We may have different
| priorities and goals, but that doesn't stop us from both being able
| to help each reach our goals. But any such discussion about
| performance and problem areas needs to be based on quantified
| information, not handwaving.

I would love to be able to quantify and help fix performance degradations
I am concerned about.  Unfortunately there are just not enough hours in a
day.  I will be honest, I am not an XFS developer.  I am an XFS consumer.
The products I spend my time working on rely on XFS as their foundation.
I don't even touch current XFS.  I spend most of my time working with XFS
code that is a year old or more.  Even then, I am not spending much time
with the XFS code itself but rather the code from the products built on
top of XFS.  Call me an XFS consumer.  It is like buying an automobile.
I don't review the cad drawings of each part used in the construction.
I don't even examine the engine or transmission.  I don't take an
automobile I'm looking at and hook it up to a dyno to get a performance
report.  I rely on the manufacturer to provide me with the performance
information, and then I do my best to analyze the data I have available.

| Geoffrey, can you start by identifying and quantifying two things on
| current top-of-tree kernels?
| 
| 	1. exactly where the problems with larger inodes are (on v4
| 	   superblocks)
| 	2. workloads you care about where SDM significantly impacts
| 	   performance (i.e. v4 vs v5 superblocks)

I cannot identify and quantify any more than I already have.  Bulk scans
are my primary concern, along with potential doubling of bandwidth
required for a bulk scan.  You address much of this in your follow-up
e-mail.

| We can discuss each case you raise on their merits and determine
| whether they need to be addressed and, if so, how to address them.
| But we need quantified data to make any progress here.
| 
| In the mean time, you can just use v4 superblocks like you currently
| do, but when the time comes to switch to v5 superblocks we will have
| corrected the identified problems and performance will not be an
| issue that you need to be concerned about.

I hope that is the case, and expect that it will be.  I'm not questioning
your abilities.  You are one of the best developers in the community.
I just want to be sure that I'm forced into v5 superblocks before
the identified problems have been resolved, and that the work on v5
superblocks has minimal impact on my current use of v4 superblocks.
The data you have provided has gone a long way to ally my concerns about
the metadata performance in XFS with CRCs.  I'm not ready to jump yet,
but you have given me confidence that the jump should not be as bad as I
had expected.

On Tue, Jun 04, 2013 at 08:19:37PM +1000, Dave Chinner wrote:
| On Tue, Jun 04, 2013 at 12:43:29PM +1000, Dave Chinner wrote:
| > On Mon, Jun 03, 2013 at 03:00:53PM -0500, Geoffrey Wehrman wrote:
| > > On Mon, Jun 03, 2013 at 05:44:52PM +1000, Dave Chinner wrote:
| > > This will have significant impact
| > > on SGI's DMF managed filesystems.
| > 
| > You're concerned about bulkstat performance, then? Bulkstat will CRC
| > every inode it reads, so the increase in inode size is the least of
| > your worries....
| > 
| > But bulkstat scalability is an unrelated issue to the CRC work,
| > especially as bulkstat already needs application provided
| > parallelism to scale effectively.
...
| So, the difference in performance pretty much goes away. We burn
| more bandwidth, but now the multithreaded bulkstat is CPU limited
| for both non-crc, 256 byte inodes and CRC enabled 512 byte inodes.
| 
| What this says to me is that there isn't a bulkstat performance
| problem that we need to fix apart from the 3 lines of code for the
| readahead IO plugging that I just added.  It's only limited by
| storage IOPS and available CPU power, yet the bandwidth is
| sufficiently low that any storage system that SGI installs for DMF
| is not going to be stressed by it. IOPS, yes. Bandwidth, no.

What can I say but nice analysis.  You've clearly shown that the
performance impact in bulk scan caused by CRCs can be easily offset by
changes elsewhere, improving bulkstat performance across the board.
I don't exactly follow what changes you made to _xfs_buf_ioapply(),
but expect that you will eventually post the change.


-- 
Geoffrey Wehrman  651-683-5496  gwehrman@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0DE317F51
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 17:52:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B9919304048
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 15:52:18 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	42h87ocMhfB11kPM for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 15:52:16 -0700 (PDT)
Date: Thu, 24 Apr 2014 08:52:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS fragmentation on file append
Message-ID: <20140423225204.GR15995@dastard>
References: <CAJhmKHmwvCBx=arJ6m2ZhuQVq=Jj-XbBGvEPjTPY5a1QtWRTCQ@mail.gmail.com>
	<20140408015012.GB22917@dastard>
	<CAJhmKHnap0vu8m4AXBxJr9L0RKoquFrm3NjKQdDBJwpRTYmfpw@mail.gmail.com>
	<20140408053117.GJ27017@dastard>
	<CAJhmKHk5fWVaDTEfL_oESULspavk83eBEsyw7=qEp8bC7f2S2g@mail.gmail.com>
	<20140423054719.GJ15995@dastard>
	<CAJhmKHmtXwncWJDmFOUCXEHcZphDPu7LgomAer2dCKhsSU81ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJhmKHmtXwncWJDmFOUCXEHcZphDPu7LgomAer2dCKhsSU81ZQ@mail.gmail.com>
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
To: Keyur Govande <keyurgovande@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 23, 2014 at 03:05:00PM -0400, Keyur Govande wrote:
> On Wed, Apr 23, 2014 at 1:47 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Apr 22, 2014 at 07:35:34PM -0400, Keyur Govande wrote:
> >> Here's how the first 3 AG's look like:
> >> https://gist.github.com/keyurdg/82b955fb96b003930e4f
> >>
> >> After a run of the dpwrite program, here's how the bmap looks like:
> >> https://gist.github.com/keyurdg/11196897
> >>
> >> The files have nicely interleaved with each other, mostly
> >> XFS_IEXT_BUFSZ size extents.
> >
> > XFS_IEXT_BUFSZ Has nothing to do with the size of allocations. It's
> > the size of the in memory array buffer used to hold extent records.
> >
> > What you are seeing is allocation interleaving according to the
> > pattern and size of the direct IOs being done by the application.
> > Which happen to be 512KB (1024 basic blocks) and the file being
> > written to is randomly selected.
> 
> I misspoke; I meant to say XFS_IEXT_BUFSZ (4096) blocks per extent. As
> long as each pwrite is less than 2 MB, the extents do lay out in 4096
> blocks every time.

Sure, 4096 basic blocks per extent, but that has nothing to do with
XFS_IEXT_BUFSZ. All you've done is pick a random #define out of the
source code that matches the number you are seeing from xfs_bmap.
They are *completely unrelated*.

If your extents are laying out in 2MB chunks, then perhaps that's
because of allocation alignment being driven by stripe unit/stripe
width configuration, or maybe freespace is simply fragmented into
chunks that size.

> >> The average read speed is 724 MBps. After
> >> defragmenting the file to 1 extent, the speed improves 30% to 1.09
> >> GBps.
> >
> > Sure. Now set an extent size hint of 32MB and try again.
> 
> I did these runs as well going by your last email suggestion, but I
> was more interested in what you thought about the other ideas so
> didn't include the results.
> 
> 32MB gives 850 MBps and 64MB hits 980MBps. The peak read rate from the
> hardware for a contiguous file is 1.45 GBps. I could keep on
> increasing it until I hit a number I like, but I was looking to see if
> it could be globally optimized.

IOWs, if you hit the RAID controller readahead cache, it does
1.45GB/s. If you don't hit it, you see sustainable, real world disk
speeds you can get from the array.

> I realize this is terrible for small files like a source code tree,
> but for a database which usually has a many large files in the same
> directory the seek cost is amortized by the benefit from a large
> contiguous read. Would it be terrible to have this modifiable as a
> setting (like extsize is) with the default being the inode64 behavior?

We do have that behaviour configurable. Like I said, use the inode32
allocator (mount option).

> >> I couldn't find guidance on the internet on how many allocation groups
> >> to use for a 2 TB partition,
> >
> > I've already given guidance on that. Choose to ignore it if you
> > will...
> 
> Could you repeat it or post a link? The only relevant info I found via
> Google is using as many AGs as hardware threads

Sorry, I mixed you up with someone else asking about XFS
optimisation for database workloads a couple of days ago.

http://oss.sgi.com/archives/xfs/2014-04/msg00384.html

> (http://blog.tsunanet.net/2011/08/mkfsxfs-raid10-optimal-performance.html).

That's one of the better blog posts I've seen, but it's still got
quite a few subtle errors in it.

As it is, this shows why google is a *terrible source* of technical
information - google considers crappy blog posts to be more
authorative than the mailing list posts written by subject matter
experts....

Indeed, this is where I'm trying to document all this sort of stuff
in a semi-official manner so as to avoid this "he said, she said"
sort of problem:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-documentation.git;a=blob_plain;f=admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc;hb=HEAD

> >> Could the same doubling logic be applied for DIRECT_IO writes as well?
> >
> > I don't think so. It would break many carefully tuned production
> > systems out there that rely directly  on the fact that XFS does
> > exactly what the application asks it to do when using direct IO.
> >
> > IOWs, I think you are trying to optimise the wrong layer - put your
> > effort into making fallocate() do what the application needs to
> > prevent fragmentation rather trying to hack the filesystem to do it
> > for you.  Not only will that improve performance on XFS, but it will
> > also improve performance on ext4 and any other filesystem that
> > supports fallocate and direct IO.
> 
> I've been experimenting with patches to MySQL to use fallocate with
> FALLOC_FL_KEEP_SIZE and measuring the performance and fragmentation.

Great - I'm interested to know what your results are :)

> I also poked at the kernel because I assumed other DBs may also
> benefit from the heuristic (speculative) allocation. Point taken about
> doing the optimization in the application layer.

Postgres uses buffered IO (so can make use of speculative allocation
for it's files. However, that has it's own share of problems
that direct IO doesn't have, so they aren't really in a better
position as a result of making that choice...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

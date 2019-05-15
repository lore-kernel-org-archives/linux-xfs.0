Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47802 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725937AbfEOWz1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 18:55:27 -0400
Date: Thu, 16 May 2019 08:55:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_db: add extent count and file size histograms
Message-ID: <20190515225521.GA29573@dread.disaster.area>
References: <20190514185026.73788-1-jorgeguerra@gmail.com>
 <20190514233119.GS29573@dread.disaster.area>
 <f121a7d3-ef90-2777-3074-dee302a3ad28@sandeen.net>
 <20190515020547.GT29573@dread.disaster.area>
 <CAEFkGAzWKdS4B+jzbWZ8vivqASeQrJVxFQOio913uBiVOG0zrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEFkGAzWKdS4B+jzbWZ8vivqASeQrJVxFQOio913uBiVOG0zrA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jorge Guerra <jorge.guerra@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, Omar Sandoval <osandov@osandov.com>, Jorge Guerra <jorgeguerra@fb.com>

On Wed, May 15, 2019 at 09:39:01AM -0700, Jorge Guerra wrote:
> On Tue, May 14, 2019 at 7:05 PM Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, May 14, 2019 at 07:06:52PM -0500, Eric Sandeen wrote:
> > > On 5/14/19 6:31 PM, Dave Chinner wrote:
> > This is not a measure of "internal fragmentation". It doesn't take
> > into account the fact we can (and do) allocate extents beyond EOF
> > that are there (temporarily or permanently) for the file to be
> > extended into without physically fragmenting the file. These can go
> > away at any time, so one scan might show massive "internal
> > fragmentation" and then a minute later after the EOF block scanner
> > runs there is none. i.e. without changing the file data, the layout
> > of the file within EOF, or file size, "internal fragmentation" can
> > just magically disappear.
> 
> I see, how much is do we expect this to be (i.e 1%, 10%? of the file
> size?).  In other words what's the order of magnitude of the
> "preemtive" allocation compared to the total space in the file system?

Specualtive delalloc can be up to MAXEXTLEN on large files. It is
typically the size of the file again as the file is growing. i.e. if
the file is 64k, we'll preallocate 64k. if it's 1GB, we'll prealloc
1GB, if it's over 8GB (MAXEXTLEN on a 4k block size filesystem),
then we'll prealloc 8GB.

This typically is not removed when the file is closed - it is
typically removed when the file has not been modified for a few
minutes and the EOF block scanner runs over it, the inode is cycled
out of cache or we hit an ENOSPC condition, in which case the EOF
block scanner is run to clean up such prealloc before we attempt
allocation again. THe amount of speculative prealloc is dialled back
as the filesystem gets nearer to ENOSPC (>95% capacity) or the user
starts to run out of quota space.

So, yes, it can be a large amount of space that is consumed
temporarily, but the amount is workload dependent. The
reality is that almost no-one notices that XFS does this or the
extent to which XFS makes liberal use of free space for
fragmentation avoidance...

Of course, the filesystem has no real control over user directed
preallocation beyond EOF (i.e. fallocate()) and we do not ever
remove that unless the user runs ftruncate(). Hence the space
beyond EOF might be a direct result of the applications that are
running and not filesystem behaviour related at all...

> > It doesn't take into account sparse files. Well, it does by
> > ignoring them which is another flag that this isn't measuring
> > internal fragmentation because even sparse files can be internally
> > fragmented.
> >
> > Which is another thing this doesn't take into account: the amount of
> > data actually written to the files. e.g. a preallocated, zero length
> > file is "internally fragmented" by this criteria, but the same empty
> > file with a file size that matches the preallocation is not
> > "internally fragmented". Yet an actual internally fragmented file
> > (e.g. preallocate 1MB, set size to 1MB, write 4k at 256k) will not
> > actually be noticed by this code....
> 
> Interesting, how can we better account for these?

If it is preallocated space, then you need to scan each file to
determine the ratio of written to unwritten extents in the file.
(i.e. allocated space that contains data vs allocated space that
does not contain data). Basically, you need something similar to
what xfs_fsr is doing to determine if files need defragmentation or
not...

> > IOWs, what is being reported here is exactly the same information
> > that "stat(blocks) vs stat(size)" will tell you, which makes me
> > wonder why the method of gathering it (full fs scan via xfs_db) is
> > being used when this could be done with a simple script based around
> > this:
> >
> > $ find /mntpt -type f -exec stat -c "%s %b" {} \; | histogram_script
> 
> While this is true that this can be measured via a simply a script,
> I'd like to point out that it would be significantly more inefficient,
> for instance:
> 
> # time find /mnt/pt -type f -exec stat -c "%s %b" {} \; > /tmp/file-sizes
> 
> real    27m38.885s
> user    3m29.774s
> sys     17m9.272s

That's close on CPU bound, so I'm betting most of that time is in
fork/exec for the stat binary for each file that find pipes out.

e.g on my workstation, which has ~50,000 read iops @ QD=1 capability
on the root filesystem:

$  time sudo find / -type f > /tmp/files

real	0m8.707s
user	0m1.006s
sys	0m2.571s

$ wc -l /tmp/files
1832634 /tmp/files

So, 1.8m files traversed in under 9 seconds - this didn't stat the
inodes because ftype. How long does the example script take?

$ time sudo find / -type f -exec stat -c "%s %b" {} \; > /tmp/file-sizes
<still waiting after 10 minutes>
.....

While we are waiting, lets just get rid of the fork/exec overhead,
eh?

$ time sudo sh -c 'find / -type f |xargs -d "\n" stat -c "%s %b" > /tmp/files-size-2'

real	0m4.712s
user	0m2.732s
sys	0m5.073s

Ok, a fair bunch of the directory heirarchy and inodes were cached,
but the actual stat takes almost no time at all and almost no CPU
usage.

Back to the fork-exec script, still waiting for it to finish,
despite the entire file set now residing in kernel memory.

Fmeh, I'm just going to kill it.

....
real	26m34.542s
user	18m58.183s
sys	7m38.125s
$ wc -l /tmp/file-sizes
1824062 /tmp/file-sizes

Oh, it was almost done. IOWs, the /implementation/ was the problem

I think by now you understand that I gave an example of how the
information you are querying is already available through normal
POSIX APIs, not that it was the most optimal way of running that
query through those APIs.

It is, however, /trivial/ to do this query traversal query at max IO
speed even using scripts - using xargs to batch arguments to
utilities to avoid fork/exec overhead is sysadmin 101 stuff...

> # echo "frag -s -e" | time /tmp/xfs_db -r /dev/sdb1
> [...]
> 0.44user 2.48system 0:05.42elapsed 53%CPU (0avgtext+0avgdata 996000maxresident)k
> 2079416inputs+0outputs (0major+248446minor)pagefaults 0swaps
> 
> That's 5.4s vs +27 minutes without considering the time to build the histogram.

Yup, but now you've explained why you are trying to use xfs_db in
inappropriate ways: performance.

Despite the fact directory traversal can be fast, it is still not
the most IO efficient way to iterate inodes. xfs_db does that by
reading the inodes in ascending order from the AGI btrees, meaning
it's a single sequential pass across the filesystem to parse indoes
a chunk at a time.

The sad fact about all this is that we've been able to do this from
userspace with XFS since .... 1994.  It's called bulkstat. I say
this is sad because I've lost count of the number of times people
have wasted time trying to re-invent the wheel rather than just
asking the experts a simple question and being told about bulkstat
or GETFSMAP....

Yup, there's even a basic test program in fstests that outputs stat
information from bulkstat that you can filter to report the info you
are generating histograms from:

$ time sudo src/bstat / | grep -A1 "mode 01" | awk -e '/blksize/ { print $4, $6 }' > /tmp/bstat-sizes

real	0m11.317s
user	0m8.686s
sys	0m5.909s

Again, this is /not an optimal implementation/ but just an example
that this functionality is available to userspace. Targeted
implementations can be found in tools like xfs_fsr and xfsdump which
use bulkstat to find the indoes they need to operate on much faster
than a directory walk ever will acheive....

> > I have no problems with adding analysis and reporting functionality
> > to the filesystem tools, but they have to be done the right way, and
> > not duplicate functionality and information that can be trivially
> > obtained from userspace with a script and basic utilities. IMO,
> > there has to be some substantial benefit from implementing the
> > functionality using deep, dark filesystem gubbins that can't be
> > acheived in any other way for it be worth the additional code
> > maintenance burden....
> 
> In my view, the efficiency gain should justify the need to for this
> tool.

As I said, I have no objections to such functionality if it is /done
the right way/. I'm not arguing against providing such functionality
to users, I'm pointing out that the implementation has issues that
will cause problems for users that try to use this functionality
and trying to let you know how to implement it safely without giving
up any of the efficiency gains.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

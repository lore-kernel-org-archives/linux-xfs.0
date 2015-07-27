Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B3E317FC7
	for <xfs@oss.sgi.com>; Mon, 27 Jul 2015 18:22:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 832188F8035
	for <xfs@oss.sgi.com>; Mon, 27 Jul 2015 16:22:30 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	drkhRAL5VAyTUUiG for <xfs@oss.sgi.com>;
	Mon, 27 Jul 2015 16:22:27 -0700 (PDT)
Date: Tue, 28 Jul 2015 09:22:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Slow find performance
Message-ID: <20150727232225.GK3902@dastard>
References: <CAM4LOhUqzOm3MdGZv6CKP5SxPULL72_+SDeiub_YUhZiqSNsDA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAM4LOhUqzOm3MdGZv6CKP5SxPULL72_+SDeiub_YUhZiqSNsDA@mail.gmail.com>
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
To: Hikori Chandelure <h.chandelure@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 27, 2015 at 04:39:15PM -0400, Hikori Chandelure wrote:
> Hello,
> 
> I've been experiencing slow find performance on XFS ever since I started
> specifying su/sw parameters at mkfs.xfs. This happens even on a newly
> created XFS filesystem, after all of the data has been restored from
> another backup server via rsync.
> 
> The files on this server are almost entirely large, 50MB to 20GB, with an
> average of around 350MB per file. There are about 70,000 files and about
> 4,600 directories.
>
> When running the find command "find /array", it will list files and
> directories very slowly, all while using very little I/O or CPU. Keep in
> mind, this particular server is entirely idle, no other activity is going
> on.

What does "very slow" mean? In comparison to "fast"? Can you please
provide numbers to go along with your observations?

FYI. that find has to read about 75000 inodes, and with 20 files to
a directory, a single block IO per directory is required, too. If
all the inodes are densely packed, then that find requires around
(75000/32 + 5000) ~= 7500 IOs to complete.

Find is single threaded, and there's no readahead to speak of
because the directories are so small, which means find will
essentially be synchronous and bound by the average seek time of
each IO.

> # system info
> CentOS 6.6 running kernel 3.2.69 from kernel.org / xfsprogs 3.2.3 compiled
> from source
> Intel Xeon E3-1220
> 32GB DDR3 1333MHz ECC
> 24x 2TB 7.2k HGST Ultrastars

I'd assume a 8-10ms average seek time on these drives.  Hence if we
are taking an average seek per IO, then the find should take
somewhere around 7500 * 10ms = 75s.

> Areca 1882ix-24 w/ 1GB cache and BBU

And it's a hardware raid array, which makes IO performance
unpredictable. I'm betting that the different inode/directory block
allocation pattern that XFs is using when sunit/swidth is set is
affecting the cache hit rate in the controller, and so the
difference is the average IO time of the two workloads is very
difference. If this is the case, then I'd expect the average IO time
is going to be sub-1ms for the unaligned case and so anything up to
10x faster than the aligned case.

'iostat -d -m -x 5' will tell you what the average IO times are.

FWIW, this is why actually posting numbers rather than saying
"it is slow" is important. Numbers will tell me if I have a viable
hypothesis.

> # xfs_db -r -c freesp /dev/sda
>    from      to extents  blocks    pct
>       1       1    2205    2205   0.00
>       2       3    4135   10334   0.00
>       4       7    8049   44059   0.00
>       8      15   15579  179253   0.00
>      16      31   31701  744701   0.01
>      32      63      46    1758   0.00

Those numbers are indicative - there lots of small free space chunks
between 64k and 128k in size, which confirms my suspicions that this
is probably due to the way inode allocation works on sunit/switdh
enabled filesystems.

XFS lays out inodes like this when sunit/swidth are set: it sunit
aligns the clusters if it can't allocation the next inode chunk
adjacent to the previous one. Hence with small directories, the
on-disk layout is going to look something like:

   su      su      su      su      su      su      su      su
   +-------+-------+-------+-------+-------+-------+-------+
    IDDDFFDIDDFFFFDIDDFFFFDIDDFFFFDIDDFFFFDIDDFFFFDIDDFFFFDI....

Where I = a 64 inode chunk, D is a directory block, F is free space.
I'd be expecting a sunit to contain 16k of inodes (1 chunk), 3-4
directory blocks (12-16k), and the rest being free space (roughly
96k). The above numbers show the 16-31 block bucket has an average
size of ~24 blocks, which is 92k. i.e. the peak is right where I'd
expect it to be. Some of these will be from the tail of data
extents, but it's still instructive.

This occurs because directory allocations are interleaved with inode
allocation, and with an average of 20 files per directory there are
going to be ~3 directory blocks per inode chunk (depending on
filename length). So we allocate an inode chunk, then as we create
more files, a directory block is allocated as close to the parent
inode as possible before all the free inodes in the chunk are
consumed and hence the next inode chunk allocation gets stripe unit
aligned. So you can see that the allocation pattern is less than
ideal in this "lots of small directories" case.

When sunit is not set, inode allocation just takes the next
nearest free space like so:

   su      su      su      su      su      su      su      su
   +-------+-------+-------+-------+-------+-------+-------+
    IDDDIDDDIDDDIDDDIDDDIDDDIDDDIDDDIDDDIDDDIDDDIDDDIDDDIDDD....

Which means that there are no backwards seeks to read directories,
and the stripe cache in the RAID hardware is likely to be hit much
more often than the sunit/swidth aligned case.

I know, you are now asking "why does XFS do this when sunit/swidth"
are set? It's because when you have large directories, the
allocation pattern as a result of the sunit/swidth alignment of
inodes ends up looking like:

   su      su      su      su      su      su      su      su
   +-------+-------+-------+-------+-------+-------+-------+
    IDDDDDDIIIDDDDDDDDDDDDDIIIIIDDDDDDDDDDDIIIIIDDDDDDDDDDDI...

and so we end up with much contiguous runs of blocks alternating
between directory data and inode chunks. This means performance of
large directories is much better when sunit/swidth is set because
readdir will hit sequential blocks on disk (and so the readahead
will be very effective) and the followup stat() of each inode will
also then hit sequential blocks on disk.

If sunit/swidth are not set, then the large directory allocation
pattern is unchanged from the above small directory case, and so
readdir has to seek regularly, as does the followup stat() calls to
read inodes. It requires a lot more IO, readahead is less effective,
and so performance is typically a lot worse.

i.e. the sunit/swidth inode allocation optimisations are really what
makes XFS directories scale effectively to really large sizes.

IOWs, if readdir/find  performance is really critical to your
workload that has small directories, then turn off sunit/swidth. If
that traversal behaviour is not a critical part of your production
workload (i.e it's just something you observed), then you are
probably best to ignore it as sunit/swidth will help optimise the
layout and performance of your large file IO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

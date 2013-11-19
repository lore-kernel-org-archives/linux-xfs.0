Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7A2097F4E
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 16:17:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 35FE08F8054
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 14:17:56 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	czJq6QVIt4tY06rK for <xfs@oss.sgi.com>;
	Tue, 19 Nov 2013 14:17:53 -0800 (PST)
Date: Wed, 20 Nov 2013 09:17:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 00/11] xfs: introduce the free inode btree
Message-ID: <20131119221748.GR11434@dastard>
References: <1384353427-36205-1-git-send-email-bfoster@redhat.com>
	<20131113161711.GA14300@infradead.org>
	<5283BD1A.8000704@redhat.com> <20131113211017.GI6188@dastard>
	<528BD853.8090900@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <528BD853.8090900@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Nov 19, 2013 at 04:29:55PM -0500, Brian Foster wrote:
> On 11/13/2013 04:10 PM, Dave Chinner wrote:
> ...
> > 
> > The problem can be demonstrated with a single CPU and a single
> > spindle. Create a single AG filesystem of a 100GB, and populate it
> > with 10 million inodes.
> > 
> > Time how long it takes to create another 10000 inodes in a new
> > directory. Measure CPU usage.
> > 
> > Randomly delete 10,000 inodes from the original population to
> > sparsely populate the inobt with 10000 free inodes.
> > 
> > Time how long it takes to create another 10000 inodes in a new
> > directory. Measure CPU usage.
> > 
> > The difference in time and CPU will be diretly related to the
> > addition time spent searching the inobt for free inodes...
> > 
> 
> Thanks for the suggestion, Dave. I've run some fs_mark tests along the
> lines of what is described here. I create 10m files, randomly remove
> ~10k from that dataset and measure the process of allocating 10k new
> inodes in both finobt and non-finobt scenarios (after a clean remount).
> 
> The tests run from a 4xcpu VM with 4GB RAM and against an isolated SATA
> drive I had lying around (mapped directly via virtio). The drive is
> formatted with a single VG/LV and as follows with xfs:
> 
> meta-data=/dev/mapper/testvg-testlv isize=512    agcount=1,
> agsize=26214400 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=0
> data     =                       bsize=4096   blocks=26214400, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal               bsize=4096   blocks=12800, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Once the fs has been prepared with a random set of free inodes, the
> following command is used to measure performance:
> 
> 	fs_mark -k -S 0 -D 4 -L 10 -n 1000 -s 0 -d /mnt/testdir
> 
> I've also collected some perf record data of these commands to compare
> CPU usage. I can make the full/raw data available if desirable. Snippets
> of the results are included below.
> 
> --- non-finobt, agi freecount = 9961 after random removal
> 
> - fs_mark
> 
> FSUse%        Count         Size    Files/sec     App Overhead
>      5         1000            0       1020.1            10811
>      5         2000            0        361.4            19498
>      5         3000            0        230.1            12154
>      5         4000            0        166.7            12816
>      5         5000            0        129.7            27409
>      5         6000            0        105.7            13946
>      5         7000            0         87.6            31792
>      5         8000            0         77.8            14921
>      5         9000            0         67.3            15597
>      5        10000            0         62.4            15835

Yes, that's pretty much as I expected - exponential degradation due
to the increasing search radius from the parent directory location...

> --- finobt, agi freecount = 10137 after random removal
> 
> - fs_mark
> 
> FSUse%        Count         Size    Files/sec     App Overhead
>      5         1000            0       9210.0             8587
>      5         2000            0       5592.1            14933
>      5         3000            0       7095.4            11355
>      5         4000            0       5371.1            13613
>      5         5000            0       4919.3            14534
>      5         6000            0       4375.7            15813
>      5         7000            0       5011.3            15095
>      5         8000            0       4629.8            17902
>      5         9000            0       5622.9            12975
>      5        10000            0       5761.4            12203

And that shows little, if any degradation once we toss the first
1000 inodes from the result. Nice demonstration!

> Summarized, the results show a nice improvement for inode allocation
> into a set of inode chunks with random free inode availability. The 10k
> inode allocation reduces from ~90s to ~2s and CPU usage from XFS drops
> way down in the perf profile.
> 
> I haven't extensively tested the following, but a quick 1 million inode
> allocation test on a fresh, single AG fs shows a slight degradation with
> the finobt enabled in terms of time to complete:
> 
> 	fs_mark -k -S 0 -D 4 -L 10 -n 100000 -s 0 -d /mnt/bigdir
> 
> - non-finobt
> 
> real    1m35.349s
> user    0m4.555s
> sys     1m29.749s
> 
> - finobt
> 
> real    1m42.396s
> user    0m4.326s
> sys     1m37.152s

Given that you have multiple threads banging on the same AGI, and
the hold time for the AGI is going to be slightly longer due to
needing to update two btrees instead of one, this is to be expected.

However, if you are in a memory limited situation, there's a good
chance that the lower memory footprint of the buffer cache as a
result of the finobt based searches will make a difference to these
results. With 4GB of RAM and 1M inodes, you're not generating memory
pressure and so such effects won't be seen in performance results.

As it is, the parallel fsmark tests I did on v1 of the patchset on a
fast SSD based filesystem (sparse 100TB filesystem) showed a small
improvement in performance with finobt enabled. Those tests spend
most of their time in memory pressure situations, so perhaps we're
actually seeing the difference here. However, I haven't tested the
current version yet, so take that with a grain of salt for the
moment.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

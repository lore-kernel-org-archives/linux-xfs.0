Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 98F7A7CBF
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 15:00:53 -0500 (CDT)
Date: Mon, 3 Jun 2013 15:00:53 -0500
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: Debunking myths about metadata CRC overhead
Message-ID: <20130603200052.GB863@sgi.com>
References: <20130603074452.GZ29466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130603074452.GZ29466@dastard>
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

On Mon, Jun 03, 2013 at 05:44:52PM +1000, Dave Chinner wrote:
| Hi folks,
| 
| There has been some assertions made recently that metadata CRCs have
| too much overhead to always be enabled.  So I'll run some quick
| benchmarks to demonstrate the "too much overhead" assertions are
| completely unfounded.

Thank you, much appreciated.

| fs_mark workload
| ----------------
...
| So the lock contention is variable - it's twice as high in this
| short sample as the overall profile I measured above. It's also
| pretty much all VFS cache LRU lock contention that is causing the
| problems here. IOWs, the slowdowns are not related to the overhead
| of CRC calculations; it's the change in memory access patterns that
| are lowering the threshold of catastrophic lock contention that is
| causing it. This VFS LRU problem is being fixed independently by the
| generic numa-aware LRU list patchset I've been doing with Glauber
| Costa.
| 
| Therefore, it is clear that the slowdown in this phase is not caused
| by the overhead of CRCs, but that of lock contention elsewhere in
| the kernel.  The unlink profiles show the same the thing as the walk
| profiles - additional lock contention on the lookup phase of the
| unlink walk.

I get it that the slowdown is not caused by the numerical operations to
calculate the CRCs, but as a overall feature, I don't see how you can
say that CRCs are not responsible for the slowdown.  If CRCs are
introducing lock contention, it doesn't matter if that lock contention
is in XFS code or elsewhere in the kernel, it is still a slowdown which
can be attributed to the CRC feature.  Spin it as you like, it still
appears to me that there's a huge impact on the walk and unlink phases
from CRC calculations.

| ----
| 
| Dbench:
...
| Well, now that's an interesting result, isn't it. CRC enabled
| filesystems are 10% faster than non-crc filesystems. Again, let's
| not take that number at face value, but ask ourselves why adding
| CRCs improves performance (a.k.a. "know your benchmark")...
| 
| It's pretty obvious why - dbench uses xattrs and performance is
| sensitive to how many attributes can be stored inline in the inode.
| And CRCs increase the inode size to 512 bytes meaning attributes are
| probably never out of line. So, let's make it an even playing field
| and compare:

CRC filesystems default to 512 byte inodes?  I wasn't aware of that.
Sure, CRC filesystems are able to move more volume, but the metadata is
half the density as it was before.  I'm not a dbench expert, so I have
no idea what the ratio of metadata to data is here, so I really don't
know what conclusions to draw from the dbench results.

What really bothers me is the default of 512 byte inodes for CRCs.  That
means my inodes take up twice as much space on disk, and will require
2X the bandwidth to read from disk.  This will have significant impact
on SGI's DMF managed filesystems.  I know you don't care about SGI's
DMF, but this will also have a significant performance impact on
xfsdump, xfsrestore, and xfs_repair.  These performance benchmarks are
just as important to me as dbench and compilebench.

| ----
| 
| Compilebench
| 
| Testing the same filesystems with 512 byte inodes as for dbench:
| 
| $ ./compilebench -D /mnt/scratch
| using working directory /mnt/scratch, 30 intial dirs 100 runs
| .....
| 
| test				no CRCs		CRCs
| 			runs	avg		avg
| ==========================================================================
| intial create		30	92.12 MB/s	90.24 MB/s
| create			14	61.91 MB/s	61.13 MB/s
| patch			15	41.04 MB/s	38.00 MB/s
| compile			14	278.74 MB/s	262.00 MB/s
| clean			10	1355.30 MB/s	1296.17 MB/s
| read tree		11	25.68 MB/s	25.40 MB/s
| read compiled tree	4	48.74 MB/s	48.65 MB/s
| delete tree		10	2.97 seconds	3.05 seconds
| delete compiled tree	4	2.96 seconds	3.05 seconds
| stat tree		11	1.33 seconds	1.36 seconds
| stat compiled tree	7	1.86 seconds	1.64 seconds
| 
| The numbers are so close that the differences are in the noise, and
| the CRC overhead doesn't even show up in the ">1% usage" section
| of the profile output.

What really surprises me in these results is the hit that the compile
phase takes.  That is a 6% performance drop in an area where I expect
the CRCs to have limited effect.  To me, the results show a rather
consistent performance drop of up to 6%, and is sufficient to support my
assertion that the CRCs overhead may outweigh the benefits.

| ----
| 
| Looking at these numbers realistically, dbench and compilebench
| model two fairly common metadata intensive workloads - file servers
| and code tree manipulations that developers tend to use all the
| time. The difference that CRCs make to performance in these
| workloads on equivalently configured filesystems varies between
| 0-5%, and for most operations they are small enough that they can
| just about be considered to be noise.
| 
| Yes, we could argue over the fsmark walk/unlink phase results, but
| the synthetic fsmark workload is designed to push the system to it's
| limits and it's obvious that the addition of CRCs pushes the VFS into
| lock contention hell. Further, we have to recognise that the same
| workload on a 12p VM (run 12-way instead of 8-way) without CRCs hits
| the same lock contention problem. IOWs, the slowdown is most
| definitely not caused by the addition of CRC calculations to XFS
| metadata.
| 
| The CPU overhead of CRCs is small and may be outweighed by other
| changes for CRC filesystems that improve performance far more than
| the cost of CRC calculations degrades it.  The numbers above simply
| don't support the assertion that metadata CRCs have "too much
| overhead".

Do I want to take a 5% performance hit in filesystem performance and
double the size of my inodes for an unproved feature?  I am still
unconvinced that CRCs are a feature that I want to use.  Others may see
enough benefit in CRCs to accept the performance hit.  All I want is to
ensure that I the option going forward to chose not to use CRCs without
sacrificing other features introduced XFS.


-- 
Geoffrey Wehrman
SGI Building 10                             Office: (651)683-5496
2750 Blue Water Road                           Fax: (651)683-5098
Eagan, MN 55121                             E-mail: gwehrman@sgi.com
	  http://www.sgi.com/products/storage/software/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

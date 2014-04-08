Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6AED78028
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 20:50:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3564AC012
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 18:50:27 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	tmtEJzI2ZGPwNDVU for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 18:50:25 -0700 (PDT)
Date: Tue, 8 Apr 2014 11:50:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS fragmentation on file append
Message-ID: <20140408015012.GB22917@dastard>
References: <CAJhmKHmwvCBx=arJ6m2ZhuQVq=Jj-XbBGvEPjTPY5a1QtWRTCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJhmKHmwvCBx=arJ6m2ZhuQVq=Jj-XbBGvEPjTPY5a1QtWRTCQ@mail.gmail.com>
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

[cc the XFS mailing list <xfs@oss.sgi.com>]

On Mon, Apr 07, 2014 at 06:53:46PM -0400, Keyur Govande wrote:
> Hello,
> 
> I'm currently investigating a MySQL performance degradation on XFS due
> to file fragmentation.
> 
> The box has a 16 drive RAID 10 array with a 1GB battery backed cache
> running on a 12 core box.
> 
> xfs_info shows:
> meta-data=/dev/sda4    isize=256    agcount=24, agsize=24024992 blks
>                =                 sectsz=512   attr=2, projid32bit=0
> data         =                 bsize=4096   blocks=576599552, imaxpct=5
>                =                 sunit=16     swidth=512 blks
> naming   = version 2     bsize=4096   ascii-ci=0
> log         = internal       bsize=4096   blocks=281552, version=2
>              =                   sectsz=512   sunit=16 blks, lazy-count=1
> realtime = none            extsz=4096   blocks=0, rtextents=0
> 
> The kernel version is: 3.14.0-1.el6.elrepo.x86_64 and the XFS
> partition is mounted with: rw,noatime,allocsize=128m,inode64,swalloc.
> The partition is 2TB in size and 40% full to simulate production.
> 
> Here's a test program that appends 512KB like MySQL does (write and
> then fsync). To exacerbate the issue, it loops a bunch of times:
> https://gist.github.com/keyurdg/961c19175b81c73fdaa3
> 
> When run, this creates ~9500 extents most of length 1024.

1024 of what? Most likely it is 1024 basic blocks, which is 512KB,
the size of your writes.

Could you post the output of the xfs_bmap commands you are using to
get this information?

> cat'ing the
> file to /dev/null after dropping the caches reads at an average of 75
> MBps, way less than the hardware is capable of.

What you are doing is "open-seekend-write-fsync-close".  You haven't
told the filesystem you are doing append writes (O_APPEND, or the
append inode flag) so it can't optimise for them.

You are also cleaning the file before closing it, so you are
defeating the current heuristics that XFS uses to determine whether
to remove speculative preallocation on close() - if the inode is
dirty at close(), then it won't be removed. Hence speculative
preallocation does nothing for your IO pattern (i.e. the allocsize
mount option is completely useless). Remove the fsync and you'll
see your fragmentation problem go away completely.

> When I add a posix_fallocate before calling pwrite() as shown here
> https://gist.github.com/keyurdg/eb504864d27ebfe7b40a the file
> fragments an order of magnitude less (~30 extents), and cat'ing to
> /dev/null proceeds at ~1GBps.

That should make no difference on XFS as you are only preallocating
the 512KB region beyond EOF that you are about to write into and
hence both delayed allocation and preallocation have the same
allocation target (the current EOF block). Hence in both cases the
allocation patterns should be identical if the freespace extent they
are being allocated out of are identical.

Did you remove the previous test files and sync the filesystem
between test runs so that the available freespace was identical for
the different test runs? If you didn't then the filesystem allocated
the files out of different free space extents and hence you'll get
different allocation patterns...

> The same behavior is seen even when the allocsize option is removed
> and the partition remounted.

See above.

> This is somewhat unexpected and I'm working on a patch to add
> fallocate to MySQL, wanted to check in here if I'm missing anything
> obvious here.

fallocate() of 512KB sized regions will not prevent fragmentation
into 512KB sized extents with the write pattern you are using.

If you use the inode APPEND attribute for your log files, this lets
the filesystem optimise it's block management for append IO. In the
case of XFS, it then will not remove preallocation beyond EOF when
the fd is closed because the next write will be at EOF where the
speculative preallocation already exists. Then allocsize=128M will
actually work for your log files....

Alternatively, set an extent size hint on the log files to define
the minimum sized allocation (e.g. 32MB) and this will limit
fragmentation without you having to modify the MySQL code at all...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

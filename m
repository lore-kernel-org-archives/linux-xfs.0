Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALBVlDw255477 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 05:31:47 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 525EF162AF86
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 03:31:44 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	oW7nF5wCYwdUZ9ht for <xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 03:31:44 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC][PATCH 0/8] xfstests: rework large filesystem testing
Date: Mon, 21 Nov 2011 22:31:20 +1100
Message-Id: <1321875088-30801-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

This series changes the way xfstests configures large filesystems
for testing. The assumption is that a sparse device is being used
for the large filesystem, be it a loop device or a thin provisioned
LUN. The key to make this work is marking large amounts of the
filesystem as used without having to actually write data to the
filesystem.

In the case of XFS, it always used to use a special xfs_db hack to
modify the free space in the AG headers to make them appear full.
This meant that xfs_check needed special options to avoid checking
free space as this way of marking space free is really a corrupted
filesystem state. Before we can use xfs_repair on such filesystems,
we need to change the way we mark blocks free.

So, change the method of marking space free to use preallocation.
For XFS, we can simply preallocate as much space as we need to
consume on a single file, essentially giving use a free "that's a
frickin' huge file" test. This is slower than the old xfs_db method,
but leaves the filesystem in a consistent state. It also means the
free space is not in the last AG - instead the free space will
usually be located in the same AG as the log.

This means that we can now use an unmodified xfs_repair binary to
check the consistency of the filesystem. We still need to avoid
free-space checking with xfs_check because of it's memory
consumption, but we at least will now get that checked by
xfs_repair.

There are numerous other cleanups and ease-of use modifications such
as command line parameters for executing large filesystem testing
rather than having to know about magic environment variables.

Further, the same preallocation technique can be used for testing on
ext4. The last patch of the series (not well tested yet) enables
the preallocation space filling technique for ext4 filesystems.

ext4, however, still has serious issues with this - either we take
the mkfs.ext4 time hit to initialise all the block groups, or we
take it during the preallocation.  IOWs, the "don't do work at mkfs
but do it after mount" hack^Wtradeoff simply does not work for
testing large filesystems in this manner.  While it is possible to
run large filesystem tests on ext4 using this mechanism, it is
extremely painful to do so.

Indeed, test runtime on ext4 is abysmal compared to XFS. XFS takes
about 15-20s to mkfs a 20TB filesystem and preallocate a 19.8TB
file, and about 2m to check it. ext4 took somewhere in the
order of 5 minutes to do the same operation on a loopback fs on a
SATA drive, while e2fsck -f takes 20 minutes to run.  e.g: test 223
runs mkfs 4 times:

$ sudo ./check  --large-fs 223
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 test-2 3.2.0-rc2-dgc+
MKFS_OPTIONS  -- /dev/loop0
MOUNT_OPTIONS -- -o acl,user_xattr /dev/loop0 /mnt/scratch/scratch

223 143s ... 1567s
Ran: 223
Passed all 1 tests
$ sudo time e2fsck -f /dev/loop0
e2fsck 1.42-WIP (16-Oct-2011)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/loop0: 54/335544320 files (0.0% non-contiguous),
5368709120/5368709120 blocks
1131.16user 4.36system 19:12.59elapsed 98%CPU (0avgtext+0avgdata
6153616maxresident)k
0inputs+0outputs (3major+933709minor)pagefaults 0swaps

compared to XFS:

$ sudo ./check  --large-fs 223
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 test-2 3.2.0-rc2-dgc+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop0
MOUNT_OPTIONS -- /dev/loop0 /mnt/scratch/scratch

223 1567s ... 144s
Ran: 223
Passed all 1 tests
dave@test-2:~/src/xfstests-dev$ sudo time xfs_repair /dev/loop0
Phase 1 - find and verify superblock...
Not enough RAM available for repair to enable prefetching.
This will be _slow_.
You need at least 3261MB RAM to run with prefetching enabled.
Phase 2 - using internal log
......
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
0.00user 0.26system 2:23.09elapsed 0%CPU (0avgtext+0avgdata 11200maxresident)k
0inputs+0outputs (5major+951minor)pagefaults 0swaps

This is why I haven't really tested it all that much - I'm not even
really sure it is working properly yet because execution of a single
test can take half an hour for a 20TB filesystem.  I encourage the
ext4 developers to work towards fixing these problems to help speed
up large filesystem testing cycles.

FWIW, I haven't yet written the btrfs code to enable this form of
large filesystem testing - that's the next patch I'm going to write.
I'm not sure what to expect from that.

Comments, flames, suggestions all welcome....

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

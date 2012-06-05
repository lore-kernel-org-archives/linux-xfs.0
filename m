Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q55Mdbqa133579 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 17:39:37 -0500
Date: Tue, 5 Jun 2012 17:46:00 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfstest 285: userspace vs. fragmented multiblock dir2
Message-ID: <20120605224600.GN4721@sgi.com>
References: <4FBABC41.5040001@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FBABC41.5040001@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Hey Eric,

On Mon, May 21, 2012 at 05:05:53PM -0500, Eric Sandeen wrote:
> Current xfs_repair is unhappy with fragmented multiblock
> v2 directories.  This test shows it ... patches to fix
> it soon to follow.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

This failed on my system... looks like it's just PEBKAC.  My partitions
are too small?

# ./check 287
No patches applied
KERNEL_TOPDIR -- /root/xfs
BRANCH        -- refs/heads/master2
DESC          -- v3.4-10158-gf8f5701
PATCHES:
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 nfs10 3.5.0-rc1-0.7-default+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb4
MOUNT_OPTIONS -- /dev/sdb4 /mnt/scratch

287      - no qualified output



Ran: 287
Failures: 287
Failed 1 of 1 tests

Regards,
	Ben

P.S. Here's the contents of $seq.full.

meta-data=/dev/sdb4              isize=256    agcount=4, agsize=8192 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=32768, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=16384  ascii-ci=0
log      =internal log           bsize=4096   blocks=1904, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
./287: line 60: /mnt/scratch/fragdir/f27196: No space left on device
./287: line 60: /mnt/scratch/fragdir/f27197: No space left on device
./287: line 60: /mnt/scratch/fragdir/f27198: No space left on device
./287: line 60: /mnt/scratch/fragdir/f27199: No space left on device
./287: line 60: /mnt/scratch/fragdir/f27200: No space left on device
wrote 16777216/16777216 bytes at offset 0
16 MiB, 4096 ops; 0.0000 sec (565.311 MiB/sec and 144719.6410 ops/sec)
   from      to extents  blocks    pct
      1       1   11197   11197 100.00
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
xfs_db got a bbmap for 127248
xfs_db got a bbmap for 195224
xfs_db got a bbmap for 195352
xfs_db got a bbmap for 195288
xfs_db got a bbmap for 248080
xfs_db got a bbmap for 247952
xfs_db got a bbmap for 247872
xfs_db got a bbmap for 247808
xfs_db got a bbmap for 247744
xfs_db got a bbmap for 247680
xfs_db got a bbmap for 247616
xfs_db got a bbmap for 247520
xfs_db got a bbmap for 247456
xfs_db got a bbmap for 247392
xfs_db got a bbmap for 248016
xfs_db got a bbmap for 248192
xfs_db got a bbmap for 248256
xfs_db got a bbmap for 248384
xfs_db got a bbmap for 248128
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 1
        - agno = 0
        - agno = 2
        - agno = 3
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

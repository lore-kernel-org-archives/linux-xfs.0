Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39209 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752537AbdDKOhP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2017 10:37:15 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3BEYwR1034215
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2017 10:37:15 -0400
Received: from e28smtp02.in.ibm.com (e28smtp02.in.ibm.com [125.16.236.2])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29rpfhm9mx-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2017 10:37:14 -0400
Received: from localhost
        by e28smtp02.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 11 Apr 2017 20:07:11 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] iomap_dio_rw: Prevent reading file data beyond iomap_dio->i_size
Date: Tue, 11 Apr 2017 20:07:06 +0530
In-Reply-To: <1960778.O56fy3BF0d@localhost.localdomain>
References: <1491557563-3278-1-git-send-email-chandan@linux.vnet.ibm.com> <20170407162528.GG4864@birch.djwong.org> <1960778.O56fy3BF0d@localhost.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <1948133.MfiAEyxZbW@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, sandeen@sandeen.net, linux-fsdevel@vger.kernel.org

On Sunday, April 09, 2017 08:39:44 PM Chandan Rajendra wrote:
> On Friday, April 07, 2017 09:25:28 AM Darrick J. Wong wrote:
> > On Fri, Apr 07, 2017 at 03:02:43PM +0530, Chandan Rajendra wrote:
> > > On a ppc64 machine executing overlayfs/019 with xfs as the lower and
> > > upper filesystem causes the following call trace,
> > > 
> > > WARNING: CPU: 2 PID: 8034 at /root/repos/linux/fs/iomap.c:765 .iomap_dio_actor+0xcc/0x420
> > > Modules linked in:
> > > CPU: 2 PID: 8034 Comm: fsstress Tainted: G             L  4.11.0-rc5-next-20170405 #100
> > > task: c000000631314880 task.stack: c0000003915d4000
> > > NIP: c00000000035a72c LR: c00000000035a6f4 CTR: c00000000035a660
> > > REGS: c0000003915d7570 TRAP: 0700   Tainted: G             L   (4.11.0-rc5-next-20170405)
> > > MSR: 800000000282b032 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI>
> > >   CR: 24004284  XER: 00000000
> > > CFAR: c0000000006f7190 SOFTE: 1
> > > GPR00: c00000000035a6f4 c0000003915d77f0 c0000000015a3f00 000000007c22f600
> > > GPR04: 000000000022d000 0000000000002600 c0000003b2d56360 c0000003915d7960
> > > GPR08: c0000003915d7cd0 0000000000000002 0000000000002600 c000000000521cc0
> > > GPR12: 0000000024004284 c00000000fd80a00 000000004b04ae64 ffffffffffffffff
> > > GPR16: 000000001000ca70 0000000000000000 c0000003b2d56380 c00000000153d2b8
> > > GPR20: 0000000000000010 c0000003bc87bac8 0000000000223000 000000000022f5ff
> > > GPR24: c0000003b2d56360 000000000000000c 0000000000002600 000000000022d000
> > > GPR28: 0000000000000000 c0000003915d7960 c0000003b2d56360 00000000000001ff
> > > NIP [c00000000035a72c] .iomap_dio_actor+0xcc/0x420
> > > LR [c00000000035a6f4] .iomap_dio_actor+0x94/0x420
> > > Call Trace:
> > > [c0000003915d77f0] [c00000000035a6f4] .iomap_dio_actor+0x94/0x420 (unreliable)
> > > [c0000003915d78f0] [c00000000035b9f4] .iomap_apply+0xf4/0x1f0
> > > [c0000003915d79d0] [c00000000035c320] .iomap_dio_rw+0x230/0x420
> > > [c0000003915d7ae0] [c000000000512a14] .xfs_file_dio_aio_read+0x84/0x160
> > > [c0000003915d7b80] [c000000000512d24] .xfs_file_read_iter+0x104/0x130
> > > [c0000003915d7c10] [c0000000002d6234] .__vfs_read+0x114/0x1a0
> > > [c0000003915d7cf0] [c0000000002d7a8c] .vfs_read+0xac/0x1a0
> > > [c0000003915d7d90] [c0000000002d96b8] .SyS_read+0x58/0x100
> > > [c0000003915d7e30] [c00000000000b8e0] system_call+0x38/0xfc
> > > Instruction dump:
> > > 78630020 7f831b78 7ffc07b4 7c7ce039 40820360 a13d0018 2f890003 419e0288
> > > 2f890004 419e00a0 2f890001 419e02a8 <0fe00000> 3b80fffb 38210100 7f83e378
> > > 
> > > The above problem can also be recreated on a regular xfs filesystem
> > > using the command,
> > > 
> > > $ fsstress -d /mnt -l 1000 -n 1000 -p 1000
> > > 
> > > The reason for the call trace is,
> > > 1. When 'reserving' blocks for delayed allocation , XFS reserves more
> > >    blocks (i.e. past file's current EOF) than required. This is done
> > >    because XFS assumes that userspace might write more data and hence
> > >    'reserving' more blocks might lead to the file's new data being
> > >    stored contiguously on disk.
> > > 2. The in-memory 'struct xfs_bmbt_irec' mapping the file's last extent would
> > >    then cover the prealloc-ed EOF blocks in addition to the regular blocks.
> > > 3. When flushing the dirty blocks to disk, we only flush data till the
> > >    file's EOF. But before writing out the dirty data, we allocate blocks
> > >    on the disk for holding the file's new data. This allocation includes
> > >    the blocks that are part of the 'prealloc EOF blocks'.
> > > 4. Later, when the last reference to the inode is being closed, XFS frees the
> > >    unused 'prealloc EOF blocks' in xfs_inactive().
> > > 
> > > In step 3 above, When allocating space on disk for the delayed allocation
> > > range, the space allocator might sometimes allocate less blocks than
> > > required. If such an allocation ends right at the current EOF of the
> > > file, We will not be able to clear the "delayed allocation" flag for the
> > > 'prealloc EOF blocks', since we won't have dirty buffer heads associated
> > > with that range of the file.
> > > 
> > > In such a situation if a Direct I/O read operation is performed on file
> > > range [X, Y] (where X < EOF and Y > EOF), we flush dirty data in the
> > > range [X, Y] and invalidate page cache for that range (Refer to
> > > iomap_dio_rw()). Later for performing the Direct I/O read, XFS obtains
> > > the extent items (which are still cached in memory) for the file
> > > range. When doing so we are not supposed to get an extent item with
> > > IOMAP_DELALLOC flag set, since the previous "flush" operation should
> > > have converted any delayed allocation data in the range [X, Y]. Hence we
> > > end up hitting a WARN_ON_ONCE(1) statement in iomap_dio_actor().
> > > 
> > > This commit fixes the bug by preventing the read operation from going
> > > beyond iomap_dio->i_size.
> > > 
> > > Reported-by: Santhosh G <santhog4@linux.vnet.ibm.com>
> > > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > Looks ok to me, but I'll wait for the test before making further decisions.
> > 
> 
> The command 'fsstress -d /mnt -l 1000 -n 1000 -p 1000' takes a long time for
> execution. It does not complete even after 30 mins of run time.
> 
> Hence I tried the following command line sequence for the new xfstests' test,
> 
> # mkfs.xfs -f -d size=256m /dev/loop0
> # mount /dev/loop0 /mnt/
> # xfs_io -f -c 'pwrite 0 64k' /mnt/test-file
> # dd if=/dev/zero of=/mnt/filler bs=4k
> # for i in $(seq 1 2 32); do offset=$(($i * 4096)); xfs_io -f -c "fpunch $offset 4k" -c sync /mnt/filler; done
> # xfs_io -f -c 'pwrite 64k 4k' /mnt/test-file # Prealloc blocks are reserved beyond file offset (68k - 1).
> # xfs_io -f -d -c 'pread 64k 64k' /mnt/test-file
> 
> The last command which performs a direct read operation beyond file's EOF
> should have triggered the call trace. But I noticed (via printk statements)
> that XFS was able to successfully allocate (4k + prealloc blocks) worth of
> contiguous space for /mnt/test-file.
> 
> I am still trying to figure out how XFS was able to allocate the EOF prealloc
> blocks when it shouldn't have had any contiguous space larger than 4k bytes.

Hi Darrick,

I am unable to recreate the issue using the script provided below,

--------------------------------------------------------------------------------
#!/usr/bin/zsh -f

[[ $ARGC != 2 ]] && { print "Usage: $0 <device> <mount point>"; exit 1 }

device=$1
mntpnt=$2

test_file=$mntpnt/test-file
filler_file=$mntpnt/filler

print "Device = $device"
print "Mount point = $mntpnt"

umount $device > /dev/null 2>&1
mkfs.xfs -f -d size=256m $device || { print "mkfs.xfs failed"; exit 1 }
mount $device $mntpnt || { print "mounting $device failed"; exit 1 }

xfs_io -f -c 'pwrite 0 64k' $test_file
sync
dd if=/dev/zero of=$filler_file bs=4k
sync

for i in $(seq 1 2 31); do
        offset=$(($i * 4096));
        printf "Fpunching hole at range: %d - %d\n" $offset $(($offset + 4096 - 1))
        xfs_io -f -c "fpunch $offset 4k" -c sync $filler_file;
done

xfs_io -f -c 'pwrite 64k 4k' $test_file
xfs_io -f -d -c 'pread 64k 64k' $test_file

exit 0
--------------------------------------------------------------------------------

When the last but one command (i.e. "xfs_io -f -c 'pwrite 64k 4k' $test_file")
is executed, XFS is able to somehow reserve 16 blocks (1 required 4k block +
15 prealloc 4k blocks). Ideally this shouldn't have happened because we would
have punched only 15 blocks in $filler_file.

Also, During space allocation (i.e. xfs_map_blocks()), I see that the space
allocation code was able to allocate an extent of 16 blocks (1 required 4k
block + 15 prealloc blocks). Again, this shouldn't have happened since
$filler_file would have occupied the rest of the free space and fpunch was
performed on alternating blocks.

Just after executing the series of "fpunch" commands in the above script, I
observe the following,

[root@localhost xfstests-dev]# xfs_db /dev/loop0
xfs_db> freesp                                  
   from      to extents  blocks    pct          
      1       1      32      32   0.94          
      2       3       1       3   0.09          
     32      63       1      45   1.32          
     64     127       2     144   4.24          
   2048    4095       1    3173  93.41          

Basically, I feel that it is quite impossible to control the free space usage
of an XFS filesystem in a granularity as required to recreate this bug.

As I has informed earlier, "fsstress -d /mnt -l 1000 -n 1000 -p 1000" does not
complete even after 30 mins of execution on a loop device which has a file on
tmpfs as its backing device.

Please let me know if you have any hints/thoughts about how I could proceed.

-- 
chandan


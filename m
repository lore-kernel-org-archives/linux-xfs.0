Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46854 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726904AbeJQTP5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Oct 2018 15:15:57 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 718A92AE39
        for <linux-xfs@vger.kernel.org>; Wed, 17 Oct 2018 11:20:42 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201453] New: Bug 1640090 - [xfstests xfs/490]: xfs_db print a
 bad (negative number) as agi freecount
Date: Wed, 17 Oct 2018 11:20:42 +0000
Message-ID: <bug-201453-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201453

            Bug ID: 201453
           Summary: Bug 1640090 - [xfstests xfs/490]: xfs_db print a bad
                    (negative number) as agi freecount
           Product: File System
           Version: 2.5
    Kernel Version: v4.18
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

Description of problem:
On s390x, I hit a xfs/490 failure (can't reproduce it on x86_64). By manually
debuging, I find:

# mkfs.xfs -f -m finobt=0 /dev/loop1                                            
meta-data=/dev/loop1             isize=512    agcount=4, agsize=786496 blks     
         =                       sectsz=512   attr=2, projid32bit=1             
         =                       crc=1        finobt=0, sparse=1, rmapbt=0      
         =                       reflink=1
data     =                       bsize=4096   blocks=3145984, imaxpct=25        
         =                       sunit=0      swidth=0 blks                     
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1               
log      =internal log           bsize=4096   blocks=2560, version=2            
         =                       sectsz=512   sunit=0 blks, lazy-count=1        
realtime =none                   extsz=4096   blocks=0, rtextents=0             
# mount /dev/loop1 /mnt/testarea/scratch/                                       
# mkdir /mnt/testarea/scratch/dir                                               
# xfs_io -fc "pwrite 0 4096" -c fsync /mnt/testarea/scratch/dir/testfile        
wrote 4096/4096 bytes at offset 0
4 KiB, 1 ops; 0.0000 sec (150.240 MiB/sec and 38461.5385 ops/sec)               
# stat -c %i /mnt/testarea/scratch/dir/testfile                                 
132
# umount /dev/loop1                                                             
# _scratch_xfs_db -c "convert inode 132 agno"                                   
0x0 (0)
# _scratch_xfs_get_metadata_field "recs[1].freecount" "agi 0" "addr root"       
-197
]# xfs_db -c "agi 0" -c "addr root" -c "print recs[1]" /dev/loop1               
recs[1] = [startino,holemask,count,freecount,free]
1:[128,0,64,-197,0xffffffffffffffe0]


Version-Release number of selected component (if applicable):
kernel 4.18
xfsprogs 4.19.0-rc0

How reproducible:
100% on s390x with loop device (at least from my testing)

Steps to Reproduce:
run xfs/490 on s390x

Actual results:
as above

Expected results:
test pass

Additional info:
I think it's not a kernel problem, the negative number maybe not real on disk.
Due to the SCRATCH_DEV still can be mounted without errors:

[root@ibm-z-110 xfstests]# mount /dev/loop1 /mnt/testarea/scratch
[root@ibm-z-110 xfstests]# dmesg|tail
[ 7289.790976] XFS (loop1): Mounting V5 Filesystem
[ 7289.796601] XFS (loop1): Ending clean mount

And it's not reproducible on x86_64:
# xfs_db -c "agi 0" -c "addr root" -c "print recs[1]" /dev/loop1
recs[1] = [startino,holemask,count,freecount,free] 
1:[128,0,64,59,0xffffffffffffffe0]

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

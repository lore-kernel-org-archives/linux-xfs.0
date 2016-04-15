Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AE7077CA0
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 23:23:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 40BDA304048
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 21:23:52 -0700 (PDT)
Received: from smtp-out-no.shaw.ca (smtp-out-no.shaw.ca [64.59.134.13]) by
	cuda.sgi.com with ESMTP id MUgemEDFXdYKFTBD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Apr 2016 21:23:43 -0700 (PDT)
Subject: Re: xfs_repair fails after trying to format log cycle?
References: <56F6DE67.60403@shaw.ca> <20160328085541.GA27040@bfoster.bfoster>
	<570C8D4D.3060304@shaw.ca> <20160412140512.GA59690@bfoster.bfoster>
	<570D578D.5010706@shaw.ca> <20160413121214.GA2775@bfoster.bfoster>
	<570EC95F.2010401@shaw.ca>
From: Andrew Ryder <tireman@shaw.ca>
Message-ID: <57106CF5.3050501@shaw.ca>
Date: Fri, 15 Apr 2016 00:24:21 -0400
MIME-Version: 1.0
In-Reply-To: <570EC95F.2010401@shaw.ca>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com

Success!!

The problem was the superblock at the mdadm layer was messed up somehow.

Re-creating the array to re-write the md superblock/metadata and running 
the first two xfs_repairs, without then with the -L option and it 
followed through then and completed the log formatting.. AND I can 
mount/unmount the array without having to run xfs_repair.

For some reason running a check of the array did not throw any errors or 
correct the messed up array parameters?

I'm going to assume when using md software arrays there is an md 
superblock as well as a superblock for the filesystem?

If you want a copy of the output of 'dmesg' to peruse, I can forward it.

Thanks again.


Bigmouth ~ # mount /dev/md2
mount: /dev/md2: can't read superblock
Bigmouth ~ # xfs_repair /dev/md2
Phase 1 - find and verify superblock...
         - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
         - zero log...
Log inconsistent (didn't find previous header)
failed to find log head
zero_log: cannot find log head/tail (xlog_find_tail=5)

fatal error -- ERROR: The log head and/or tail cannot be discovered. 
Attempt to mount the
filesystem to replay the log or use the -L option to destroy the log and
attempt a repair.
Bigmouth ~ # xfs_repair -L /dev/md2
Phase 1 - find and verify superblock...
         - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
         - zero log...
Log inconsistent (didn't find previous header)
failed to find log head
zero_log: cannot find log head/tail (xlog_find_tail=5)
         - scan filesystem freespace and inode maps...
         - 23:43:28: scanning filesystem freespace - 33 of 33 allocation 
groups done
         - found root inode chunk
Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
         - 23:43:28: scanning agi unlinked lists - 33 of 33 allocation 
groups done
         - process known inodes and perform inode discovery...
         - agno = 0
         - agno = 15
         - agno = 30
         - agno = 16
         - agno = 31
         - agno = 1
         - agno = 17
         - agno = 32
         - agno = 2
         - agno = 18
         - agno = 3
         - agno = 19
         - agno = 4
         - agno = 20
         - agno = 5
         - agno = 21
         - agno = 6
         - agno = 22
         - agno = 7
         - agno = 23
         - agno = 24
         - agno = 8
         - agno = 25
         - agno = 9
         - agno = 26
         - agno = 10
         - agno = 27
         - agno = 11
         - agno = 28
         - agno = 12
         - agno = 29
         - agno = 13
         - agno = 14
         - 00:01:59: process known inodes and inode discovery - 5789504 
of 5789504 inodes done
         - process newly discovered inodes...
         - 00:01:59: process newly discovered inodes - 33 of 33 
allocation groups done
Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - 00:01:59: setting up duplicate extent list - 33 of 33 
allocation groups done
         - check for inodes claiming duplicate blocks...
         - agno = 2
         - agno = 0
         - agno = 4
         - agno = 10
         - agno = 17
         - agno = 1
         - agno = 25
         - agno = 7
         - agno = 9
         - agno = 11
         - agno = 3
         - agno = 12
         - agno = 14
         - agno = 13
         - agno = 15
         - agno = 16
         - agno = 5
         - agno = 18
         - agno = 8
         - agno = 19
         - agno = 20
         - agno = 21
         - agno = 24
         - agno = 23
         - agno = 26
         - agno = 22
         - agno = 27
         - agno = 28
         - agno = 30
         - agno = 29
         - agno = 31
         - agno = 6
         - agno = 32
         - 00:02:00: check for inodes claiming duplicate blocks - 
5789504 of 5789504 inodes done
Phase 5 - rebuild AG headers and trees...
         - 00:02:01: rebuild AG headers and trees - 33 of 33 allocation 
groups done
         - reset superblock...
Phase 6 - check inode connectivity...
         - resetting contents of realtime bitmap and summary inodes
         - traversing filesystem ...
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
         - 00:11:30: verify and correct link counts - 33 of 33 
allocation groups done
Maximum metadata LSN (64:2230592) is ahead of log (1:64).
Format log to cycle 67.
done




On 04/13/2016 06:34 PM, Andrew Ryder wrote:
> That seems to make sense. I've started a check of the array and see what
> happens. I don't believe its a hardware error as neither sata pmp
> controller I have it on logs any hardware/cabling related errors at all.
>
> Thanks for the help so far. I'll let you know how I make out if I ever
> figure out where the gremlins are hiding..
>
> On 04/13/2016 08:12 AM, Brian Foster wrote:
>> On Tue, Apr 12, 2016 at 04:16:13PM -0400, Andrew Ryder wrote:
>>> On 04/12/2016 10:05 AM, Brian Foster wrote:
>>>> On Tue, Apr 12, 2016 at 01:53:17AM -0400, Andrew Ryder wrote:
>>>>>
>>>>>
>>>>> On 03/28/2016 04:55 AM, Brian Foster wrote:
>> ...
>>>> What happens if you manually issue the read call that failed? E.g.,
>>>> umount the filesystem and run the following command directly against
>>>> the
>>>> array:
>>>>
>>>> xfs_io -dc "pread 3001552175104 2097152" /dev/md2
>>>>
>>>> Brian
>>>
>>> It failed with the same error. I've attached the strace output for the
>>> command.
>>>
>>
>> Thanks, well that is interesting. The larger 2MB read eventually results
>> in this smaller (4k) read that fails:
>>
>> 16:02:14.221784 pread64(3, 0x1ce7000, 4096, 3001553125376) = -1 EIO
>> (Input/output error)
>>
>> So you could repeat that command with offset 3001553125376 and size 4k
>> and just confirm that still fails. As Dave points out, something is
>> wrong with the storage here and that is what needs to be resolved.
>>
>> With regard to the xfs_repair behavior... you're initially hitting a
>> read error when the filesystem scans through the log looking for the
>> head and tail to determine whether the log is dirty. If the log is
>> zeroed, this sequence can be bypassed and the log assumed clean. I
>> suspect by zeroing enough of the log before it fails, your repair
>> sequence is just bypassing the log head/tail discovery that previously
>> scanned areas of the disk that are having issues. In other words, it's
>> just temporarily stepping around the problem until the log progresses
>> back to this address range.
>>
>> What you probably have to do at this point is use the simple I/O error
>> reproducer you have to try and determine why the storage returns an
>> error. It could be anywhere from something broken in the md subsystem,
>> to the controller driver, to a physical problem with the associated
>> disk. I'd suggest to start by reporting to the md mailing list and work
>> down from there...
>>
>> Brian
>>
>>> The array is fairly full so I'm wondering if something is out of
>>> alignment
>>> somewhere thats causing this?
>>>
>>> /dev/md2       5858060288 5245630392 612429896  90% /mnt/md2
>>>
>>> When I had the array plugged into another controller which isn't a
>>> rocketraid card, it did complain about all the drives not being aligned
>>> properly? Somehow it looks like sdk wasn't partitioned the same as
>>> the rest,
>>> I'm wondering if thats screwing things up?
>>>
>>> GNU Parted 3.2
>>> Using /dev/sdi
>>> Welcome to GNU Parted! Type 'help' to view a list of commands.
>>> (parted) p
>>> Model: ATA ST2000NC000-1CX1 (scsi)
>>> Disk /dev/sdi: 2000GB
>>> Sector size (logical/physical): 512B/512B
>>> Partition Table: gpt
>>> Disk Flags:
>>>
>>> Number  Start   End     Size    File system  Name  Flags
>>>   1      1049kB  2000GB  2000GB
>>> Number  Start  End          Size         File system  Name  Flags
>>>   1      2048s  3907028991s  3907026944s
>>>
>>>
>>> GNU Parted 3.2
>>> Using /dev/sdk
>>> Welcome to GNU Parted! Type 'help' to view a list of commands.
>>> (parted) p
>>> Model: ATA ST2000DL001-9VT1 (scsi)
>>> Disk /dev/sdk: 2000GB
>>> Sector size (logical/physical): 512B/512B
>>> Partition Table: msdos
>>> Disk Flags:
>>>
>>> Number  Start  End     Size    Type     File system  Flags
>>>   1      512B   2000GB  2000GB  primary               raid
>>> Number  Start  End          Size         Type     File system  Flags
>>>   1      1s     3907029167s  3907029167s  primary               raid
>>>
>>>
>>> GNU Parted 3.2
>>> Using /dev/sdh
>>> Welcome to GNU Parted! Type 'help' to view a list of commands.
>>> (parted) p
>>> Model: ATA ST2000DL001-9VT1 (scsi)
>>> Disk /dev/sdh: 2000GB
>>> Sector size (logical/physical): 512B/512B
>>> Partition Table: gpt
>>> Disk Flags:
>>>
>>> Number  Start   End     Size    File system  Name  Flags
>>>   1      1049kB  2000GB  2000GB
>>> Number  Start  End          Size         File system  Name  Flags
>>>   1      2048s  3907028991s  3907026944s
>>>
>>>
>>> GNU Parted 3.2
>>> Using /dev/sdm
>>> Welcome to GNU Parted! Type 'help' to view a list of commands.
>>> (parted) p
>>> Model: ATA ST2000NC000-1CX1 (scsi)
>>> Disk /dev/sdm: 2000GB
>>> Sector size (logical/physical): 512B/512B
>>> Partition Table: gpt
>>> Disk Flags:
>>>
>>> Number  Start   End     Size    File system  Name  Flags
>>>   1      1049kB  2000GB  2000GB
>>> Number  Start  End          Size         File system  Name  Flags
>>>   1      2048s  3907028991s  3907026944s
>>>
>>>
>>>
>>>>
>>>>>
>>>>> This all began when the RR2722 driver running under 3.18.15
>>>>> complained and
>>>>> ..
>>>>>
>>>>> Mar 14 07:23:07 Bigmouth kernel: [7177248.090541] /dev/vmnet: port
>>>>> on hub 0
>>>>> successfully opened
>>>>> Mar 14 07:26:03 Bigmouth kernel: [7177424.552323] device eth1 left
>>>>> promiscuous mode
>>>>> Mar 14 07:26:03 Bigmouth kernel: [7177424.552786] bridge-eth1:
>>>>> disabled
>>>>> promiscuous mode
>>>>> Mar 14 20:10:20 Bigmouth kernel: [7223317.069464] rr272x_1x:Task
>>>>> file error,
>>>>> StatusReg=0x51, ErrReg=0x84, LBA[0-3]=0x747dc92f,LBA[4-7]=0x0.
>>>>> Mar 14 20:10:20 Bigmouth kernel: [7223317.179811] sd 5:0:1:0: [sdg]
>>>>> Mar 14 20:10:21 Bigmouth kernel: [7223317.690439] Result:
>>>>> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
>>>>> Mar 14 20:10:21 Bigmouth kernel: [7223317.700480] sd 5:0:1:0: [sdg]
>>>>> CDB:
>>>>> Mar 14 20:10:21 Bigmouth kernel: [7223318.211147] Write(10): 2a 00
>>>>> 74 7d c9
>>>>> 00 00 00 40 00
>>>>> Mar 14 20:10:21 Bigmouth kernel: [7223318.211167]
>>>>> blk_update_request: I/O
>>>>> error, dev sdg, sector 1954400512
>>>>> Mar 14 20:10:21 Bigmouth kernel: [7223318.211203] sd 5:0:3:0: [sdi]
>>>>> Mar 14 20:10:21 Bigmouth kernel: [7223318.211206] Result:
>>>>> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
>>>>> Mar 14 20:10:21 Bigmouth kernel: [7223318.211209] sd 5:0:3:0: [sdi]
>>>>> CDB:
>>>>> Mar 14 20:10:21 Bigmouth kernel: [7223318.211211] Write(10): 2a 00
>>>>> 74 7d c9
>>>>> 00 00 00 40 00
>>>>> Mar 14 20:10:21 Bigmouth kernel: [7223318.211223]
>>>>> blk_update_request: I/O
>>>>> error, dev sdi, sector 1954400512
>>>>> Mar 14 20:10:23 Bigmouth kernel: [7223319.957052] XFS (md2):
>>>>> metadata I/O
>>>>> error: block 0x15d6d4900 ("xlog_iodone") error 5 numblks 64
>>>>> Mar 14 20:10:23 Bigmouth kernel: [7223319.957064] XFS (md2):
>>>>> xfs_do_force_shutdown(0x2) called from line 1181 of file
>>>>> fs/xfs/xfs_log.c.
>>>>> Return address = 0xffffffff812fdf96
>>>>> Mar 14 20:10:23 Bigmouth kernel: [7223319.957080] XFS (md2): Log
>>>>> I/O Error
>>>>> Detected.  Shutting down filesystem
>>>>> Mar 14 20:10:23 Bigmouth kernel: [7223319.957083] XFS (md2): Please
>>>>> umount
>>>>> the filesystem and rectify the problem(s)
>>>>> Mar 14 20:10:23 Bigmouth kernel: [7223319.957093] XFS (md2):
>>>>> xfs_log_force:
>>>>> error -5 returned.
>>>>> Mar 14 20:10:50 Bigmouth kernel: [7223347.087272] XFS (md2):
>>>>> xfs_log_force:
>>>>> error -5 returned.
>>>>> Mar 14 20:11:20 Bigmouth kernel: [7223377.190469] XFS (md2):
>>>>> xfs_log_force:
>>>>> error -5 returned.
>>>>> Mar 14 20:11:50 Bigmouth kernel: [7223407.293952] XFS (md2):
>>>>> xfs_log_force:
>>>>> error -5 returned.
>>>>> Mar 14 20:12:20 Bigmouth kernel: [7223437.397444] XFS (md2):
>>>>> xfs_log_force:
>>>>> error -5 returned.
>>>>> Mar 14 20:12:23 Bigmouth kernel: [7223439.791407] nfsd: last server
>>>>> has
>>>>> exited, flushing export cache
>>>>> Mar 14 20:12:50 Bigmouth kernel: [7223467.500928] XFS (md2):
>>>>> xfs_log_force:
>>>>> error -5 returned.
>>>>> Mar 14 20:13:20 Bigmouth kernel: [7223497.604420] XFS (md2):
>>>>> xfs_log_force:
>>>>> error -5 returned.
>>>>> Mar 14 20:13:50 Bigmouth kernel: [7223527.707899] XFS (md2):
>>>>> xfs_log_force:
>>>>> error -5 returned.
>>>>> Mar 14 20:14:21 Bigmouth kernel: [7223557.811399] XFS (md2):
>>>>> xfs_log_force:
>>>>> error -5 returned.
>>>>> Mar 14 20:14:51 Bigmouth kernel: [7223587.914932] XFS (md2):
>>>>> xfs_log_force:
>>>>> error -5 returned.
>>>>> Mar 14 20:15:21 Bigmouth kernel: [7223618.018362] XFS (md2):
>>>>> xfs_log_force:
>>>>> error -5 returned.
>>>>> Mar 14 20:15:51 Bigmouth kernel: [7223648.121779] XFS (md2):
>>>>> xfs_log_force:
>>>>> error -5 returned.
>>>>> Mar 14 20:16:19 Bigmouth kernel: [7223676.401069] XFS (md2):
>>>>> xfs_log_force:
>>>>> error -5 returned.
>>>>> Mar 14 20:16:21 Bigmouth kernel: [7223678.225334] XFS (md2):
>>>>> xfs_log_force:
>>>>> error -5 returned.
>>>>> Mar 14 20:16:27 Bigmouth kernel: [7223684.541305] XFS (md2):
>>>>> xfs_log_force:
>>>>> error -5 returned.
>>>>> Mar 14 20:16:27 Bigmouth kernel: [7223684.572176] XFS (md2):
>>>>> xfs_log_force:
>>>>> error -5 returned.
>>>>> Mar 14 20:16:38 Bigmouth kernel: [7223694.918565]  md2: unknown
>>>>> partition
>>>>> table
>>>>> Mar 14 20:16:43 Bigmouth kernel: [7223700.425290] XFS (md2):
>>>>> Mounting V5
>>>>> Filesystem
>>>>> Mar 14 20:16:43 Bigmouth kernel: [7223700.545669] XFS (md2): Starting
>>>>> recovery (logdev: internal)
>>>>> Mar 14 20:16:44 Bigmouth kernel: [7223701.874245] XFS (md2): Ending
>>>>> recovery
>>>>> (logdev: internal)
>>>>> Mar 14 20:30:31 Bigmouth kernel: [7224529.528678]  md2: unknown
>>>>> partition
>>>>> table
>>>>>
>>>>>
>>>>>
>>>>> /dev/md2:
>>>>>          Version : 1.2
>>>>>    Creation Time : Tue Oct 13 22:21:27 2015
>>>>>       Raid Level : raid5
>>>>>       Array Size : 5860147200 (5588.67 GiB 6000.79 GB)
>>>>>    Used Dev Size : 1953382400 (1862.89 GiB 2000.26 GB)
>>>>>     Raid Devices : 4
>>>>>    Total Devices : 4
>>>>>      Persistence : Superblock is persistent
>>>>>
>>>>>    Intent Bitmap : Internal
>>>>>
>>>>>      Update Time : Tue Apr 12 01:19:43 2016
>>>>>            State : clean
>>>>>   Active Devices : 4
>>>>> Working Devices : 4
>>>>>   Failed Devices : 0
>>>>>    Spare Devices : 0
>>>>>
>>>>>           Layout : left-symmetric
>>>>>       Chunk Size : 512K
>>>>>
>>>>>             Name : Bigmouth:2  (local to host Bigmouth)
>>>>>             UUID : ed979276:3459155c:a32f63da:0c684042
>>>>>           Events : 62846
>>>>>
>>>>>      Number   Major   Minor   RaidDevice State
>>>>>         5       8      193        0      active sync   /dev/sdm1
>>>>>         6       8      129        1      active sync   /dev/sdi1
>>>>>         2       8      177        2      active sync   /dev/sdl1
>>>>>         4       8      113        3      active sync   /dev/sdh1
>>>>>
>>>>>
>>>>> meta-data=/dev/md2               isize=512    agcount=33,
>>>>> agsize=45782272
>>>>> blks
>>>>>           =                       sectsz=512   attr=2, projid32bit=1
>>>>>           =                       crc=1        finobt=1 spinodes=0
>>>>> data     =                       bsize=4096   blocks=1465036800,
>>>>> imaxpct=5
>>>>>           =                       sunit=128    swidth=384 blks
>>>>> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
>>>>> log      =internal               bsize=4096   blocks=521728, version=2
>>>>>           =                       sectsz=512   sunit=8 blks,
>>>>> lazy-count=1
>>>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>>>>
>>>>>
>>>>>>
>>>>>>>
>>>>>>> Checking the drives with smartctl shows no errors nor does
>>>>>>> 'dmesg' show any
>>>>>>> hardware i/o or controller related errors...
>>>>>>>
>>>>>>> I've tried scrubbing the array and no bad sectors are found either..
>>>>>>>
>>>>>>> I'm running kernel 3.19.8 with xfsprogs 4.5.
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Andrew
>>>>>>>
>>>>>>> _______________________________________________
>>>>>>> xfs mailing list
>>>>>>> xfs@oss.sgi.com
>>>>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>>>>
>>>>
>>
>>> 16:02:14.159324 execve("/usr/sbin/xfs_io", ["xfs_io", "-dc", "pread
>>> 3001552175104 2097152", "/dev/md2"], [/* 51 vars */]) = 0
>>> 16:02:14.160220 brk(NULL)               = 0x1ce4000
>>> 16:02:14.160345 mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>>> MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f1c5e4a2000
>>> 16:02:14.160508 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No
>>> such file or directory)
>>> 16:02:14.160626 open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
>>> 16:02:14.160707 fstat(3, {st_mode=S_IFREG|0644, st_size=246250, ...})
>>> = 0
>>> 16:02:14.160791 mmap(NULL, 246250, PROT_READ, MAP_PRIVATE, 3, 0) =
>>> 0x7f1c5e458000
>>> 16:02:14.160862 close(3)                = 0
>>> 16:02:14.160959 open("/usr/lib64/libxcmd.so.0", O_RDONLY|O_CLOEXEC) = 3
>>> 16:02:14.161037 read(3,
>>> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0@\37\0\0\0\0\0\0"...,
>>> 832) = 832
>>> 16:02:14.161111 fstat(3, {st_mode=S_IFREG|0755, st_size=26832, ...}) = 0
>>> 16:02:14.161184 mmap(NULL, 2128384, PROT_READ|PROT_EXEC,
>>> MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f1c5e070000
>>> 16:02:14.161254 mprotect(0x7f1c5e076000, 2093056, PROT_NONE) = 0
>>> 16:02:14.161325 mmap(0x7f1c5e275000, 8192, PROT_READ|PROT_WRITE,
>>> MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x5000) = 0x7f1c5e275000
>>> 16:02:14.161438 mmap(0x7f1c5e277000, 2560, PROT_READ|PROT_WRITE,
>>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f1c5e277000
>>> 16:02:14.161525 close(3)                = 0
>>> 16:02:14.161605 open("/lib64/libhandle.so.1", O_RDONLY|O_CLOEXEC) = 3
>>> 16:02:14.161683 read(3,
>>> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0P\17\0\0\0\0\0\0"...,
>>> 832) = 832
>>> 16:02:14.161755 fstat(3, {st_mode=S_IFREG|0755, st_size=14224, ...}) = 0
>>> 16:02:14.161826 mmap(NULL, 2113800, PROT_READ|PROT_EXEC,
>>> MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f1c5de68000
>>> 16:02:14.161896 mprotect(0x7f1c5de6b000, 2093056, PROT_NONE) = 0
>>> 16:02:14.161965 mmap(0x7f1c5e06a000, 8192, PROT_READ|PROT_WRITE,
>>> MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7f1c5e06a000
>>> 16:02:14.162049 mmap(0x7f1c5e06c000, 264, PROT_READ|PROT_WRITE,
>>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f1c5e06c000
>>> 16:02:14.162131 close(3)                = 0
>>> 16:02:14.162210 open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
>>> 16:02:14.162287 read(3,
>>> "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0000\7\2\0\0\0\0\0"...,
>>> 832) = 832
>>> 16:02:14.162359 fstat(3, {st_mode=S_IFREG|0755, st_size=1664768,
>>> ...}) = 0
>>> 16:02:14.162457 mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>>> MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f1c5e4a1000
>>> 16:02:14.162535 mmap(NULL, 3771992, PROT_READ|PROT_EXEC,
>>> MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f1c5dac8000
>>> 16:02:14.162607 mprotect(0x7f1c5dc57000, 2097152, PROT_NONE) = 0
>>> 16:02:14.162679 mmap(0x7f1c5de57000, 24576, PROT_READ|PROT_WRITE,
>>> MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x18f000) = 0x7f1c5de57000
>>> 16:02:14.162764 mmap(0x7f1c5de5d000, 15960, PROT_READ|PROT_WRITE,
>>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f1c5de5d000
>>> 16:02:14.162849 close(3)                = 0
>>> 16:02:14.162933 open("/lib64/libreadline.so.6", O_RDONLY|O_CLOEXEC) = 3
>>> 16:02:14.163013 read(3,
>>> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260d\1\0\0\0\0\0"...,
>>> 832) = 832
>>> 16:02:14.163084 fstat(3, {st_mode=S_IFREG|0555, st_size=415928, ...})
>>> = 0
>>> 16:02:14.163155 mmap(NULL, 2518968, PROT_READ|PROT_EXEC,
>>> MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f1c5d860000
>>> 16:02:14.163225 mprotect(0x7f1c5d8bd000, 2097152, PROT_NONE) = 0
>>> 16:02:14.163296 mmap(0x7f1c5dabd000, 36864, PROT_READ|PROT_WRITE,
>>> MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x5d000) = 0x7f1c5dabd000
>>> 16:02:14.163389 mmap(0x7f1c5dac6000, 4024, PROT_READ|PROT_WRITE,
>>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f1c5dac6000
>>> 16:02:14.163482 close(3)                = 0
>>> 16:02:14.163568 open("/lib64/libncurses.so.6", O_RDONLY|O_CLOEXEC) = 3
>>> 16:02:14.163645 read(3,
>>> "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\320W\1\0\0\0\0\0"...,
>>> 832) = 832
>>> 16:02:14.163716 fstat(3, {st_mode=S_IFREG|0755, st_size=526008, ...})
>>> = 0
>>> 16:02:14.163787 mmap(NULL, 2624120, PROT_READ|PROT_EXEC,
>>> MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f1c5d5d8000
>>> 16:02:14.163857 mprotect(0x7f1c5d654000, 2093056, PROT_NONE) = 0
>>> 16:02:14.163927 mmap(0x7f1c5d853000, 20480, PROT_READ|PROT_WRITE,
>>> MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x7b000) = 0x7f1c5d853000
>>> 16:02:14.164028 mmap(0x7f1c5d858000, 2680, PROT_READ|PROT_WRITE,
>>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f1c5d858000
>>> 16:02:14.164113 close(3)                = 0
>>> 16:02:14.164197 mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>>> MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f1c5e4a0000
>>> 16:02:14.164281 mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>>> MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f1c5e49f000
>>> 16:02:14.164355 mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>>> MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f1c5e49e000
>>> 16:02:14.164455 arch_prctl(ARCH_SET_FS, 0x7f1c5e49f700) = 0
>>> 16:02:14.164661 mprotect(0x7f1c5de57000, 16384, PROT_READ) = 0
>>> 16:02:14.164806 mprotect(0x7f1c5d853000, 16384, PROT_READ) = 0
>>> 16:02:14.165153 mprotect(0x7f1c5dabd000, 8192, PROT_READ) = 0
>>> 16:02:14.165231 mprotect(0x7f1c5e06a000, 4096, PROT_READ) = 0
>>> 16:02:14.165313 mprotect(0x7f1c5e275000, 4096, PROT_READ) = 0
>>> 16:02:14.165402 mprotect(0x618000, 4096, PROT_READ) = 0
>>> 16:02:14.165482 mprotect(0x7f1c5e499000, 4096, PROT_READ) = 0
>>> 16:02:14.165552 munmap(0x7f1c5e458000, 246250) = 0
>>> 16:02:14.165817 brk(NULL)               = 0x1ce4000
>>> 16:02:14.165876 brk(0x1d05000)          = 0x1d05000
>>> 16:02:14.165953 open("/usr/lib64/locale/locale-archive",
>>> O_RDONLY|O_CLOEXEC) = 3
>>> 16:02:14.166031 fstat(3, {st_mode=S_IFREG|0644, st_size=3832592,
>>> ...}) = 0
>>> 16:02:14.166103 mmap(NULL, 3832592, PROT_READ, MAP_PRIVATE, 3, 0) =
>>> 0x7f1c5d230000
>>> 16:02:14.166187 close(3)                = 0
>>> 16:02:14.166394 open("/dev/md2", O_RDWR|O_DIRECT) = 3
>>> 16:02:14.166498 fstatfs(3, {f_type="TMPFS_MAGIC", f_bsize=4096,
>>> f_blocks=2560, f_bfree=2560, f_bavail=2560, f_files=8244585,
>>> f_ffree=8243843, f_fsid={0, 0}, f_namelen=255, f_frsize=4096,
>>> f_flags=4130}) = 0
>>> 16:02:14.166583 fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9,
>>> 2), ...}) = 0
>>> 16:02:14.166655 fstatfs(3, {f_type="TMPFS_MAGIC", f_bsize=4096,
>>> f_blocks=2560, f_bfree=2560, f_bavail=2560, f_files=8244585,
>>> f_ffree=8243843, f_fsid={0, 0}, f_namelen=255, f_frsize=4096,
>>> f_flags=4130}) = 0
>>> 16:02:14.166730 fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9,
>>> 2), ...}) = 0
>>> 16:02:14.166822 open("/usr/share/locale/locale.alias",
>>> O_RDONLY|O_CLOEXEC) = 4
>>> 16:02:14.166899 fstat(4, {st_mode=S_IFREG|0644, st_size=2997, ...}) = 0
>>> 16:02:14.166969 mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>>> MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f1c5e49d000
>>> 16:02:14.167040 read(4, "# Locale name alias data base.\n#"..., 4096)
>>> = 2997
>>> 16:02:14.167154 read(4, "", 4096)       = 0
>>> 16:02:14.167223 close(4)                = 0
>>> 16:02:14.167289 munmap(0x7f1c5e49d000, 4096) = 0
>>> 16:02:14.167405
>>> open("/usr/share/locale/en_US.utf8/LC_MESSAGES/xfsprogs.mo",
>>> O_RDONLY) = -1 ENOENT (No such file or directory)
>>> 16:02:14.167488
>>> open("/usr/share/locale/en_US/LC_MESSAGES/xfsprogs.mo", O_RDONLY) =
>>> -1 ENOENT (No such file or directory)
>>> 16:02:14.167564
>>> open("/usr/share/locale/en.utf8/LC_MESSAGES/xfsprogs.mo", O_RDONLY) =
>>> -1 ENOENT (No such file or directory)
>>> 16:02:14.167637 open("/usr/share/locale/en/LC_MESSAGES/xfsprogs.mo",
>>> O_RDONLY) = -1 ENOENT (No such file or directory)
>>> 16:02:14.168062 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552175104) = 4096
>>> 16:02:14.168480 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552179200) = 4096
>>> 16:02:14.168744 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552183296) = 4096
>>> 16:02:14.168995 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552187392) = 4096
>>> 16:02:14.169235 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552191488) = 4096
>>> 16:02:14.169479 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552195584) = 4096
>>> 16:02:14.169717 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552199680) = 4096
>>> 16:02:14.169970 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552203776) = 4096
>>> 16:02:14.170215 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552207872) = 4096
>>> 16:02:14.170461 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552211968) = 4096
>>> 16:02:14.170700 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552216064) = 4096
>>> 16:02:14.170940 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552220160) = 4096
>>> 16:02:14.171177 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552224256) = 4096
>>> 16:02:14.171440 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552228352) = 4096
>>> 16:02:14.171680 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552232448) = 4096
>>> 16:02:14.171913 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552236544) = 4096
>>> 16:02:14.172148 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552240640) = 4096
>>> 16:02:14.172402 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552244736) = 4096
>>> 16:02:14.172652 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552248832) = 4096
>>> 16:02:14.172901 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552252928) = 4096
>>> 16:02:14.173135 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552257024) = 4096
>>> 16:02:14.173381 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552261120) = 4096
>>> 16:02:14.173626 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552265216) = 4096
>>> 16:02:14.173859 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552269312) = 4096
>>> 16:02:14.174095 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552273408) = 4096
>>> 16:02:14.174335 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552277504) = 4096
>>> 16:02:14.174591 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552281600) = 4096
>>> 16:02:14.174822 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552285696) = 4096
>>> 16:02:14.175053 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552289792) = 4096
>>> 16:02:14.175285 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552293888) = 4096
>>> 16:02:14.175528 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552297984) = 4096
>>> 16:02:14.175765 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552302080) = 4096
>>> 16:02:14.175988 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552306176) = 4096
>>> 16:02:14.176212 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552310272) = 4096
>>> 16:02:14.176596 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552314368) = 4096
>>> 16:02:14.176860 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552318464) = 4096
>>> 16:02:14.177083 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552322560) = 4096
>>> 16:02:14.177306 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552326656) = 4096
>>> 16:02:14.177535 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552330752) = 4096
>>> 16:02:14.177759 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552334848) = 4096
>>> 16:02:14.177981 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552338944) = 4096
>>> 16:02:14.178231 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552343040) = 4096
>>> 16:02:14.178469 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552347136) = 4096
>>> 16:02:14.178687 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552351232) = 4096
>>> 16:02:14.178915 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552355328) = 4096
>>> 16:02:14.179131 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552359424) = 4096
>>> 16:02:14.179404 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552363520) = 4096
>>> 16:02:14.179635 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552367616) = 4096
>>> 16:02:14.179856 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552371712) = 4096
>>> 16:02:14.180076 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552375808) = 4096
>>> 16:02:14.180299 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552379904) = 4096
>>> 16:02:14.180518 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552384000) = 4096
>>> 16:02:14.180738 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552388096) = 4096
>>> 16:02:14.180983 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552392192) = 4096
>>> 16:02:14.181204 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552396288) = 4096
>>> 16:02:14.181455 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552400384) = 4096
>>> 16:02:14.181677 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552404480) = 4096
>>> 16:02:14.181900 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552408576) = 4096
>>> 16:02:14.182122 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552412672) = 4096
>>> 16:02:14.182345 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552416768) = 4096
>>> 16:02:14.182585 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552420864) = 4096
>>> 16:02:14.182808 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552424960) = 4096
>>> 16:02:14.183041 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552429056) = 4096
>>> 16:02:14.183261 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552433152) = 4096
>>> 16:02:14.183486 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552437248) = 4096
>>> 16:02:14.183707 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552441344) = 4096
>>> 16:02:14.183943 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552445440) = 4096
>>> 16:02:14.184159 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552449536) = 4096
>>> 16:02:14.184398 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552453632) = 4096
>>> 16:02:14.184621 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552457728) = 4096
>>> 16:02:14.184836 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552461824) = 4096
>>> 16:02:14.185075 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552465920) = 4096
>>> 16:02:14.185292 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552470016) = 4096
>>> 16:02:14.189482 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552474112) = 4096
>>> 16:02:14.189973 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552478208) = 4096
>>> 16:02:14.190171 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552482304) = 4096
>>> 16:02:14.190360 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552486400) = 4096
>>> 16:02:14.190573 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552490496) = 4096
>>> 16:02:14.190745 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552494592) = 4096
>>> 16:02:14.190913 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552498688) = 4096
>>> 16:02:14.191098 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552502784) = 4096
>>> 16:02:14.191269 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552506880) = 4096
>>> 16:02:14.191478 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552510976) = 4096
>>> 16:02:14.191692 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552515072) = 4096
>>> 16:02:14.191879 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552519168) = 4096
>>> 16:02:14.192062 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552523264) = 4096
>>> 16:02:14.192246 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552527360) = 4096
>>> 16:02:14.192444 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552531456) = 4096
>>> 16:02:14.192625 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552535552) = 4096
>>> 16:02:14.192806 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552539648) = 4096
>>> 16:02:14.192990 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552543744) = 4096
>>> 16:02:14.193172 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552547840) = 4096
>>> 16:02:14.193351 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552551936) = 4096
>>> 16:02:14.193555 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552556032) = 4096
>>> 16:02:14.193736 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552560128) = 4096
>>> 16:02:14.193913 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552564224) = 4096
>>> 16:02:14.194094 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552568320) = 4096
>>> 16:02:14.194278 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552572416) = 4096
>>> 16:02:14.194468 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552576512) = 4096
>>> 16:02:14.194650 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552580608) = 4096
>>> 16:02:14.194829 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552584704) = 4096
>>> 16:02:14.195009 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552588800) = 4096
>>> 16:02:14.195193 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552592896) = 4096
>>> 16:02:14.195386 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552596992) = 4096
>>> 16:02:14.195579 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552601088) = 4096
>>> 16:02:14.195763 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552605184) = 4096
>>> 16:02:14.195957 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552609280) = 4096
>>> 16:02:14.196141 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552613376) = 4096
>>> 16:02:14.196321 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552617472) = 4096
>>> 16:02:14.196511 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552621568) = 4096
>>> 16:02:14.196697 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552625664) = 4096
>>> 16:02:14.197041 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552629760) = 4096
>>> 16:02:14.197239 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552633856) = 4096
>>> 16:02:14.197486 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552637952) = 4096
>>> 16:02:14.197689 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552642048) = 4096
>>> 16:02:14.197874 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552646144) = 4096
>>> 16:02:14.198057 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552650240) = 4096
>>> 16:02:14.198259 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552654336) = 4096
>>> 16:02:14.198446 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552658432) = 4096
>>> 16:02:14.198639 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552662528) = 4096
>>> 16:02:14.198823 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552666624) = 4096
>>> 16:02:14.199006 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552670720) = 4096
>>> 16:02:14.199188 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552674816) = 4096
>>> 16:02:14.199373 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552678912) = 4096
>>> 16:02:14.199569 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552683008) = 4096
>>> 16:02:14.199749 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552687104) = 4096
>>> 16:02:14.199929 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552691200) = 4096
>>> 16:02:14.200108 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552695296) = 4096
>>> 16:02:14.200304 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552699392) = 4096
>>> 16:02:14.200494 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552703488) = 4096
>>> 16:02:14.200684 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552707584) = 4096
>>> 16:02:14.200867 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552711680) = 4096
>>> 16:02:14.201047 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552715776) = 4096
>>> 16:02:14.201227 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552719872) = 4096
>>> 16:02:14.201417 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552723968) = 4096
>>> 16:02:14.201602 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552728064) = 4096
>>> 16:02:14.201782 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552732160) = 4096
>>> 16:02:14.201962 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552736256) = 4096
>>> 16:02:14.202153 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552740352) = 4096
>>> 16:02:14.202352 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552744448) = 4096
>>> 16:02:14.202564 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552748544) = 4096
>>> 16:02:14.202740 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552752640) = 4096
>>> 16:02:14.202920 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552756736) = 4096
>>> 16:02:14.203101 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552760832) = 4096
>>> 16:02:14.203284 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552764928) = 4096
>>> 16:02:14.203473 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552769024) = 4096
>>> 16:02:14.203654 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552773120) = 4096
>>> 16:02:14.203833 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552777216) = 4096
>>> 16:02:14.204014 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552781312) = 4096
>>> 16:02:14.204198 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552785408) = 4096
>>> 16:02:14.204409 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552789504) = 4096
>>> 16:02:14.204591 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552793600) = 4096
>>> 16:02:14.204770 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552797696) = 4096
>>> 16:02:14.204952 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552801792) = 4096
>>> 16:02:14.205135 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552805888) = 4096
>>> 16:02:14.205316 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552809984) = 4096
>>> 16:02:14.205502 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552814080) = 4096
>>> 16:02:14.205684 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552818176) = 4096
>>> 16:02:14.205865 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552822272) = 4096
>>> 16:02:14.206050 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552826368) = 4096
>>> 16:02:14.206240 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552830464) = 4096
>>> 16:02:14.206446 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552834560) = 4096
>>> 16:02:14.206626 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552838656) = 4096
>>> 16:02:14.206806 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552842752) = 4096
>>> 16:02:14.206988 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552846848) = 4096
>>> 16:02:14.207166 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552850944) = 4096
>>> 16:02:14.207344 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552855040) = 4096
>>> 16:02:14.207539 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552859136) = 4096
>>> 16:02:14.207724 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552863232) = 4096
>>> 16:02:14.207907 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552867328) = 4096
>>> 16:02:14.208084 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552871424) = 4096
>>> 16:02:14.208274 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552875520) = 4096
>>> 16:02:14.208494 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552879616) = 4096
>>> 16:02:14.208675 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552883712) = 4096
>>> 16:02:14.208858 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552887808) = 4096
>>> 16:02:14.209037 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552891904) = 4096
>>> 16:02:14.209217 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552896000) = 4096
>>> 16:02:14.209412 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552900096) = 4096
>>> 16:02:14.209595 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552904192) = 4096
>>> 16:02:14.209774 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552908288) = 4096
>>> 16:02:14.209953 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552912384) = 4096
>>> 16:02:14.210130 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552916480) = 4096
>>> 16:02:14.210320 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552920576) = 4096
>>> 16:02:14.210538 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552924672) = 4096
>>> 16:02:14.210723 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552928768) = 4096
>>> 16:02:14.210903 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552932864) = 4096
>>> 16:02:14.211084 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552936960) = 4096
>>> 16:02:14.211264 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552941056) = 4096
>>> 16:02:14.211452 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552945152) = 4096
>>> 16:02:14.211639 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552949248) = 4096
>>> 16:02:14.211831 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552953344) = 4096
>>> 16:02:14.212012 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552957440) = 4096
>>> 16:02:14.212194 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552961536) = 4096
>>> 16:02:14.212377 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552965632) = 4096
>>> 16:02:14.212579 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552969728) = 4096
>>> 16:02:14.212760 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552973824) = 4096
>>> 16:02:14.212939 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552977920) = 4096
>>> 16:02:14.213118 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552982016) = 4096
>>> 16:02:14.213298 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552986112) = 4096
>>> 16:02:14.213490 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552990208) = 4096
>>> 16:02:14.213672 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552994304) = 4096
>>> 16:02:14.213987 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001552998400) = 4096
>>> 16:02:14.214237 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553002496) = 4096
>>> 16:02:14.214493 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553006592) = 4096
>>> 16:02:14.214760 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553010688) = 4096
>>> 16:02:14.215009 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553014784) = 4096
>>> 16:02:14.215258 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553018880) = 4096
>>> 16:02:14.215515 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553022976) = 4096
>>> 16:02:14.215774 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553027072) = 4096
>>> 16:02:14.216026 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553031168) = 4096
>>> 16:02:14.216273 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553035264) = 4096
>>> 16:02:14.216529 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553039360) = 4096
>>> 16:02:14.216801 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553043456) = 4096
>>> 16:02:14.217042 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553047552) = 4096
>>> 16:02:14.217302 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553051648) = 4096
>>> 16:02:14.217557 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553055744) = 4096
>>> 16:02:14.217821 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553059840) = 4096
>>> 16:02:14.218067 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553063936) = 4096
>>> 16:02:14.218312 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553068032) = 4096
>>> 16:02:14.218559 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553072128) = 4096
>>> 16:02:14.218801 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553076224) = 4096
>>> 16:02:14.219045 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553080320) = 4096
>>> 16:02:14.219287 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553084416) = 4096
>>> 16:02:14.219543 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553088512) = 4096
>>> 16:02:14.219794 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553092608) = 4096
>>> 16:02:14.220040 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553096704) = 4096
>>> 16:02:14.220286 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553100800) = 4096
>>> 16:02:14.220541 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553104896) = 4096
>>> 16:02:14.220787 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553108992) = 4096
>>> 16:02:14.221033 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553113088) = 4096
>>> 16:02:14.221280 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553117184) = 4096
>>> 16:02:14.221532 pread64(3,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096,
>>> 3001553121280) = 4096
>>> 16:02:14.221784 pread64(3, 0x1ce7000, 4096, 3001553125376) = -1 EIO
>>> (Input/output error)
>>> 16:02:14.222083 dup(2)                  = 4
>>> 16:02:14.222183 fcntl(4, F_GETFL)       = 0x8402 (flags
>>> O_RDWR|O_APPEND|O_LARGEFILE)
>>> 16:02:14.222290
>>> open("/usr/share/locale/en_US.utf8/LC_MESSAGES/libc.mo", O_RDONLY) =
>>> -1 ENOENT (No such file or directory)
>>> 16:02:14.222448 open("/usr/share/locale/en_US/LC_MESSAGES/libc.mo",
>>> O_RDONLY) = -1 ENOENT (No such file or directory)
>>> 16:02:14.222616 open("/usr/share/locale/en.utf8/LC_MESSAGES/libc.mo",
>>> O_RDONLY) = -1 ENOENT (No such file or directory)
>>> 16:02:14.222693 open("/usr/share/locale/en/LC_MESSAGES/libc.mo",
>>> O_RDONLY) = -1 ENOENT (No such file or directory)
>>> 16:02:14.222786 fstat(4, {st_mode=S_IFCHR|0620, st_rdev=makedev(136,
>>> 9), ...}) = 0
>>> 16:02:14.222866 mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>>> MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f1c5e49d000
>>> 16:02:14.222954 write(4, "pread64: Input/output error\n", 28) = 28
>>> 16:02:14.223038 close(4)                = 0
>>> 16:02:14.223103 munmap(0x7f1c5e49d000, 4096) = 0
>>> 16:02:14.223249 exit_group(0)           = ?
>>> 16:02:14.223594 +++ exited with 0 +++
>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

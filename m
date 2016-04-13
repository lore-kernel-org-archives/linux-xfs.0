Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 93E637CA0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 22:02:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 446F28F8033
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 20:02:15 -0700 (PDT)
Received: from smtp-out-so.shaw.ca (smtp-out-so.shaw.ca [64.59.136.138]) by
	cuda.sgi.com with ESMTP id YvjjykyvlaqdiUD4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 20:02:11 -0700 (PDT)
Subject: Re: xfs_repair fails after trying to format log cycle?
References: <56F6DE67.60403@shaw.ca> <20160328085541.GA27040@bfoster.bfoster>
	<570C8D4D.3060304@shaw.ca> <20160412140512.GA59690@bfoster.bfoster>
	<570D578D.5010706@shaw.ca>
From: Andrew Ryder <tireman@shaw.ca>
Message-ID: <570DB6CD.1000007@shaw.ca>
Date: Tue, 12 Apr 2016 23:02:37 -0400
MIME-Version: 1.0
In-Reply-To: <570D578D.5010706@shaw.ca>
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
Cc: xfs@oss.sgi.com

Is it possible the location its searching for at block

02:34:43.887528 pread64(4, 0x7fb8f53e0200, 2097152, 3001552175104) = -1 
EIO (Input/output error)

is not where the log actually is?

If I run xfs_db in r/o mode it returns:

xfs_db> blockget
xfs_db: error - read only 950272 of 2097152 bytes
failed to find log head
xlog_is_dirty: cannot find log head/tail (xlog_find_tail=-5)

ERROR: cannot find log head/tail, run xfs_repair


The value of 950272 is the same if I multiply the 232 lines by 4096 of 
pread in the "strace_xfs_io.txt" file I get 950272 bytes as well.

Yet if I run xfs_logprint it dump about 727MB of log info.. before 
throwing an error.


xfs_logprint:
     data device: 0x902
     log device: 0x902 daddr: 5860130880 length: 4173824

cycle: 63	version: 2		lsn: 63,2283776	tail_lsn: 63,2283456
length of Log Record: 32256	prev offset: 2283712		num ops: 376
uuid: 14bc270b-e658-4f85-b1db-673642ab9d67   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: 6dd14bc1  len: 8  clientid: TRANS  flags: WAS_CONT END
Left over region from split log item
----------------------------------------------------------------------------
Oper (1): tid: 6dd14bc1  len: 32  clientid: TRANS  flags: none
EFD:  #regs: 1    num_extents: 1  id: 0xffff88044f10abc0
----------------------------------------------------------------------------
Oper (2): tid: 6dd14bc1  len: 56  clientid: TRANS  flags: none
INODE: #regs: 2   ino: 0x360f8c437  flags: 0x1   dsize: 0
         blkno: 9905273888  len: 32  boff: 11776
Oper (3): tid: 6dd14bc1  len: 176  clientid: TRANS  flags: none
INODE CORE
magic 0x494e mode 0100644 version 3 format 2
nlink 1 uid 1000 gid 100
atime 0x56d8c8e2 mtime 0x56d8c8e2 ctime 0x56d8c8e2
size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0

< ... skipping to end .... >

Oper (0): tid: edbd9f49  len: 0  clientid: TRANS  flags: START
----------------------------------------------------------------------------
Oper (1): tid: edbd9f49  len: 16  clientid: TRANS  flags: none
TRAN:    type: CHECKPOINT       tid: edbd9f49       num_items: 2
----------------------------------------------------------------------------
Oper (2): tid: edbd9f49  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 0 (0x0)  len: 1  bmap size: 1  flags: 0x9000
Oper (3): tid: edbd9f49  len: 128  clientid: TRANS  flags: none
SUPER BLOCK Buffer:
icount: 6360863066640355328  ifree: 1465036800  fdblks: 0  frext: 0
----------------------------------------------------------------------------
Oper (4): tid: edbd9f49  len: 0  clientid: TRANS  flags: COMMIT

============================================================================
**********************************************************************
* ERROR: header cycle=0           block=5120                         *
**********************************************************************



and if I pull the byte offset value from the daddr value below I get:

xfs_db> daddr 5860130880
xfs_db> stack
1:
byte offset 3000387010560, length 512
buffer block 5860130880 (fsbno 1073741832), 1 bb
inode -1, dir inode -1, type data


which is where when xfs_repair actually traverses the fs on the 3rd 
iteration and it fails after formatting the log to a size of 434,896,896 
bytes (1659 iterations of
262144 byte successful writes before error)


On 04/12/2016 04:16 PM, Andrew Ryder wrote:
> On 04/12/2016 10:05 AM, Brian Foster wrote:
>> On Tue, Apr 12, 2016 at 01:53:17AM -0400, Andrew Ryder wrote:
>>>
>>>
>>> On 03/28/2016 04:55 AM, Brian Foster wrote:
>>>> On Sat, Mar 26, 2016 at 03:09:27PM -0400, Andrew Ryder wrote:
>>>>> Hello,
>>>>>
>>>>> I have an mdadm array with a xfs v5 filesystem on it and its begun
>>>>> to give
>>>>> me issues when trying to mount it as well as complete xfs_repair.
>>>>> Not sure
>>>>> if anyone might be able to shed some light on what is going on or
>>>>> how to
>>>>> correct the issue?
>>>>>
>>>>> When I try and mount the fs, it complains with:
>>>>>
>>>>> [  388.479847] XFS (md2): Mounting V5 Filesystem
>>>>> [  388.494686] XFS (md2): metadata I/O error: block 0x15d6d39c0
>>>>> ("xlog_bread_noalign") error 5 numblks 8192
>>>>> [  388.495013] XFS (md2): failed to find log head
>>>>> [  388.495018] XFS (md2): log mount/recovery failed: error -5
>>>>> [  388.495090] XFS (md2): log mount failed
>>>>>
>>>>
>>>> So a read I/O error from the kernel...
>>>>
>>>>>
>>>>> This is where its not making any sense for me, If I try and run
>>>>> "xfs_repair
>>>>> /dev/md2" it fails with:
>>>>>
>>>>> Phase 1 - find and verify superblock...
>>>>>          - reporting progress in intervals of 15 minutes
>>>>> Phase 2 - using internal log
>>>>>          - zero log...
>>>>> xfs_repair: read failed: Input/output error
>>>>> failed to find log head
>>>>> zero_log: cannot find log head/tail (xlog_find_tail=-5)
>>>>>
>>>>> fatal error -- ERROR: The log head and/or tail cannot be
>>>>> discovered. Attempt
>>>>> to mount the
>>>>> filesystem to replay the log or use the -L option to destroy the
>>>>> log and
>>>>> attempt a repair.
>>>>>
>>>>
>>>> ... similar read error from xfsprogs...
>>>>
>>>>>
>>>>> But if I run "xfs_repair -L /dev/md2" which gives:
>>>>>
>>>>> Phase 1 - find and verify superblock...
>>>>>          - reporting progress in intervals of 15 minutes
>>>>> Phase 2 - using internal log
>>>>>          - zero log...
>>>>> xfs_repair: read failed: Input/output error
>>>>> failed to find log head
>>>>> zero_log: cannot find log head/tail (xlog_find_tail=-5)
>>>>> xfs_repair: libxfs_device_zero write failed: Input/output error
>>>>>
>>>>
>>>> ... and it looks like it fails to write as well when trying to zero the
>>>> log...
>>>>
>>>>> then try and re-run "xfs_repair /dev/md2" it starts traversing the
>>>>> filesystem all the way to "Phase 7" then errors with:
>>>>>
>>>>> Phase 7 - verify and correct link counts...
>>>>>          - 14:36:55: verify and correct link counts - 33 of 33
>>>>> allocation
>>>>> groups done
>>>>> Maximum metadata LSN (64:2230592) is ahead of log (0:0).
>>>>> Format log to cycle 67.
>>>>> xfs_repair: libxfs_device_zero write failed: Input/output error
>>>>>
>>>>>
>>>>> Yet at this point I can now mount the filesystem..
>>>>>
>>>>
>>>> ... and this is effectively a repeat of the write error as we try to
>>>> format the log with a correct LSN based on the metadata LSN tracked by
>>>> the repair process. Your kernel is old enough that runtime probably
>>>> won't complain either way (note that 3.19 might be considered a fairly
>>>> early kernel for using CRC support). Perhaps the first write attempt
>>>> zeroed enough of the log before it failed that log recovery wasn't
>>>> required, and thus these problematic I/Os were avoided.
>>>>
>>>> What's the history of this fs? Has it been working for some time, just
>>>> recently formatted? What lead to the need for log recovery? What's the
>>>> mdadm --detail info, member device size, total array size, xfs_info of
>>>> the filesystem, etc..?
>>>>
>>>> Does xfs_repair run clean at this point? If so, does 'xfs_repair -L'
>>>> still reproduce the write error (note that I'm assuming you have a
>>>> clean
>>>> log such that this command will not cause data loss). If so, an strace
>>>> of the repair process might be interesting...
>>>>
>>>> Brian
>>>
>>>
>>> The filesystem is about a year old as I had one of the Addonics
>>> backplane
>>> boards go bad and after the replacement all was good again.. until the
>>> RocketRaid 2722 card and its obscure "Task File error" error message
>>> came up
>>> again.
>>>
>>> Everything up to this point had been working smoothly since end of
>>> Sept 2015
>>> after the rebuild. All disks are 2TB in size, partitioned via
>>> 'parted' with
>>> 0% and 100% used for partition boundaries on each drive. Everything
>>> had been
>>> working wonderfully long before but the array was taken out due to some
>>> issues I had with 3 hitachi drives that refused to work on the RR2722
>>> card/drivers. Long story.
>>>
>>> I've swapped out two drives in the array and no luck yet as it
>>> doesn't seem
>>> to be hardware failure related.. I've not had any signs of data
>>> corruption,
>>> just meta-data corruption/errors.
>>>
>>> If I remember correct, the format applied to the array was done under
>>> 3.6.11
>>> kernel as
>>> I'm still going through the same xfs_repair as above to get the array to
>>> mount. It keeps failing after it tries to format the log to cycle 67.
>>>
>>> I'll see if I can get you an strace of things.
>>>
>>
>> FWIW, I created an md array of similar geometry and ran through some
>> fsstress/xfs_repair sequences just to see if there was anything
>> obviously broken in the stack here, but I don't hit any issues.
>> xfs_repair can zero the log and reformat it successfully. This is on a
>> 4.6.0-rc1 kernel.
>>
>> So I think the big question here is why are these certain I/Os failing?
>> This might ultimately require investigation at the md layer and/or
>> further down to your storage controller driver, etc. Anyways, here's the
>> first failed I/O from strace_2.1.txt:
>>
>> 02:34:36.309704 pread64(4, 0x7fe772ec0200, 2097152, 3001552175104) =
>> -1 EIO (Input/output error)
>>
>> That's a 2MB read during phase 2, which is probably what leads to the
>> "failed to find log head" error. The read offset is right around the
>> middle of the array where the internal log resides. What's also
>> interesting is that it is preceded by a bunch of other read I/Os that
>> all appear to complete fine, but those are all 512b I/Os.
>>
>> What happens if you manually issue the read call that failed? E.g.,
>> umount the filesystem and run the following command directly against the
>> array:
>>
>> xfs_io -dc "pread 3001552175104 2097152" /dev/md2
>>
>> Brian
>
> It failed with the same error. I've attached the strace output for the
> command.
>
> The array is fairly full so I'm wondering if something is out of
> alignment somewhere thats causing this?
>
> /dev/md2       5858060288 5245630392 612429896  90% /mnt/md2
>
> When I had the array plugged into another controller which isn't a
> rocketraid card, it did complain about all the drives not being aligned
> properly? Somehow it looks like sdk wasn't partitioned the same as the
> rest, I'm wondering if thats screwing things up?
>
> GNU Parted 3.2
> Using /dev/sdi
> Welcome to GNU Parted! Type 'help' to view a list of commands.
> (parted) p
> Model: ATA ST2000NC000-1CX1 (scsi)
> Disk /dev/sdi: 2000GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
> Disk Flags:
>
> Number  Start   End     Size    File system  Name  Flags
>   1      1049kB  2000GB  2000GB
> Number  Start  End          Size         File system  Name  Flags
>   1      2048s  3907028991s  3907026944s
>
>
> GNU Parted 3.2
> Using /dev/sdk
> Welcome to GNU Parted! Type 'help' to view a list of commands.
> (parted) p
> Model: ATA ST2000DL001-9VT1 (scsi)
> Disk /dev/sdk: 2000GB
> Sector size (logical/physical): 512B/512B
> Partition Table: msdos
> Disk Flags:
>
> Number  Start  End     Size    Type     File system  Flags
>   1      512B   2000GB  2000GB  primary               raid
> Number  Start  End          Size         Type     File system  Flags
>   1      1s     3907029167s  3907029167s  primary               raid
>
>
> GNU Parted 3.2
> Using /dev/sdh
> Welcome to GNU Parted! Type 'help' to view a list of commands.
> (parted) p
> Model: ATA ST2000DL001-9VT1 (scsi)
> Disk /dev/sdh: 2000GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
> Disk Flags:
>
> Number  Start   End     Size    File system  Name  Flags
>   1      1049kB  2000GB  2000GB
> Number  Start  End          Size         File system  Name  Flags
>   1      2048s  3907028991s  3907026944s
>
>
> GNU Parted 3.2
> Using /dev/sdm
> Welcome to GNU Parted! Type 'help' to view a list of commands.
> (parted) p
> Model: ATA ST2000NC000-1CX1 (scsi)
> Disk /dev/sdm: 2000GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
> Disk Flags:
>
> Number  Start   End     Size    File system  Name  Flags
>   1      1049kB  2000GB  2000GB
> Number  Start  End          Size         File system  Name  Flags
>   1      2048s  3907028991s  3907026944s
>
>
>
>>
>>>
>>> This all began when the RR2722 driver running under 3.18.15
>>> complained and
>>> ..
>>>
>>> Mar 14 07:23:07 Bigmouth kernel: [7177248.090541] /dev/vmnet: port on
>>> hub 0
>>> successfully opened
>>> Mar 14 07:26:03 Bigmouth kernel: [7177424.552323] device eth1 left
>>> promiscuous mode
>>> Mar 14 07:26:03 Bigmouth kernel: [7177424.552786] bridge-eth1: disabled
>>> promiscuous mode
>>> Mar 14 20:10:20 Bigmouth kernel: [7223317.069464] rr272x_1x:Task file
>>> error,
>>> StatusReg=0x51, ErrReg=0x84, LBA[0-3]=0x747dc92f,LBA[4-7]=0x0.
>>> Mar 14 20:10:20 Bigmouth kernel: [7223317.179811] sd 5:0:1:0: [sdg]
>>> Mar 14 20:10:21 Bigmouth kernel: [7223317.690439] Result:
>>> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
>>> Mar 14 20:10:21 Bigmouth kernel: [7223317.700480] sd 5:0:1:0: [sdg] CDB:
>>> Mar 14 20:10:21 Bigmouth kernel: [7223318.211147] Write(10): 2a 00 74
>>> 7d c9
>>> 00 00 00 40 00
>>> Mar 14 20:10:21 Bigmouth kernel: [7223318.211167] blk_update_request:
>>> I/O
>>> error, dev sdg, sector 1954400512
>>> Mar 14 20:10:21 Bigmouth kernel: [7223318.211203] sd 5:0:3:0: [sdi]
>>> Mar 14 20:10:21 Bigmouth kernel: [7223318.211206] Result:
>>> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
>>> Mar 14 20:10:21 Bigmouth kernel: [7223318.211209] sd 5:0:3:0: [sdi] CDB:
>>> Mar 14 20:10:21 Bigmouth kernel: [7223318.211211] Write(10): 2a 00 74
>>> 7d c9
>>> 00 00 00 40 00
>>> Mar 14 20:10:21 Bigmouth kernel: [7223318.211223] blk_update_request:
>>> I/O
>>> error, dev sdi, sector 1954400512
>>> Mar 14 20:10:23 Bigmouth kernel: [7223319.957052] XFS (md2): metadata
>>> I/O
>>> error: block 0x15d6d4900 ("xlog_iodone") error 5 numblks 64
>>> Mar 14 20:10:23 Bigmouth kernel: [7223319.957064] XFS (md2):
>>> xfs_do_force_shutdown(0x2) called from line 1181 of file
>>> fs/xfs/xfs_log.c.
>>> Return address = 0xffffffff812fdf96
>>> Mar 14 20:10:23 Bigmouth kernel: [7223319.957080] XFS (md2): Log I/O
>>> Error
>>> Detected.  Shutting down filesystem
>>> Mar 14 20:10:23 Bigmouth kernel: [7223319.957083] XFS (md2): Please
>>> umount
>>> the filesystem and rectify the problem(s)
>>> Mar 14 20:10:23 Bigmouth kernel: [7223319.957093] XFS (md2):
>>> xfs_log_force:
>>> error -5 returned.
>>> Mar 14 20:10:50 Bigmouth kernel: [7223347.087272] XFS (md2):
>>> xfs_log_force:
>>> error -5 returned.
>>> Mar 14 20:11:20 Bigmouth kernel: [7223377.190469] XFS (md2):
>>> xfs_log_force:
>>> error -5 returned.
>>> Mar 14 20:11:50 Bigmouth kernel: [7223407.293952] XFS (md2):
>>> xfs_log_force:
>>> error -5 returned.
>>> Mar 14 20:12:20 Bigmouth kernel: [7223437.397444] XFS (md2):
>>> xfs_log_force:
>>> error -5 returned.
>>> Mar 14 20:12:23 Bigmouth kernel: [7223439.791407] nfsd: last server has
>>> exited, flushing export cache
>>> Mar 14 20:12:50 Bigmouth kernel: [7223467.500928] XFS (md2):
>>> xfs_log_force:
>>> error -5 returned.
>>> Mar 14 20:13:20 Bigmouth kernel: [7223497.604420] XFS (md2):
>>> xfs_log_force:
>>> error -5 returned.
>>> Mar 14 20:13:50 Bigmouth kernel: [7223527.707899] XFS (md2):
>>> xfs_log_force:
>>> error -5 returned.
>>> Mar 14 20:14:21 Bigmouth kernel: [7223557.811399] XFS (md2):
>>> xfs_log_force:
>>> error -5 returned.
>>> Mar 14 20:14:51 Bigmouth kernel: [7223587.914932] XFS (md2):
>>> xfs_log_force:
>>> error -5 returned.
>>> Mar 14 20:15:21 Bigmouth kernel: [7223618.018362] XFS (md2):
>>> xfs_log_force:
>>> error -5 returned.
>>> Mar 14 20:15:51 Bigmouth kernel: [7223648.121779] XFS (md2):
>>> xfs_log_force:
>>> error -5 returned.
>>> Mar 14 20:16:19 Bigmouth kernel: [7223676.401069] XFS (md2):
>>> xfs_log_force:
>>> error -5 returned.
>>> Mar 14 20:16:21 Bigmouth kernel: [7223678.225334] XFS (md2):
>>> xfs_log_force:
>>> error -5 returned.
>>> Mar 14 20:16:27 Bigmouth kernel: [7223684.541305] XFS (md2):
>>> xfs_log_force:
>>> error -5 returned.
>>> Mar 14 20:16:27 Bigmouth kernel: [7223684.572176] XFS (md2):
>>> xfs_log_force:
>>> error -5 returned.
>>> Mar 14 20:16:38 Bigmouth kernel: [7223694.918565]  md2: unknown
>>> partition
>>> table
>>> Mar 14 20:16:43 Bigmouth kernel: [7223700.425290] XFS (md2): Mounting V5
>>> Filesystem
>>> Mar 14 20:16:43 Bigmouth kernel: [7223700.545669] XFS (md2): Starting
>>> recovery (logdev: internal)
>>> Mar 14 20:16:44 Bigmouth kernel: [7223701.874245] XFS (md2): Ending
>>> recovery
>>> (logdev: internal)
>>> Mar 14 20:30:31 Bigmouth kernel: [7224529.528678]  md2: unknown
>>> partition
>>> table
>>>
>>>
>>>
>>> /dev/md2:
>>>          Version : 1.2
>>>    Creation Time : Tue Oct 13 22:21:27 2015
>>>       Raid Level : raid5
>>>       Array Size : 5860147200 (5588.67 GiB 6000.79 GB)
>>>    Used Dev Size : 1953382400 (1862.89 GiB 2000.26 GB)
>>>     Raid Devices : 4
>>>    Total Devices : 4
>>>      Persistence : Superblock is persistent
>>>
>>>    Intent Bitmap : Internal
>>>
>>>      Update Time : Tue Apr 12 01:19:43 2016
>>>            State : clean
>>>   Active Devices : 4
>>> Working Devices : 4
>>>   Failed Devices : 0
>>>    Spare Devices : 0
>>>
>>>           Layout : left-symmetric
>>>       Chunk Size : 512K
>>>
>>>             Name : Bigmouth:2  (local to host Bigmouth)
>>>             UUID : ed979276:3459155c:a32f63da:0c684042
>>>           Events : 62846
>>>
>>>      Number   Major   Minor   RaidDevice State
>>>         5       8      193        0      active sync   /dev/sdm1
>>>         6       8      129        1      active sync   /dev/sdi1
>>>         2       8      177        2      active sync   /dev/sdl1
>>>         4       8      113        3      active sync   /dev/sdh1
>>>
>>>
>>> meta-data=/dev/md2               isize=512    agcount=33,
>>> agsize=45782272
>>> blks
>>>           =                       sectsz=512   attr=2, projid32bit=1
>>>           =                       crc=1        finobt=1 spinodes=0
>>> data     =                       bsize=4096   blocks=1465036800,
>>> imaxpct=5
>>>           =                       sunit=128    swidth=384 blks
>>> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
>>> log      =internal               bsize=4096   blocks=521728, version=2
>>>           =                       sectsz=512   sunit=8 blks,
>>> lazy-count=1
>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>>
>>>
>>>>
>>>>>
>>>>> Checking the drives with smartctl shows no errors nor does 'dmesg'
>>>>> show any
>>>>> hardware i/o or controller related errors...
>>>>>
>>>>> I've tried scrubbing the array and no bad sectors are found either..
>>>>>
>>>>> I'm running kernel 3.19.8 with xfsprogs 4.5.
>>>>>
>>>>> Thanks,
>>>>> Andrew
>>>>>
>>>>> _______________________________________________
>>>>> xfs mailing list
>>>>> xfs@oss.sgi.com
>>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>>
>>
>
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

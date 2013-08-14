Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EFAA77FC3
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 10:06:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 75C48AC003
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 08:06:22 -0700 (PDT)
Received: from mx1.vr-web.de (mx0.vr-web.de [195.200.35.198]) by cuda.sgi.com
	with ESMTP id ebtUtkJn2ZegrPgj for <xfs@oss.sgi.com>;
	Wed, 14 Aug 2013 08:06:19 -0700 (PDT)
Message-ID: <520B9CCF.1040908@allmail.net>
Date: Wed, 14 Aug 2013 17:05:51 +0200
From: Michael Maier <m1278468@allmail.net>
MIME-Version: 1.0
Subject: Re: Failure growing xfs with linux 3.10.5
References: <52073905.8010608@allmail.net> <5207D9C4.7020102@sandeen.net>
	<52090C6C.6060604@allmail.net> <20130813000453.GQ12779@dastard>
	<520A5132.6090608@allmail.net> <520B1B4F.9070800@hardwarefreak.com>
In-Reply-To: <520B1B4F.9070800@hardwarefreak.com>
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
To: stan@hardwarefreak.com
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Stan Hoeppner schrieb:
> On 8/13/2013 10:30 AM, Michael Maier wrote:
>> Dave Chinner wrote:
>>> [ re-ccing the list, because finding this is in everyone's interest ]
>>>
>>> On Mon, Aug 12, 2013 at 06:25:16PM +0200, Michael Maier wrote:
>>>> Eric Sandeen wrote:
>>>>> On 8/11/13 2:11 AM, Michael Maier wrote:
>>>>>> Hello!
>>>>>>
>>>>>> I think I'm facing the same problem as already described here:
>>>>>> http://thread.gmane.org/gmane.comp.file-systems.xfs.general/54428
>>>>>
>>>>> Maybe you can try the tracing Dave suggested in that thread?
>>>>> It certainly does look similar.
>>>>
>>>> I attached a trace report while executing xfs_growfs /mnt on linux 3.10.5 (does not happen with 3.9.8).
>>>>
>>>> xfs_growfs /mnt
> 
> 
>>>>>>>>>> meta-data=/dev/mapper/backupMy-daten3 isize=256    agcount=42, agsize=7700480 blks
> 
> 
>>>>          =                       sectsz=512   attr=2
>>>> data     =                       bsize=4096   blocks=319815680, imaxpct=25
>>>>          =                       sunit=0      swidth=0 blks
>>>> naming   =version 2              bsize=4096   ascii-ci=0
>>>> log      =internal               bsize=4096   blocks=60160, version=2
>>>>          =                       sectsz=512   sunit=0 blks, lazy-count=1
>>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>>> xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs cleaning
>>>> data blocks changed from 319815680 to 346030080
>>>>
>>>> The entry in messages was:
>>>>
>>>> Aug 12 18:09:50 dualc kernel: [  257.368030] ffff8801e8dbd400: 58 46 53 42 00 00 10 00 00 00 00 00 13 10 00 00  XFSB............
>>>> Aug 12 18:09:50 dualc kernel: [  257.368037] ffff8801e8dbd410: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>>> Aug 12 18:09:50 dualc kernel: [  257.368042] ffff8801e8dbd420: 46 91 c6 80 a9 a9 4d 8c 8f e2 18 fd e8 7f 66 e1  F.....M.......f.
>>>> Aug 12 18:09:50 dualc kernel: [  257.368045] ffff8801e8dbd430: 00 00 00 00 04 00 00 04 00 00 00 00 00 00 00 80  ................
>>>> Aug 12 18:09:50 dualc kernel: [  257.368051] XFS (dm-33): Internal error xfs_sb_read_verify at line 730 of file
>>>> /daten2/tmp/rpm/BUILD/kernel-desktop-3.10.5/linux-3.10/fs/xfs/xfs_mount.c.  Caller 0xffffffffa099a2fd
>>> .....
>>>> Aug 12 18:09:50 dualc kernel: [  257.368533] XFS (dm-33): Corruption detected. Unmount and run xfs_repair
>>>> Aug 12 18:09:50 dualc kernel: [  257.368611] XFS (dm-33): metadata I/O error: block 0x3ac00000 ("xfs_trans_read_buf_map") error 117 numblks 1
>>>> Aug 12 18:09:50 dualc kernel: [  257.368623] XFS (dm-33): error 117 reading secondary superblock for ag 16
>>>
>>> Ok, so that's reading the secondary superblock for AG 16. You're
>>> growing the filesystem from 42 to 45 AGs, so this problem is not
> 
> The AGs are ~30GB.  Going from 42 to 45 grows the XFS by 90GB.  Michael,
> how much were you attempting to grow?  Surely more than 90GB.
> 
>>> related to the actual grow operation - it's tripping over a problem
>>> that already exists on disk before the grow operation is started.
>>> i.e. this is likely to be a real corruption being seen, and it
>>> happened some time in the distant past and so we probably won't ever
>>> be able to pinpoint the cause of the problem.
>>>
>>> That said, let's have a look at the broken superblock. Can you post
>>> the output of the commands:
>>>
>>> # xfs_db -r -c "sb 16" -c p <dev>
>>
>> done after the failed growfs mentioned above:
>>
>> magicnum = 0x58465342
>> blocksize = 4096
>> dblocks = 319815680
>> rblocks = 0
>> rextents = 0
>> uuid = 4691c680-a9a9-4d8c-8fe2-18fde87f66e1
>> logstart = 67108868
>> rootino = 128
>> rbmino = 129
>> rsumino = 130
>> rextsize = 1
>> agblocks = 7700480
>> agcount = 42
>> rbmblocks = 0
>> logblocks = 60160
>> versionnum = 0xb4a4
>> sectsize = 512
>> inodesize = 256
>> inopblock = 16
>> fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
>> blocklog = 12
>> sectlog = 9
>> inodelog = 8
>> inopblog = 4
>> agblklog = 23
>> rextslog = 0
>> inprogress = 0
>> imax_pct = 25
>> icount = 6464
>> ifree = 631
>> fdblocks = 1124026
>> frextents = 0
>> uquotino = 0
>> gquotino = 0
>> qflags = 0
>> flags = 0
>> shared_vn = 0
>> inoalignmt = 2
>> unit = 0
>> width = 0
>> dirblklog = 0
>> logsectlog = 0
>> logsectsize = 0
>> logsunit = 1
>> features2 = 0xa
>> bad_features2 = 0xa
>>
>>>
>>> and
>>>
>>> # xfs_db -r -c "sb 16" -c "type data" -c p <dev>
>>
>> 000: 58465342 00001000 00000000 13100000 00000000 00000000 00000000 00000000
>> 020: 4691c680 a9a94d8c 8fe218fd e87f66e1 00000000 04000004 00000000 00000080
>> 040: 00000000 00000081 00000000 00000082 00000001 00758000 0000002a 00000000
>> 060: 0000eb00 b4a40200 01000010 00000000 00000000 00000000 0c090804 17000019
>> 080: 00000000 00001940 00000000 00000277 00000000 001126ba 00000000 00000000
>> 0a0: 00000000 00000000 00000000 00000000 00000000 00000002 00000000 00000000
>> 0c0: 00000000 00000001 0000000a 0000000a 8f980320 73987e9e db829704 ef73fe2e
>> 0e0: 8f980320 73987e9e db829704 ef73fe2e 8f980320 73987e9e db829704 ef73fe2e
>> 100: 8f980320 73987e9e db829704 ef73fe2e 8f980320 73987e9e db829704 ef73fe2e
>> 120: 8f980320 73987e9e db829704 ef73fe2e 8f980320 73987e9e db829704 ef73fe2e
>> 140: 8f980320 73987e9e db829704 ef73fe2e 8f980320 73987e9e db829704 ef73fe2e
>> 160: 8f980320 73987e9e db829704 ef73fe2e 8f980320 73987e9e db829704 ef73fe2e
>> 180: 8f980320 73987e9e db829704 ef73fe2e 8f980320 73987e9e db829704 ef73fe2e
>> 1a0: 8f980320 73987e9e db829704 ef73fe2e 8f980320 73987e9e db829704 ef73fe2e
>> 1c0: 8f980320 73987e9e db829704 ef73fe2e 8f980320 73987e9e db829704 ef73fe2e
>> 1e0: 8f980320 73987e9e db829704 ef73fe2e 8f980320 73987e9e db829704 ef73fe2e
>>>
>>> so we can see the exact contents of that superblock?
>>>
>>> FWIW, how many times has this filesystem ben grown?
>>
>> I can't say for sure, about 4 or 5 times?
>>
>>> Did it start
>>> with only 32 AGs (i.e. 10TB in size)?
>>
>> 10TB? No. The device just has 3 TB. You most probably meant 10GB?
>> I'm not sure, but it definitely started with > 100GB.
> 
> According to your xfs_info output that I highlighted above, and assuming
> my math here is correct,
> 
> (((7700480*4096)/1048576)*42)= 1,263,360 GB or ~1.23 TB
> 
> this filesystem was 1.23 TB w/42 AGs before the grow operation.
> Assuming defaults were used during mkfs.xfs it would appear the initial
> size of this filesystem was ~120GB.  And it would appear it has been
> grown to ~10x its original size, and from 4 AGs to 42 AGs.  That seems
> like a lot of growth, to me.  And Dave states the latest grow operation
> was to 45 AGs, which would yield a ~1.32TB filesystem, not 3TB.

He wrote about 10TB (=Terra(!) Byte). The entire HD only has 3 TB.
10TB is impossible!

The last growfs was about 100GB. The FS was grown lots of times
since the initial creation one or two years ago.

About the sizes before the last grow and after it: see
http://www.spinics.net/lists/xfs/msg21032.html


Thanks,
regards,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

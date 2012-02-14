Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1ENOEEM130830 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 17:24:15 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Pq9tsXswynQwvtiA for
	<xfs@oss.sgi.com>; Tue, 14 Feb 2012 15:24:13 -0800 (PST)
Message-ID: <4F3AED1C.4040703@redhat.com>
Date: Tue, 14 Feb 2012 15:24:12 -0800
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: xfs_fsr (defragmenting) 'XFS_IOC_SWAPEXT failed: ino=xxxxxx:
	Invalid argument' error
References: <4F3AAC04.5090400@rhul.ac.uk>
In-Reply-To: <4F3AAC04.5090400@rhul.ac.uk>
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
To: Tom Crane <T.Crane@rhul.ac.uk>
Cc: xfs@oss.sgi.com

On 2/14/12 10:46 AM, Tom Crane wrote:
> Dear XFS Support,
>   I am attempting to use xfs_fsr to defrag a 60TB FS but am getting some of the following errors;
> 'XFS_IOC_SWAPEXT failed: ino=xxxxxx: Invalid argument'.  Most files defrag w/o problem.  In an hour long run only 45/(45+6211) failed this way.  Here is a example chunk of syslog from a run with fsr -v which includes the FS level reports.
> 
> 
>> Feb 14 15:49:13 store3 fsr[10917]: extents before:10 after:1 DONE ino=797765
>> Feb 14 15:49:13 store3 fsr[10917]: ino=797738
>> Feb 14 15:49:13 store3 fsr[10917]: extents before:9 after:1 DONE ino=797738
>> Feb 14 15:49:13 store3 fsr[10917]: ino=797749
>> Feb 14 15:49:14 store3 fsr[10917]: extents before:8 after:1 DONE ino=797749
>> Feb 14 15:49:14 store3 fsr[10917]: ino=797754
>> Feb 14 15:49:15 store3 fsr[10917]: extents before:8 after:1 DONE ino=797754
>> Feb 14 15:49:15 store3 fsr[10917]: ino=797728
>> Feb 14 15:49:17 store3 kernel: Filesystem dm-0: fs/xfs/xfs_dfrag.c: inode 0xc2c20 format is incompatible for exchanging.
>> Feb 14 15:49:17 store3 fsr[10917]: XFS_IOC_SWAPEXT failed: ino=797728: Invalid argument
>> Feb 14 15:49:17 store3 fsr[10917]: ino=797753
>> Feb 14 15:49:18 store3 kernel: Filesystem dm-0: fs/xfs/xfs_dfrag.c: inode 0xc2c39 format is incompatible for exchanging.
>> Feb 14 15:49:18 store3 fsr[10917]: XFS_IOC_SWAPEXT failed: ino=797753: Invalid argument
>> Feb 14 15:49:18 store3 fsr[10917]: ino=797740
>> Feb 14 15:49:20 store3 fsr[10917]: extents before:6 after:1 DONE ino=797740
>> Feb 14 15:49:20 store3 fsr[10917]: ino=797721
>> Feb 14 15:49:21 store3 fsr[10917]: extents before:5 after:1 DONE ino=797721
>> Feb 14 15:49:21 store3 fsr[10917]: ino=797720
>> Feb 14 15:49:22 store3 fsr[10917]: extents before:4 after:1 DONE ino=797720
>> Feb 14 15:49:22 store3 fsr[10917]: ino=797723
>> Feb 14 15:49:23 store3 fsr[10917]: extents before:4 after:1 DONE ino=797723
> 
> I have had a browse in the archive and can rule out an SElinux attribute difference (using xfs_io -c lsattr) between the problem files and the others.  It is not an busy file problem either.  I've rechecked with fuser and xfs_fsr -v on some of the individual files and always get the same error.  xfs_bmaping the problem files afterwards shows they remain un-defragmented.  Here is the output of xfs_bmap -v on the file with inode=797728.
> 
> 
>> EXT: FILE-OFFSET       BLOCK-RANGE              AG AG-OFFSET              TOTAL FLAGS
>>    0: [0..61439]:       81759234304..81759295743 38 (154865408..154926847) 61440 00011
>>    1: [61440..127407]:  81959724544..81959790511 38 (355355648..355421615) 65968 00111
>>    2: [127408..127791]: 81959790528..81959790911 38 (355421632..355422015)   384 01111
>>    3: [127792..127807]: 81959790512..81959790527 38 (355421616..355421631)    16 01111
>>    4: [127808..157695]: 81959791104..81959820991 38 (355422208..355452095) 29888 00111
>>    5: [157696..186367]: 81959013120..81959041791 38 (354644224..354672895) 28672 00011
>>    6: [186368..225039]: 81980197120..81980235791 38 (375828224..375866895) 38672 00111
> 
> 
> I am running the latest (v.3.1.7) xfsprogs.  My OS is SLC5 Linux with kernel details,
> 2.6.18-274.17.1.el5 #1 SMP Wed Jan 11 11:10:32 CET 2012 x86_64 x86_64 x86_64 GNU/Linux.
> xfs_info reports the following for the FS,
> 
> xfs_info  /dev/mapper/vg0-lvol0
> meta-data=/dev/mapper/vg0-lvol0  isize=256    agcount=59, agsize=268435424 blks
>         =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=15624994816, imaxpct=5
>         =                       sunit=32     swidth=128 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>         =                       sectsz=512   sunit=32 blks, lazy-count=0
> realtime =none                   extsz=524288 blocks=0, rtextents=0
> 
> 
> Is this a known problem with xfs in this kernel? Any other information/tests that I can supply?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e09f98606dcc156de1146c209d45a0d6d5f51c3f
and
http://git.kernel.org/?p=fs/xfs/xfsprogs-dev.git;a=commitdiff;h=bdb041f58dc436dcb10b698ed8715fb889589b90

contain a lot of comments about what it is you're running into.  The latter (the userspace change) should have made these less frequent.

If you're familiar with tracepoints, can you enable these and watch?

This should do it:

# mount -t debugfs none /sys/kernel/debug
# echo 1 > /sys/kernel/debug/tracing/tracing_enabled
# echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_swap_extent_before/enable
# echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_swap_extent_after/enable

<run your failing fsr run>

# cat /sys/kernel/debug/tracing/trace

and that should give us more info.

Thanks,
-Eric



> Many thanks
> Tom Crane
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

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7K0cjhN052912 for <xfs@oss.sgi.com>; Fri, 19 Aug 2011 19:38:46 -0500
Received: from crunch.scalableinformatics.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F062E1385677
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2011 17:41:04 -0700 (PDT)
Received: from crunch.scalableinformatics.com
	(173-10-54-97-Michigan.hfc.comcastbusiness.net [173.10.54.97])
	by cuda.sgi.com with ESMTP id aHXFl5XyP5cuDi3M for
	<xfs@oss.sgi.com>; Fri, 19 Aug 2011 17:41:04 -0700 (PDT)
Message-ID: <4E4F021D.50000@scalableinformatics.com>
Date: Fri, 19 Aug 2011 20:38:53 -0400
From: Joe Landman <landman@scalableinformatics.com>
MIME-Version: 1.0
Subject: Re: bug: xfs_repair becomes very slow when file system has a large
	sparse file
References: <4E4E9131.2050807@scalableinformatics.com>
	<20110820002657.GF32358@dastard>
In-Reply-To: <20110820002657.GF32358@dastard>
Reply-To: landman@scalableinformatics.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 8/19/2011 8:26 PM, Dave Chinner wrote:
> On Fri, Aug 19, 2011 at 12:37:05PM -0400, Joe Landman wrote:
>> (If you prefer we file this on a bug reporting system, please let me
>> know where and I'll do this).
>>
>> Scenario:  xfs_repair being run against an about 17TB volume,
>> containing 1 large sparse file.  Logical size of 7 PB, actual size,
>> a few hundred GB.
>>
>> Metadata:  Kernel = 2.6.32.41, 2.6.39.4, and others. Xfstools 3.1.5.
>> Hardware RAID ~17TB LUN.  Base OS: Centos 5.6 + updates + updated
>> xfs tools + our kernels.  Using external journal on a different
>> device
>>
>> What we observe:
>>
>> Running xfs_repair
>>
>> 	xfs_repair -l /dev/md2 -vv /dev/sdd2
>
> can you post the actual output of xfs_repair?

[root@jr4-2 ~]# xfs_repair -l /dev/md2 -vv /dev/sdd2
Phase 1 - find and verify superblock...
- max_mem = 37094400, icount = 1346752, imem = 5260, dblock =
4391112384, dmem = 2144097
- block cache size set to 4361880 entries
Phase 2 - using external log on /dev/md2
- zero log...
zero_log: head block 126232 tail block 126232
- scan filesystem freespace and inode maps...
agf_freeblks 11726908, counted 11726792 in ag 1
sb_ifree 2366, counted 2364
sb_fdblocks 2111548832, counted 2111548716
- found root inode chunk
libxfs_bcache: 0x8804c0
Max supported entries = 4361880
Max utilized entries = 4474
Active entries = 4474
Hash table size = 545235
Hits = 0
Misses = 4474
Hit ratio = 0.00
MRU 0 entries = 4474 (100%)
MRU 1 entries = 0 ( 0%)
MRU 2 entries = 0 ( 0%)
MRU 3 entries = 0 ( 0%)
MRU 4 entries = 0 ( 0%)
MRU 5 entries = 0 ( 0%)
MRU 6 entries = 0 ( 0%)
MRU 7 entries = 0 ( 0%)
MRU 8 entries = 0 ( 0%)
MRU 9 entries = 0 ( 0%)
MRU 10 entries = 0 ( 0%)
MRU 11 entries = 0 ( 0%)
MRU 12 entries = 0 ( 0%)
MRU 13 entries = 0 ( 0%)
MRU 14 entries = 0 ( 0%)
MRU 15 entries = 0 ( 0%)
Hash buckets with 0 entries 541170 ( 0%)
Hash buckets with 1 entries 3765 ( 84%)
Hash buckets with 2 entries 242 ( 10%)
Hash buckets with 3 entries 15 ( 1%)
Hash buckets with 4 entries 36 ( 3%)
Hash buckets with 5 entries 6 ( 0%)
Hash buckets with 6 entries 1 ( 0%)
Phase 3 - for each AG...
- scan and clear agi unlinked lists...
- process known inodes and perform inode discovery...
- agno = 0
bad magic number 0xc88 on inode 5034047
bad version number 0x40 on inode 5034047
bad inode format in inode 5034047
correcting nblocks for inode 5034046, was 185195 - counted 0
bad magic number 0xc88 on inode 5034047, resetting magic number
bad version number 0x40 on inode 5034047, resetting version number
bad inode format in inode 5034047
cleared inode 5034047

(then it hangs here)


>> the system gets to stage 3 and the first ag.  Then it appears to
>> stop. After an hour or so, we strace it, and we see
>>
>> 	pread(...) = 4096
>
> and the same for the strace, along with syscall completion time?
> (i.e. strace -ttt -T .....) That will tell us if the time is spend
> doing IO or in the repair binary.

Unfortunately, we fixed the original system.  We'll see if we can create 
this condition in the lab, and then post this.

> What is the CPU usage when this happens? How much memory do you

Very low.  The machine is effectively idle, user load of 0.01 or so.

48 GB ram in these machine

> have? Is the machine swapping while it is slowing down? A couple of

No.  I've not seen xfs_repair use more than a few hundred MB on this problem

> minutes output of 'vmstat 5' when it is in this state would be handy.
>
>> occurring about 2-3 per second.  An hour later, its down to 1 per
>> second.   An hour after that, its once every 2 seconds.
>>
>> Also, somewhere on this disk, someone has created an unfortunately
>> large file
>>
>> [root@jr4-2 ~]# ls -alF /data/brick-sdd2/dht/scratch/xyzpdq
>> total 4652823496
>> d---------   2 1232 1000               86 Jun 27 20:31 ./
>> drwx------ 104 1232 1000            65536 Aug 17 23:53 ../
>> -rw-------   1 1232 1000               21 Jun 27 09:57 Default.Route

>> -rw-------   1 1232 1000              250 Jun 27 09:57 Gau-00000.inp
>> -rw-------   1 1232 1000                0 Jun 27 09:57 Gau-00000.d2e
>> -rw-------   1 1232 1000 7800416534233088 Jun 27 20:18 Gau-00000.rwf
>>
>> [root@jr4-2 ~]# ls -ahlF /data/brick-sdd2/dht/scratch/xyzpdq
>> total 4.4T
>> d---------   2 1232 1000   86 Jun 27 20:31 ./
>> drwx------ 104 1232 1000  64K Aug 17 23:53 ../
>> -rw-------   1 1232 1000   21 Jun 27 09:57 Default.Route
>> -rw-------   1 1232 1000  250 Jun 27 09:57 Gau-00000.inp
>> -rw-------   1 1232 1000    0 Jun 27 09:57 Gau-00000.d2e
>> -rw-------   1 1232 1000 7.0P Jun 27 20:18 Gau-00000.rwf
>>
>> This isn't a 7PB file system, its a 100TB file system across 3
>> machines, roughly 17TB per brick or OSS.  The Gau-00000.rwf is
>> obviously a sparse file, as could be seen with an ls -alsF
>
> What does du tell you about it?  xfs_io -f -c "stat"<large file>?
> xfs_bmap -vp<large file>?

ls -alsF told me it was a few hundred GB.  Du gave a similar number.

>
>> Upon removing that file, the xfs_repair completes within ~10
>> minutes. Leaving that file on there, the xfs_repair does not
>> terminate, it just gets asymptotically slower.
>
> That could simply be the memory footprint causing more swapping per
> operation to occur. Or it could be that something is simply getting
> too large for the index type being used. If the machine is not
> swapping, can you point 'perf top -p<pid of xfs_repair>' at it so
> we might see where that CPU time is being spent?  (you might need to
> use a non-stripped version of the binary to get any useful
> information)

Ok, we will try to recreate the condition in the lab and generate this.

>
>> Please let me know if you need more information, or if you would
>> like me to file this somewhere else for official reportage.
>
> This is the right place to let us know about problems.

Thanks!



-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.,
email: landman@scalableinformatics.com
web  : http://www.scalableinformatics.com
phone: +1 734 786 8423
fax  : +1 866 888 3112
cell : +1 734 612 4615

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

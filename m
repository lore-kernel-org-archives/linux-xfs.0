Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 19F0D7F3F
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 15:22:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 082A030406B
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 13:22:08 -0800 (PST)
Received: from mail-qc0-f176.google.com (mail-qc0-f176.google.com
	[209.85.216.176]) by cuda.sgi.com with ESMTP id
	nlbBFPLbkfAWaQpx (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Dec 2014 13:22:07 -0800 (PST)
Received: by mail-qc0-f176.google.com with SMTP id i17so1568235qcy.21
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 13:22:06 -0800 (PST)
Message-ID: <54934576.4090603@gmail.com>
Date: Thu, 18 Dec 2014 16:21:58 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: Disconnected inodes after test xfs/261
References: <20141217193535.GA8231@quack.suse.cz>
	<20141217210226.GY24183@dastard>
In-Reply-To: <20141217210226.GY24183@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On 12/17/14 16:02, Dave Chinner wrote:
> On Wed, Dec 17, 2014 at 08:35:35PM +0100, Jan Kara wrote:
>>   Hello,
>>
>>   in my test KVM with today's Linus' kernel I'm getting xfs_repair
>> complaint about disconnected inodes after the test xfs/261 finishes
>> (with success). xfs_repair output is like:
>> xfs_repair -n /dev/vdb2
>> Phase 1 - find and verify superblock...
>> Phase 2 - using internal log
>>         - scan filesystem freespace and inode maps...
>>         - found root inode chunk
>> Phase 3 - for each AG...
>>         - scan (but don't clear) agi unlinked lists...
>>         - process known inodes and perform inode discovery...
>>         - agno = 0
>>         - agno = 1
>>         - agno = 2
>>         - agno = 3
>>         - process newly discovered inodes...
>> Phase 4 - check for duplicate blocks...
>>         - setting up duplicate extent list...
>>         - check for inodes claiming duplicate blocks...
>>         - agno = 0
>>         - agno = 1
>>         - agno = 2
>>         - agno = 3
>> No modify flag set, skipping phase 5
>> Phase 6 - check inode connectivity...
>>         - traversing filesystem ...
>>         - traversal finished ...
>>         - moving disconnected inodes to lost+found ...
>> disconnected inode 132, would move to lost+found
>> disconnected inode 133, would move to lost+found
>> Phase 7 - verify link counts...
>> No modify flag set, skipping filesystem flush and exiting.
>> ---
>> Given how trivial test xfs/261 is, it seems like created private mtab files
>> that also get unlinked don't get added to AGI unlinked list before umount.
>> I didn't have a detailed look whether that's possible or not and probably
>> won't get to it before Christmas. So I'm sending this just in case someone
>> more knowledgeable has ideas earlier...
> 
> I don't see that here. If you mount/unmount the filesystem, does the
> warning go away? i.e. xfs_repair -n ignores the contents of
> the log, so if the unlinked list transactions are in the log then
> log recovery will make everything good again.
> 
> That said, if unmount is not leaving the log clean, then we've still
> got an issue we need to get to the bottom of.
> 
> Cheers,
> 
> Dave.

OK, I played with this a bit, though in all but one case, my XFS stack 
is new.  A bisect will be done to find when this started.  kernel 
3.10.63 here at work is OK, where new xfsprogs is installed.

In trying out new kernels, I hit the "kernel too old" wall on boot.  
Therefore, a new system was brewed from slackware-current, and xfstests 
was installed on top of that.  This result is from the "huge-smp" 
vendor kernel, as it came from the original binary packages:

root@kyhorse:/var/lib/xfstests# uname -a
Linux kyhorse 3.14.24-smp #2 SMP Fri Nov 14 18:34:21 CST 2014 i686 Intel(R) Pentium(R) 4 CPU 1.80GHz GenuineIntel GNU/Linux

root@kyhorse:/var/lib/xfstests# ./check xfs/261
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 kyhorse 3.14.24-smp
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda7
MOUNT_OPTIONS -- /dev/sda7 /mnt/scratch

xfs/261 2s ... 3s
_check_xfs_filesystem: filesystem on /dev/sda7 is inconsistent (c) (see /var/lib/xfstests/results//xfs/261.full)
_check_xfs_filesystem: filesystem on /dev/sda7 is inconsistent (r) (see /var/lib/xfstests/results//xfs/261.full)
Ran: xfs/261
Passed all 1 tests

root@kyhorse:/var/lib/xfstests# xfs_repair $SCRQ ATCH_DEV
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
disconnected inode 132, moving to lost+found
disconnected inode 133, moving to lost+found
Phase 7 - verify and correct link counts...
Note - quota info will be regenerated on next quota mount.
done

A mount/umount sequence did not change matters.  xfsprogs appears to 
be version 3.1.11, glancing from the tarball names in the a/ directory 
here:

ftp://ftp.slackware.com/pub/slackware/slackware-current/slackware/

The new setup was just made bootable before I came in to work, and the 
bisect will start tonight and will hopefully be posted by Monday night.

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

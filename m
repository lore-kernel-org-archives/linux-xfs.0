Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 92D467FFA
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 16:13:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 900878F8035
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 14:13:26 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ooaAutLtOkEJ8W8w for <xfs@oss.sgi.com>;
	Mon, 03 Feb 2014 14:13:23 -0800 (PST)
Date: Tue, 4 Feb 2014 09:12:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: >>: Re: =?utf-8?B?SNCwOiBSZTogWEZTOiBB?= =?utf-8?Q?ssertion?=
	failed: fs_is_ok, file: fs/xfs/xfs_alloc.c, line: 1590
Message-ID: <20140203221257.GT13997@dastard>
References: <OF16FE6E5B.C3E862DE-ON44257C74.001D9802-44257C74.001DDBB0@beeline.ru>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <OF16FE6E5B.C3E862DE-ON44257C74.001D9802-44257C74.001DDBB0@beeline.ru>
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
To: Dmitriy Yu Leonov <DLeonov@beeline.ru>
Cc: xfs@oss.sgi.com

On Mon, Feb 03, 2014 at 09:26:04AM +0400, Dmitriy Yu Leonov wrote:
> Repost my message, because I accidentally answered Dave instead of
> answering all. Sorry.
> I'm registered problem also in XFS bugzilla:
> http://oss.sgi.com/bugzilla/show_bug.cgi?id=1045
> 
> Good evening, Dave.
> 
> I?m installed xfsprogs version 3.1.11 and try to repair filesystem on the
> raid disk. But command xfs_repair -P /dev/sdb1 hanged.
> Then I decided to reboot with old kernel version 3.7.10 (I have several
> versions of kernel). After reboot the system, I ran the command again.
> Command executed successfully in the old kernel 3.7.10. Output of the
> commands attached to the letter after the text.

So you changed the kernel and xfs_repair completed? That sounds like
there might be a problem with the storage drivers for your hardware
on the kernel that repair is hanging on. can you run an strace to
find what syscall xfs_repair is hanging on?

> From the description of the commands output clear that there is a loss of
> log file data. Now I need to restore the file system with a minimum of data
> loss. Is it possible? What command set correctly for that use?
> 
> PS: output of programs and system info in the bottom of signature.
> 
> 
> 
> ?
>   Sincerely, Dmitry.
> 
> 
> uname -a
> Linux devastator 3.7.10-gentoo #2 SMP Wed Mar 27 13:28:00 MSK 2013 x86_64
> Intel(R) Xeon(TM) CPU 3.00GHz GenuineIntel GNU/Linux
> 
> 
> xfs_repair -P /dev/sdb1
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>        - zero log...
> ERROR: The filesystem has valuable metadata changes in a log which needs to
> be replayed.  Mount the filesystem to replay the log, and unmount it before
> re-running xfs_repair.  If you are unable to mount the filesystem, then use
> the -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mount
> of the filesystem before doing this.

YOu're in the catch-22 state here - the log contains a corruption,
so it can't be replayed. hence you are going to have to zero the log
at some point to repair the problem.

> xfs_repair -n /dev/sdb1
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>        - scan filesystem freespace and inode maps...
> block (3,1498933-1498933) multiply claimed by cnt space tree, state - 2
> agf_freeblks 259940761, counted 259940776 in ag 3
> agf_freeblks 255012362, counted 255012365 in ag 4
> agf_freeblks 260627255, counted 260627372 in ag 5
> agf_freeblks 255168644, counted 255168626 in ag 2
> agf_freeblks 207044983, counted 207044984 in ag 6
> agf_freeblks 243646150, counted 243646100 in ag 1
> block (0,9288775-9288775) multiply claimed by cnt space tree, state - 2
> block (0,9292880-9292880) multiply claimed by cnt space tree, state - 2
> block (0,9311746-9311746) multiply claimed by cnt space tree, state - 2
> block (0,9313774-9313774) multiply claimed by cnt space tree, state - 2
> block (0,4010552-4010552) multiply claimed by cnt space tree, state - 2
> block (0,7294010-7294010) multiply claimed by cnt space tree, state - 2
> block (0,6907114-6907114) multiply claimed by cnt space tree, state - 2
> block (0,4058360-4058360) multiply claimed by cnt space tree, state - 2
> block (0,3891784-3891784) multiply claimed by cnt space tree, state - 2
> block (0,9322824-9322824) multiply claimed by cnt space tree, state - 2
> agf_freeblks 228242757, counted 228242913 in ag 0
> sb_fdblocks 1709684933, counted 1709685157

So what this is telling us is that there are lots of block
allocations and removals in the log that are being ignored.

>        - found root inode chunk
> Phase 3 - for each AG...
>        - scan (but don't clear) agi unlinked lists...
>        - process known inodes and perform inode discovery...
>        - agno = 0
> data fork in ino 16762966 claims free block 16654424
> bad nblocks 256 for inode 16764668, would reset to 255

That's indicating that the inode has less blocks than it thinks.
i.e. the allocation of the last block will be lost.

> data fork in ino 16767882 claims free block 9317836
> data fork in ino 16767882 claims free block 9317837

These should be recovered just fine

> bad nblocks 530 for inode 16767882, would reset to 545
> data fork in ino 16770934 claims free block 9309594
> data fork in ino 16770934 claims free block 9309595
> bad nblocks 2396 for inode 16772596, would reset to 2395
> data fork in ino 16775619 claims free block 9319785
> data fork in ino 16775619 claims free block 9319786
> bad nblocks 6284 for inode 16775619, would reset to 6291

And that's the opposite - a truncate will be lost. Whether the
truncated space still contains good data, I can't say.

> bad nblocks 103 for inode 16780498, would reset to 102
> bad nextents 27 for inode 16780498, would reset to 26
> data fork in ino 16781959 claims free block 7295214
> data fork in ino 16781959 claims free block 7295215
> bad nblocks 76 for inode 16781959, would reset to 81
> bad key in bmbt root (is 1856, would reset to 1844) in inode 16782070 data
> fork

That's an error in an block map btree block which means it may be
pointing to bad data now.

.....

> bad magic # 0x20313030 in inode 16927721 (data fork) bmbt block 9305534
> bad data fork in inode 16927721
> would have cleared inode 16927721

That's an inode whose block map is corrupt and cannot be recovered
at all, so the data is lost here.

.....
> entry "10.6.114.148" at block 297 offset 496 in directory inode 19125
> references free inode 16927721
>        would clear inode number in entry at offset 496...

That inode is considered free and would be reclaimed.

> Phase 6 - check inode connectivity...
>        - traversing filesystem ...
> entry "10.6.114.148" in directory inode 19125 points to free inode 16927721
> , would junk entry

and that's cleaning up the directory entry.

> 
> xfsprogs util?s works fine with kernel 3.7.10 (config kernel params list
> below):
> /usr/src/linux-3.7.10-gentoo/.config
> CONFIG_XFS_FS=y
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> # CONFIG_XFS_DEBUG is not set
> 
> xfsprogs util?s hangs in start with kernel 3.10.25 (config kernel params
> list below):
> /usr/src/linux-3.10.25-gentoo/.config
> CONFIG_XFS_FS=y
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> CONFIG_XFS_DEBUG=y

Any reason you are running CONFIG_XFS_DEBUG=y? You shoul dnot do
that unless you are actively trying to debug a problem as it has
impact on runtime performance, availability (i.e. it will panic on
certain errors that can otherwise be handled) and it affects
allocation algorithms in a way that causes accelerated aging of the
filesystem....

> Output of log print command I?am upload in web-site:
> xfs_logprint -d -C ./xfs_log.dump
> http://yadi.sk/d/Jxv-ItRSGt8vN

I'm not going to be able to do anything with that. Even if I could
fine the corruption in the log from it, I'd just say "run xfs_repair
and look at all the inodes that it fixed and determine what was
lost from that"...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

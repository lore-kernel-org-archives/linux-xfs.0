Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4DNpgwb181823 for <xfs@oss.sgi.com>; Wed, 13 May 2009 18:51:42 -0500
Received: from web65615.mail.ac4.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id A52701D30AD0
	for <xfs@oss.sgi.com>; Wed, 13 May 2009 16:51:48 -0700 (PDT)
Received: from web65615.mail.ac4.yahoo.com (web65615.mail.ac4.yahoo.com
	[76.13.9.83]) by cuda.sgi.com with SMTP id f3AWVkY1iy5OaySD for
	<xfs@oss.sgi.com>; Wed, 13 May 2009 16:51:48 -0700 (PDT)
Message-ID: <502709.63746.qm@web65615.mail.ac4.yahoo.com>
References: <283244.29270.qm@web65608.mail.ac4.yahoo.com>
	<4A0A0E76.6000701@sandeen.net>
	<618437.93111.qm@web65601.mail.ac4.yahoo.com>
	<4A0A55E0.4010202@sandeen.net>
	<705795.15734.qm@web65604.mail.ac4.yahoo.com>
	<20090513222823.GL16929@discord.disaster>
Date: Wed, 13 May 2009 16:51:48 -0700 (PDT)
From: p v <pvlogin@yahoo.com>
Subject: Re: file preallocation without unwritten flag being set
In-Reply-To: <20090513222823.GL16929@discord.disaster>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com



I did it on a fresh filesystem (of course). It didn't make a difference - sb flags cleared, extent flags set, xfs_repair unhappy. I tried to repro again and do cut/paste of my steps but I lost the machine. The only difference this time was that I was going to do it with the default mkfs and mount options. I created the fs, cleared extflg from the superblocks and run xfs_io to resvsp the space. Then I run truncate and truncate decided to initialize the extents to zero and since it's 10TB it's going to take a while (can't reset as it's a remote machine and xfs_io is looping in the kernel ...). It didn't do it before and if I remember right the only differences were mkfs with 2048 size inodes and mount options with noatime,nodiratime,inode64,allocsize=1g. Anyway - I'll try it again on a different machine and send the steps. However the fact that it did try to zero the reserved space tells me that the extent flags were not set this time - and unfortunatelly
 it also means that it won't work - unless I do the previous workaround and instead of calling truncate from xfs_io I'll do the xfs_db and set the inode size directly - in fact now I remember that was exactly the reason why the original steps were so tricky - truncate up would zero extents but xfs_db will set the inode size to whatever without any problem.

Thanks for the info regarding the max extent size.

The man pages I am looking at (FC4, Centos5) don't have the xfs options like allocsize, inode64. Probably should download the latest versions ...

I am a little bit lost about the comment regarding the page caches. I unmounted the filesystem before running xfs_db. Shouldn't that flush pages, buffers, ...? I assume that xfs_db goes directly to the device so if the fs was unmounted then the device should be up to date?

thx

Peter Vajgel




----- Original Message ----
From: Dave Chinner <david@fromorbit.com>
To: p v <pvlogin@yahoo.com>
Cc: Eric Sandeen <sandeen@sandeen.net>; xfs@oss.sgi.com
Sent: Wednesday, May 13, 2009 3:28:23 PM
Subject: Re: file preallocation without unwritten flag being set

On Wed, May 13, 2009 at 02:05:16PM -0700, p v wrote:
> 
> doesn't seem to work - I tried to clear the extflg in the
> versionnum of the superblock (in every copy of it as well) but it
> doesn't work. The flag is still set on all extents.

Sure - that xfs_db command only clears it from the superblock so
that *new* preallocations don't have the unwritten bit set. it
doesn't change existing allocations.

> And once I make the file xfs_repair complains and resets the sb
> flag - my guess is that in the extent allocation path it is
> hardcoded for the version 4.

More likely is that repair is seeing an existing unwritten extent
and setting the flag on the superblock.

> - any extent allocated beyond file size will get the flag .

Allocation beyond EOF does not use unwritten extents unless
it is preallocation.

> Also - 2 questions -
> 
> 1) what is inode64 and where can I find out all of the
> undocumented mkfs/mount options (it's unfortunate that such a good
> fs doesnt' have a correspondingly good documentation)

All the options should be documented.  Try 'man mkfs.xfs', 'man 8
mount' and Documentation/filesystems/xfs.txt

> 2) why is the largest extent size limited to xxx blocks

2^21 blocks. Limited to that because there are 21 bits for
the extent size in the on disk extent record.

> (can't find
> out thenumber - when does the inode get finally flushed? ls -i
> reports 19 as the inode number but even after unmounting inode 19
> in xfs_db still shows a free inode - is it still only in the
> log???)

Might be, or you are seeing stale cached block device data
(xfs_db operates in a different address space to a mounted
filesystem). Try dropping the page cache and then re-read.

> ? I assumed that xfs_bmap gets me the correct number of
> extents but now looking at the inode with xfs_db it's obvious that
> xfs_bmap reports contiguous ranges rather than actual extents in
> the blockmap tree.

Sure it does. You can tell how many extents a specific range is from
their maximum size (e.g. one extent per 8GB for a 4k block size
filesystem).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com



      

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

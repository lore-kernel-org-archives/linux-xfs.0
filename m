Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4DMSLXI178589 for <xfs@oss.sgi.com>; Wed, 13 May 2009 17:28:21 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 696B728490C
	for <xfs@oss.sgi.com>; Wed, 13 May 2009 15:28:27 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	yglerNb81Vr8dzfG for <xfs@oss.sgi.com>;
	Wed, 13 May 2009 15:28:27 -0700 (PDT)
Date: Thu, 14 May 2009 08:28:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: file preallocation without unwritten flag being set
Message-ID: <20090513222823.GL16929@discord.disaster>
References: <283244.29270.qm@web65608.mail.ac4.yahoo.com>
	<4A0A0E76.6000701@sandeen.net>
	<618437.93111.qm@web65601.mail.ac4.yahoo.com>
	<4A0A55E0.4010202@sandeen.net>
	<705795.15734.qm@web65604.mail.ac4.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <705795.15734.qm@web65604.mail.ac4.yahoo.com>
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
To: p v <pvlogin@yahoo.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

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

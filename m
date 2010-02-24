Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1ON0sx6055279 for <xfs@oss.sgi.com>; Wed, 24 Feb 2010 17:00:55 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 41B0C1CF6FA8
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2010 15:02:15 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	r8MmBVi7EnfgPhVO for <xfs@oss.sgi.com>;
	Wed, 24 Feb 2010 15:02:15 -0800 (PST)
Date: Thu, 25 Feb 2010 10:02:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_growfs failure....
Message-ID: <20100224230211.GL16175@discord.disaster>
References: <E51793F9F4FAD54A8C1774933D8E500006B64A2687@sbapexch05>
	<19333.23937.956036.716@tree.ty.sabi.co.uk>
	<E51793F9F4FAD54A8C1774933D8E500006B64A2793@sbapexch05>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <E51793F9F4FAD54A8C1774933D8E500006B64A2793@sbapexch05>
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
To: Joe Allen <Joe.Allen@citrix.com>
Cc: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>, Linux XFS <xfs@oss.sgi.com>

On Wed, Feb 24, 2010 at 10:37:30AM -0800, Joe Allen wrote:
> Thanks so much for the help interpreting. 
> We are extremely grateful for your help. 
> I have tried to include some more information you all suggest might help:
> 
> 
> >> It looks like that the filesystem was "grown" from ~92TiB to
> ~114TiB on a storage device that is reported as ~103TiB
> long. Again, very strange.
> 
> cat /proc/partitions
> [snip]
> 253    61 107971596288 dm-61
> 
> = ~100TB. 

OK.

> >>112 AGs of 1TiB each - that confirms the grow succeeded and it was able to write metadata to disk 
> >>between 100 and 111 TiB without errors being reported. That
> >>implies the block device must have been that big at some
> >>point...
> 
> There were never 110 TB; only 100 were ever there...so I am not clear on this point. 

Well, XFS writes the new AG header metadata synchronously to the
expanded region before making the superblock changes. If they didn't
error out, either:

	a. the block device was large enough
	b. the writes were silently ignored by the block device
	   (buggy block device)
	c. the block device wrapped them back around to the front of
	   the device (buggy block device) and overwrote stuff => fs
	   corruption.

SO regardless of what actually happened, you're going to need to
run xfs_repair after the main superblock is fixed up.

> >>My impression is that not enough history/context has been
> >>provided to enable a good guess at what has happened and how to
> >>undo the consequent damage.You suggested more context might help: 
> 
> 
> These were the commands run: 
>  
> pvcreate /dev/dm-50 /dev/dm-51 /dev/dm-52 /dev/dm-53 /dev/dm-54 /dev/dm-55
> vgextend logfs-sessions /dev/dm-50 /dev/dm-51 /dev/dm-52 /dev/dm-53 /dev/dm-54 /dev/dm-55
> lvextend -i 3 -I 512 -l +1406973 /dev/logfs-sessions/sessions /dev/dm-50 /dev/dm-51 /dev/dm-52
> lvextend -i 3 -I 512 -l +1406973 /dev/logfs-sessions/sessions /dev/dm-53 /dev/dm-54 /dev/dm-55
> xfs_growfs  /u01 (which failed)
> xfs_growfs -d /u01 (which did not error out)
> touch /u01/a

Ok, 2.8.20 is old enough to have the userspace growfs bugs, and I'd
say the kernel is old enough to have the growfs bugs as well. It is
entirely possible that executing it twice was the cause of this.

> I am sorry I don't have the output of the xfs_growfs command any longer. 
> Very shortly after someone noticed the filesystem was essentially offline -- input output error. 
> Tried unmounting but couldn't... got out of memory errors even when doing ls.  
> Tried rebooting and now FS is off line. 
> 
> The FS was 90TB, the purpose of the exercise was to grow it to 100TB. 
> 
> This is:
> 
> -bash-3.1# uname -a
> Linux xx.com 2.6.18-53.1.19.el5 #1 SMP Tue Apr 22 03:01:10 EDT 2008 x86_64 x86_64 x86_64 GNU/Linux
> 
> rpm -qa | grep xfs
> kmod-xfs-0.4-1.2.6.18_8.1.1.el5.centos.plus.1
> xfsprogs-2.8.20-1.el5.centos

> I've read about a case where Mr Chinner used xfd_db to set agcount
> and in some cases fix things up.
> Don't know if I am a candidate for that approach... 

That's exactly what is has to be done to get the superblock back
into the correct shape to enable a repair run to occur.

First, upgrade your userspace tools to the latest so you pick up all
the xfs_repair speedups and memory usage reductions. Then
calculate the correct block count for 100AGs (dblocks = agcount *
agblocks), modify the agcount and dblocks fields using xfs_db, then 
xfs_repair -n to confirm that it finds the superblock valid.

If the superblock is valid, you can then probably mount the
filesystem to replay the log. Unmount immediately afterwards. Note
that this may replay the bad growfs transaction, so you might need
to use xfs_db to reset the superblock again. Once this is done you
can run repair for real after which you should have a usable
filesytem.

This won't have restored the filesystem to the exact size of the
underlying block device - a subsequent grow would be needed to
extend the fs to include a partial AG at the end to use the
remaining space.

Good luck!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

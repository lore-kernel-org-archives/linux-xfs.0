Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CC4197F3F
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 20:20:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8DE1A30404E
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 18:20:18 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	lMQH6qnEzscdSMIB for <xfs@oss.sgi.com>;
	Sat, 18 May 2013 18:20:16 -0700 (PDT)
Date: Sun, 19 May 2013 11:20:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hangup - Failed to recover EFIs
Message-ID: <20130519012015.GF6495@dastard>
References: <20130518183919.100500@gmx.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130518183919.100500@gmx.com>
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
To: Punk Rider <kornos@mail.com>
Cc: xfs@oss.sgi.com

On Sat, May 18, 2013 at 02:39:19PM -0400, Punk Rider wrote:
> Hello
> 
> After upgrading my laptop from Ubuntu 12.04 LTS to Ubuntu 13.04 Raring i noticed that my Linux would not boot again. 
> So after inserting Ubuntu 13.04 boot disk , this is what i've found out:
> 
> ubuntu@ubuntu:~$ uname -a
> Linux ubuntu 3.8.0-19-generic #29-Ubuntu SMP Wed Apr 17 18:16:28 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
> 
> ubuntu@ubuntu:~$ sudo xfs_repair -v /dev/sda3
> Phase 1 - find and verify superblock...
>  - block cache size set to 363760 entries
> Phase 2 - using internal log
>  - zero log...
> zero_log: head block 32468 tail block 31799
> ERROR: The filesystem has valuable metadata changes in a log which needs to
> be replayed. Mount the filesystem to replay the log, and unmount it before
> re-running xfs_repair. If you are unable to mount the filesystem, then use
> the -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mount
> of the filesystem before doing this.
> ubuntu@ubuntu:~$ ls /mnt/
> ubuntu@ubuntu:~$ sudo mount /dev/sda3 /mnt
>  ^C^C -> mount command hang indefinetely
> 
> On other terminal (output from dmeg):
> 
> [ 418.414325] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
> [ 418.428026] XFS (sda3): Mounting Filesystem
> [ 418.511943] XFS (sda3): Starting recovery (logdev: internal)
> [ 425.070536] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1557 of file /build/buildd/linux-3.8.0/fs/xfs/xfs_alloc.c. Caller 0xffffffffa06dae36
> [ 425.070536]
> [ 425.070552] Pid: 5671, comm: mount Tainted: GF 3.8.0-19-generic #29-Ubuntu
> [ 425.070556] Call Trace:
> [ 425.070605] [<ffffffffa06c311c>] xfs_error_report+0x3c/0x40 [xfs]
> [ 425.070646] [<ffffffffa06dae36>] ? xfs_free_extent+0xd6/0x120 [xfs]
> [ 425.070682] [<ffffffffa06d8556>] xfs_free_ag_extent+0x2d6/0x740 [xfs]
> [ 425.070717] [<ffffffffa06dae36>] xfs_free_extent+0xd6/0x120 [xfs]
> [ 425.070751] [<ffffffffa06d7137>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
> [ 425.070797] [<ffffffffa0709b50>] xlog_recover_process_efi+0x170/0x1b0 [xfs]
> [ 425.070830] [<ffffffffa06c904f>] ? xfs_iget+0x36f/0x690 [xfs]
> [ 425.070869] [<ffffffffa070b376>] xlog_recover_process_efis.isra.8+0x66/0xc0 [xfs]

That's a corrupted freespace btree. Your only option at this point
is to zero the log and hope that xfs_repair can clean everything
up without too much loss.

> Before attempting mounting with -L flag , do you want me to do
> other things to assist in tracking this bug down?

Damage has already been done, there's no way we can find the cause
from the state you have on disk at this point, unfortunately.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

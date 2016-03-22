Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B15317CB7
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 08:01:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 56D32304051
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 06:01:54 -0700 (PDT)
Received: from mail-ob0-f178.google.com (mail-ob0-f178.google.com
	[209.85.214.178]) by cuda.sgi.com with ESMTP id
	gYD9nc8CV7uI8BVr (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Mar 2016 06:01:51 -0700 (PDT)
Received: by mail-ob0-f178.google.com with SMTP id m7so199663561obh.3
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 06:01:51 -0700 (PDT)
From: Shyam Kaushik <shyam@zadarastorage.com>
References: <f049419a2ab10f8e3c4fef0e4f4ca1ba@mail.gmail.com>
	<20160322121922.GA53693@bfoster.bfoster>
In-Reply-To: <20160322121922.GA53693@bfoster.bfoster>
MIME-Version: 1.0
Date: Tue, 22 Mar 2016 18:31:48 +0530
Message-ID: <6457b1d9de271ec6cca6bc2626aac161@mail.gmail.com>
Subject: RE: XFS hung task in xfs_ail_push_all_sync() when unmounting FS after
	disk failure/recovery
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
To: Brian Foster <bfoster@redhat.com>
Cc: Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

Hi Brian,

Thanks for your quick reply. I repeated the test & trace-pipe is
constantly filled with this:

   xfsaild/dm-10-3335  [003] ...2 24890.546491: xfs_ilock_nowait: dev
253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 24890.546492: xfs_iunlock: dev 253:10
ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 24890.546493: xfs_ail_flushing: dev
253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
   xfsaild/dm-10-3335  [003] ...2 24890.596491: xfs_ilock_nowait: dev
253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 24890.596492: xfs_iunlock: dev 253:10
ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 24890.596494: xfs_ail_flushing: dev
253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
   xfsaild/dm-10-3335  [003] ...2 24890.646497: xfs_ilock_nowait: dev
253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 24890.646498: xfs_iunlock: dev 253:10
ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 24890.646500: xfs_ail_flushing: dev
253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
   xfsaild/dm-10-3335  [003] ...2 24890.696467: xfs_ilock_nowait: dev
253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 24890.696468: xfs_iunlock: dev 253:10
ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 24890.696468: xfs_ail_flushing: dev
253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
   xfsaild/dm-10-3335  [003] ...2 24890.746548: xfs_ilock_nowait: dev
253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 24890.746550: xfs_iunlock: dev 253:10
ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 24890.746550: xfs_ail_flushing: dev
253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
   xfsaild/dm-10-3335  [003] ...2 24890.796479: xfs_ilock_nowait: dev
253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 24890.796480: xfs_iunlock: dev 253:10
ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 24890.796480: xfs_ail_flushing: dev
253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
   xfsaild/dm-10-3335  [003] ...2 24890.846467: xfs_ilock_nowait: dev
253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 24890.846468: xfs_iunlock: dev 253:10
ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]


while regular activity seems to happen on other inodes/kworker threads

    kworker/u8:4-27691 [001] ...1 24895.811474: xfs_writepage: dev 253:10
ino 0x1801061 pgoff 0x29000 size 0x1aebbc offset 0 length 0 delalloc 1
unwritten 0
    kworker/u8:4-27691 [001] ...1 24895.811477: xfs_invalidatepage: dev
253:10 ino 0x1801061 pgoff 0x29000 size 0x1aebbc offset 0 length 1000
delalloc 1 unwritten 0
    kworker/u8:4-27691 [001] ...1 24895.811478: xfs_releasepage: dev
253:10 ino 0x1801061 pgoff 0x29000 size 0x1aebbc offset 0 length 0
delalloc 0 unwritten 0
    kworker/u8:4-27691 [001] ...1 24895.811482: xfs_writepage: dev 253:10
ino 0x4017bdf pgoff 0x29000 size 0x1aebbc offset 0 length 0 delalloc 1
unwritten 0
    kworker/u8:4-27691 [001] ...1 24895.811482: xfs_invalidatepage: dev
253:10 ino 0x4017bdf pgoff 0x29000 size 0x1aebbc offset 0 length 1000
delalloc 1 unwritten 0
    kworker/u8:4-27691 [001] ...1 24895.811483: xfs_releasepage: dev
253:10 ino 0x4017bdf pgoff 0x29000 size 0x1aebbc offset 0 length 0
delalloc 0 unwritten 0
    kworker/u8:4-27691 [001] ...1 24895.811485: xfs_writepage: dev 253:10
ino 0x68048c3 pgoff 0x29000 size 0x1aebbc offset 0 length 0 delalloc 1
unwritten 0
    kworker/u8:4-27691 [001] ...1 24895.811486: xfs_invalidatepage: dev
253:10 ino 0x68048c3 pgoff 0x29000 size 0x1aebbc offset 0 length 1000
delalloc 1 unwritten 0
    kworker/u8:4-27691 [001] ...1 24895.811486: xfs_releasepage: dev
253:10 ino 0x68048c3 pgoff 0x29000 size 0x1aebbc offset 0 length 0
delalloc 0 unwritten 0
    kworker/u8:4-27691 [001] ...1 24895.812381: xfs_writepage: dev 253:10
ino 0x1805e37 pgoff 0x29000 size 0x68470 offset 0 length 0 delalloc 1
unwritten 0
    kworker/u8:4-27691 [001] ...1 24895.812382: xfs_invalidatepage: dev
253:10 ino 0x1805e37 pgoff 0x29000 size 0x68470 offset 0 length 1000
delalloc 1 unwritten 0
    kworker/u8:4-27691 [001] ...1 24895.812382: xfs_releasepage: dev
253:10 ino 0x1805e37 pgoff 0x29000 size 0x68470 offset 0 length 0 delalloc
0 unwritten 0
    kworker/u8:4-27691 [001] ...1 24895.812385: xfs_writepage: dev 253:10
ino 0x4019c95 pgoff 0x29000 size 0x68470 offset 0 length 0 delalloc 1
unwritten 0
    kworker/u8:4-27691 [001] ...1 24895.812385: xfs_invalidatepage: dev
253:10 ino 0x4019c95 pgoff 0x29000 size 0x68470 offset 0 length 1000
delalloc 1 unwritten 0


looks like xfsaild is not able to take lock until hung-task timeout kicks
in

   xfsaild/dm-10-3335  [003] ...2 25247.649468: xfs_ilock_nowait: dev
253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 25247.649469: xfs_iunlock: dev 253:10
ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 25247.649469: xfs_ail_flushing: dev
253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
   xfsaild/dm-10-3335  [003] ...2 25247.699478: xfs_ilock_nowait: dev
253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 25247.699516: xfs_iunlock: dev 253:10
ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 25247.699517: xfs_ail_flushing: dev
253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
   xfsaild/dm-10-3335  [003] ...2 25247.749471: xfs_ilock_nowait: dev
253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 25247.749478: xfs_iunlock: dev 253:10
ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-10-3335  [003] ...2 25247.749479: xfs_ail_flushing: dev
253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL

Please let me know how to debug this further. Thanks.

--Shyam
-----Original Message-----
From: Brian Foster [mailto:bfoster@redhat.com]
Sent: 22 March 2016 17:49
To: Shyam Kaushik
Cc: xfs@oss.sgi.com; Alex Lyakas
Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
after disk failure/recovery

On Tue, Mar 22, 2016 at 04:51:39PM +0530, Shyam Kaushik wrote:
> Hi XFS developers,
>
> We are seeing the following issue with XFS on kernel 3.18.19.
>
> We have XFS mounted over a raw disk. Disk was pulled out manually. There
> were async writes on files that were errored like this
>
...
>
> And XFS hit metadata & Log IO errors that it decides to shutdown:
>
> Mar 16 16:03:22 host0 kernel: [ 4637.351841] XFS (dm-29): metadata I/O
> error: block 0x3a27fbd0 ("xlog_iodone") error 5 numblks 64
> Mar 16 16:03:22 host0 kernel: [ 4637.352820] XFS(dm-29): SHUTDOWN!!!
> old_flags=0x0 new_flags=0x2
> Mar 16 16:03:22 host0 kernel: [ 4637.353187] XFS (dm-29): Log I/O Error
> Detected.  Shutting down filesystem
...
> Later the drive was re-inserted back. After the drive was re-inserted,
XFS
> was attempted to be unmounted
>
> Mar 16 16:16:53 host0 controld: [2557] [     ] umount[202]
> : umount(/sdisk/vol5b0, xfs)
>
> But nothing happens except for the 30-secs xfs_log_force errors that
keeps
> repeating
>
...
>
> This problem doesn't happen consistently, but happens periodically with
a
> drive failure/recovery followed by XFS unmount. I couldn't find this
issue
> fixed in later kernels. Can you please suggest how I can debug this
issue
> further?
>

Similar problems have been reproduced due to racy/incorrect EFI/EFD
object tracking, which are internal data structures associated with
freeing extents.

What happens if you enable tracepoints while the fs is in this hung
unmount state?

# trace-cmd start -e "xfs:*"
# cat /sys/kernel/debug/tracing/trace_pipe

Brian

> Thanks!
>
> --Shyam
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

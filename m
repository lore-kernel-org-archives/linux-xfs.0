Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2D2B27CA0
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 07:30:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A09C4AC005
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 05:30:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 53xHbOsyVmy2F9NS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Mar 2016 05:30:14 -0700 (PDT)
Date: Wed, 23 Mar 2016 08:30:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
	after disk failure/recovery
Message-ID: <20160323123010.GA43073@bfoster.bfoster>
References: <f049419a2ab10f8e3c4fef0e4f4ca1ba@mail.gmail.com>
	<20160322121922.GA53693@bfoster.bfoster>
	<6457b1d9de271ec6cca6bc2626aac161@mail.gmail.com>
	<20160322140345.GA54245@bfoster.bfoster>
	<0f3832c45509f444f55fda2aaf9c9deb@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0f3832c45509f444f55fda2aaf9c9deb@mail.gmail.com>
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
To: Shyam Kaushik <shyam@zadarastorage.com>
Cc: Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

On Wed, Mar 23, 2016 at 03:13:57PM +0530, Shyam Kaushik wrote:
> Hi Brian,
> 
> Here are two inodes on which the xfsaild is looping over & over during
> unmount. This captures right from the cp that I started with copying some
> files to xfs while the drive was pulled out, later drive was pushed back &
> unmount was attempted. Does this give you better picture on the issue?
> Please let me know if you prefer to do some other steps in the reproducer.
> 
...
>     kworker/0:1H-257   [000] ...1  7477.849984: xfs_inode_unpin: dev
> 253:11 ino 0x103c84a count 1 pincount 1 caller xfs_trans_committed_bulk
> [xfs]

So it looks like the transaction is committed to the log. We don't
necessarily know whether the I/O completed or this was aborted, though I
suppose we can infer the former since the inode ends up on the AIL.
There's not much else that I can go on here, however. It looks like this
trace output is redacted and/or some events were lost. For example, I
don't see any xfs_ail_insert/move events at all, etc.

I'd suggest to use trace-record to collect and send (or post somewhere)
the full, raw trace dump. Something like 'trace-record -e xfs:* sleep
999' should dump everything to a file while you try and reproduce.

Alternatively, it sounds like Carlos is working towards a reproducer on
a recent kernel and might be closer to tracking this down. One random
thought/guess from skimming through the code: I wonder if there's some
kind of race going on between a failed metadata write retry and the fs
shutdown. It looks like we retry once in xfs_buf_iodone_callbacks(). If
the fs is shutdown, we invoke the callbacks which look like it should
ultimately release the flush lock (in xfs_iflush_done()), but I'm not
sure that happens if the shutdown occurs after a failed retry.

...
> It will be hard for me to shift to a newer kernel. But if you say we are
> left with no options to root cause this issue, I can attempt at this
> direction. Pls let me know. Thanks.
> 

I ask mainly for informational and debugging purposes. If the problem
doesn't occur on a recent kernel, we might have a fix that could be
identified via a bisect. If it does, then it's still preferable to debug
on something more recent. As mentioned above, it sounds like Carlos has
been working on tracking this down on recent kernels already.

Brian

> --Shyam
> -----Original Message-----
> From: Brian Foster [mailto:bfoster@redhat.com]
> Sent: 22 March 2016 19:34
> To: Shyam Kaushik
> Cc: Alex Lyakas; xfs@oss.sgi.com
> Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
> after disk failure/recovery
> 
> On Tue, Mar 22, 2016 at 06:31:48PM +0530, Shyam Kaushik wrote:
> > Hi Brian,
> >
> > Thanks for your quick reply. I repeated the test & trace-pipe is
> > constantly filled with this:
> >
> >    xfsaild/dm-10-3335  [003] ...2 24890.546491: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.546492: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.546493: xfs_ail_flushing: dev
> > 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
> >    xfsaild/dm-10-3335  [003] ...2 24890.596491: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.596492: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.596494: xfs_ail_flushing: dev
> > 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
> >    xfsaild/dm-10-3335  [003] ...2 24890.646497: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.646498: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.646500: xfs_ail_flushing: dev
> > 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
> >    xfsaild/dm-10-3335  [003] ...2 24890.696467: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.696468: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.696468: xfs_ail_flushing: dev
> > 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
> >    xfsaild/dm-10-3335  [003] ...2 24890.746548: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.746550: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.746550: xfs_ail_flushing: dev
> > 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
> >    xfsaild/dm-10-3335  [003] ...2 24890.796479: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.796480: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.796480: xfs_ail_flushing: dev
> > 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
> >    xfsaild/dm-10-3335  [003] ...2 24890.846467: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.846468: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >
> 
> So xfsaild is spinning on this inode. It was presumably modified, logged
> and flushed to the log, hence it's sitting in the AIL waiting to be
> flushed to disk. xfsaild wants to push it to get it flushed to disk and
> off the AIL, but it sees it is already in the flushing state as the
> flush lock is held.
> 
> It's not clear to me why the inode is not removed from the AIL, or
> whether that I/O was actually submitted or aborted with an error. The
> shutdown involved here most likely affects this one way or the other.
> IIUC, the I/O completion should eventually release the flush lock and
> remove the inode from the AIL. A complete trace log of the entire
> reproducer might shed more light as to what's going on.
> 
> Also, it sounds like you have a reliable reproducer. Does this reproduce
> on a recent kernel?
> 
> Brian
> 
> >
> > while regular activity seems to happen on other inodes/kworker threads
> >
> >     kworker/u8:4-27691 [001] ...1 24895.811474: xfs_writepage: dev
> 253:10
> > ino 0x1801061 pgoff 0x29000 size 0x1aebbc offset 0 length 0 delalloc 1
> > unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.811477: xfs_invalidatepage: dev
> > 253:10 ino 0x1801061 pgoff 0x29000 size 0x1aebbc offset 0 length 1000
> > delalloc 1 unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.811478: xfs_releasepage: dev
> > 253:10 ino 0x1801061 pgoff 0x29000 size 0x1aebbc offset 0 length 0
> > delalloc 0 unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.811482: xfs_writepage: dev
> 253:10
> > ino 0x4017bdf pgoff 0x29000 size 0x1aebbc offset 0 length 0 delalloc 1
> > unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.811482: xfs_invalidatepage: dev
> > 253:10 ino 0x4017bdf pgoff 0x29000 size 0x1aebbc offset 0 length 1000
> > delalloc 1 unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.811483: xfs_releasepage: dev
> > 253:10 ino 0x4017bdf pgoff 0x29000 size 0x1aebbc offset 0 length 0
> > delalloc 0 unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.811485: xfs_writepage: dev
> 253:10
> > ino 0x68048c3 pgoff 0x29000 size 0x1aebbc offset 0 length 0 delalloc 1
> > unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.811486: xfs_invalidatepage: dev
> > 253:10 ino 0x68048c3 pgoff 0x29000 size 0x1aebbc offset 0 length 1000
> > delalloc 1 unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.811486: xfs_releasepage: dev
> > 253:10 ino 0x68048c3 pgoff 0x29000 size 0x1aebbc offset 0 length 0
> > delalloc 0 unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.812381: xfs_writepage: dev
> 253:10
> > ino 0x1805e37 pgoff 0x29000 size 0x68470 offset 0 length 0 delalloc 1
> > unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.812382: xfs_invalidatepage: dev
> > 253:10 ino 0x1805e37 pgoff 0x29000 size 0x68470 offset 0 length 1000
> > delalloc 1 unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.812382: xfs_releasepage: dev
> > 253:10 ino 0x1805e37 pgoff 0x29000 size 0x68470 offset 0 length 0
> delalloc
> > 0 unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.812385: xfs_writepage: dev
> 253:10
> > ino 0x4019c95 pgoff 0x29000 size 0x68470 offset 0 length 0 delalloc 1
> > unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.812385: xfs_invalidatepage: dev
> > 253:10 ino 0x4019c95 pgoff 0x29000 size 0x68470 offset 0 length 1000
> > delalloc 1 unwritten 0
> >
> >
> > looks like xfsaild is not able to take lock until hung-task timeout
> kicks
> > in
> >
> >    xfsaild/dm-10-3335  [003] ...2 25247.649468: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 25247.649469: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 25247.649469: xfs_ail_flushing: dev
> > 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
> >    xfsaild/dm-10-3335  [003] ...2 25247.699478: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 25247.699516: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 25247.699517: xfs_ail_flushing: dev
> > 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
> >    xfsaild/dm-10-3335  [003] ...2 25247.749471: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 25247.749478: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 25247.749479: xfs_ail_flushing: dev
> > 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
> >
> > Please let me know how to debug this further. Thanks.
> >
> > --Shyam
> > -----Original Message-----
> > From: Brian Foster [mailto:bfoster@redhat.com]
> > Sent: 22 March 2016 17:49
> > To: Shyam Kaushik
> > Cc: xfs@oss.sgi.com; Alex Lyakas
> > Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
> > after disk failure/recovery
> >
> > On Tue, Mar 22, 2016 at 04:51:39PM +0530, Shyam Kaushik wrote:
> > > Hi XFS developers,
> > >
> > > We are seeing the following issue with XFS on kernel 3.18.19.
> > >
> > > We have XFS mounted over a raw disk. Disk was pulled out manually.
> There
> > > were async writes on files that were errored like this
> > >
> > ...
> > >
> > > And XFS hit metadata & Log IO errors that it decides to shutdown:
> > >
> > > Mar 16 16:03:22 host0 kernel: [ 4637.351841] XFS (dm-29): metadata I/O
> > > error: block 0x3a27fbd0 ("xlog_iodone") error 5 numblks 64
> > > Mar 16 16:03:22 host0 kernel: [ 4637.352820] XFS(dm-29): SHUTDOWN!!!
> > > old_flags=0x0 new_flags=0x2
> > > Mar 16 16:03:22 host0 kernel: [ 4637.353187] XFS (dm-29): Log I/O
> Error
> > > Detected.  Shutting down filesystem
> > ...
> > > Later the drive was re-inserted back. After the drive was re-inserted,
> > XFS
> > > was attempted to be unmounted
> > >
> > > Mar 16 16:16:53 host0 controld: [2557] [     ] umount[202]
> > > : umount(/sdisk/vol5b0, xfs)
> > >
> > > But nothing happens except for the 30-secs xfs_log_force errors that
> > keeps
> > > repeating
> > >
> > ...
> > >
> > > This problem doesn't happen consistently, but happens periodically
> with
> > a
> > > drive failure/recovery followed by XFS unmount. I couldn't find this
> > issue
> > > fixed in later kernels. Can you please suggest how I can debug this
> > issue
> > > further?
> > >
> >
> > Similar problems have been reproduced due to racy/incorrect EFI/EFD
> > object tracking, which are internal data structures associated with
> > freeing extents.
> >
> > What happens if you enable tracepoints while the fs is in this hung
> > unmount state?
> >
> > # trace-cmd start -e "xfs:*"
> > # cat /sys/kernel/debug/tracing/trace_pipe
> >
> > Brian
> >
> > > Thanks!
> > >
> > > --Shyam
> > >
> > > _______________________________________________
> > > xfs mailing list
> > > xfs@oss.sgi.com
> > > http://oss.sgi.com/mailman/listinfo/xfs
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

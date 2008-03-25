Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 19:02:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2P228Qw009915
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 19:02:11 -0700
Date: Tue, 25 Mar 2008 13:02:23 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: BUG: xfs on linux lvm - lvconvert random hungs when doing i/o
Message-ID: <20080325020223.GB108924158@sgi.com>
References: <200803211520.16398.stf_xl@wp.pl> <20080324233952.GF103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080324233952.GF103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>, xfs@oss.sgi.com

On Tue, Mar 25, 2008 at 10:39:52AM +1100, David Chinner wrote:
> On Fri, Mar 21, 2008 at 03:20:16PM +0100, Stanislaw Gruszka wrote:
> > Hello
> > 
> > I have problems using xfs and lvm snapshots on linux-2.6.24 , When I do
> > lvconvert  to create snapshots and when system is under heavy load, lvconvert
> > and I/O processes randomly hung .  I use below script to reproduce, but it is very hard
> > to catch this bug.
> 
> This looks like an I/O completion problem.
> 
> You're writing 2 files and doing snap shots while they are running.
> 
> > xfsdatad/1    D 00000000     0   288      2
> > Call Trace:
> >  [<c05558e6>] rwsem_down_failed_common+0x76/0x170
> >  [<c0555a2d>] rwsem_down_write_failed+0x1d/0x24
> >  [<c0555aa2>] call_rwsem_down_write_failed+0x6/0x8
> >  [<c05555d2>] down_write+0x12/0x20
> >  [<c029906a>] xfs_ilock+0x5a/0xa0
> >  [<c02c0093>] xfs_setfilesize+0x43/0x130
> >  [<c02c0180>] xfs_end_bio_delalloc+0x0/0x20
> >  [<c02c018d>] xfs_end_bio_delalloc+0xd/0x20
> >  [<c01334d2>] run_workqueue+0x52/0x100
> >  [<c01373a2>] prepare_to_wait+0x52/0x70
> >  [<c01335ff>] worker_thread+0x7f/0xc0
> 
> This is an xfs I/O completion workqueue, waiting to get the inode
> ilock in excusive mode to update the file size.

......

> This dd (I've trimmed the stack trace to make it readable):
> 
> > dd            D c4018ab4     0 12113  29734
> > Call Trace:
> >  [<c0555b35>] __down+0x75/0xe0
> >  [<c04793c7>] dm_unplug_all+0x17/0x30
> >  [<c0555a3b>] __down_failed+0x7/0xc
> >  [<c02e1ac0>] blk_backing_dev_unplug+0x0/0x10
> >  [<c02c2e4c>] xfs_buf_lock+0x3c/0x50
> >  [<c02c27d1>] _xfs_buf_find+0x151/0x1d0
> >  [<c02c28a5>] xfs_buf_get_flags+0x55/0x130
> >  [<c02c299c>] xfs_buf_read_flags+0x1c/0x90
> >  [<c02b48cf>] xfs_trans_read_buf+0x16f/0x350
> >  [<c02995fd>] xfs_itobp+0x7d/0x250
> >  [<c029cfc9>] xfs_iflush+0x99/0x470
> >  [<c02bd907>] xfs_inode_flush+0x127/0x1f0
> >  [<c02c9732>] xfs_fs_write_inode+0x22/0x80
> >  [<c01963fb>] write_inode+0x4b/0x50
> >  [<c01966d0>] __sync_single_inode+0xf0/0x190
> >  [<c01967b9>] __writeback_single_inode+0x49/0x1c0
> >  [<c0196a0e>] sync_sb_inodes+0xde/0x1d0
> >  [<c0196ba0>] writeback_inodes+0xa0/0xb0
> >  [<c015d043>] balance_dirty_pages+0x193/0x2c0
> >  [<c0158ad2>] generic_perform_write+0x142/0x190
> >  [<c0158ba7>] generic_file_buffered_write+0x87/0x150
> >  [<c02c8d0b>] xfs_write+0x61b/0x8c0
> >  [<c02c45f6>] xfs_file_aio_write+0x76/0x90
> >  [<c0178e9d>] do_sync_write+0xbd/0x110
> >  [<c0179050>] vfs_write+0x160/0x170
> >  [<c0179111>] sys_write+0x41/0x70
> >  [<c010418e>] syscall_call+0x7/0xb
> 
> Is writing to one file, hitting foreground write throttling and
> flushing either itself or the other file. It's stuct waiting on 
> I/O completion of the inode buffer.
> 
> I suspect that the I/O completion has been blocked by the fact it's
> trying to get The xfsdatad process is blocked on this inode - the
> inode flush takes the ilock shared, which is holding off the I/O
> completion. As soon as the inode buffer I/O is issued, then inode
> will be unlocked and completion processing can continue.
> 
> i.e. it seems that either we can't safely take the ilock in I/O
> completion without a trylock or we can't hold the ilock across
> I/O submission without a trylock on the buffer lock. Ouch! That's
> going to take some fixing....

No, that's not true - the data I/O is queued to the xfsdatad, whilst
metadata gets queued to the xfslogd completion queue. Hence data I/O
completion can't hold up metadata I/O completion and we can't deadlock
here....

That points to I/O not completing (not an XFS problem at all), or
the filesystem freeze is just taking a long time to run (as it has
to sync everything to disk). Given that this is a snapshot target,
writing new blocks will take quite some time. Is the system still
making writeback  progress when in this state, or is it really hung?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

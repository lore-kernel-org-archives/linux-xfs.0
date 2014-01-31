Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9EEE37F63
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 14:38:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8756730408B
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 12:38:30 -0800 (PST)
Received: from mail-qc0-f180.google.com (mail-qc0-f180.google.com
	[209.85.216.180]) by cuda.sgi.com with ESMTP id
	urHgo5s040RFD5cY (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 31 Jan 2014 12:38:26 -0800 (PST)
Received: by mail-qc0-f180.google.com with SMTP id i17so7813352qcy.39
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 12:38:25 -0800 (PST)
Date: Fri, 31 Jan 2014 15:38:21 -0500
From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH v2] xfstests: avoid ext4/306 failures caused by
	incompatible mount options
Message-ID: <20140131203821.GC2385@wallace>
References: <20140131155332.GB2385@wallace>
 <52EBF870.1000603@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52EBF870.1000603@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Eric Whitney <enwlinux@gmail.com>

* Eric Sandeen <sandeen@sandeen.net>:
> On 1/31/14, 9:53 AM, Eric Whitney wrote:
> > ext4/306 will fail when mounting the ext3 file system it creates if an
> > ext3-incompatible mount option is applied by _scratch_mount.  This can
> > happen if EXT_MOUNT_OPTIONS is defined appropriately in the test
> > environment.  For example, the block_validity option is commonly used
> > to enhance ext4 testing, and it is not supported by ext3.
> > 
> > Fix this by instead creating an ext4 file system without extents as a
> > functionally equivalent substitute.  This will also eliminate a
> > dependency for ext3 support on the test system.
> 
> this seems like it should be fine, but a quick check[1] makes me think
> that it's passing when it should not.  My flexible test boxes are tied up
> right now; the fix hit v3.10 (dunno about stable) so we should make sure
> this fails on v3.9 before & after your, I guess.
> 
> I can try to get to it, or if you do first, let me now :)
> 

It's good thing I archive all my ext4 testing kernels.  :-)

On 3.9, I find that the current version of ext4/306 and my patched version
yield the same failure - each test hangs uninterruptably in the umount.  Is
that what you were expecting?  Stack backtraces for the patched version
follow, and closely resemble those seen for the current version.

Thanks,
Eric

SysRq : Show Blocked State
  task                        PC stack   pid father
flush-253:32    D ffff88002b109a28     0  4992      2 0x00000000
 ffff88002b1099d8 0000000000000046 ffff880036433f60 ffff88002b109fd8
 ffff88002b109fd8 ffff88002b109fd8 ffff88003b490000 ffff880036433f60
 ffff88002b1099e8 ffff88002b109c60 ffff88002b109b10 0007ffffffffffff
Call Trace:
 [<ffffffff81246950>] ? write_cache_pages_da+0x3b0/0x520
 [<ffffffff816ffc09>] ? schedule+0x29/0x70
 [<ffffffff8129dda5>] ? jbd2_log_wait_commit+0xb5/0x130
 [<ffffffff81080ec0>] ? __init_waitqueue_head+0x60/0x60
 [<ffffffff812a10ea>] ? jbd2_journal_force_commit_nested+0x6a/0xd0
 [<ffffffff81246f2c>] ? ext4_da_writepages+0x46c/0x5e0
 [<ffffffff8114a2c1>] ? do_writepages+0x21/0x50
 [<ffffffff811c79a0>] ? __writeback_single_inode+0x40/0x220
 [<ffffffff81373a6d>] ? do_raw_spin_unlock+0x5d/0xb0
 [<ffffffff811c8e21>] ? writeback_sb_inodes+0x281/0x420
 [<ffffffff811c9180>] ? wb_writeback+0xf0/0x2c0
 [<ffffffff811ca6ea>] ? wb_do_writeback+0xba/0x210
 [<ffffffff810bed8d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8106b6ac>] ? del_timer+0x5c/0x70
 [<ffffffff811ca8d3>] ? bdi_writeback_thread+0x93/0x230
 [<ffffffff811ca840>] ? wb_do_writeback+0x210/0x210
 [<ffffffff8108083a>] ? kthread+0xea/0xf0
 [<ffffffff81080750>] ? kthread_create_on_node+0x160/0x160
 [<ffffffff8170a06c>] ? ret_from_fork+0x7c/0xb0
 [<ffffffff81080750>] ? kthread_create_on_node+0x160/0x160
jbd2/vdc-8      D ffff88003ce59bd0     0  5251      2 0x00000000
 ffff88003ce59b28 0000000000000046 ffff88003b490000 ffff88003ce59fd8
 ffff88003ce59fd8 ffff88003ce59fd8 ffffffff81c13440 ffffffff810b9aed
 ffff88003ce59b28 ffffffff817012c7 ffff880036433f60 ffff8800364345a0
Call Trace:
 [<ffffffff81373a6d>] ? do_raw_spin_unlock+0x5d/0xb0
 [<ffffffff810b9aed>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff817012c7>] ? _raw_spin_unlock_irqrestore+0x67/0x80
 [<ffffffff813395b9>] ? submit_bio+0x79/0x160
 [<ffffffff810921bf>] ? try_to_wake_up+0x1ff/0x350
 [<ffffffff811034a4>] ? __delayacct_blkio_end+0x34/0x60
 [<ffffffff816ffcdf>] ? io_schedule+0x8f/0xd0
 [<ffffffff811d00fe>] ? sleep_on_buffer+0xe/0x20
 [<ffffffff816fcfb0>] ? __wait_on_bit+0x60/0x90
 [<ffffffff810986fe>] ? dequeue_entity+0x13e/0x4b0
 [<ffffffff8170129f>] ? _raw_spin_unlock_irqrestore+0x3f/0x80
 [<ffffffff810bed8d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff816ffc09>] schedule+0x29/0x70
 [<ffffffff8129f068>] ? kjournald2+0xc8/0x260
 [<ffffffff81080ec0>] ? __init_waitqueue_head+0x60/0x60
 [<ffffffff8129efa0>] ? journal_init_common+0x1d0/0x1d0
 [<ffffffff8108083a>] ? kthread+0xea/0xf0
 [<ffffffff81080750>] ? kthread_create_on_node+0x160/0x160
 [<ffffffff8170a06c>] ? ret_from_fork+0x7c/0xb0
 [<ffffffff81080750>] ? kthread_create_on_node+0x160/0x160
umount          D 000000000000353a     0  5271   5053 0x00000000
 ffff88003ced3b88 0000000000000046 ffff88003a953f60 ffff88003ced3fd8
 ffff88003ced3fd8 ffff88003ced3fd8 ffffffff81c13440 ffff88003a953f60
 0000000000000002 ffff88003ced3d10 ffff88003ced3d18 7fffffffffffffff
Call Trace:
 [<ffffffff816ffc09>] schedule+0x29/0x70
 [<ffffffff816fccdc>] schedule_timeout+0x18c/0x250
 [<ffffffff810beb7b>] ? mark_held_locks+0x9b/0x100
 [<ffffffff81701250>] ? _raw_spin_unlock_irq+0x30/0x40
 [<ffffffff810beced>] ? trace_hardirqs_on_caller+0x10d/0x1a0
 [<ffffffff816ff27f>] wait_for_completion+0x9f/0x110
 [<ffffffff81092310>] ? try_to_wake_up+0x350/0x350
 [<ffffffff811c81d4>] writeback_inodes_sb_nr+0x134/0x180
 [<ffffffff811c824e>] writeback_inodes_sb+0x2e/0x40
 [<ffffffff811ce51d>] sync_filesystem+0x3d/0xb0
 [<ffffffff8119f14b>] generic_shutdown_super+0x3b/0xf0
 [<ffffffff8119f230>] kill_block_super+0x30/0x80
 [<ffffffff8119f757>] deactivate_locked_super+0x57/0x80
 [<ffffffff811a039e>] deactivate_super+0x4e/0x70
 [<ffffffff811bc801>] mntput_no_expire+0x101/0x160
 [<ffffffff811bd73c>] sys_umount+0x9c/0x3c0
 [<ffffffff8170a119>] system_call_fastpath+0x16/0x1b





> -Eric
> 
> [1] on an old RHEL5 box so that's a bit of a strange beast
> 
> > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> > ---
> >  tests/ext4/306 | 21 +++++++--------------
> >  1 file changed, 7 insertions(+), 14 deletions(-)
> > 
> > diff --git a/tests/ext4/306 b/tests/ext4/306
> > index 398c4c0..9559cf2 100755
> > --- a/tests/ext4/306
> > +++ b/tests/ext4/306
> > @@ -45,29 +45,22 @@ _supported_os Linux
> >  
> >  _require_scratch
> >  
> > -# This needs to mount ext3; might require ext3 driver, or ext4
> > -# might handle it itself.  Find out if we have it one way or another.
> > -modprobe ext3 > /dev/null 2>&1
> > -grep -q ext3 /proc/filesystems || _notrun "This test requires ext3 support"
> > -
> >  rm -f $seqres.full
> >  
> > -# Make a small ext3 fs, (extents disabled) & mount it
> > -yes | mkfs.ext3 $SCRATCH_DEV 512m >> $seqres.full 2>&1
> > -_scratch_mount -t ext3 || _fail "couldn't mount fs as ext3"
> > +# Make a small ext4 fs with extents disabled & mount it
> > +yes | mkfs.ext4 -O ^extents $SCRATCH_DEV 512m >> $seqres.full 2>&1
> > +_scratch_mount || _fail "couldn't mount fs"
> > +
> >  # Create a small non-extent-based file
> >  echo "Create 1m testfile1"
> >  $XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c "pwrite 0 1m" | _filter_xfs_io
> > +
> > +# Create a large non-extent-based file filling the fs; this will run out & fail
> >  echo "Create testfile2 to fill the fs"
> > -# A large non-extent-based file filling the fs; this will run out & fail
> >  $XFS_IO_PROG -f $SCRATCH_MNT/testfile2 -c "pwrite 0 512m" | _filter_xfs_io
> > -
> > -# Remount as ext4
> > -_scratch_unmount
> > -_scratch_mount -t ext4 || _fail "couldn't remount fs as ext4"
> >  df -h $SCRATCH_MNT >> $seqres.full
> >  
> > -# Grow it by 512m
> > +# Grow fs by 512m
> >  echo "Resize to 1g"
> >  resize2fs $SCRATCH_DEV 1g >> $seqres.full 2>&1 || _fail "Could not resize to 1g"
> >  df -h $SCRATCH_MNT >> $seqres.full
> > 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

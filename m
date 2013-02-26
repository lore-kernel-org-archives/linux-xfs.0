Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 161D17F81
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 22:40:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 06F84304039
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 20:40:44 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	dLKMV89PlNCJEemi for <xfs@oss.sgi.com>;
	Mon, 25 Feb 2013 20:40:42 -0800 (PST)
Date: Tue, 26 Feb 2013 15:40:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [BUG] pvmove corrupting XFS filesystems (was Re: [BUG] Internal
	error xfs_dir2_data_reada_verify)
Message-ID: <20130226044039.GM5551@dastard>
References: <87d2vnc34r.fsf@fftw.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87d2vnc34r.fsf@fftw.org>
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
To: Matteo Frigo <athena@fftw.org>
Cc: dm-devel@redhat.com, xfs@oss.sgi.com

[cc'd dm-devel]

On Mon, Feb 25, 2013 at 07:47:32PM -0500, Matteo Frigo wrote:
> For some reason XFS reliably crashes for me when used in conjunction
> with LVM2's pvmove.  The error reliably appears when removing a large
> number of files from a volume that is being pvmove'd at the same time.
> I am using vanilla kernel 3.8.  A typical kernel message looks like the
> following:
> 
>    [  262.396471] ffff88001ecfb000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    [  262.398314] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
>    [  262.398314] 
>    [  262.398740] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
>    [  262.398742] Call Trace:
>    [  262.398767]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
>    [  262.398777]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
>    [  262.398792]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
>    [  262.398801]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
>    [  262.398809]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
>    [  262.398814]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
>    [  262.398831]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
>    [  262.398834]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
>    [  262.398837]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
>    [  262.398840]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
>    [  262.398842]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
>    [  262.398846]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
>    [  262.398848]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
>    [  262.398850] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
>    [  262.399089] XFS (dm-1): metadata I/O error: block 0x805060 ("xfs_trans_read_buf_map") error 117 numblks 8

That's clearly a 3.8 kernel you are seeing this on. The readahead
has returned zeros rather than data which implies that the readahead
has been cancelled. I can see a potential bug in the 3.8 code where
the above verifier is called even on an IO error. Hence a readahead
will trigger a corruption error like above, even though a failed
readahead is supposed to be silent.

A failed readahead is then supposed to be retried by a blocking read
when the metadata is actually read, and this means that failed
readahead can be ignored.

> I have observed the problem with vanilla kernels 3.8 and 3.4.33, and
> with CentOS 6.3 using the CentOS variant of 2.6.32.  I have observed the
> problem on various virtual machines using debian wheezy/sid and Fedora
> 18, and on at least three physical machines.  Even though the kernel
> reports "Corruption detected", xfs_repair appears to be able to fix any
> problems, so I haven't actually lost any data.  The problem goes away
> after stopping pvmove.

Which implies two things: 1) that the corruption is not limited to
readahead; and 2) the bug is a result of whatever DM is doing during
a pvmove operation.

> HOW TO REPRODUCE: I created a virtual machine with debian sid and two
> virtual disks /dev/vdb and /dev/vdc.  Then, the following script
> reliably triggers the failure.  
> 
>     pvcreate /dev/vd[bc]
>     vgcreate test /dev/vd[bc]
>     lvcreate -L 8G -n vol test /dev/vdb
>     mkfs.xfs -f /dev/mapper/test-vol
>     mount -o noatime /dev/mapper/test-vol /mnt
>     cd /mnt
>     git clone ~/linux-stable
>     cd /
>     umount /mnt
> 
>     mount -o noatime /dev/mapper/test-vol /mnt
>     pvmove -b /dev/vdb /dev/vdc
>     sleep 2
>     rm -rf /mnt/linux-stable

Yup, I can reproduce it here on a 3.8 kernel. Note that it's not
just returning buffers with zeros in them, it's returning buffers
with stale data in them:

ffff88011cfd4000: 31 5f 53 50 41 52 45 5f 4d 41 53 4b 29 20 3e 3e 1_SPARE_MASK) >>
[98756.147971] XFS (dm-0): Internal error xfs_dir3_data_reada_verify at line 240 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffff81457dbf

> I have observed the problem even without unmounting and re-mounting the
> file system, but it appears that the umount/mount sequence makes the
> problem 100% reproducible.

Yup, because it's got to read the metadata from disk to do the rm,
and hence triggers lots of directory block readahead to occur.

> I am not implying that this is an xfs bug---it may well be a dm bug for
> all I know.  However, the same test completes correctly using ext4
> instead of xfs, suggesting that dm is working in at least some cases.

ext4 doesn't use readahead in the same way that XFS does. XFS has a
long history of discovering readahead handling bugs in DM...

So, I added a check to ensure we don't run the verifier on buffers
that have had an IO error returned (i.e. we preserve the error and
IO completion checking until a read buffer read occurs):

--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1022,7 +1022,9 @@ xfs_buf_iodone_work(
 	bool                    read = !!(bp->b_flags & XBF_READ);
 
 	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
-	if (read && bp->b_ops)
+
+	/* validate buffers that were read without errors */
+	if (read && bp->b_ops && !bp->b_error && (bp->b_flags & XBF_DONE))
 		bp->b_ops->verify_read(bp);
 
 	if (bp->b_iodone)


and so errors on buffers are passed all the way through. This
occurred:

[  112.067262] XFS (dm-0): metadata I/O error: block 0x180068 ("xfs_trans_read_buf_map") error 11 numblks 8
[  112.069331] XFS (dm-0): metadata I/O error: block 0x180068 ("xfs_trans_read_buf_map") error 11 numblks 8
[  112.073369] XFS (dm-0): metadata I/O error: block 0x4800a8 ("xfs_trans_read_buf_map") error 11 numblks 8
[  112.077853] XFS (dm-0): metadata I/O error: block 0x4800a8 ("xfs_trans_read_buf_map") error 11 numblks 8
[  112.108900] XFS (dm-0): metadata I/O error: block 0x180d10 ("xfs_trans_read_buf_map") error 11 numblks 8
[  112.112003] XFS (dm-0): metadata I/O error: block 0x180d10 ("xfs_trans_read_buf_map") error 11 numblks 8
[  112.116444] XFS (dm-0): metadata I/O error: block 0x480d20 ("xfs_trans_read_buf_map") error 11 numblks 8
[  112.119678] XFS (dm-0): metadata I/O error: block 0x480d20 ("xfs_trans_read_buf_map") error 11 numblks 8
[  112.125633] XFS (dm-0): metadata I/O error: block 0x1816b8 ("xfs_trans_read_buf_map") error 11 numblks 8
[  112.129345] XFS (dm-0): metadata I/O error: block 0x1816b8 ("xfs_trans_read_buf_map") error 11 numblks 8

Error 11 is EAGAIN, which means that the IO is being completed with
an error of EAGAIN on it. This is not an XFS bug - EAGAIN is not a
recognised IO stack error on any filesystem and so whatever is
returning it is broken. There are also definitely other problems in
the lower layers of the storage stack when pvmove is executed, as
this happened next:

[  112.130211] BUG: unable to handle kernel NULL pointer dereference at 000000000000007c
[  112.130232] IP: [<ffffffff8175aa67>] do_raw_spin_lock+0x17/0x110
[  112.130235] PGD 21cb16067 PUD 21c65d067 PMD 0 
[  112.130238] Oops: 0000 [#1] SMP 
[  112.130244] Modules linked in:
[  112.130249] CPU 5 
[  112.130249] Pid: 0, comm: swapper/5 Not tainted 3.8.0-dgc+ #433 Bochs Bochs
[  112.130254] RIP: 0010:[<ffffffff8175aa67>]  [<ffffffff8175aa67>] do_raw_spin_lock+0x17/0x110
[  112.130259] RSP: 0018:ffff88011dd03c18  EFLAGS: 00010086
[  112.130260] RAX: 0000000000000092 RBX: 0000000000000078 RCX: ffff88011cdcc680
[  112.130261] RDX: ffff88007dbc5fd8 RSI: ffff88007bd6fcb8 RDI: 0000000000000078
[  112.130262] RBP: ffff88011dd03c48 R08: 0000000000000000 R09: 0000000000000000
[  112.130264] R10: 0000000000000000 R11: 0000000000000001 R12: 00000000000000a0
[  112.130265] R13: 0000000000000078 R14: 0000000000010000 R15: 0000000000010000
[  112.130267] FS:  0000000000000000(0000) GS:ffff88011dd00000(0000) knlGS:0000000000000000
[  112.130268] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  112.130269] CR2: 000000000000007c CR3: 000000021c3f9000 CR4: 00000000000006e0
[  112.130276] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  112.130282] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  112.130284] Process swapper/5 (pid: 0, threadinfo ffff88007dbc4000, task ffff88007dbc23c0)
[  112.130284] Stack:
[  112.130287]  ffff88011dd03c78 0000000000000086 ffff88011dd03c88 0000000000000092
[  112.130289]  00000000000000a0 0000000000000078 ffff88011dd03c68 ffffffff81bd7cf4
[  112.130291]  ffff88007c58a200 ffff88007bd6fcb8 ffff88011dd03c98 ffffffff81a65d2e
[  112.130292] Call Trace:
[  112.130295]  <IRQ> 
[  112.130300]  [<ffffffff81bd7cf4>] _raw_spin_lock_irqsave+0x34/0x40
[  112.130316]  [<ffffffff81a65d2e>] push+0x2e/0x60
[  112.130319]  [<ffffffff81a65e10>] ? run_pages_job+0xb0/0xb0
[  112.130322]  [<ffffffff81a65e7a>] complete_io+0x6a/0xa0
[  112.130325]  [<ffffffff81a64f33>] dec_count.part.5+0x63/0x80
[  112.130328]  [<ffffffff81a64fa5>] endio+0x55/0xa0
[  112.130340]  [<ffffffff811b8b9d>] bio_endio+0x1d/0x30
[  112.130348]  [<ffffffff8172957b>] req_bio_endio.isra.63+0x8b/0xd0
[  112.130351]  [<ffffffff817296c8>] blk_update_request+0x108/0x4d0
[  112.130354]  [<ffffffff81bd7c3e>] ? _raw_spin_unlock+0xe/0x20
[  112.130356]  [<ffffffff81729ab7>] blk_update_bidi_request+0x27/0xa0
[  112.130360]  [<ffffffff8172cae0>] __blk_end_bidi_request+0x20/0x50
[  112.130362]  [<ffffffff8172cb2f>] __blk_end_request_all+0x1f/0x30
[  112.130373]  [<ffffffff8194beb0>] virtblk_done+0x100/0x240
[  112.130385]  [<ffffffff817d4f45>] vring_interrupt+0x35/0x60
[  112.130395]  [<ffffffff810fb01c>] handle_irq_event_percpu+0x6c/0x230
[  112.130398]  [<ffffffff810fb228>] handle_irq_event+0x48/0x70
[  112.130404]  [<ffffffff810fd987>] handle_edge_irq+0x77/0x110
[  112.130408]  [<ffffffff81049192>] handle_irq+0x22/0x40
[  112.130412]  [<ffffffff81be1c9a>] do_IRQ+0x5a/0xe0
[  112.130414]  [<ffffffff81bd80ed>] common_interrupt+0x6d/0x6d
[  112.130416]  <EOI> 
[  112.130420]  [<ffffffff81074146>] ? native_safe_halt+0x6/0x10
[  112.130424]  [<ffffffff8104f82f>] default_idle+0x4f/0x220
[  112.130427]  [<ffffffff81050646>] cpu_idle+0xb6/0xf0
[  112.130442]  [<ffffffff81bc565e>] start_secondary+0x1aa/0x1ae
[  112.130466] Code: 10 89 47 08 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec 30 48 89 5d e8 48 89 fb 4c 89 65 f0 4c 89 6d f8 <81> 7f 04 ad 4e  
[  112.130469] RIP  [<ffffffff8175aa67>] do_raw_spin_lock+0x17/0x110
[  112.130470]  RSP <ffff88011dd03c18>
[  112.130471] CR2: 000000000000007c
[  112.130474] ---[ end trace e4b9ec49f84b99c2 ]---
[  112.130476] Kernel panic - not syncing: Fatal exception in interrupt

Which indicates that IO completion through kcopyd died.

And finally, this corruption occurred on the third run:

[   68.309233] XFS (dm-0): Corruption detected. Unmount and run xfs_repair
[   68.310281] XFS (dm-0): bad inode magic/vsn daddr 1578640 #0 (magic=5844)
[   68.312136] XFS: Assertion failed: 0, file: fs/xfs/xfs_inode.c, line: 417
[   68.313906] ------------[ cut here ]------------
[   68.314822] kernel BUG at fs/xfs/xfs_message.c:100!
[   68.315838] invalid opcode: 0000 [#1] SMP 
[   68.316117] Modules linked in:
[   68.316117] CPU 3 
[   68.316117] Pid: 4401, comm: kworker/3:1H Not tainted 3.8.0-dgc+ #433 Bochs Bochs
[   68.316117] RIP: 0010:[<ffffffff8146a1f2>]  [<ffffffff8146a1f2>] assfail+0x22/0x30
[   68.316117] RSP: 0018:ffff88021c70dd08  EFLAGS: 00010296
[   68.316117] RAX: 000000000000003d RBX: 0000000000000000 RCX: 0000000000008f8e
[   68.316117] RDX: 0000000000008e8e RSI: 0000000000000096 RDI: 0000000000000246
[   68.316117] RBP: ffff88021c70dd08 R08: 000000000000000a R09: 0000000000000215
[   68.316117] R10: 0000000000000000 R11: 0000000000000214 R12: ffff88011d005000
[   68.316117] R13: ffff88011b71d5c0 R14: 0000000000000020 R15: ffff88011b5d1000
[   68.316117] FS:  0000000000000000(0000) GS:ffff88021fc00000(0000) knlGS:0000000000000000
[   68.316117] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   68.316117] CR2: 0000000000757000 CR3: 000000019a1ac000 CR4: 00000000000006e0
[   68.316117] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   68.316117] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   68.316117] Process kworker/3:1H (pid: 4401, threadinfo ffff88021c70c000, task ffff88021c97c280)
[   68.316117] Stack:
[   68.316117]  ffff88021c70dd68 ffffffff814b2c37 ffffffff814b2cee 0000000000000003
[   68.316117]  ffff88021c70dd48 ffff88011d0052a0 ffff88021fc12c40 ffff88011b71d688
[   68.316117]  ffff88011b71d5c0 0000000000000001 0000000000000000 ffff88011b71d688
[   68.316117] Call Trace:
[   68.316117]  [<ffffffff814b2c37>] xfs_inode_buf_verify+0xf7/0x190
[   68.316117]  [<ffffffff814b2cee>] ? xfs_inode_buf_read_verify+0xe/0x10
[   68.316117]  [<ffffffff814b2cee>] xfs_inode_buf_read_verify+0xe/0x10
[   68.316117]  [<ffffffff81457e25>] xfs_buf_iodone_work+0xc5/0xf0
[   68.316117]  [<ffffffff810a0b42>] process_one_work+0x132/0x4e0
[   68.316117]  [<ffffffff81457d60>] ? xfs_buf_unlock+0xa0/0xa0
[   68.316117]  [<ffffffff810a244d>] worker_thread+0x15d/0x450
[   68.316117]  [<ffffffff810a22f0>] ? __next_gcwq_cpu+0x60/0x60
[   68.316117]  [<ffffffff810a84d8>] kthread+0xd8/0xe0
[   68.316117]  [<ffffffff810a8400>] ? flush_kthread_worker+0xa0/0xa0
[   68.316117]  [<ffffffff81be03ec>] ret_from_fork+0x7c/0xb0
[   68.316117]  [<ffffffff810a8400>] ? flush_kthread_worker+0xa0/0xa0

Which is on a buffer that has never had read-ahead issued on it.
It's an inode buffer, but the partial magic number indicates that
the block contains directory data of some kind. IOWs, it looks to me
like data from the wrong blocks was returned to XFS....

[Ben: now do you see why I want every single piece of XFS metadata
to be completely self describing with embedded UUIDs, block/inode
numbers and owners? Having a block/inode number encoded into the
metadata will detect these sorts of storage layer bugs immediately
and tell us the class of error is occurring without having to
guess...]

All of the evidence points of a problem caused by the pvmove
operation. I'd suggest that you don't use it until we get to the
bottom of the problem (i.e. where the EAGAIN is coming from and
why)....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

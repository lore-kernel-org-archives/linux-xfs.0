Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BCB857FAD
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 10:20:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9CA0A8F8037
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 08:20:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oEvKufwAW1KkJxJb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Aug 2014 08:20:46 -0700 (PDT)
Date: Wed, 6 Aug 2014 11:20:42 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: use-after-free on log replay failure
Message-ID: <20140806152042.GB39990@bfoster.bfoster>
References: <CAOcd+r0B-4SPjzim=68w3L8Y9FxwBD-C5HkkeO58C6t9nfgbhw@mail.gmail.com>
	<20140113204314.GJ3469@dastard>
	<CAOcd+r22FirPMHjdxQyTmXOAM72ND-t0=njK9nEmesSV5=Ec=Q@mail.gmail.com>
	<20140115014503.GQ3469@dastard>
	<CAOcd+r0R6KxmgEJNPUZ0Q5cQhsStGb=cehYE0+wKgDNU1negsA@mail.gmail.com>
	<20140119231745.GF18112@dastard>
	<4B2A412C75324EE9880358513C069476@alyakaslap>
	<9D3CBECB663B4A77B7EF74B67973310A@alyakaslap>
	<20140804230721.GA20518@dastard>
	<AC10852F403846A182491ED8071135ED@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AC10852F403846A182491ED8071135ED@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 06, 2014 at 03:52:03PM +0300, Alex Lyakas wrote:
> Hello Dave and Brian,
> 
> Dave, I tried the patch you suggested, but it does not fix the issue. I did
> some further digging, and it appears that _xfs_buf_ioend(schedule=1) can be
> called from xfs_buf_iorequest(), which the patch fixes, but also from
> xfs_buf_bio_end_io() which is my case. I am reproducing the issue pretty
> easily. The flow that I have is like this:
> - xlog_recover() calls xlog_find_tail(). This works alright.

What's the purpose of a sleep here?

> - Now I add a small sleep before calling xlog_do_recover(), and meanwhile I
> instruct my block device to return ENOSPC for any WRITE from now on.
> 
> What seems to happen is that several WRITE bios are submitted and they all
> fail. When they do, they reach xfs_buf_ioend() through a stack like this:
> 
> Aug  6 15:23:07 dev kernel: [  304.410528] [56]xfs*[xfs_buf_ioend:1056]
> XFS(dm-19): Scheduling xfs_buf_iodone_work on error
> Aug  6 15:23:07 dev kernel: [  304.410534] Pid: 56, comm: kworker/u:1
> Tainted: G        W  O 3.8.13-557-generic #1382000791
> Aug  6 15:23:07 dev kernel: [  304.410537] Call Trace:
> Aug  6 15:23:07 dev kernel: [  304.410587]  [<ffffffffa04d6654>]
> xfs_buf_ioend+0x1a4/0x1b0 [xfs]
> Aug  6 15:23:07 dev kernel: [  304.410621]  [<ffffffffa04d6685>]
> _xfs_buf_ioend+0x25/0x30 [xfs]
> Aug  6 15:23:07 dev kernel: [  304.410643]  [<ffffffffa04d6b3d>]
> xfs_buf_bio_end_io+0x3d/0x50 [xfs]
> Aug  6 15:23:07 dev kernel: [  304.410652]  [<ffffffff811c3d8d>]
> bio_endio+0x1d/0x40
> ...
> 
> At this point, they are scheduled to run xlog_recover_iodone through
> xfslogd_workqueue.
> The first callback that gets called, calls xfs_do_force_shutdown in stack
> like this:
> 
> Aug  6 15:23:07 dev kernel: [  304.411791] XFS (dm-19): metadata I/O error:
> block 0x3780001 ("xlog_recover_iodone") error 28 numblks 1
> Aug  6 15:23:07 dev kernel: [  304.413493] XFS (dm-19):
> xfs_do_force_shutdown(0x1) called from line 377 of file
> /mnt/work/alex/xfs/fs/xfs/xfs_log_recover.c.  Return address =
> 0xffffffffa0526848
> Aug  6 15:23:07 dev kernel: [  304.413837]  [<ffffffffa04e0b60>]
> xfs_do_force_shutdown+0x40/0x180 [xfs]
> Aug  6 15:23:07 dev kernel: [  304.413870]  [<ffffffffa0526848>] ?
> xlog_recover_iodone+0x48/0x70 [xfs]
> Aug  6 15:23:07 dev kernel: [  304.413902]  [<ffffffffa0526848>]
> xlog_recover_iodone+0x48/0x70 [xfs]
> Aug  6 15:23:07 dev kernel: [  304.413923]  [<ffffffffa04d645d>]
> xfs_buf_iodone_work+0x4d/0xa0 [xfs]
> Aug  6 15:23:07 dev kernel: [  304.413930]  [<ffffffff81077a11>]
> process_one_work+0x141/0x4a0
> Aug  6 15:23:07 dev kernel: [  304.413937]  [<ffffffff810789e8>]
> worker_thread+0x168/0x410
> Aug  6 15:23:07 dev kernel: [  304.413943]  [<ffffffff81078880>] ?
> manage_workers+0x120/0x120
> Aug  6 15:23:07 dev kernel: [  304.413949]  [<ffffffff8107df10>]
> kthread+0xc0/0xd0
> Aug  6 15:23:07 dev kernel: [  304.413954]  [<ffffffff8107de50>] ?
> flush_kthread_worker+0xb0/0xb0
> Aug  6 15:23:07 dev kernel: [  304.413976]  [<ffffffff816ab86c>]
> ret_from_fork+0x7c/0xb0
> Aug  6 15:23:07 dev kernel: [  304.413986]  [<ffffffff8107de50>] ?
> flush_kthread_worker+0xb0/0xb0
> Aug  6 15:23:07 dev kernel: [  304.413990] ---[ end trace 988d698520e1fa81
> ]---
> Aug  6 15:23:07 dev kernel: [  304.414012] XFS (dm-19): I/O Error Detected.
> Shutting down filesystem
> Aug  6 15:23:07 dev kernel: [  304.415936] XFS (dm-19): Please umount the
> filesystem and rectify the problem(s)
> 
> But the rest of the callbacks also arrive:
> Aug  6 15:23:07 dev kernel: [  304.417812] XFS (dm-19): metadata I/O error:
> block 0x3780002 ("xlog_recover_iodone") error 28 numblks 1
> Aug  6 15:23:07 dev kernel: [  304.420420] XFS (dm-19):
> xfs_do_force_shutdown(0x1) called from line 377 of file
> /mnt/work/alex/xfs/fs/xfs/xfs_log_recover.c.  Return address =
> 0xffffffffa0526848
> Aug  6 15:23:07 dev kernel: [  304.420427] XFS (dm-19): metadata I/O error:
> block 0x3780008 ("xlog_recover_iodone") error 28 numblks 8
> Aug  6 15:23:07 dev kernel: [  304.422708] XFS (dm-19):
> xfs_do_force_shutdown(0x1) called from line 377 of file
> /mnt/work/alex/xfs/fs/xfs/xfs_log_recover.c.  Return address =
> 0xffffffffa0526848
> Aug  6 15:23:07 dev kernel: [  304.422738] XFS (dm-19): metadata I/O error:
> block 0x3780010 ("xlog_recover_iodone") error 28 numblks 8
> 
> The mount sequence fails and goes back to the caller:
> Aug  6 15:23:07 dev kernel: [  304.423438] XFS (dm-19): log mount/recovery
> failed: error 28
> Aug  6 15:23:07 dev kernel: [  304.423757] XFS (dm-19): log mount failed
> 
> But there are still additional callbacks to deliver, which the mount
> sequence did not wait for!
> Aug  6 15:23:07 dev kernel: [  304.425717] XFS (@dR):
> xfs_do_force_shutdown(0x1) called from line 377 of file
> /mnt/work/alex/xfs/fs/xfs/xfs_log_recover.c.  Return address =
> 0xffffffffa0526848
> Aug  6 15:23:07 dev kernel: [  304.425723] XFS (@dR): metadata I/O error:
> block 0x3780018 ("xlog_recover_iodone") error 28 numblks 8
> Aug  6 15:23:07 dev kernel: [  304.428239] XFS (@dR):
> xfs_do_force_shutdown(0x1) called from line 377 of file
> /mnt/work/alex/xfs/fs/xfs/xfs_log_recover.c.  Return address =
> 0xffffffffa0526848
> Aug  6 15:23:07 dev kernel: [  304.428246] XFS (@dR): metadata I/O error:
> block 0x37800a0 ("xlog_recover_iodone") error 28 numblks 16
> 
> Notice the junk that they are printing! Naturally, because xfs_mount
> structure has been kfreed.
> 
> Finally the kernel crashes (instead of printing junk), because the xfs_mount
> structure is gone, but the callback tries to access it (printing the name):
> 
> Aug  6 15:23:07 dev kernel: [  304.430796] general protection fault: 0000
> [#1] SMP
> Aug  6 15:23:07 dev kernel: [  304.432035] Modules linked in: xfrm_user
> xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 iscsi_scst_tcp(O)
> scst_vdisk(O) scst(O) dm_zcache(O) dm_btrfs(O) xfs(O) btrfs(O) libcrc32c
> raid456(O) async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq
> async_tx raid1(O) md_mod deflate zlib_deflate ctr twofish_generic
> twofish_x86_64_3way glue_helper lrw xts gf128mul twofish_x86_64
> twofish_common camellia_generic serpent_generic blowfish_generic
> blowfish_x86_64 blowfish_common cast5_generic cast_common des_generic xcbc
> rmd160 sha512_generic crypto_null af_key xfrm_algo dm_round_robin kvm vfat
> fat ppdev psmouse microcode nfsd nfs_acl dm_multipath(O) serio_raw
> parport_pc nfsv4 dm_iostat(O) mac_hid i2c_piix4 auth_rpcgss nfs fscache
> lockd sunrpc lp parport floppy
> Aug  6 15:23:07 dev kernel: [  304.432035] CPU 1
> Aug  6 15:23:07 dev kernel: [  304.432035] Pid: 133, comm: kworker/1:1H
> Tainted: G        W  O 3.8.13-557-generic #1382000791 Bochs Bochs
> Aug  6 15:23:07 dev kernel: [  304.432035] RIP: 0010:[<ffffffff8133c2cb>]
> [<ffffffff8133c2cb>] strnlen+0xb/0x30
> Aug  6 15:23:07 dev kernel: [  304.432035] RSP: 0018:ffff880035461b08
> EFLAGS: 00010086
> Aug  6 15:23:07 dev kernel: [  304.432035] RAX: 0000000000000000 RBX:
> ffffffff81e6a4e7 RCX: 0000000000000000
> Aug  6 15:23:07 dev kernel: [  304.432035] RDX: e4e8390a265c0000 RSI:
> ffffffffffffffff RDI: e4e8390a265c0000
> Aug  6 15:23:07 dev kernel: [  304.432035] RBP: ffff880035461b08 R08:
> 000000000000ffff R09: 000000000000ffff
> Aug  6 15:23:07 dev kernel: [  304.432035] R10: 0000000000000000 R11:
> 00000000000004cd R12: e4e8390a265c0000
> Aug  6 15:23:07 dev kernel: [  304.432035] R13: ffffffff81e6a8c0 R14:
> 0000000000000000 R15: 000000000000ffff
> Aug  6 15:23:07 dev kernel: [  304.432035] FS:  0000000000000000(0000)
> GS:ffff88007fc80000(0000) knlGS:0000000000000000
> Aug  6 15:23:07 dev kernel: [  304.432035] CS:  0010 DS: 0000 ES: 0000 CR0:
> 000000008005003b
> Aug  6 15:23:07 dev kernel: [  304.432035] CR2: 00007fc902ffbfd8 CR3:
> 000000007702a000 CR4: 00000000000006e0
> Aug  6 15:23:07 dev kernel: [  304.432035] DR0: 0000000000000000 DR1:
> 0000000000000000 DR2: 0000000000000000
> Aug  6 15:23:07 dev kernel: [  304.432035] DR3: 0000000000000000 DR6:
> 00000000ffff0ff0 DR7: 0000000000000400
> Aug  6 15:23:07 dev kernel: [  304.432035] Process kworker/1:1H (pid: 133,
> threadinfo ffff880035460000, task ffff880035412e00)
> Aug  6 15:23:07 dev kernel: [  304.432035] Stack:
> Aug  6 15:23:07 dev kernel: [  304.432035]  ffff880035461b48
> ffffffff8133dd5e 0000000000000000 ffffffff81e6a4e7
> Aug  6 15:23:07 dev kernel: [  304.432035]  ffffffffa0566cba
> ffff880035461c80 ffffffffa0566cba ffffffff81e6a8c0
> Aug  6 15:23:07 dev kernel: [  304.432035]  ffff880035461bc8
> ffffffff8133ef59 ffff880035461bc8 ffffffff81c84040
> Aug  6 15:23:07 dev kernel: [  304.432035] Call Trace:
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffff8133dd5e>]
> string.isra.4+0x3e/0xd0
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffff8133ef59>]
> vsnprintf+0x219/0x640
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffff8133f441>]
> vscnprintf+0x11/0x30
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffff8105a971>]
> vprintk_emit+0xc1/0x490
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffff8105aa20>] ?
> vprintk_emit+0x170/0x490
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffff8168b992>]
> printk+0x61/0x63
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffffa04e9bf1>]
> __xfs_printk+0x31/0x50 [xfs]
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffffa04e9e43>]
> xfs_notice+0x53/0x60 [xfs]
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffffa04e0c15>]
> xfs_do_force_shutdown+0xf5/0x180 [xfs]
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffffa0526848>] ?
> xlog_recover_iodone+0x48/0x70 [xfs]
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffffa0526848>]
> xlog_recover_iodone+0x48/0x70 [xfs]
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffffa04d645d>]
> xfs_buf_iodone_work+0x4d/0xa0 [xfs]
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffff81077a11>]
> process_one_work+0x141/0x4a0
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffff810789e8>]
> worker_thread+0x168/0x410
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffff81078880>] ?
> manage_workers+0x120/0x120
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffff8107df10>]
> kthread+0xc0/0xd0
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffff8107de50>] ?
> flush_kthread_worker+0xb0/0xb0
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffff816ab86c>]
> ret_from_fork+0x7c/0xb0
> Aug  6 15:23:07 dev kernel: [  304.432035]  [<ffffffff8107de50>] ?
> flush_kthread_worker+0xb0/0xb0
> Aug  6 15:23:07 dev kernel: [  304.432035] Code: 31 c0 80 3f 00 55 48 89 e5
> 74 11 48 89 f8 66 90 48 83 c0 01 80 38 00 75 f7 48 29 f8 5d c3 66 90 55 31
> c0 48 85 f6 48 89 e5 74 23 <80> 3f 00 74 1e 48 89 f8 eb 0c 0f 1f 00 48 83 ee
> 01 80 38 00 74
> Aug  6 15:23:07 dev kernel: [  304.432035] RIP  [<ffffffff8133c2cb>]
> strnlen+0xb/0x30
> Aug  6 15:23:07 dev kernel: [  304.432035]  RSP <ffff880035461b08>
> 
> 
> So previously you said: "So, something is corrupting memory and stamping all
> over the XFS structures." and also "given you have a bunch of out of tree
> modules loaded (and some which are experiemental) suggests that you have a
> problem with your storage...".
> 
> But I believe, my analysis shows that during the mount sequence XFS does not
> wait properly for all the bios to complete, before failing the mount
> sequence back to the caller.
> 

As an experiment, what about the following? Compile tested only and not
safe for general use.

What might help more is to see if you can create a reproducer on a
recent, clean kernel. Perhaps a metadump of your reproducer fs combined
with whatever block device ENOSPC hack you're using would do it.

Brian

---8<---

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index cd7b8ca..fbcf524 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1409,19 +1409,27 @@ xfs_buf_iorequest(
  * case nothing will ever complete.  It returns the I/O error code, if any, or
  * 0 if there was no error.
  */
-int
-xfs_buf_iowait(
-	xfs_buf_t		*bp)
+static int
+__xfs_buf_iowait(
+	struct xfs_buf		*bp,
+	bool			skip_error)
 {
 	trace_xfs_buf_iowait(bp, _RET_IP_);
 
-	if (!bp->b_error)
+	if (skip_error || !bp->b_error)
 		wait_for_completion(&bp->b_iowait);
 
 	trace_xfs_buf_iowait_done(bp, _RET_IP_);
 	return bp->b_error;
 }
 
+int
+xfs_buf_iowait(
+	struct xfs_buf		*bp)
+{
+	return __xfs_buf_iowait(bp, false);
+}
+
 xfs_caddr_t
 xfs_buf_offset(
 	xfs_buf_t		*bp,
@@ -1866,7 +1874,7 @@ xfs_buf_delwri_submit(
 		bp = list_first_entry(&io_list, struct xfs_buf, b_list);
 
 		list_del_init(&bp->b_list);
-		error2 = xfs_buf_iowait(bp);
+		error2 = __xfs_buf_iowait(bp, true);
 		xfs_buf_relse(bp);
 		if (!error)
 			error = error2;

---

> Thanks,
> Alex.
> 
> 
> 
> -----Original Message----- From: Dave Chinner
> Sent: 05 August, 2014 2:07 AM
> To: Alex Lyakas
> Cc: xfs@oss.sgi.com
> Subject: Re: use-after-free on log replay failure
> 
> On Mon, Aug 04, 2014 at 02:00:05PM +0300, Alex Lyakas wrote:
> >Greetings,
> >
> >we had a log replay failure due to some errors that the underlying
> >block device returned:
> >[49133.801406] XFS (dm-95): metadata I/O error: block 0x270e8c180
> >("xlog_recover_iodone") error 28 numblks 16
> >[49133.802495] XFS (dm-95): log mount/recovery failed: error 28
> >[49133.802644] XFS (dm-95): log mount failed
> 
> #define ENOSPC          28      /* No space left on device */
> 
> You're getting an ENOSPC as a metadata IO error during log recovery?
> Thin provisioning problem, perhaps, and the error is occurring on
> submission rather than completion? If so:
> 
> 8d6c121 xfs: fix buffer use after free on IO error
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE66D7CA0
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 06:21:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7572D304051
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 04:21:44 -0700 (PDT)
Received: from mail-ob0-f175.google.com (mail-ob0-f175.google.com
	[209.85.214.175]) by cuda.sgi.com with ESMTP id
	pNaP1O1OxtIvxeEd (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Mar 2016 04:21:41 -0700 (PDT)
Received: by mail-ob0-f175.google.com with SMTP id xj3so28956695obb.0
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 04:21:41 -0700 (PDT)
From: Shyam Kaushik <shyam@zadarastorage.com>
MIME-Version: 1.0
Date: Tue, 22 Mar 2016 16:51:39 +0530
Message-ID: <f049419a2ab10f8e3c4fef0e4f4ca1ba@mail.gmail.com>
Subject: XFS hung task in xfs_ail_push_all_sync() when unmounting FS after
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
To: xfs@oss.sgi.com
Cc: Alex Lyakas <alex@zadarastorage.com>

Hi XFS developers,

We are seeing the following issue with XFS on kernel 3.18.19.

We have XFS mounted over a raw disk. Disk was pulled out manually. There
were async writes on files that were errored like this

Mar 16 16:03:21 host0 kernel: [ 4635.645613] XFS (dm-29): metadata I/O
error: block 0x7442c20 ("xfs_buf_iodone_callbacks") error 5 numblks 8
Mar 16 16:03:21 host0 kernel: [ 4635.945044] XFS (dm-29): Detected failing
async write on buffer block 0x7442c20. Retrying async write.
Mar 16 16:03:21 host0 kernel: [ 4635.945048] XFS (dm-29): Detected failing
async write on buffer block 0x7442c28. Retrying async write.
Mar 16 16:03:21 host0 kernel: [ 4635.945050] XFS (dm-29): Detected failing
async write on buffer block 0x7442c30. Retrying async write.
Mar 16 16:03:21 host0 kernel: [ 4635.965056] XFS (dm-29): Detected failing
async write on buffer block 0x7443008. Retrying async write.
Mar 16 16:03:21 host0 kernel: [ 4635.965070] XFS (dm-29): Detected failing
async write on buffer block 0xae64230. Retrying async write.
Mar 16 16:03:21 host0 kernel: [ 4635.965075] XFS (dm-29): Detected failing
async write on buffer block 0xae64210. Retrying async write.
Mar 16 16:03:21 host0 kernel: [ 4635.965080] XFS (dm-29): Detected failing
async write on buffer block 0xae64228. Retrying async write.
Mar 16 16:03:21 host0 kernel: [ 4635.965085] XFS (dm-29): Detected failing
async write on buffer block 0xae64220. Retrying async write.
Mar 16 16:03:21 host0 kernel: [ 4635.965090] XFS (dm-29): Detected failing
async write on buffer block 0xae64208. Retrying async write.
Mar 16 16:03:21 host0 kernel: [ 4636.005024] XFS (dm-29): Detected failing
async write on buffer block 0xe885828. Retrying async write.

And XFS hit metadata & Log IO errors that it decides to shutdown:

Mar 16 16:03:22 host0 kernel: [ 4637.351841] XFS (dm-29): metadata I/O
error: block 0x3a27fbd0 ("xlog_iodone") error 5 numblks 64
Mar 16 16:03:22 host0 kernel: [ 4637.352820] XFS(dm-29): SHUTDOWN!!!
old_flags=0x0 new_flags=0x2
Mar 16 16:03:22 host0 kernel: [ 4637.353187] XFS (dm-29): Log I/O Error
Detected.  Shutting down filesystem
Mar 16 16:03:22 host0 kernel: [ 4637.353202] XFS (dm-29): xfs_log_force:
error -5 returned.
Mar 16 16:03:22 host0 kernel: [ 4637.354037] XFS (dm-29): Please umount
the filesystem and rectify the problem(s)
Mar 16 16:03:22 host0 kernel: [ 4637.354704] Buffer I/O error on dev
dm-29, logical block 122146379, lost async page write

After this happens, constantly XFS prints log force failure every 30-secs

Mar 16 16:03:51 host0 kernel: [ 4665.695023] XFS (dm-29): xfs_log_force:
error -5 returned.
Mar 16 16:04:21 host0 kernel: [ 4695.775022] XFS (dm-29): xfs_log_force:
error -5 returned.
Mar 16 16:04:51 host0 kernel: [ 4725.855021] XFS (dm-29): xfs_log_force:
error -5 returned.
Mar 16 16:05:21 host0 kernel: [ 4755.935033] XFS (dm-29): xfs_log_force:
error -5 returned.

Later the drive was re-inserted back. After the drive was re-inserted, XFS
was attempted to be unmounted

Mar 16 16:16:53 host0 controld: [2557] [     ] umount[202]
: umount(/sdisk/vol5b0, xfs)

But nothing happens except for the 30-secs xfs_log_force errors that keeps
repeating

Mar 16 16:16:53 host0 kernel: [ 5448.122129] XFS (dm-29): xfs_log_force:
error -5 returned.
Mar 16 16:16:53 host0 kernel: [ 5448.135107] XFS (dm-29): xfs_log_force:
error -5 returned.
Mar 16 16:17:23 host0 kernel: [ 5477.855028] XFS (dm-29): xfs_log_force:
error -5 returned.
Mar 16 16:17:53 host0 kernel: [ 5507.935034] XFS (dm-29): xfs_log_force:
error -5 returned.
Mar 16 16:18:23 host0 kernel: [ 5538.015020] XFS (dm-29): xfs_log_force:
error -5 returned.
Mar 16 16:18:53 host0 kernel: [ 5568.095031] XFS (dm-29): xfs_log_force:
error -5 returned.
Mar 16 16:19:23 host0 kernel: [ 5598.175025] XFS (dm-29): xfs_log_force:
error -5 returned.
Mar 16 16:19:53 host0 kernel: [ 5628.255023] XFS (dm-29): xfs_log_force:
error -5 returned.
Mar 16 16:20:23 host0 kernel: [ 5658.335027] XFS (dm-29): xfs_log_force:
error -5 returned.
Mar 16 16:20:54 host0 kernel: [ 5688.415028] XFS (dm-29): xfs_log_force:
error -5 returned.
Mar 16 16:21:24 host0 kernel: [ 5718.495021] XFS (dm-29): xfs_log_force:
error -5 returned.
Mar 16 16:21:54 host0 kernel: [ 5748.575024] XFS (dm-29): xfs_log_force:
error -5 returned.


& we run into a hung-task timeout like this

Mar 16 16:22:07 host0 kernel: [ 5762.085031] INFO: task controld:2557
blocked for more than 180 seconds.
Mar 16 16:22:07 host0 kernel: [ 5762.086224] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 16 16:22:07 host0 kernel: [ 5762.086897] controld      D
ffff88023fc13540     0  2557      1 0x00000000
Mar 16 16:22:07 host0 kernel: [ 5762.086901]  ffff880223a07d58
0000000000000086 ffff88023332d100 0000000000013540
Mar 16 16:22:07 host0 kernel: [ 5762.086903]  ffff880223a07fd8
0000000000013540 ffffffff81c1d4c0 ffff88023332d100
Mar 16 16:22:07 host0 kernel: [ 5762.086906]  ffff880210f5f980
ffff88020fdb1600 ffff880210f5f980 ffff88020fdb1640
Mar 16 16:22:07 host0 kernel: [ 5762.086908] Call Trace:
Mar 16 16:22:07 host0 kernel: [ 5762.086914]  [<ffffffff817136c9>]
schedule+0x29/0x70
Mar 16 16:22:07 host0 kernel: [ 5762.086939]  [<ffffffffc087fb49>]
xfs_ail_push_all_sync+0xa9/0xe0 [xfs]
Mar 16 16:22:07 host0 kernel: [ 5762.086942]  [<ffffffff810b26b0>] ?
prepare_to_wait_event+0x110/0x110
Mar 16 16:22:07 host0 kernel: [ 5762.086958]  [<ffffffffc0869fd1>]
xfs_unmountfs+0x61/0x1a0 [xfs]
Mar 16 16:22:07 host0 kernel: [ 5762.086970]  [<ffffffffc086a97b>] ?
xfs_mru_cache_destroy+0x6b/0x90 [xfs]
Mar 16 16:22:07 host0 kernel: [ 5762.086982]  [<ffffffffc086be4d>]
xfs_fs_put_super+0x2d/0x70 [xfs]
Mar 16 16:22:07 host0 kernel: [ 5762.086985]  [<ffffffff811e9e36>]
generic_shutdown_super+0x76/0x100
Mar 16 16:22:07 host0 kernel: [ 5762.086987]  [<ffffffff811ea207>]
kill_block_super+0x27/0x70
Mar 16 16:22:07 host0 kernel: [ 5762.086990]  [<ffffffff811ea519>]
deactivate_locked_super+0x49/0x60
Mar 16 16:22:07 host0 kernel: [ 5762.086992]  [<ffffffff811eaaee>]
deactivate_super+0x4e/0x70
Mar 16 16:22:07 host0 kernel: [ 5762.086995]  [<ffffffff81207593>]
cleanup_mnt+0x43/0x90
Mar 16 16:22:07 host0 kernel: [ 5762.086998]  [<ffffffff81207632>]
__cleanup_mnt+0x12/0x20
Mar 16 16:22:07 host0 kernel: [ 5762.087003]  [<ffffffff8108f8e7>]
task_work_run+0xa7/0xe0
Mar 16 16:22:07 host0 kernel: [ 5762.087016]  [<ffffffff81014ff7>]
do_notify_resume+0x97/0xb0
Mar 16 16:22:07 host0 kernel: [ 5762.087019]  [<ffffffff81717c6f>]
int_signal+0x12/0x17

Looks like unmount/xfs_ail_push_all_sync() decided to wake up the aild
task to flush, but is never woken up at all after this. These are the
other stack traces

[8506] xfsalloc
[<ffffffff8108c679>] rescuer_thread+0x209/0x2a0
[<ffffffff810911b9>] kthread+0xc9/0xe0
[<ffffffff81717918>] ret_from_fork+0x58/0x90
[<ffffffffffffffff>] 0xffffffffffffffff

[8507] xfs_mru_cache
[<ffffffff8108c679>] rescuer_thread+0x209/0x2a0
[<ffffffff810911b9>] kthread+0xc9/0xe0
[<ffffffff81717918>] ret_from_fork+0x58/0x90
[<ffffffffffffffff>] 0xffffffffffffffff

[8508] xfslogd
[<ffffffff8108c679>] rescuer_thread+0x209/0x2a0
[<ffffffff810911b9>] kthread+0xc9/0xe0
[<ffffffff81717918>] ret_from_fork+0x58/0x90
[<ffffffffffffffff>] 0xffffffffffffffff

[8663] xfs-data/dm-29
[<ffffffff8108c679>] rescuer_thread+0x209/0x2a0
[<ffffffff810911b9>] kthread+0xc9/0xe0
[<ffffffff81717918>] ret_from_fork+0x58/0x90
[<ffffffffffffffff>] 0xffffffffffffffff

[8665] xfs-conv/dm-29
[<ffffffff8108c679>] rescuer_thread+0x209/0x2a0
[<ffffffff810911b9>] kthread+0xc9/0xe0
[<ffffffff81717918>] ret_from_fork+0x58/0x90
[<ffffffffffffffff>] 0xffffffffffffffff

[8670] xfs-cil/dm-29
[<ffffffff8108c679>] rescuer_thread+0x209/0x2a0
[<ffffffff810911b9>] kthread+0xc9/0xe0
[<ffffffff81717918>] ret_from_fork+0x58/0x90
[<ffffffffffffffff>] 0xffffffffffffffff

[8672] xfsaild/dm-29
[<ffffffffc087f8d7>] xfsaild+0x5a7/0x630 [xfs]
[<ffffffff810911b9>] kthread+0xc9/0xe0
[<ffffffff81717918>] ret_from_fork+0x58/0x90
[<ffffffffffffffff>] 0xffffffffffffffff

This problem doesn't happen consistently, but happens periodically with a
drive failure/recovery followed by XFS unmount. I couldn't find this issue
fixed in later kernels. Can you please suggest how I can debug this issue
further?

Thanks!

--Shyam

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

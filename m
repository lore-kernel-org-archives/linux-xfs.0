Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5B00429DF7
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2014 09:06:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C54B2AC008
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2014 07:05:59 -0700 (PDT)
Received: from order.stressinduktion.org (order.stressinduktion.org
	[87.106.68.36]) by cuda.sgi.com with ESMTP id OZ9i3W9BjcSyRJWe
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 27 Mar 2014 07:05:57 -0700 (PDT)
Date: Thu, 27 Mar 2014 15:05:56 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: xfs errors while unlinking filenames with hash collisions
Message-ID: <20140327140556.GW29498@order.stressinduktion.org>
References: <20140327074156.GJ29498@order.stressinduktion.org>
	<5334241E.9060708@sgi.com>
	<20140327132354.GU29498@order.stressinduktion.org>
	<533428D6.507@sgi.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <533428D6.507@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 27, 2014 at 08:34:14AM -0500, Mark Tinguely wrote:
> On 03/27/14 08:23, Hannes Frederic Sowa wrote:
> >On Thu, Mar 27, 2014 at 08:14:06AM -0500, Mark Tinguely wrote:
> >>Have you tried to run a xfs_repair on the filesystem after the reboot?
> >
> >Yes, I did. I still use the filesystem and it works. As soon as I try to
> >remove the directory again the same splash from above happens again.
> 
> Is it the latest xfsprogs' repair?
> 
> Do you have the output from the repair still?

I can easily test this here, so you can throw any commands and tests at
me. ;)

This is the output:

(I replayed the journal before that)

pre-mount:/# xfs_repair -V
xfs_repair version 3.1.11
pre-mount:/# xfs_repair -v /dev/vda1 
Phase 1 - find and verify superblock...
        - block cache size set to 372848 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 5071 tail block 5071
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
bad hash ordering in block 8388739 of directory inode 3543184
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
Phase 5 - rebuild AG headers and trees...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - agno = 0
rebuilding directory inode 3543184
        - agno = 1
        - agno = 2
        - agno = 3
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...

        XFS_REPAIR Summary    Thu Mar 27 14:03:12 2014

Phase		Start		End		Duration
Phase 1:	03/27 14:02:42	03/27 14:02:42	
Phase 2:	03/27 14:02:42	03/27 14:02:42	
Phase 3:	03/27 14:02:42	03/27 14:02:45	3 seconds
Phase 4:	03/27 14:02:45	03/27 14:02:46	1 second
Phase 5:	03/27 14:02:46	03/27 14:02:46	
Phase 6:	03/27 14:02:46	03/27 14:03:10	24 seconds
Phase 7:	03/27 14:03:10	03/27 14:03:10	

Total run time: 28 seconds
done

Some other time I remembered getting directory names printed to the serial
console, which got killed because of this. This time it didn't happen.

Btw., When tried to remove the old directory without generating a new
poison one, I got some other traces. Seems like the above splash only
happens when I create and try to remove the directories in one run
(without reboot between).

[   23.401494] ffff88011898e000: 00 00 00 00 00 00 00 00 d2 f1 00 00 01 4d 00 92  .............M..
[   23.408565] ffff88011898e010: 00 00 00 2e 00 00 00 02 00 00 17 2e 00 00 00 04  ................
[   23.423819] ffff88011898e020: 14 10 19 e2 00 02 bc 02 14 10 19 e2 00 02 c2 a7  ................
[   23.430293] ffff88011898e030: 14 10 19 e2 00 02 c5 d0 14 10 19 e2 00 02 c4 c8  ................
[   23.433952] XFS (vda1): Internal error __read_verify at line 186 of file fs/xfs/xfs_dir2_leaf.c.  Caller 0xffffffffa010c243
[   23.439316] CPU: 1 PID: 178 Comm: kworker/1:1H Not tainted 3.13.6-200.fc20.x86_64 #1
[   23.442614] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   23.445069] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[   23.447307]  0000000000000001 ffff8800db7bbd50 ffffffff8168730c ffff8800db97a000
[   23.453139]  ffff8800db7bbd68 ffffffffa00d10cb ffffffffa010c243 ffff8800db7bbda0
[   23.465312]  ffffffffa00d1125 000000badb7bbda0 ffff880117dd8600 ffff8800db97a000
[   23.468831] Call Trace:
[   23.469950]  [<ffffffff8168730c>] dump_stack+0x45/0x56
[   23.472269]  [<ffffffffa00d10cb>] xfs_error_report+0x3b/0x40 [xfs]
[   23.475774]  [<ffffffffa010c243>] ? xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   23.480877]  [<ffffffffa00d1125>] xfs_corruption_error+0x55/0x80 [xfs]
[   23.483665]  [<ffffffffa010c1b6>] __read_verify+0x76/0xf0 [xfs]
[   23.486227]  [<ffffffffa010c243>] ? xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   23.489715]  [<ffffffffa010c243>] xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   23.492707]  [<ffffffffa00ce245>] xfs_buf_iodone_work+0x85/0xf0 [xfs]
[   23.495499]  [<ffffffff81087b76>] process_one_work+0x176/0x430
[   23.499170]  [<ffffffff810887ab>] worker_thread+0x11b/0x3a0
[   23.502038]  [<ffffffff81088690>] ? rescuer_thread+0x350/0x350
[   23.505033]  [<ffffffff8108f272>] kthread+0xd2/0xf0
[   23.507504]  [<ffffffff8108f1a0>] ? insert_kthread_work+0x40/0x40
[   23.510573]  [<ffffffff8169623c>] ret_from_fork+0x7c/0xb0
[   23.513104]  [<ffffffff8108f1a0>] ? insert_kthread_work+0x40/0x40
[   23.515687] XFS (vda1): Corruption detected. Unmount and run xfs_repair
[   23.520994] XFS (vda1): metadata I/O error: block 0x1212dd0 ("xfs_trans_read_buf_map") error 117 numblks 8
[   23.521674] ffff88011898e000: 00 00 00 00 00 00 00 00 d2 f1 00 00 01 4d 00 92  .............M..
[   23.521676] ffff88011898e010: 00 00 00 2e 00 00 00 02 00 00 17 2e 00 00 00 04  ................
[   23.521677] ffff88011898e020: 14 10 19 e2 00 02 bc 02 14 10 19 e2 00 02 c2 a7  ................
[   23.521678] ffff88011898e030: 14 10 19 e2 00 02 c5 d0 14 10 19 e2 00 02 c4 c8  ................
[   23.521682] XFS (vda1): Internal error __read_verify at line 186 of file fs/xfs/xfs_dir2_leaf.c.  Caller 0xffffffffa010c243
[   23.521685] CPU: 1 PID: 178 Comm: kworker/1:1H Not tainted 3.13.6-200.fc20.x86_64 #1
[   23.521685] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   23.521731] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[   23.521734]  0000000000000001 ffff8800db7bbd50 ffffffff8168730c ffff8800db97a000
[   23.521736]  ffff8800db7bbd68 ffffffffa00d10cb ffffffffa010c243 ffff8800db7bbda0
[   23.521738]  ffffffffa00d1125 000000badb7bbda0 ffff880117dd8600 ffff8800db97a000
[   23.521738] Call Trace:
[   23.521745]  [<ffffffff8168730c>] dump_stack+0x45/0x56
[   23.521764]  [<ffffffffa00d10cb>] xfs_error_report+0x3b/0x40 [xfs]
[   23.521788]  [<ffffffffa010c243>] ? xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   23.521806]  [<ffffffffa00d1125>] xfs_corruption_error+0x55/0x80 [xfs]
[   23.521829]  [<ffffffffa010c1b6>] __read_verify+0x76/0xf0 [xfs]
[   23.521852]  [<ffffffffa010c243>] ? xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   23.521875]  [<ffffffffa010c243>] xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   23.521893]  [<ffffffffa00ce245>] xfs_buf_iodone_work+0x85/0xf0 [xfs]
[   23.521896]  [<ffffffff81087b76>] process_one_work+0x176/0x430
[   23.521898]  [<ffffffff810887ab>] worker_thread+0x11b/0x3a0
[   23.521900]  [<ffffffff81088690>] ? rescuer_thread+0x350/0x350
[   23.521902]  [<ffffffff8108f272>] kthread+0xd2/0xf0
[   23.521905]  [<ffffffff8108f1a0>] ? insert_kthread_work+0x40/0x40
[   23.521908]  [<ffffffff8169623c>] ret_from_fork+0x7c/0xb0
[   23.521910]  [<ffffffff8108f1a0>] ? insert_kthread_work+0x40/0x40
[   23.521911] XFS (vda1): Corruption detected. Unmount and run xfs_repair
[   23.522053] XFS (vda1): metadata I/O error: block 0x1212dd0 ("xfs_trans_read_buf_map") error 117 numblks 8
[   23.767676] ffff88011898e000: 00 00 00 00 00 00 00 00 d2 f1 00 00 01 4d 00 92  .............M..
[   23.767677] ffff88011898e010: 00 00 00 2e 00 00 00 02 00 00 17 2e 00 00 00 04  ................
[   23.767678] ffff88011898e020: 14 10 19 e2 00 02 bc 02 14 10 19 e2 00 02 c2 a7  ................
[   23.767680] ffff88011898e030: 14 10 19 e2 00 02 c5 d0 14 10 19 e2 00 02 c4 c8  ................
[   23.767683] XFS (vda1): Internal error __read_verify at line 186 of file fs/xfs/xfs_dir2_leaf.c.  Caller 0xffffffffa010c243
[   23.767686] CPU: 1 PID: 178 Comm: kworker/1:1H Not tainted 3.13.6-200.fc20.x86_64 #1
[   23.767686] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   23.767731] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[   23.767734]  0000000000000001 ffff8800db7bbd50 ffffffff8168730c ffff8800db97a000
[   23.767736]  ffff8800db7bbd68 ffffffffa00d10cb ffffffffa010c243 ffff8800db7bbda0
[   23.767737]  ffffffffa00d1125 000000badb7bbda0 ffff880117dd8600 ffff8800db97a000
[   23.767738] Call Trace:
[   23.767744]  [<ffffffff8168730c>] dump_stack+0x45/0x56
[   23.767763]  [<ffffffffa00d10cb>] xfs_error_report+0x3b/0x40 [xfs]
[   23.767840]  [<ffffffffa010c243>] ? xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   23.767860]  [<ffffffffa00d1125>] xfs_corruption_error+0x55/0x80 [xfs]
[   23.767884]  [<ffffffffa010c1b6>] __read_verify+0x76/0xf0 [xfs]
[   23.767908]  [<ffffffffa010c243>] ? xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   23.767931]  [<ffffffffa010c243>] xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   23.767950]  [<ffffffffa00ce245>] xfs_buf_iodone_work+0x85/0xf0 [xfs]
[   23.767954]  [<ffffffff81087b76>] process_one_work+0x176/0x430
[   23.767956]  [<ffffffff810887ab>] worker_thread+0x11b/0x3a0
[   23.767958]  [<ffffffff81088690>] ? rescuer_thread+0x350/0x350
[   23.767961]  [<ffffffff8108f272>] kthread+0xd2/0xf0
[   23.767963]  [<ffffffff8108f1a0>] ? insert_kthread_work+0x40/0x40
[   23.767966]  [<ffffffff8169623c>] ret_from_fork+0x7c/0xb0
[   23.767969]  [<ffffffff8108f1a0>] ? insert_kthread_work+0x40/0x40
[   23.768005] XFS (vda1): Corruption detected. Unmount and run xfs_repair
[   23.768191] XFS (vda1): metadata I/O error: block 0x1212dd0 ("xfs_trans_read_buf_map") error 117 numblks 8
[   23.768665] ffff8800d7fd2000: 00 00 00 00 00 00 00 00 d2 f1 00 00 01 4d 00 92  .............M..
[   23.768666] ffff8800d7fd2010: 00 00 00 2e 00 00 00 02 00 00 17 2e 00 00 00 04  ................
[   23.768667] ffff8800d7fd2020: 14 10 19 e2 00 02 bc 02 14 10 19 e2 00 02 c2 a7  ................
[   23.768668] ffff8800d7fd2030: 14 10 19 e2 00 02 c5 d0 14 10 19 e2 00 02 c4 c8  ................
[   23.768671] XFS (vda1): Internal error __read_verify at line 186 of file fs/xfs/xfs_dir2_leaf.c.  Caller 0xffffffffa010c243
[   23.768673] CPU: 1 PID: 178 Comm: kworker/1:1H Not tainted 3.13.6-200.fc20.x86_64 #1
[   23.768674] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   23.768706] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[   23.768709]  0000000000000001 ffff8800db7bbd50 ffffffff8168730c ffff8800db97a000
[   23.768710]  ffff8800db7bbd68 ffffffffa00d10cb ffffffffa010c243 ffff8800db7bbda0
[   23.768712]  ffffffffa00d1125 000000badb7bbda0 ffff880117dd8600 ffff8800db97a000
[   23.768712] Call Trace:
[   23.768718]  [<ffffffff8168730c>] dump_stack+0x45/0x56
[   23.768737]  [<ffffffffa00d10cb>] xfs_error_report+0x3b/0x40 [xfs]
[   23.768761]  [<ffffffffa010c243>] ? xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   23.768887]  [<ffffffffa00d1125>] xfs_corruption_error+0x55/0x80 [xfs]
[   23.768911]  [<ffffffffa010c1b6>] __read_verify+0x76/0xf0 [xfs]
[   23.768934]  [<ffffffffa010c243>] ? xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   23.768957]  [<ffffffffa010c243>] xr+0x55/0x80 [xfs]
[   23.864331]  [<ffffffffa010c1b6>] __read_verify+0x76/0xf0 [xfs]
[   23.864353]  [<ffffffffa010c243>] ? xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   23.864376]  [<ffffffffa010c243>] xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   23.864393]  [<ffffffffa00ce245>] xfs_buf_iodone_work+0x85/0xf0 [xfs]
[   23.864417]  [<ffffffff81087b76>] process_one_work+0x176/0x430
[   23.864419]  [<ffffffff810887ab>] worker_thread+0x11b/0x3a0
[   23.864421]  [<ffffffff81088690>] ? rescuer_thread+0x350/0x350
[   23.864423]  [<ffffffff8108f272>] kthread+0xd2/0xf0
[   23.864426]  [<ffffffff8108f1a0>] ? insert_kthread_work+0x40/0x40
[   23.864428]  [<ffffffff8169623c>] ret_from_fork+0x7c/0xb0
[   23.864430]  [<ffffffff8108f1a0>] ? insert_kthread_work+0x40/0x40
[   23.864432] XFS (vda1): Corruption detected. Unmount and run xfs_repair
[   23.865270] XFS (vda1): metadata I/O error: block 0x1212dd0 ("xfs_trans_read_buf_map") error 117 numblks 8
[   23.929267] ffff8800d7fd2000: 00 00 00 00 00 00 00 00 d2 f1 00 00 01 4d 00 92  .............M..
[   23.929269] ffff8800d7fd2010: 00 00 00 2e 00 00 00 02 00 00 17 2e 00 00 00 04  ................
[   23.929270] ffff8800d7fd2020: 14 10 19 e2 00 02 bc 02 14 10 19 e2 00 02 c2 a7  ................
[   23.929271] ffff8800d7fd2030: 14 10 19 e2 00 02 c5 d0 14 10 19 e2 00 02 c4 c8  ................
[   23.929274] XFS (vda1): Internal error __read_verify at line 186 of file fs/xfs/xfs_dir2_leaf.c.  Caller 0xffffffffa010c243
[   23.929277] CPU: 1 PID: 178 Comm: kworker/1:1H Not tainted 3.13.6-200.fc20.x86_64 #1
[   23.929278] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   23.929323] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[   23.929325]  0000000000000001 ffff8800db7bbd50 ffffffff8168730c ffff8800db97a000
[   23.929327]  ffff8800db7bbd68 ffffffffa00d10cb ffffffffa010c243 ffff8800db7bbda0
[   23.929329]  ffffffffa00d1125 000000badb7bbda0 ffff880117dd8600 ffff8800db97a000
[   23.929330] Call Trace:
[   23.929336]  [<ffffffff8168730c>] dump_stack+0x45/0x56
[   23.929355]  [<ffffffffa00d101a0>] ? insert_kthread_work+0x40/0x40
[   24.033302]  [<ffffffff8169623c>] ret_from_fork+0x7c/0xb0
[   24.033304]  [<ffffffff8108f1a0>] ? insert_kthread_work+0x40/0x40
[   24.033306] XFS (vda1): Corruption detected. Unmount and run xfs_repair
[   24.033511] XFS (vda1): metadata I/O error: block 0x1212dd0 ("xfs_trans_read_buf_map") error 117 numblks 8
[   24.106127] ffff8800372a0000: 00 00 00 00 00 00 00 00 d2 f1 00 00 01 4d 00 92  .............M..
[   24.106128] ffff8800372a0010: 00 00 00 2e 00 00 00 02 00 00 17 2e 00 00 00 04  ................
[   24.106130] ffff8800372a0020: 14 10 19 e2 00 02 bc 02 14 10 19 e2 00 02 c2 a7  ................
[   24.106131] ffff8800372a0030: 14 10 19 e2 00 02 c5 d0 14 10 19 e2 00 02 c4 c8  ................
[   24.106134] XFS (vda1): Internal error __read_verify at line 186 of file fs/xfs/xfs_dir2_leaf.c.  Caller 0xffffffffa010c243
[   24.106137] CPU: 1 PID: 178 Comm: kworker/1:1H Not tainted 3.13.6-200.fc20.x86_64 #1
[   24.106138] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   24.106182] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[   24.106185]  0000000000000001 ffff8800db7bbd50 ffffffff8168730c ffff8800db97a000
[   24.106187]  ffff8800db7bbd68 ffffffffa00d10cb ffffffffa010c243 ffff8800db7bbda0
[   24.106189]  ffffffffa00d1125 000000badb7bbda0 ffff880117dd8780 ffff8800db97a000
[   24.106189] Call Trace:
[   24.106196]  [<ffffffff8168730c>] dump_stack+0x45/0x56
[   24.106215]  [<ffffffffa00d10cb>] xfs_error_report+0x3b/0x40 [xfs]
[   24.106239]  [<ffffffffa010c243>] ? xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   24.106257]  [<ffffffffa00d1125>] xfs_corruption_error+0x55/0x80 [xfs]
[   24.106280]  [<ffffffffa010c1b6>] __read_verify+0x76/0xf0 [xfs]
[   24.106303]  [<ffffffffa010c243>] ? xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   24.106326]  [<ffffffffa010c243>] xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   24.106344]  [<ffffffffa00ce245>] xfs_buf_iodone_work+0x85/0xf0 [xfs]
[   24.106347]  [<ffffffff81087b76>] process_one_work+0x176/0x430
[   24.106349]  [<ffffffff810887ab>] worker_thread+0x11b/0x1H Not tainted 3.13.6-200.fc20.x86_64 #1
[   24.282672] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   24.282672] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[   24.282672]  0000000000000001 ffff8800db7bbd50 ffffffff8168730c ffff8800db97a000
[   24.282672]  ffff8800db7bbd68 ffffffffa00d10cb ffffffffa010c243 ffff8800db7bbda0
[   24.282672]  ffffffffa00d1125 000000badb7bbda0 ffff880117dd8780 ffff8800db97a000
[   24.282672] Call Trace:
[   24.282672]  [<ffffffff8168730c>] dump_stack+0x45/0x56
[   24.282672]  [<ffffffffa00d10cb>] xfs_error_report+0x3b/0x40 [xfs]
[   24.282672]  [<ffffffffa010c243>] ? xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   24.282672]  [<ffffffffa00d1125>] xfs_corruption_error+0x55/0x80 [xfs]
[   24.282672]  [<ffffffffa010c1b6>] __read_verify+0x76/0xf0 [xfs]
[   24.282672]  [<ffffffffa010c243>] ? xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   24.282672]  [<ffffffffa010c243>] xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   24.282672]  [<ffffffffa00ce245>] xfs_buf_iodone_work+0x85/0xf0 [xfs]
[   24.282672]  [<ffffffff81087b76>] process_one_work+0x176/0x430
[   24.282672]  [<ffffffff810887ab>] worker_thread+0x11b/0x3a0
[   24.282672]  [<ffffffff81088690>] ? rescuer_thread+0x350/0x350
[   24.282672]  [<ffffffff8108f272>] kthread+0xd2/0xf0
[   24.282672]  [<ffffffff8108f1a0>] ? insert_kthread_work+0x40/0x40
[   24.282672]  [<ffffffff8169623c>] ret_from_fork+0x7c/0xb0
[   24.282672]  [<ffffffff8108f1a0>] ? insert_kthread_work+0x40/0x40
[   24.282672] XFS (vda1): Corruption detected. Unmount and run xfs_repair
[   24.296557] XFS (vda1): metadata I/O error: block 0x1212dd0 ("xfs_trans_read_buf_map") error 117 numblks 8
[   24.338934] ffff8800372a0000: 00 00 00 00 00 00 00 00 d2 f1 00 00 01 4d 00 92  .............M..
[   24.338935] ffff8800372a0010: 00 00 00 2e 00 00 00 02 00 00 17 2e 00 00 00 04  ................
[   24.338937] ffff8800372a0020: 14 10 19 e2 00 02 bc 02 14 10 19 e2 00 02 c2 a7  ................
[   24.338938] ffff8800372a0030: 14 10 19 e2 00 02 c5 d0 14 10 19 e2 00 02 c4 c8  ................
[   24.338941] XFS (vda1): Internal error __read_verify at line 186 of file fs/xfs/xfs_dir2_leaf.c.  Caller 0xffffffffa010c243
[   24.338945] CPU: 1 PID: 178 Comm: kworker/1:1H Not tainted 3.13.6-200.fc20.x86_64 #1
[   24.338945] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   24.338992] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[   24.338995]  0000000000000001 ffff8800db7bbd50 ffffffff8168730c ffff8800db97a000
[   24.338997]  ffff8800db7bbd68 ffffffffa00d10cb ffffffffa010c243 ffff8800db7bbda0
[   24.338999]  ffffffffa00d1125 000000badb7bbda0 ffff880117dd8780 ffff8800db97a000
[   24.339000] Call Trace:
[   24.339056]  [<ffffffff8168730c>] dump_stack+0x45/0x56
[   24.339077]  [<ffffffffa00d10cb>] xfs_error_report+0x3b/0x40 [xfs]
[   24.339104]  [<ffffffffa010c243>] ? xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   24.339124]  [<ffffffffa00d1125>] xfs_corruption_error+0x55/0x80 [xfs]
[   24.339150]  [<ffffffffa010c1b6>] __read_verify+0x76/0xf0 [xfs]
[   24.339176]  [<ffffffffa010c243>] ? xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   24.339202]  [<ffffffffa010c243>] xfs_dir3_leaf1_read_verify+0x13/0x20 [xfs]
[   24.339222]  [<ffffffffa00ce245>] xfs_buf_iodone_work+0x85/0xf0 [xfs]
[   24.339225]  [<ffffffff81087b76>] process_one_work+0x176/0x430
[   24.339227]  [<ffffffff810887ab>] worker_thread+0x11b/0x3a0
[   24.339229]  [<ffffffff81088690>] ? rescuer_thread+0x350/0x350
[   24.339232]  [<ffffffff8108f272>] kthread+0xd2/0xf0
[   24.339235]  [<ffffffff8108f1a0>] ? insert_kthread_work+0x40/0x40
[   24.339238]  [<ffffffff8169623c>] ret_from_fork+0x7c/0xb0
[   24.339240]  [<ffffffff8108f1a0>] ? insert_kthread_work+0x40/0x40
[   24.339242] XFS (vda1): Corruption detected. Unmount and run xfs_repair
[   24.340307] XFS (vda1): metadata I/O error: block 0x1212dd0 ("xfs_trans_read_buf_map") error 117 numblks 8


Bye,

  Hannes

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

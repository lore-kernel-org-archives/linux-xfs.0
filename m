Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 129BC7F81
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 09:43:29 -0600 (CST)
Date: Tue, 5 Mar 2013 09:43:25 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: xfs with kernel 3.8.1
Message-ID: <20130305154325.GJ22182@sgi.com>
References: <alpine.LRH.2.02.1303051331140.26003@mail.vlasiu.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1303051331140.26003@mail.vlasiu.net>
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
To: Gabriel VLASIU <gabriel@vlasiu.net>
Cc: xfs@oss.sgi.com

Hi Gabriel, 

   This is fixed in 3.8.2, by 

   commit	2cd182d6f0f

   xfs: xfs_bmap_add_attrfork_local is too generic
   commit 1e82379b018ceed0f0912327c60d73107dacbcb3 upstream. 

-Ben

On Tue, Mar 05, 2013 at 03:04:44PM +0200, Gabriel VLASIU wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> Hi!
> 
> I think there is something wrong with xfs in kernel 3.8.1 (x86_64).
> 
> While compiling kernel 3.8.2 (noarch section: rpmbuild -bb kernel.spec 
> - --target=noarch) I had this error:
> 
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912705] ffff88010e1bf000: 2f 68 6f 6d 65 2f 67 61 62 72 69 65 6c 2f 77 6f  /home/gabriel/wo
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912713] XFS (loop0): Internal error xfs_bmbt_verify at line 747 of file fs/xfs/xfs_bmap_btree.c.  Caller 0xffffffffa005b7fe
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912713] 
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912716] Pid: 497, comm: xfsaild/loop0 Tainted: GF        C O 3.8.1-201.AES.f18g.x86_64 #1
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912718] Call Trace:
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912768]  [<ffffffffa00311cf>] xfs_error_report+0x3f/0x50 [xfs]
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912786]  [<ffffffffa005b7fe>] ? xfs_bmbt_write_verify+0xe/0x10 [xfs]
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912799]  [<ffffffffa003123e>] xfs_corruption_error+0x5e/0x90 [xfs]
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912815]  [<ffffffffa005b7fe>] ? xfs_bmbt_write_verify+0xe/0x10 [xfs]
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912831]  [<ffffffffa005b6a6>] xfs_bmbt_verify+0x76/0x1c0 [xfs]
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912847]  [<ffffffffa005b7fe>] ? xfs_bmbt_write_verify+0xe/0x10 [xfs]
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912860]  [<ffffffffa002f615>] ? xfs_bdstrat_cb+0x65/0xd0 [xfs]
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912876]  [<ffffffffa005b7fe>] xfs_bmbt_write_verify+0xe/0x10 [xfs]
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912889]  [<ffffffffa002f16e>] _xfs_buf_ioapply+0x5e/0x370 [xfs]
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912894]  [<ffffffff81094060>] ? try_to_wake_up+0x2d0/0x2d0
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912907]  [<ffffffffa002f615>] ? xfs_bdstrat_cb+0x65/0xd0 [xfs]
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912920]  [<ffffffffa002f55a>] xfs_buf_iorequest+0x4a/0xa0 [xfs]
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912933]  [<ffffffffa002f615>] xfs_bdstrat_cb+0x65/0xd0 [xfs]
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912946]  [<ffffffffa002f7f1>] __xfs_buf_delwri_submit+0x171/0x1e0 [xfs]
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912960]  [<ffffffffa00301a0>] ? xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912979]  [<ffffffffa0089200>] ? xfs_trans_ail_cursor_first+0x80/0xb0 [xfs]
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912992]  [<ffffffffa00301a0>] xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
> Mar  5 12:50:21 xxxxxxx kernel: [93088.913002]  [<ffffffffa0089451>] xfsaild+0x221/0x5d0 [xfs]
> Mar  5 12:50:21 xxxxxxx kernel: [93088.913047]  [<ffffffffa0089230>] ? xfs_trans_ail_cursor_first+0xb0/0xb0 [xfs]
> Mar  5 12:50:21 xxxxxxx kernel: [93088.913058]  [<ffffffff81081f50>] kthread+0xc0/0xd0
> Mar  5 12:50:21 xxxxxxx kernel: [93088.913063]  [<ffffffff81010000>] ? ftrace_define_fields_xen_mc_entry+0xa0/0xf0
> Mar  5 12:50:21 xxxxxxx kernel: [93088.913065]  [<ffffffff81081e90>] ? kthread_create_on_node+0x120/0x120
> Mar  5 12:50:21 xxxxxxx kernel: [93088.913069]  [<ffffffff8165466c>] ret_from_fork+0x7c/0xb0
> Mar  5 12:50:21 xxxxxxx kernel: [93088.913072]  [<ffffffff81081e90>] ? kthread_create_on_node+0x120/0x120
> Mar  5 12:50:21 xxxxxxx kernel: [93088.913075] XFS (loop0): Corruption detected. Unmount and run xfs_repair
> Mar  5 12:50:21 xxxxxxx kernel: [93088.913081] XFS (loop0): xfs_do_force_shutdown(0x8) called from line 1358 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffffa002f441
> Mar  5 12:50:21 xxxxxxx kernel: [93088.913090] XFS (loop0): Corruption of in-memory data detected.  Shutting down filesystem
> Mar  5 12:50:21 xxxxxxx kernel: [93088.913094] XFS (loop0): Please umount the filesystem and rectify the problem(s)
> 
> Unmounted /home partition:
> 
> Mar  5 12:50:51 xxxxxxx kernel: [93118.944028] XFS (loop0): xfs_log_force: error 5 returned.
> Mar  5 12:51:21 xxxxxxx kernel: [93149.024021] XFS (loop0): xfs_log_force: error 5 returned.
> Mar  5 12:51:34 xxxxxxx kernel: [93162.227404] XFS (loop0): xfs_log_force: error 5 returned.
> Mar  5 12:51:34 xxxxxxx kernel: [93162.399230] XFS (loop0): xfs_log_force: error 5 returned.
> Mar  5 12:51:34 xxxxxxx kernel: [93162.484440] XFS (loop0): xfs_log_force: error 5 returned.
> 
> Mount /home:
> 
> Mar  5 12:52:15 xxxxxxx kernel: [93203.823908] XFS (loop0): Mounting Filesystem
> Mar  5 12:52:16 xxxxxxx kernel: [93203.921716] XFS (loop0): Starting recovery (logdev: internal)
> Mar  5 12:52:16 xxxxxxx kernel: [93203.925106] XFS (loop0): log record CRC mismatch: found 0x73ada7a8, expected 0x707caf70.
> Mar  5 12:52:16 xxxxxxx kernel: [93203.925106] 
> Mar  5 12:52:16 xxxxxxx kernel: [93203.926284] ffffc90010f80000: 00 00 00 29 00 00 00 60 69 00 00 00 4e 49 a4 81  ...)...`i...NI..
> Mar  5 12:52:16 xxxxxxx kernel: [93203.927457] ffffc90010f80010: 02 02 00 00 e8 03 00 00 e8 03 00 00 01 00 00 00  ................
> Mar  5 12:52:16 xxxxxxx kernel: [93203.955789] XFS (loop0): log record CRC mismatch: found 0x812d8b74, expected 0x804f4c8f.
> Mar  5 12:52:16 xxxxxxx kernel: [93203.955789] 
> Mar  5 12:52:16 xxxxxxx kernel: [93203.957064] ffffc90010f80000: 00 00 00 29 00 00 00 00 69 01 00 00 dd a9 1c 1e  ...)....i.......
> Mar  5 12:52:16 xxxxxxx kernel: [93203.958297] ffffc90010f80010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 12:52:16 xxxxxxx kernel: [93203.966873] XFS (loop0): log record CRC mismatch: found 0xfe2b5eb2, expected 0xcf6bdbcf.
> Mar  5 12:52:16 xxxxxxx kernel: [93203.966873] 
> Mar  5 12:52:16 xxxxxxx kernel: [93203.968220] ffffc90010f80000: 00 00 00 29 00 00 03 60 69 18 00 00 00 00 00 00  ...)...`i.......
> Mar  5 12:52:16 xxxxxxx kernel: [93203.969436] ffffc90010f80010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Mar  5 12:52:16 xxxxxxx kernel: [93203.973081] XFS (loop0): log record CRC mismatch: found 0x95245555, expected 0x8cbe76ce.
> Mar  5 12:52:16 xxxxxxx kernel: [93203.973081] 
> Mar  5 12:52:16 xxxxxxx kernel: [93203.974507] ffffc90010f80000: 00 00 00 29 00 00 00 48 69 18 00 00 00 00 00 00  ...)...Hi.......
> Mar  5 12:52:16 xxxxxxx kernel: [93203.975784] ffffc90010f80010: 00 00 01 00 c7 cd 35 51 e6 fe 0a 16 c7 cd 35 51  ......5Q......5Q
> Mar  5 12:52:16 xxxxxxx kernel: [93203.983811] XFS (loop0): log record CRC mismatch: found 0x73ada7a8, expected 0x707caf70.
> Mar  5 12:52:16 xxxxxxx kernel: [93203.983811] 
> Mar  5 12:52:16 xxxxxxx kernel: [93203.985372] ffffc90014c00000: 00 00 00 29 00 00 00 60 69 00 00 00 4e 49 a4 81  ...)...`i...NI..
> Mar  5 12:52:16 xxxxxxx kernel: [93203.986759] ffffc90014c00010: 02 02 00 00 e8 03 00 00 e8 03 00 00 01 00 00 00  ................
> Mar  5 12:52:16 xxxxxxx kernel: [93203.995116] XFS (loop0): log record CRC mismatch: found 0x812d8b74, expected 0x804f4c8f.
> Mar  5 12:52:16 xxxxxxx kernel: [93203.995116] 
> Mar  5 12:52:16 xxxxxxx kernel: [93203.996650] ffffc90014c00000: 00 00 00 29 00 00 00 00 69 01 00 00 dd a9 1c 1e  ...)....i.......
> Mar  5 12:52:16 xxxxxxx kernel: [93203.998018] ffffc90014c00010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 12:52:16 xxxxxxx kernel: [93204.006817] XFS (loop0): log record CRC mismatch: found 0xfe2b5eb2, expected 0xcf6bdbcf.
> Mar  5 12:52:16 xxxxxxx kernel: [93204.006817] 
> Mar  5 12:52:16 xxxxxxx kernel: [93204.008432] ffffc90014c00000: 00 00 00 29 00 00 03 60 69 18 00 00 00 00 00 00  ...)...`i.......
> Mar  5 12:52:16 xxxxxxx kernel: [93204.009808] ffffc90014c00010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Mar  5 12:52:16 xxxxxxx kernel: [93204.013573] XFS (loop0): log record CRC mismatch: found 0x95245555, expected 0x8cbe76ce.
> Mar  5 12:52:16 xxxxxxx kernel: [93204.013573] 
> Mar  5 12:52:16 xxxxxxx kernel: [93204.015169] ffffc90014c00000: 00 00 00 29 00 00 00 48 69 18 00 00 00 00 00 00  ...)...Hi.......
> Mar  5 12:52:16 xxxxxxx kernel: [93204.016560] ffffc90014c00010: 00 00 01 00 c7 cd 35 51 e6 fe 0a 16 c7 cd 35 51  ......5Q......5Q
> Mar  5 12:52:16 xxxxxxx kernel: [93204.825304] XFS (loop0): Ending recovery (logdev: internal)
> 
> Umount, xfs_repair, remount:
> 
> Mar  5 12:53:31 xxxxxxx kernel: [93278.958787] XFS (loop0): Mounting Filesystem
> Mar  5 12:53:31 xxxxxxx kernel: [93279.063396] XFS (loop0): Ending clean mount
> 
> 20 minutes later, recompiling kernel 3.8.1 (noarch) and running rsync 
> I had another error:
> 
> Mar  5 13:10:36 xxxxxxx kernel: [94304.726835] ffff880110756000: 2f 68 6f 6d 65 2f 67 61 62 72 69 65 6c 2f 77 6f  /home/gabriel/wo
> Mar  5 13:10:36 xxxxxxx kernel: [94304.726842] XFS (loop0): Internal error xfs_bmbt_verify at line 747 of file fs/xfs/xfs_bmap_btree.c.  Caller 0xffffffffa005b7fe
> Mar  5 13:10:36 xxxxxxx kernel: [94304.726842] 
> Mar  5 13:10:36 xxxxxxx kernel: [94304.726846] Pid: 25827, comm: xfsaild/loop0 Tainted: GF        C O 3.8.1-201.AES.f18g.x86_64 #1
> Mar  5 13:10:36 xxxxxxx kernel: [94304.726847] Call Trace:
> Mar  5 13:10:36 xxxxxxx kernel: [94304.726897]  [<ffffffffa00311cf>] xfs_error_report+0x3f/0x50 [xfs]
> Mar  5 13:10:36 xxxxxxx kernel: [94304.726914]  [<ffffffffa005b7fe>] ? xfs_bmbt_write_verify+0xe/0x10 [xfs]
> Mar  5 13:10:36 xxxxxxx kernel: [94304.726927]  [<ffffffffa003123e>] xfs_corruption_error+0x5e/0x90 [xfs]
> Mar  5 13:10:36 xxxxxxx kernel: [94304.726943]  [<ffffffffa005b7fe>] ? xfs_bmbt_write_verify+0xe/0x10 [xfs]
> Mar  5 13:10:36 xxxxxxx kernel: [94304.726959]  [<ffffffffa005b6a6>] xfs_bmbt_verify+0x76/0x1c0 [xfs]
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727062]  [<ffffffffa005b7fe>] ? xfs_bmbt_write_verify+0xe/0x10 [xfs]
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727075]  [<ffffffffa002f615>] ? xfs_bdstrat_cb+0x65/0xd0 [xfs]
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727091]  [<ffffffffa005b7fe>] xfs_bmbt_write_verify+0xe/0x10 [xfs]
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727104]  [<ffffffffa002f16e>] _xfs_buf_ioapply+0x5e/0x370 [xfs]
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727110]  [<ffffffff81094060>] ? try_to_wake_up+0x2d0/0x2d0
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727123]  [<ffffffffa002f615>] ? xfs_bdstrat_cb+0x65/0xd0 [xfs]
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727136]  [<ffffffffa002f55a>] xfs_buf_iorequest+0x4a/0xa0 [xfs]
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727149]  [<ffffffffa002f615>] xfs_bdstrat_cb+0x65/0xd0 [xfs]
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727162]  [<ffffffffa002f7f1>] __xfs_buf_delwri_submit+0x171/0x1e0 [xfs]
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727176]  [<ffffffffa00301a0>] ? xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727195]  [<ffffffffa0089201>] ? xfs_trans_ail_cursor_first+0x81/0xb0 [xfs]
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727209]  [<ffffffffa00301a0>] xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727227]  [<ffffffffa0089451>] xfsaild+0x221/0x5d0 [xfs]
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727246]  [<ffffffffa0089230>] ? xfs_trans_ail_cursor_first+0xb0/0xb0 [xfs]
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727251]  [<ffffffff81081f50>] kthread+0xc0/0xd0
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727256]  [<ffffffff81010000>] ? ftrace_define_fields_xen_mc_entry+0xa0/0xf0
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727258]  [<ffffffff81081e90>] ? kthread_create_on_node+0x120/0x120
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727262]  [<ffffffff8165466c>] ret_from_fork+0x7c/0xb0
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727265]  [<ffffffff81081e90>] ? kthread_create_on_node+0x120/0x120
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727267] XFS (loop0): Corruption detected. Unmount and run xfs_repair
> Mar  5 13:10:36 xxxxxxx kernel: [94304.727270] XFS (loop0): xfs_do_force_shutdown(0x8) called from line 1358 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffffa002f441
> Mar  5 13:10:37 xxxxxxx kernel: [94304.982635] XFS (loop0): Corruption of in-memory data detected.  Shutting down filesystem
> Mar  5 13:10:37 xxxxxxx kernel: [94304.982642] XFS (loop0): Please umount the filesystem and rectify the problem(s)
> Mar  5 13:10:37 xxxxxxx kernel: [94305.036039] XFS (loop0): xfs_log_force: error 5 returned.
> Mar  5 13:10:37 xxxxxxx kernel: [94305.087970] Buffer I/O error on device loop0, logical block 90997607
> Mar  5 13:10:37 xxxxxxx kernel: [94305.087975] lost page write due to I/O error on loop0
> Mar  5 13:10:37 xxxxxxx kernel: [94305.087980] Buffer I/O error on device loop0, logical block 90997608
> Mar  5 13:10:37 xxxxxxx kernel: [94305.087981] lost page write due to I/O error on loop0
> Mar  5 13:10:37 xxxxxxx kernel: [94305.087983] Buffer I/O error on device loop0, logical block 90997609
> Mar  5 13:10:37 xxxxxxx kernel: [94305.087984] lost page write due to I/O error on loop0
> Mar  5 13:10:37 xxxxxxx kernel: [94305.087986] Buffer I/O error on device loop0, logical block 90997610
> Mar  5 13:10:37 xxxxxxx kernel: [94305.087988] lost page write due to I/O error on loop0
> Mar  5 13:10:37 xxxxxxx kernel: [94305.087990] Buffer I/O error on device loop0, logical block 90997611
> Mar  5 13:10:37 xxxxxxx kernel: [94305.087991] lost page write due to I/O error on loop0
> Mar  5 13:10:37 xxxxxxx kernel: [94305.087993] Buffer I/O error on device loop0, logical block 90997612
> Mar  5 13:10:37 xxxxxxx kernel: [94305.087994] lost page write due to I/O error on loop0
> Mar  5 13:10:37 xxxxxxx kernel: [94305.087996] Buffer I/O error on device loop0, logical block 90997613
> Mar  5 13:10:37 xxxxxxx kernel: [94305.087997] lost page write due to I/O error on loop0
> Mar  5 13:10:37 xxxxxxx kernel: [94305.087999] Buffer I/O error on device loop0, logical block 90997614
> Mar  5 13:10:37 xxxxxxx kernel: [94305.088018] lost page write due to I/O error on loop0
> Mar  5 13:10:37 xxxxxxx kernel: [94305.088020] Buffer I/O error on device loop0, logical block 90997615
> Mar  5 13:10:37 xxxxxxx kernel: [94305.088021] lost page write due to I/O error on loop0
> Mar  5 13:10:37 xxxxxxx kernel: [94305.088023] Buffer I/O error on device loop0, logical block 90997616
> Mar  5 13:10:37 xxxxxxx kernel: [94305.088025] lost page write due to I/O error on loop0
> 
> Umount /home:
> 
> Mar  5 13:11:06 xxxxxxx kernel: [94334.816017] XFS (loop0): xfs_log_force: error 5 returned.
> Mar  5 13:11:37 xxxxxxx kernel: [94364.896026] XFS (loop0): xfs_log_force: error 5 returned.
> Mar  5 13:12:07 xxxxxxx kernel: [94394.976025] XFS (loop0): xfs_log_force: error 5 returned.
> Mar  5 13:12:08 xxxxxxx kernel: [94396.397569] XFS (loop0): xfs_log_force: error 5 returned.
> Mar  5 13:12:08 xxxxxxx kernel: [94396.798331] XFS (loop0): xfs_log_force: error 5 returned.
> Mar  5 13:12:08 xxxxxxx kernel: [94396.803897] XFS (loop0): xfs_log_force: error 5 returned.
> 
> Mount /home:
> 
> Mar  5 13:12:36 xxxxxxx kernel: [94424.276817] XFS (loop0): Mounting Filesystem
> Mar  5 13:12:36 xxxxxxx kernel: [94424.444206] XFS (loop0): Starting recovery (logdev: internal)
> Mar  5 13:12:36 xxxxxxx kernel: [94424.454409] XFS (loop0): log record CRC mismatch: found 0xe8dc0331, expected 0xb8afb9f5.
> Mar  5 13:12:36 xxxxxxx kernel: [94424.454409] 
> Mar  5 13:12:36 xxxxxxx kernel: [94424.454427] ffffc90014440000: 00 00 00 01 00 00 00 00 69 01 00 00 4f 3e 05 16  ........i...O>..
> Mar  5 13:12:36 xxxxxxx kernel: [94424.454434] ffffc90014440010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 13:12:36 xxxxxxx kernel: [94424.457657] XFS (loop0): log record CRC mismatch: found 0xca3729fa, expected 0x936285f8.
> Mar  5 13:12:36 xxxxxxx kernel: [94424.457657] 
> Mar  5 13:12:36 xxxxxxx kernel: [94424.457677] ffffc90014440000: 00 00 00 01 00 00 00 48 69 18 00 00 00 00 00 00  .......Hi.......
> Mar  5 13:12:36 xxxxxxx kernel: [94424.457685] ffffc90014440010: 00 00 00 00 3e d2 35 51 d3 4c a5 05 3e d2 35 51  ....>.5Q.L..>.5Q
> Mar  5 13:12:36 xxxxxxx kernel: [94424.459325] XFS (loop0): log record CRC mismatch: found 0x82df5071, expected 0x147787f2.
> Mar  5 13:12:36 xxxxxxx kernel: [94424.459325] 
> Mar  5 13:12:36 xxxxxxx kernel: [94424.459343] ffffc90014440000: 00 00 00 01 00 00 00 00 69 01 00 00 b6 da 4d 37  ........i.....M7
> Mar  5 13:12:36 xxxxxxx kernel: [94424.459351] ffffc90014440010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 13:12:36 xxxxxxx kernel: [94424.459825] XFS (loop0): log record CRC mismatch: found 0x81d60a0c, expected 0xa36fc6cf.
> Mar  5 13:12:36 xxxxxxx kernel: [94424.459825] 
> Mar  5 13:12:36 xxxxxxx kernel: [94424.459836] ffffc90014440000: 00 00 00 01 00 00 00 00 69 01 00 00 a0 58 d2 ca  ........i....X..
> Mar  5 13:12:36 xxxxxxx kernel: [94424.459842] ffffc90014440010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 13:12:36 xxxxxxx kernel: [94424.460452] XFS (loop0): log record CRC mismatch: found 0xd5e688af, expected 0x32f0716d.
> Mar  5 13:12:36 xxxxxxx kernel: [94424.460452] 
> Mar  5 13:12:36 xxxxxxx kernel: [94424.460466] ffffc90014440000: 00 00 00 01 00 00 00 00 69 01 00 00 7d a4 99 70  ........i...}..p
> Mar  5 13:12:36 xxxxxxx kernel: [94424.460473] ffffc90014440010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 13:12:36 xxxxxxx kernel: [94424.460904] XFS (loop0): log record CRC mismatch: found 0xaa2ac0a7, expected 0x94620a44.
> Mar  5 13:12:36 xxxxxxx kernel: [94424.460904] 
> Mar  5 13:12:36 xxxxxxx kernel: [94424.460915] ffffc90014440000: 00 00 00 01 00 00 00 00 69 01 00 00 43 53 3a 4f  ........i...CS:O
> Mar  5 13:12:36 xxxxxxx kernel: [94424.460921] ffffc90014440010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 13:12:36 xxxxxxx kernel: [94424.474642] XFS (loop0): log record CRC mismatch: found 0x924e1723, expected 0x89c0a34b.
> Mar  5 13:12:36 xxxxxxx kernel: [94424.474642] 
> Mar  5 13:12:36 xxxxxxx kernel: [94424.474661] ffffc90014440000: 00 00 00 01 00 00 00 00 69 01 00 00 05 3b b5 68  ........i....;.h
> Mar  5 13:12:36 xxxxxxx kernel: [94424.474668] ffffc90014440010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 13:12:36 xxxxxxx kernel: [94424.475512] XFS (loop0): log record CRC mismatch: found 0x1b8a4eb7, expected 0xa9b341a6.
> Mar  5 13:12:36 xxxxxxx kernel: [94424.475512] 
> Mar  5 13:12:36 xxxxxxx kernel: [94424.475529] ffffc90014440000: 00 00 00 01 00 00 00 00 69 01 00 00 1b e8 ad f5  ........i.......
> Mar  5 13:12:36 xxxxxxx kernel: [94424.475536] ffffc90014440010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 13:12:36 xxxxxxx kernel: [94424.478164] XFS (loop0): log record CRC mismatch: found 0xe7aaf329, expected 0x62577a0d.
> Mar  5 13:12:36 xxxxxxx kernel: [94424.478164] 
> Mar  5 13:12:36 xxxxxxx kernel: [94424.478181] ffffc90014440000: 00 00 00 01 00 00 00 00 69 01 00 00 5f 1b ed 49  ........i..._..I
> Mar  5 13:12:36 xxxxxxx kernel: [94424.478190] ffffc90014440010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 13:12:36 xxxxxxx kernel: [94424.478869] XFS (loop0): log record CRC mismatch: found 0x8b024d5d, expected 0xa6ddb6cf.
> Mar  5 13:12:36 xxxxxxx kernel: [94424.478869] 
> Mar  5 13:12:36 xxxxxxx kernel: [94424.479208] ffffc90014440000: 00 00 00 01 00 00 00 00 69 01 00 00 b1 f5 1e 94  ........i.......
> Mar  5 13:12:36 xxxxxxx kernel: [94424.480501] ffffc90014440010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 13:12:36 xxxxxxx kernel: [94424.489048] XFS (loop0): log record CRC mismatch: found 0xe8dc0331, expected 0xb8afb9f5.
> Mar  5 13:12:36 xxxxxxx kernel: [94424.489048] 
> Mar  5 13:12:36 xxxxxxx kernel: [94424.490737] ffffc90014480000: 00 00 00 01 00 00 00 00 69 01 00 00 4f 3e 05 16  ........i...O>..
> Mar  5 13:12:36 xxxxxxx kernel: [94424.492209] ffffc90014480010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 13:12:36 xxxxxxx kernel: [94424.496938] XFS (loop0): log record CRC mismatch: found 0xca3729fa, expected 0x936285f8.
> Mar  5 13:12:36 xxxxxxx kernel: [94424.496938] 
> Mar  5 13:12:36 xxxxxxx kernel: [94424.498729] ffffc90014480000: 00 00 00 01 00 00 00 48 69 18 00 00 00 00 00 00  .......Hi.......
> Mar  5 13:12:36 xxxxxxx kernel: [94424.500298] ffffc90014480010: 00 00 00 00 3e d2 35 51 d3 4c a5 05 3e d2 35 51  ....>.5Q.L..>.5Q
> Mar  5 13:12:37 xxxxxxx kernel: [94425.029493] XFS (loop0): log record CRC mismatch: found 0x82df5071, expected 0x147787f2.
> Mar  5 13:12:37 xxxxxxx kernel: [94425.029493] 
> Mar  5 13:12:37 xxxxxxx kernel: [94425.031376] ffffc90014480000: 00 00 00 01 00 00 00 00 69 01 00 00 b6 da 4d 37  ........i.....M7
> Mar  5 13:12:37 xxxxxxx kernel: [94425.032938] ffffc90014480010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 13:12:37 xxxxxxx kernel: [94425.069605] XFS (loop0): log record CRC mismatch: found 0x81d60a0c, expected 0xa36fc6cf.
> Mar  5 13:12:37 xxxxxxx kernel: [94425.069605] 
> Mar  5 13:12:37 xxxxxxx kernel: [94425.071520] ffffc90014480000: 00 00 00 01 00 00 00 00 69 01 00 00 a0 58 d2 ca  ........i....X..
> Mar  5 13:12:37 xxxxxxx kernel: [94425.073183] ffffc90014480010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 13:12:37 xxxxxxx kernel: [94425.082249] XFS (loop0): log record CRC mismatch: found 0xd5e688af, expected 0x32f0716d.
> Mar  5 13:12:37 xxxxxxx kernel: [94425.082249] 
> Mar  5 13:12:37 xxxxxxx kernel: [94425.084292] ffffc90014480000: 00 00 00 01 00 00 00 00 69 01 00 00 7d a4 99 70  ........i...}..p
> Mar  5 13:12:37 xxxxxxx kernel: [94425.085947] ffffc90014480010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 13:12:37 xxxxxxx kernel: [94425.092165] XFS (loop0): log record CRC mismatch: found 0xaa2ac0a7, expected 0x94620a44.
> Mar  5 13:12:37 xxxxxxx kernel: [94425.092165] 
> Mar  5 13:12:37 xxxxxxx kernel: [94425.094305] ffffc90014480000: 00 00 00 01 00 00 00 00 69 01 00 00 43 53 3a 4f  ........i...CS:O
> Mar  5 13:12:37 xxxxxxx kernel: [94425.096037] ffffc90014480010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 13:12:37 xxxxxxx kernel: [94425.111936] XFS (loop0): log record CRC mismatch: found 0x924e1723, expected 0x89c0a34b.
> Mar  5 13:12:37 xxxxxxx kernel: [94425.111936] 
> Mar  5 13:12:37 xxxxxxx kernel: [94425.114115] ffffc90014480000: 00 00 00 01 00 00 00 00 69 01 00 00 05 3b b5 68  ........i....;.h
> Mar  5 13:12:37 xxxxxxx kernel: [94425.115816] ffffc90014480010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 13:12:37 xxxxxxx kernel: [94425.527549] XFS (loop0): log record CRC mismatch: found 0x1b8a4eb7, expected 0xa9b341a6.
> Mar  5 13:12:37 xxxxxxx kernel: [94425.527549] 
> Mar  5 13:12:37 xxxxxxx kernel: [94425.529738] ffffc90014480000: 00 00 00 01 00 00 00 00 69 01 00 00 1b e8 ad f5  ........i.......
> Mar  5 13:12:37 xxxxxxx kernel: [94425.531521] ffffc90014480010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 13:12:37 xxxxxxx kernel: [94425.539719] XFS (loop0): log record CRC mismatch: found 0xe7aaf329, expected 0x62577a0d.
> Mar  5 13:12:37 xxxxxxx kernel: [94425.539719] 
> Mar  5 13:12:37 xxxxxxx kernel: [94425.541902] ffffc90014480000: 00 00 00 01 00 00 00 00 69 01 00 00 5f 1b ed 49  ........i..._..I
> Mar  5 13:12:37 xxxxxxx kernel: [94425.543659] ffffc90014480010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 13:12:38 xxxxxxx kernel: [94425.890080] XFS (loop0): log record CRC mismatch: found 0x8b024d5d, expected 0xa6ddb6cf.
> Mar  5 13:12:38 xxxxxxx kernel: [94425.890080] 
> Mar  5 13:12:38 xxxxxxx kernel: [94425.892186] ffffc90014480000: 00 00 00 01 00 00 00 00 69 01 00 00 b1 f5 1e 94  ........i.......
> Mar  5 13:12:38 xxxxxxx kernel: [94425.893932] ffffc90014480010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...
> Mar  5 13:12:38 xxxxxxx kernel: [94425.911651] XFS (loop0): Ending recovery (logdev: internal)
> 
> Umount, xfs_repair, mount.
> 
> Reboot with 3.7.9 (x86_64)
>   - full resync for whole directory tree (196Gb): no problems
>   - kernel re-compilation: no problems
> 
> Seems to be related to kernel tree directory:
> 
> Mar  5 12:50:21 xxxxxxx kernel: [93088.912705] ffff88010e1bf000: 2f 68 6f 6d 65 2f 67 61 62 72 69 65 6c 2f 77 6f  /home/gabriel/wo
> 
> I think the actual directory is /home/gabriel/work/rpm/BUILD/kernel-3.8.f18g/ ...
> 
> Is there any way I can debug this?
> 
> 
> Additional info:
> * kernel: 3.8.1 (x86_64)
> * xfs_repair version: 3.1.10
> * 1 cpu
> 
> # cat /proc/mounts | grep xfs | grep ^/dev
> /dev/sda2 / xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
> /dev/sdc1 /saves xfs rw,seclabel,nosuid,nodev,relatime,attr2,inode64,logbufs=8,logbsize=256k,noquota 0 0
> /dev/sdb1 /export xfs rw,seclabel,nosuid,nodev,relatime,attr2,inode64,logbufs=8,logbsize=256k,noquota 0 0
> /dev/loop6 /tmp xfs rw,seclabel,nosuid,nodev,noexec,relatime,attr2,inode64,noquota 0 0
> /dev/loop6 /var/tmp xfs rw,seclabel,nosuid,nodev,noexec,relatime,attr2,inode64,noquota 0 0
> /dev/loop0 /home xfs rw,seclabel,nosuid,nodev,relatime,attr2,inode64,logbufs=8,logbsize=256k,noquota 0 0
> 
> # cat /proc/partitions 
> major minor  #blocks  name
> 
>    8        0  488386584 sda
>    8        1     512000 sda1
>    8        2   20971520 sda2
>    8        3    2097152 sda3
>    8        4          1 sda4
>    8        5  462707712 sda5
>    8        6    2095104 sda6
>   11        0    1048575 sr0
>    8       32  312571224 sdc
>    8       33  312570200 sdc1
>    8       16  156290904 sdb
>    8       17  156289880 sdb1
>    7        0  462707704 loop0
>    7        6    2095104 loop6
>    7        7    2097148 loop7
> 
> # xfs_info /home
> meta-data=/dev/loop0             isize=256    agcount=4, agsize=28919232 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=115676926, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=56482, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> Sincerely,
> Gabriel
> 
> - -- 
> 
> // Gabriel VLASIU
> //
> // OpenGPG-KeyID      : 44952F15
> // OpenGPG-Fingerprint: 4AC5 7C26 2FE9 02DA 4906  24B2 D32B 7ED7 4495 2F15
> // OpenGPG-URL        : http://www.vlasiu.net/public.key
> 
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.13 (GNU/Linux)
> 
> iQIcBAEBCgAGBQJRNe1sAAoJENMrftdElS8Vrt8QALOWM3Gzph6TDWkGwcqyxTos
> o6X0jXfJxEn+pYdcMWh+h8x8poxfLFNxCn4yVqO5WdX4xqYq23BYO1VR0qqFueTT
> dNerqxQcvKn+HRi+hsME/GabDjI5RInvotZ2QVWjuqWk72F2qlIVnmvQtCXOm1lX
> 6Mkf18b0+voCgZG6eYHSftbRxc+Jme2lPl5fbUcGDeiANkkZbq0+YrfAp6u9KEOu
> CX5Pzss7oSDqTCVzy0X85Xw9f1txKEdjPbzZkMcTLFmVgB7zc/muViEmEiLljGjS
> DLtoONDoHU6cVTkfr7Uzjuv49vwSKNL/5qrtX05+GidUOAKQqGs90FR3wgMC9SHR
> Vo5RSbNVOEeRUkbhWa2mBemscD6teNujBnVkvVsWeeA9qdf4F5CldshfCdZocLhe
> Zy8qD/ZmoVJTgEzv5iksd4WzkpVnT5Vz0w59ETW3SkvIdceGwEFCE3PUS19Yb6Gr
> /OWj8bna+QtgtrEijbwdOPDDx6JrXXcYTtJk7m2R0LMRC3GymPeOiJSbrxFe8XTn
> s6o4QGZQczPkwL/+wQIDiijAQxBn/t9tRC36iunIA7hXRzmYhtgj9s6iXTmiLLJk
> NkdZ9jlg82RFenXaDDOMMdki2tgEmGZGpYDH81V/Nfi4VHDBjM0ZIjP0/2wWoUnA
> 9GYY2qWSGY3MNw28hlu9
> =RjjN
> -----END PGP SIGNATURE-----
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

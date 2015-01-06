Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E9357F50
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 06:18:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2A3AF304048
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 04:18:25 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fa9rkYzNByyWSsWw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 04:18:24 -0800 (PST)
Date: Tue, 6 Jan 2015 07:18:18 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs down
Message-ID: <20150106121817.GA5874@bfoster.bfoster>
References: <CAL2gTc0nwvHcdev_HPoiYfNyAuT-SVENjt5zhmm1X0NcVzqp6g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAL2gTc0nwvHcdev_HPoiYfNyAuT-SVENjt5zhmm1X0NcVzqp6g@mail.gmail.com>
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
To: Mingfan Lu <mingfan.lu@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 05, 2015 at 11:20:39AM +0800, Mingfan Lu wrote:
>  I saw such xfs corruption information in /var/log/messages, and the xfs
> partition could not be accessed now.
> Any suggestion? Just to run xfs_repair ?
> 

Note that this is a distro kernel...

It looks like something is up with an allocation btree block. The output
of 'xfs_repair -n' would be interesting. You might also want to provide
some basic info about the fs (xfs_info), etc.:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Brian

> 2015-01-04T23:01:26.130998+08:00 jylt kernel: ffff8808ede89000: 41 42 54 43
> 00 00 00 ff ff ff ff ff 00 00 00 00  ABTC............
> 2015-01-04T23:01:26.131024+08:00 jylt kernel: XFS (sdb): Internal error
> xfs_btree_check_sblock at line 120 of file fs/xfs/xfs_btree.c.  Caller
> 0xffffffffa0303d44
> 2015-01-04T23:01:26.131027+08:00 jylt kernel:
> 2015-01-04T23:01:26.138526+08:00 jylt kernel: Pid: 9163, comm: xfsalloc/10
> Not tainted 2.6.32-358.6.2.01.el6.x86_64 #1
> 2015-01-04T23:01:26.138537+08:00 jylt kernel: Call Trace:
> 2015-01-04T23:01:26.138542+08:00 jylt kernel: [<ffffffffa031732f>] ?
> xfs_error_report+0x3f/0x50 [xfs]
> 2015-01-04T23:01:26.138544+08:00 jylt kernel: [<ffffffffa0303d44>] ?
> xfs_btree_check_block+0x14/0x30 [xfs]
> 2015-01-04T23:01:26.138547+08:00 jylt kernel: [<ffffffffa031739e>] ?
> xfs_corruption_error+0x5e/0x90 [xfs]
> 2015-01-04T23:01:26.138549+08:00 jylt kernel: [<ffffffffa0303d44>] ?
> xfs_btree_check_block+0x14/0x30 [xfs]
> 2015-01-04T23:01:26.138551+08:00 jylt kernel: [<ffffffffa0303c8e>] ?
> xfs_btree_check_sblock+0xbe/0x160 [xfs]
> 2015-01-04T23:01:26.138553+08:00 jylt kernel: [<ffffffffa0303d44>] ?
> xfs_btree_check_block+0x14/0x30 [xfs]
> 2015-01-04T23:01:26.138555+08:00 jylt kernel: [<ffffffffa0336a4d>] ?
> xfs_trans_read_buf+0x5d/0x410 [xfs]
> 2015-01-04T23:01:26.138570+08:00 jylt kernel: [<ffffffffa0303d44>] ?
> xfs_btree_check_block+0x14/0x30 [xfs]
> 2015-01-04T23:01:26.138579+08:00 jylt kernel: [<ffffffffa0303ee9>] ?
> xfs_btree_read_buf_block+0xa9/0xd0 [xfs]
> 2015-01-04T23:01:26.138586+08:00 jylt kernel: [<ffffffffa02ef7b1>] ?
> xfs_allocbt_set_root+0x91/0xb0 [xfs]
> 2015-01-04T23:01:26.138589+08:00 jylt kernel: [<ffffffffa0306a49>] ?
> xfs_btree_new_root+0x229/0x550 [xfs]
> 2015-01-04T23:01:26.138591+08:00 jylt kernel: [<ffffffffa0307d58>] ?
> xfs_btree_insrec+0x348/0x5a0 [xfs]
> 2015-01-04T23:01:26.138593+08:00 jylt kernel: [<ffffffffa03058fc>] ?
> xfs_btree_delrec+0x3ac/0x10c0 [xfs]
> 2015-01-04T23:01:26.138595+08:00 jylt kernel: [<ffffffffa03025a2>] ?
> xfs_lookup_get_search_key+0x52/0x60 [xfs]
> 2015-01-04T23:01:26.138597+08:00 jylt kernel: [<ffffffffa0308043>] ?
> xfs_btree_insert+0x93/0x180 [xfs]
> 2015-01-04T23:01:26.138599+08:00 jylt kernel: [<ffffffffa02ebe58>] ?
> xfs_alloc_fixup_trees+0x138/0x350 [xfs]
> 2015-01-04T23:01:26.138606+08:00 jylt kernel: [<ffffffffa02ee43b>] ?
> xfs_alloc_ag_vextent_near+0x98b/0xb20 [xfs]
> 2015-01-04T23:01:26.138609+08:00 jylt kernel: [<ffffffffa02eec4d>] ?
> xfs_alloc_fix_freelist+0x40d/0x4a0 [xfs]
> 2015-01-04T23:01:26.138611+08:00 jylt kernel: [<ffffffffa02ee6a5>] ?
> xfs_alloc_ag_vextent+0xd5/0x100 [xfs]
> 2015-01-04T23:01:26.138614+08:00 jylt kernel: [<ffffffffa02ef0cc>] ?
> xfs_alloc_vextent+0x2bc/0x610 [xfs]
> 2015-01-04T23:01:26.138616+08:00 jylt kernel: [<ffffffffa02f97c7>] ?
> xfs_bmap_btalloc+0x267/0x700 [xfs]
> 2015-01-04T23:01:26.138618+08:00 jylt kernel: [<ffffffffa02f9c6e>] ?
> xfs_bmap_alloc+0xe/0x10 [xfs]
> 2015-01-04T23:01:26.138620+08:00 jylt kernel: [<ffffffffa02f9d4a>] ?
> xfs_bmapi_allocate_worker+0x4a/0x80 [xfs]
> 2015-01-04T23:01:26.138622+08:00 jylt kernel: [<ffffffffa02f9d00>] ?
> xfs_bmapi_allocate_worker+0x0/0x80 [xfs]
> 2015-01-04T23:01:26.138626+08:00 jylt kernel: [<ffffffff81090ae0>] ?
> worker_thread+0x170/0x2a0
> 2015-01-04T23:01:26.138629+08:00 jylt kernel: [<ffffffff81096ca0>] ?
> autoremove_wake_function+0x0/0x40
> 2015-01-04T23:01:26.138630+08:00 jylt kernel: [<ffffffff81090970>] ?
> worker_thread+0x0/0x2a0
> 2015-01-04T23:01:26.138632+08:00 jylt kernel: [<ffffffff81096936>] ?
> kthread+0x96/0xa0
> 2015-01-04T23:01:26.138634+08:00 jylt kernel: [<ffffffff8100c0ca>] ?
> child_rip+0xa/0x20
> 2015-01-04T23:01:26.138636+08:00 jylt kernel: [<ffffffff810968a0>] ?
> kthread+0x0/0xa0
> 2015-01-04T23:01:26.138638+08:00 jylt kernel: [<ffffffff8100c0c0>] ?
> child_rip+0x0/0x20
> 2015-01-04T23:01:26.138642+08:00 jylt kernel: XFS (sdb): Corruption
> detected. Unmount and run xfs_repair
> 2015-01-04T23:01:26.138644+08:00 jylt kernel: XFS (sdb): Internal error
> xfs_trans_cancel at line 1948 of file fs/xfs/xfs_trans.c.  Caller
> 0xffffffffa0322e0d
> 2015-01-04T23:01:26.138646+08:00 jylt kernel:
> 2015-01-04T23:01:26.138648+08:00 jylt kernel: Pid: 10003, comm: flush-8:16
> Not tainted 2.6.32-358.6.2.01.el6.x86_64 #1
> 2015-01-04T23:01:26.138655+08:00 jylt kernel: Call Trace:
> 2015-01-04T23:01:26.138657+08:00 jylt kernel: [<ffffffffa031732f>] ?
> xfs_error_report+0x3f/0x50 [xfs]
> 2015-01-04T23:01:26.138660+08:00 jylt kernel: [<ffffffffa0322e0d>] ?
> xfs_iomap_write_allocate+0x26d/0x370 [xfs]
> 2015-01-04T23:01:26.138662+08:00 jylt kernel: [<ffffffffa0334635>] ?
> xfs_trans_cancel+0xf5/0x120 [xfs]
> 2015-01-04T23:01:26.138664+08:00 jylt kernel: [<ffffffffa0322e0d>] ?
> xfs_iomap_write_allocate+0x26d/0x370 [xfs]
> 2015-01-04T23:01:26.138666+08:00 jylt kernel: [<ffffffffa033daf3>] ?
> xfs_map_blocks+0x193/0x250 [xfs]
> 2015-01-04T23:01:26.138668+08:00 jylt kernel: [<ffffffffa033e641>] ?
> xfs_vm_writepage+0x261/0x5a0 [xfs]
> 2015-01-04T23:01:26.138670+08:00 jylt kernel: [<ffffffff8112cb87>] ?
> __writepage+0x17/0x40
> 2015-01-04T23:01:26.138672+08:00 jylt kernel: [<ffffffff8112de99>] ?
> write_cache_pages+0x1c9/0x4b0
> 2015-01-04T23:01:26.138674+08:00 jylt kernel: [<ffffffff8112cb70>] ?
> __writepage+0x0/0x40
> 2015-01-04T23:01:26.138676+08:00 jylt kernel: [<ffffffff8112e1a4>] ?
> generic_writepages+0x24/0x30
> 2015-01-04T23:01:26.138678+08:00 jylt kernel: [<ffffffffa033d91d>] ?
> xfs_vm_writepages+0x5d/0x80 [xfs]
> 2015-01-04T23:01:26.138679+08:00 jylt kernel: [<ffffffff8112e1d1>] ?
> do_writepages+0x21/0x40
> 2015-01-04T23:01:26.138684+08:00 jylt kernel: [<ffffffff811ac78d>] ?
> writeback_single_inode+0xdd/0x290
> 2015-01-04T23:01:26.138686+08:00 jylt kernel: [<ffffffff811acb9e>] ?
> writeback_sb_inodes+0xce/0x180
> 2015-01-04T23:01:26.138688+08:00 jylt kernel: [<ffffffff811accfb>] ?
> writeback_inodes_wb+0xab/0x1b0
> 2015-01-04T23:01:26.138690+08:00 jylt kernel: [<ffffffff811ad09b>] ?
> wb_writeback+0x29b/0x3f0
> 2015-01-04T23:01:26.138692+08:00 jylt kernel: [<ffffffff8150dbb0>] ?
> thread_return+0x4e/0x76e
> 2015-01-04T23:01:26.138693+08:00 jylt kernel: [<ffffffff81081ae2>] ?
> del_timer_sync+0x22/0x30
> 2015-01-04T23:01:26.138695+08:00 jylt kernel: [<ffffffff811ad389>] ?
> wb_do_writeback+0x199/0x240
> 2015-01-04T23:01:26.138699+08:00 jylt kernel: [<ffffffff811ad493>] ?
> bdi_writeback_task+0x63/0x1b0
> 2015-01-04T23:01:26.138701+08:00 jylt kernel: [<ffffffff81096b67>] ?
> bit_waitqueue+0x17/0xd0
> 2015-01-04T23:01:26.138703+08:00 jylt kernel: [<ffffffff8113cb20>] ?
> bdi_start_fn+0x0/0x100
> 2015-01-04T23:01:26.138705+08:00 jylt kernel: [<ffffffff8113cba6>] ?
> bdi_start_fn+0x86/0x100
> 2015-01-04T23:01:26.138707+08:00 jylt kernel: [<ffffffff8113cb20>] ?
> bdi_start_fn+0x0/0x100
> 2015-01-04T23:01:26.138709+08:00 jylt kernel: [<ffffffff81096936>] ?
> kthread+0x96/0xa0
> 2015-01-04T23:01:26.138710+08:00 jylt kernel: [<ffffffff8100c0ca>] ?
> child_rip+0xa/0x20
> 2015-01-04T23:01:26.138712+08:00 jylt kernel: [<ffffffff810968a0>] ?
> kthread+0x0/0xa0
> 2015-01-04T23:01:26.138716+08:00 jylt kernel: [<ffffffff8100c0c0>] ?
> child_rip+0x0/0x20
> 2015-01-04T23:01:26.138727+08:00 jylt kernel: XFS (sdb):
> xfs_do_force_shutdown(0x8) called from line 1949 of file
> fs/xfs/xfs_trans.c.  Return address = 0xffffffffa033464e
> 2015-01-04T23:01:26.138729+08:00 jylt kernel: XFS (sdb): Corruption of
> in-memory data detected.  Shutting down filesystem
> 2015-01-04T23:01:26.138731+08:00 jylt kernel: XFS (sdb): Please umount the
> filesystem and rectify the problem(s)
> 2015-01-04T23:01:29.367810+08:00 jylt data1-jy_ugc_mams_source_cold[3406]:
> [2015-01-04 15:01:29.359018] M
> [posix-helpers.c:1502:posix_health_check_thread_proc]
> 0-jy_ugc_mams_source_cold-posix: health-check failed, going down

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

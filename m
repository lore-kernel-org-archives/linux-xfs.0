Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 17:26:50 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F0Qlnt026567
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 17:26:47 -0700
Message-ID: <48F546ED.6050702@sgi.com>
Date: Wed, 15 Oct 2008 11:27:09 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: fw: [PATCH] fix instant oops with tracing enabled
References: <20081013223932.GE10716@disturbed> <48F3EA6F.9000209@sgi.com> <20081014131140.GB17351@lst.de>
In-Reply-To: <20081014131140.GB17351@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Mark Goodwin <markgw@sgi.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Tue, Oct 14, 2008 at 10:40:15AM +1000, Mark Goodwin wrote:
>> Lachlan also saw some regressions after merging these patchsets :
>> . replace the mount inode list with radix tree traversals
>> . clean up sync code
> 
> What exactly?  I saw some softlookup in 042, but when applying Dave's
> xfs_sync_inodeS_ag fix (or the hal of it applying without the del inodes
> tracking in the radix tree) it goes away.

I saw this panic but I don't think it's related to the above patches:

[252921.307588] BUG: unable to handle kernel <3>BUG: scheduling while atomic: dd/16976/0xf101da90
[252921.307908] Modules linked in:
[252921.307911] Pid: 16976, comm: dd Not tainted 2.6.27-rc8 #183
[252921.307913] 
[252921.307913] Call Trace:
[252921.307920]  [<ffffffff8102fe22>] __schedule_bug+0x62/0x66
[252921.307923]  [<ffffffff8153dce1>] schedule+0x99/0x7c7
[252921.307925]  [<ffffffff8153e890>] schedule_timeout+0x22/0xb4
[252921.307929]  [<ffffffff810473f9>] ? add_wait_queue_exclusive+0x3c/0x41
[252921.307932]  [<ffffffff81198bc9>] xlog_state_get_iclog_space+0xe8/0x278
[252921.307934]  [<ffffffff8102de2d>] ? default_wake_function+0x0/0xf
[252921.307936]  [<ffffffff81198e6d>] xlog_write+0x114/0x579
[252921.307938]  [<ffffffff811761d5>] ? xfs_buf_item_pin+0x76/0x7b
[252921.307940]  [<ffffffff811993a7>] xfs_log_write+0x38/0x62
[252921.307943]  [<ffffffff811a4f6b>] _xfs_trans_commit+0x1fd/0x3c6
[252921.307945]  [<ffffffff81193e93>] xfs_iomap_write_allocate+0x2d5/0x387
[252921.307947]  [<ffffffff81194e07>] xfs_iomap+0x331/0x3ba
[252921.307950]  [<ffffffff811b0930>] xfs_map_blocks+0x30/0x69
[252921.307952]  [<ffffffff811b1a00>] xfs_page_state_convert+0x2e5/0x594
[252921.307953]  [<ffffffff811b1f1b>] ? xfs_vm_releasepage+0xae/0xbd
[252921.307955]  [<ffffffff811b1ff1>] xfs_vm_writepage+0xc7/0x109
[252921.307958]  [<ffffffff81080835>] shrink_page_list+0x31a/0x57c
[252921.307960]  [<ffffffff81080be3>] shrink_inactive_list+0x126/0x39d
[252921.307962]  [<ffffffff81080f3f>] shrink_zone+0xe5/0x10a
[252921.307964]  [<ffffffff81081436>] try_to_free_pages+0x248/0x3cf
[252921.307966]  [<ffffffff8108042f>] ? isolate_pages_global+0x0/0x34
[252921.307967]  [<ffffffff8107cc3c>] __alloc_pages_internal+0x262/0x3b6
[252921.307969]  [<ffffffff811b4284>] ? xfs_buf_get_flags+0x6b/0x165
[252921.307972]  [<ffffffff8109709f>] alloc_pages_current+0xb9/0xc2
[252921.307974]  [<ffffffff8109d66b>] new_slab+0x57/0x283
[252921.307975]  [<ffffffff8109daeb>] __slab_alloc+0x1e8/0x3dd
[252921.307977]  [<ffffffff811b0220>] ? kmem_zone_alloc+0x58/0xaa
[252921.307980]  [<ffffffff811638c1>] ? xfs_bmap_search_multi_extents+0x9a/0xda
[252921.307982]  [<ffffffff8109e07e>] kmem_cache_alloc+0x43/0x76
[252921.307983]  [<ffffffff811b0220>] kmem_zone_alloc+0x58/0xaa
[252921.307985]  [<ffffffff811b0281>] kmem_zone_zalloc+0xf/0x31
[252921.307986]  [<ffffffff811a555c>] _xfs_trans_alloc+0x25/0x5f
[252921.307988]  [<ffffffff811a562c>] xfs_trans_alloc+0x96/0xa1
[252921.307990]  [<ffffffff81193d05>] xfs_iomap_write_allocate+0x147/0x387
[252921.307991]  [<ffffffff81194db4>] ? xfs_iomap+0x2de/0x3ba
[252921.307993]  [<ffffffff81194e07>] xfs_iomap+0x331/0x3ba
[252921.307995]  [<ffffffff811b0930>] xfs_map_blocks+0x30/0x69
[252921.307996]  [<ffffffff811b1a00>] xfs_page_state_convert+0x2e5/0x594
[252921.307998]  [<ffffffff811b1ff1>] xfs_vm_writepage+0xc7/0x109
[252921.307999]  [<ffffffff8107cec6>] __writepage+0x12/0x2b
[252921.308001]  [<ffffffff8107d39a>] write_cache_pages+0x1b3/0x317
[252921.308003]  [<ffffffff8107ceb4>] ? __writepage+0x0/0x2b
[252921.308004]  [<ffffffff8107d51d>] generic_writepages+0x1f/0x25
[252921.308006]  [<ffffffff811b20ca>] xfs_vm_writepages+0x43/0x4b
[252921.308007]  [<ffffffff8107d54b>] do_writepages+0x28/0x37
[252921.308011]  [<ffffffff810bfd82>] __writeback_single_inode+0x145/0x29f
[252921.308015]  [<ffffffff812283c5>] ? prop_fraction_single+0x3d/0x5f
[252921.308017]  [<ffffffff810c0294>] generic_sync_sb_inodes+0x1d0/0x2ba
[252921.308019]  [<ffffffff810c0387>] sync_sb_inodes+0x9/0xb
[252921.308021]  [<ffffffff810c06f3>] writeback_inodes+0x64/0xad
[252921.308023]  [<ffffffff8107da26>] balance_dirty_pages_ratelimited_nr+0x16b/0x2dd
[252921.308027]  [<ffffffff8107769f>] generic_file_buffered_write+0x203/0x625
[252921.308028]  [<ffffffff8107c16d>] ? get_page_from_freelist+0x45e/0x5d0
[252921.308031]  [<ffffffff811b8b80>] ? xfs_rw_enter_trace+0xbf/0xca
[252921.308032]  [<ffffffff811b9641>] xfs_write+0x64f/0x9cf
[252921.308035]  [<ffffffff81076b4e>] ? find_lock_page+0x2b/0x61
[252921.308037]  [<ffffffff811b50c3>] __xfs_file_write+0x4c/0x4e
[252921.308038]  [<ffffffff811b50e9>] xfs_file_aio_write+0x11/0x13
[252921.308040]  [<ffffffff810a2f94>] do_sync_write+0xe2/0x126
[252921.308042]  [<ffffffff81084935>] ? __do_fault+0x326/0x36c
[252921.308044]  [<ffffffff810471d3>] ? autoremove_wake_function+0x0/0x38
[252921.308047]  [<ffffffff811e8618>] ? selinux_file_permission+0x10d/0x116
[252921.308050]  [<ffffffff811e1321>] ? security_file_permission+0x11/0x13
[252921.308052]  [<ffffffff810a3790>] vfs_write+0xae/0x157
[252921.308053]  [<ffffffff810a3c9e>] sys_write+0x47/0x6f
[252921.308055]  [<ffffffff8100bf3b>] system_call_fastpath+0x16/0x1b
[252921.308056] 
[252921.308125] paging request at ffff881829c85a78
[252921.308125] IP: [<ffffffff810297a3>] cpuacct_charge+0x2b/0x34
[252921.308125] PGD 202063 PUD 0 
[252921.308125] Oops: 0000 [1] SMP 


I saw sync get stuck in an infinite loop running test 042 - maybe the same
problem you saw.

[1]kdb> btp 7356
Stack traceback for pid 7356
0xffff880071d10740     7356     7390  1    2   R  0xffff880071d10ba8  sync
sp                ip                Function (args)
0xffff880058cc3c88 0xffffffff81540566 kdb_interrupt+0x66 (0xffff8800720e4ac4, 0x202, 0x0, 0xffff88007119b810, 0xffff880058cc3d48, 0xffff88007213deb8)
0xffff880058cc3ce8 0xffffffff8153ff8e _spin_unlock_irqrestore+0x8 (0xffff8800720e4ac4, 0x202)
0xffff880058cc3d20 0xffffffff81229b96 __down_read_trylock+0x3f (invalid)
0xffff880058cc3d40 0xffffffff8104a34d down_read_trylock+0x9
0xffff880058cc3d50 0xffffffff8118bcd9 xfs_ilock_nowait+0xaf (0xffff8800720e4a00, invalid)
0xffff880058cc3d80 0xffffffff811bc3d9 xfs_sync_inodes_ag+0x12a (0xffff88007119b800, invalid, invalid, 0x0)
0xffff880058cc3e00 0xffffffff811bc6ee xfs_sync_inodes+0x65 (0xffff88007119b800, invalid, 0x0)
0xffff880058cc3e40 0xffffffff811bc785 xfs_syncsub+0x67 (0xffff88007119b800, invalid, 0x0)
0xffff880058cc3e80 0xffffffff811bc9d0 xfs_sync+0x7d (0xffff88007119b800, invalid)
0xffff880058cc3eb0 0xffffffff811ba6b9 xfs_fs_sync_super+0x38 (0xffff88007e056000)
0xffff880058cc3f20 0xffffffff810a5311 sync_filesystems+0xb7 (invalid)
0xffff880058cc3f50 0xffffffff810c2deb do_sync+0x37 (0x1)
0xffff880058cc3f70 0xffffffff810c2e25 sys_sync+0xe
  not matched: from 0xffffffff8100bfad to 0xffffffff8100c025 drop_through 0 bb_jmp[7


I saw the panic in _xfs_itrace_exit() which has now been fixed.

And I also saw this assertion:

<4>[34770.626472] Assertion failed: (index >= 0) && (index < ktp->kt_nentries), file: fs/xfs/support/ktrace.c, line: 173
<0>[34770.626511] ------------[ cut here ]------------
<2>[34770.627419] kernel BUG at fs/xfs/support/debug.c:81!

[2]kdb> bt
Stack traceback for pid 400
0xffff88007e883a00      400        2  1    2   R  0xffff88007e883e68 *xfslogd/2
sp                ip                Function (args)
0xffff88007e66fbf8 0xffffffff811bd5d5 assfail+0x1a (invalid, invalid, invalid)
0xffff88007e66fc28 0xffffffff811bdb24 ktrace_enter+0x8b (invalid, invalid, invalid, invalid, invalid, invalid, invalid, invalid, invalid)
0xffff88007e66fc78 0xffffffff81175b35 xfs_buf_item_trace+0xe6 (0xffffffff816d8948, 0xffff88007c47cb40)
0xffff88007e66fd18 0xffffffff81175b60 xfs_buf_item_committed+0x1c (0xffff88007c47cb40, 0x100000b1f)
0xffff88007e66fd38 0xffffffff811a4766 xfs_trans_chunk_committed+0x60 (0xffff880050124780, 0x100000b1f, invalid)
0xffff88007e66fd98 0xffffffff811a4873 xfs_trans_committed+0x43 (0xffff880050124670, invalid)
0xffff88007e66fdc8 0xffffffff81197b2a xlog_state_do_callback+0x19a (0xffff88007ef78400, invalid, 0xffff88007ef79000)
0xffff88007e66fe38 0xffffffff81197d6d xlog_state_done_syncing+0xda (0xffff88007ef79000, invalid)
0xffff88007e66fe68 0xffffffff81198587 xlog_iodone+0x154 (0xffff88006ac37c80)
0xffff88007e66fe98 0xffffffff811b3afb xfs_buf_iodone_work+0x65 (invalid)
0xffff88007e66feb8 0xffffffff81043cfb run_workqueue+0x7c (0xffff88007e866b80)
0xffff88007e66fed8 0xffffffff81044711 worker_thread+0xd8 (0xffff88007e866b80)
0xffff88007e66ff28 0xffffffff810470a3 kthread+0x49 (invalid)
0xffff88007e66ff48 0xffffffff8100ce89 child_rip+0xa (invalid, invalid)


> 
>>> If that
>>> series is going to be included in the current round of checkins
>>> then this patch probably isn't needed.
>> The agreed plan for 2.6.28 still has the following patchsets to go in:
>>
>> . Combine the XFS and Linux inode structures V2
>> . Track reclaimable inodes in inode cache
>> . AIL cleanup and bug fixes
>> . Account for allocated blocks when expanding directories
>> . Check for valid transaction headers in recovery
>> . fix remount rw with unrecognized options
> 
> 
> 3-6 are small bug fixes and should go in ASAP.  I'd really like to see 1
> and 2 and volunter to help sorting out any fallout.  Not entirely sure
> about the AIL patches - they seem ready but at least they don't have
> much impact on everything else.   So if you really want to reduce the
> amount of patches those would be the ones.
> 
> 
> 

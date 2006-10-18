Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Oct 2006 23:55:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9I6tfaG020693
	for <xfs@oss.sgi.com>; Tue, 17 Oct 2006 23:55:43 -0700
Date: Wed, 18 Oct 2006 16:54:58 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: xfs mounting problem, hdb1 just freezes
Message-ID: <44C178671B335D901A3FC0FB@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <200610162114.36314.peyytmek@gmx.de>
References: <200610162114.36314.peyytmek@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: peyytmek@gmx.de, xfs@oss.sgi.com

Hi,

--On 16 October 2006 9:14:35 PM +0000 peyytmek@gmx.de wrote:

> I've got a problem with my xfs-partition after my pc crashed.
> Every programm that tries to use hdb1 just freezes like mount or even
> xfs_check (even killall -9 proc-name doesn't help)
>
> thats what i get with dmesg. maybe someone of you can understand it.
>

It was in the log recovery code.
Part of the recovery code processes the unlinked list, which has
referenced inodes which have been unlinked from their parent directories.
On the unclean unmount ("pc crashed"), during recovery it is supposed
to delete these inodes and truncate their extents, so it can recover
the space etc...
During this processing we've died in xfs_bmap_search_extents when
it detects an error it calls xfs_cmn_err CE_ALERT -> cmn_err CE_PANIC
in support/debug.c.
I guess there is a problem after it processes the extents in
xfs_bmap_search_multiextents which sets up the found extent entry.
You could print out the offending inode with xfs_db to show us
what it looks like: $xfs_db -r /dev/hdb1 -c "inode 950759" -c "print".

Interestingly with an older xfs we never did inode unlink processing
because of a double endian conversion bug which Shailendra found.
So without the fix, it ended up just skipping over these inodes and
they were cleaned up until xfs_repair was used; but it would still
do the actual log replay nonetheless.

So it would be interesting to do a recovery without unlinked-list
processing. It looks like we have a mount flag for this but
are not setting it (used by something else) - d'oh.
Do you have a kernel dated prior to May 26?
It might be interesting to mount with it since it didn't do
the unlink processing effectively. Then one could unmount straight afterwards
and run repair.

--Tim


> thanks in advance.
>
> dmesg on hdb1 on boot:
>
> XFS mounting filesystem hdb1
> Starting XFS recovery on filesystem: hdb1 (logdev: internal)
> Access to block zero: fs: <hdb1> inode: 950759 start_block : 0 start_off : 0
> blkcnt : 0 extent-state : 0
> ------------[ cut here ]------------
> kernel BUG at fs/xfs/support/debug.c:57!
> invalid opcode: 0000 [#1]
> PREEMPT
> Modules linked in:
> CPU:    0
> EIP:    0060:[<c03378f9>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.18-gentoo #7)
> EIP is at cmn_err+0xb9/0xe0
> eax: 00000000   ebx: 00000297   ecx: ffffffff   edx: 00004301
> esi: f78c97a0   edi: c064e2e0   ebp: 00000000   esp: f7c9b75c
> ds: 007b   es: 007b   ss: 0068
> Process mount (pid: 2114, ti=f7c9a000 task=f7c5d050 task.ti=f7c9a000)
> Stack: c0556f3b c052284a c064e2e0 f7c9b788 f7c9b8f8 f78c97a0 f7c9b93c 00000000
>        c02dec27 00000000 c0548610 f7cd54c0 000e81e7 00000000 00000000 00000000
>        00000000 00000000 00000000 00000000 00000000 00000000 00000001 00000000
> Call Trace:
>  [<c02dec27>] xfs_bmap_search_extents+0x117/0x120
>  [<c02e23d4>] xfs_bunmapi+0x1d4/0x1db0
>  [<c04070c0>] ide_dma_exec_cmd+0x30/0x40
>  [<c0406773>] ide_dma_start+0x33/0x50
>  [<c03fea22>] ide_do_request+0x682/0x830
>  [<c03fe33c>] ide_end_request+0x14c/0x160
>  [<c0147658>] mempool_alloc+0x38/0x120
>  [<c0147658>] mempool_alloc+0x38/0x120
>  [<c034fcf6>] as_set_request+0x26/0x80
>  [<c0143f5c>] find_lock_page+0x2c/0xc0
>  [<c02e2200>] xfs_bunmapi+0x0/0x1db0
>  [<c030672f>] xfs_itruncate_finish+0x28f/0x460
>  [<c0329198>] xfs_inactive+0x668/0xca0
>  [<c032f233>] xfs_buf_get_flags+0x293/0x4a0
>  [<c032f474>] xfs_buf_read_flags+0x34/0xa0
>  [<c031dfcc>] xfs_trans_read_buf+0x5c/0x3e0
>  [<c032df74>] xfs_buf_offset+0x44/0x50
>  [<c0336c3e>] xfs_fs_clear_inode+0x3e/0xa0
>  [<c018063a>] clear_inode+0x5a/0xe0
>  [<c01807b6>] generic_delete_inode+0xf6/0x130
>  [<c0314ca9>] xlog_recover_process_iunlinks+0x559/0x580
>  [<c032e3ab>] xfs_buf_free+0x5b/0x110
>  [<c03150a2>] xlog_recover_finish+0x3d2/0x510
>  [<c03368db>] xfs_initialize_vnode+0x3ab/0x3c0
>  [<c03029c9>] xfs_iget+0x429/0x737
>  [<c03198a0>] xfs_mountfs+0xe40/0x1060
>  [<c0116d20>] default_wake_function+0x0/0x20
>  [<c04fe527>] __down_failed+0x7/0xc
>  [<c034aff0>] generic_unplug_device+0x0/0x40
>  [<c032e485>] xfs_buf_rele+0x25/0xe0
>  [<c03218d1>] xfs_mount+0x6e1/0xa60
>  [<c0336a5d>] xfs_fs_fill_super+0x9d/0x240
>  [<c035a78b>] snprintf+0x2b/0x30
>  [<c01a3b98>] disk_name+0x98/0xd0
>  [<c016cd3f>] sb_set_blocksize+0x1f/0x50
>  [<c016c30b>] get_sb_bdev+0x13b/0x180
>  [<c0335aa7>] xfs_fs_get_sb+0x37/0x40
>  [<c03369c0>] xfs_fs_fill_super+0x0/0x240
>  [<c016bfec>] vfs_kern_mount+0x4c/0xa0
>  [<c016c0b2>] do_kern_mount+0x42/0x60
>  [<c018464d>] do_mount+0x28d/0x730
>  [<c017646d>] link_path_walk+0x7d/0x100
>  [<c017ec43>] dput+0x23/0x190
>  [<c0174fe1>] putname+0x31/0x40
>  [<c0176720>] do_path_lookup+0xb0/0x2e0
>  [<c01750a1>] getname+0xb1/0x100
>  [<c016f4af>] vfs_stat+0x1f/0x30
>  [<c01498b4>] __get_free_pages+0x34/0x60
>  [<c0182fe4>] copy_mount_options+0x44/0x130
>  [<c0184b8d>] sys_mount+0x9d/0xe0
>  [<c010318b>] syscall_call+0x7/0xb
> Code: e0 e2 64 c0 c7 04 24 3b 6f 55 c0 89 44 24 04 e8 7e 37 de ff 53 9d 89 e0
> 25 00 e0 ff ff ff 48 14 8b 40 08 a8 08 75 20 85 ed 75 08 <0f> 0b 39 00 b8 ec
> 52 c0 8b 5c 24 10 8b 74 24 14 8b 7c 24 18 8b
> EIP: [<c03378f9>] cmn_err+0xb9/0xe0 SS:ESP 0068:f7c9b75c
>  <6>Adding 1004020k swap on /dev/hda6.  Priority:-1 extents:1 across:1004020k
>

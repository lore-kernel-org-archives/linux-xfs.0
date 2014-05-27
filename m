Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B2C307F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 17:20:05 -0500 (CDT)
Received: from eagdhcp-232-192.americas.sgi.com
	(eagdhcp-232-192.americas.sgi.com [128.162.232.192])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8F431304043
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 15:20:02 -0700 (PDT)
Message-ID: <53850F92.7010401@sgi.com>
Date: Tue, 27 May 2014 17:20:02 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/7] xfs: add support FALLOC_FL_COLLAPSE_RANGE for
	fallocate
References: <1378132151-2685-1-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1378132151-2685-1-git-send-email-linkinjeon@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 09/02/13 09:29, Namjae Jeon wrote:
> From: Namjae Jeon<namjae.jeon@samsung.com>
>
> Add support FALLOC_FL_COLLAPSE_RANGE for fallocate.
>
> Signed-off-by: Namjae Jeon<namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan<a.sangwan@samsung.com>
> ---

> +		/* Check if we can merge 2 adjacent extents */
> +		if ((state & BMAP_LEFT_VALID) && !(state & BMAP_LEFT_DELAY) &&
> +		    left.br_startoff + left.br_blockcount == startoff &&
> +		    left.br_startblock + left.br_blockcount ==
> +		    xfs_bmbt_get_startblock(gotp) &&
> +		    xfs_bmbt_get_state(gotp) == left.br_state &&
> +		    left.br_blockcount + xfs_bmbt_get_blockcount(gotp) <=
> +		    MAXEXTLEN) {
> +			blockcount =
> +			left.br_blockcount + xfs_bmbt_get_blockcount(gotp);
> +			state |= BMAP_LEFT_CONTIG;
> +			xfs_iext_remove(ip, *current_ext, 1, 0);
> +			XFS_IFORK_NEXT_SET(ip, whichfork,
> +				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
> +			gotp = xfs_iext_get_ext(ifp, --*current_ext);
> +		}
> +
> +		if (cur) {
> +			error = xfs_bmbt_lookup_eq(cur,
> +					xfs_bmbt_get_startoff(gotp),
> +					xfs_bmbt_get_startblock(gotp),
> +					xfs_bmbt_get_blockcount(gotp),
> +					&i);
> +			if (error)
> +				goto del_cursor;
> +			XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);

I can reliably trigger this XFS_WANT_CORRUPTED_GOTO() with a fsstress 
that fills the filesystem:

xfstests > ltp/fsstress -d /mnt/scratch -s 1370236858 -p 512 -n 8192 &

xfstests > xfs_info /mnt/scratch
meta-data=/dev/sda7              isize=256    agcount=4, agsize=2228515 blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=0
data     =                       bsize=4096   blocks=8914059, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=4352, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


  XFS: Assertion failed: fs_is_ok, file: fs/xfs/xfs_bmap.c, line: 5511
  ------------[ cut here ]------------
  kernel BUG at fs/xfs/xfs_message.c:107!
  invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
  Modules linked in: e1000e xfs exportfs libcrc32c ext3 jbd
  CPU: 3 PID: 6341 Comm: fsstress Not tainted 3.15.0-rc5+ #1
  Hardware name: SGI.COM AltixXE210/S5000PAL0,
  BIOS S5000.86B.11.00.0096.011320091422 01/13/2009
  task: ffff88081ec991a0 ti: ffff88081ecca000 task.ti: ffff88081ecca000
  RIP: 0010:[<ffffffffa005a7cd>]  [<ffffffffa005a7cd>] assfail+0x1d/0x30 
[xfs]
  RSP: 0018:ffff88081eccbcd8  EFLAGS: 00010296
  RAX: 0000000000000044 RBX: 0000000000000000 RCX: 0000000000000000
  RDX: ffff88085bccda50 RSI: ffff88085bccd1c8 RDI: ffff88085bccd1c8
  RBP: ffff88081eccbcd8 R08: 0000000000000316 R09: 0000000000000003
  R10: 0000000000000316 R11: 0000000000000006 R12: 00000000000002d6
  R13: ffff88009f778d00 R14: ffff88081eccbe10 R15: ffff8807fa0d4000
  FS:  00007fd496c57700(0000) GS:ffff88085bcc0000(0000) 
knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  CR2: 00007fd4902e0e88 CR3: 000000081ecbc000 CR4: 00000000000007e0
  Stack:
   ffff88081eccbda8 ffffffffa00769f4 ffff8805df5bbba0 0000000000000079
   ffff88081eccbe14 ffff8805ddff5b00 0000000000000000 ffff8807fa0d4040
   0000000100000001 ffff88066a5ddef0 00000000000002c5 0000000000c11a01
  Call Trace:
  [<ffffffffa00769f4>] xfs_bmap_shift_extents+0x184/0x5a0 [xfs]
   [<ffffffffa0047c7c>] xfs_collapse_file_space+0x15c/0x250 [xfs]
   [<ffffffffa004e094>] xfs_file_fallocate+0x354/0x380 [xfs]
   [<ffffffff81142564>] ? __sb_start_write+0x64/0xf0
   [<ffffffff81274e0c>] ? selinux_file_permission+0xec/0x130
   [<ffffffff8113f270>] do_fallocate+0x150/0x170
   [<ffffffff8113f2de>] SyS_fallocate+0x4e/0x80
   [<ffffffff817b42e2>] system_call_fastpath+0x16/0x1b
  Code: 00 00 00 48 89 45 c8 e8 42 fc ff ff c9 c3 55 41 89 d0 48 89 f1 
48 89 fa 48 c7 c6 d0 3b 0d a0 31 ff 48 89 e5 31 c0 e8 93 ff ff ff <0f> 
0b eb fe 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 0f
  RIP  [<ffffffffa005a7cd>] assfail+0x1d/0x30 [xfs]
  RSP <ffff88081eccbcd8>
  ---[ end trace 40b8d37513d3de71 ]---
  Kernel panic - not syncing: Fatal exception
  Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range:
  0xffffffff80000000-0xffffffff9fffffff)
  ---[ end Kernel panic - not syncing: Fatal exception

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

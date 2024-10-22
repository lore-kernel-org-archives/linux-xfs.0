Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7870112D75C;
	Tue, 22 Oct 2024 09:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729590095; cv=none; b=ouubt2TkMZEnMy4NcwEca3ZInA5+7oqdNJW0r4u0JlYlLQfDCuzrvxBTfXa9ArocsIZhMahNpS8AsVDLMcbUwwRC+7tNKW9oomEQiwv+u0nIGo5d2pQhB1qkDTllqax6DBArVCyQutrStMDJZavIh7evHNDn+Lgg6g2sHUD/G3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729590095; c=relaxed/simple;
	bh=kPVRiPC9TYHCWiC2pBOneIy2rUZwZM1FlOA2gTuQRoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UdaDZ9SW0nFm/4NM1r7Rln9SKpFDk8dmGPBE4TUie36n+xZka92CRgxabNuaY3/eICh1XnsAxKnUGDZ4xyAVB1lzSVqC/TthnxgM+gRariUGXPk5nIW/EszJfbUo0P2dPZWvMShRhxbe2UNNQj1VP/bUiUupMOFve1bzYkfJftc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g6BFGtgC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g6BFGtgC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6thVadB+XojYdUKZxZ9UGvHdWNgMOLYyvruHcIkUskE=; b=g6BFGtgC1/NivGXVN0d0BOrHBt
	1Ll8LBLuPQszY/cehw48BCMQk1E9/n3Ury0q7gyw/MI38iPHNDnRjYguG8VJdqAJuSFgONrn3ojlc
	8xl5LI5quIYUowLW4Y3AeTjP5ZSYX6fF2XUhCDrQfSvgIIUxo2cg5KgmUI3W39pgc9QLLaJpVPuB7
	ERnspYUF7ySHCt8LxxW11+e8r52JBKs241EfsoABekdaAIOVMuA8M7rijolnn9U3MadFgZein9KJb
	fVcQMEIyjpxCbYVcWy2Ea+KgXWzAfD4XiKXEedex6k7uSyRZdjOlLQMCTWs8LnRfWbJrJF7I3eF7c
	5knNZ3uA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t3BOO-0000000AOCf-2aky;
	Tue, 22 Oct 2024 09:41:32 +0000
Date: Tue, 22 Oct 2024 02:41:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: syzbot <syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com>
Cc: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] KASAN: null-ptr-deref Write in
 xfs_filestream_select_ag (2)
Message-ID: <ZxdzTL4UYZtgsIiK@infradead.org>
References: <6712b052.050a0220.10f4f4.001a.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6712b052.050a0220.10f4f4.001a.GAE@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

#syz test git://git.infradead.org/users/hch/misc.git xfs-filesystems-pick-fix

On Fri, Oct 18, 2024 at 12:00:34PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4d939780b705 Merge tag 'mm-hotfixes-stable-2024-10-17-16-0..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=169f4c5f980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=164d2822debd8b0d
> dashboard link: https://syzkaller.appspot.com/bug?extid=4125a3c514e3436a02e6
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1374d830580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/cbc7a4f0dff1/disk-4d939780.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/21165b36b232/vmlinux-4d939780.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/8e42c5595828/bzImage-4d939780.xz
> mounted in repro #1: https://storage.googleapis.com/syzbot-assets/9171ce715585/mount_0.gz
> mounted in repro #2: https://storage.googleapis.com/syzbot-assets/faf0b43468d6/mount_2.gz
> mounted in repro #3: https://storage.googleapis.com/syzbot-assets/12ac0c5a53d1/mount_14.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: null-ptr-deref in instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
> BUG: KASAN: null-ptr-deref in atomic_inc include/linux/atomic/atomic-instrumented.h:435 [inline]
> BUG: KASAN: null-ptr-deref in xfs_filestream_create_association fs/xfs/xfs_filestream.c:320 [inline]
> BUG: KASAN: null-ptr-deref in xfs_filestream_select_ag+0x13ed/0x1d80 fs/xfs/xfs_filestream.c:371
> Write of size 4 at addr 0000000000000010 by task syz.1.56/5898
> 
> CPU: 0 UID: 0 PID: 5898 Comm: syz.1.56 Not tainted 6.12.0-rc3-syzkaller-00217-g4d939780b705 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>  print_report+0xe8/0x550 mm/kasan/report.c:491
>  kasan_report+0x143/0x180 mm/kasan/report.c:601
>  kasan_check_range+0x282/0x290 mm/kasan/generic.c:189
>  instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
>  atomic_inc include/linux/atomic/atomic-instrumented.h:435 [inline]
>  xfs_filestream_create_association fs/xfs/xfs_filestream.c:320 [inline]
>  xfs_filestream_select_ag+0x13ed/0x1d80 fs/xfs/xfs_filestream.c:371
>  xfs_bmap_btalloc_filestreams fs/xfs/libxfs/xfs_bmap.c:3657 [inline]
>  xfs_bmap_btalloc fs/xfs/libxfs/xfs_bmap.c:3774 [inline]
>  xfs_bmapi_allocate+0x162d/0x3450 fs/xfs/libxfs/xfs_bmap.c:4189
>  xfs_bmapi_convert_one_delalloc fs/xfs/libxfs/xfs_bmap.c:4697 [inline]
>  xfs_bmapi_convert_delalloc+0x9a0/0x1970 fs/xfs/libxfs/xfs_bmap.c:4752
>  xfs_map_blocks+0x7b7/0x1050 fs/xfs/xfs_aops.c:363
>  iomap_writepage_map_blocks fs/iomap/buffered-io.c:1855 [inline]
>  iomap_writepage_map fs/iomap/buffered-io.c:2003 [inline]
>  iomap_writepages+0xd49/0x2ac0 fs/iomap/buffered-io.c:2057
>  xfs_vm_writepages+0xfc/0x150 fs/xfs/xfs_aops.c:477
>  do_writepages+0x35d/0x870 mm/page-writeback.c:2683
>  filemap_fdatawrite_wbc+0x125/0x180 mm/filemap.c:398
>  __filemap_fdatawrite_range mm/filemap.c:431 [inline]
>  file_write_and_wait_range+0x195/0x280 mm/filemap.c:788
>  xfs_file_fsync+0x1d3/0xa80 fs/xfs/xfs_file.c:138
>  generic_write_sync include/linux/fs.h:2871 [inline]
>  xfs_file_buffered_write+0x9a8/0xac0 fs/xfs/xfs_file.c:799
>  new_sync_write fs/read_write.c:590 [inline]
>  vfs_write+0xa6d/0xc90 fs/read_write.c:683
>  ksys_write+0x183/0x2b0 fs/read_write.c:736
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f11d7b7dff9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f11d75de038 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007f11d7d36208 RCX: 00007f11d7b7dff9
> RDX: 0000000000000048 RSI: 0000000020020cc0 RDI: 0000000000000004
> RBP: 00007f11d7bf0296 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 00007f11d7d36208 R15: 00007ffcddfd4a88
>  </TASK>
> ==================================================================
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 
---end quoted text---

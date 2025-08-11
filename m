Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E827A4315A;
	Mon, 11 Aug 2025 17:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754931833; cv=none; b=V0qc/n4uVdIMHl30vNnEMEXnnfpRntzGpn2fjABkQTqWchrnngmjuIKDbh3ZmgaoYT8vrcT6rLCc1NTXPJ0RPkYMw01yQSfmvcWX27WKKJM9wnaH2RyF/g+Ez9BcieGbQDomXqGkEoe41CIMPeDx12ihqm6/k1pXaJdwoO2I+XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754931833; c=relaxed/simple;
	bh=RZ4Xn5x99Iohk2SsgoK9CjPxsvI7/acqpqiyZ65sYy4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=rPuZ9xNFdKBMGMQujgogEJDIx+x63kyjRNXyLJoHaxVLFebaBK1XK+zjdQQm8YqiCcnB+BmwPaZu4UrwM8aWPIlz2X239cSIOrprGSQvgnfoFcy0q994V2j8DzrMJWsKZuD2KukM65UIYHGEA2+0FDWivRrIDLFwlBaJLeS167s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KiNx85BK; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KiNx85BK"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-76be8e4b59aso3897776b3a.1;
        Mon, 11 Aug 2025 10:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754931830; x=1755536630; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iX14DYwhOjoqHJjk6Hzvdkyymk2hGJQIHbw2BvR4PQ8=;
        b=KiNx85BKHbHdrhx9iT9uanNJIWdTpQNfsVOxxKSqaitRfK8oYwq8jl6Nfu2JX1IuJt
         KNnJKOY3givxfqLE7HD/38NmTjGEYezbJp3ChobK4iTFoekRVz4l5Z/1ncxYKCjOUvKJ
         7nn50nc+P+OWb7aCJSsNSBb5Vr1aTfHi804nhLFfr1GAc7Bv6LOohZPj5lQZZZDL0Tbi
         8i2LvQ0RoBQfE78W8ADkEzxL+cu7tPumVjhM0pXmd1aI5xWO5esz9chaGinNq+j36t+C
         PoDoS67s86sao1I/CZUHzUXI0+HRBRPnoPS6WQ7/DD/cVWPQVMlMQMeVufjgSBCP/qUk
         nxyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754931830; x=1755536630;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iX14DYwhOjoqHJjk6Hzvdkyymk2hGJQIHbw2BvR4PQ8=;
        b=et3lsfWcOqONWsUKPeeQZNAV1g9uGjQ2k9A88ubcdE6UxqZBJUbr3PYcEC4A1jaeRi
         u5cPXtX11e05GqxVMLpU27NhGk/bxbhNz8sy+BatfGYTKFoeQMi05ShZLiiSbHIyEQcr
         oblts/4oLBC0NcATNLgQE5KHUPEkPpNFzMXG775fiybWoke30R/DOngA5t7I2neIBMxh
         SlS/tzMpYFSloQbsFA5wGjEU/1UhiFbv5b1dOkmYAyDKYEqPYSKplzQ2WUqlwxgMpmVy
         jmxwChd1fxUsDKeBsXL5obNIFYX9PcqJ33BXwlFruah7WGKFo0iKaB6m4W7XU36IMYq+
         FYzg==
X-Forwarded-Encrypted: i=1; AJvYcCUmI3tWL4lEYTl9JtathoOYdNSoMX/QYfQtrfLw3ipspS+A9MtfwqCHMN5FM4cS+JrJK2W8RJSntnx+@vger.kernel.org, AJvYcCXble7mysw37f/qEVB3BjLvW0plc2iRl1LXXGRd91twTnhwzP4Dutj4rMemh5N3NguhKUAgbbC5C5X6d1k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwI0KZ5Ld8l9A6jXqcvyxRHEfUfTnd8QMvoJEldHNFJreMnb66I
	Ptls5oY0k9AsQpWQh2cP+b5C2zvoIQEd5DKCq03pn+/BZCbPX7rW9OY5
X-Gm-Gg: ASbGncsH0bOuZWgKTrvMG0st0/XjGVQWJ1/tXh2qXDP1DRKzs66u7kJwcfsTVL5Wnla
	QX+Mu4oR6TuT0TvW1qTVWig62Eum6hVxJygabZRk/sSJZLZFtyh89J0N2LpqlbK+3UtUGJuCQ/G
	TWkLMiSZWdruoI50goLUC3ueLkZVszFOKk6zbXtytI2Mf5Cdl+haBy5gTqrmK09Fyemqx38gQvq
	YNSFf2bFaVAADZIFtUUIyOa0B01L4GRPWqbBHmLfmV0uAFFS+3+5UZ7oWrOdespNDwAmzkxnXUT
	ZLHBLv4nvgEFReiygyQlojqKJXCzAZtMpersyB/25nbGEW5UiOLuHTZ8edsZlaPIRJr1UIZlfTJ
	egpN14g==
X-Google-Smtp-Source: AGHT+IFT0OcJ1xJtCV0k7Ma7XK7fzyKAbYxp6Win+80ipmR/n9p/cAlh65fRdoEMDCzkC95PB7DFhQ==
X-Received: by 2002:a05:6a20:5493:b0:240:116b:cc41 with SMTP id adf61e73a8af0-24055046d7fmr17800459637.16.1754931829992;
        Mon, 11 Aug 2025 10:03:49 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bdbda5f23sm24719715b3a.112.2025.08.11.10.03.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Aug 2025 10:03:49 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_icwalk_ag (3)
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <689a0c9f.050a0220.51d73.009e.GAE@google.com>
Date: Tue, 12 Aug 2025 01:03:34 +0800
Cc: cem@kernel.org,
 linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <79A94075-25CD-4B0B-B9E0-6C8650174D18@gmail.com>
References: <689a0c9f.050a0220.51d73.009e.GAE@google.com>
To: syzbot <syzbot+789028412a4af61a2b61@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On Aug 11, 2025, at 23:30, syzbot =
<syzbot+789028412a4af61a2b61@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    6e64f4580381 Merge tag 'input-for-v6.17-rc0' of =
git://git...
> git tree:       upstream
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D170e0ea2580000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3Dff0ac94f5fb505cf
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3D789028412a4af61a2b61
> compiler:       Debian clang version 20.1.7 =
(++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD =
20.1.7
>=20
> Unfortunately, I don't have any reproducer for this issue yet.
>=20
> Downloadable assets:
> disk image (non-bootable): =
https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_dis=
k-6e64f458.raw.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/6b0d7c92b652/vmlinux-6e64f458=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/541b13915f7e/bzImage-6e64f458=
.xz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+789028412a4af61a2b61@syzkaller.appspotmail.com
>=20
> loop0: detected capacity change from 0 to 32768
> XFS (loop0): DAX unsupported by block device. Turning off DAX.
> XFS (loop0): Mounting V5 Filesystem =
c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Ending clean mount
> XFS (loop0): Quotacheck needed: Please wait.
> XFS (loop0): Quotacheck: Done.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: possible recursive locking detected
> 6.16.0-syzkaller-11952-g6e64f4580381 #0 Not tainted
> --------------------------------------------
> syz.0.0/5359 is trying to acquire lock:
> ffff88805250f758 (&xfs_nondir_ilock_class){++++}-{4:4}, at: =
xfs_reclaim_inode fs/xfs/xfs_icache.c:1042 [inline]
> ffff88805250f758 (&xfs_nondir_ilock_class){++++}-{4:4}, at: =
xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1734 [inline]
> ffff88805250f758 (&xfs_nondir_ilock_class){++++}-{4:4}, at: =
xfs_icwalk_ag+0x12c5/0x1ab0 fs/xfs/xfs_icache.c:1816
>=20
> but task is already holding lock:
> ffff8880525327d8 (&xfs_nondir_ilock_class){++++}-{4:4}, at: =
xfs_bmap_punch_delalloc_range+0x26d/0x7c0 fs/xfs/xfs_bmap_util.c:452
>=20
> other info that might help us debug this:
> Possible unsafe locking scenario:
>=20
>       CPU0
>       ----
>  lock(&xfs_nondir_ilock_class);
>  lock(&xfs_nondir_ilock_class);
>=20
> *** DEADLOCK ***
>=20
> May be due to missing lock nesting notation
>=20
> 4 locks held by syz.0.0/5359:
> #0: ffff8880525329f0 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: =
xfs_ilock+0xfe/0x390 fs/xfs/xfs_inode.c:149
> #1: ffff888052532b90 (mapping.invalidate_lock#3){+.+.}-{4:4}, at: =
filemap_invalidate_lock include/linux/fs.h:924 [inline]
> #1: ffff888052532b90 (mapping.invalidate_lock#3){+.+.}-{4:4}, at: =
xfs_buffered_write_iomap_end+0x2b6/0x4c0 fs/xfs/xfs_iomap.c:1993
> #2: ffff8880525327d8 (&xfs_nondir_ilock_class){++++}-{4:4}, at: =
xfs_bmap_punch_delalloc_range+0x26d/0x7c0 fs/xfs/xfs_bmap_util.c:452
> #3: ffff888043ac40e0 (&type->s_umount_key#50){.+.+}-{4:4}, at: =
super_trylock_shared fs/super.c:563 [inline]
> #3: ffff888043ac40e0 (&type->s_umount_key#50){.+.+}-{4:4}, at: =
super_cache_scan+0x91/0x4b0 fs/super.c:197
>=20
> stack backtrace:
> CPU: 0 UID: 0 PID: 5359 Comm: syz.0.0 Not tainted =
6.16.0-syzkaller-11952-g6e64f4580381 #0 PREEMPT(full)=20
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS =
1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Call Trace:
> <TASK>
> dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
> print_deadlock_bug+0x28b/0x2a0 kernel/locking/lockdep.c:3041
> check_deadlock kernel/locking/lockdep.c:3093 [inline]
> validate_chain+0x1a3f/0x2140 kernel/locking/lockdep.c:3895
> __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
> lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
> down_write_nested+0x9d/0x200 kernel/locking/rwsem.c:1706
> xfs_reclaim_inode fs/xfs/xfs_icache.c:1042 [inline]
> xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1734 [inline]
> xfs_icwalk_ag+0x12c5/0x1ab0 fs/xfs/xfs_icache.c:1816
> xfs_icwalk fs/xfs/xfs_icache.c:1864 [inline]
> xfs_reclaim_inodes_nr+0x1e3/0x260 fs/xfs/xfs_icache.c:1108
> super_cache_scan+0x41b/0x4b0 fs/super.c:228
> do_shrink_slab+0x6ef/0x1110 mm/shrinker.c:437
> shrink_slab+0xd74/0x10d0 mm/shrinker.c:664
> shrink_one+0x28a/0x7c0 mm/vmscan.c:4954
> shrink_many mm/vmscan.c:5015 [inline]
> lru_gen_shrink_node mm/vmscan.c:5093 [inline]
> shrink_node+0x314e/0x3760 mm/vmscan.c:6078
> shrink_zones mm/vmscan.c:6336 [inline]
> do_try_to_free_pages+0x668/0x1960 mm/vmscan.c:6398
> try_to_free_pages+0x8a2/0xdd0 mm/vmscan.c:6644
> __perform_reclaim mm/page_alloc.c:4310 [inline]
> __alloc_pages_direct_reclaim+0x144/0x300 mm/page_alloc.c:4332
> __alloc_pages_slowpath+0x5ff/0xce0 mm/page_alloc.c:4781
> __alloc_frozen_pages_noprof+0x319/0x370 mm/page_alloc.c:5161
> alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
> alloc_frozen_pages_noprof mm/mempolicy.c:2487 [inline]
> alloc_pages_noprof+0xa9/0x190 mm/mempolicy.c:2507
> stack_depot_save_flags+0x777/0x860 lib/stackdepot.c:677
> kasan_save_stack mm/kasan/common.c:48 [inline]
> kasan_save_track+0x4f/0x80 mm/kasan/common.c:68
> poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
> __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:405
> kasan_kmalloc include/linux/kasan.h:260 [inline]
> __do_kmalloc_node mm/slub.c:4365 [inline]
> __kmalloc_node_track_caller_noprof+0x271/0x4e0 mm/slub.c:4384
> __do_krealloc mm/slub.c:4942 [inline]
> krealloc_noprof+0x124/0x340 mm/slub.c:4995

__GFP_NOLOCKDEP doesn=E2=80=99t work correctly.

> xfs_iext_realloc_root fs/xfs/libxfs/xfs_iext_tree.c:613 [inline]
> xfs_iext_insert_raw+0x131/0x3260 fs/xfs/libxfs/xfs_iext_tree.c:647
> xfs_iext_insert+0x36/0x220 fs/xfs/libxfs/xfs_iext_tree.c:684
> xfs_bmap_del_extent_delay+0x105b/0x15b0 fs/xfs/libxfs/xfs_bmap.c:4787
> xfs_bmap_punch_delalloc_range+0x536/0x7c0 fs/xfs/xfs_bmap_util.c:483
> xfs_buffered_write_iomap_end+0x2d2/0x4c0 fs/xfs/xfs_iomap.c:1994
> iomap_iter+0x316/0xde0 fs/iomap/iter.c:79
> iomap_file_buffered_write+0x7fa/0x9b0 fs/iomap/buffered-io.c:1065
> xfs_file_buffered_write+0x209/0x8a0 fs/xfs/xfs_file.c:981
> aio_write+0x535/0x7a0 fs/aio.c:1634
> __io_submit_one fs/aio.c:-1 [inline]
> io_submit_one+0x78b/0x1310 fs/aio.c:2053
> __do_sys_io_submit fs/aio.c:2112 [inline]
> __se_sys_io_submit+0x185/0x2f0 fs/aio.c:2082
> do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f17f498ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 =
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f17f5846038 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
> RAX: ffffffffffffffda RBX: 00007f17f4bb5fa0 RCX: 00007f17f498ebe9
> RDX: 0000200000000540 RSI: 0000000000000008 RDI: 00007f17f5804000
> RBP: 00007f17f4a11e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f17f4bb6038 R14: 00007f17f4bb5fa0 R15: 00007ffe6a2d5798
> </TASK>
> syz.0.0 (5359) used greatest stack depth: 19048 bytes left
>=20
>=20
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>=20
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>=20
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>=20
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>=20
> If you want to undo deduplication, reply with:
> #syz undup
>=20


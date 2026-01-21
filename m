Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA49C3B8D46;
	Wed, 21 Jan 2026 19:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769023428; cv=none; b=W9s9rdX7sNLiP+LQ+KhEUqa156u3RgPUXoADuF+7feOZjfGNkTi0sUq5OOCoOsxebectEpq7s3cgi666aGg+BfMR6NfEuxb4kj2j6FpERaw4z0h4QyKB4jy19baD1IdrqXXQeE2ZN7IA3QJGlWiQ0D483vEWH42cz7CoripTjdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769023428; c=relaxed/simple;
	bh=A1zYgC5LMXRf+4mzL12j2nVzFVrCMCG0EdpHHZncR5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IhVT/ImnaJ41UifwqrZijslxU6mJHdFyp6PNWkVVT1QG+gHGBWP6o8MX59TDozNFdKHpWezzWa2VTrqFEUsNLuWVPUj32l3U1e6BBP6cYWt8QZ/XTogX9CIW7pcoG6RDl1piryLwBjzq58vOAHPS/raG1DqLhfMyr0wcFJAMKPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sydOlgCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sydOlgCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC25C4CEF1;
	Wed, 21 Jan 2026 19:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769023427;
	bh=A1zYgC5LMXRf+4mzL12j2nVzFVrCMCG0EdpHHZncR5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sydOlgCCDBlNLiJ4nn2pJa3Nen5QmypGAwVVtW13hGO2BzbKdmY3891IUvycBU14n
	 pWlY/+Z1AHM7/6is6G36x9wDy9OXfb/A01h7jxqx1uH++hH+HiLkASjq6q9OHK1ueh
	 yAY5OrTLjOkArs/9Q6PUPZaw+ZOdKWSuUp/dkuGqMSEo0cICnbAYF1rZvDSyGFGmoe
	 CorZaa39MdwYC4ves0VODV/1st0aghUR16dyvvX+xSNtZ9cnHJvQieSfp8A1xvkxH1
	 kjxzGwZWC6Hn/0vAk7N/hgDQp4XXBSqwjoFAD5eqWsiWSZ+J3uozDt5tbsd4iKzWIp
	 XQOe67VREmi9g==
Date: Wed, 21 Jan 2026 11:23:46 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jiaming Zhang <r772577952@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	pchelkin@ispras.ru, syzkaller@googlegroups.com
Subject: Re: [Linux Kernel Bugs] general protection fault in xchk_btree and
 another slab-use-after-free issue
Message-ID: <20260121192346.GI5945@frogsfrogsfrogs>
References: <CANypQFYN5YtfD7gMbOhe8Rt1+rfpCn2htSr_Sa+pesspWixhPQ@mail.gmail.com>
 <20260120191745.GX15551@frogsfrogsfrogs>
 <CANypQFYFxVVJzHGrxQYgC6Su50-OSLUhWuJ5X3viXTXpqCeikQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANypQFYFxVVJzHGrxQYgC6Su50-OSLUhWuJ5X3viXTXpqCeikQ@mail.gmail.com>

On Wed, Jan 21, 2026 at 06:14:06PM +0800, Jiaming Zhang wrote:
> Darrick J. Wong <djwong@kernel.org> 于2026年1月21日周三 03:17写道：
> >
> > On Tue, Jan 20, 2026 at 06:13:44PM +0800, Jiaming Zhang wrote:
> > > Dear Linux kernel developers and maintainers,
> > >
> > > We are writing to report a general protection fault discovered in the
> > > xfs subsystem with our generated syzkaller specifications. This issue
> > > is reproducible on the latest version of linux (v6.19-rc6, commit
> > > 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7). The KASAN report from
> > > kernel is listed below (formatted by syz-symbolize):
> > >
> > > ---
> > >
> > > loop0: detected capacity change from 0 to 32768
> > > XFS (loop0): Mounting V5 Filesystem 9f91832a-3b79-45c3-9d6d-ed0bc7357fe4
> > > XFS (loop0): Ending clean mount
> > > XFS (loop0): Injecting error at file fs/xfs/libxfs/xfs_btree.c, line
> > > 309, on filesystem "loop0"
> > > Oops: general protection fault, probably for non-canonical address
> > > 0xdffffc0000000009: 0000 [#1] SMP KASAN NOPTI
> > > KASAN: null-ptr-deref in range [0x0000000000000048-0x000000000000004f]
> > > CPU: 1 UID: 0 PID: 9920 Comm: repro.out Not tainted 6.19.0-rc6 #24 PREEMPT(full)
> > > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> > > RIP: 0010:xchk_btree+0xb9/0x1380 fs/xfs/scrub/btree.c:701
> > > Code: f2 00 66 43 c7 44 35 0d f3 f3 43 c6 44 35 0f f3 e8 1c 44 39 fe
> > > 48 89 5c 24 40 48 83 c3 48 48 89 d8 48 c1 e8 03 48 89 44 24 30 <42> 0f
> > > b6 04 30 84 c0 0f 85 d6 11 00 00 44 0f b6 33 41 ff ce bf 53
> > > RSP: 0018:ffffc9000854f360 EFLAGS: 00010206
> > > RAX: 0000000000000009 RBX: 0000000000000048 RCX: ffff888020bebd80
> > > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888044710e00
> > > RBP: ffffc9000854f510 R08: ffffc9000854f540 R09: 0000000000000002
> > > R10: 0000000000000006 R11: 0000000000000000 R12: ffffffff837c5b20
> > > R13: 1ffff920010a9e88 R14: dffffc0000000000 R15: ffffffff8ba6c880
> > > FS:  000000001d1543c0(0000) GS:ffff8880ec5e0000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000200000002700 CR3: 00000000229e4000 CR4: 0000000000752ef0
> > > PKRU: 55555554
> > > Call Trace:
> > >  <TASK>
> > >  xchk_allocbt+0x112/0x190 fs/xfs/scrub/alloc.c:173
> > >  xrep_revalidate_allocbt+0xf3/0x160 fs/xfs/scrub/alloc_repair.c:930
> > >  xfs_scrub_metadata+0xc08/0x1920 fs/xfs/scrub/scrub.c:-1
> > >  xfs_ioc_scrubv_metadata+0x74a/0xaf0 fs/xfs/scrub/scrub.c:981
> > >  xfs_file_ioctl+0x751/0x1560 fs/xfs/xfs_ioctl.c:1266
> > >  vfs_ioctl fs/ioctl.c:51 [inline]
> > >  __do_sys_ioctl fs/ioctl.c:597 [inline]
> > >  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
> > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > >  do_syscall_64+0xe8/0xf80 arch/x86/entry/syscall_64.c:94
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > RIP: 0033:0x45a879
> > > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 31 18 00 00 90 48 89 f8 48
> > > 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> > > 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> > > RSP: 002b:00007ffda72db7f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > > RAX: ffffffffffffffda RBX: 00000000004004b8 RCX: 000000000045a879
> > > RDX: 00002000000000c0 RSI: 00000000c0285840 RDI: 0000000000000005
> > > RBP: 00007ffda72db860 R08: 0000000000000004 R09: 0000000000000005
> > > R10: 0000000000000004 R11: 0000000000000246 R12: 000000000040b990
> > > R13: 0000000000000000 R14: 00000000004ca018 R15: 00000000004004b8
> > >  </TASK>
> > > Modules linked in:
> > > ---[ end trace 0000000000000000 ]---
> > > RIP: 0010:xchk_btree+0xb9/0x1380 fs/xfs/scrub/btree.c:701
> > > Code: f2 00 66 43 c7 44 35 0d f3 f3 43 c6 44 35 0f f3 e8 1c 44 39 fe
> > > 48 89 5c 24 40 48 83 c3 48 48 89 d8 48 c1 e8 03 48 89 44 24 30 <42> 0f
> > > b6 04 30 84 c0 0f 85 d6 11 00 00 44 0f b6 33 41 ff ce bf 53
> > > RSP: 0018:ffffc9000854f360 EFLAGS: 00010206
> > > RAX: 0000000000000009 RBX: 0000000000000048 RCX: ffff888020bebd80
> > > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888044710e00
> > > RBP: ffffc9000854f510 R08: ffffc9000854f540 R09: 0000000000000002
> > > R10: 0000000000000006 R11: 0000000000000000 R12: ffffffff837c5b20
> > > R13: 1ffff920010a9e88 R14: dffffc0000000000 R15: ffffffff8ba6c880
> > > FS:  000000001d1543c0(0000) GS:ffff8880ec5e0000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00007fbbbc0430c8 CR3: 00000000229e4000 CR4: 0000000000752ef0
> > > PKRU: 55555554
> > > ----------------
> > > Code disassembly (best guess):
> > >    0: f2 00 66 43          repnz add %ah,0x43(%rsi)
> > >    4: c7 44 35 0d f3 f3 43 movl   $0xc643f3f3,0xd(%rbp,%rsi,1)
> > >    b: c6
> > >    c: 44 35 0f f3 e8 1c    rex.R xor $0x1ce8f30f,%eax
> > >   12: 44 39 fe              cmp    %r15d,%esi
> > >   15: 48 89 5c 24 40        mov    %rbx,0x40(%rsp)
> > >   1a: 48 83 c3 48          add    $0x48,%rbx
> > >   1e: 48 89 d8              mov    %rbx,%rax
> > >   21: 48 c1 e8 03          shr    $0x3,%rax
> > >   25: 48 89 44 24 30        mov    %rax,0x30(%rsp)
> > > * 2a: 42 0f b6 04 30        movzbl (%rax,%r14,1),%eax <-- trapping instruction
> > >   2f: 84 c0                test   %al,%al
> > >   31: 0f 85 d6 11 00 00    jne    0x120d
> > >   37: 44 0f b6 33          movzbl (%rbx),%r14d
> > >   3b: 41 ff ce              dec    %r14d
> > >   3e: bf                    .byte 0xbf
> > >   3f: 53                    push   %rbx
> > >
> > > ---
> > >
> > > The root cause of this issue is that in xchk_btree(), where the
> > > argument cur can be NULL but the function assume cur is not NULL,
> > > leading to a NULL pointer dereference when accessing member
> > > (https://github.com/torvalds/linux/blob/v6.19-rc6/fs/xfs/scrub/btree.c#L701).
> > >
> > > We can add a NULL check at the beginning of xchk_btree() to fix this issue:
> > > ```
> > > --- a/fs/xfs/scrub/btree.c
> > > +++ b/fs/xfs/scrub/btree.c
> > > @@ -693,6 +693,9 @@ xchk_btree(
> > >   int level;
> > >   int error = 0;
> > >
> > > + if (!cur)
> > > + return -EINVAL;
> >
> > Uh, no, don't just fling EINVAL up to userspace.  Line 930 is the cntbt
> > revalidation in xrep_revalidate_allocbt.  Why is that pointer
> > 0xdffffc0000000009?  Did we somehow fail to allocate a cntbt cursor in
> > xchk_ag_btcur_init?  Did that xchk_should_check_xref free it?  Did we
> > fail to attach the AGF to sc->sa.agf_bp?
> 
> Thanks for the feedback! I dug deeper into the root cause as you
> suggested, here is what I found:
> 
> (1) The program executes XFS_IOC_ERROR_INJECTION branch in
> xfs_file_ioctl(), causes xfs_btree_check_block() to return
> -EFSCORRUPTED, which consequently marks the AG as sick (via
> xfs_btree_mark_sick).

"marks the AG as sick" ... which structure, specifically?  I'm guessing
XFS_SICK_AG_CNTBT from context, but it'd be useful to state these things
from the data you've collected rather than relying on me to infer what's
going on.

> (2) Then, the program executes XFS_IOC_SCRUBV_METADATA branch in
> xfs_file_ioctl(), the setup function (xchk_setup_ag_allocbt())

Which scrub type is it calling, bnobt or cntbt?

> attempts to initialize the cursor. However, the sick flag makes kernel
> executes xchk_ag_btree_del_cursor_if_sick(), the cursor is freed and
> nullified.

Are you talking about the ->setup call after we've rebuilt both free
space btrees, just prior to step three?  When that happens,
xchk_ag_btree_del_cursor_if_sick will see the XREP_ALREADY_FIXED flag
and mask out sc->sick_mask from mask:

	/*
	 * If we just repaired some AG metadata, sc->sick_mask will reflect all
	 * the per-AG metadata types that were repaired.  Exclude these from
	 * the filesystem health query because we have not yet updated the
	 * health status and we want everything to be scanned.
	 */
	if ((sc->flags & XREP_ALREADY_FIXED) &&
	    type_to_health_flag[sc->sm->sm_type].group == XHG_AG)
		mask &= ~sc->sick_mask;

> (3) Lastly, the repair_eval function (xrep_revalidate_allocbt()) calls
> xchk_allocbt(). Since xchk_allocbt() assumes the cursor is valid, it
> passes the NULL pointer to xchk_btree, leading to the null-ptr-deref.

Sure, but xrep_allocbt sets sc->sick_mask to XFS_SICK_AG_BNOBT |
XFS_SICK_AG so any pre-existing bnobt or cntbt sick state in the
xfs_group will be ignored and neither cursor will be deleted when
setting up the revalidation.

> Based on above analysis, I think sc->sa.cnt_cur being NULL is expected
> when the AG is sick. I think the appropriate fix is to check NULL
> inside xchk_allocbt():
> ```
> --- a/fs/xfs/scrub/alloc.c
> +++ b/fs/xfs/scrub/alloc.c
> @@ -170,6 +170,9 @@ xchk_allocbt(
>         return -EIO;
>     }
> 
> +   if (!cur)
> +       return -ENOENT;

This is not correct either.  We've just rebuilt the bnobt and cntbt for
the AG which means that cursors for both btrees should be loaded and
ready for revalidation.

I think you need to look into xchk_ag_btree_del_cursor_if_sick to figure
out exactly what the xfs_group's sick state is, what @mask is, and what
sc->sick_mask is, and from that figure out if it's really deleting the
cntbt cursor.  This is made more difficult because XFS error injection
is probabilistic so it could trigger on /any/ btree.

--D

> +
>     return xchk_btree(sc, cur, xchk_allocbt_rec, &XFS_RMAP_OINFO_AG, &ca);
>  }
>  ```
> What do you think? :)
> 
> >
> > >   /*
> > >   * Allocate the btree scrub context from the heap, because this
> > >   * structure can get rather large.  Don't let a caller feed us a
> > > ```
> > >
> > > After applying changes above and re-running reproducer, another issues
> > > is triggered:
> > >
> > > ---
> > > TITLE: KASAN: slab-use-after-free Read in xchk_btree_check_block_owner
> > >
> > > XFS (loop6): Mounting V5 Filesystem 9f91832a-3b79-45c3-9d6d-ed0bc7357fe4
> > > XFS (loop6): Ending clean mount
> > > ==================================================================
> > > BUG: KASAN: slab-use-after-free in
> > > xchk_btree_check_block_owner+0x3a2/0x600 fs/xfs/scrub/btree.c:401
> > > Read of size 8 at addr ffff88806af035d8 by task syz.6.59/14096
> > >
> > > CPU: 1 UID: 0 PID: 14096 Comm: syz.6.59 Not tainted 6.19.0-rc6-dirty
> > > #30 PREEMPT(full)
> > > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> > > Call Trace:
> > >  <TASK>
> > >  __dump_stack lib/dump_stack.c:94 [inline]
> > >  dump_stack_lvl+0x10e/0x190 lib/dump_stack.c:120
> > >  print_address_description mm/kasan/report.c:378 [inline]
> > >  print_report+0x17e/0x810 mm/kasan/report.c:482
> > >  kasan_report+0x147/0x180 mm/kasan/report.c:595
> > >  xchk_btree_check_block_owner+0x3a2/0x600 fs/xfs/scrub/btree.c:401
> > >  xchk_btree+0x57e/0x1320 fs/xfs/scrub/btree.c:797
> > >  xchk_allocbt+0x112/0x190 fs/xfs/scrub/alloc.c:173
> > >  xrep_revalidate_allocbt+0x69/0x160 fs/xfs/scrub/alloc_repair.c:925
> > >  xfs_scrub_metadata+0xc08/0x1920 fs/xfs/scrub/scrub.c:-1
> > >  xfs_ioc_scrubv_metadata+0x74a/0xaf0 fs/xfs/scrub/scrub.c:981
> > >  xfs_file_ioctl+0x751/0x1560 fs/xfs/xfs_ioctl.c:1266
> > >  vfs_ioctl fs/ioctl.c:51 [inline]
> > >  __do_sys_ioctl fs/ioctl.c:597 [inline]
> > >  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
> > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > >  do_syscall_64+0xe8/0xf80 arch/x86/entry/syscall_64.c:94
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > RIP: 0033:0x7f71bddb459d
> > > Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
> > > 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> > > 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> > > RSP: 002b:00007f71bed71f98 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > > RAX: ffffffffffffffda RBX: 00007f71be045fa0 RCX: 00007f71bddb459d
> > > RDX: 00002000000000c0 RSI: 00000000c0285840 RDI: 0000000000000005
> > > RBP: 00007f71bde52610 R08: 0000000000000000 R09: 0000000000000000
> > > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > > R13: 00007f71be046038 R14: 00007f71be045fa0 R15: 00007f71bed52000
> > >  </TASK>
> > >
> > > Allocated by task 14096:
> > >  kasan_save_stack mm/kasan/common.c:57 [inline]
> > >  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
> > >  unpoison_slab_object mm/kasan/common.c:340 [inline]
> > >  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
> > >  kasan_slab_alloc include/linux/kasan.h:253 [inline]
> > >  slab_post_alloc_hook mm/slub.c:4953 [inline]
> > >  slab_alloc_node mm/slub.c:5263 [inline]
> > >  kmem_cache_alloc_noprof+0x37d/0x710 mm/slub.c:5270
> > >  xfs_btree_alloc_cursor fs/xfs/libxfs/xfs_btree.h:683 [inline]
> > >  xfs_bnobt_init_cursor+0x64/0x210 fs/xfs/libxfs/xfs_alloc_btree.c:485
> > >  xchk_ag_btcur_init+0xe0/0x5d0 fs/xfs/scrub/common.c:612
> > >  xchk_ag_init fs/xfs/scrub/common.c:698 [inline]
> > >  xchk_setup_ag_btree+0x295/0x310 fs/xfs/scrub/common.c:943
> > >  xchk_setup_ag_allocbt+0x70/0x190 fs/xfs/scrub/alloc.c:35
> > >  xfs_scrub_metadata+0xa9e/0x1920 fs/xfs/scrub/scrub.c:709
> > >  xfs_ioc_scrubv_metadata+0x74a/0xaf0 fs/xfs/scrub/scrub.c:981
> > >  xfs_file_ioctl+0x751/0x1560 fs/xfs/xfs_ioctl.c:1266
> > >  vfs_ioctl fs/ioctl.c:51 [inline]
> > >  __do_sys_ioctl fs/ioctl.c:597 [inline]
> > >  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
> > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > >  do_syscall_64+0xe8/0xf80 arch/x86/entry/syscall_64.c:94
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > >
> > > Freed by task 14096:
> > >  kasan_save_stack mm/kasan/common.c:57 [inline]
> > >  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
> > >  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
> > >  poison_slab_object mm/kasan/common.c:253 [inline]
> > >  __kasan_slab_free+0x58/0x80 mm/kasan/common.c:285
> > >  kasan_slab_free include/linux/kasan.h:235 [inline]
> > >  slab_free_hook mm/slub.c:2540 [inline]
> > >  slab_free mm/slub.c:6670 [inline]
> > >  kmem_cache_free+0x197/0x620 mm/slub.c:6781
> > >  xchk_should_check_xref+0xf9/0x420 fs/xfs/scrub/common.c:1351
> > >  xchk_xref_is_used_space+0x14b/0x210 fs/xfs/scrub/alloc.c:190
> > >  xchk_btree_check_block_owner+0x2fe/0x600 fs/xfs/scrub/btree.c:395
> > >  xchk_btree+0x57e/0x1320 fs/xfs/scrub/btree.c:797
> > >  xchk_allocbt+0x112/0x190 fs/xfs/scrub/alloc.c:173
> > >  xrep_revalidate_allocbt+0x69/0x160 fs/xfs/scrub/alloc_repair.c:925
> > >  xfs_scrub_metadata+0xc08/0x1920 fs/xfs/scrub/scrub.c:-1
> > >  xfs_ioc_scrubv_metadata+0x74a/0xaf0 fs/xfs/scrub/scrub.c:981
> > >  xfs_file_ioctl+0x751/0x1560 fs/xfs/xfs_ioctl.c:1266
> > >  vfs_ioctl fs/ioctl.c:51 [inline]
> > >  __do_sys_ioctl fs/ioctl.c:597 [inline]
> > >  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
> > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > >  do_syscall_64+0xe8/0xf80 arch/x86/entry/syscall_64.c:94
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > >
> > > The buggy address belongs to the object at ffff88806af035c8
> > >  which belongs to the cache xfs_bnobt_cur of size 232
> > > The buggy address is located 16 bytes inside of
> > >  freed 232-byte region [ffff88806af035c8, ffff88806af036b0)
> > >
> > > The buggy address belongs to the physical page:
> > > page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x6af03
> > > ksm flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
> > > page_type: f5(slab)
> > > raw: 04fff00000000000 ffff88801dd96a00 ffffea000094fdc0 0000000000000003
> > > raw: 0000000000000000 00000000800d000d 00000000f5000000 0000000000000000
> > > page dumped because: kasan: bad access detected
> > > page_owner tracks the page as allocated
> > > page last allocated via order 0, migratetype Unmovable, gfp_mask
> > > 0x1052c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOLOCKDEP),
> > > pid 13126, tgid 13119 (syz.4.29), ts 58027826746, free_ts 57929202822
> > >  set_page_owner include/linux/page_owner.h:32 [inline]
> > >  post_alloc_hook+0x234/0x290 mm/page_alloc.c:1884
> > >  prep_new_page mm/page_alloc.c:1892 [inline]
> > >  get_page_from_freelist+0x24e4/0x2580 mm/page_alloc.c:3945
> > >  __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5240
> > >  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
> > >  alloc_slab_page mm/slub.c:3075 [inline]
> > >  allocate_slab+0x86/0x3b0 mm/slub.c:3248
> > >  new_slab mm/slub.c:3302 [inline]
> > >  ___slab_alloc+0xe70/0x1860 mm/slub.c:4656
> > >  __slab_alloc+0x65/0x100 mm/slub.c:4779
> > >  __slab_alloc_node mm/slub.c:4855 [inline]
> > >  slab_alloc_node mm/slub.c:5251 [inline]
> > >  kmem_cache_alloc_noprof+0x40f/0x710 mm/slub.c:5270
> > >  xfs_btree_alloc_cursor fs/xfs/libxfs/xfs_btree.h:683 [inline]
> > >  xfs_cntbt_init_cursor+0x64/0x210 fs/xfs/libxfs/xfs_alloc_btree.c:511
> > >  xfs_free_ag_extent+0x570/0x1890 fs/xfs/libxfs/xfs_alloc.c:2149
> > >  __xfs_free_extent+0x2a7/0x460 fs/xfs/libxfs/xfs_alloc.c:4047
> > >  xfs_extent_free_finish_item+0x299/0x840 fs/xfs/xfs_extfree_item.c:555
> > >  xfs_defer_finish_one+0x5a6/0xcc0 fs/xfs/libxfs/xfs_defer.c:595
> > >  xfs_defer_finish_noroll+0x94a/0x1300 fs/xfs/libxfs/xfs_defer.c:707
> > >  xfs_defer_finish+0x1e/0x270 fs/xfs/libxfs/xfs_defer.c:741
> > >  xrep_defer_finish+0x16e/0x240 fs/xfs/scrub/repair.c:242
> > > page last free pid 785 tgid 785 stack trace:
> > >  reset_page_owner include/linux/page_owner.h:25 [inline]
> > >  free_pages_prepare mm/page_alloc.c:1433 [inline]
> > >  __free_frozen_pages+0xbc4/0xd40 mm/page_alloc.c:2973
> > >  vfree+0x25a/0x400 mm/vmalloc.c:3466
> > >  delayed_vfree_work+0x55/0x80 mm/vmalloc.c:3385
> > >  process_one_work kernel/workqueue.c:3257 [inline]
> > >  process_scheduled_works+0xa45/0x1670 kernel/workqueue.c:3340
> > >  worker_thread+0x8a0/0xda0 kernel/workqueue.c:3421
> > >  kthread+0x711/0x8a0 kernel/kthread.c:463
> > >  ret_from_fork+0x510/0xa50 arch/x86/kernel/process.c:158
> > >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
> > >
> > > Memory state around the buggy address:
> > >  ffff88806af03480: fc fc fc fc fa fb fb fb fb fb fb fb fb fb fb fb
> > >  ffff88806af03500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > > >ffff88806af03580: fb fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb
> > >                                                     ^
> > >  ffff88806af03600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > >  ffff88806af03680: fb fb fb fb fb fb fc fc fc fc fc fc fc fc fa fb
> > > ==================================================================
> > > ---
> > >
> > > I also analyzed the root cause of this issue. In
> > > xchk_btree_check_block_owner(), bs->cur is an alias for
> > > bs->sc->sa.bnocur (or rmap_cur,
> > > https://github.com/torvalds/linux/blob/v6.19-rc6/fs/xfs/scrub/btree.c#L396-L400).
> > > The issue occurs when error injection triggers a failure path:
> > >
> > > 1. xchk_btree_check_block_owner() calls xchk_xref_is_used_space()
> > > 2. In xchk_xref_is_used_space(), xfs_alloc_has_records() returns a
> > > non-zero error due to error injection
> > > 3. Non-zero error causes xchk_should_check_xref() to free curpp (which
> > > points to bs->sc->sa.bnocur).
> > > 4. Memory pointed to by bs->cur is freed.
> > >
> > > Control returns to xchk_btree_check_block_owner(), which subsequently
> > > accesses bs->cur->bc_ops, triggering the UAF.
> > >
> > > P.S. this issue can also be triggered independently by syzkaller using
> > > our generated specs.
> > >
> > > To fix this issue, we can cache values of
> > > xfs_btree_is_bno(bs->cur->bc_ops) and
> > > xfs_btree_is_rmap(bs->cur->bc_ops) at the beginning of the function:
> > > ```
> > > --- a/fs/xfs/scrub/btree.c
> > > +++ b/fs/xfs/scrub/btree.c
> > > @@ -371,6 +371,8 @@ xchk_btree_check_block_owner(
> > >   xfs_agnumber_t agno;
> > >   xfs_agblock_t agbno;
> > >   bool init_sa;
> > > + bool is_bno;
> > > + bool is_rmap;
> > >   int error = 0;
> > >
> > >   if (!bs->cur)
> > > @@ -379,6 +381,9 @@ xchk_btree_check_block_owner(
> > >   agno = xfs_daddr_to_agno(bs->cur->bc_mp, daddr);
> > >   agbno = xfs_daddr_to_agbno(bs->cur->bc_mp, daddr);
> > >
> > > + is_bno = xfs_btree_is_bno(bs->cur->bc_ops);
> > > + is_rmap = xfs_btree_is_rmap(bs->cur->bc_ops);
> > > +
> > >   /*
> > >   * If the btree being examined is not itself a per-AG btree, initialize
> > >   * sc->sa so that we can check for the presence of an ownership record
> > > @@ -398,11 +403,11 @@ xchk_btree_check_block_owner(
> > >   * have to nullify it (to shut down further block owner checks) if
> > >   * self-xref encounters problems.
> > >   */
> > > - if (!bs->sc->sa.bno_cur && xfs_btree_is_bno(bs->cur->bc_ops))
> > > + if (!bs->sc->sa.bno_cur && is_bno)
> > >   bs->cur = NULL;
> > >
> > >   xchk_xref_is_only_owned_by(bs->sc, agbno, 1, bs->oinfo);
> > > - if (!bs->sc->sa.rmap_cur && xfs_btree_is_rmap(bs->cur->bc_ops))
> > > + if (!bs->sc->sa.rmap_cur && is_rmap)
> >
> > Indentation problems notwithstanding, that looks like a correct
> > resolution to the UAF problem.
> >
> > >   bs->cur = NULL;
> > >
> > >  out_free:
> > > ```
> > >
> > > After applying above changes, reproducer ran for ~35 minutes without
> > > triggering any issues.
> > >
> > > If above solutions are acceptable, we are happy to submit patches :)
> > >
> > > The kernel console output, kernel config, syzkaller reproducer, and C
> > > reproducer are also attached to help with analysis.
> > >
> > > Please let me know if any further information is required.
> > >
> > > Best Regards,
> > > Jiaming Zhang
> >
> > Please just link to your dashboard, don't send a 1MB email to dozens
> > of people.
> >
> > --D
> 

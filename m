Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464C04279FA;
	Wed, 21 Jan 2026 06:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768978016; cv=none; b=f/FPOhtZMl65lMXwiDpWT3VwqA++fOwDomZJDFFhfmWeZmwL23LJD9vMkSEbKHnIf08ZLceu+Ztc/vkBCk3wWnecLA08W5jghLH508GitaGgcIUv9OOgOEAhVzYQgagqNq8/txTSSC0ySplyO9bAXCE+w/yUwsyZwV6A0Pm7pxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768978016; c=relaxed/simple;
	bh=WP8wQbvZ8USHrR9LFbvo0Tvg4NV606fHA5zcy/T3Opg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SOdvBh/e9FWNPoqQhbUm9NkwE/yKqY1YxMN+3VrrkCKSN7dEc6HRm7xPsTJsprIMOGasndfka/cplrpjBth+jdTWIrB2KvGEGx9IqYejzsTXQMLIMjZvczo1x+TKSfX2EQwjUuYlUu3h3q68gWqK7y+lZyeICGu+Q/DhiZvUgLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SFlrHY/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SFlrHY/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD022C116D0;
	Wed, 21 Jan 2026 06:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768978015;
	bh=WP8wQbvZ8USHrR9LFbvo0Tvg4NV606fHA5zcy/T3Opg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SFlrHY/3SpfM1Ee1zkuYenCsGQBvDzTHee9jLXbfJ9SPtfCWnFrIEQkO4fFke2NKb
	 XTZknRhzZ4n4j636g2/Xt7D1IJ8eGBocrd6803sTBDqG47g6qKityhsiv7DuOFLZbN
	 wT0iFcmCMF23luiJ92BPc4JWC8GvQEEUbqCmC84+wqojJVZfzzzyL9JBRcNSzLIxOo
	 0xZLV2tQ6jeuWaEZJvHhRA2WWDT9VxMZfr9Fnn6MpHYw3AVsIwwdiW84LBcG0f/XUV
	 sppo/M5JWZu7D8dVP/D9PJuEzdafnKEiC18FUKMcmalNyzXqaoUf5AP13fhJr6yd7R
	 pCeLjDX+UEJwA==
Date: Tue, 20 Jan 2026 22:46:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jiaming Zhang <r772577952@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, brauner@kernel.org,
	linux-kernel@vger.kernel.org, willy@infradead.org,
	syzkaller@googlegroups.com
Subject: Re: [Linux Kernel Bug] general protection fault in xfarray_destroy
Message-ID: <20260121064655.GB5945@frogsfrogsfrogs>
References: <CANypQFaxY=1aGi=F69+XRz8HakXoP3rarym55yPPvhpZFiQOeQ@mail.gmail.com>
 <20260119174849.GE15551@frogsfrogsfrogs>
 <CANypQFaOTc32uD7ge=DT1sxhnTF5zMBBXB-3hWL+hU3ypY=hFQ@mail.gmail.com>
 <20260120181505.GV15551@frogsfrogsfrogs>
 <CANypQFZ4earRFNiBBK6zB=1W+s3kHR_hin62TRfZ_w_rxGNt-Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANypQFZ4earRFNiBBK6zB=1W+s3kHR_hin62TRfZ_w_rxGNt-Q@mail.gmail.com>

On Wed, Jan 21, 2026 at 12:24:05PM +0800, Jiaming Zhang wrote:
> Hi Darrick,
> 
> Thank you for your comments!
> 
> Darrick J. Wong <djwong@kernel.org> 于2026年1月21日周三 02:15写道：
> >
> > On Tue, Jan 20, 2026 at 02:57:59PM +0800, Jiaming Zhang wrote:
> > > Hi Darrick,
> > >
> > > Thank you for your reply!
> > >
> > > I applied the NULL check to `xfarray_destroy()` and ran regression
> > > testing. However, the reproducer triggered another issue (formatted by
> > > `syz-symbolize`):
> > >
> > > ---
> > >
> > > TITLE: general protection fault in alloc_file_pseudo
> > >
> > > XFS (loop7): Mounting V5 Filesystem 9f91832a-3b79-45c3-9d6d-ed0bc7357fe4
> > > XFS (loop7): Ending clean mount
> > > Oops: general protection fault, probably for non-canonical address
> > > 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> > > KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> > > CPU: 1 UID: 0 PID: 51224 Comm: repro.out Not tainted 6.19.0-rc6-dirty
> > > #21 PREEMPT(full)
> > > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> > > RIP: 0010:strlen+0x29/0x70 lib/string.c:420
> > > Code: 90 f3 0f 1e fa 41 57 41 56 41 54 53 48 c7 c0 ff ff ff ff 49 be
> > > 00 00 00 00 00 fc ff df 48 89 fb 49 89 c7 48 89 d8 48 c1 e8 03 <42> 0f
> > > b6 04 30 84 c0 75 11 48 ff c3 49 8d 47 01 42 80 7c 3f 01 00
> > > RSP: 0018:ffffc90007c2f238 EFLAGS: 00010246
> > > RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88801f939ec0
> > > RDX: 0000000000000000 RSI: ffff888040456020 RDI: 0000000000000000
> > > RBP: ffffc90007c2f328 R08: ffffffff8b7560e0 R09: 1ffff110036d38ee
> > > R10: dffffc0000000000 R11: ffffed10036d38ef R12: ffff888040456020
> > > R13: 0000000000000000 R14: dffffc0000000000 R15: ffffffffffffffff
> > > FS:  0000000036bb33c0(0000) GS:ffff8880ec5e0000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00000000004c60f0 CR3: 0000000000cbf000 CR4: 0000000000752ef0
> > > PKRU: 55555554
> > > Call Trace:
> > >  <TASK>
> > >  alloc_path_pseudo fs/file_table.c:363 [inline]
> > >  alloc_file_pseudo+0xb6/0x210 fs/file_table.c:379
> > >  __shmem_file_setup+0x284/0x300 mm/shmem.c:5846
> > >  xfile_create+0x73/0x400 fs/xfs/scrub/xfile.c:64
> > >  xfarray_create+0xb4/0x5c0 fs/xfs/scrub/xfarray.c:82
> > >  xchk_nlinks_setup_scan+0x1ee/0x480 fs/xfs/scrub/nlinks.c:1011
> > >  xchk_nlinks+0x93/0x290 fs/xfs/scrub/nlinks.c:1048
> > >  xfs_scrub_metadata+0xc08/0x1920 fs/xfs/scrub/scrub.c:-1
> > >  xfs_ioc_scrubv_metadata+0x74a/0xaf0 fs/xfs/scrub/scrub.c:981
> > >  xfs_file_ioctl+0x751/0x1560 fs/xfs/xfs_ioctl.c:1266
> > >  vfs_ioctl fs/ioctl.c:51 [inline]
> > >  __do_sys_ioctl fs/ioctl.c:597 [inline]
> > >  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
> > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > >  do_syscall_64+0xe8/0xf80 arch/x86/entry/syscall_64.c:94
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > RIP: 0033:0x459b79
> > > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 01 18 00 00 90 48 89 f8 48
> > > 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> > > 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> > > RSP: 002b:00007ffd5595c328 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > > RAX: ffffffffffffffda RBX: 00000000004004a0 RCX: 0000000000459b79
> > > RDX: 00002000000000c0 RSI: 00000000c0285840 RDI: 0000000000000004
> > > RBP: 00007ffd5595c390 R08: 00007ffd5595c076 R09: 0000000000000008
> > > R10: 0000000000000000 R11: 0000000000000246 R12: 000000000040ac80
> > > R13: 0000000000000000 R14: 00000000004c6018 R15: 00000000004004a0
> > >  </TASK>
> > > Modules linked in:
> > > ---[ end trace 0000000000000000 ]---
> > > RIP: 0010:strlen+0x29/0x70 lib/string.c:420
> > > Code: 90 f3 0f 1e fa 41 57 41 56 41 54 53 48 c7 c0 ff ff ff ff 49 be
> > > 00 00 00 00 00 fc ff df 48 89 fb 49 89 c7 48 89 d8 48 c1 e8 03 <42> 0f
> > > b6 04 30 84 c0 75 11 48 ff c3 49 8d 47 01 42 80 7c 3f 01 00
> > > RSP: 0018:ffffc90007c2f238 EFLAGS: 00010246
> > > RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88801f939ec0
> > > RDX: 0000000000000000 RSI: ffff888040456020 RDI: 0000000000000000
> > > RBP: ffffc90007c2f328 R08: ffffffff8b7560e0 R09: 1ffff110036d38ee
> > > R10: dffffc0000000000 R11: ffffed10036d38ef R12: ffff888040456020
> > > R13: 0000000000000000 R14: dffffc0000000000 R15: ffffffffffffffff
> > > FS:  0000000036bb33c0(0000) GS:ffff8880ec5e0000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00007f82497bd000 CR3: 0000000000cbf000 CR4: 0000000000752ef0
> > > PKRU: 55555554
> > > ----------------
> > > Code disassembly (best guess):
> > >    0: 90                    nop
> > >    1: f3 0f 1e fa          endbr64
> > >    5: 41 57                push   %r15
> > >    7: 41 56                push   %r14
> > >    9: 41 54                push   %r12
> > >    b: 53                    push   %rbx
> > >    c: 48 c7 c0 ff ff ff ff mov    $0xffffffffffffffff,%rax
> > >   13: 49 be 00 00 00 00 00 movabs $0xdffffc0000000000,%r14
> > >   1a: fc ff df
> > >   1d: 48 89 fb              mov    %rdi,%rbx
> > >   20: 49 89 c7              mov    %rax,%r15
> > >   23: 48 89 d8              mov    %rbx,%rax
> > >   26: 48 c1 e8 03          shr    $0x3,%rax
> > > * 2a: 42 0f b6 04 30        movzbl (%rax,%r14,1),%eax <-- trapping instruction
> > >   2f: 84 c0                test   %al,%al
> > >   31: 75 11                jne    0x44
> > >   33: 48 ff c3              inc    %rbx
> > >   36: 49 8d 47 01          lea    0x1(%r15),%rax
> > >   3a: 42 80 7c 3f 01 00    cmpb   $0x0,0x1(%rdi,%r15,1)
> > >
> > > ---
> > >
> > > I analyzed this issue and found that `alloc_path_pseudo()` assumes the
> > > input `name` is not NULL. However, the `description` in
> > > `xfile_create()` can be passed as NULL, which eventually propagates to
> > > `alloc_path_pseudo()` and causes the NULL pointer dereference. (Note:
> > > This issue can also be triggered independently by syzkaller using our
> > > generated specs).
> >
> > Let me guess, syzbot makes every memory allocation attempt fail now, and
> > now there's a mess of xchk_xfile_*_descr calls to check and/or update.
> > I was under the impression that allocations under 16 bytes would never
> > fail, but ... oh, "file link counts" is a 17-byte string.  SIGH.
> >
> > OH wait, those are all macro definitions that turn that into "XFS(sda):
> > file link counts", which is even longer and more error-prone.
> >
> > > We can fix this by adding a NULL check in `xfile_create()`:
> > > ```
> > > int
> > > xfile_create(
> > >     const char      *description,
> > >     loff_t          isize,
> > >     struct xfile        **xfilep)
> > > {
> > >     struct inode        *inode;
> > >     struct xfile        *xf;
> > >     int         error;
> > >
> > > +   if (!description)
> > > +       return -EINVAL;
> >
> > Yes, you can fix this one particular crash, but there are 33 callsites
> > of xfile_xchk_file.*descr macros, and each of them needs individual
> > attention because the returned string can get passed to xmbuf_alloc,
> > which calls shmem_kernel_file_setup on its own.
> 
> How about refactoring xchk_xfile.*_descr callsites to explicitly
> handle the allocation and ensure the string is valid? The pattern
> would look like this (an example of xchk_xfile_ag_descr callsite):
> ```
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -1743,6 +1743,8 @@ xrep_agi(
>         sc->buf_cleanup = xrep_agi_buf_cleanup;
> 
>         descr = xchk_xfile_ag_descr(sc, "iunlinked next pointers");
> +       if (!descr)
> +               return -ENOMEM;
>         error = xfarray_create(descr, 0, sizeof(xfs_agino_t),
>                         &ragi->iunlink_next);
>         kfree(descr);
> ```
> If acceptable, I will apply it to the remaining callsites and submit a patch :)

Already done, please see downlist.

> Best Regards,
> Jiaming Zhang

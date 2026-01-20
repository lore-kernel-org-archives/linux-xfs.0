Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520003A7DF0;
	Tue, 20 Jan 2026 20:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768939885; cv=none; b=V0SFAqMTNUlrR/srEsekM0S9T467R448wHZK0pAApZOMPoN2zr+jeLJbRIQYvgwZiJowiok4KMLCdyB29fQLpht16egaGUYXenSUzsPjcFBV6Pmzt5HZhKEPXnIiWuyi98ytE1WlCBlxQ/APs3YvXwa8vCyJf04Pvvw8p8e932s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768939885; c=relaxed/simple;
	bh=oMpVMIm0AozsATnpQMNw/uxDZ/0n/B3NNrLbtpvMJ48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mhA1vAaPA0GRmxk3ZqvmERDH6K1Ru3A13xs7qIq+r6+jupzleZtDo+TVL0P0qL34DAO3kWF3FvoOzcR1PZxUEcl7Rt6+FJyniR7+HWkCa0KTG+GPHM/0abDfQrLiu6OUWfAXZyKkI+n18KmV3E6SWoewzulqFTUh3FTP9ocYmnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JKkAfonA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JKkAfonA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168A4C16AAE;
	Tue, 20 Jan 2026 20:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768939884;
	bh=oMpVMIm0AozsATnpQMNw/uxDZ/0n/B3NNrLbtpvMJ48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JKkAfonA/ifbFl9exXA1Gs/XlD91BKEsz0hTyAhlUDMug4dFUz88UWa85390LLtm0
	 +ENNQU2LkKxBltmYGZnfqt7wuXXiLnccwNTI4fftvo3no0MnV3ZxfqIoW/XGyyb96Z
	 4QKN+tPKbqI9TGEtWVVBVkPz5mR6CTutnbjnJkjTCy+/mgZzOq2MVJtc0XWl2Ro/Sj
	 GBcV/fWt7uI0QctKY7SaHua0dn+mTWQ3SBdRzp8q/CSRPqMDo2CFRUc1UYiC2i1FTu
	 swnNop4235Zc7SPeH3j3TUyMhtpZw47WgBvhvR9I5faUUAUYlGMFXFFUk6OQiP2Mak
	 /YMX/+/iKWzzw==
Date: Tue, 20 Jan 2026 12:11:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jiaming Zhang <r772577952@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, brauner@kernel.org,
	linux-kernel@vger.kernel.org, mjguzik@gmail.com,
	syzkaller@googlegroups.com
Subject: Re: [Linux Kernel Bug] general protection fault in
 xchk_metadata_inode_forks
Message-ID: <20260120201123.GY15551@frogsfrogsfrogs>
References: <CANypQFbytMi2F2==XxAK5QuJw5NnS3d2OrnjdYTjqvRA3vqG4g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANypQFbytMi2F2==XxAK5QuJw5NnS3d2OrnjdYTjqvRA3vqG4g@mail.gmail.com>

On Tue, Jan 20, 2026 at 08:12:47PM +0800, Jiaming Zhang wrote:
> Dear Linux kernel developers and maintainers,
> 
> We are writing to report a general protection fault discovered in the
> xfs subsystem with our generated syzkaller specifications. This issue
> is reproducible on the latest version of linux (v6.19-rc6, commit
> 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7). The KASAN report from
> kernel is listed below (formatted by syz-symbolize):

750K is still a very large email to send to dozens of people...

> ---
> 
> loop2: detected capacity change from 0 to 32768
> xfs: Deprecated parameter 'ikeep'
> XFS: ikeep mount option is deprecated.
> XFS (loop2): Mounting V5 Filesystem 9f91832a-3b79-45c3-9d6d-ed0bc7357fe4
> XFS (loop2): Ending clean mount
> XFS (loop2): Quotacheck needed: Please wait.
> XFS (loop2): Quotacheck: Done.
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 13187 Comm: syz.2.19 Not tainted 6.19.0-rc6 #31 PREEMPT(full)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> RIP: 0010:xchk_metadata_inode_subtype fs/xfs/scrub/common.c:1398 [inline]
> RIP: 0010:xchk_metadata_inode_forks+0xf3/0x8f0 fs/xfs/scrub/common.c:1418
> Code: 00 00 00 48 8b 7c 24 08 be 0b 00 00 00 e8 25 c8 03 00 49 89 c7
> 4c 8d 60 10 4c 89 e0 48 c1 e8 03 49 bd 00 00 00 00 00 fc ff df <42> 80
> 3c 28 00 74 08 4c 89 e7 e8 5e 4b a0 fe 4d 8b 24 24 49 83 c4
> RSP: 0018:ffffc9000a6af2a0 EFLAGS: 00010247
> RAX: 0000000000000000 RBX: ffff888046c67c08 RCX: ffff888000361ec0
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88801a441b40
> RBP: ffffc9000a6af370 R08: 0000000000006dc0 R09: 00000000ffffffff
> R10: dffffc0000000000 R11: fffffbfff1c0d107 R12: 0000000000000004
> R13: dffffc0000000000 R14: 1ffff11008d8cf81 R15: fffffffffffffff4
> FS:  00007f5877ffe640(0000) GS:ffff8880ec5e0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f627486f000 CR3: 0000000026294000 CR4: 0000000000752ef0
> PKRU: 00000000
> Call Trace:
>  <TASK>
>  xchk_quota_data_fork+0xd0/0x5e0 fs/xfs/scrub/quota.c:271
>  xchk_quota+0x193/0x420 fs/xfs/scrub/quota.c:314
>  xfs_scrub_metadata+0xc08/0x1920 fs/xfs/scrub/scrub.c:-1
>  xfs_ioc_scrubv_metadata+0x74a/0xaf0 fs/xfs/scrub/scrub.c:981
>  xfs_file_ioctl+0x751/0x1560 fs/xfs/xfs_ioctl.c:1266
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe8/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f58789b459d
> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f5877ffdf98 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f5878c45fa0 RCX: 00007f58789b459d
> RDX: 00002000000000c0 RSI: 00000000c0285840 RDI: 0000000000000004
> RBP: 00007f5877ffe010 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> R13: 00007f5878c46038 R14: 00007f5878c45fa0 R15: 00007f5877fde000
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:xchk_metadata_inode_subtype fs/xfs/scrub/common.c:1398 [inline]
> RIP: 0010:xchk_metadata_inode_forks+0xf3/0x8f0 fs/xfs/scrub/common.c:1418
> Code: 00 00 00 48 8b 7c 24 08 be 0b 00 00 00 e8 25 c8 03 00 49 89 c7
> 4c 8d 60 10 4c 89 e0 48 c1 e8 03 49 bd 00 00 00 00 00 fc ff df <42> 80
> 3c 28 00 74 08 4c 89 e7 e8 5e 4b a0 fe 4d 8b 24 24 49 83 c4
> RSP: 0018:ffffc9000a6af2a0 EFLAGS: 00010247
> RAX: 0000000000000000 RBX: ffff888046c67c08 RCX: ffff888000361ec0
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88801a441b40
> RBP: ffffc9000a6af370 R08: 0000000000006dc0 R09: 00000000ffffffff
> R10: dffffc0000000000 R11: fffffbfff1c0d107 R12: 0000000000000004
> R13: dffffc0000000000 R14: 1ffff11008d8cf81 R15: fffffffffffffff4
> FS:  00007f5877ffe640(0000) GS:ffff8880ec5e0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f62748ab000 CR3: 0000000026294000 CR4: 0000000000752ef0
> PKRU: 00000000
> ----------------
> Code disassembly (best guess):
>    0: 00 00                 add    %al,(%rax)
>    2: 00 48 8b              add    %cl,-0x75(%rax)
>    5: 7c 24                 jl     0x2b
>    7: 08 be 0b 00 00 00     or     %bh,0xb(%rsi)
>    d: e8 25 c8 03 00        call   0x3c837
>   12: 49 89 c7              mov    %rax,%r15
>   15: 4c 8d 60 10           lea    0x10(%rax),%r12
>   19: 4c 89 e0              mov    %r12,%rax
>   1c: 48 c1 e8 03           shr    $0x3,%rax
>   20: 49 bd 00 00 00 00 00  movabs $0xdffffc0000000000,%r13
>   27: fc ff df
> * 2a: 42 80 3c 28 00        cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
>   2f: 74 08                 je     0x39
>   31: 4c 89 e7              mov    %r12,%rdi
>   34: e8 5e 4b a0 fe        call   0xfea04b97
>   39: 4d 8b 24 24           mov    (%r12),%r12
>   3d: 49                    rex.WB
>   3e: 83                    .byte 0x83
>   3f: c4                    .byte 0xc4
> 
> ---
> 
> The root cause of this issue is that the function
> xchk_metadata_inode_subtype() calls xchk_scrub_create_subord(), which
> may return ERR_PTR(-ENOMEM). However, the function does not check
> validity of the returned value and directly dereferences it
> (https://github.com/torvalds/linux/blob/v6.19-rc6/fs/xfs/scrub/common.c#L1397-L1398),
> leading to a system crash.
> 
> We can fix this issue by checking validity of return value:
> ```
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -1395,6 +1395,9 @@ xchk_metadata_inode_subtype(
>   int     error;
> 
>   sub = xchk_scrub_create_subord(sc, scrub_type);
> + if (IS_ERR(sub))
> +   return PTR_ERR(sub);

Don't you need to check the other xchk_scrub_create_subord callsite?

--D

> +
>   error = sub->sc.ops->scrub(&sub->sc);
>   xchk_scrub_free_subord(sub);
>   return error;
> ```
> 
> After applying the above changes, the reproducer ran for ~25 minutes
> without triggering any issues.
> 
> If the above solutions are acceptable, we are happy to submit patches :)
> 
> The kernel console output, kernel config, and syzkaller reproducer are
> also attached to help with analysis.
> 
> Please let me know if any further information is required.
> 
> Best Regards,
> Jiaming Zhang

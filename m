Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47579139CF2;
	Wed,  5 Mar 2025 03:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741144839; cv=none; b=TC5mIddvpAI82ZkSedJSpXJxZ9h+/PI5Fezeceyw68Jfqlz7XE/5ZxzQ4SeR3cpONCuqyJ9HMte6tFdJ0QCDqTvFEmjOrBkbMnyihuwGjol/6oW+S7NUzGABtMJMY8B9Y8vCqaspefClW6F0/EfUqtlkFlZ41REFKBuYUYy3qAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741144839; c=relaxed/simple;
	bh=I4fBTEY4FRNhnrPAw6eM9y01Y1oi0ELTGofvJysBghc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LzeMtgG4r9HTCzLmnJjSYPs5ZeCpbICKg7FqonWpx74+8HtAVmxiZ6LzMPW3m2DmY5sMom/k8/MCkiWBqJAs9t1DJBzbFTmbc4SB7Tx3GcPoQu2usFJJR92PjDh5e/GtOnYjiYM5as97S41+APubmiUgVWngm6YAhxoZEMhNlg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wk6tohfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wk6tohfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD5FC4CEE5;
	Wed,  5 Mar 2025 03:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741144838;
	bh=I4fBTEY4FRNhnrPAw6eM9y01Y1oi0ELTGofvJysBghc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wk6tohfGqlQgK6cEPcrMvTJLM6wK+BzIVBoZUa3ktAvuFhaeepA67RAmAdIpb31CJ
	 qf4F9XNQANtK9lyUGe4vLNv/iGIwPeZJjxNJMW1YHQEUlRalJTW3uroTipKHWrIEcL
	 uVd0SZMLrikxiKBfK+CNsnJytycpclG004xByUjpvBDN0oWPS20ATvylIwadLDhj52
	 ZftqVjbX5lC3y/smP2MDaFs8djFhIkVBI5MfvpNiAIzs2UxuN7AaX33wtuB9OVcxiC
	 KM0p8KhYBwgZalLXnlxdt2caDuf1dYGdyvYstk/qRw2myceU/A4A6qYdmY5wNnerR9
	 srBypsB0QRhIA==
Date: Tue, 4 Mar 2025 19:20:36 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: syzbot <syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com>
Cc: ardb@kernel.org, bp@alien8.de, chandan.babu@oracle.com,
	dave.hansen@linux.intel.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, mingo@redhat.com,
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Subject: Re: [syzbot] [xfs?] KASAN: slab-out-of-bounds Read in xlog_cksum
Message-ID: <20250305032036.GD20133@sol.localdomain>
References: <67c72724.050a0220.38b91b.0244.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67c72724.050a0220.38b91b.0244.GAE@google.com>

On Tue, Mar 04, 2025 at 08:15:32AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    99fa936e8e4f Merge tag 'affs-6.14-rc5-tag' of git://git.ke..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=111c9464580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2040405600e83619
> dashboard link: https://syzkaller.appspot.com/bug?extid=9f6d080dece587cfdd4c
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=132f0078580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1483fc54580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-99fa936e.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/ef04f83d96f6/vmlinux-99fa936e.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/583a7eea5c8e/bzImage-99fa936e.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/6232fcdbddfb/mount_1.gz
>   fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=11d457a0580000)
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
> 
> =======================================================
> XFS (loop0): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f791
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in crc32c_le_arch+0xc7/0x1b0 arch/x86/lib/crc32-glue.c:81
> Read of size 8 at addr ffff888040dfea00 by task syz-executor260/5304
> 
> CPU: 0 UID: 0 PID: 5304 Comm: syz-executor260 Not tainted 6.14.0-rc5-syzkaller-00013-g99fa936e8e4f #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:408 [inline]
>  print_report+0x16e/0x5b0 mm/kasan/report.c:521
>  kasan_report+0x143/0x180 mm/kasan/report.c:634
>  crc32c_le_arch+0xc7/0x1b0 arch/x86/lib/crc32-glue.c:81
>  __crc32c_le include/linux/crc32.h:36 [inline]
>  crc32c include/linux/crc32c.h:9 [inline]
>  xlog_cksum+0x91/0xf0 fs/xfs/xfs_log.c:1588
>  xlog_recover_process+0x78/0x1e0 fs/xfs/xfs_log_recover.c:2900
>  xlog_do_recovery_pass+0xa01/0xdc0 fs/xfs/xfs_log_recover.c:3235
>  xlog_verify_head+0x21f/0x5a0 fs/xfs/xfs_log_recover.c:1058
>  xlog_find_tail+0xa04/0xdf0 fs/xfs/xfs_log_recover.c:1315
>  xlog_recover+0xe1/0x540 fs/xfs/xfs_log_recover.c:3419

This got sent "To:" me because of crc32c in the call stack.  The bug is in XFS,
though; it's passing an invalid buffer to crc32c().

- Eric

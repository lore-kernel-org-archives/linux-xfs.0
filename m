Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CB233F8DD;
	Mon, 19 Jan 2026 08:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768811873; cv=none; b=WuzOKi7U7Z9bGcwKkHLFoUXtlDJAouzXf2okDaYN7nIP8cHP9lyW652HYRk7a4W4y999gXTMvXjRzEn+EQgUjPhKX3IVQ5fKz4ZQ9c2CP64+QGqsL7jffBhumYxB52eX11gQ7y+wAWBYs03ryzD/yj4Sk//mWfpnl5B9flE0ea8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768811873; c=relaxed/simple;
	bh=nvXSpZVPmSNqCcksf0Mb/Bj2GLTvT7YypJ9jo8WmzXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g9LNUEnH2eXQq4Ep/8YzqcyKr67P/57zPCa0uCZE1DyJgi1KPEFIibQ/F3bQK7RsTyxCWj0UFdVYPR/cwcPxMaq0oaEEzoKDe7HcvTz8e8g7hwfd7jv716lZ461nUrj6s+hEg1nhLUi3TWoEPw60YY2x9SQzMbWv19m48tCKovc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3MgsS1SC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3MgsS1SC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IQ6V0ML5fLmW+MdiPRFQIxhtChAdE9d0p5jwT47svtk=; b=3MgsS1SCbWrJEpGUtrvcV+HCnS
	4SphTsmSPiJVjgqpGS+Un+r4AjPTbaLp4JFeQKOEWQAAwDc0oRzY6N6IecIwXKiSib53y55T1MIru
	xs+wzjPJNK/Yx+BQTWMWgmbxDox3AJ3A7nvS26AbfXFy3GBFm1x6yNRjwO+X8W+w0Lx+wlOVPgWea
	xGptrTJIv5v/FwlGfF1otbPIvEYnJVwuagPclmrYqdJItg4bC4/0UTJgdWMOFJEk9IEcvj/Zg43J9
	aqtigqOZx/wbZNXjmn+lsW8cDPi6XhpTPPozij3jCd/sdGQdf2/WQhGYb6i2TXsOdSe1RtPxZqN6z
	EKZwMEPQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhklj-00000001ZGJ-3WwX;
	Mon, 19 Jan 2026 08:37:51 +0000
Date: Mon, 19 Jan 2026 00:37:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: syzbot <syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com>
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] KASAN: slab-use-after-free Read in xfs_buf_rele
 (4)
Message-ID: <aW3tX6aAAONC6zyr@infradead.org>
References: <aW3g7G_dWk4cbx0_@infradead.org>
 <696dec7b.a70a0220.34546f.043a.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <696dec7b.a70a0220.34546f.043a.GAE@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

So I'm not sure what this test does that it always triggers the lockdep
keys, but that makes it impossible to validate the original xfs report.

Is there a way to force running syzbot reproducers without lockdep?

Note that I've also had it running locally for quite a while, an even
with lockdep enabled I'm somehow not hitting the lockdep splat.
Although that is using my normal debug config and not the provided
one.

On Mon, Jan 19, 2026 at 12:34:03AM -0800, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> BUG: MAX_LOCKDEP_KEYS too low!
> 
> BUG: MAX_LOCKDEP_KEYS too low!
> turning off the locking correctness validator.
> CPU: 1 UID: 0 PID: 7123 Comm: syz-executor Not tainted syzkaller #0 PREEMPT 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/03/2025
> Call trace:
>  show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
>  __dump_stack+0x30/0x40 lib/dump_stack.c:94
>  dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
>  dump_stack+0x1c/0x28 lib/dump_stack.c:129
>  register_lock_class+0x310/0x348 kernel/locking/lockdep.c:1332
>  __lock_acquire+0xbc/0x30a4 kernel/locking/lockdep.c:5112
>  lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
>  touch_wq_lockdep_map+0xa8/0x164 kernel/workqueue.c:3940
>  __flush_workqueue+0xfc/0x109c kernel/workqueue.c:3982
>  drain_workqueue+0xa4/0x310 kernel/workqueue.c:4146
>  destroy_workqueue+0xb4/0xd90 kernel/workqueue.c:5903
>  xfs_destroy_mount_workqueues+0xac/0xdc fs/xfs/xfs_super.c:649
>  xfs_fs_put_super+0x128/0x144 fs/xfs/xfs_super.c:1262
>  generic_shutdown_super+0x12c/0x2b8 fs/super.c:643
>  kill_block_super+0x44/0x90 fs/super.c:1722
>  xfs_kill_sb+0x20/0x58 fs/xfs/xfs_super.c:2297
>  deactivate_locked_super+0xc4/0x12c fs/super.c:474
>  deactivate_super+0xe0/0x100 fs/super.c:507
>  cleanup_mnt+0x31c/0x3ac fs/namespace.c:1318
>  __cleanup_mnt+0x20/0x30 fs/namespace.c:1325
>  task_work_run+0x1dc/0x260 kernel/task_work.c:233
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
>  exit_to_user_mode_loop+0x10c/0x18c kernel/entry/common.c:75
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
>  exit_to_user_mode_prepare_legacy include/linux/irq-entry-common.h:242 [inline]
>  arm64_exit_to_user_mode arch/arm64/kernel/entry-common.c:81 [inline]
>  el0_svc+0x17c/0x26c arch/arm64/kernel/entry-common.c:725
>  el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
>  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> 
> 
> Tested on:
> 
> commit:         3e548540 increase LOCKDEP_CHAINS_BITS
> git tree:       git://git.infradead.org/users/hch/xfs.git xfs-buf-hash
> console output: https://syzkaller.appspot.com/x/log.txt?x=101b0d22580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6c6138f827b10ea4
> dashboard link: https://syzkaller.appspot.com/bug?extid=0391d34e801643e2809b
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> userspace arch: arm64
> 
> Note: no patches were applied.
---end quoted text---

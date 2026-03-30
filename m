Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB0C2A1BF;
	Mon, 30 Mar 2026 01:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774834898; cv=none; b=AJ9B8l+0s3Y6vpx2vQriXFU3/oDv7t9SM5gjYLZtPU/I3ivX1uwx5NbqlZ5+2zEHoAldHTC1R5fYqmHHpgrn4FzY/KYw7uTuogr/XRBpD7fBAOOL9yccHUh0jd8erIM2jrISNSJ81ai8i26NY+6MM8xVqw2TxU8d6SstYfDNHB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774834898; c=relaxed/simple;
	bh=mYllvTVYnPWHya7yLZUDM/0BpaB9SMJOaI8msGcgIck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MP8kyryoLykRxjY66loIyXNpRQ9DJJAhGQp/51sf9oNFdSnaOnE5WeU0vW5tXpd6Cn9wW91KhM0fHaA11kxiB02jttsyIcwva6nntHWXY7sCgDqQmY/pg5pXuTQg3uXE235+emVH9lKLdEb5h9F0gZ4YI+sBKH+ft4HpZoGsTwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HZmWzVmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZmWzVmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A0EC116C6;
	Mon, 30 Mar 2026 01:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774834897;
	bh=mYllvTVYnPWHya7yLZUDM/0BpaB9SMJOaI8msGcgIck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HZmWzVmqmewcE9uU3FIHPqUhSafTHRZWP2Rciae5o9aFZhbrlElSCO14tSSvJ0gES
	 NUUp0qlD3s+XVuXYvWszeIboprujz6rTeOuUPY9UNNDLVxWDPtc025tciZ0Flz/F+I
	 LkrG8jwKJKArQd58+uQMxBoDYIfObjg9h3lv8IN55wQAWKHG3y0uCyRdzBEE9TZ0rp
	 t0yxH68vgS4N3a9bBb7wMi5VOHOqUugrbyJZ0TtgWruehzXBR6oOqpDU4ngXBvq0Pn
	 RXV1d/zhVwVbiV6NQYUtih95cf8oMf+2IbHywMcB5IaC+F2omGGjDsPzok9fJZJzJU
	 H54C7UmKX90pg==
Date: Mon, 30 Mar 2026 12:41:29 +1100
From: Dave Chinner <dgc@kernel.org>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: cem@kernel.org, dchinner@redhat.com, djwong@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH] xfs: avoid inodegc worker flush deadlock
Message-ID: <acnUybgMAsBA9IEc@dread>
References: <20260328071252.3936506-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260328071252.3936506-1-gality369@gmail.com>

On Sat, Mar 28, 2026 at 03:12:51PM +0800, ZhengYuan Huang wrote:
> [BUG]
> WARNING: possible recursive locking detected
> --------------------------------------------
> kworker/0:1/10 is trying to acquire lock:
> ffff88801621fd48 ((wq_completion)xfs-inodegc/ublkb1){+.+.}-{0:0}, at: touch_wq_lockdep_map+0x99/0x1c0 kernel/workqueue.c:3936
> 
> but task is already holding lock:
> ffff88801621fd48 ((wq_completion)xfs-inodegc/ublkb1){+.+.}-{0:0}, at: process_one_work+0x1188/0x1980 kernel/workqueue.c:3238
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock((wq_completion)xfs-inodegc/ublkb1);
>   lock((wq_completion)xfs-inodegc/ublkb1);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 2 locks held by kworker/0:1/10:
>  #0: ffff88801621fd48 ((wq_completion)xfs-inodegc/ublkb1){+.+.}-{0:0}, at: process_one_work+0x1188/0x1980 kernel/workqueue.c:3238
>  #1: ffff888009dafce8 ((work_completion)(&(&gc->work)->work)){+.+.}-{0:0}, at: process_one_work+0x865/0x1980 kernel/workqueue.c:3239
> 
> stack backtrace:
> Workqueue: xfs-inodegc/ublkb1 xfs_inodegc_worker
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0xbe/0x130 lib/dump_stack.c:120
>  dump_stack+0x15/0x20 lib/dump_stack.c:129
>  print_deadlock_bug+0x23f/0x320 kernel/locking/lockdep.c:3041
>  check_deadlock kernel/locking/lockdep.c:3093 [inline]
>  validate_chain kernel/locking/lockdep.c:3895 [inline]
>  __lock_acquire+0x1317/0x21e0 kernel/locking/lockdep.c:5237
>  lock_acquire kernel/locking/lockdep.c:5868 [inline]
>  lock_acquire+0x169/0x2f0 kernel/locking/lockdep.c:5825
>  touch_wq_lockdep_map+0xab/0x1c0 kernel/workqueue.c:3936
>  __flush_workqueue+0x117/0x1010 kernel/workqueue.c:3978
>  xfs_inodegc_wait_all fs/xfs/xfs_icache.c:495 [inline]
>  xfs_inodegc_flush+0x9a/0x390 fs/xfs/xfs_icache.c:2020
>  xfs_blockgc_flush_all+0x106/0x250 fs/xfs/xfs_icache.c:1614
>  xfs_trans_alloc+0x5e4/0xc10 fs/xfs/xfs_trans.c:268
>  xfs_inactive_ifree+0x329/0x3c0 fs/xfs/xfs_inode.c:1224
>  xfs_inactive+0x590/0xb60 fs/xfs/xfs_inode.c:1485

How did the filesystem get to ENOSPC when freeing an inode?
That should not happen, so can you please describe what the system
was doing to trip over this issue?

i.e. the problem that needs to be understood and fixed here is
"freeing an inode should never see ENOSPC", not "inodegc should not
recurse"...

-Dave.
-- 
Dave Chinner
dgc@kernel.org

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8082F366046;
	Mon, 13 Apr 2026 18:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776103781; cv=none; b=oRfNzwxRydVvfBLP0TcYyfxFt8zxTLZTsSFz+GERnx1p7XXicQyyxyDMCoUBbh+6xbVR2+MCNgHf1PlpA1FSfZOBdc1xnxKElsL1wHs3G9bMyqfkWP4D0ePLbudU0iJQk5rfQM/rXeybN84/X5OeXyrh/vluEW3byi0UfPtZK+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776103781; c=relaxed/simple;
	bh=wkTlNw8fM3o+aR/1pq27qu67bx7LI1s0W5xZbjJ/Mg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YZ6h9G2JjjEohHXQ7+ggFToBjbCwqW3Yzyw1UF7wfO1hu474WULJneH34asHwm3Z+bY/94MYKh38/n0gBx7DJQQWPyfWQHO1qSV/t8QJEQpI+UoN2gmV9wScecyrZDPkqrPs9fqFwkFSlK+nkYsOhbjxrUje3chpR//JkRTGQ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iq0wcyDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iq0wcyDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CC5C2BCAF;
	Mon, 13 Apr 2026 18:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776103781;
	bh=wkTlNw8fM3o+aR/1pq27qu67bx7LI1s0W5xZbjJ/Mg4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Iq0wcyDDKaA4SMKBpHDZcQI9PyPGQVOdNL2bDUOIxZK/pprpo4QGuLsp+n8xd1bDP
	 0bd01xU6oJ6Mdu2OMmx+dmne6HWDLjHQTHC47AYLC3pI4+c8XohTxD3iVJVT3K+n6c
	 BPmo/sdxb/9LAgnDb0RhFQp8r44XhAhr0baXEPEersM7mg3+SOcu+IBhe6tvha6VO6
	 bUYkf/19P8v0+cUvPpa1QDV6JR9GrvSP6rgmYb92oyUlnq6zF0ZN9yrc/Sa0p8+roq
	 c/BVetnCgcjWL67yfSVCODnBWdng8Y4Bd3G2dC0Xz6r1ki7Uk6cH5J3OL6HpiRAjyw
	 dstu2xjSOB/Bw==
Date: Mon, 13 Apr 2026 11:09:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: Re: [PATCH] xfs: start inodegc after quota initialization
Message-ID: <20260413180940.GO1048989@frogsfrogsfrogs>
References: <20260413004925.84518-1-pedrodemargomes@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413004925.84518-1-pedrodemargomes@gmail.com>

On Sun, Apr 12, 2026 at 09:49:25PM -0300, Pedro Demarchi Gomes wrote:
> When mounting a xfs filesystem with quotas, if an error occurs in xfs_mount
> after calling xfs_inodegc_start and before m_quotainfo initialization, the
> error path will call xfs_inodegc_flush assuming that m_quotainfo was already
> initialized, causing the following error:
> 
> [   82.411853][   T23] ==================================================================
> [   82.412678][   T23] BUG: KASAN: null-ptr-deref in mutex_lock (./include/linux/instrumented.h:55 ./include/linux/atomic/atomic-instrumented.h:4457 kernel/locking/mutex.c:159 kernel/locking/mutex.c:289)
> [   82.413383][   T23] Write of size 8 at addr 0000000000000030 by task kworker/1:0/23
> [   82.414187][   T23]
> [   82.414450][   T23] CPU: 1 UID: 0 PID: 23 Comm: kworker/1:0 Not tainted 7.0.0-rc5-00051-gbbeb83d3182a #35 PREEMPT(
> [   82.414458][   T23] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> [   82.414463][   T23] Workqueue: xfs-inodegc/loop0 xfs_inodegc_worker
> [   82.414478][   T23] Call Trace:
> [   82.414481][   T23]  <TASK>
> [   82.414484][   T23]  dump_stack_lvl (lib/dump_stack.c:122)
> [   82.414494][   T23]  print_report (mm/kasan/report.c:487)
> [   82.414518][   T23]  kasan_report (mm/kasan/report.c:597)
> [   82.414541][   T23]  kasan_check_range (mm/kasan/generic.c:? mm/kasan/generic.c:200)
> [   82.414549][   T23]  mutex_lock (./include/linux/instrumented.h:55 ./include/linux/atomic/atomic-instrumented.h:4457 kernel/locking/mutex.c:159 kernel/locking/mutex.c:289)
> [   82.414601][   T23]  xfs_qm_dqget_cache_lookup (fs/xfs/xfs_dquot.c:813)
> [   82.414609][   T23]  xfs_qm_dqget_inode (fs/xfs/xfs_dquot.c:1017)
> [   82.414678][   T23]  xfs_qm_dqattach_locked (fs/xfs/xfs_qm.c:331)
> [   82.414688][   T23]  xfs_qm_dqattach (fs/xfs/xfs_qm.c:371)
> [   82.414696][   T23]  xfs_inactive (fs/xfs/xfs_inode.c:1453)
> [   82.414733][   T23]  xfs_inodegc_worker (fs/xfs/xfs_icache.c:1946 fs/xfs/xfs_icache.c:1992)
> [   82.414743][   T23]  process_scheduled_works (kernel/workqueue.c:3281 kernel/workqueue.c:3359)
> [   82.414755][   T23]  worker_thread (kernel/workqueue.c:?)
> [   82.414775][   T23]  kthread (kernel/kthread.c:437)
> [   82.414787][   T23]  ret_from_fork (arch/x86/kernel/process.c:164)
> [   82.414822][   T23]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
> [   82.414834][   T23]  </TASK>
> 
> To avoid this, call xfs_inodegc_start after quota initialization.
> 
> Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
> Closes: https://lore.kernel.org/all/DDC07F0C-05D2-46B4-9815-E010749FB3DC@gmail.com/
> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> ---
>  fs/xfs/xfs_mount.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index ef1ea8a1238c..d6f75ab41337 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1057,7 +1057,6 @@ xfs_mountfs(
>  		xfs_clear_using_logged_xattrs(mp);
>  
>  	/* Enable background inode inactivation workers. */
> -	xfs_inodegc_start(mp);
>  	xfs_blockgc_start(mp);
>  
>  	if (xfs_has_metadir(mp)) {
> @@ -1143,6 +1142,8 @@ xfs_mountfs(
>  		}
>  	}
>  
> +	xfs_inodegc_start(mp);

Why is it correct to defer inodegc until this point?  Can any code
between line 1060 and 1145 push an inode to the inodegc mechanism?
blockgc can unmap blocks from files, so why is it ok to leave the
blockgc_start call where it is?

--D

> +
>  	/*
>  	 * Finish recovering the file system.  This part needed to be delayed
>  	 * until after the root and real-time bitmap inodes were consistently
> -- 
> 2.47.3
> 
> 

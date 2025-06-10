Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF5A20E034;
	Tue, 10 Jun 2025 14:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749566618; cv=none; b=Hg6gdndwzQ6+/6eBNDOseW8Q31GkAOF7Klfu6iXtkupaAhIWfj4y22YPY3jk9XulLb1MGOpwB2efTaMMyI1QonWKG0EePJ4fJp3c44SgxrHL1AatHHKNDtO1z+KspR9fCgxGBANpwLR9cPzUqmbvf1rEeJK1Flj++fhePhk7bsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749566618; c=relaxed/simple;
	bh=kJScALIcaZaahWIzaDjdqDQ2xqLKvVvLgUpiCUAaWHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tmN1bUor0SWrEVwtBqYktEZm06m/fiNgbYXOFEAG/TxNtfsDt6MiDixreFH0GapUUsgB5tp7Qi8CVJF0uM+AC9xgJdfifWZPqKIClx7Nnw8/V/6IsgvNYjTJHI8uSgqFp7mqq68hK4lZU+B/8DpiI46rJR7kswuBpSwT08qOJVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RsWGgpin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RsWGgpin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96154C4CEED;
	Tue, 10 Jun 2025 14:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749566615;
	bh=kJScALIcaZaahWIzaDjdqDQ2xqLKvVvLgUpiCUAaWHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RsWGgpinyYnOWqyB1afVCm9f8LGYyJRnymPtL076ZRkF/pRsqEvdrtYtejVydQMbz
	 N5Vw3j9/SJja1ET+RSZS9RwDGS5c7FX97S7gzFtIcDvwtOrGxgfHIhq0Hy1pf7y2D4
	 X2Wq1szdt9U3M/Ly5BtkY2u7LcUQi3sYWyTblagnGU8DFdJYhijriaPeWd+sgrRWTd
	 GJXtDzc0wfHLBIw0cJ1Nzy43ydvtZZpwtjcpb21EGL/eGZrcmmFhUmAFNqED5DwEeo
	 6S5Ipj4sSjnPKw2gibk+1okO0UCr6aFnaiYY9L9VOVr0H9tbEY27m5uTkbj2rL3Hys
	 RC4oEup/og3KA==
Date: Tue, 10 Jun 2025 07:43:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Li Chen <me@linux.beauty>
Cc: Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V2] generic/738 : add missing _fixed_by_git_commit line
 to the test
Message-ID: <20250610144334.GC6143@frogsfrogsfrogs>
References: <20250610025242.11403-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250610025242.11403-1-me@linux.beauty>

On Tue, Jun 10, 2025 at 10:52:42AM +0800, Li Chen wrote:
> From: Li Chen <chenl311@chinatelecom.cn>
> 
> Add the usual  _fixed_by_kernel_commit  line so the user can find
> that the hang is cured by
> 
>     ab23a7768739  ("xfs: per-cpu deferred inode inactivation queues")
> 
> The hung task call trace would be as below:
> [   20.535519]       Not tainted 5.14.0-rc4+ #27
> [   20.537855] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [   20.539420] task:738             state:D stack:14544 pid: 7124 ppid:   753 flags:0x00004002
> [   20.540892] Call Trace:
> [   20.541424]  __schedule+0x22d/0x6c0
> [   20.542128]  schedule+0x3f/0xa0
> [   20.542751]  percpu_rwsem_wait+0x100/0x130
> [   20.543516]  ? percpu_free_rwsem+0x30/0x30
> [   20.544259]  __percpu_down_read+0x44/0x50
> [   20.545002]  xfs_trans_alloc+0x19a/0x1f0
> [   20.545747]  xfs_free_eofblocks+0x47/0x100
> [   20.546519]  xfs_inode_mark_reclaimable+0x115/0x160
> [   20.547398]  destroy_inode+0x36/0x70
> [   20.548077]  prune_icache_sb+0x79/0xb0
> [   20.548789]  super_cache_scan+0x159/0x1e0
> [   20.549536]  shrink_slab.constprop.0+0x1b1/0x370
> [   20.550363]  drop_slab_node+0x1d/0x40
> [   20.551041]  drop_slab+0x30/0x70
> [   20.551600]  drop_caches_sysctl_handler+0x6b/0x80
> [   20.552311]  proc_sys_call_handler+0x12b/0x250
> [   20.552931]  new_sync_write+0x117/0x1b0
> [   20.553462]  vfs_write+0x1bd/0x250
> [   20.553914]  ksys_write+0x5a/0xd0
> [   20.554381]  do_syscall_64+0x3b/0x90
> [   20.554854]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   20.555481] RIP: 0033:0x7f90928d3300
> [   20.555946] RSP: 002b:00007ffc2b50b998 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
> [   20.556853] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f90928d3300
> [   20.557686] RDX: 0000000000000002 RSI: 000055a5d6c47750 RDI: 0000000000000001
> [   20.558524] RBP: 000055a5d6c47750 R08: 0000000000000007 R09: 0000000000000073
> [   20.559335] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
> [   20.560154] R13: 00007f90929ae760 R14: 0000000000000002 R15: 00007f90929a99e0
> 
> localhost login: [   30.773559] INFO: task 738:7124 blocked for more than 20 seconds.
> [   30.775236]       Not tainted 5.14.0-rc4+ #27
> [   30.777449] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [   30.779729] task:738             state:D stack:14544 pid: 7124 ppid:   753 flags:0x00004002
> [   30.781267] Call Trace:
> [   30.781850]  __schedule+0x22d/0x6c0
> [   30.782618]  schedule+0x3f/0xa0
> [   30.783297]  percpu_rwsem_wait+0x100/0x130
> [   30.784110]  ? percpu_free_rwsem+0x30/0x30
> [   30.785085]  __percpu_down_read+0x44/0x50
> [   30.786071]  xfs_trans_alloc+0x19a/0x1f0
> [   30.786877]  xfs_free_eofblocks+0x47/0x100
> [   30.787727]  xfs_inode_mark_reclaimable+0x115/0x160
> [   30.788708]  destroy_inode+0x36/0x70
> [   30.789395]  prune_icache_sb+0x79/0xb0
> [   30.790056]  super_cache_scan+0x159/0x1e0
> [   30.790712]  shrink_slab.constprop.0+0x1b1/0x370
> [   30.791381]  drop_slab_node+0x1d/0x40
> [   30.791924]  drop_slab+0x30/0x70
> [   30.792469]  drop_caches_sysctl_handler+0x6b/0x80
> [   30.793328]  proc_sys_call_handler+0x12b/0x250
> [   30.793948]  new_sync_write+0x117/0x1b0
> [   30.794471]  vfs_write+0x1bd/0x250
> [   30.794941]  ksys_write+0x5a/0xd0
> [   30.795414]  do_syscall_64+0x3b/0x90
> [   30.795928]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   30.796595] RIP: 0033:0x7f90928d3300
> [   30.797090] RSP: 002b:00007ffc2b50b998 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
> [   30.798033] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f90928d3300
> [   30.798852] RDX: 0000000000000002 RSI: 000055a5d6c47750 RDI: 0000000000000001
> [   30.799703] RBP: 000055a5d6c47750 R08: 0000000000000007 R09: 0000000000000073
> [   30.800833] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
> [   30.801764] R13: 00007f90929ae760 R14: 0000000000000002 R15: 00007f90929a99e0
> [   30.802628] INFO: task xfs_io:7130 blocked for more than 10 seconds.
> [   30.803421]       Not tainted 5.14.0-rc4+ #27
> [   30.803985] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [   30.804979] task:xfs_io          state:D stack:13712 pid: 7130 ppid:  7127 flags:0x00000002
> [   30.806013] Call Trace:
> [   30.806399]  __schedule+0x22d/0x6c0
> [   30.806867]  schedule+0x3f/0xa0
> [   30.807334]  rwsem_down_write_slowpath+0x1d8/0x510
> [   30.808018]  thaw_super+0xd/0x20
> [   30.808748]  __x64_sys_ioctl+0x5d/0xb0
> [   30.809292]  do_syscall_64+0x3b/0x90
> [   30.809797]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   30.810454] RIP: 0033:0x7ff1b48c5d1b
> [   30.810943] RSP: 002b:00007fff0bf88ac0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [   30.811874] RAX: ffffffffffffffda RBX: 000055b93ae5fc40 RCX: 00007ff1b48c5d1b
> [   30.812743] RDX: 00007fff0bf88b2c RSI: ffffffffc0045878 RDI: 0000000000000003
> [   30.813583] RBP: 000055b93ae60fe0 R08: 0000000000000000 R09: 0000000000000000
> [   30.814497] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> [   30.815413] R13: 000055b93a3a94e9 R14: 0000000000000000 R15: 000055b93ae61150
> 
> Signed-off-by: Li Chen <chenl311@chinatelecom.cn>

Looks good, though ab23a7768739 is a bit of a backport ;)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> Changes since v1: use _fixed_by_kernel_commit helper as suggested by
> Zorro
> 
>  tests/generic/738 | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tests/generic/738 b/tests/generic/738
> index 6f1ea7f8..b0503025 100755
> --- a/tests/generic/738
> +++ b/tests/generic/738
> @@ -9,6 +9,9 @@
>  . ./common/preamble
>  _begin_fstest auto quick freeze
>  
> +[ "$FSTYP" = "xfs" ] && _fixed_by_kernel_commit ab23a7768739 \
> +	"xfs: per-cpu deferred inode inactivation queues"
> +
>  _cleanup()
>  {
>  	xfs_freeze -u $SCRATCH_MNT 2>/dev/null
> -- 
> 2.49.0
> 
> 

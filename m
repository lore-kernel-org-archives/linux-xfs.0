Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF723B6354;
	Sun, 13 Sep 2026 06:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789280914; cv=none; b=gYCYyRy6mqeQ42RI4siY868oyIyhBAERsCadZzh56SpgS5vM34SYJr7tCrfPzwttvHcQCuZfVvgHiGe1Qdfe1dVLuKPLwz3Xp492Nk0PFQK2i236TbVJkDfq0bWZ9BBMIlb3F8DUqsCYJ38ah9tIZ5D/DMVbqlSBpIsvgNMMnIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789280914; c=relaxed/simple;
	bh=shFRVVpE+VNZolsi6ztjlaEnF+GpCw0ats+ZWD7xWrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JwrACuCE3RS0oXkOE97henHaydzHAsgIjSUCd+7z+xJUfnteKkkixnFzTu8HswdfzivHz2OeY8/Wnze2Q88AN2dwwDCfSL/sz957OsP6ocjdM9+KxkQ/dbimjwvYI3SCqkMo0nqX/6wp8GOn7GO31Wsk3tIy9npDqy35PkPf3aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P7UheOav; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7UheOav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C841F000FF;
	Sun, 13 Sep 2026 06:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789280910;
	bh=UU7i//fV9asFs1S8GMCZ2V8jNCnAK3XGgRC+nuOoW44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P7UheOavzc1vyZrZivWcvqU/rcJ32aPpyjTkTNttl4Fvgm4XAFIj6vbnc2CDSAYlN
	 suSALUaEZuy0fy4YJME6kCHOqjVPFB5nxZ7NitEpMZ1TXUg8yW88JltTTsy2J3bLWk
	 bzUhN7l0UGYuLorhYKhY15e3SuM1TlrdThK7hIB1OEsk4pjBPB4cuQMXwDcsWTRc5A
	 psAAbc7GtHG98Kn5HX0GZcsl2m4j+xBJQR33WAglhx6scp+DToNVqqTrZrqM8JNx+8
	 zyGY0qUlcEM/WFBpqX2sYdkv/oxQ8E0b9UjpELz6GFREaC3xMl4Q/tkSpEBLObnw9f
	 aYcCX56eBZ5ZQ==
Date: Sun, 13 Sep 2026 08:28:25 +0200
From: Carlos Maiolino <cem@kernel.org>
To: co <co+af981e62f5c7171a@bugs.sh>
Cc: cedalion@bugs.sh, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] fs/xfs: out-of-bounds in xlog_recover_buf_reorder()
Message-ID: <aqZALi7GdVprcNOh@cronus.toxiclabs.cc>
References: <1p0VZ9ucW56B8jIOVuXOhm0yFEYlXq2oDoOo@bugs.sh>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1p0VZ9ucW56B8jIOVuXOhm0yFEYlXq2oDoOo@bugs.sh>

Thank you for the report... A few suggestions below:

>     Everything in this mail is validated by the reproducer below.
> 
>     We also hold an unreviewed LLM-generated analysis and candidate
>     patch. The same reproducer panics the unpatched kernel and runs
>     clean with that patch applied. Use it as a starting point, or ignore
>     it and write your own:
> 
>         patch.diff  https://bugs.sh/b/af981e62f5c7171a/patch.diff

If you have a suggested patch, include it inlined in the message, do not
expect somebody to go and click on some random link sent to the mailing
list.


>         report.md   https://bugs.sh/b/af981e62f5c7171a/report.md

If you have no capacity to review your generated AI reports, then don't
send them to the list, we are not your AI-slop moderators/reviewers.
Neither your lab rats.

> 
>     Happy to test patches. Complaints and suggestions about our work
>     are welcome at:
> 
>         cedalion@bugs.sh
> 
> == Environment =========================================================
>     Reproduced on  2709dd5ae32f ("Merge tag 'sched-urgent-2026-08-22' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip")
>     VM setup       https://bugs.sh/b/af981e62f5c7171a/run.sh
>     config         https://bugs.sh/b/af981e62f5c7171a/config.gz
>     poc            https://bugs.sh/b/af981e62f5c7171a/repro.c

Again, same as above. Include everything in the email, do not expect
people to go and keep clicking on random links to access whatever
information you provided.
A reproducer is appreciated, but it should be in the email message not
at some random URL. This is not safe and is a security risk for
maintainers and developers to just go and click on random links.

Carlos

> 
> == Sanitizer Report ====================================================
> BUG: KASAN: slab-out-of-bounds in xlog_recover_buf_reorder (fs/xfs/xfs_buf_item_recover.c:164)
> Read of size 2 at addr ffff88800beee384 by task exploit/147
> Call Trace:
> dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
> print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
> kasan_report (mm/kasan/report.c:595)
> xlog_recover_buf_reorder (fs/xfs/xfs_buf_item_recover.c:164)
> xlog_recover_reorder_trans (fs/xfs/xfs_log_recover.c:1929)
> xlog_recover_commit_trans (fs/xfs/xfs_log_recover.c:2053)
> xlog_recovery_process_trans (fs/xfs/xfs_log_recover.c:2319)
> xlog_recover_process_data (fs/xfs/xfs_log_recover.c:2510)
> xlog_do_recovery_pass (fs/xfs/xfs_log_recover.c:3253)
> xlog_do_log_recovery (fs/xfs/xfs_log_recover.c:3340)
> xlog_do_recover (fs/xfs/xfs_log_recover.c:3377)
> xlog_recover (fs/xfs/xfs_log_recover.c:3502)
> xfs_log_mount (fs/xfs/xfs_log.c:617)
> xfs_mountfs (fs/xfs/xfs_mount.c:1031)
> xfs_fs_fill_super (fs/xfs/xfs_super.c:1987)
> get_tree_bdev_flags (fs/super.c:1887)
> vfs_get_tree (fs/super.c:1947)
> fc_mount (fs/namespace.c:1198)
> path_mount (fs/namespace.c:3772 fs/namespace.c:3848 fs/namespace.c:4168)
> __x64_sys_mount (fs/namespace.c:4181 fs/namespace.c:4397 fs/namespace.c:4374 fs/namespace.c:4374)
> do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
> entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
> The buggy address belongs to the object at ffff88800beee380
> which belongs to the cache kmalloc-8 of size 8
> The buggy address is located 0 bytes to the right of

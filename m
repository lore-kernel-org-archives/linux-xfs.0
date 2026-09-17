Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328824ED1AF;
	Thu, 17 Sep 2026 17:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665968; cv=none; b=FuxlbWXXGx+caa2oVM5S+5wXgJ4pp4ZFJXrsghqVF10FDM0dpEmwuwfvsokrWyRVRYWI9tULYrH21jLzD0m/6Z8y4/UITkkhtq5wGFS6ofxiIk4+Xg1qWaMm1geAzU2cO44wNDSL6q4L1WW6SCHKrsP/kOkDcQ3yApEMXwhZ50c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665968; c=relaxed/simple;
	bh=VFbnV6j9DuufYT6S60+uCjOEew2SHehBRlJUcQSjMe0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CTTdGQ3WhEwPPbr6IxiJFf0ZEP0rDJnIt5qSp8AbZqq9Y//sGDJO9fXgIepVMBLLeCRPR9DhZtWFsF8Vaf1jYthsR658PMUUVzgHBfsEp41tfOv3VilAFX7grLxVHu7uy6WohFZprwt18B9uqo8rNCnWPCZ95BQgVcRhD2mUUxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=ClBAkLtT; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gCiyXMY6; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="ClBAkLtT";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gCiyXMY6"
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.phl.internal (Postfix) with ESMTP id 510A1EC0193;
	Thu, 17 Sep 2026 13:26:05 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Thu, 17 Sep 2026 13:26:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1789665965;
	 x=1789752365; bh=D+o9trAtYGhDLpSMEEW1KG628RFEVK4YErYgH791//c=; b=
	ClBAkLtTSjLikMfLTuc0rrDg0a7Th3U881Jx+SXn7WZNjNlZF8IY0LqeLvlOep8N
	CcM/MCfbywEkYqywtAVfZJe++/6EsKLTDGp6Wk3Jfg/MhWR0OrvFol7r/xub0Rhl
	YyMb2nXuLXo4vjz2mASc32BF40UghIvbRLUhcxYy/V5q7IOsBpQ7IUzWj/hfO43J
	Hxp5jC93KhXOK9vFH4uXRf9XsuNieDJIhFKp0OjRmSOG7IIikq3EdvYbXBOc2s3B
	m7Ew71Zgr7jlUmAdP7vyPPCa+JPkPXln0KRlkymrHNBGEB31xirkh2gtAaC744bM
	IHsLqx8GhFxUQOdcqxtbuw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789665965; x=
	1789752365; bh=D+o9trAtYGhDLpSMEEW1KG628RFEVK4YErYgH791//c=; b=g
	CiyXMY69Zdi6wK6lub/sP0BBSGtz1bb64be01h3BuxzeeeOjLde2b/lLLBya/RpQ
	TwbfEtFZomjjAnJKImFReUaeDsDVpG2aS4VkXRWTxm56vYPqmGLBs0HYj1ZA7yyB
	bIpM67IACuHiZHD7x06eD01UoTYfIgJxVcUeTUMhF7J8oeD0apZIQ+ACBPK/5/A9
	0s28S/oXbwzIMBaNVygifUD2TC3NTrwxQMeSVfp7qgfoha9WqvkoqpLcYFzzReaQ
	WCaCJarpiwt/vJKpB36KPHoEcXM/q4jDp8bzOXvGsmPHHXn4vWdr3Ag7WQ3FyShE
	qAW6Edkaw4xlDuMowkD1w==
X-ME-Sender: <xms:rCKsapxFhbw3V54cKO8bRmz04m3E6Vr6qyfnZYNvAdrMNO9gHMl56A>
    <xme:rCKsanHZOE6BF78t88U9i9FEcOr6M5pu5cYS3o-UdUKQychrFNb0tsw3F5yhp15lu
    O7b7sxP54wAjqKLI9bONDLTb15bBIVAgsV6h6hLs17cDCpwGUr2OQR2kg>
X-ME-Received: <xmr:rCKsatxQ_YByg4LLDctm4rdribvd3fNYDm4Lmd9v1V78m0xmIUXNsTllbT5Uyzg_u_L77-TFKBVwzaINH2-PmrZHf_3brA>
X-ME-Proxy-Cause: dmFkZTFZPqA/zw/tJRZySJFJeqCvGa+EUItf0Hdmz7l5InvXBl7J++UJO+TqRTWdoWfhFT
    fB5Udo2N7AuaSdTHXVDcPBRh8H9IJTP7jWC2iCrh23/gajQvvMvWjRSDLrbwI1/ArwgE2v
    V24CGd2ZLZVJz+X88iVYNTLPm8zhyJwhl1FqVSU98HF4oTHE2TcoxIWhw+9cQSkWyWTSxe
    WE/Q219c+kKmE54dx8AzU5uYsFGidgprK0bIgn6pUPEzRjW9vro0r48CBpm0oJxImdPzQ2
    5FL7NLvpzqt4IfwyrGxT4VbyXcAdG+e16ccwz2M3bw+AQCDkM6lALnCS6j7CjXg/hMrjL0
    fMBXRbaCzpQFldps68WMj4JnrklQY//1K1gkYNmEPJRYn65kOvWVvxgB4nzTHLeW/JT6s4
    vEASy8YX7t80lOSjTd6uGQvZ0UpmrYMAMhY/1Sc8HM/iOdCm44/Wj8Uj2n9XzOoynPfzx7
    CMUjcBO3hHhgw+23nekqTvvcQDZ5xFn1I+Rc23+qcmGiSSC/AbIgfZCEfoLxHhVTrsoij7
    Be13Zl3vsH9uPiuR2UkEp7WZbgcswrkyO8MCAjq6iUNXbWWtjVjKFVQKhWX6/ylxfpcHaa
    To8LeKcs3nnbGj2NDFHvuSanD7DjR928jnBbgecccYzYGrLY21ivm/A2dKEA
X-ME-Proxy: <xmx:rCKsaotj5yMdbnm2q-DrpsT_d-Gx72BWHgBbA0zOCdhCbSucDPIGNQ>
    <xmx:rSKsaq1XAwNHtAlUji65E4mHjr7VUgIi0mIVrS5W1SvwjvqqIJ1uwg>
    <xmx:rSKsaj-p2j0dpM3G5N8p2p-UeYBE-CLZWmzBC8EpS5jhq2M8pfb8aA>
    <xmx:rSKsarM8TxUSfOl6YS6FQerB5XacC4LiKR2eFHdZoqJf-RMGNpBh3Q>
    <xmx:rSKsalbR6pNEr5F-O-9Fmlxz_38aVHbX6GaCADk5WXHJc2fcPuZ_X8rC>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Sep 2026 13:26:04 -0400 (EDT)
Message-ID: <92b9d941-37b5-46b3-9e51-58ce75ad99ce@sandeen.net>
Date: Thu, 17 Sep 2026 12:26:03 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] fs/xfs: out-of-bounds in xlog_recover_buf_reorder()
To: co <co+af981e62f5c7171a@bugs.sh>, linux-xfs@vger.kernel.org,
 Carlos Maiolino <cem@kernel.org>
Cc: linux-kernel@vger.kernel.org
References: <1p0VZ9ucW56B8jIOVuXOhm0yFEYlXq2oDoOo@bugs.sh>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <1p0VZ9ucW56B8jIOVuXOhm0yFEYlXq2oDoOo@bugs.sh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/13/26 12:56 AM, co wrote:
> This is a bug report, not a patch submission.
> 
> We found a bug reachable in:
> 
>     path    fs/xfs
>     crash   out-of-bounds in xlog_recover_buf_reorder()
>     commit  2709dd5ae32f ("Merge tag 'sched-urgent-2026-08-22' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip")
> 
> Config, environment, the sanitizer report and a C reproducer follow.

A few thoughts here.

This looks very much like you have re-implemented syzkaller & syzbot,
and are following in their missteps.

A filesystem bug report with a reproducer consisting of a big binary
array in a C file is just about the least useful way to provide the
report. The first thing anyone looking at it must do is reverse-engineer
what is going on, what the inputs are, etc.
"static const unsigned char img_blob[]" is not conducive to that.

After a prolonged effort, syzbot now provides a filesystem image for
reports like these, so that standard filesystem analysis and debugging
tools can be used. At a minimum, you should do the same.

I would also suggest that if you have compute resources to spare, you
can do more than test only your targeted reproducer. We have a
comprehensive test suite available, and anyone can run it. It's a fairly
standard expectation that patches sent to the list have been well tested,
and not left as work for others to do.

But as a bigger picture, as Dave Chinner has said elsewhere on the
list recently, these sorts of fuzzer/AI guided bugs and patches are
not addressing problems holistically. They lead to lots of one-off
fixes (or band-aids) sprinkled around the code, rather than looking
at the problem in a comprehensive or systemic manner. Dave's doing work
now to validate all on-disk data used during log replay,
and it will almost certainly address the class of bug you've reported
here.

The problem we are facing more and more frequently is that it is becoming
extremely easy for just about anyone to generate bug reports. It still
falls to a small set of humans to evaluate and respond to those reports.

The more reporters can do to reduce friction and increase confidence
in the work being presented, the better.

As a final thought, given that this looks very much like syzkaller, I
would ask whether your framework does things that syzkaller cannot do.
Syzkaller is well-established and well understood, with a good framework
for tracking reports, fixes, etc. Re-inventing that is a burden on the
whole community; if you have improvements over syzkaller, folding those
back into the syzkaller project would be preferable to what looks essentially
like a fork, and asking the kernel community to now deal with an entirely
new, separate fuzzer-bug reporting and tracking framework.

Thanks,
-Eric

> == Notes ===============================================================
>     If you fix this bug, this tag credits the report and lets us
>     close it on our side:
> 
> Reported-by: co+af981e62f5c7171a@bugs.sh
> 
>     Everything in this mail is validated by the reproducer below.
> 
>     We also hold an unreviewed LLM-generated analysis and candidate
>     patch. The same reproducer panics the unpatched kernel and runs
>     clean with that patch applied. Use it as a starting point, or ignore
>     it and write your own:
> 
>         patch.diff  https://bugs.sh/b/af981e62f5c7171a/patch.diff
>         report.md   https://bugs.sh/b/af981e62f5c7171a/report.md
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
> 
> 
> ---
> The report format is based on syzbot bug report.
> 
> This report is generated by a bot. It may contain errors.
> See https://github.com/n132/cedalion for more information.
> 
> For any issue with this report, reach out to cedalion@bugs.sh
> 
> If the report is already addressed, let us know by replying with:
> #co fix: <commit hash>
> 
> If the report is a duplicate of another one, reply with:
> #co dup: <lore link>
> 
> If you want to undo deduplication, reply with:
> #co undup
> 
> 
> 


Received: from bg-bec.cloudflare-smtp.org (bg-bec.cloudflare-smtp.org [104.30.16.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F632EC09B
	for <linux-xfs@vger.kernel.org>; Sun, 13 Sep 2026 05:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.30.16.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789278974; cv=none; b=UTcNPrCA2hQWleuBYulZdltJi2PME+X1JD3JLD8tRyJE6pxYyQPd5Wi8JwXhCBEL0w5IqXWwJAqhV+CvmbrEW1d7vPiK7B57394JRjPM/uJDfico3ziEP3Klfc6xbZM1361Ii85HkExlItWgj0aslrxMxsCkk8xZdyT/N+MNpO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789278974; c=relaxed/simple;
	bh=upjDGJJNlweE9DH551XLTHMrWR/jjDCvnblk6fuBddI=;
	h=From:Message-ID:Date:Subject:To:Cc:MIME-Version:Content-Type; b=RDKMrL2eLAbaxjbqBYS1ik3RyocApBBueVnZoC4jIZ+5PVeARuFQiy+21MmgbeC6IctGCJKTZ/7H5MTfsKBG2QtgN0pG28EuVuPbJcDV/ANSN+DmVHwwGm2zUBxfAa+C0l5yY/pvqqynUzdnfryPLWkRlfirr6IOxNULw9/XRaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bugs.sh; spf=pass smtp.mailfrom=cf-bounce.bugs.sh; dkim=pass (2048-bit key) header.d=cloudflare-smtp.org header.i=@cloudflare-smtp.org header.b=DzisnToR; dkim=pass (2048-bit key) header.d=bugs.sh header.i=@bugs.sh header.b=Mt0e6hKM; arc=none smtp.client-ip=104.30.16.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bugs.sh
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cf-bounce.bugs.sh
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare-smtp.org header.i=@cloudflare-smtp.org header.b="DzisnToR";
	dkim=pass (2048-bit key) header.d=bugs.sh header.i=@bugs.sh header.b="Mt0e6hKM"
DKIM-Signature: v=1; a=rsa-sha256; s=cf2024-1; d=cloudflare-smtp.org; c=relaxed/relaxed;
	h=Cc:To:Subject:Date:From:Feedback-ID:from:reply-to:resent-date
	:resent-from:resent-to:resent-cc:in-reply-to:references:list-id:list-help
	:list-unsubscribe:list-unsubscribe-post:list-subscribe:list-post
	:list-owner:list-archive; t=1789278972; x=1789883772; bh=vH++NRt8Iwj+fj4AY2
	MO/3uFUwrZEsm+rlOa3TQMApc=; b=DzisnToRFhwX+OiAepFnAeWjTz6P5WCRjvJXPhG/rQl3c
	ri3+jxQUZP2i2ZBiCbnGsYNIjtUwYG1ntn/vPh/Ii4sD4Ntpfe3t4LlxbFVupK+iBGezoNcckea
	zlk25sRyKLVi58Skn4Yj7eM6WRsC/fEUpQWq2aiXZBMCHFcze3t3CSv+P8lK3W8/E2sCdzWEtYs
	v1ktWxnbWIjFnRQpxFX10FWJoDM5vZ6NfxpSdAq73AoqQqjrfH3QauqpRLnsGGoOiMi9gxgcwnT
	O7PHA8BhW24xXMBj/nvh374Q/q9T+dTh3kjmwj0WC05rEDH57rwQ4tHKkJLi4rcgnBV+uMKw==;
DKIM-Signature: v=1; a=rsa-sha256; s=cf-bounce; d=bugs.sh; c=relaxed/relaxed;
	h=Cc:To:Subject:Date:From:Feedback-ID:from:reply-to:resent-date
	:resent-from:resent-to:resent-cc:in-reply-to:references:list-id:list-help
	:list-unsubscribe:list-unsubscribe-post:list-subscribe:list-post
	:list-owner:list-archive; t=1789278972; x=1789883772; bh=vH++NRt8Iwj+fj4AY2
	MO/3uFUwrZEsm+rlOa3TQMApc=; b=Mt0e6hKM/eNVxxTAkb22WCQVzcK0OPuqWqhYhnHqtJQTZ
	4ZSrIi6ISltISjxX9KLb+MMM3pWCFNluGTWbFyEDl4RimKqJ48lAVMoEX/Uw+bDQ545uGffnkvO
	XiIjW3FQSk5CkcIZzUkihQo/YLWNgBpOvd6Rkzsn0NkhzaK45tVZupkxjPRlByevcTQB4z39kez
	W3Mfs1LzvNXBejREZa4Gq79utRuhBeLruVSKSgU/EYQC4GyQVgM+6fAa8f+gbdz5u8Ywec4V7av
	Ha64RDSP9x2uqraVCFfWpBld2LfGZY5KLFLktKyEAQbMRNULMXEYG0wVfEAN8D5MVJ5I3y2g==;
Feedback-ID: bugs.sh:5:6:Cloudflare
From: co <co+af981e62f5c7171a@bugs.sh>
Message-ID: <1p0VZ9ucW56B8jIOVuXOhm0yFEYlXq2oDoOo@bugs.sh>
Date: Sun, 13 Sep 2026 05:56:00 +0000
Subject: [BUG] fs/xfs: out-of-bounds in xlog_recover_buf_reorder()
To: linux-xfs@vger.kernel.org, "Carlos Maiolino" <cem@kernel.org>
Cc: linux-kernel@vger.kernel.org, co <co+af981e62f5c7171a@bugs.sh>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

This is a bug report, not a patch submission.

We found a bug reachable in:

    path    fs/xfs
    crash   out-of-bounds in xlog_recover_buf_reorder()
    commit  2709dd5ae32f ("Merge tag 'sched-urgent-2026-08-22' of git://git=
.kernel.org/pub/scm/linux/kernel/git/tip/tip")

Config, environment, the sanitizer report and a C reproducer follow.

=3D=3D Notes =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    If you fix this bug, this tag credits the report and lets us
    close it on our side:

Reported-by: co+af981e62f5c7171a@bugs.sh

    Everything in this mail is validated by the reproducer below.

    We also hold an unreviewed LLM-generated analysis and candidate
    patch. The same reproducer panics the unpatched kernel and runs
    clean with that patch applied. Use it as a starting point, or ignore
    it and write your own:

        patch.diff  https://bugs.sh/b/af981e62f5c7171a/patch.diff
        report.md   https://bugs.sh/b/af981e62f5c7171a/report.md

    Happy to test patches. Complaints and suggestions about our work
    are welcome at:

        cedalion@bugs.sh

=3D=3D Environment =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    Reproduced on  2709dd5ae32f ("Merge tag 'sched-urgent-2026-08-22' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/tip/tip")
    VM setup       https://bugs.sh/b/af981e62f5c7171a/run.sh
    config         https://bugs.sh/b/af981e62f5c7171a/config.gz
    poc            https://bugs.sh/b/af981e62f5c7171a/repro.c

=3D=3D Sanitizer Report =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-out-of-bounds in xlog_recover_buf_reorder (fs/xfs/xfs_buf_=
item_recover.c:164)
Read of size 2 at addr ffff88800beee384 by task exploit/147
Call Trace:
dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
kasan_report (mm/kasan/report.c:595)
xlog_recover_buf_reorder (fs/xfs/xfs_buf_item_recover.c:164)
xlog_recover_reorder_trans (fs/xfs/xfs_log_recover.c:1929)
xlog_recover_commit_trans (fs/xfs/xfs_log_recover.c:2053)
xlog_recovery_process_trans (fs/xfs/xfs_log_recover.c:2319)
xlog_recover_process_data (fs/xfs/xfs_log_recover.c:2510)
xlog_do_recovery_pass (fs/xfs/xfs_log_recover.c:3253)
xlog_do_log_recovery (fs/xfs/xfs_log_recover.c:3340)
xlog_do_recover (fs/xfs/xfs_log_recover.c:3377)
xlog_recover (fs/xfs/xfs_log_recover.c:3502)
xfs_log_mount (fs/xfs/xfs_log.c:617)
xfs_mountfs (fs/xfs/xfs_mount.c:1031)
xfs_fs_fill_super (fs/xfs/xfs_super.c:1987)
get_tree_bdev_flags (fs/super.c:1887)
vfs_get_tree (fs/super.c:1947)
fc_mount (fs/namespace.c:1198)
path_mount (fs/namespace.c:3772 fs/namespace.c:3848 fs/namespace.c:4168)
__x64_sys_mount (fs/namespace.c:4181 fs/namespace.c:4397 fs/namespace.c:437=
4 fs/namespace.c:4374)
do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:8=
4)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
The buggy address belongs to the object at ffff88800beee380
which belongs to the cache kmalloc-8 of size 8
The buggy address is located 0 bytes to the right of


---
The report format is based on syzbot bug report.

This report is generated by a bot. It may contain errors.
See https://github.com/n132/cedalion for more information.

For any issue with this report, reach out to cedalion@bugs.sh

If the report is already addressed, let us know by replying with:
#co fix: <commit hash>

If the report is a duplicate of another one, reply with:
#co dup: <lore link>

If you want to undo deduplication, reply with:
#co undup



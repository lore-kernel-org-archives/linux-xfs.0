Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB7F3451CE
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 08:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768812813; cv=pass; b=SGoFJujMpu95sam7ct01/j5akr1aj13ja4RyAXWVlXn5fd7LuaiFy9Bslnp9TGyTJSqLVupv3j+HrcToiura63xK6l2X0Kgipt5EMNfZL5buO+s3t9WjQeL0zIp/iMpsjQewFaqRxulEVX3hDOCwLVLbSaVPknL1xFhOEW3Lba8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768812813; c=relaxed/simple;
	bh=N47UuiW1Rn8kqQ/w7dtmlA650AWk9lWMjFbw2V0RQ5s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fh9uBXNxk8wiAF8hsqmBmArHo0fyI3zAvvqiNvBhPsDxTmHMI/RbmVyXTtv1uK5Rw0KyHGQ6VRmNTED4La7xEYgaBtzuVtENZGdfAx1Uh8rlTTwo2KCIB20VLJLwkZm7+PXRWTAcjpyVZHM9LAn8d/bAt7tlPE0JidnZ+uGVVbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gmz5Ec3N; arc=pass smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gmz5Ec3N"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6610b241d19so1987652eaf.0
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 00:53:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768812810; cv=none;
        d=google.com; s=arc-20240605;
        b=D7MMqc8E6HwSNu9CMV8g1A/gD1/jTEAnLJCnYlVvw49Xo11zg/xwfe/nW/EpZxIxtM
         f5kDN2ra+s4reCfstWsc5uzPY8Vu1z44f2EO0Hr9HVFx7ZqrLZ4wiHscywqZhUQPI7C1
         Db6jSCX5v6HXiLEvyAvbZFpz36kdN+og+Hc8nrxsfeB0AmvnlVejTem7ybwe6i663omK
         8Ba2FzzIZxyc5Q0W4DTELx61Gya1RvVntAJNjKXnTBRVYj1V8VifGofh4J+H6MgK0zfc
         uFbp6oroloIfBb3orcNVroTvyN/GLRcW3nslFHBQRTClF42idIqVhtLGIVUzaxL+TC9U
         HQzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YLXfgpMQ+ykg9+69k/0Y1IptfficyceO7B7YsmKjWoE=;
        fh=vMVIIbNhm0MzQ5XS+z27KlQ4C6NlkffISQN9Tl6NtXY=;
        b=cU/Bm+etXznEXJYuI8OykVUT6zsUFDtZeu+Auez0nrynEF/ThcSIPGZsH+Q7e9ppcr
         fGzOIja2fhJ/X5nCYuB0yWjge+2wEAv5Wc4SmYyLwf5rXaiD9dvA27MSTbrY19Fk1JO5
         IdNUD6IdQslj5u0rTp1emLz9Qvmmh6RlcE1+eNS9DOhlzK0MocLUPWFgYxd6rSmwHZil
         tXNH/1aJdslIKKpvT1vlm7bOeig/WGQqmh6ythaOkC9M+T/B0A7cFjLM51+HZgj2u2I8
         tCJ4BmnT83t4N4hh6fKCBDEmcTAArbFrbPnL+T8KWgMrJ1FYw7s69KCahG0Cn3F2px1k
         yanA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768812810; x=1769417610; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YLXfgpMQ+ykg9+69k/0Y1IptfficyceO7B7YsmKjWoE=;
        b=gmz5Ec3NzlqDX83WxYyoBDSFddtcvY5V9LyieSq6D6npsMkiRISOX3aBA1ZJ0LyWFj
         vpD7LWWopwBIGsrNwCjuAGcVBMY3qITXpurAc7rics488H6Ca3kGxvAT3RF9OcIeoMoW
         0l/9CUsP7Yd9QcAdRoW/gGDwbLbbYNWicu8U6kHzfwtzWrW7TRlsnQiARzLs5lKNZ0U3
         3o9I8dSXw4mnjf68lZ50r2Nc6WbZOPNJj0eDuez/iYRr20hmJcnWHZ9/V7zv6M6CjStm
         30kNwFaVbS+3ZP331zNfE85uZn99Wi2p6a0IZ4AyXlEw6Lw1tyfmnZoZPKUZwZKgOhLg
         Vw+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768812810; x=1769417610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YLXfgpMQ+ykg9+69k/0Y1IptfficyceO7B7YsmKjWoE=;
        b=H1K+Na+hrfhNTnPFUSdPxhTmzYQ9zgINIAKXKvKm+VEWvEYyk89THxRBFUP9wuK7n/
         h15IO6DycoxI61ccPLkDGvAaa0Swj9up/NID7xm4Ze0YErc72ZDhNCkRCvi3oqQx1CJw
         GBUISa6WvkY1ATwoKs+cnmZLgV9MIMMWjVP07qBN5XBaZLSPmftVO0VdDemwp05pi9t9
         N26sYBJiXEiKHxRuB9+f9649KDBxZgLLz9xPUEry023PL2oRJ+3ozsKJot7nSXBciL1L
         TzQk6UBbRgvWKS6H3apRv4Gh8iZJdnkqdIF2Mc3WJL0+iK/qoM9KZk3x8fMcwtX6G+8o
         IhMg==
X-Forwarded-Encrypted: i=1; AJvYcCXEYpAm9lEyR9lB4pg/qnMYylGNbtMS0scOVHk7nwlCAdkJLNWGv8g/Rhxb30vU1g7lqZjHnU3igJo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAj2I06PdRuw1lEOUd/7OvXE1DXaNY4HAd8e9CtL1XcguFLrR+
	zRLW3rJ+HAfQBc+DuuLC93D+zzm1G8oIURhD70loc7BL1HIWt7T511f50HFCRj1QRfdFyMQQxhr
	NGKnsFpFrW/REoxqnepxPLyEGNBZRc3FUh59G6tF191N4czPOMYmMXx/H5Us=
X-Gm-Gg: AY/fxX4wH15zpZq7bfS5SzkISgb2860EC6ICxrKZ/YDvEHjXQCOCwFH9O3ko7HNlqSG
	WCaa84qZSghOxYj2eVG+jj4qUgO0hZGEZfzlGkNqcwhuaDxoYTrrJXlyZwFxTOYualh8Z1o60vY
	HgdTnJrmyPk2fs0Wyz63qG20nWPh9TBMzo871ZMGwrJJ/Egaa+pW15KPP3pxfypSYBFtt7hKc8U
	XCTtDkQ5lNk0AAomFE9sMWHN3+iwXQ6YY1Qwo0y3GyeAdiprIhAW/mlzmq7IvZ9b7JLAHMep5R6
	oznKuL3SoxWUBtJStEpuzVz3QnduLFputGhiyph1EaPyvVZAKmOZ9FYIHA==
X-Received: by 2002:a4a:ee06:0:b0:65f:564f:34b1 with SMTP id
 006d021491bc7-66117913e21mr5042151eaf.16.1768812810032; Mon, 19 Jan 2026
 00:53:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aW3g7G_dWk4cbx0_@infradead.org> <696dec7b.a70a0220.34546f.043a.GAE@google.com>
 <aW3tX6aAAONC6zyr@infradead.org>
In-Reply-To: <aW3tX6aAAONC6zyr@infradead.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 19 Jan 2026 09:53:18 +0100
X-Gm-Features: AZwV_Qjx6kvIORnvlvvBVJhulwGUo7rDNWzoooqnpSwzpih1TmLo1y6HfILmn0o
Message-ID: <CANp29Y6PLo-Lr81SWp4qK9avLKpTGhXMAUDrZe3OYYgfWuaKVw@mail.gmail.com>
Subject: Re: [syzbot] [xfs?] KASAN: slab-use-after-free Read in xfs_buf_rele (4)
To: Christoph Hellwig <hch@infradead.org>
Cc: syzbot <syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com>, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2026 at 9:37=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> So I'm not sure what this test does that it always triggers the lockdep
> keys, but that makes it impossible to validate the original xfs report.
>
> Is there a way to force running syzbot reproducers without lockdep?

Not directly, but you could explicitly modify lockdep's Kconfig in
your test patch to disable lockdep entirely.

>
> Note that I've also had it running locally for quite a while, an even
> with lockdep enabled I'm somehow not hitting the lockdep splat.
> Although that is using my normal debug config and not the provided
> one.

Hmm, yes, that sounds weird.

I wonder if it's because we run the reproducers in threaded mode when
handling #syz test commands on the syzbot side, which leads to even
more syscalls being executed in parallel. Or the system just got lucky
once when it was generating the reproducer - overall, "BUG:
MAX_LOCKDEP_KEYS too low!" [1] seems to be a popular sink for
different reproducers on our side :(

[1] https://syzkaller.appspot.com/bug?extid=3Da70a6358abd2c3f9550f

>
> On Mon, Jan 19, 2026 at 12:34:03AM -0800, syzbot wrote:
> > Hello,
> >
> > syzbot has tested the proposed patch but the reproducer is still trigge=
ring an issue:
> > BUG: MAX_LOCKDEP_KEYS too low!
> >
> > BUG: MAX_LOCKDEP_KEYS too low!
> > turning off the locking correctness validator.
> > CPU: 1 UID: 0 PID: 7123 Comm: syz-executor Not tainted syzkaller #0 PRE=
EMPT
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 10/03/2025
> > Call trace:
> >  show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
> >  __dump_stack+0x30/0x40 lib/dump_stack.c:94
> >  dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
> >  dump_stack+0x1c/0x28 lib/dump_stack.c:129
> >  register_lock_class+0x310/0x348 kernel/locking/lockdep.c:1332
> >  __lock_acquire+0xbc/0x30a4 kernel/locking/lockdep.c:5112
> >  lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
> >  touch_wq_lockdep_map+0xa8/0x164 kernel/workqueue.c:3940
> >  __flush_workqueue+0xfc/0x109c kernel/workqueue.c:3982
> >  drain_workqueue+0xa4/0x310 kernel/workqueue.c:4146
> >  destroy_workqueue+0xb4/0xd90 kernel/workqueue.c:5903
> >  xfs_destroy_mount_workqueues+0xac/0xdc fs/xfs/xfs_super.c:649
> >  xfs_fs_put_super+0x128/0x144 fs/xfs/xfs_super.c:1262
> >  generic_shutdown_super+0x12c/0x2b8 fs/super.c:643
> >  kill_block_super+0x44/0x90 fs/super.c:1722
> >  xfs_kill_sb+0x20/0x58 fs/xfs/xfs_super.c:2297
> >  deactivate_locked_super+0xc4/0x12c fs/super.c:474
> >  deactivate_super+0xe0/0x100 fs/super.c:507
> >  cleanup_mnt+0x31c/0x3ac fs/namespace.c:1318
> >  __cleanup_mnt+0x20/0x30 fs/namespace.c:1325
> >  task_work_run+0x1dc/0x260 kernel/task_work.c:233
> >  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
> >  __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
> >  exit_to_user_mode_loop+0x10c/0x18c kernel/entry/common.c:75
> >  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inli=
ne]
> >  exit_to_user_mode_prepare_legacy include/linux/irq-entry-common.h:242 =
[inline]
> >  arm64_exit_to_user_mode arch/arm64/kernel/entry-common.c:81 [inline]
> >  el0_svc+0x17c/0x26c arch/arm64/kernel/entry-common.c:725
> >  el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
> >  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> > XFS (loop0): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
> >
> >
> > Tested on:
> >
> > commit:         3e548540 increase LOCKDEP_CHAINS_BITS
> > git tree:       git://git.infradead.org/users/hch/xfs.git xfs-buf-hash
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D101b0d22580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D6c6138f827b=
10ea4
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D0391d34e80164=
3e2809b
> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7=
976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > userspace arch: arm64
> >
> > Note: no patches were applied.
> ---end quoted text---
>

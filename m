Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A501A2877E1
	for <linux-xfs@vger.kernel.org>; Thu, 10 Jul 2025 08:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752134593; cv=none; b=aT0B2HlJQAKEU267RjuHUR682DHZBsJY4GoBh/DrcT7IRYxP1HLx5lSN05aalYZWcvEAUQX9KUHQh4lGuQR2mROl8xhPVN2mVt0MKygxOQt3W5oLiiS7g/TzIH7Kd7GiFiJ5+e5w9iWl7WbnLVTkz4uBVYFr1PHG97aPoi+tcvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752134593; c=relaxed/simple;
	bh=qRPX/qw+WJ0whT+SwzWvSJX2ZqFsQ3pwUONrGceLs6w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B/WoacP4i4mz203qd93vMDIrcZzAG2SY2SO9XZkeJVAQYrhY35hnaEb9bFhLjL44AAgNw1YF7c596zMWSobpINtn9UubmeVipkUAbaHeitN6EQFeyUhMKD+RkII1kZuOdzDFmj7zUgJaTlRKdreoYpLEsa88T4LEWqkK/x0rmDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dqdyDDeU; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dqdyDDeU"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b26f5f47ba1so689846a12.1
        for <linux-xfs@vger.kernel.org>; Thu, 10 Jul 2025 01:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752134591; x=1752739391; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dn1s1OnqM766ROLY29Wi7jVidC52A92cp1/CyP/E9uk=;
        b=dqdyDDeUiy83QERXfqBxijU0G53PXC1mT6/Y/+6/J7VYUAyNUbAWcPGwKYTSQJGiQl
         cRZ6Bo7tj1Zi0z7IYRZzArC94swW32xGbieMRrzVjkNhavNNTHJqxLA6wnEXz7BQT8F8
         9jPjGJelnlcG0RuUmBUIuAQA/s0+jTg1QyoT6YnTCcFqoQBm7iB/2K4LtNRdWX53U6/M
         u+ictIpGJZM+4j74vgAkDPJ6xOniCW7TyHi3D1f1mH5C782QsiTe0S80ru0mMD20HOhW
         6nQDJXMO9Qoj8ytK+kkWqOWoXh1FCYL25zmniYpEfZRZMAsXjczO0nScvd2ixcgFakQ2
         AvWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752134591; x=1752739391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dn1s1OnqM766ROLY29Wi7jVidC52A92cp1/CyP/E9uk=;
        b=lOsTR4sBJPGHP1T7hi9qYCqIP9RYCvNnA+Qg/gHdZGprQ8wss+WhbYSfc4YjSV5Dde
         9n99JqFEvR/IdraErU4ztDflhDD2LB3V5yYtxh8iJU60eMp+KS1wx9t5AHsn6kILNf6T
         Jisjg9rJi4Y9SRy+dXK5s0Dejv4L3MPlXxC79v25FfUZq+x1RoSrUJMGTKJrNhfOyHjH
         5kmoqZGwpVNYSrUExgOxgffA2R4MKG3ck+Y6UR4jxDXQN4MzVaHQPm4KDaYon9Lsgr43
         WbkeCKcAsDLubiBZL3Bq7C4+lmYFbv3Z+sIaPXWzjgYpgnAagmvrtWHnxxM9+3s7wSnC
         d1Fw==
X-Forwarded-Encrypted: i=1; AJvYcCVhYtU0IOOa0bkJ24Hcdp2II4cKzJ2bOnnHby9CD9ImWwb3vR9DOgVynAdnmuMKjeeZp3AKzJdHIx4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzx6X1hylTRjAkFUWVxGvy4evpQ7kwvJKMo8ueTaGPdGjRhzOoE
	6y/Itd94E3l8ZxlinZGtnL3t6MwdZHtC93K7JKS/yjVyulbNIhykxqoGKRrUterom/B/c9kqNep
	5CbEcb0IcZjTjHi1m3o0aRwtt3Oa1W76l195mNmq5
X-Gm-Gg: ASbGncu+SbFGya53C9PkMR5Cwho8R4wBRsUbWqr2pJ00ZLXdZ3G363Qz1jpZerx59qP
	ktniZf0T5c0OKWBqtU89YYS3XFFD+KABEkwhhaZavUlVZ7yzrQc+u/g4VEC2jEshV44xlQP3nsD
	UectnMA2GI3510oL2ZmlMOdJEGYvi8aorAjTn67qbuVBfXB28OBedIQzLJDuilHafO5WECBs4CE
	a2owrcXcBiz
X-Google-Smtp-Source: AGHT+IHDV9FQvB8A+v7zknLaNUWrdiR+PMz6YJqcz8cQw8kfvU/R4MwkGH7Xv6dLOAwoevuEEtmJFcSk1nrYxDUqsxY=
X-Received: by 2002:a17:90b:5345:b0:31a:bc78:7fe1 with SMTP id
 98e67ed59e1d1-31c3c2d4748mr4761227a91.18.1752134590559; Thu, 10 Jul 2025
 01:03:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <686ea951.050a0220.385921.0016.GAE@google.com> <aG7pfqqhk47YXFNz@dread.disaster.area>
In-Reply-To: <aG7pfqqhk47YXFNz@dread.disaster.area>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 10 Jul 2025 10:02:59 +0200
X-Gm-Features: Ac12FXy6k_Uf27DJHMFvYT-oDiqLCYYE_boXGcb3Fh1zipBMh0T2QL10IhXu33M
Message-ID: <CANp29Y700diEaeHd6bHksAL_60D+vJD-95EqcveqMME0smNJnw@mail.gmail.com>
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_ilock_attr_map_shared (2)
To: Dave Chinner <david@fromorbit.com>
Cc: syzbot <syzbot+3470c9ffee63e4abafeb@syzkaller.appspotmail.com>, cem@kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Thu, Jul 10, 2025 at 12:13=E2=80=AFAM 'Dave Chinner' via syzkaller-bugs
<syzkaller-bugs@googlegroups.com> wrote:
>
> On Wed, Jul 09, 2025 at 10:39:29AM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    733923397fd9 Merge tag 'pwm/for-6.16-rc6-fixes' of git:=
//g..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D13f53582580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Db309c907eaa=
b29da
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D3470c9ffee63e=
4abafeb
> > compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6=
049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets=
/d900f083ada3/non_bootable_disk-73392339.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/be7feaa77b8c/vmli=
nux-73392339.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/a663b3e31463=
/bzImage-73392339.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+3470c9ffee63e4abafeb@syzkaller.appspotmail.com
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> > WARNING: possible circular locking dependency detected
> > 6.16.0-rc5-syzkaller-00038-g733923397fd9 #0 Not tainted
> > ------------------------------------------------------
> > syz.0.0/5339 is trying to acquire lock:
> > ffffffff8e247500 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linu=
x/sched/mm.h:318 [inline]
> > ffffffff8e247500 (fs_reclaim){+.+.}-{0:0}, at: prepare_alloc_pages+0x15=
3/0x610 mm/page_alloc.c:4727
> >
> > but task is already holding lock:
> > ffff888053415098 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_ilock_a=
ttr_map_shared+0x92/0xd0 fs/xfs/xfs_inode.c:85
> >
> > which lock already depends on the new lock.
> >
> >
> > the existing dependency chain (in reverse order) is:
> >
> > -> #1 (&xfs_nondir_ilock_class){++++}-{4:4}:
> >        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
> >        down_write_nested+0x9d/0x200 kernel/locking/rwsem.c:1693
> >        xfs_reclaim_inode fs/xfs/xfs_icache.c:1045 [inline]
> >        xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1737 [inline]
> >        xfs_icwalk_ag+0x12c5/0x1ab0 fs/xfs/xfs_icache.c:1819
> >        xfs_icwalk fs/xfs/xfs_icache.c:1867 [inline]
> >        xfs_reclaim_inodes_nr+0x1e3/0x260 fs/xfs/xfs_icache.c:1111
> >        super_cache_scan+0x41b/0x4b0 fs/super.c:228
> >        do_shrink_slab+0x6ec/0x1110 mm/shrinker.c:437
> >        shrink_slab+0xd74/0x10d0 mm/shrinker.c:664
> >        shrink_one+0x28a/0x7c0 mm/vmscan.c:4939
> >        shrink_many mm/vmscan.c:5000 [inline]
> >        lru_gen_shrink_node mm/vmscan.c:5078 [inline]
> >        shrink_node+0x314e/0x3760 mm/vmscan.c:6060
> >        kswapd_shrink_node mm/vmscan.c:6911 [inline]
> >        balance_pgdat mm/vmscan.c:7094 [inline]
> >        kswapd+0x147c/0x2830 mm/vmscan.c:7359
> >        kthread+0x70e/0x8a0 kernel/kthread.c:464
> >        ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
> >        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >
> > -> #0 (fs_reclaim){+.+.}-{0:0}:
> >        check_prev_add kernel/locking/lockdep.c:3168 [inline]
> >        check_prevs_add kernel/locking/lockdep.c:3287 [inline]
> >        validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3911
> >        __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5240
> >        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
> >        __fs_reclaim_acquire mm/page_alloc.c:4045 [inline]
> >        fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4059
> >        might_alloc include/linux/sched/mm.h:318 [inline]
> >        prepare_alloc_pages+0x153/0x610 mm/page_alloc.c:4727
> >        __alloc_frozen_pages_noprof+0x123/0x370 mm/page_alloc.c:4948
> >        alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2419
> >        alloc_frozen_pages_noprof mm/mempolicy.c:2490 [inline]
> >        alloc_pages_noprof+0xa9/0x190 mm/mempolicy.c:2510
> >        get_free_pages_noprof+0xf/0x80 mm/page_alloc.c:5018
> >        __kasan_populate_vmalloc mm/kasan/shadow.c:362 [inline]
> >        kasan_populate_vmalloc+0x33/0x1a0 mm/kasan/shadow.c:417
> >        alloc_vmap_area+0xd51/0x1490 mm/vmalloc.c:2084
> >        __get_vm_area_node+0x1f8/0x300 mm/vmalloc.c:3179
> >        __vmalloc_node_range_noprof+0x301/0x12f0 mm/vmalloc.c:3845
> >        __vmalloc_node_noprof mm/vmalloc.c:3948 [inline]
> >        __vmalloc_noprof+0xb1/0xf0 mm/vmalloc.c:3962
> >        xfs_buf_alloc_backing_mem fs/xfs/xfs_buf.c:239 [inline]
>
> KASAN is still failing to pass through __GFP_NOLOCKDEP allocation
> context flags. It's also failing to pass through other important
> context restrictions like GFP_NOFS, GFP_NOIO, __GFP_NOFAIL, etc.
>
> Fundamentally, it's a bug to be doing nested GFP_KERNEL allocations
> inside an allocation context that has a more restricted allocation
> context...
>
> #syz set subsystems: kasan

Thanks for the analysis!

I've added the kasan-dev list to Cc.

--=20
Aleksandr

>
> --
> Dave Chinner
> david@fromorbit.com
>

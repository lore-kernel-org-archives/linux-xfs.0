Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F151C27;
	Mon, 11 Aug 2025 13:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754919514; cv=none; b=Rhlq2d3HF0BUb8iIm9hI9vpAl6WRDScJYbJAn2IbBOBfvJrheDzONebJO6FBQMY+4KCthU1I4QmOCxyo5zZosXeYXEqoBbyCDOys8XWPhE0Ed+Q1W9HsBFJWTwNwCz+wj9ZHOopiVTJP7qT132tsb9EsstKFVo/VWf3yh6tzAJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754919514; c=relaxed/simple;
	bh=GF3G4G8QjoOvA7O7APe71DN965A1wlJFRL7n5YynW1A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rW+0biAuzF8jXV0JTNTumc1Aj+SS2Sl9LctwWZcsYv/kN/0JMLnu3xOlHTMXsZukMTRGCrn6yB3OjnsIGWqyYBLAF0MbTcIQKxjzk8J0OSbsg9BRv3gMMCAMkI95JKHMuPuRqenZceuT2hayQpDUX75qrEi3dD2Z8PBTOQ3uz3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XR0uCimK; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XR0uCimK"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-458b885d6eeso27646845e9.3;
        Mon, 11 Aug 2025 06:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754919511; x=1755524311; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1kbINbP8WLaLr5mOXjjJSrdAAtJw6w4ZFXcoqIl+hSs=;
        b=XR0uCimKXONRSc+URWZ71FoHCo2hw77ngQKDDGPBrzjcwfVFAon1xhdRtX5pToTy7p
         MReQUJgV7qeTgS7ta772RiMVwNn3aWXTJzNmB/eVLqbkEMD4QcH14oEJtUo0WHMnyHZA
         S8Q7s8ZXd/q5+hszFGGtCfcG7pZNcE7T3mC5qJekeP2xiLgfUzIdm1QMsJz+0K0G5J4a
         e5GSAPw0LrlNYQeiodtCrjFlW24ImA7df5aIXZzL9TkOnH1xajYqUW59y/Din1xNnYom
         6RoFKX1pH5ehvqd+yR6mft9InRXErQUkHnO4J8luLDZFDpaKhqmmkuXIqnnRygE1+1yF
         aKFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754919511; x=1755524311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1kbINbP8WLaLr5mOXjjJSrdAAtJw6w4ZFXcoqIl+hSs=;
        b=SjCav3lCSoc1NVp6P6jdU/9O6PLO/rD4aZGVOnsMPoUIyAu1HVadh6cQGy8Ow8z+e2
         aaFPEZCpBGzSkZySPJD8tkILHqj/qCUg5Wm/U7fplb3JNCJbkD67DSHCPwp8kR7bjl5k
         UfuuoFW93nPyA3eL8JEwPlMEPbezR87jwL9A8+jBkk3IdJFyicxe1wm/m0kQVN6fcOqM
         TCpzO7zpZYrP9uIGCW0Jz5BKp/0GHL5tlfFCZXVYYCSk5OIh2yU8nmWz3Qeakz+54H5C
         EiRO+5c6tPmoVLZJdI6Nl2Z25MqNrQiYe7w6nyQn3KzIG0Ha10E6gVqNSwxNpOialmnq
         dDHg==
X-Forwarded-Encrypted: i=1; AJvYcCU1Ya5tAytbHjRwU26knqCT57Aoyo9Y+ozLtIaTM9YInaZXOCpizQ/MrBa7Z++/WBWadgmaoWYLpeeK6eM=@vger.kernel.org, AJvYcCVAuX3Ha4yUjRHfbOJ/q2mpzguP33XOnky9f1LBF8pMh4lz18FNaviBTaqtYL3JkPFNqo+7eiHIhL5N@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4KnW45CJeo8BQNd7wuXd+1hqkq7q5o3/FC/IzymO8WPG6DZON
	NnrxR7Yh6yF55waJ0BNJV9hXcbG+L7ceeRBGFDziNEVMByx6cyzbq2q4Lz3yLVzXwOVrme25sav
	cS3/Q4MIY19OvM1GEmS+mSPGEhvLxSJE=
X-Gm-Gg: ASbGncuxszoVSeoNPA42NvA2XibW3vuiHVhGCuQNvuxuv9/hDQpQEnCvczBgifNGSAm
	Qct1QEyFNEBOHqDAJWBAJICJYikiT8aBCH7IQIxHFgsakEWwhL6Hf1IgPy5t6z6AinWVENjcgQB
	ce4fsqWhxl6wo3s7svGpCrSwsii4yU/SFeeO9keEfPMzdhjVkW8qpjh+SE0PWefny12sSZMU95B
	vA7yw==
X-Google-Smtp-Source: AGHT+IGwJht/dXHwAmkHJXbCjztZIMDTFgdNk0j6k4sj8lYAMPqMYE3e7E2/T9xKzl59W06kLwS6I3p/Z1pD7uhJ/P4=
X-Received: by 2002:a05:6000:2011:b0:3a5:1cc5:aa6f with SMTP id
 ffacd0b85a97d-3b900b4dbdemr9521937f8f.34.1754919510792; Mon, 11 Aug 2025
 06:38:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <686ea951.050a0220.385921.0016.GAE@google.com> <aG7pfqqhk47YXFNz@dread.disaster.area>
 <CANp29Y700diEaeHd6bHksAL_60D+vJD-95EqcveqMME0smNJnw@mail.gmail.com>
In-Reply-To: <CANp29Y700diEaeHd6bHksAL_60D+vJD-95EqcveqMME0smNJnw@mail.gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Mon, 11 Aug 2025 15:38:17 +0200
X-Gm-Features: Ac12FXyLwMPgBtXA0Gq8HKHELEpcXOwD5qy9_RF6aOPgWMkTUfSEdQ1ChL4vEts
Message-ID: <CA+fCnZfMMb0Rw68BczORoDQSDJaQy93n8TAA44JwS4P0s=abkw@mail.gmail.com>
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_ilock_attr_map_shared (2)
To: Aleksandr Nogikh <nogikh@google.com>, Dave Chinner <david@fromorbit.com>
Cc: syzbot <syzbot+3470c9ffee63e4abafeb@syzkaller.appspotmail.com>, cem@kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 10, 2025 at 10:03=E2=80=AFAM 'Aleksandr Nogikh' via kasan-dev
<kasan-dev@googlegroups.com> wrote:
>
> Hi Dave,
>
> On Thu, Jul 10, 2025 at 12:13=E2=80=AFAM 'Dave Chinner' via syzkaller-bug=
s
> <syzkaller-bugs@googlegroups.com> wrote:
> >
> > On Wed, Jul 09, 2025 at 10:39:29AM -0700, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    733923397fd9 Merge tag 'pwm/for-6.16-rc6-fixes' of gi=
t://g..
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D13f535825=
80000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Db309c907e=
aab29da
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D3470c9ffee6=
3e4abafeb
> > > compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88=
f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> > >
> > > Unfortunately, I don't have any reproducer for this issue yet.
> > >
> > > Downloadable assets:
> > > disk image (non-bootable): https://storage.googleapis.com/syzbot-asse=
ts/d900f083ada3/non_bootable_disk-73392339.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/be7feaa77b8c/vm=
linux-73392339.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/a663b3e314=
63/bzImage-73392339.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> > > Reported-by: syzbot+3470c9ffee63e4abafeb@syzkaller.appspotmail.com
> > >
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> > > WARNING: possible circular locking dependency detected
> > > 6.16.0-rc5-syzkaller-00038-g733923397fd9 #0 Not tainted
> > > ------------------------------------------------------
> > > syz.0.0/5339 is trying to acquire lock:
> > > ffffffff8e247500 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/li=
nux/sched/mm.h:318 [inline]
> > > ffffffff8e247500 (fs_reclaim){+.+.}-{0:0}, at: prepare_alloc_pages+0x=
153/0x610 mm/page_alloc.c:4727
> > >
> > > but task is already holding lock:
> > > ffff888053415098 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_ilock=
_attr_map_shared+0x92/0xd0 fs/xfs/xfs_inode.c:85
> > >
> > > which lock already depends on the new lock.
> > >
> > >
> > > the existing dependency chain (in reverse order) is:
> > >
> > > -> #1 (&xfs_nondir_ilock_class){++++}-{4:4}:
> > >        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
> > >        down_write_nested+0x9d/0x200 kernel/locking/rwsem.c:1693
> > >        xfs_reclaim_inode fs/xfs/xfs_icache.c:1045 [inline]
> > >        xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1737 [inline]
> > >        xfs_icwalk_ag+0x12c5/0x1ab0 fs/xfs/xfs_icache.c:1819
> > >        xfs_icwalk fs/xfs/xfs_icache.c:1867 [inline]
> > >        xfs_reclaim_inodes_nr+0x1e3/0x260 fs/xfs/xfs_icache.c:1111
> > >        super_cache_scan+0x41b/0x4b0 fs/super.c:228
> > >        do_shrink_slab+0x6ec/0x1110 mm/shrinker.c:437
> > >        shrink_slab+0xd74/0x10d0 mm/shrinker.c:664
> > >        shrink_one+0x28a/0x7c0 mm/vmscan.c:4939
> > >        shrink_many mm/vmscan.c:5000 [inline]
> > >        lru_gen_shrink_node mm/vmscan.c:5078 [inline]
> > >        shrink_node+0x314e/0x3760 mm/vmscan.c:6060
> > >        kswapd_shrink_node mm/vmscan.c:6911 [inline]
> > >        balance_pgdat mm/vmscan.c:7094 [inline]
> > >        kswapd+0x147c/0x2830 mm/vmscan.c:7359
> > >        kthread+0x70e/0x8a0 kernel/kthread.c:464
> > >        ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
> > >        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> > >
> > > -> #0 (fs_reclaim){+.+.}-{0:0}:
> > >        check_prev_add kernel/locking/lockdep.c:3168 [inline]
> > >        check_prevs_add kernel/locking/lockdep.c:3287 [inline]
> > >        validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3911
> > >        __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5240
> > >        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
> > >        __fs_reclaim_acquire mm/page_alloc.c:4045 [inline]
> > >        fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4059
> > >        might_alloc include/linux/sched/mm.h:318 [inline]
> > >        prepare_alloc_pages+0x153/0x610 mm/page_alloc.c:4727
> > >        __alloc_frozen_pages_noprof+0x123/0x370 mm/page_alloc.c:4948
> > >        alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2419
> > >        alloc_frozen_pages_noprof mm/mempolicy.c:2490 [inline]
> > >        alloc_pages_noprof+0xa9/0x190 mm/mempolicy.c:2510
> > >        get_free_pages_noprof+0xf/0x80 mm/page_alloc.c:5018
> > >        __kasan_populate_vmalloc mm/kasan/shadow.c:362 [inline]
> > >        kasan_populate_vmalloc+0x33/0x1a0 mm/kasan/shadow.c:417
> > >        alloc_vmap_area+0xd51/0x1490 mm/vmalloc.c:2084
> > >        __get_vm_area_node+0x1f8/0x300 mm/vmalloc.c:3179
> > >        __vmalloc_node_range_noprof+0x301/0x12f0 mm/vmalloc.c:3845
> > >        __vmalloc_node_noprof mm/vmalloc.c:3948 [inline]
> > >        __vmalloc_noprof+0xb1/0xf0 mm/vmalloc.c:3962
> > >        xfs_buf_alloc_backing_mem fs/xfs/xfs_buf.c:239 [inline]
> >
> > KASAN is still failing to pass through __GFP_NOLOCKDEP allocation
> > context flags. It's also failing to pass through other important
> > context restrictions like GFP_NOFS, GFP_NOIO, __GFP_NOFAIL, etc.
> >
> > Fundamentally, it's a bug to be doing nested GFP_KERNEL allocations
> > inside an allocation context that has a more restricted allocation
> > context...
> >
> > #syz set subsystems: kasan
>
> Thanks for the analysis!
>
> I've added the kasan-dev list to Cc.

Filed a bug: https://bugzilla.kernel.org/show_bug.cgi?id=3D220434

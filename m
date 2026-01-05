Received: from mail-oa1-f80.google.com (mail-oa1-f80.google.com [209.85.160.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4F115ADB4
	for <linux-xfs@vger.kernel.org>; Mon,  5 Jan 2026 23:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767654939; cv=none; b=hfWIxjHCQ5AiWOOmZQAoEeHTxDf+FKE7Qa1wbZR/JR1Orz1/xuezhswGt+9Whn+iNrPS9RsbW9NUHBnjSy+LltE7MN7DtTbs5mjNKgKXbhh87YbhPhpgHej9vjXR3zrDbl2Xk+ztvHmrzb5wgU1XUk+bbp4e1SuAAtqrRNCXEjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767654939; c=relaxed/simple;
	bh=AtR2UsBW/eFcJ0rUIWEX331hXp8UY0kOLJMmNUJe5ts=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=glzz0fhiUisysLbP+n2osGwdqLmber0N3CQCcqBIitbMBgC6TXse/aGGnmVbJ3NLaSe8k82kAf7/nQBgzISCriSL7BZZ0hY8mldy7PgtyWdk3hmJiKW+TK/wlwZupnkz5whrqZIFiSTUtwy9va3/j9tJ4GyREtVzBJzqgvWPmw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f80.google.com with SMTP id 586e51a60fabf-3f0d1a7a9c2so423294fac.3
        for <linux-xfs@vger.kernel.org>; Mon, 05 Jan 2026 15:15:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767654937; x=1768259737;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xKmG/al5lAtHvuG0LFNYbDr83zacZNiXFwtfanj8MZI=;
        b=hsOo93oTscrWGucfmMMYE4K74sdxk9/kNGk/CWPc60aDRsi7bTDuEYPOdtrAXM8qxG
         xLeBoGdT2gqGnuH3+Y+HOsYVmnXHbaqY6lr6fbNcutfqKc7yC5BRyswMBpB8RGFFz56F
         6eL6J+SZ3mKOUVBobUpLzwuCCB97dgcO1rmwUkS/Mineo+m6rvqfdeIjeuygimbT7Rg4
         XF9UwQXnnqfWooIqNxWV8fRmNMC7/sl8iqujBiivhzBPJHUlzVLRDsEYsl8Wy8WWPXjb
         U6G/VpR0wF7aPzMRdzjVzwPPgupi/OTLc9NfsObF514YcqvmLwp8PLfrJRqtA1VuKmug
         3NHA==
X-Forwarded-Encrypted: i=1; AJvYcCVz5opavfCF6PAEEm+UY+DHRzI84W8sWdrzUcvvwuITNn/ai3V7QEJQSWCW3pO+33Cl+yren6cOthk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzK/ZMzv0l3tgA/UHdO25c12UIZGj1ZBTHJkk5Q0EvMjFv/Bz/
	xRo+AY1RfNBoL1SaIi/PWdZFZ4ipHJ2+IClepMcHEjURb6yXqbG32kc4TN+KdhQwxKD9HBrFP1y
	lcpKjWpZ0BuxPXwaGvCHLvId+pc5WEfBB547gnhkhgNEGCf/kODS/h7oj37s=
X-Google-Smtp-Source: AGHT+IHXuFyoZ5Q1xrB3OoEkhhwnau8awMQ7GNO722MVD6vSv35Gtya6ebFvzTSgY9Mc6mGowLasJwUtNNMyMnVvQN1iGKRcPc3s
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:d383:0:b0:659:9a49:8def with SMTP id
 006d021491bc7-65f47a30065mr451954eaf.49.1767654937087; Mon, 05 Jan 2026
 15:15:37 -0800 (PST)
Date: Mon, 05 Jan 2026 15:15:37 -0800
In-Reply-To: <aVxGFP1GJLPremdy@dread.disaster.area>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695c4619.050a0220.318c5c.0134.GAE@google.com>
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_ilock (4)
From: syzbot <syzbot+c628140f24c07eb768d8@syzkaller.appspotmail.com>
To: david@fromorbit.com
Cc: cem@kernel.org, david@fromorbit.com, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> On Sun, Jan 04, 2026 at 06:40:21PM -0800, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    8f0b4cce4481 Linux 6.19-rc1
>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1481d792580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=8a8594efdc14f07a
>> dashboard link: https://syzkaller.appspot.com/bug?extid=c628140f24c07eb768d8
>> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>> userspace arch: arm64
>> 
>> Unfortunately, I don't have any reproducer for this issue yet.
>> 
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/cd4f5f43efc8/disk-8f0b4cce.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/aafb35ac3a3c/vmlinux-8f0b4cce.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/d221fae4ab17/Image-8f0b4cce.gz.xz
>> 
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+c628140f24c07eb768d8@syzkaller.appspotmail.com
>> 
>> WARNING: possible circular locking dependency detected
>> syzkaller #0 Not tainted
>> ------------------------------------------------------
>> syz.3.4/6790 is trying to acquire lock:
>> ffff80008fb56c80 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:317 [inline]
>> ffff80008fb56c80 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:4904 [inline]
>> ffff80008fb56c80 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:5239 [inline]
>> ffff80008fb56c80 (fs_reclaim){+.+.}-{0:0}, at: __kmalloc_cache_noprof+0x58/0x698 mm/slub.c:5771
>> 
>> but task is already holding lock:
>> ffff0000f77f5b18 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_ilock+0x1d8/0x3d0 fs/xfs/xfs_inode.c:165
>> 
>> which lock already depends on the new lock.
>
> #syz test

This crash does not have a reproducer. I cannot test it.

>
>
> iomap: use mapping_gfp_mask() for iomap_fill_dirty_folios()
>
> From: Dave Chinner <dchinner@redhat.com>
>
> GFP_KERNEL allocations in the buffered write path generates false
> positive lockdep warnings against inode reclaim such as:
>
> -> #1 (&xfs_nondir_ilock_class){++++}-{4:4}:
>        down_write_nested+0x58/0xcc kernel/locking/rwsem.c:1706
>        xfs_ilock+0x1d8/0x3d0 fs/xfs/xfs_inode.c:165
>        xfs_reclaim_inode fs/xfs/xfs_icache.c:1035 [inline]
>        xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1727 [inline]
>        xfs_icwalk_ag+0xe4c/0x16a4 fs/xfs/xfs_icache.c:1809
>        xfs_icwalk fs/xfs/xfs_icache.c:1857 [inline]
>        xfs_reclaim_inodes_nr+0x1b4/0x268 fs/xfs/xfs_icache.c:1101
>        xfs_fs_free_cached_objects+0x68/0x7c fs/xfs/xfs_super.c:1282
>        super_cache_scan+0x2f0/0x380 fs/super.c:228
>        do_shrink_slab+0x638/0x11b0 mm/shrinker.c:437
>        shrink_slab+0xc68/0xfb8 mm/shrinker.c:664
>        shrink_node_memcgs mm/vmscan.c:6022 [inline]
>        shrink_node+0xe18/0x20bc mm/vmscan.c:6061
>        kswapd_shrink_node mm/vmscan.c:6901 [inline]
>        balance_pgdat+0xb60/0x13b8 mm/vmscan.c:7084
>        kswapd+0x6d0/0xe64 mm/vmscan.c:7354
>        kthread+0x5fc/0x75c kernel/kthread.c:463
>        ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:844
>
> -> #0 (fs_reclaim){+.+.}-{0:0}:
>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>        validate_chain kernel/locking/lockdep.c:3908 [inline]
>        __lock_acquire+0x1774/0x30a4 kernel/locking/lockdep.c:5237
>        lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
>        __fs_reclaim_acquire mm/page_alloc.c:4301 [inline]
>        fs_reclaim_acquire+0x8c/0x118 mm/page_alloc.c:4315
>        might_alloc include/linux/sched/mm.h:317 [inline]
>        slab_pre_alloc_hook mm/slub.c:4904 [inline]
>        slab_alloc_node mm/slub.c:5239 [inline]
>        __kmalloc_cache_noprof+0x58/0x698 mm/slub.c:5771
>        kmalloc_noprof include/linux/slab.h:957 [inline]
>        iomap_fill_dirty_folios+0xf0/0x218 fs/iomap/buffered-io.c:1557
>        xfs_buffered_write_iomap_begin+0x8b4/0x1668 fs/xfs/xfs_iomap.c:1857
>        iomap_iter+0x528/0xefc fs/iomap/iter.c:110
>        iomap_zero_range+0x17c/0x8ec fs/iomap/buffered-io.c:1590
>        xfs_zero_range+0x98/0xfc fs/xfs/xfs_iomap.c:2289
>        xfs_reflink_zero_posteof+0x110/0x2f0 fs/xfs/xfs_reflink.c:1619
>        xfs_reflink_remap_prep+0x314/0x5e4 fs/xfs/xfs_reflink.c:1699
>        xfs_file_remap_range+0x1f4/0x758 fs/xfs/xfs_file.c:1518
>        vfs_clone_file_range+0x62c/0xb68 fs/remap_range.c:403
>        ioctl_file_clone fs/ioctl.c:239 [inline]
>        ioctl_file_clone_range fs/ioctl.c:257 [inline]
>        do_vfs_ioctl+0xb84/0x1834 fs/ioctl.c:544
>
> We use mapping_gfp_mask() in the IO paths where the IOLOCK is held
> to avoid these false positives and any possible reclaim recursion
> deadlock that might occur from complex nested calls into the IO
> path.
>
> Fixes: 395ed1ef0012 ("iomap: optional zero range dirty folio processing")
> Reported-by: syzbot+c628140f24c07eb768d8@syzkaller.appspotmail.com
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/iomap/buffered-io.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index e5c1ca440d93..01f0263e285a 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1554,7 +1554,8 @@ iomap_fill_dirty_folios(
>  	pgoff_t			start = offset >> PAGE_SHIFT;
>  	pgoff_t			end = (offset + length - 1) >> PAGE_SHIFT;
>  
> -	iter->fbatch = kmalloc(sizeof(struct folio_batch), GFP_KERNEL);
> +	iter->fbatch = kmalloc(sizeof(struct folio_batch),
> +				mapping_gfp_mask(mapping));
>  	if (!iter->fbatch)
>  		return offset + length;
>  	folio_batch_init(iter->fbatch);

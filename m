Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE403FFD
	for <linux-xfs@vger.kernel.org>; Mon,  5 Jan 2026 23:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767654939; cv=none; b=U0js+fp2g4PE3RBOpcJLiwgMsWZHXV7qR42UefSPdresUzdpvuerP0YJpZAWpmYt4ybSY1W0pwzIzdFZ2Fv7Pit72VbA32cot2XQdNfl9lkKSJZC/fC5AwbVwlzaybHL6o/NSV/ogtLqC8gq9YZbJVrMsOr5a6eZXKN3LEVIyik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767654939; c=relaxed/simple;
	bh=GS/5kxbxpyPKc0QXABe3s31vkh4shagR1cGPkLsZBrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MMMjIN1BQA/qHtregHqLbGczssf+0DN6T6OnA1a04kIPhk/T4WQTFR3Bmr1gS+wa7G2TKcwpUnBnW9hW9gEPD9y6ElCrl7hjE823imzsAYq7YBNK3dWQyP5rQyQlE/nO/7DZzM7Zu9tMHCjXHCt51rbBe0Zi3A73PiZKa1EksRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=xvaoMaU/; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="xvaoMaU/"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-bbf2c3eccc9so750276a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 05 Jan 2026 15:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1767654936; x=1768259736; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LdyFtMC5xu34ynezlxQ4q9iMFQhpKdGr0zfb5KMTZmA=;
        b=xvaoMaU/EYT9pFcqU9WMyQeI8JYRuiJLHLI9/uBmbiB62+GXRCMMaNRCUzvXluQnPM
         soYxBli1CYstyjVE6g2u3rifPeQbBJCX23UlN0flgoS3nw60RCauABFYwk5zCxJ5rjGA
         dNKz7koBkYd20QCbMZhWFCmRu3MFpU4B1Ra19u0+m+TQXYAKv0P8PuoUmu55L4W4USGI
         6wc4gYmdT32pQUW/+QJFUbd+JZEDvIAdFgZOBpTFHcDZT3LvT3fkDJMtkMVPh0MCOLNW
         jakdV9v1tbZfR84c6miiVIbSlNOpqlLLFuQ45YAovFe14PZOKRpPXt1d8gcD4KkA4u/g
         bXCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767654936; x=1768259736;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LdyFtMC5xu34ynezlxQ4q9iMFQhpKdGr0zfb5KMTZmA=;
        b=UK/5Y1ljf6SGa3g+rxBgfItThaPoOuuxVFZjWeoWbhhpLYXPIVgCXUmCu37bkYHht6
         7IN2b/1YtwZ7mzov6AKPTwyZquthtwg2G0kY7J/BZ4j5klCmLqgX4jFYH1lcVGYn4e1j
         yDpye5ZqVSvvCTNkkTnqb0cMCqKamq2vR8cUedtupXKhS+e8q0CQxjGl462zsKv4nyyy
         Re7n5XI7HNbnqSQBCZQZYyCXaOXbfbELcc+mY30QHefHR81TWuC8TAMLxHYOwd01Cvar
         Txorxb3UhqXX2AMx9GUgC0KSbgiNvweYZEz3363gEvR4Oe9yXNSUb1TXgxC7ZEghneGn
         Lh3w==
X-Forwarded-Encrypted: i=1; AJvYcCU8xzKnX3Nzn1XYjiHEWYZ63E6XijP9Bwzi/FtsbuD8Ozrx8AUHnvQs60BShnB2lpKeNUC5v3mc3J4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzmTRB192jxhKcnWFl68UerwqhWT3hkXhoigEfJZHk7qVKtvnk
	6/NDZoxfRX78ADPsZVqeO/ww7yBeVoANhQY9sua82wVIHhU0K4KOc8v2KqACLd2/t9bWROwY/Gt
	WOB2U
X-Gm-Gg: AY/fxX6ikIG2V2tvdYkXzT7cWFBighXxJa56CAM6DgS4rP6GKx4pdTTZVWw7/gWDT1v
	+GCBM5a+v6z8BiSpwB3hgY5gJUdiRqQfsQFCjxczB6e/33s9FB7cq8EHrrRFVj5UWNT6LxD90Bc
	7XkK5qENIkqmXOMvKCzDMYzB6VpyehGTsciKTb7xQsoTg1Qy4zQkfp4btr1p81P2qRL7kRwWA49
	UPCaVHgwd/eCQKjDmAG3qAuksrMU65uw5v4YrGf10gBcIm4tX0kM953EmAqUecYcrIfSjNQwp71
	2TpOxI/pNLWpNmZ1WppHSZBSW/qAkzIyh+J6Ybx6XHToiGhKqoz+CkvK+2X64HPv7Bl7pEmMwz6
	CAP2Lau6Q0GgLrqvDVU/MbPEiJ9E/5lIk5UUPCBB1uqNo4CMDQfxvSSlJfAL9M0UT9QOhMeypq3
	81uxH35ETSz/s/MA1ECn/trA6Ffmie68YdW2pefX/wqW+sWlrYQgSzzrSyDxKIdQ==
X-Google-Smtp-Source: AGHT+IH6twE7fdcGRaU9c6QZqG/H4OwlnOQf07tkm3cKKAhXe98Grr494OMKtRd4iGCgSEMnDkqg8w==
X-Received: by 2002:a17:90b:49:b0:340:8d99:49d4 with SMTP id 98e67ed59e1d1-34f5f831cabmr488417a91.1.1767654935575;
        Mon, 05 Jan 2026 15:15:35 -0800 (PST)
Received: from dread.disaster.area (pa49-186-83-206.pa.vic.optusnet.com.au. [49.186.83.206])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5fa7820fsm378987a91.2.2026.01.05.15.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 15:15:35 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vctnQ-00000006CoF-1Db2;
	Tue, 06 Jan 2026 10:15:32 +1100
Date: Tue, 6 Jan 2026 10:15:32 +1100
From: Dave Chinner <david@fromorbit.com>
To: syzbot <syzbot+c628140f24c07eb768d8@syzkaller.appspotmail.com>
Cc: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_ilock (4)
Message-ID: <aVxGFP1GJLPremdy@dread.disaster.area>
References: <695b2495.050a0220.1c9965.0020.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <695b2495.050a0220.1c9965.0020.GAE@google.com>

On Sun, Jan 04, 2026 at 06:40:21PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    8f0b4cce4481 Linux 6.19-rc1
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=1481d792580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8a8594efdc14f07a
> dashboard link: https://syzkaller.appspot.com/bug?extid=c628140f24c07eb768d8
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> userspace arch: arm64
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/cd4f5f43efc8/disk-8f0b4cce.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/aafb35ac3a3c/vmlinux-8f0b4cce.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d221fae4ab17/Image-8f0b4cce.gz.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c628140f24c07eb768d8@syzkaller.appspotmail.com
> 
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> syz.3.4/6790 is trying to acquire lock:
> ffff80008fb56c80 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:317 [inline]
> ffff80008fb56c80 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:4904 [inline]
> ffff80008fb56c80 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:5239 [inline]
> ffff80008fb56c80 (fs_reclaim){+.+.}-{0:0}, at: __kmalloc_cache_noprof+0x58/0x698 mm/slub.c:5771
> 
> but task is already holding lock:
> ffff0000f77f5b18 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_ilock+0x1d8/0x3d0 fs/xfs/xfs_inode.c:165
> 
> which lock already depends on the new lock.

#syz test


iomap: use mapping_gfp_mask() for iomap_fill_dirty_folios()

From: Dave Chinner <dchinner@redhat.com>

GFP_KERNEL allocations in the buffered write path generates false
positive lockdep warnings against inode reclaim such as:

-> #1 (&xfs_nondir_ilock_class){++++}-{4:4}:
       down_write_nested+0x58/0xcc kernel/locking/rwsem.c:1706
       xfs_ilock+0x1d8/0x3d0 fs/xfs/xfs_inode.c:165
       xfs_reclaim_inode fs/xfs/xfs_icache.c:1035 [inline]
       xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1727 [inline]
       xfs_icwalk_ag+0xe4c/0x16a4 fs/xfs/xfs_icache.c:1809
       xfs_icwalk fs/xfs/xfs_icache.c:1857 [inline]
       xfs_reclaim_inodes_nr+0x1b4/0x268 fs/xfs/xfs_icache.c:1101
       xfs_fs_free_cached_objects+0x68/0x7c fs/xfs/xfs_super.c:1282
       super_cache_scan+0x2f0/0x380 fs/super.c:228
       do_shrink_slab+0x638/0x11b0 mm/shrinker.c:437
       shrink_slab+0xc68/0xfb8 mm/shrinker.c:664
       shrink_node_memcgs mm/vmscan.c:6022 [inline]
       shrink_node+0xe18/0x20bc mm/vmscan.c:6061
       kswapd_shrink_node mm/vmscan.c:6901 [inline]
       balance_pgdat+0xb60/0x13b8 mm/vmscan.c:7084
       kswapd+0x6d0/0xe64 mm/vmscan.c:7354
       kthread+0x5fc/0x75c kernel/kthread.c:463
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:844

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1774/0x30a4 kernel/locking/lockdep.c:5237
       lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
       __fs_reclaim_acquire mm/page_alloc.c:4301 [inline]
       fs_reclaim_acquire+0x8c/0x118 mm/page_alloc.c:4315
       might_alloc include/linux/sched/mm.h:317 [inline]
       slab_pre_alloc_hook mm/slub.c:4904 [inline]
       slab_alloc_node mm/slub.c:5239 [inline]
       __kmalloc_cache_noprof+0x58/0x698 mm/slub.c:5771
       kmalloc_noprof include/linux/slab.h:957 [inline]
       iomap_fill_dirty_folios+0xf0/0x218 fs/iomap/buffered-io.c:1557
       xfs_buffered_write_iomap_begin+0x8b4/0x1668 fs/xfs/xfs_iomap.c:1857
       iomap_iter+0x528/0xefc fs/iomap/iter.c:110
       iomap_zero_range+0x17c/0x8ec fs/iomap/buffered-io.c:1590
       xfs_zero_range+0x98/0xfc fs/xfs/xfs_iomap.c:2289
       xfs_reflink_zero_posteof+0x110/0x2f0 fs/xfs/xfs_reflink.c:1619
       xfs_reflink_remap_prep+0x314/0x5e4 fs/xfs/xfs_reflink.c:1699
       xfs_file_remap_range+0x1f4/0x758 fs/xfs/xfs_file.c:1518
       vfs_clone_file_range+0x62c/0xb68 fs/remap_range.c:403
       ioctl_file_clone fs/ioctl.c:239 [inline]
       ioctl_file_clone_range fs/ioctl.c:257 [inline]
       do_vfs_ioctl+0xb84/0x1834 fs/ioctl.c:544

We use mapping_gfp_mask() in the IO paths where the IOLOCK is held
to avoid these false positives and any possible reclaim recursion
deadlock that might occur from complex nested calls into the IO
path.

Fixes: 395ed1ef0012 ("iomap: optional zero range dirty folio processing")
Reported-by: syzbot+c628140f24c07eb768d8@syzkaller.appspotmail.com
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap/buffered-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index e5c1ca440d93..01f0263e285a 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1554,7 +1554,8 @@ iomap_fill_dirty_folios(
 	pgoff_t			start = offset >> PAGE_SHIFT;
 	pgoff_t			end = (offset + length - 1) >> PAGE_SHIFT;
 
-	iter->fbatch = kmalloc(sizeof(struct folio_batch), GFP_KERNEL);
+	iter->fbatch = kmalloc(sizeof(struct folio_batch),
+				mapping_gfp_mask(mapping));
 	if (!iter->fbatch)
 		return offset + length;
 	folio_batch_init(iter->fbatch);

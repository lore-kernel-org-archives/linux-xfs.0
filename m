Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A0C1B0437
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 01:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756171464; cv=none; b=lsq4bzEVfWaSBAG5iUYGLSrFL8tUG1DbPNkhoCukrYS4YdVj69CTqdf/P+pxRaclsNFx7t4mcTC0iC9miC5N8kxWoMYAQODXRdx1eTkPZMFcq2Tzx/J7ehBc7iF+VF2CqAy4kYVpN5HuqxRAlQvAdCFpgJu6ujtWDcOUusrep9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756171464; c=relaxed/simple;
	bh=wAFk8pmWvuBVZgfWNWp0tQy6YGf2DZuA0iYfoc1Enf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G086aMboOYIkgq/yczgHnzFfEklCL+YOdvBZWA8oxYXxOnbOxVExCjh5wyibpzh1O4XlRs8fuBFS7VequxHvXvrR+eBNjBe2x2elE2D1XcM5J2DPgp+jYXMMGw8FDbJG6mVIjuLjEjaSdwACdR5wWYx/pDSaqV69NpJtTpLWpLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=X+CZxHj/; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="X+CZxHj/"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-32519b32b6cso2684375a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 18:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1756171462; x=1756776262; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ltti8iRy2np+ORk+ZjBogBIUbwWTr9OZzV4iETiziIQ=;
        b=X+CZxHj/wTY6X60gnHe2qKt9snOv8SYifjCk5LjYERB9s0ZOcUtJSPRJBvMFxrPHY3
         S9Zed2muzA7b9KYXPH1Weog2xUZ637XprFEhyTV900ZV4y3Ch0/JYLyzAlkzTZ4m4at1
         ZQxK0JNm57DAWH0i/xYing1wB2i1GO5BDR+ugu9OWvWWjvnsN594YqClJSLoNx3eqIdh
         hTM39ZDbjafKiJBnm3dUXZTN3Klpu9gPPxFCYiITCH36+FyXGh4g4Npg5gPqiMarNQss
         t5IXPjA1qU3ke619A7S4t+D1KLFS5FsDPWhPZIfBHnxvaJbh0zYGmFP6i2uHQuUonrJk
         TTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756171462; x=1756776262;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ltti8iRy2np+ORk+ZjBogBIUbwWTr9OZzV4iETiziIQ=;
        b=PW/PY0tbDNR0BlYWhpI5P3h/NSmRMAzf+i/IOKmoyAfZse9YGFaOSAxjMjUjbCHe3B
         Kgr3rDip/oaMiSUxhsifGIMPgNb+RYGGMrSExO4mvuACQULt7axL/qNRkp2t9yHW/hKY
         xJk4ZMX7MbYhS2b0LcsFIAZsT4EKRj78Oj37DLRN9TW8/4P85JKqhLOw25irGh1Gzmww
         ZO1GEbMYRirymOCTZZY9XBbe3zXQlryo/zA/jEQjtSeeRl8e7SG13VNWbYSheQcjQ6SN
         8IB7taY5TNpgVo//POdjcGXX+J6p/1XxEsaAVrk10AgX2BfjHlOv3VTybpcPyFPhSFcM
         6wvA==
X-Forwarded-Encrypted: i=1; AJvYcCXeobjepm45F6gkku3c1XInuCdjb21HIcF+iYJ4fBsCXBUsXwGgGyty7jIGwW/JitjARDwdflVm9SQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyft+8h2dUcrA5r+CLpps6ghVywfko6uZVKTSyZgTgNnvqMsLbp
	tq/ebxxN4BuHSYwqLoStxzRF0mG0hiAZ8hcVLPmceHYf7SFshlze49aD2rvrMtkfzRw=
X-Gm-Gg: ASbGnctFIRDCQERpV3J2sjnXKNNycAoEQrg608s48w4BUV3vUIbbYgddyoifCU00/RX
	6k8h0bjXLZXSd51YqXkqyB20gfypzw/qdRjkFsEubCmJeybLkwqtnk1L3PM4CPaEb/tZDi5KKSg
	W6/RdIpAlaEbAmaEJTJGlsKkF5g3m+Yl4vGBm0WoN+vq65mnLlcXmRV4ueO/7p726ofeWklVlek
	cxw2FhclgbJyBBW1Ad1KjO5jz8eIsts+PLq0oMoYYwdpvbOS0Ouu0e6Eph0bJAPqZdioV9sFbh1
	l36mCmReLwnWXntO6ZXcAxYCi2wLROgEEkYHvC1ukBoV57Xbbx+TZxzDlhQvq3OmkU3mN9PhGnB
	rz9Lxj+8gjq8gGoaPMtcBrxctSTkx3D7zLvStJNpAKLwD7qLyyzEbj12sM4ucsRKTZc0P5xqCyA
	==
X-Google-Smtp-Source: AGHT+IHE3ii5zDvPdNZKyz/jfhGzlMKkouBfRQy8ylfVeQ9ry0GQPkZOqQB9xvP0F9FcqNlw4Y4KoQ==
X-Received: by 2002:a17:90b:3d0d:b0:311:df4b:4b93 with SMTP id 98e67ed59e1d1-32515ec3216mr19358089a91.7.1756171461797;
        Mon, 25 Aug 2025 18:24:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49d858ae34sm5805538a12.47.2025.08.25.18.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 18:24:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uqiQ5-0000000B8dn-2nau;
	Tue, 26 Aug 2025 11:24:17 +1000
Date: Tue, 26 Aug 2025 11:24:17 +1000
From: Dave Chinner <david@fromorbit.com>
To: syzbot <syzbot+4e6ee73c0ae4b6e8753f@syzkaller.appspotmail.com>
Cc: cem@kernel.org, cmaiolino@redhat.com, dchinner@redhat.com,
	djwong@kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] KASAN: slab-use-after-free Write in
 xlog_cil_committed
Message-ID: <aK0MwSIIv4Ca-RXw@dread.disaster.area>
References: <68a70f15.050a0220.3d78fd.0024.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68a70f15.050a0220.3d78fd.0024.GAE@google.com>

On Thu, Aug 21, 2025 at 05:20:37AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    931e46dcbc7e Add linux-next specific files for 20250814
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=14621234580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a286bd75352e92fa
> dashboard link: https://syzkaller.appspot.com/bug?extid=4e6ee73c0ae4b6e8753f
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1128faf0580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12621234580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/fb896162d550/disk-931e46dc.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/45f6f857b82c/vmlinux-931e46dc.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/0f16e70143e1/bzImage-931e46dc.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/d03c38510d66/mount_0.gz
>   fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=15e82442580000)
> 
> The issue was bisected to:
> 
> commit d2fe5c4c8d25999862d615f616aea7befdd62799
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Wed Jun 25 22:48:58 2025 +0000
> 
>     xfs: rearrange code in xfs_buf_item.c

I don't think this is the cause of the issue. It certainly exposed
the problem being tripped over and will need fixing, but there's
some underlying whackiness going on here....

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14bca6f0580000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=16bca6f0580000
> console output: https://syzkaller.appspot.com/x/log.txt?x=12bca6f0580000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+4e6ee73c0ae4b6e8753f@syzkaller.appspotmail.com
> Fixes: d2fe5c4c8d25 ("xfs: rearrange code in xfs_buf_item.c")
> 
> BUG: KASAN: slab-use-after-free in instrument_atomic_write include/linux/instrumented.h:82 [inline]
> BUG: KASAN: slab-use-after-free in set_bit include/asm-generic/bitops/instrumented-atomic.h:28 [inline]
> BUG: KASAN: slab-use-after-free in xlog_cil_ail_insert fs/xfs/xfs_log_cil.c:791 [inline]
> BUG: KASAN: slab-use-after-free in xlog_cil_committed+0x45e/0x1040 fs/xfs/xfs_log_cil.c:897
> Write of size 8 at addr ffff8880750cbc10 by task kworker/1:0H/25

Just before this:

[   93.113540][ T6320] loop4: detected capacity change from 32768 to 64
[   93.121392][ T6320] XFS (loop4): Metadata corruption detected at xfs_inobt_verify+0x9e/0x1f0, xfs_finobt block 0x8
[   93.136248][ T6320] XFS (loop4): Unmount and run xfs_repair
[   93.144727][ T6320] XFS (loop4): First 128 bytes of corrupted metadata buffer:
[   93.152601][ T6320] 00000000: 41 42 33 42 00 00 00 02 ff ff ff ff ff ff ff ff  AB3B............
[   93.162774][ T6320] 00000010: 00 00 00 00 00 00 00 08 00 00 00 01 00 00 00 10  ................
[   93.171779][ T6320] 00000020: c4 96 e0 5e 54 0d 4c 72 b5 91 04 d7 9d 8b 4e eb  ...^T.Lr......N.
[   93.182192][ T6320] 00000030: 00 00 00 00 c8 fc 31 e4 00 00 04 4e 00 00 00 02  ......1....N....
[   93.191959][ T6320] 00000040: 00 00 04 60 00 00 0b a0 00 00 00 00 00 00 00 00  ...`............
[   93.211058][ T6320] 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   93.228793][ T6320] 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   93.241303][ T6320] 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   93.255636][ T6320] XFS (loop4): metadata I/O error in "xfs_btree_read_buf_block+0x290/0x470" at daddr 0x8 len 8 error 117
[   93.308796][ T5995] syz-executor: attempt to access beyond end of device
[   93.308796][ T5995] loop4: rw=432129, sector=96, nr_sectors = 16 limit=64
[   93.308796][ T5995] syz-executor: attempt to access beyond end of device
[   93.308796][ T5995] loop4: rw=432129, sector=96, nr_sectors = 16 limit=64
[   93.310419][ T3859] XFS (loop4): Metadata corruption detected at xfs_btree_lookup_get_block+0x3c5/0x500, xfs_bnobt block 0x8
[   93.330994][   T56] XFS (loop4): log I/O error -5
[   93.337979][ T3859] XFS (loop4): Unmount and run xfs_repair
[   93.344019][   T56] XFS (loop4): Filesystem has been shut down due to log error (0x2).
[   93.353457][   T56] XFS (loop4): Please unmount the filesystem and rectify the problem(s).
[   93.364934][ T5995] XFS (loop4): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb

So, syszbot has resized the block device under the filesystem to
almost all IO now returns -EIO. Then the journal aborts and trips
this UAF:

> CPU: 1 UID: 0 PID: 25 Comm: kworker/1:0H Not tainted 6.17.0-rc1-next-20250814-syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
> Workqueue: xfs-log/loop0 xlog_ioend_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xca/0x240 mm/kasan/report.c:482
>  kasan_report+0x118/0x150 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:-1 [inline]
>  kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:200
>  instrument_atomic_write include/linux/instrumented.h:82 [inline]
>  set_bit include/asm-generic/bitops/instrumented-atomic.h:28 [inline]
>  xlog_cil_ail_insert fs/xfs/xfs_log_cil.c:791 [inline]
>  xlog_cil_committed+0x45e/0x1040 fs/xfs/xfs_log_cil.c:897
>  xlog_cil_process_committed+0x15c/0x1b0 fs/xfs/xfs_log_cil.c:927
>  xlog_state_shutdown_callbacks+0x269/0x360 fs/xfs/xfs_log.c:488
>  xlog_force_shutdown+0x332/0x400 fs/xfs/xfs_log.c:3520
>  xlog_ioend_work+0xaf/0x100 fs/xfs/xfs_log.c:1245
>  process_one_work kernel/workqueue.c:3236 [inline]
>  process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
>  worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>

Where the journal completion has tried to set the XFS_LI_ABORTED bit
on the log item before running ->iop_committed/->iop_unpin on it.
It should have a reference to the BLI at this point - it's not
dropped until ->iop_unpin() is run.

So, we have a BLI reference counting problem.

> Allocated by task 5867:
>  kasan_save_stack mm/kasan/common.c:56 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
>  unpoison_slab_object mm/kasan/common.c:339 [inline]
>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:365
>  kasan_slab_alloc include/linux/kasan.h:250 [inline]
>  slab_post_alloc_hook mm/slub.c:4180 [inline]
>  slab_alloc_node mm/slub.c:4229 [inline]
>  kmem_cache_alloc_noprof+0x1c1/0x3c0 mm/slub.c:4236
>  xfs_buf_item_init+0x66/0x670 fs/xfs/xfs_buf_item.c:878
>  _xfs_trans_bjoin+0x46/0x110 fs/xfs/xfs_trans_buf.c:75
>  xfs_trans_read_buf_map+0x28f/0x8e0 fs/xfs/xfs_trans_buf.c:325
>  xfs_trans_read_buf fs/xfs/xfs_trans.h:210 [inline]

Here's where the BLI was allocated, after a free space btree buffer
read during a transaction. The buffer will have already been read
from disk, so it's supposedly XBF_DONE, contains valid data and the
BLI has a single reference.

The same task then -reads the same buffer again-, and issues IO on
it again. Not sure why this happens - it should have been found in
the transaction itself and simply reused. (that's whackiness #1)

> Freed by task 5876:
>  kasan_save_stack mm/kasan/common.c:56 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
>  __kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:587
>  kasan_save_free_info mm/kasan/kasan.h:406 [inline]
>  poison_slab_object mm/kasan/common.c:252 [inline]
>  __kasan_slab_free+0x5b/0x80 mm/kasan/common.c:284
>  kasan_slab_free include/linux/kasan.h:233 [inline]
>  slab_free_hook mm/slub.c:2417 [inline]
>  slab_free mm/slub.c:4680 [inline]
>  kmem_cache_free+0x18f/0x400 mm/slub.c:4782
>  __xfs_buf_ioend+0x29c/0x6f0 fs/xfs/xfs_buf.c:1202
>  xfs_buf_iowait+0x167/0x480 fs/xfs/xfs_buf.c:1384
>  _xfs_buf_read fs/xfs/xfs_buf.c:646 [inline]
>  xfs_buf_read_map+0x335/0xa50 fs/xfs/xfs_buf.c:712
>  xfs_trans_read_buf_map+0x1d7/0x8e0 fs/xfs/xfs_trans_buf.c:304
>  xfs_trans_read_buf fs/xfs/xfs_trans.h:210 [inline]

And then frees the BLI during IO completion.

Say what? This code path should not be possible. (whackiness #2)

i.e. the stack trace indicates a -write IO completion- is running
on a buffer read IO, on a buffer that has supposedly already been
read, initialised and joined to the transaction.

_xfs_buf_read() does:

	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD | XBF_DONE);
        bp->b_flags |= XBF_READ;
        xfs_buf_submit(bp);
        return xfs_buf_iowait(bp);

This is all done with the buffer locked, so nothing else should be
touching it at this point.

The code path that frees the buf item on IO completion does this:

>  __xfs_buf_ioend+0x29c/0x6f0 fs/xfs/xfs_buf.c:1202

1166 static bool
1167 __xfs_buf_ioend(
1168         struct xfs_buf  *bp)
1169 {
1170         trace_xfs_buf_iodone(bp, _RET_IP_);
1171
1172         if (bp->b_flags & XBF_READ) {
.....
1182         } else {
.....
1196                 /*
1197                  * Note that for things like remote attribute buffers, there may
1198                  * not be a buffer log item here, so processing the buffer log
1199                  * item must remain optional.
1200                  */
1201                 if (bp->b_log_item)
1202   >>>>>>>>>             xfs_buf_item_done(bp);
1203

Which clearly points out that at IO completion XBF_READ is *not set*
and so it has run write IO completion.  As a result, the BLI
attached to the buffer gets freed.

Finally, if the buffer is in the CIL and being committed, it should
be pinned, which prevents write IO from being issued. i.e.
xfs_buf_submit() does:

	if (bp->b_flags & XBF_WRITE)
                xfs_buf_wait_unpin(bp);

So we cannot have issued the IO with XBF_WRITE set....

IOWs, this failure has been triggered by something corrupting buffer
state whilst it is under IO, which then triggers a premature free of
the BLI, which then triggers a UAF when the journal tries to access
it.

The bisected commit removed this check from xfs_buf_item_relse():

-       if (atomic_read(&bip->bli_refcount))
-               return;

and that is what has exposed this whacky "write IO completion on a
read IO" behaviour.

This above check tries to takes into account the fact the AIL
doesn't hold a reference to the BLI, and so write IO is done without
references to the BLI. Hence at IO completion, it was used to check
to see if new references had been taken to the BLI whilst the IO was
in flight.

I removed this check and replaced it with an ASSERT because it
should not be possible for the AIL to do writeback of a buffer when
the BLI is referenced. Nor should it be possible to take a new BLI
reference whilst the buffer is being written. i.e.:

- the transaction modifying the buffer holds it locked (and so
  writeback cannot be started), it pins the BLI before unlocking the
  buffer and passes the BLI reference to the pin.
- items in the CIL or being committed by journal IO are pinned so
  cannot be written back. The BLI ref associated with the pin is
  dropped before the unpin wakeups are run.
- writeback is done holding the buffer lock whilst doing IO and
  waiting on an unpin wakeup, so no new BLI references can be taken
  once writeback on the buffer has been started.

Hence it should not possible for write IO to occur whilst the BLI is
referenced, and therefore it should not be possible to run write IO
completion and call xfs_buf_item_done() to free the BLI while it is
actively referenced.

Did I miss something here?

As such, I think that the issue we need to understand here is why a
write IO completion is being run from read IO context. That's the
root cause of the UAF, not the commit the bisect landed on....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E92EB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jun 2023 15:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjFZP2F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jun 2023 11:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjFZP2D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2023 11:28:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D2E93;
        Mon, 26 Jun 2023 08:28:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B85160EC2;
        Mon, 26 Jun 2023 15:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96858C433C0;
        Mon, 26 Jun 2023 15:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1687793281;
        bh=S2Kjb13VGnWuBr65aLFEcvkGtLsC7vUg96ml5q0Yt4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oV1ipiSsjsj94QuaHDixcIUJmKhs+B+wsselM5xY74Mmft1xowMkKld1p/M3W+xEM
         Ue/Uakvf19dB52lz24gTDq/nV5Mroa2HD61iLHzgRRNjT35OZEQgJ4ZbIvOanGSoHt
         ajDAz5ju5gkHh5x20AAImHFwmwls1j8ntZU0YGCM=
Date:   Mon, 26 Jun 2023 17:27:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4] xfs: verify buffer contents when we skip log replay
Message-ID: <2023062645-swaddling-pushiness-ca7e@gregkh>
References: <20230626120826.1770707-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230626120826.1770707-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 26, 2023 at 05:38:26PM +0530, Chandan Babu R wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> commit 22ed903eee23a5b174e240f1cdfa9acf393a5210 upstream.
> 
> syzbot detected a crash during log recovery:
> 
> XFS (loop0): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f791
> XFS (loop0): Torn write (CRC failure) detected at log block 0x180. Truncating head block from 0x200.
> XFS (loop0): Starting recovery (logdev: internal)
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in xfs_btree_lookup_get_block+0x15c/0x6d0 fs/xfs/libxfs/xfs_btree.c:1813
> Read of size 8 at addr ffff88807e89f258 by task syz-executor132/5074
> 
> CPU: 0 PID: 5074 Comm: syz-executor132 Not tainted 6.2.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x1b1/0x290 lib/dump_stack.c:106
>  print_address_description+0x74/0x340 mm/kasan/report.c:306
>  print_report+0x107/0x1f0 mm/kasan/report.c:417
>  kasan_report+0xcd/0x100 mm/kasan/report.c:517
>  xfs_btree_lookup_get_block+0x15c/0x6d0 fs/xfs/libxfs/xfs_btree.c:1813
>  xfs_btree_lookup+0x346/0x12c0 fs/xfs/libxfs/xfs_btree.c:1913
>  xfs_btree_simple_query_range+0xde/0x6a0 fs/xfs/libxfs/xfs_btree.c:4713
>  xfs_btree_query_range+0x2db/0x380 fs/xfs/libxfs/xfs_btree.c:4953
>  xfs_refcount_recover_cow_leftovers+0x2d1/0xa60 fs/xfs/libxfs/xfs_refcount.c:1946
>  xfs_reflink_recover_cow+0xab/0x1b0 fs/xfs/xfs_reflink.c:930
>  xlog_recover_finish+0x824/0x920 fs/xfs/xfs_log_recover.c:3493
>  xfs_log_mount_finish+0x1ec/0x3d0 fs/xfs/xfs_log.c:829
>  xfs_mountfs+0x146a/0x1ef0 fs/xfs/xfs_mount.c:933
>  xfs_fs_fill_super+0xf95/0x11f0 fs/xfs/xfs_super.c:1666
>  get_tree_bdev+0x400/0x620 fs/super.c:1282
>  vfs_get_tree+0x88/0x270 fs/super.c:1489
>  do_new_mount+0x289/0xad0 fs/namespace.c:3145
>  do_mount fs/namespace.c:3488 [inline]
>  __do_sys_mount fs/namespace.c:3697 [inline]
>  __se_sys_mount+0x2d3/0x3c0 fs/namespace.c:3674
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f89fa3f4aca
> Code: 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffd5fb5ef8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00646975756f6e2c RCX: 00007f89fa3f4aca
> RDX: 0000000020000100 RSI: 0000000020009640 RDI: 00007fffd5fb5f10
> RBP: 00007fffd5fb5f10 R08: 00007fffd5fb5f50 R09: 000000000000970d
> R10: 0000000000200800 R11: 0000000000000206 R12: 0000000000000004
> R13: 0000555556c6b2c0 R14: 0000000000200800 R15: 00007fffd5fb5f50
>  </TASK>
> 
> The fuzzed image contains an AGF with an obviously garbage
> agf_refcount_level value of 32, and a dirty log with a buffer log item
> for that AGF.  The ondisk AGF has a higher LSN than the recovered log
> item.  xlog_recover_buf_commit_pass2 reads the buffer, compares the
> LSNs, and decides to skip replay because the ondisk buffer appears to be
> newer.
> 
> Unfortunately, the ondisk buffer is corrupt, but recovery just read the
> buffer with no buffer ops specified:
> 
> 	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno,
> 			buf_f->blf_len, buf_flags, &bp, NULL);
> 
> Skipping the buffer leaves its contents in memory unverified.  This sets
> us up for a kernel crash because xfs_refcount_recover_cow_leftovers
> reads the buffer (which is still around in XBF_DONE state, so no read
> verification) and creates a refcountbt cursor of height 32.  This is
> impossible so we run off the end of the cursor object and crash.
> 
> Fix this by invoking the verifier on all skipped buffers and aborting
> log recovery if the ondisk buffer is corrupt.  It might be smarter to
> force replay the log item atop the buffer and then see if it'll pass the
> write verifier (like ext4 does) but for now let's go with the
> conservative option where we stop immediately.
> 
> Link: https://syzkaller.appspot.com/bug?extid=7e9494b8b399902e994e
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> Acked-by: Darrick J. Wong <djwong@kernel.org>
> ---
> Hi Greg,
> 
> This is a backport of a patch that has already been merged into 6.1.y,
> 5.15.y and 5.10.y. I have tested this patch and have not found any new
> regressions arising because of it. Please commit this patch into 5.4.y
> tree.

Now queued up, thanks.

greg k-h

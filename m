Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC5DC7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 23:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjDKXx1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 19:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDKXx0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 19:53:26 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7650B2139
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 16:53:25 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id j8so8071301pjy.4
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 16:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1681257205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZbITci/k7Kzzxm3lg8XhDWnK2GO7bZZQYMor5L4Pw/c=;
        b=FJBXAabVUF7r0blTgbPOVw+bH1vOEJ9xlpCyuNaq372wL0A9hhMwzsgd6QuBNPoD56
         Cm4WGXx5SL5YVvkfXeJ+r1WuaIcLOpLisINYqFkWhEbFl90tOqUY7JMpxvjz8wR+Mv8A
         QyMCmI67MB9pDx6KZnuKmNo06eACOKa+GBEyym5stnchtAMadeoyRC97JhwcbSE5Tovx
         r6SgSGm77XmaA1wsOVjFHth6WP+wf8Xw6jh8XDeoZ0mJS9k/uaxEpQfUfh110vUprz/r
         uJO90urSySY5Tw+OeX7OaitfHdOKKRm2CMrxfO9Vefjay152FAS5NjkClNTO+LAvnXwg
         hv6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681257205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZbITci/k7Kzzxm3lg8XhDWnK2GO7bZZQYMor5L4Pw/c=;
        b=Bznry+Raj4X997/mTgRCCGkJj0Y7prb7/Eyk+DBKTovvUOsKfUmZnUXF3edRouI449
         NN6g7ofFSy1cjjytmmumZ9gaqM9SQBnLK3rvmGi8rpNlXB0XqRRpX6WyLsfWJnHOL892
         HOZ+PY2kVqs17wgPDGXd3ZQZyyKteMZAf+ot3VCCoi2oncoo/V1NII34+XIDakbLqoTj
         2cqIn5xZMo0DIAfudUllUyKoUcMoIwP9VAdCgz3xdNUSPZfnI1oGf4Cz8Gb0qZhxSorD
         UH/l5zI7EE2R5ONxusdmmg+USAtwHCr3DsbLDX0xLlc7p5lMBAU/FEfjlXRMWbFB/RDF
         lGlw==
X-Gm-Message-State: AAQBX9cdPYpU2/JVTIHR6ZzYPJLqWV3064yjYGA0bt0usOrG7AlVQKKU
        CP4ns2yhpqQXWKGb+q7Iofnj6w3cO48e30rYuB8mQWV9E/U=
X-Google-Smtp-Source: AKy350a7YtBJ46Zg3POz/KnfUGTrYmeWnKXHvtxEp4S9A17hHL7fzEHpjhbITbCUTDLfV8+qS6tHZg==
X-Received: by 2002:a17:90b:4d04:b0:233:c301:32b3 with SMTP id mw4-20020a17090b4d0400b00233c30132b3mr6628503pjb.3.1681257204880;
        Tue, 11 Apr 2023 16:53:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id dw16-20020a17090b095000b00233cde36909sm155895pjb.21.2023.04.11.16.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 16:53:24 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pmNnd-002He6-I9; Wed, 12 Apr 2023 09:53:21 +1000
Date:   Wed, 12 Apr 2023 09:53:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: verify buffer contents when we skip log replay
Message-ID: <20230411235321.GC3223426@dread.disaster.area>
References: <20230411233159.GH360895@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411233159.GH360895@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 11, 2023 at 04:31:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
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
> Fixes: 67dc288c2106 ("xfs: ensure verifiers are attached to recovered buffers")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_buf_item_recover.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 5368a0d34452..ebe7f2c3cf63 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -971,6 +971,16 @@ xlog_recover_buf_commit_pass2(
>  	if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
>  		trace_xfs_log_recover_buf_skip(log, buf_f);
>  		xlog_recover_validate_buf_type(mp, bp, buf_f, NULLCOMMITLSN);
> +
> +		/*
> +		 * We're skipping replay of this buffer log item due to the log
> +		 * item LSN being behind the ondisk buffer.  Verify the buffer
> +		 * contents since we aren't going to run the write verifier.
> +		 */
> +		if (bp->b_ops) {
> +			bp->b_ops->verify_read(bp);
> +			error = bp->b_error;
> +		}
>  		goto out_release;
>  	}

Good catch - an unverified buffer in memory is definitely a
landmine recovery shouldn't be leaving behind...

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

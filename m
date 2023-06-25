Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E23EB64DC
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Jun 2023 22:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjFYWe1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 25 Jun 2023 18:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjFYWe0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Jun 2023 18:34:26 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3F91B7
        for <linux-xfs@vger.kernel.org>; Sun, 25 Jun 2023 15:34:25 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id 5614622812f47-39ca120c103so2087560b6e.2
        for <linux-xfs@vger.kernel.org>; Sun, 25 Jun 2023 15:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687732464; x=1690324464;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s4yBb03ugrMi47R3eazPpJE6uQLph1c0O7a9F+kkM/I=;
        b=oU0ozSS23XtC0W+FcwMnT0OczCD3cxQBennIwH7BnV8EgterPHj3w5CHwtqMM3VDKN
         sGH2L+3WDyUOMV9/i4w7THY6plMcPCZqjG6iusjeqY0gJZTkwYiw4N0Mq2dsHT9U1SDx
         22u31LMYKqW6fOvI04bDUMu2r/qjiULPAgrbQ0Np9QTLUNM/aiDYsTtHfa7v8I7af4zx
         /f0wn5+ahpCcY17/lFN3NjYGNew5ezgqDP8preTOkwevHSjfuRZq+cCo2a83m20QJyFC
         K4ddZRVxmR180HDLRKKpqSMGtbNFSXAqhNJdq0Yj8BTY2h5zf1xwQxQQDVAJHkzMZpLT
         L49Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687732464; x=1690324464;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s4yBb03ugrMi47R3eazPpJE6uQLph1c0O7a9F+kkM/I=;
        b=Yn53KsszXBWaFcl8PVX5FitWsOAFbvVbBXoIbHTP10BkxIX9dQuWWW5B9cY5QnJ3eY
         OeT4wNUee16k8Vw0p6tsCcpC2QiIUBNLrsN37bqghA/vqTKtMTMR+QHiRh7e+2T2ApYC
         RKCGqPKS8HfP9OxVoLwuA01LG8POqZ+WebyKgCRbEoFnahgHtOn6nMuVJWBUy6S4XHy7
         UXHdtqlgAPXWpCjL6YuaAtf6Pc2HvfjPY3CvY4DwHZ5IRF05jAFXl6z+PXE7+vHvJXmN
         Lz/SQy702Nk2mOTE5A+A/u1JudRigZ27laX8L9g3eAos9TFgdI/0JMSff7YGqccIGW01
         gU2w==
X-Gm-Message-State: AC+VfDy9AKs7L11J3GhdWbqxopZrt4VjJNJzOnV//mQao2S2hCc+/wJl
        5oyp71n2RNCpRtUPdAWNqqYfNF878jT8fEtdKs4=
X-Google-Smtp-Source: ACHHUZ4hyFebRB0+xK6N/CUUeDMNfLpEKhozOaJcE8jYGtanf1z2Qo0tcNeXN1qjYo3EXWZxQA6k2A==
X-Received: by 2002:a05:6808:2099:b0:3a0:67aa:739a with SMTP id s25-20020a056808209900b003a067aa739amr14000562oiw.44.1687732464531;
        Sun, 25 Jun 2023 15:34:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id g6-20020a17090ae58600b0025ed38d7dddsm3053674pjz.54.2023.06.25.15.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 15:34:23 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qDYJI-00GCKt-0b;
        Mon, 26 Jun 2023 08:34:20 +1000
Date:   Mon, 26 Jun 2023 08:34:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: fix AGF vs inode cluster buffer deadlock
Message-ID: <ZJjA7HU5dQY7pEPm@dread.disaster.area>
References: <20230517000449.3997582-1-david@fromorbit.com>
 <20230517000449.3997582-5-david@fromorbit.com>
 <ZJetR4WyR33vzjsj@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJetR4WyR33vzjsj@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 25, 2023 at 03:58:15AM +0100, Matthew Wilcox wrote:
> On Wed, May 17, 2023 at 10:04:49AM +1000, Dave Chinner wrote:
> > Lock order in XFS is AGI -> AGF, hence for operations involving
> > inode unlinked list operations we always lock the AGI first. Inode
> > unlinked list operations operate on the inode cluster buffer,
> > so the lock order there is AGI -> inode cluster buffer.
> 
> Hi Dave,
> 
> This commit reliably produces an assertion failure for me.  I haven't
> tried to analyse why.  It's pretty clear though; I can run generic/426
> in a loop for hundreds of seconds on the parent commit (cb042117488d),
> but it'll die within 30 seconds on commit 82842fee6e59.
> 
>     export MKFS_OPTIONS="-m reflink=1,rmapbt=1 -i sparse=1 -b size=1024"

That's part of my regular regression test config (mkfs defaults w/
1kB block size), and I haven't seen this problem.

I've just kicked off an iteration of g/426 on a couple of machines,
on a current TOT, and they are already a couple of hundred
iterations in without a failure....

Can you grab a trace for me? i.e. run

# trace-cmd record -e xfs\* -e printk

in one shell and leave it running. Then in another shell run the
test. when the test fails, ctrl-c the trace-cmd, and send me
the output of

# trace-cmd report > report.txt

> I suspect the size=1024 is the important thing, but I haven't tested
> that hypothesis.  This is on an x86-64 virtual machine; full qemu
> command line at the end [1]

As it's an inode cluster buffer failure, I very much doubt
filesystem block size plays a part. Inode buffer size is defined by
inode size, not filesystem block size and so the buffer in question
will be a 16kB unmapped buffer because inode size is 512 bytes...

> 00028 FSTYP         -- xfs (debug)
> 00028 PLATFORM      -- Linux/x86_64 pepe-kvm 6.4.0-rc5-00004-g82842fee6e59 #182 SMP PREEMPT_DYNAMIC Sat Jun 24 22:51:32 EDT 2023
> 00028 MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=1 -i sparse=1 -b size=1024 /dev/sdc
> 00028 MOUNT_OPTIONS -- /dev/sdc /mnt/scratch
> 00028
> 00028 XFS (sdc): Mounting V5 Filesystem 591c2048-7cce-4eda-acf7-649e19cd8554
> 00028 XFS (sdc): Ending clean mount
> 00028 XFS (sdc): Unmounting Filesystem 591c2048-7cce-4eda-acf7-649e19cd8554
> 00028 XFS (sdb): EXPERIMENTAL online scrub feature in use. Use at your own risk!
> 00028 XFS (sdb): Unmounting Filesystem 9db9e0a2-c05b-4690-a938-ae8f7b70be8e
> 00028 XFS (sdb): Mounting V5 Filesystem 9db9e0a2-c05b-4690-a938-ae8f7b70be8e
> 00028 XFS (sdb): Ending clean mount
> 00028 generic/426       run fstests generic/426 at 2023-06-25 02:52:07
> 00029 XFS: Assertion failed: bp->b_flags & XBF_DONE, file: fs/xfs/xfs_trans_buf.c, line: 241
> 00029 ------------[ cut here ]------------
> 00029 kernel BUG at fs/xfs/xfs_message.c:102!
> 00029 invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> 00029 CPU: 1 PID: 62 Comm: kworker/1:1 Kdump: loaded Not tainted 6.4.0-rc5-00004-g82842fee6e59 #182
> 00029 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> 00029 Workqueue: xfs-inodegc/sdb xfs_inodegc_worker
> 00029 RIP: 0010:assfail+0x30/0x40
> 00029 Code: c9 48 c7 c2 48 f8 ea 81 48 89 f1 48 89 e5 48 89 fe 48 c7 c7 b9 cc e5 81 e8 fd fd ff ff 80 3d f6 2f d3 00 00 75 04 0f 0b 5d c3 <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 55 48 63 f6 49 89
> 00029 RSP: 0018:ffff88800317bc78 EFLAGS: 00010202
> 00029 RAX: 00000000ffffffea RBX: ffff88800611e000 RCX: 000000007fffffff
> 00029 RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffffffff81e5ccb9
> 00029 RBP: ffff88800317bc78 R08: 0000000000000000 R09: 000000000000000a
> 00029 R10: 000000000000000a R11: 0fffffffffffffff R12: ffff88800c780800
> 00029 R13: ffff88800317bce0 R14: 0000000000000001 R15: ffff88800c73d000
> 00029 FS:  0000000000000000(0000) GS:ffff88807d840000(0000) knlGS:0000000000000000
> 00029 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 00029 CR2: 00005623b1911068 CR3: 000000000ee28003 CR4: 0000000000770ea0
> 00029 PKRU: 55555554
> 00029 Call Trace:
> 00029  <TASK>
> 00029  ? show_regs+0x5c/0x70
> 00029  ? die+0x32/0x90
> 00029  ? do_trap+0xbb/0xe0
> 00029  ? do_error_trap+0x67/0x90
> 00029  ? assfail+0x30/0x40
> 00029  ? exc_invalid_op+0x52/0x70
> 00029  ? assfail+0x30/0x40
> 00029  ? asm_exc_invalid_op+0x1b/0x20
> 00029  ? assfail+0x30/0x40
> 00029  ? assfail+0x23/0x40
> 00029  xfs_trans_read_buf_map+0x2d9/0x480
> 00029  xfs_imap_to_bp+0x3d/0x40
> 00029  xfs_inode_item_precommit+0x176/0x200
> 00029  xfs_trans_run_precommits+0x65/0xc0
> 00029  __xfs_trans_commit+0x3d/0x360
> 00029  xfs_trans_commit+0xb/0x10
> 00029  xfs_inactive_ifree.isra.0+0xea/0x200
> 00029  xfs_inactive+0x132/0x230
> 00029  xfs_inodegc_worker+0xb6/0x1a0
> 00029  process_one_work+0x1a9/0x3a0
> 00029  worker_thread+0x4e/0x3a0
> 00029  ? process_one_work+0x3a0/0x3a0
> 00029  kthread+0xf9/0x130
> 
> In case things have moved around since that commit, the particular line
> throwing the assertion is in this paragraph:
> 
>         if (bp) {
>                 ASSERT(xfs_buf_islocked(bp));
>                 ASSERT(bp->b_transp == tp);
>                 ASSERT(bp->b_log_item != NULL);
>                 ASSERT(!bp->b_error);
>                 ASSERT(bp->b_flags & XBF_DONE);

Nothing immediately obvious stands out here. 

I suspect it may be an interaction with memory reclaim freeing the
inode cluster buffer while it is clean after the inode has been
brought into memory, then xfs_ifree_cluster using
xfs_trans_get_buf() to invalidate the inode cluster (hence bringing
it into memory without reading it's contents) and then us trying to
read it, finding it already linked into the transaction, and it
skipping the buffer cache lookup that would have read the data
in....

The trace will tell me if this is roughly what is happening.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

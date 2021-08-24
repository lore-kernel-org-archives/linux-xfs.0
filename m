Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92722C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 11:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72B9461247
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 11:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236327AbhHXLEG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 07:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236428AbhHXLEG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Aug 2021 07:04:06 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F0BC061757
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 04:03:22 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id t42so15446867pfg.12
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 04:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:message-id
         :date:mime-version;
        bh=9ezM63KZWaG39u8OvmGCaQjqqwheC9gTM9eHkE9oulw=;
        b=H11G6qyTI+fHP4ylUeeCupYNtvptc6kbv9Bw1xyof/ohnZuhR9COzeodZMcbZole9A
         GCo3oitWvzbGKXftzt2uSSeXuQS05L4+VjYmCppOx2/iLRSR2fxh6RQYzFQJ4bJSFTbZ
         cpHyWpCI+G4PtHwNpbJBvnLdJA+lXFxKZv+C6VLSYGzxhGMc/V2P3+dVCUAiuqphupfG
         VQj/3cPJZ2Pmem5xavWDxHB/xBSk2Xx1LeMCZkSvfOeapsZ2PY5QP57ebdRNN5kxqU87
         MNopqMOMNo1wWKJoOW6jltwVmSrsS/ym3kY4yyexizVnlw8l61mQOt3QVZCJggt2JN4n
         ufoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:message-id:date:mime-version;
        bh=9ezM63KZWaG39u8OvmGCaQjqqwheC9gTM9eHkE9oulw=;
        b=H8P6k7tAQzXF1V3u4g6RZv95z9hr1vucxQBts5ZdsfucZtGRnKyJDuTwSwcni5QFPh
         542go8UOclnztB7fYeg41lJ4BSTx1CWGdKS5LcSIuXnOzgP81PWznWYg1XnC4wD9daze
         L82W50bo1Qg7CVwk9pRUE1pEXTn7wlFSy94dQmSx2ilLgl+gXPrFswYzI0QsyuvhwfWv
         uXhOmZkwrws4cRQpnRw1UwproVKo9kAU++l88Ef2BnyELlc4qRPaLtAKLFmsQG11LGQ7
         Q6/S/jEy7+25EpvWcTCBI0jlLKC1y0o4eBLzJQCehzn7M8IOx/cCxhF1WiMQUIpG7277
         02TQ==
X-Gm-Message-State: AOAM5308rAvgk2Zr43rKGxC1CfiKD6hj5dp2I5CAr3zrMz9cNs1oMxTT
        YSaxKpwIVgk7w7Rgio5TxsA4coIRhvU=
X-Google-Smtp-Source: ABdhPJwN1iplAllPiEdgVITIf84HyaRd18mu0dcKKZ934IfjPVBmHW22+S15h+f9Pno9fMhVGSggLQ==
X-Received: by 2002:aa7:93cd:0:b029:3e0:e283:9c45 with SMTP id y13-20020aa793cd0000b02903e0e2839c45mr38470739pff.53.1629803001917;
        Tue, 24 Aug 2021 04:03:21 -0700 (PDT)
Received: from garuda ([122.172.179.159])
        by smtp.gmail.com with ESMTPSA id v25sm18520381pfm.202.2021.08.24.04.03.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 24 Aug 2021 04:03:21 -0700 (PDT)
References: <20210824003739.GC12640@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: only set IOMAP_F_SHARED when providing a srcmap to
 a write
In-reply-to: <20210824003739.GC12640@magnolia>
Message-ID: <87eeajf6kp.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 24 Aug 2021 16:33:18 +0530
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 24 Aug 2021 at 06:07, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> While prototyping a free space defragmentation tool, I observed an
> unexpected IO error while running a sequence of commands that can be
> recreated by the following sequence of commands:
>
> # xfs_io -f -c "pwrite -S 0x58 -b 10m 0 10m" file1
> # cp --reflink=always file1 file2
> # punch-alternating -o 1 file2
> # xfs_io -c "funshare 0 10m" file2
> fallocate: Input/output error
>
> I then scraped this (abbreviated) stack trace from dmesg:
>
> WARNING: CPU: 0 PID: 30788 at fs/iomap/buffered-io.c:577 iomap_write_begin+0x376/0x450
> CPU: 0 PID: 30788 Comm: xfs_io Not tainted 5.14.0-rc6-xfsx #rc6 5ef57b62a900814b3e4d885c755e9014541c8732
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:iomap_write_begin+0x376/0x450
> RSP: 0018:ffffc90000c0fc20 EFLAGS: 00010297
> RAX: 0000000000000001 RBX: ffffc90000c0fd10 RCX: 0000000000001000
> RDX: ffffc90000c0fc54 RSI: 000000000000000c RDI: 000000000000000c
> RBP: ffff888005d5dbd8 R08: 0000000000102000 R09: ffffc90000c0fc50
> R10: 0000000000b00000 R11: 0000000000101000 R12: ffffea0000336c40
> R13: 0000000000001000 R14: ffffc90000c0fd10 R15: 0000000000101000
> FS:  00007f4b8f62fe40(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000056361c554108 CR3: 000000000524e004 CR4: 00000000001706f0
> Call Trace:
>  iomap_unshare_actor+0x95/0x140
>  iomap_apply+0xfa/0x300
>  iomap_file_unshare+0x44/0x60
>  xfs_reflink_unshare+0x50/0x140 [xfs 61947ea9b3a73e79d747dbc1b90205e7987e4195]
>  xfs_file_fallocate+0x27c/0x610 [xfs 61947ea9b3a73e79d747dbc1b90205e7987e4195]
>  vfs_fallocate+0x133/0x330
>  __x64_sys_fallocate+0x3e/0x70
>  do_syscall_64+0x35/0x80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f4b8f79140a
>
> Looking at the iomap tracepoints, I saw this:
>
> iomap_iter:           dev 8:64 ino 0x100 pos 0 length 0 flags WRITE|0x80 (0x81) ops xfs_buffered_write_iomap_ops caller iomap_file_unshare
> iomap_iter_dstmap:    dev 8:64 ino 0x100 bdev 8:64 addr -1 offset 0 length 131072 type DELALLOC flags SHARED
> iomap_iter_srcmap:    dev 8:64 ino 0x100 bdev 8:64 addr 147456 offset 0 length 4096 type MAPPED flags
> iomap_iter:           dev 8:64 ino 0x100 pos 0 length 4096 flags WRITE|0x80 (0x81) ops xfs_buffered_write_iomap_ops caller iomap_file_unshare
> iomap_iter_dstmap:    dev 8:64 ino 0x100 bdev 8:64 addr -1 offset 4096 length 4096 type DELALLOC flags SHARED
> console:              WARNING: CPU: 0 PID: 30788 at fs/iomap/buffered-io.c:577 iomap_write_begin+0x376/0x450
>
> The first time funshare calls ->iomap_begin, xfs sees that the first
> block is shared and creates a 128k delalloc reservation in the COW fork.
> The delalloc reservation is returned as dstmap, and the shared block is
> returned as srcmap.  So far so good.
>
> funshare calls ->iomap_begin to try the second block.  This time there's
> no srcmap (punch-alternating punched it out!) but we still have the
> delalloc reservation in the COW fork.  Therefore, we again return the
> reservation as dstmap and the hole as srcmap.  iomap_unshare_iter
> incorrectly tries to unshare the hole, which __iomap_write_begin rejects
> because shared regions must be fully written and therefore cannot
> require zeroing.
>
> Therefore, change the buffered write iomap_begin function not to set
> IOMAP_F_SHARED when there isn't a source mapping to read from for the
> unsharing.

Indeed, the hole following the 0th extent isn't a "shared extent" as was
conveyed by xfs_buffered_write_iomap_begin(). With this patch applied,
iomap_unshare_actor() returns early since the extent described by iomap isn't
shared.

I am fine with either your version of the fix or the fix authored by
Christoph.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_iomap.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 7c69b124a475..abf6d60945ab 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -870,6 +870,7 @@ xfs_buffered_write_iomap_begin(
>  	struct xfs_bmbt_irec	imap, cmap;
>  	struct xfs_iext_cursor	icur, ccur;
>  	xfs_fsblock_t		prealloc_blocks = 0;
> +	u16			cflags = 0;
>  	bool			eof = false, cow_eof = false, shared = false;
>  	int			allocfork = XFS_DATA_FORK;
>  	int			error = 0;
> @@ -1061,6 +1062,7 @@ xfs_buffered_write_iomap_begin(
>  found_cow:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	if (imap.br_startoff <= offset_fsb) {
> +		cflags = IOMAP_F_SHARED;
>  		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, 0);
>  		if (error)
>  			return error;
> @@ -1068,7 +1070,7 @@ xfs_buffered_write_iomap_begin(
>  		xfs_trim_extent(&cmap, offset_fsb,
>  				imap.br_startoff - offset_fsb);
>  	}
> -	return xfs_bmbt_to_iomap(ip, iomap, &cmap, IOMAP_F_SHARED);
> +	return xfs_bmbt_to_iomap(ip, iomap, &cmap, cflags);
>  
>  out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);


-- 
chandan

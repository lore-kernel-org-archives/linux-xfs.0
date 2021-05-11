Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B43C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 11:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D2D761207
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 11:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhEKLue (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 07:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbhEKLuc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 07:50:32 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F677C061574
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 04:49:25 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gq14-20020a17090b104eb029015be008ab0fso228512pjb.1
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 04:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=6GzUXw/5sVyUjFwJsWC5Mre/0Yn3N9FQiCKmLqdwxb4=;
        b=p5YvlIlIzbszhRHVd+Pl5UILBmOeVa0DhM6hBK4XL8HUyeCuJjnBqoGuMaW9Ih1vIj
         1vBZyHZ7IIfKCyu7ZJwmLns91gemHf2fFEB2Hazylmk3byEllEFK50eCxiTSl4KawUp3
         9gd52QFKLsIpE11SlYqulmKDz0Wtnu8KlMkE7lCtqoi/Mi9JPk6mFl9aLohuxsAJqSIW
         65oKHTJ+2fXmCwbGtw9PVSCR2wpRhzJg55jWSXg6QOmDWBi9UevaJFtE8VI6uGsjOeAC
         48TNHwPIp4qSEFUbPcoJOoSVxPAjyf6wnk2wnzF6l9sjN0hvG0ZvB2WKKkb2e/WbXAAf
         kfyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=6GzUXw/5sVyUjFwJsWC5Mre/0Yn3N9FQiCKmLqdwxb4=;
        b=NVHsNdTu6cg1T9CbQH/H8N/r/slLP0ins6JZ6JU+C9f8F07leqkuQiwXV1Rs95PVNn
         dlW7Vtj1JMkAfpb9YUGSiy+F8zPbt8xnFXC5DUlAGTZULYq3DiwMs4pIopN5QDRmGqZf
         Ve8MuZXyCCCmWnyaS0fvP4yEL6jy2GQjoWQxbfABRjQ32jnzaa2CCf6H9jITEPdkTxII
         wjYfZctGXQD9IPjlvScmh6IhEeOK8c2AxHPjHkXZTYhC+xXmyoHciGQIF/aFKFU7MZeN
         4JDPwedZ7PD5eyr3yiHdnsxr1NqIDYGaCa3C1kZnr9xzUOt6Dl7qWgS3xLp2JIaHZTc5
         oL7w==
X-Gm-Message-State: AOAM532FtTiZFmIUqSMuosBovVWw62IcirbZOW0U340JGWmNpM/ooukp
        Y4nyA0cpT3zYk07zGxIfZ7RuvjW7qrc=
X-Google-Smtp-Source: ABdhPJwMGlJTh5yWtNc42++S8vikP8NuiAx0PVf4WSeOvCRvw55QViUugWFZggWiyR6NawMiI+fVWA==
X-Received: by 2002:a17:902:6901:b029:ee:e531:ca5f with SMTP id j1-20020a1709026901b02900eee531ca5fmr29577638plk.37.1620733764665;
        Tue, 11 May 2021 04:49:24 -0700 (PDT)
Received: from garuda ([122.171.167.72])
        by smtp.gmail.com with ESMTPSA id c12sm3861017pfr.154.2021.05.11.04.49.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 May 2021 04:49:24 -0700 (PDT)
References: <20210428065152.77280-1-chandanrlinux@gmail.com> <20210428065152.77280-2-chandanrlinux@gmail.com> <20210429011231.GF63242@dread.disaster.area> <875z0399gw.fsf@garuda> <20210430224415.GG63242@dread.disaster.area> <87y2cwnnzp.fsf@garuda> <20210504000306.GJ63242@dread.disaster.area> <874kfh5p32.fsf@garuda> <20210506032751.GN63242@dread.disaster.area>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Prevent deadlock when allocating blocks for AGFL
In-reply-to: <20210506032751.GN63242@dread.disaster.area>
Date:   Tue, 11 May 2021 17:19:21 +0530
Message-ID: <87cztxwkvy.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 06 May 2021 at 08:57, Dave Chinner wrote:
> On Wed, May 05, 2021 at 06:12:41PM +0530, Chandan Babu R wrote:
>> > Hence when doing allocation for the free list, we need to fail the
>> > allocation rather than block on the only remaining free extent in
>> > the AG. If we are freeing extents, the AGFL not being full is not an
>> > issue at all. And if we are allocating extents, the transaction
>> > reservations should have ensured that the AG had sufficient space in
>> > it to complete the entire operation without deadlocking waiting for
>> > space.
>> >
>> > Either way, I don't see a problem with making sure the AGFL
>> > allocations just skip busy extents and fail if the only free extents
>> > are ones this transaction has freed itself.
>> >
>>
>> Hmm. In the scenario where *all* free extents in the AG were originally freed
>> by the current transaction (and hence busy in the transaction),
>
> How does that happen?

I tried in vain to arrive at the above mentioned scenario by consuming away as
many blocks as possible from the filesystem. At best, I could arrive at an AG
with just one free extent record in the cntbt (NOTE: I had to disable global
reservation by invoking "xfs_io -x -c 'resblks 0' $mntpnt"):

recs[1] = [startblock,blockcount]
1:[32767,1]

For each AG available in an FS instance, we take away 8
(i.e. XFS_ALLOC_AGFL_RESERVE + 4) blocks from the global free data blocks
counter. This reservation is applied to the FS as a whole rather than each AG
individually. Hence we could get to a scenario where an AG could have less
than 8 free blocks. I could not find any other restriction in the code that
explicitly prevents an AG from having zero free extents.

However, I could not create such an AG because any fs operation that needs
extent allocation to be done would try to reserve more than 1 extent causing
the above cited AG to not be chosen.

>
>> we would need
>> to be able to recognize this situation and skip invoking
>> xfs_extent_busy_flush() altogether.
>
> If we are freeing extents (i.e XFS_ALLOC_FLAG_FREEING is set) and
> we are doing allocation for AGFL and we only found busy extents,
> then it's OK to fail the allocation.

When freeing an extent, the following patch skips allocation of blocks to AGFL
if all the free extents found are busy,

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index aaa19101bb2a..5310e311d5c6 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1694,6 +1694,7 @@ xfs_alloc_ag_vextent_size(
 	 * are no smaller extents available.
 	 */
 	if (!i) {
+alloc_small_extent:
 		error = xfs_alloc_ag_vextent_small(args, cnt_cur,
 						   &fbno, &flen, &i);
 		if (error)
@@ -1710,6 +1711,9 @@ xfs_alloc_ag_vextent_size(
 		/*
 		 * Search for a non-busy extent that is large enough.
 		 */
+		xfs_agblock_t	orig_fbno = NULLAGBLOCK;
+		xfs_extlen_t	orig_flen;
+
 		for (;;) {
 			error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, &i);
 			if (error)
@@ -1719,6 +1723,11 @@ xfs_alloc_ag_vextent_size(
 				goto error0;
 			}

+			if (orig_fbno == NULLAGBLOCK) {
+				orig_fbno = fbno;
+				orig_flen = flen;
+			}
+
 			busy = xfs_alloc_compute_aligned(args, fbno, flen,
 					&rbno, &rlen, &busy_gen);

@@ -1729,6 +1738,13 @@ xfs_alloc_ag_vextent_size(
 			if (error)
 				goto error0;
 			if (i == 0) {
+				if (args->freeing_extent) {
+					error = xfs_alloc_lookup_eq(cnt_cur,
+							orig_fbno, orig_flen, &i);
+					ASSERT(!error && i);
+					goto alloc_small_extent;
+				}
+
 				/*
 				 * Our only valid extents must have been busy.
 				 * Make it unbusy by forcing the log out and
@@ -1819,7 +1835,7 @@ xfs_alloc_ag_vextent_size(
 	 */
 	args->len = rlen;
 	if (rlen < args->minlen) {
-		if (busy) {
+		if (busy && !args->freeing_extent) {
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 			trace_xfs_alloc_size_busy(args);
 			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
@@ -2641,6 +2657,7 @@ xfs_alloc_fix_freelist(
 	targs.alignment = targs.minlen = targs.prod = 1;
 	targs.type = XFS_ALLOCTYPE_THIS_AG;
 	targs.pag = pag;
+	targs.freeing_extent = flags & XFS_ALLOC_FLAG_FREEING;
 	error = xfs_alloc_read_agfl(mp, tp, targs.agno, &agflbp);
 	if (error)
 		goto out_agbp_relse;
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index a4427c5775c2..1e0fc28ef87a 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -78,6 +78,7 @@ typedef struct xfs_alloc_arg {
 #ifdef DEBUG
 	bool		alloc_minlen_only; /* allocate exact minlen extent */
 #endif
+	bool		freeing_extent;
 } xfs_alloc_arg_t;

 /*

With the above patch, xfs/538 cause the following call trace to be printed,

   XFS (vdc2): Internal error i != 1 at line 3426 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_btree_insert+0x15c/0x1f0
   CPU: 2 PID: 1284 Comm: punch-alternati Not tainted 5.12.0-rc8-next-20210419-chandan #19
   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
   Call Trace:
    dump_stack+0x64/0x7c
    xfs_corruption_error+0x85/0x90
    ? xfs_btree_insert+0x15c/0x1f0
    xfs_btree_insert+0x18d/0x1f0
    ? xfs_btree_insert+0x15c/0x1f0
    ? xfs_allocbt_init_common+0x30/0xf0
    xfs_free_ag_extent+0x463/0x9d0
    __xfs_free_extent+0xe5/0x200
    xfs_trans_free_extent+0x3e/0x100
    xfs_extent_free_finish_item+0x24/0x40
    xfs_defer_finish_noroll+0x1f7/0x5c0
    __xfs_trans_commit+0x12f/0x300
    xfs_free_file_space+0x1af/0x2c0
    xfs_file_fallocate+0x1ca/0x430
    ? __cond_resched+0x16/0x40
    ? inode_security+0x22/0x60
    ? selinux_file_permission+0xe2/0x120
    vfs_fallocate+0x146/0x2e0
    __x64_sys_fallocate+0x3e/0x70
    do_syscall_64+0x40/0x80
    entry_SYSCALL_64_after_hwframe+0x44/0xae

The above call trace occurs during execution of the step #2 listed below,
1. Filling up 90% of the free space of the filesystem.
2. Punch alternate blocks of files.

Just before the failure, the filesystem had ~9000 busy extents. So I think we
have to flush busy extents even when refilling AGFL for the purpose of freeing
an extent.

>
> We have options here - once we get to the end of the btree and
> haven't found a candidate that isn't busy, we could fail
> immediately. Or maybe we try an optimisitic flush which forces the
> log and waits for as short while (instead of forever) for the
> generation to change and then fail if we get a timeout response. Or
> maybe there's a more elegant way of doing this that hasn't yet
> rattled out of my poor, overloaded brain right now.
>
> Just because we currently do a blocking flush doesn't mean we always
> must do a blocking flush....

I will try to work out a solution.

--
chandan

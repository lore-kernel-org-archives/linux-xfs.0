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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C1C2C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 06:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4980164DB1
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 06:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhBWG1N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 01:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbhBWGZS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 01:25:18 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F98C061574
        for <linux-xfs@vger.kernel.org>; Mon, 22 Feb 2021 22:24:38 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id o63so11752634pgo.6
        for <linux-xfs@vger.kernel.org>; Mon, 22 Feb 2021 22:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=5/MDvXf4OSTvySPPtHkWwoZynp744dnk05C04HSuAVk=;
        b=HYeweNiLiIUyOix7+XWa7OKrW8RpATKIaD5311fafXPJKX7sVOcXco8aEBPvYMC7TK
         aUIpBo1aMVwisO+ITpH6YsTaSmq3w4ZX/w2jSIq8/JFKL2RKs2KVj1bY3G90ZoTPaipu
         6pibj+FugHD4OLDrvXmfOg8FkYOgpAtX5tU09zaaNh7SziDddJ+/PvmMIaVVb+aVc8q2
         /VdEAZBPtfA3hV7H+NE7lK81KDCjcHJmhYAyRDxQP/7Kf0NpxnNltFR3baxVTcqV0m5s
         VLNmMnAtBGbmAbaXW0Lh68pFJ/P0hGELrXIfladbTUBcdbwz5n+533N+TsDiwaoT2xUM
         FK/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=5/MDvXf4OSTvySPPtHkWwoZynp744dnk05C04HSuAVk=;
        b=rCz0v1IlaiLp2AvvdqutH8AQLr2Nstvc+7/1qTS31TQNLcK2NKabxsmD93aKQ4U1uq
         p1jPFSHlC0EQZV90a24lR8FiZRb/OtNTo/8G4qn7LHX1d4n9NcBvDM9UUPO1ox1GzJg6
         nq6X6iJgUaqbYa0QowU6ldxwkTrpGpv4lsYmve9NzYJVRAQPQ6LXXXhkzPgdPedQsXJ2
         gXMyJKtsr6M5PblaQtlyuKO4rWVKHHQfNWKthCYE7wxF1+Ob2EeFFgu868RgEoMM4Y4m
         4YYY1UiqrtVGWCrPNrl33/l+oWrbRz83S0saM4XNHTEBTZ641ITIvCsso+Az4WPzTYPb
         EcXA==
X-Gm-Message-State: AOAM5334o6lXI4seDulIXVW5auoc2UIgX9D9LcMBWowWB86f/J9eoSLH
        /cueprvLT+P5i3pJVNTqEq6QVg3CHNg=
X-Google-Smtp-Source: ABdhPJz7l+juwYGIlnMB7o5Ld06mPbsMz4p1xhHU4FITeWct+VniC4CJnCrQKQHhYtndnTzbswjGBQ==
X-Received: by 2002:aa7:9e04:0:b029:1ed:996a:abb4 with SMTP id y4-20020aa79e040000b02901ed996aabb4mr965605pfq.5.1614061477589;
        Mon, 22 Feb 2021 22:24:37 -0800 (PST)
Received: from garuda ([122.171.216.250])
        by smtp.gmail.com with ESMTPSA id 9sm20409285pgw.61.2021.02.22.22.24.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Feb 2021 22:24:37 -0800 (PST)
References: <20210222153442.897089-1-bfoster@redhat.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't reuse busy extents on extent trim
In-reply-to: <20210222153442.897089-1-bfoster@redhat.com>
Date:   Tue, 23 Feb 2021 11:54:32 +0530
Message-ID: <87k0qzmhcv.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 22 Feb 2021 at 21:04, Brian Foster wrote:
> Freed extents are marked busy from the point the freeing transaction
> commits until the associated CIL context is checkpointed to the log.
> This prevents reuse and overwrite of recently freed blocks before
> the changes are committed to disk, which can lead to corruption
> after a crash. The exception to this rule is that metadata
> allocation is allowed to reuse busy extents because metadata changes
> are also logged.
>
> As of commit 97d3ac75e5e0 ("xfs: exact busy extent tracking"), XFS
> has allowed modification or complete invalidation of outstanding
> busy extents for metadata allocations. This implementation assumes
> that use of the associated extent is imminent, which is not always
> the case. For example, the trimmed extent might not satisfy the
> minimum length of the allocation request, or the allocation
> algorithm might be involved in a search for the optimal result based
> on locality.
>
> generic/019 reproduces a corruption caused by this scenario. First,
> a metadata block (usually a bmbt or symlink block) is freed from an
> inode. A subsequent bmbt split on an unrelated inode attempts a near
> mode allocation request that invalidates the busy block during the
> search, but does not ultimately allocate it. Due to the busy state
> invalidation, the block is no longer considered busy to subsequent
> allocation. A direct I/O write request immediately allocates the
> block and writes to it. Finally, the filesystem crashes while in a
> state where the initial metadata block free had not committed to the
> on-disk log. After recovery, the original metadata block is in its
> original location as expected, but has been corrupted by the
> aforementioned dio.
>
> This demonstrates that it is fundamentally unsafe to modify busy
> extent state for extents that are not guaranteed to be allocated.
> This applies to pretty much all of the code paths that currently
> trim busy extents for one reason or another. Therefore to address
> this problem, drop the reuse mechanism from the busy extent trim
> path. This code already knows how to return partial non-busy ranges
> of the targeted free extent and higher level code tracks the busy
> state of the allocation attempt. If a block allocation fails where
> one or more candidate extents is busy, we force the log and retry
> the allocation.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_extent_busy.c | 14 --------------
>  1 file changed, 14 deletions(-)
>
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 3991e59cfd18..ef17c1f6db32 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -344,7 +344,6 @@ xfs_extent_busy_trim(
>  	ASSERT(*len > 0);
>  
>  	spin_lock(&args->pag->pagb_lock);
> -restart:
>  	fbno = *bno;
>  	flen = *len;
>  	rbp = args->pag->pagb_tree.rb_node;
> @@ -363,19 +362,6 @@ xfs_extent_busy_trim(
>  			continue;
>  		}
>  
> -		/*
> -		 * If this is a metadata allocation, try to reuse the busy
> -		 * extent instead of trimming the allocation.
> -		 */
> -		if (!(args->datatype & XFS_ALLOC_USERDATA) &&
> -		    !(busyp->flags & XFS_EXTENT_BUSY_DISCARDED)) {
> -			if (!xfs_extent_busy_update_extent(args->mp, args->pag,
> -							  busyp, fbno, flen,
> -							  false))
> -				goto restart;
> -			continue;
> -		}
> -
>  		if (bbno <= fbno) {
>  			/* start overlap */


-- 
chandan

Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6894C77B61
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 02:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjDKCGa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 22:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDKCG3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 22:06:29 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D62819AF
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 19:06:28 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y6so5314469plp.2
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 19:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1681178788;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1K45G3Xk38MRsn/IvI6UctDMVxWaPIpgJaoca1sEXqs=;
        b=diEKm0+TweYI/jv0x/zdN0qvjzeIpeP5Z6zIUcPDQDNA3sDlAKuLjsJ0WuhW6GPcZi
         XGPpfrY3CUOTkXYYeYqFr4ZPgmKktP4PGBQ6fHLqox+fieKJ5qKdGEK3yZgm8df3PXgR
         lCfze60RScipMedJVUhNfcePT9BWvVQRCKJyWo6FFPw/BPtYnJ3CbzQJPJdk0bfTB4VW
         OOoD1TtLVcK/dlZ7JPq/bCXnDj6EDWameXBBqUXdzpYP1LABkvMPcu+yv8eVtaSqDaVy
         cKkaqh0Sezc91w/wCuQK9X05x5sr2+Z5Mm89FZuxCi1QkJCEQ4pL/jxvYB1AZo0efaNY
         M06w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681178788;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1K45G3Xk38MRsn/IvI6UctDMVxWaPIpgJaoca1sEXqs=;
        b=mFGBGvsC+CDvArzbc9gmQ56IrWJQTJ/xLGRU02gaF5iI1vx2UN7CdonXsgjkyKCyOs
         kN+O29vS2V2Jg5MomZWYMLCz8prdOb5I0eKpWq1+lboSbONLTnsGluwSuZHCErcD4n05
         wvm1SXljVr3kj5gmyCeyR/FJdi2iXOsmLvqbNYE9oUZfLK6Y3L7/42SzmAvH9HRy4oHR
         AK4tAPn9pa3ePjw/Mx693zD/O8J6KJSkNU/3pFuzVpwP2EFBqmHgg26bkACbVHAXeY8h
         K6CconKVBY/4IoOVwntPPYdE7T1MaflCGnYQEcLfMsNs3yIkE8NHnpNJZ8SmbtobA03D
         W5kw==
X-Gm-Message-State: AAQBX9fVMUg5rYEjmaDjTviaQ2HqkDdWg01AJCo8U4X2WvtzJ0TzynRE
        NsH3zscv5z0uDPf3xhofs/2nRA==
X-Google-Smtp-Source: AKy350Yu9N94FYcnhpqPoNZlTMHxVJLQmckNh47/t1TEvNXk8sUOXnT7wDH5pVuvarZF9W1Jnt3i7w==
X-Received: by 2002:a17:902:dacd:b0:1a1:cef2:acd1 with SMTP id q13-20020a170902dacd00b001a1cef2acd1mr13061025plx.17.1681178788067;
        Mon, 10 Apr 2023 19:06:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id t20-20020a170902b21400b001a194df5a58sm8412150plr.167.2023.04.10.19.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 19:06:27 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pm3Oq-001vQ1-Hw; Tue, 11 Apr 2023 12:06:24 +1000
Date:   Tue, 11 Apr 2023 12:06:24 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix AGFL allocation dead lock
Message-ID: <20230411020624.GY3223426@dread.disaster.area>
References: <20230330204610.23546-1-wen.gang.wang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330204610.23546-1-wen.gang.wang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 30, 2023 at 01:46:10PM -0700, Wengang Wang wrote:
> There is deadlock with calltrace on process 10133:
> 
> PID 10133 not sceduled for 4403385ms (was on CPU[10])
> 	#0	context_switch() kernel/sched/core.c:3881
> 	#1	__schedule() kernel/sched/core.c:5111
> 	#2	schedule() kernel/sched/core.c:5186
> 	#3	xfs_extent_busy_flush() fs/xfs/xfs_extent_busy.c:598
> 	#4	xfs_alloc_ag_vextent_size() fs/xfs/libxfs/xfs_alloc.c:1641
> 	#5	xfs_alloc_ag_vextent() fs/xfs/libxfs/xfs_alloc.c:828
> 	#6	xfs_alloc_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:2362
> 	#7	xfs_free_extent_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:3029
> 	#8	__xfs_free_extent() fs/xfs/libxfs/xfs_alloc.c:3067
> 	#9	xfs_trans_free_extent() fs/xfs/xfs_extfree_item.c:370
> 	#10	xfs_efi_recover() fs/xfs/xfs_extfree_item.c:626
> 	#11	xlog_recover_process_efi() fs/xfs/xfs_log_recover.c:4605
> 	#12	xlog_recover_process_intents() fs/xfs/xfs_log_recover.c:4893
> 	#13	xlog_recover_finish() fs/xfs/xfs_log_recover.c:5824
> 	#14	xfs_log_mount_finish() fs/xfs/xfs_log.c:764
> 	#15	xfs_mountfs() fs/xfs/xfs_mount.c:978
> 	#16	xfs_fs_fill_super() fs/xfs/xfs_super.c:1908
> 	#17	mount_bdev() fs/super.c:1417
> 	#18	xfs_fs_mount() fs/xfs/xfs_super.c:1985
> 	#19	legacy_get_tree() fs/fs_context.c:647
> 	#20	vfs_get_tree() fs/super.c:1547
> 	#21	do_new_mount() fs/namespace.c:2843
> 	#22	do_mount() fs/namespace.c:3163
> 	#23	ksys_mount() fs/namespace.c:3372
> 	#24	__do_sys_mount() fs/namespace.c:3386
> 	#25	__se_sys_mount() fs/namespace.c:3383
> 	#26	__x64_sys_mount() fs/namespace.c:3383
> 	#27	do_syscall_64() arch/x86/entry/common.c:296
> 	#28	entry_SYSCALL_64() arch/x86/entry/entry_64.S:180
> 
> It's waiting xfs_perag.pagb_gen to increase (busy extent clearing happen).
> From the vmcore, it's waiting on AG 1. And the ONLY busy extent for AG 1 is
> with the transaction (in xfs_trans.t_busy) for process 10133. That busy extent
> is created in a previous EFI with the same transaction. Process 10133 is
> waiting, it has no change to commit that that transaction. So busy extent
> clearing can't happen and pagb_gen remain unchanged. So dead lock formed.

We've talked about this "busy extent in transaction" issue before:

https://lore.kernel.org/linux-xfs/20210428065152.77280-1-chandanrlinux@gmail.com/

and we were closing in on a practical solution before it went silent.

I'm not sure if there's a different fix we can apply here - maybe
free one extent per transaction instead of all the extents in an EFI
in one transaction and relog the EFD at the end of each extent free
transaction roll?

> commit 06058bc40534530e617e5623775c53bb24f032cb disallowed using busy extents
> for any path that calls xfs_extent_busy_trim(). That looks over-killing.
> For AGFL block allocation, it just use the first extent that satisfies, it won't
> try another extent for choose a "better" one. So it's safe to reuse busy extent
> for AGFL.

AGFL block allocation is not "for immediate use". The blocks get
placed on the AGFL for -later- use, and not necessarily even within
the current transaction. Hence a freelist block is still considered
free space, not as used space. The difference is that we assume AGFL
blocks can always be used immediately and they aren't constrained by
being busy or have pending discards.

Also, we have to keep in mind that we can allocate data blocks from
the AGFL in low space situations. Hence it is not safe to place busy
or discard-pending blocks on the AGFL, as this can result in them
being allocated for user data and overwritten before the checkpoint
that marked them busy has been committed to the journal....

As such, I don't think it is be safe to ignore busy extent state
just because we are filling the AGFL from the current free space
tree.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

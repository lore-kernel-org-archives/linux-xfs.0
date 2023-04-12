Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5B2C77B6C
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 23:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjDLX7W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 19:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLX7V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 19:59:21 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755723C39
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 16:59:20 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id la3so13031881plb.11
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 16:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1681343960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rv0eZ9Sw4VOmWUDSiycbcIekUdRKr8QiR0eBHnHZpV4=;
        b=ccdfOwbiff/EAm9gAR2MP6t8vTbevcPPSbIUUSUFibQXG42/Flcy5Cl2D2biNdmU30
         Cv3aItB7J7HcG+QzFeSf216lLekboj2ydkby09Q627F8qQHRbbxgrXvsL3/LcqmP0iqc
         VtaSO8g7lWbI28BFRxzdr8G8GM6VOFJVRIgUEp8vITbshj6+RxXRZwnP0UwM+Xohd9BF
         QaXMnRMkdUbCXq4/bww0jNN3sf/OQ/0AWG0Xxi8DouZiGqMG4ATVgSPkIILHHveaMDJ6
         y8maeMjCFV3cZut7ZvJMWf3QCQGRVzph5ZPfdvTrGkYkq9CwJQubz3QyCDrYoWVhFTjH
         Tqww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681343960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rv0eZ9Sw4VOmWUDSiycbcIekUdRKr8QiR0eBHnHZpV4=;
        b=Z/8Y5iZ2/SL909ouydsjVNZCWaGGAfW6/1DmRZazbI/1OYhvtv4JlL+BF/5swNubM/
         D9MRrnQRwsJ4yVmaxEXQW72SkwyHF4ksf5KJOwQaEEgEO2zuj5ySX5LEWUL040SyiPo6
         i7Rug67iic9A2LLr6hKoqJbjptIuirWFlrg7KiVwJIJ+p+4PM2DtPfYtclVRtgYnNbXT
         8+xj75Tsy/hy7+ZzfBnmAaaHn4ATML76uE5UZ7ZkiF5kI95k7pNvLxt8Na644w55W7wq
         rCd2nDcMFY5uXo1/YQtdDgQbA81uthXF9tbHIpojl+cj3GvpviWSWuBSeKi//LSS+9WC
         RxnA==
X-Gm-Message-State: AAQBX9do7/taYPjTyvgjsqhrEm13For7FEJrhBXPEtqMtOA1R2/e2fav
        vM4SGgINcCfVtnOIh0HaYEaiWJNVfjmqsnFiCXvyfIhg
X-Google-Smtp-Source: AKy350bg5NdJiQ6ujpjnx1ahWv72aXGT+hrF708Ic5B38m8jRYxADuAT9PkSppGIqX/MXe02CenZyA==
X-Received: by 2002:a17:902:dac9:b0:1a1:d366:b085 with SMTP id q9-20020a170902dac900b001a1d366b085mr137328plx.21.1681343959830;
        Wed, 12 Apr 2023 16:59:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id u9-20020a170902b28900b001a640f9ebb9sm154828plr.21.2023.04.12.16.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 16:59:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pmkMt-002gXo-U4; Thu, 13 Apr 2023 09:59:15 +1000
Date:   Thu, 13 Apr 2023 09:59:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     Wengang Wang <wen.gang.wang@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix AGFL allocation dead lock
Message-ID: <20230412235915.GN3223426@dread.disaster.area>
References: <20230330204610.23546-1-wen.gang.wang@oracle.com>
 <20230411020624.GY3223426@dread.disaster.area>
 <87mt3djwj9.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mt3djwj9.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2023 at 01:53:59PM +0530, Chandan Babu R wrote:
> On Tue, Apr 11, 2023 at 12:06:24 PM +1000, Dave Chinner wrote:
> > On Thu, Mar 30, 2023 at 01:46:10PM -0700, Wengang Wang wrote:
> >> There is deadlock with calltrace on process 10133:
> >> 
> >> PID 10133 not sceduled for 4403385ms (was on CPU[10])
> >> 	#0	context_switch() kernel/sched/core.c:3881
> >> 	#1	__schedule() kernel/sched/core.c:5111
> >> 	#2	schedule() kernel/sched/core.c:5186
> >> 	#3	xfs_extent_busy_flush() fs/xfs/xfs_extent_busy.c:598
> >> 	#4	xfs_alloc_ag_vextent_size() fs/xfs/libxfs/xfs_alloc.c:1641
> >> 	#5	xfs_alloc_ag_vextent() fs/xfs/libxfs/xfs_alloc.c:828
> >> 	#6	xfs_alloc_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:2362
> >> 	#7	xfs_free_extent_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:3029
> >> 	#8	__xfs_free_extent() fs/xfs/libxfs/xfs_alloc.c:3067
> >> 	#9	xfs_trans_free_extent() fs/xfs/xfs_extfree_item.c:370
> >> 	#10	xfs_efi_recover() fs/xfs/xfs_extfree_item.c:626
> >> 	#11	xlog_recover_process_efi() fs/xfs/xfs_log_recover.c:4605
> >> 	#12	xlog_recover_process_intents() fs/xfs/xfs_log_recover.c:4893
> >> 	#13	xlog_recover_finish() fs/xfs/xfs_log_recover.c:5824
> >> 	#14	xfs_log_mount_finish() fs/xfs/xfs_log.c:764
> >> 	#15	xfs_mountfs() fs/xfs/xfs_mount.c:978
> >> 	#16	xfs_fs_fill_super() fs/xfs/xfs_super.c:1908
> >> 	#17	mount_bdev() fs/super.c:1417
> >> 	#18	xfs_fs_mount() fs/xfs/xfs_super.c:1985
> >> 	#19	legacy_get_tree() fs/fs_context.c:647
> >> 	#20	vfs_get_tree() fs/super.c:1547
> >> 	#21	do_new_mount() fs/namespace.c:2843
> >> 	#22	do_mount() fs/namespace.c:3163
> >> 	#23	ksys_mount() fs/namespace.c:3372
> >> 	#24	__do_sys_mount() fs/namespace.c:3386
> >> 	#25	__se_sys_mount() fs/namespace.c:3383
> >> 	#26	__x64_sys_mount() fs/namespace.c:3383
> >> 	#27	do_syscall_64() arch/x86/entry/common.c:296
> >> 	#28	entry_SYSCALL_64() arch/x86/entry/entry_64.S:180
> >> 
> >> It's waiting xfs_perag.pagb_gen to increase (busy extent clearing happen).
> >> From the vmcore, it's waiting on AG 1. And the ONLY busy extent for AG 1 is
> >> with the transaction (in xfs_trans.t_busy) for process 10133. That busy extent
> >> is created in a previous EFI with the same transaction. Process 10133 is
> >> waiting, it has no change to commit that that transaction. So busy extent
> >> clearing can't happen and pagb_gen remain unchanged. So dead lock formed.
> >
> > We've talked about this "busy extent in transaction" issue before:
> >
> > https://lore.kernel.org/linux-xfs/20210428065152.77280-1-chandanrlinux@gmail.com/
> >
> > and we were closing in on a practical solution before it went silent.
> >
> > I'm not sure if there's a different fix we can apply here - maybe
> > free one extent per transaction instead of all the extents in an EFI
> > in one transaction and relog the EFD at the end of each extent free
> > transaction roll?
> >
> 
> Consider the case of executing a truncate operation which involves freeing two
> file extents on a filesystem which has refcount feature enabled.
> 
> xfs_refcount_decrease_extent() will be invoked twice and hence
> XFS_DEFER_OPS_TYPE_REFCOUNT will have two "struct xfs_refcount_intent"
> associated with it.

Yes, that's exactly the same issue as processing multiple extents
in a single EFI intent.

The same solution applies.

The design the intent/intent done infrastructure allows intents to
be logged repeatedly to indicate ongoing partial completion of the
original intent. The runtime deferred work completion does this (see
xfs_defer_finish_one() and handling the -EAGAIN return value).

Indeed, we have a requeue mechanism in xfs_cui_item_recover() -
look at what 'requeue_only' does. It stops processing the extents in
the intent and instead relogs them as deferred operations to be
processed in a later transaction context. IOWs, we can avoid
processing multiple extent frees in a single transaction with just a
small logic change to the recovery code to ensure it always requeues
after the first extent is processed.

Looking at recovery of intents:

BUIs only ever have one extent in them, so no change needed there.
CUIs can be requeued already, just need to update the loop.

RUIs will process all extents in a single transaction, so it needs
to be updated to relog and defer after the first extent is freed.

EFIs will process all extents in a single transaction, so it needs
to be updated to relog and defer after the first extent is freed.

ATTRI already do the right thing w.r.t. deferring updates to new
transaction contexts. No change needed.

IOWs, the number of extents in a given intent is largely irrelevant
as we can process them one extent at a time in recovery if we
actually need to just by relogging new intents as deferred work.

> Processing each of the "struct xfs_refcount_intent" can cause two refcount
> btree blocks to be freed:
> - A high level transacation will invoke xfs_refcountbt_free_block() twice.
> - The first invocation adds an extent entry to the transaction's busy extent
>   list. The second invocation can find the previously freed busy extent and
>   hence wait indefinitely for the busy extent to be flushed.
> 
> Also, processing a single "struct xfs_refcount_intent" can require the leaf
> block and its immediate parent block to be freed.  The leaf block is added to
> the transaction's busy list. Freeing the parent block can result in the task
> waiting for the busy extent (present in the high level transaction) to be
> flushed.

Yes, it probably can, but this is a different problem - this is an
internal btree update issue, not a "free multiple user extents in a
single transaction that may only have a reservation large enough
for a single user extent modification".

So, lets think about why the allocator might try to reuse a busy
extent on the next extent internal btree free operation in the
transaction.  The only way that I can see that happening is if the
AGFL needs refilling, and the only way the allocator should get
stuck in this way is if there are no other free extents in the AG.

It then follows that if there are no other free extents in the AG,
then we don't need to refill the AGFL, because freeing an extent in
an empty AG will never cause the free space btrees to grow. In which
case, we should not ever need to allocate from an extent that was
previously freed in this specific transaction.

We should also have XFS_ALLOC_FLAG_FREEING set, and this allows the
AGFL refill to abort without error if there are no free blocks
available because it's not necessary in this case.  If we can't find
a non-busy extent after flushing on an AGFL fill for a
XFS_ALLOC_FLAG_FREEING operation, we should just abort the freelist
refill and allow the extent free operation to continue.

Hence a second free operation in a single transaction in the same AG
(i.e. pretty much any multi-level btree merge operation) should
always succeed at ENOSPC regardless of how many busy extents there
are in the current transaction - we should never need to refill the
AGFL for these operations when the only free space in the AG is
space that has been freed by the transaction doing the freeing....

-Dave.

> >> commit 06058bc40534530e617e5623775c53bb24f032cb disallowed using busy extents
> >> for any path that calls xfs_extent_busy_trim(). That looks over-killing.
> >> For AGFL block allocation, it just use the first extent that satisfies, it won't
> >> try another extent for choose a "better" one. So it's safe to reuse busy extent
> >> for AGFL.
> >
> > AGFL block allocation is not "for immediate use". The blocks get
> > placed on the AGFL for -later- use, and not necessarily even within
> > the current transaction. Hence a freelist block is still considered
> > free space, not as used space. The difference is that we assume AGFL
> > blocks can always be used immediately and they aren't constrained by
> > being busy or have pending discards.
> >
> > Also, we have to keep in mind that we can allocate data blocks from
> > the AGFL in low space situations. Hence it is not safe to place busy
> > or discard-pending blocks on the AGFL, as this can result in them
> > being allocated for user data and overwritten before the checkpoint
> > that marked them busy has been committed to the journal....
> >
> > As such, I don't think it is be safe to ignore busy extent state
> > just because we are filling the AGFL from the current free space
> > tree.
> >
> > Cheers,
> >
> > Dave.
> 
> -- 
> chandan
> 

-- 
Dave Chinner
david@fromorbit.com

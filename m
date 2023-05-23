Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F02C7EE2A
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 00:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235197AbjEWAsG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 May 2023 20:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235200AbjEWArt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 May 2023 20:47:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1751FCE
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2023 17:31:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BC9362CE2
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 00:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF1AC433D2;
        Tue, 23 May 2023 00:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684801906;
        bh=p1AG3F/27ePjwBC+Yix6G+W7ho53RH+n7MQQGeNuKWM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TgkT0H4G2C04WztOQRPMUA3dCSKJu3Xw7h3xZV7qVbdXawsb05ucRVdWpHhB2vYN+
         IdYNK/K0r8kWWjFpYbBvRVXNxGfmwxOkf8IfHsDT1TXO3m4Xa57CBF8AXCvTK/E0sj
         XwrNqnaaA1P/hAM552s5Jd6Lo04w1Rus2LQ6TOUQzvBiQxXo9YG6W8oWBqLX0cH1nN
         ISRao3mHcJrmDEX3vTi1e9nqEWCIEti5OYaxU182MOKwLwBn7ecZvsYRDngcr/1ug8
         5f1gF8IQKx1Jmjwiim0ukavyT6oXP+bm10hNCKgzOxNbF6gr36LRQtKn2AkFb6xKwk
         F4lFObZjqfI9g==
Date:   Mon, 22 May 2023 17:31:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "david@fromorbit.com" <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Don't block in xfs_extent_busy_flush
Message-ID: <20230523003146.GC11620@frogsfrogsfrogs>
References: <20230519171829.4108-1-wen.gang.wang@oracle.com>
 <20230520215604.GA11620@frogsfrogsfrogs>
 <FBB71644-F783-46FB-BA7C-94BAA6432656@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <FBB71644-F783-46FB-BA7C-94BAA6432656@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 22, 2023 at 05:25:01PM +0000, Wengang Wang wrote:
> 
> 
> > On May 20, 2023, at 2:56 PM, Darrick J. Wong <djwong@kernel.org> wrote:
> > 
> > On Fri, May 19, 2023 at 10:18:29AM -0700, Wengang Wang wrote:
> >> The following calltrace is seen:
> >> #0 context_switch() kernel/sched/core.c:3881
> >> #1 __schedule() kernel/sched/core.c:5111
> >> #2 schedule() kernel/sched/core.c:5186
> >> #3 xfs_extent_busy_flush() fs/xfs/xfs_extent_busy.c:598
> >> #4 xfs_alloc_ag_vextent_size() fs/xfs/libxfs/xfs_alloc.c:1641
> >> #5 xfs_alloc_ag_vextent() fs/xfs/libxfs/xfs_alloc.c:828
> >> #6 xfs_alloc_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:2362
> >> #7 xfs_free_extent_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:3029
> >> #8 __xfs_free_extent() fs/xfs/libxfs/xfs_alloc.c:3067
> >> #9 xfs_trans_free_extent() fs/xfs/xfs_extfree_item.c:370
> >> #10 xfs_efi_recover() fs/xfs/xfs_extfree_item.c:626
> >> #11 xlog_recover_process_efi() fs/xfs/xfs_log_recover.c:4605
> >> #12 xlog_recover_process_intents() fs/xfs/xfs_log_recover.c:4893
> >> #13 xlog_recover_finish() fs/xfs/xfs_log_recover.c:5824
> >> #14 xfs_log_mount_finish() fs/xfs/xfs_log.c:764
> >> #15 xfs_mountfs() fs/xfs/xfs_mount.c:978
> >> #16 xfs_fs_fill_super() fs/xfs/xfs_super.c:1908
> >> #17 mount_bdev() fs/super.c:1417
> >> #18 xfs_fs_mount() fs/xfs/xfs_super.c:1985
> >> #19 legacy_get_tree() fs/fs_context.c:647
> >> #20 vfs_get_tree() fs/super.c:1547
> >> #21 do_new_mount() fs/namespace.c:2843
> >> #22 do_mount() fs/namespace.c:3163
> >> #23 ksys_mount() fs/namespace.c:3372
> >> #24 __do_sys_mount() fs/namespace.c:3386
> >> #25 __se_sys_mount() fs/namespace.c:3383
> >> #26 __x64_sys_mount() fs/namespace.c:3383
> >> #27 do_syscall_64() arch/x86/entry/common.c:296
> >> #28 entry_SYSCALL_64() arch/x86/entry/entry_64.S:180
> >> 
> >> During the process of the 2nd and subsequetial record in an EFI.
> >> It is waiting for the busy blocks to be cleaned, but the only busy extent
> >> is still hold in current xfs_trans->t_busy. That busy extent was added when
> >> processing previous EFI record. And because that busy extent is not committed
> >> yet, it can't be cleaned.
> >> 
> >> To avoid above deadlock, we don't block in xfs_extent_busy_flush() when
> >> allocating AGFL blocks, instead it returns -EAGAIN. On receiving -EAGAIN
> >> we are able to retry that EFI record with a new transaction after committing
> >> the old transactin. With old transaction committed, the busy extent attached
> >> to the old transaction get the change to be cleaned. On the retry, there is
> >> no existing busy extents in the new transaction, thus no deadlock.
> >> 
> >> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> >> ---
> >> fs/xfs/libxfs/xfs_alloc.c | 30 ++++++++++++++++++++++++------
> >> fs/xfs/libxfs/xfs_alloc.h |  2 ++
> >> fs/xfs/scrub/repair.c     |  4 ++--
> >> fs/xfs/xfs_extent_busy.c  | 34 +++++++++++++++++++++++++++++-----
> >> fs/xfs/xfs_extent_busy.h  |  6 +++---
> >> fs/xfs/xfs_extfree_item.c | 37 ++++++++++++++++++++++++++++++++++++-
> >> fs/xfs/xfs_log_recover.c  | 23 ++++++++++-------------
> >> fs/xfs/xfs_trans_ail.c    |  2 +-
> >> fs/xfs/xfs_trans_priv.h   |  1 +
> >> 9 files changed, 108 insertions(+), 31 deletions(-)
> >> 
> >> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> >> index 203f16c48c19..abfd2acb3053 100644
> >> --- a/fs/xfs/libxfs/xfs_alloc.c
> >> +++ b/fs/xfs/libxfs/xfs_alloc.c
> >> @@ -1491,6 +1491,7 @@ STATIC int
> >> xfs_alloc_ag_vextent_near(
> >> struct xfs_alloc_arg *args)
> >> {
> >> + int flags = args->flags | XFS_ALLOC_FLAG_TRYFLUSH;
> >> struct xfs_alloc_cur acur = {};
> >> int error; /* error code */
> >> int i; /* result code, temporary */
> >> @@ -1564,8 +1565,11 @@ xfs_alloc_ag_vextent_near(
> >> if (!acur.len) {
> >> if (acur.busy) {
> >> trace_xfs_alloc_near_busy(args);
> >> - xfs_extent_busy_flush(args->mp, args->pag,
> >> -       acur.busy_gen);
> >> + error = xfs_extent_busy_flush(args->tp, args->pag,
> >> +       acur.busy_gen, flags);
> >> + if (error)
> >> + goto out;
> >> + flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
> >> goto restart;
> >> }
> >> trace_xfs_alloc_size_neither(args);
> >> @@ -1592,6 +1596,7 @@ STATIC int /* error */
> >> xfs_alloc_ag_vextent_size(
> >> xfs_alloc_arg_t *args) /* allocation argument structure */
> >> {
> >> + int flags = args->flags | XFS_ALLOC_FLAG_TRYFLUSH;
> > 
> > This variable holds XFS_ALLOC_FLAG_* values that are passed only to
> > xfs_extent_busy_flush, right?  Could this be named "busyflags" or
> > similar to make that clearer?
> > 
> > (Clearer to 6hr^W6mo from now Darrick who won't remember this at all.)
> 
> Yes, the ‘flags’ in only passed to xfs_extent_busy_flush(). will be ‘busyflags'
> in next drop.

Ok.

> > 
> >> struct xfs_agf *agf = args->agbp->b_addr;
> >> struct xfs_btree_cur *bno_cur; /* cursor for bno btree */
> >> struct xfs_btree_cur *cnt_cur; /* cursor for cnt btree */
> >> @@ -1670,8 +1675,13 @@ xfs_alloc_ag_vextent_size(
> >> xfs_btree_del_cursor(cnt_cur,
> >>      XFS_BTREE_NOERROR);
> >> trace_xfs_alloc_size_busy(args);
> >> - xfs_extent_busy_flush(args->mp,
> >> - args->pag, busy_gen);
> >> + error = xfs_extent_busy_flush(args->tp, args->pag,
> >> + busy_gen, flags);
> >> + if (error) {
> >> + cnt_cur = NULL;
> >> + goto error0;
> >> + }
> >> + flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
> >> goto restart;
> >> }
> >> }
> >> @@ -1755,7 +1765,13 @@ xfs_alloc_ag_vextent_size(
> >> if (busy) {
> >> xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> >> trace_xfs_alloc_size_busy(args);
> >> - xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
> >> + error = xfs_extent_busy_flush(args->tp, args->pag,
> >> + busy_gen, flags);
> >> + if (error) {
> >> + cnt_cur = NULL;
> >> + goto error0;
> >> + }
> >> + flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
> >> goto restart;
> >> }
> >> goto out_nominleft;
> >> @@ -2629,6 +2645,7 @@ xfs_alloc_fix_freelist(
> >> targs.agno = args->agno;
> >> targs.alignment = targs.minlen = targs.prod = 1;
> >> targs.pag = pag;
> >> + targs.flags = args->flags & XFS_ALLOC_FLAG_FREEING;
> > 
> > Hmm, I guess this propagates FREEING into the allocation that lengthens
> > the AGFL.  Right?
> 
> Yes, the original call path is like this:
> xfs_free_extent_fix_freelist()
>   xfs_alloc_fix_freelist(args, XFS_ALLOC_FLAG_FREEING as flags)  
>     xfs_alloc_ag_vextent_size(targs)
>       xfs_extent_busy_flush(tp, pag, busy_gen, flags)
> 
> We don’t have a ‘flags’ parameter to xfs_alloc_ag_vextent_size().
> Considering the args its self is used for allocation, the ‘flags’ is also for the same
> purpose. I moved the ‘flags’ into args (struct xfs_alloc_arg) and thus 
> xfs_alloc_fix_freelist() doesn’t need the ‘flags’ parameter any longer since
> the 'flags' is in in ‘args’. In my draft code (not posted to this email list), I
> removed the ‘flags’ paramter from xfs_alloc_fix_freelist(). While when I was
> reviewing the code change, I found that the ‘flags’ is well used in that function,
> accessing 'args->flags' instead of ‘flags’ may caused some extra CPU cycles.
> So in the patch (for review) I kept the ‘flags’ parameter which cause the code
> ugly :D

I prefer either passing @flags around as a function parameter like we
always have; or stuffing it in xfs_alloc_arg.  Not both, that makes it
much harder to understand.

> > 
> >> error = xfs_alloc_read_agfl(pag, tp, &agflbp);
> >> if (error)
> >> goto out_agbp_relse;
> >> @@ -3572,6 +3589,7 @@ xfs_free_extent_fix_freelist(
> >> args.mp = tp->t_mountp;
> >> args.agno = pag->pag_agno;
> >> args.pag = pag;
> >> + args.flags = XFS_ALLOC_FLAG_FREEING;
> >> 
> >> /*
> >>  * validate that the block number is legal - the enables us to detect
> >> @@ -3580,7 +3598,7 @@ xfs_free_extent_fix_freelist(
> >> if (args.agno >= args.mp->m_sb.sb_agcount)
> >> return -EFSCORRUPTED;
> >> 
> >> - error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING);
> >> + error = xfs_alloc_fix_freelist(&args, args.flags);
> > 
> > Hm.  Why stuff XFS_ALLOC_FLAG_FREEING into args.flags here?  I /think/
> > in this case it doesn't matter because nothing under
> > xfs_alloc_fix_freelist accesses args->flags...?
> > 
> > AFAICT in xfs_alloc_fix_freelist, the difference between @args->flags
> > and @flags is that @args is the allocation that we're trying to do,
> > whereas @flags are for any allocation that might need to be done to fix
> > the freelist.  IOWS, the only allocation we're doing *is* to fix the
> > freelist, so they are one in the same.  Maybe?  Otherwise I can't tell
> > why we'd convey two sets of XFS_ALLOC flags to xfs_alloc_fix_freelist.
> > 
> > So while I think this isn't incorrect, the flag mixing bothers me a bit
> > because setting fields in a struct can have weird not so obvious side
> > effects.
> > 
> > (Still trying to make sense of the addition of a @flags field to struct
> > xfs_alloc_arg.)
> 
> Right, see my above explain.
> 
> > 
> >> if (error)
> >> return error;
> >> 
> >> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> >> index 2b246d74c189..5038fba87784 100644
> >> --- a/fs/xfs/libxfs/xfs_alloc.h
> >> +++ b/fs/xfs/libxfs/xfs_alloc.h
> >> @@ -24,6 +24,7 @@ unsigned int xfs_agfl_size(struct xfs_mount *mp);
> >> #define XFS_ALLOC_FLAG_NORMAP 0x00000004  /* don't modify the rmapbt */
> >> #define XFS_ALLOC_FLAG_NOSHRINK 0x00000008  /* don't shrink the freelist */
> >> #define XFS_ALLOC_FLAG_CHECK 0x00000010  /* test only, don't modify args */
> >> +#define XFS_ALLOC_FLAG_TRYFLUSH 0x00000020  /* don't block in busyextent flush*/
> >> 
> >> /*
> >>  * Argument structure for xfs_alloc routines.
> >> @@ -57,6 +58,7 @@ typedef struct xfs_alloc_arg {
> >> #ifdef DEBUG
> >> bool alloc_minlen_only; /* allocate exact minlen extent */
> >> #endif
> >> + int flags; /* XFS_ALLOC_FLAG_* */
> >> } xfs_alloc_arg_t;
> >> 
> >> /*
> >> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> >> index 1b71174ec0d6..2ba28e4257fe 100644
> >> --- a/fs/xfs/scrub/repair.c
> >> +++ b/fs/xfs/scrub/repair.c
> >> @@ -496,9 +496,9 @@ xrep_fix_freelist(
> >> args.agno = sc->sa.pag->pag_agno;
> >> args.alignment = 1;
> >> args.pag = sc->sa.pag;
> >> + args.flags = can_shrink ? 0 : XFS_ALLOC_FLAG_NOSHRINK;
> >> 
> >> - return xfs_alloc_fix_freelist(&args,
> >> - can_shrink ? 0 : XFS_ALLOC_FLAG_NOSHRINK);
> >> + return xfs_alloc_fix_freelist(&args, args.flags);
> >> }
> >> 
> >> /*
> >> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> >> index f3d328e4a440..ea1c1857bf5b 100644
> >> --- a/fs/xfs/xfs_extent_busy.c
> >> +++ b/fs/xfs/xfs_extent_busy.c
> >> @@ -567,18 +567,41 @@ xfs_extent_busy_clear(
> >> /*
> >>  * Flush out all busy extents for this AG.
> >>  */
> >> -void
> >> +int
> >> xfs_extent_busy_flush(
> >> - struct xfs_mount *mp,
> >> + struct xfs_trans *tp,
> >> struct xfs_perag *pag,
> >> - unsigned busy_gen)
> >> + unsigned busy_gen,
> >> + int flags)
> >> {
> >> DEFINE_WAIT (wait);
> >> int error;
> >> 
> >> - error = xfs_log_force(mp, XFS_LOG_SYNC);
> >> + error = xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
> >> if (error)
> >> - return;
> >> + return error;
> >> +
> >> + /*
> >> +  * If we are holding busy extents, the caller may not want to block
> >> +  * straight away. If we are being told just to try a flush or progress
> >> +  * has been made since we last skipped a busy extent, return
> >> +  * immediately to allow the caller to try again. If we are freeing
> >> +  * extents, we might actually be holding the only free extents in the
> >> +  * transaction busy list and the log force won't resolve that
> >> +  * situation. In this case, return -EAGAIN in that case to tell the
> >> +  * caller it needs to commit the busy extents it holds before retrying
> >> +  * the extent free operation.
> >> +  */
> >> + if (!list_empty(&tp->t_busy)) {
> >> + if (flags & XFS_ALLOC_FLAG_TRYFLUSH)
> >> + return 0;
> >> +
> >> + if (busy_gen != READ_ONCE(pag->pagb_gen))
> >> + return 0;
> >> +
> >> + if (flags & XFS_ALLOC_FLAG_FREEING)
> >> + return -EAGAIN;
> >> + }
> >> 
> >> do {
> >> prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
> >> @@ -588,6 +611,7 @@ xfs_extent_busy_flush(
> >> } while (1);
> >> 
> >> finish_wait(&pag->pagb_wait, &wait);
> >> + return 0;
> > 
> > This part looks good.
> > 
> >> }
> >> 
> >> void
> >> diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
> >> index 4a118131059f..edeedb92e0df 100644
> >> --- a/fs/xfs/xfs_extent_busy.h
> >> +++ b/fs/xfs/xfs_extent_busy.h
> >> @@ -51,9 +51,9 @@ bool
> >> xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t *bno,
> >> xfs_extlen_t *len, unsigned *busy_gen);
> >> 
> >> -void
> >> -xfs_extent_busy_flush(struct xfs_mount *mp, struct xfs_perag *pag,
> >> - unsigned busy_gen);
> >> +int
> >> +xfs_extent_busy_flush(struct xfs_trans *tp, struct xfs_perag *pag,
> >> + unsigned busy_gen, int flags);
> >> 
> >> void
> >> xfs_extent_busy_wait_all(struct xfs_mount *mp);
> >> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> >> index 011b50469301..3c5a9e9952ec 100644
> >> --- a/fs/xfs/xfs_extfree_item.c
> >> +++ b/fs/xfs/xfs_extfree_item.c
> >> @@ -336,6 +336,25 @@ xfs_trans_get_efd(
> >> return efdp;
> >> }
> >> 
> >> +/*
> >> + * Fill the EFD with all extents from the EFI and set the counter.
> >> + * Note: the EFD should comtain at least one extents already.
> >> + */
> >> +static void xfs_fill_efd_with_efi(struct xfs_efd_log_item *efdp)
> >> +{
> >> + struct xfs_efi_log_item *efip = efdp->efd_efip;
> >> + uint                    i;
> >> +
> >> + if (efdp->efd_next_extent == efip->efi_format.efi_nextents)
> >> + return;
> >> +
> >> + for (i = 0; i < efip->efi_format.efi_nextents; i++) {
> >> +        efdp->efd_format.efd_extents[i] =
> >> +        efip->efi_format.efi_extents[i];
> >> + }
> >> + efdp->efd_next_extent = efip->efi_format.efi_nextents;
> >> +}
> >> +
> >> /*
> >>  * Free an extent and log it to the EFD. Note that the transaction is marked
> >>  * dirty regardless of whether the extent free succeeds or fails to support the
> >> @@ -369,6 +388,10 @@ xfs_trans_free_extent(
> >> error = __xfs_free_extent(tp, xefi->xefi_startblock,
> >> xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
> >> xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
> >> + if (error == -EAGAIN) {
> >> + xfs_fill_efd_with_efi(efdp);
> >> + return error;
> >> + }
> >> /*
> >>  * Mark the transaction dirty, even on error. This ensures the
> >>  * transaction is aborted, which:
> >> @@ -476,7 +499,8 @@ xfs_extent_free_finish_item(
> >> xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
> >> 
> >> error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
> >> - kmem_cache_free(xfs_extfree_item_cache, xefi);
> >> + if (error != -EAGAIN)
> >> + kmem_cache_free(xfs_extfree_item_cache, xefi);
> >> return error;
> >> }
> >> 
> >> @@ -633,6 +657,17 @@ xfs_efi_item_recover(
> >> fake.xefi_blockcount = extp->ext_len;
> >> 
> >> error = xfs_trans_free_extent(tp, efdp, &fake);
> >> + if (error == -EAGAIN) {
> > 
> > Curious, is this patch based off of 6.4-rc?  There should be a
> > xfs_extent_free_get_group / xfs_extent_free_put_group here.
> 
> It’s still 6.3.0-rc6 — the newest when started to work on the deadlock issue.
> Will rebase to current version for next drop.

Ok.

> > 
> >> + xfs_free_extent_later(tp, fake.xefi_startblock,
> >> + fake.xefi_blockcount, &XFS_RMAP_OINFO_ANY_OWNER);
> >> + /*
> >> +  * try to free as many extents as possible with current
> >> +  * transaction
> >> +  */
> >> + error = 0;
> >> + continue;
> >> + };
> > 
> > If we get EAGAIN, why not let the unfinished parts of the recovered EFI
> > work get turned into a new EFI?
> 
> That is an optimization. I wanted finish more records with current transaction
> when possible. Say for this case (we hit the first EAGAIN on (AG1, bno2, len2):
> EFI {(AG1, bno1, len1), (AG1, bno2, len2), (AG2, bno3, len3), (AG2, bno4, len4)}
> with current patch, we need 1 extra EFI, so
> orig EFI {(AG1, bno1, len1), (AG2, bno3, len3)} # records shown are really done ones  
> new EFI1 {(AG1, bno2, len2), (AG2, bno4, len4)}
> 
> Otherwise if we move all the records (from current one) to new EFI on the
> first EAGAIN, we would need
> orig EFI {(AG1, bno1, len1)}
> new EFI1 {(AG1, bno2, len2), (AG2, bno3, len3)} 
> new EFI3 {(AG2, bno4, len4)}
> 
> In above case, we saved one EFI with the optimization.

The trouble here is that now we're performing updates during log
recovery in a different order than they would have been done by the
regular fs code.  I /think/ for EFIs this doesn't matter (it definitely
matters for the other intent items!) but we (maintainers) prefer not to
have to think about two different orderings.

> > 
> >> +
> >> if (error == -EFSCORRUPTED)
> >> XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> >> extp, sizeof(*extp));
> >> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> >> index 322eb2ee6c55..00bfe9683fa8 100644
> >> --- a/fs/xfs/xfs_log_recover.c
> >> +++ b/fs/xfs/xfs_log_recover.c
> >> @@ -2540,30 +2540,27 @@ xlog_recover_process_intents(
> >> struct xfs_log_item *lip;
> >> struct xfs_ail *ailp;
> >> int error = 0;
> >> -#if defined(DEBUG) || defined(XFS_WARN)
> >> - xfs_lsn_t last_lsn;
> >> -#endif
> >> + xfs_lsn_t threshold_lsn;
> >> 
> >> ailp = log->l_ailp;
> >> + threshold_lsn = xfs_ail_max_lsn(ailp);
> >> spin_lock(&ailp->ail_lock);
> >> -#if defined(DEBUG) || defined(XFS_WARN)
> >> - last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
> >> -#endif
> >> +
> >> for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> >>      lip != NULL;
> >>      lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
> >> const struct xfs_item_ops *ops;
> >> + /*
> >> +  * Orignal redo EFI could be splitted into new EFIs. Those
> >> +  * new EFIs are supposed to be processed in capture_list.
> >> +  * Stop here when original redo intents are done.
> >> +  */
> >> + if (XFS_LSN_CMP(threshold_lsn, lip->li_lsn) < 0)
> >> + break;
> > 
> > I'm not sure what this change accomplishes?  Is it because of the
> > continue; statement in xfs_efi_item_recover?
> 
> The function xlog_recover_process_intents() iterates all the intent
> items in AIL and process them. According the the comments:
> 
> 2519  * When this is called, all of the log intent items which did not have
> 2520  * corresponding log done items should be in the AIL.  What we do now is update
> 2521  * the data structures associated with each one.
> 
> I am thinking xlog_recover_process_intents should iterates only the ones
> which are already on the AIL. If we don’t make a threshold here,  it will continue
> to process new intents added when we are processing existing intents. In this
> case, we add new EFIs and that runs fast to be added to AIL in callbacks before
> we finish the iterations here. And then the new EFIs are captured by
> xlog_recover_process_intents(). If xlog_recover_process_intents() continue to
> process these new EFIs, it will double free extents in EFI with xlog_finish_defer_ops()
> thus cause problem.

Each ->iop_recover function is supposed to do at least one unit of work,
which should generate new non-intent log items.  These new items are
attached to the end of the AIL's list before any new intent items
created to handle an EAGAIN return.  Hence the list order ought to be:

<recovered EFI> -> <buffer log items for bnobt updates> ->
<new EFI to continue because busy flush didn't move busy gen>

Are you seeing an order other than this?

--D

> thanks,
> wengang
> 
> 

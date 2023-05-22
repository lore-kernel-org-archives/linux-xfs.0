Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B817C77B73
	for <linux-xfs@archiver.kernel.org>; Mon, 22 May 2023 01:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjEVBRe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 21 May 2023 21:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjEVBRc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 May 2023 21:17:32 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63118CD
        for <linux-xfs@vger.kernel.org>; Sun, 21 May 2023 18:17:30 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-52867360efcso3744746a12.2
        for <linux-xfs@vger.kernel.org>; Sun, 21 May 2023 18:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684718250; x=1687310250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XLzhDCC1waPf6cZbm2z4t01UOoWnQlHsqq2t8aXCpHk=;
        b=5UmUuY/cy+t1LbNkLMH4XN40WSwkfROmF4XhrqzhqrhFHyCWe8W7V9aIP9boJBiLRU
         dQKWDKah6Jpp2c5Jnt5wt/gh4Dxct0Olw5JL6nbglAjGvfmKHXqqebifeFDIjMu8b6AP
         iiQRvRd90K69J1/hLDhdCEnibkFmC3CCBYzyOXI8qIg2TIlcLvdoW/phnPz2RmrE2mD8
         vcQ+IU3CWawNzzxSSs9uEFvSKBJDQkSsnNsTsz5R/bi2ic/k8E3/Z7As+sUpGVJhvjOL
         uNnUkfqWZApG9HZLVJKogJHXdRLoun8lHhCajkvhhC++Fic2SXFTkuwbrYvcFqIpgn/+
         yFuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684718250; x=1687310250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XLzhDCC1waPf6cZbm2z4t01UOoWnQlHsqq2t8aXCpHk=;
        b=MB9yHq6Lgcm99tILoJaikUQJdS/FdTsA2jmGkMGL3OSV/+OCOKiH3tZYkP4bpUet1Q
         XuHl83o2OYpg3uqUSDK9vRmLLzOtFyPZACbzLBalDD1pt83SQwU+L16Z2eMuS3ilKouq
         xs3K5rcV+/kS9qJQk0O6OomrIkNBtz4wVyWm61Ce4cQMINA2k/gU3vfaOpwdCyxJOwuv
         9C3dZyNjKG3G5UBBBeVU4SSa4Mj+tVijpj9Vt0xJO3WcodF2A/74qBPNy3FhQG/Rozqy
         0xXZrE2yWS4e0jr+hrvRMtUADcyj1HqM6bgegwUlItWcqpVI6CregSWfEZweYrcM6rx/
         20nQ==
X-Gm-Message-State: AC+VfDyADKpObvUfD9jdCaEDS6PQ7SCt+O6Nm8CMqV0jDWDIl5G2MgC3
        3FQYfjNCDYSAHOuuuuNjPjN5T2dZdulRrx53irY=
X-Google-Smtp-Source: ACHHUZ4hbKRKFBTSMr4NZjnsbS4oV4ObFT8tzdWZBffmpESzPX93JI931H1wpFzuqjjIxDL+5shatA==
X-Received: by 2002:a05:6a20:9f4b:b0:ff:8d85:9f24 with SMTP id ml11-20020a056a209f4b00b000ff8d859f24mr8031697pzb.50.1684718249633;
        Sun, 21 May 2023 18:17:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id s3-20020a62e703000000b00639fc7124c2sm3087826pfh.148.2023.05.21.18.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 May 2023 18:17:29 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q0uAv-002Lac-1K;
        Mon, 22 May 2023 11:17:25 +1000
Date:   Mon, 22 May 2023 11:17:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH] xfs: Don't block in xfs_extent_busy_flush
Message-ID: <ZGrCpXoEk9achabI@dread.disaster.area>
References: <20230519171829.4108-1-wen.gang.wang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519171829.4108-1-wen.gang.wang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 19, 2023 at 10:18:29AM -0700, Wengang Wang wrote:
> The following calltrace is seen:
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
> During the process of the 2nd and subsequetial record in an EFI.
> It is waiting for the busy blocks to be cleaned, but the only busy extent
> is still hold in current xfs_trans->t_busy. That busy extent was added when
> processing previous EFI record. And because that busy extent is not committed
> yet, it can't be cleaned.
> 
> To avoid above deadlock, we don't block in xfs_extent_busy_flush() when
> allocating AGFL blocks, instead it returns -EAGAIN. On receiving -EAGAIN
> we are able to retry that EFI record with a new transaction after committing
> the old transactin. With old transaction committed, the busy extent attached
> to the old transaction get the change to be cleaned. On the retry, there is
> no existing busy extents in the new transaction, thus no deadlock.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

THere are multiple changes in this patchset that aren't immediately
obvious why they have been done. hence this needs to be split into
one set of changes per patch.

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 30 ++++++++++++++++++++++++------
>  fs/xfs/libxfs/xfs_alloc.h |  2 ++
>  fs/xfs/scrub/repair.c     |  4 ++--
>  fs/xfs/xfs_extent_busy.c  | 34 +++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_extent_busy.h  |  6 +++---
>  fs/xfs/xfs_extfree_item.c | 37 ++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_log_recover.c  | 23 ++++++++++-------------
>  fs/xfs/xfs_trans_ail.c    |  2 +-
>  fs/xfs/xfs_trans_priv.h   |  1 +
>  9 files changed, 108 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 203f16c48c19..abfd2acb3053 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1491,6 +1491,7 @@ STATIC int
>  xfs_alloc_ag_vextent_near(
>  	struct xfs_alloc_arg	*args)
>  {
> +	int			flags = args->flags | XFS_ALLOC_FLAG_TRYFLUSH;

The first set of changes is encoding allocation flags into the
struct xfs_alloc_arg. I can sort of see why you did this, but it's
done in an inconsistent manner, and I don't see why some of the
changes were made and not others. This conversion belongs in it's
own patch.

>  	struct xfs_alloc_cur	acur = {};
>  	int			error;		/* error code */
>  	int			i;		/* result code, temporary */
> @@ -1564,8 +1565,11 @@ xfs_alloc_ag_vextent_near(
>  	if (!acur.len) {
>  		if (acur.busy) {
>  			trace_xfs_alloc_near_busy(args);
> -			xfs_extent_busy_flush(args->mp, args->pag,
> -					      acur.busy_gen);
> +			error = xfs_extent_busy_flush(args->tp, args->pag,
> +					      acur.busy_gen, flags);
> +			if (error)
> +				goto out;
> +			flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
>  			goto restart;
>  		}
>  		trace_xfs_alloc_size_neither(args);
> @@ -1592,6 +1596,7 @@ STATIC int				/* error */
>  xfs_alloc_ag_vextent_size(
>  	xfs_alloc_arg_t	*args)		/* allocation argument structure */
>  {
> +	int		flags = args->flags | XFS_ALLOC_FLAG_TRYFLUSH;
>  	struct xfs_agf	*agf = args->agbp->b_addr;
>  	struct xfs_btree_cur *bno_cur;	/* cursor for bno btree */
>  	struct xfs_btree_cur *cnt_cur;	/* cursor for cnt btree */
> @@ -1670,8 +1675,13 @@ xfs_alloc_ag_vextent_size(
>  				xfs_btree_del_cursor(cnt_cur,
>  						     XFS_BTREE_NOERROR);
>  				trace_xfs_alloc_size_busy(args);
> -				xfs_extent_busy_flush(args->mp,
> -							args->pag, busy_gen);
> +				error = xfs_extent_busy_flush(args->tp, args->pag,
> +						busy_gen, flags);
> +				if (error) {
> +					cnt_cur = NULL;
> +					goto error0;
> +				}
> +				flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
>  				goto restart;
>  			}
>  		}

The cursor handling for the error case could be improved here by
moving the xfs_btree_del_cursor(cnt_cur...) call here.

			if (i == 0) {
				/* ... */
				trace_xfs_alloc_size_busy(args);
				error = xfs_extent_busy_flush(args->tp, args->pag,
						busy_gen, flags);
				if (error)
					goto error0;

				xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
				flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
				goto restart;
			}

> @@ -1755,7 +1765,13 @@ xfs_alloc_ag_vextent_size(
>  		if (busy) {
>  			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
>  			trace_xfs_alloc_size_busy(args);
> -			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
> +			error = xfs_extent_busy_flush(args->tp, args->pag,
> +					busy_gen, flags);
> +			if (error) {
> +				cnt_cur = NULL;
> +				goto error0;
> +			}
> +			flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
>  			goto restart;
>  		}
>  		goto out_nominleft;

Same here.

I'd also enhance the trace_xfs_alloc_size_error() call to
trace the error that occurred so we can actually see when an EAGAIN
error occurs when we are tracing...


> @@ -2629,6 +2645,7 @@ xfs_alloc_fix_freelist(
>  	targs.agno = args->agno;
>  	targs.alignment = targs.minlen = targs.prod = 1;
>  	targs.pag = pag;
> +	targs.flags = args->flags & XFS_ALLOC_FLAG_FREEING;
>  	error = xfs_alloc_read_agfl(pag, tp, &agflbp);
>  	if (error)
>  		goto out_agbp_relse;

This is a change in behaviour for AGFL filling. This should be in
it's own patch, explaining why the change of behaviour is necessary.

Also, it could just be:

	targs.flags = flags & XFS_ALLOC_FLAG_FREEING;

> @@ -3572,6 +3589,7 @@ xfs_free_extent_fix_freelist(
>  	args.mp = tp->t_mountp;
>  	args.agno = pag->pag_agno;
>  	args.pag = pag;
> +	args.flags = XFS_ALLOC_FLAG_FREEING;
>  
>  	/*
>  	 * validate that the block number is legal - the enables us to detect
> @@ -3580,7 +3598,7 @@ xfs_free_extent_fix_freelist(
>  	if (args.agno >= args.mp->m_sb.sb_agcount)
>  		return -EFSCORRUPTED;
>  
> -	error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING);
> +	error = xfs_alloc_fix_freelist(&args, args.flags);
>  	if (error)
>  		return error;

This is where I see inconsistency in the usage of args.flags. If we
are going to move the XFS_ALLOC_FLAG_* state into args->flags, then
it should not be passed as a separate parameter to functions that
take a struct xfs_alloc_arg. i.e. we either use args->flags
everywhere for everything, or we pass a separate flags argument
everywhere as we currently do.


> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 2b246d74c189..5038fba87784 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -24,6 +24,7 @@ unsigned int xfs_agfl_size(struct xfs_mount *mp);
>  #define	XFS_ALLOC_FLAG_NORMAP	0x00000004  /* don't modify the rmapbt */
>  #define	XFS_ALLOC_FLAG_NOSHRINK	0x00000008  /* don't shrink the freelist */
>  #define	XFS_ALLOC_FLAG_CHECK	0x00000010  /* test only, don't modify args */
> +#define	XFS_ALLOC_FLAG_TRYFLUSH	0x00000020  /* don't block in busyextent flush*/

Convert all these to (1U << x) format while you are adding a new
flag...

>  
>  /*
>   * Argument structure for xfs_alloc routines.
> @@ -57,6 +58,7 @@ typedef struct xfs_alloc_arg {
>  #ifdef DEBUG
>  	bool		alloc_minlen_only; /* allocate exact minlen extent */
>  #endif
> +	int		flags;		/* XFS_ALLOC_FLAG_* */

And flags fields should be unsigned.

>  } xfs_alloc_arg_t;
>  
>  /*
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 1b71174ec0d6..2ba28e4257fe 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -496,9 +496,9 @@ xrep_fix_freelist(
>  	args.agno = sc->sa.pag->pag_agno;
>  	args.alignment = 1;
>  	args.pag = sc->sa.pag;
> +	args.flags = can_shrink ? 0 : XFS_ALLOC_FLAG_NOSHRINK;
>  
> -	return xfs_alloc_fix_freelist(&args,
> -			can_shrink ? 0 : XFS_ALLOC_FLAG_NOSHRINK);
> +	return xfs_alloc_fix_freelist(&args, args.flags);

Same comment as above about just passing separate flags everywhere
or just passing args. This conversion is a separate patch...

> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index f3d328e4a440..ea1c1857bf5b 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -567,18 +567,41 @@ xfs_extent_busy_clear(
>  /*
>   * Flush out all busy extents for this AG.
>   */
> -void
> +int
>  xfs_extent_busy_flush(
> -	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
>  	struct xfs_perag	*pag,
> -	unsigned		busy_gen)
> +	unsigned		busy_gen,
> +	int			flags)
>  {
>  	DEFINE_WAIT		(wait);
>  	int			error;
>  
> -	error = xfs_log_force(mp, XFS_LOG_SYNC);
> +	error = xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
>  	if (error)
> -		return;
> +		return error;
> +
> +	/*
> +	 * If we are holding busy extents, the caller may not want to block
> +	 * straight away. If we are being told just to try a flush or progress
> +	 * has been made since we last skipped a busy extent, return
> +	 * immediately to allow the caller to try again. If we are freeing
> +	 * extents, we might actually be holding the only free extents in the
> +	 * transaction busy list and the log force won't resolve that
> +	 * situation. In this case, return -EAGAIN in that case to tell the
> +	 * caller it needs to commit the busy extents it holds before retrying
> +	 * the extent free operation.
> +	 */
> +	if (!list_empty(&tp->t_busy)) {
> +		if (flags & XFS_ALLOC_FLAG_TRYFLUSH)
> +			return 0;
> +
> +		if (busy_gen != READ_ONCE(pag->pagb_gen))
> +			return 0;
> +
> +		if (flags & XFS_ALLOC_FLAG_FREEING)
> +			return -EAGAIN;
> +	}
>  
>  	do {
>  		prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
> @@ -588,6 +611,7 @@ xfs_extent_busy_flush(
>  	} while (1);
>  
>  	finish_wait(&pag->pagb_wait, &wait);
> +	return 0;
>  }
>  
>  void
> diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
> index 4a118131059f..edeedb92e0df 100644
> --- a/fs/xfs/xfs_extent_busy.h
> +++ b/fs/xfs/xfs_extent_busy.h
> @@ -51,9 +51,9 @@ bool
>  xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t *bno,
>  		xfs_extlen_t *len, unsigned *busy_gen);
>  
> -void
> -xfs_extent_busy_flush(struct xfs_mount *mp, struct xfs_perag *pag,
> -	unsigned busy_gen);
> +int
> +xfs_extent_busy_flush(struct xfs_trans *tp, struct xfs_perag *pag,
> +	unsigned busy_gen, int flags);
>  
>  void
>  xfs_extent_busy_wait_all(struct xfs_mount *mp);
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 011b50469301..3c5a9e9952ec 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -336,6 +336,25 @@ xfs_trans_get_efd(
>  	return efdp;
>  }
>  
> +/*
> + * Fill the EFD with all extents from the EFI and set the counter.
> + * Note: the EFD should comtain at least one extents already.
> + */
> +static void xfs_fill_efd_with_efi(struct xfs_efd_log_item *efdp)
> +{
> +	struct xfs_efi_log_item *efip = efdp->efd_efip;
> +	uint                    i;
> +
> +	if (efdp->efd_next_extent == efip->efi_format.efi_nextents)
> +		return;
> +
> +	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
> +	       efdp->efd_format.efd_extents[i] =
> +		       efip->efi_format.efi_extents[i];
> +	}
> +	efdp->efd_next_extent = efip->efi_format.efi_nextents;
> +}
> +

Ok, but it doesn't dirty the transaction or the EFD, which means....

> @@ -369,6 +388,10 @@ xfs_trans_free_extent(
>  	error = __xfs_free_extent(tp, xefi->xefi_startblock,
>  			xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
>  			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
> +	if (error == -EAGAIN) {
> +		xfs_fill_efd_with_efi(efdp);
> +		return error;
> +	}

.... this is incorrectly placed.

The very next lines say:

>  	/*
>  	 * Mark the transaction dirty, even on error. This ensures the
>  	 * transaction is aborted, which:

i.e. we have to make the transaction and EFD log item dirty even if
we have an error. In this case, the error is not fatal, but we still
have to ensure that we commit the EFD when we roll the transaction.
Hence the transaction and EFD still need to be dirtied on -EAGAIN...

> @@ -476,7 +499,8 @@ xfs_extent_free_finish_item(
>  	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
>  
>  	error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
> -	kmem_cache_free(xfs_extfree_item_cache, xefi);
> +	if (error != -EAGAIN)
> +		kmem_cache_free(xfs_extfree_item_cache, xefi);
>  	return error;
>  }

Ok, that's a bit nasty. let's do that the same way as
xfs_refcount_update_finish_item():

	error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);

	/*
	 * Do we need to roll the transaction and retry to avoid a busy
	 * extent deadlock?
	 */
	if (error == -EAGAIN)
		return error;

	kmem_cache_free(xfs_extfree_item_cache, xefi);
	return error;

>  
> @@ -633,6 +657,17 @@ xfs_efi_item_recover(
>  		fake.xefi_blockcount = extp->ext_len;
>  
>  		error = xfs_trans_free_extent(tp, efdp, &fake);
> +		if (error == -EAGAIN) {
> +			xfs_free_extent_later(tp, fake.xefi_startblock,
> +				fake.xefi_blockcount, &XFS_RMAP_OINFO_ANY_OWNER);
> +			/*
> +			 * try to free as many extents as possible with current
> +			 * transaction
> +			 */
> +			error = 0;
> +			continue;
> +		};

This looks like it may be problematic - I'd prefer this code to be
obviously correct before we try to do any fancy optimisations to
minimise transaction counts. That is, once we get a -EAGAIN error,
we should defer the rest of the extents and roll the transaction
same as is done in xfs_cui_item_recover().

That is, when we get -EAGAIN, set a boolean "requeue_only" flag
and if that is set simply call xfs_free_extent_later() directly
until the EFI is exhausted.

> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 322eb2ee6c55..00bfe9683fa8 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2540,30 +2540,27 @@ xlog_recover_process_intents(
>  	struct xfs_log_item	*lip;
>  	struct xfs_ail		*ailp;
>  	int			error = 0;
> -#if defined(DEBUG) || defined(XFS_WARN)
> -	xfs_lsn_t		last_lsn;
> -#endif
> +	xfs_lsn_t		threshold_lsn;
>  
>  	ailp = log->l_ailp;
> +	threshold_lsn = xfs_ail_max_lsn(ailp);
>  	spin_lock(&ailp->ail_lock);
> -#if defined(DEBUG) || defined(XFS_WARN)
> -	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);

xfs_ail_max_lsn() and l_curr_cycle/l_curr_block are not the same
thing.  max_lsn points to the lsn of the last entry in the AIL (in
memory state), whilst curr_cycle/block points to the current
physical location of the log head in the on-disk journal.

In this case, we can't use in-memory state to determine where to
stop the initial intent replay - recovery of other items may have
inserted new intents beyond the end of the physical region being
recovered, in which case using xfs_ail_max_lsn() will result in
incorrect behaviour here.

> -#endif
> +
>  	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
>  	     lip != NULL;
>  	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
>  		const struct xfs_item_ops	*ops;
> +		/*
> +		 * Orignal redo EFI could be splitted into new EFIs. Those
> +		 * new EFIs are supposed to be processed in capture_list.
> +		 * Stop here when original redo intents are done.
> +		 */
> +		if (XFS_LSN_CMP(threshold_lsn, lip->li_lsn) < 0)
> +			break;
>  
>  		if (!xlog_item_is_intent(lip))
>  			break;
>  
> -		/*
> -		 * We should never see a redo item with a LSN higher than
> -		 * the last transaction we found in the log at the start
> -		 * of recovery.
> -		 */
> -		ASSERT(XFS_LSN_CMP(last_lsn, lip->li_lsn) >= 0);
> -
>  		/*
>  		 * NOTE: If your intent processing routine can create more
>  		 * deferred ops, you /must/ attach them to the capture list in

As it is, I don't understand why this change is necessary and it is
not explained anywhere. That is, new intents should go to the end of
the AIL past the LSN of any intent that has been read from the
region of the log we are recovering. The first intent that is
processed will place non-intent items (e.g. a buffer or inode) in
the CIL/AIL before any new intent item, so this check:

		if (!xlog_item_is_intent(lip))
			break;

should always trigger before we would start processing newly logged
(deferred) intents.

If this change is actually necessary, it needs to be in it's own
commit and explain what the problem is that it is fixing. IF there
is a bug here tha tneeds fixing, it's something we need to know
about because it will affect all previous kernels, too, not just
ones with this patch that can relog EFIs in recovery.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

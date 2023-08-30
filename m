Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 516A8C83F1A
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Aug 2023 01:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238444AbjH3BCa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 21:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236947AbjH3BCI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 21:02:08 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4255CCA
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 18:01:58 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-68bee12e842so3494026b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 18:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693357318; x=1693962118; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ATWj4Im28e+CMik8K692QDJLfQFAhvpejHZZFdLpWBA=;
        b=Ef50KcVZB+mj1U8U2f7ZVFn2K2QdVTsaexgDZ8gTl4tOvSHL9rMRoigoq2WCmoBCki
         X8DhdJzFdPWD6Flzd6eAj484Z1nAMnXGlPiDiK59BUZl0OQPe7FKmrjHf8QS+WcLY3n2
         Mi+Ph5J/yGbpUU1pNzou0FN/zDyYFLGmbGhJVHnelJdFA4IRtcHLi08KktKiMXMIhvg3
         Ab/2ke/JYbzbu2TLHBmE1weZZfXWOm+tcYN3AjX5v5BUMGbtcJ3SEPe7yyQ2g1jSrzjN
         CGirslsy9FnSq5YQTkxXZGGEa0H/STeXb78eCdiV5dlTJ/BP6rC/6Qwdc7Gsstr2lfOB
         t16w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693357318; x=1693962118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ATWj4Im28e+CMik8K692QDJLfQFAhvpejHZZFdLpWBA=;
        b=XcqRa3UqgrlrGXzJA9IpijbqMIgl4VjofTEjo2iuNbyfpmjwG2BvgZnUSvJQm53Oe5
         plmpTRs2TWuEddF6boZ9dC5/t13CO0rnwkpfv7cxz/wpfziQt+ViZfNO5A5tEMsp/Sq5
         TT/hd9pph0YRGeFuHJr0Vzd5lw65Hf+THEhB3z+Z9Pz2TYBGPHUeHzT0dWUadtqmrgIX
         1NQ9JCfqLLj4dGL6rBHAhvyUOpfwPkSu9IxcIkBZlB2xf/VsdqeL25tZfAlvuTYR3A/3
         nbtXckc4h9X+A30NEJxZfL11uwsGRvS2SXYjnRhzazy5WDwYXsWwBXIqiwm7PB9Yeqda
         1+yQ==
X-Gm-Message-State: AOJu0Yx0htQdUptAe3sFBIPrFUXiHlNq70GDXgcdQ9xVL0cA8m4h0M9O
        yQD2duEWAVCVCLrBI3ZbCQmdEg==
X-Google-Smtp-Source: AGHT+IFKyM9BwiCtQXRbgVs+rPLG3+7fHb/mC4/fJ6wEjmNJlYvOqWWVQTZFBpzubVnJLFYWVXGTXQ==
X-Received: by 2002:a05:6a20:3d93:b0:134:2b44:decf with SMTP id s19-20020a056a203d9300b001342b44decfmr918340pzi.21.1693357318184;
        Tue, 29 Aug 2023 18:01:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id b16-20020a170902d51000b00198d7b52eefsm9964942plg.257.2023.08.29.18.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 18:01:57 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qb8tl-008I9d-04;
        Wed, 30 Aug 2023 10:17:29 +1000
Date:   Wed, 30 Aug 2023 10:17:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@gmail.com, Wengang Wang <wen.gang.wang@oracle.com>,
        Srikanth C S <srikanth.c.s@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: reserve less log space when recovering log
 intent items
Message-ID: <ZO6KmUd9LJPwb0GD@dread.disaster.area>
References: <169335065467.3528394.5454470321177848433.stgit@frogsfrogsfrogs>
 <169335066034.3528394.15168907062088535034.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169335066034.3528394.15168907062088535034.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2023 at 04:11:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Wengang Wang reports that a customer's system was running a number of
> truncate operations on a filesystem with a very small log.  Contention
> on the reserve heads lead to other threads stalling on smaller updates
> (e.g.  mtime updates) long enough to result in the node being rebooted
> on account of the lack of responsivenes.  The node failed to recover
> because log recovery of an EFI became stuck waiting for a grant of
> reserve space.  From Wengang's report:
> 
> "For the file deletion, log bytes are reserved basing on
> xfs_mount->tr_itruncate which is:
> 
>     tr_logres = 175488,
>     tr_logcount = 2,
>     tr_logflags = XFS_TRANS_PERM_LOG_RES,
> 
> "You see it's a permanent log reservation with two log operations (two
> transactions in rolling mode).  After calculation (xlog_calc_unit_res()
> adds space for various log headers), the final log space needed per
> transaction changes from  175488 to 180208 bytes.  So the total log
> space needed is 360416 bytes (180208 * 2).  [That quantity] of log space
> (360416 bytes) needs to be reserved for both run time inode removing
> (xfs_inactive_truncate()) and EFI recover (xfs_efi_item_recover())."
> 
> In other words, runtime pre-reserves 360K of space in anticipation of
> running a chain of two transactions in which each transaction gets a
> 180K reservation.
> 
> Now that we've allocated the transaction, we delete the bmap mapping,
> log an EFI to free the space, and roll the transaction as part of
> finishing the deferops chain.  Rolling creates a new xfs_trans which
> shares its ticket with the old transaction.  Next, xfs_trans_roll calls
> __xfs_trans_commit with regrant == true, which calls xlog_cil_commit
> with the same regrant parameter.
> 
> xlog_cil_commit calls xfs_log_ticket_regrant, which decrements t_cnt and
> subtracts t_curr_res from the reservation and write heads.
> 
> If the filesystem is fresh and the first transaction only used (say)
> 20K, then t_curr_res will be 160K, and we give that much reservation
> back to the reservation head.  Or if the file is really fragmented and
> the first transaction actually uses 170K, then t_curr_res will be 10K,
> and that's what we give back to the reservation.
> 
> Having done that, we're now headed into the second transaction with an
> EFI and 180K of reservation.  Other threads apparently consumed all the
> reservation for smaller transactions, such as timestamp updates.
> 
> Now let's say the first transaction gets written to disk and we crash
> without ever completing the second transaction.  Now we remount the fs,
> log recovery finds the unfinished EFI, and calls xfs_efi_recover to
> finish the EFI.  However, xfs_efi_recover starts a new tr_itruncate
> tranasction, which asks for 360K log reservation.  This is a lot more
> than the 180K that we had reserved at the time of the crash.  If the
> first EFI to be recovered is also pinning the tail of the log, we will
> be unable to free any space in the log, and recovery livelocks.
> 
> Wengang confirmed this:
> 
> "Now we have the second transaction which has 180208 log bytes reserved
> too. The second transaction is supposed to process intents including
> extent freeing.  With my hacking patch, I blocked the extent freeing 5
> hours. So in that 5 hours, 180208 (NOT 360416) log bytes are reserved.
> 
> "With my test case, other transactions (update timestamps) then happen.
> As my hacking patch pins the journal tail, those timestamp-updating
> transactions finally use up (almost) all the left available log space
> (in memory in on disk).  And finally the on disk (and in memory)
> available log space goes down near to 180208 bytes.  Those 180208 bytes
> are reserved by [the] second (extent-free) transaction [in the chain]."
> 
> Wengang and I noticed that EFI recovery starts a transaction, completes
> one step of the chain, and commits the transaction without completing
> any other steps of the chain.  Those subsequent steps are completed by
> xlog_finish_defer_ops, which allocates yet another transaction to
> finish the rest of the chain.  That transaction gets the same tr_logres
> as the head transaction, but with tr_logcount = 1 to force regranting
> with every roll to avoid livelocks.
> 
> In other words, we already figured this out in commit 929b92f64048d
> ("xfs: xfs_defer_capture should absorb remaining transaction
> reservation"), but should have applied that logic to each intent item's
> recovery function.  For Wengang's case, the xfs_trans_alloc call in the
> EFI recovery function should only be asking for a single transaction's
> worth of log reservation -- 180K, not 360K.
> 
> Quoting Wengang again:
> 
> "With log recovery, during EFI recovery, we use tr_itruncate again to
> reserve two transactions that needs 360416 log bytes.  Reserving 360416
> bytes fails [stalls] because we now only have about 180208 available.
> 
> "Actually during the EFI recover, we only need one transaction to free
> the extents just like the 2nd transaction at RUNTIME.  So it only needs
> to reserve 180208 rather than 360416 bytes.  We have (a bit) more than
> 180208 available log bytes on disk, so [if we decrease the reservation
> to 180K] the reservation goes and the recovery [finishes].  That is to
> say: we can fix the log recover part to fix the issue. We can introduce
> a new xfs_trans_res xfs_mount->tr_ext_free
> 
> {
>   tr_logres = 175488,
>   tr_logcount = 0,
>   tr_logflags = 0,
> }
> 
> "and use tr_ext_free instead of tr_itruncate in EFI recover."
> 
> However, I don't think it quite makes sense to create an entirely new
> transaction reservation type to handle single-stepping during log
> recovery.  Instead, we should copy the transaction reservation
> information in the xfs_mount, change tr_logcount to 1, and pass that
> into xfs_trans_alloc.  We know this won't risk changing the min log size
> computation since we always ask for a fraction of the reservation for
> all known transaction types.
> 
> This looks like it's been lurking in the codebase since commit
> 3d3c8b5222b92, which changed the xfs_trans_reserve call in
> xlog_recover_process_efi to use the tr_logcount in tr_itruncate.
> That changed the EFI recovery transaction from making a
> non-XFS_TRANS_PERM_LOG_RES request for one transaction's worth of log
> space to a XFS_TRANS_PERM_LOG_RES request for two transactions worth.
> 
> Fixes: 3d3c8b5222b92 ("xfs: refactor xfs_trans_reserve() interface")
> Complements: 929b92f64048d ("xfs: xfs_defer_capture should absorb remaining transaction reservation")
> Suggested-by: Wengang Wang <wen.gang.wang@oracle.com>
> Cc: Srikanth C S <srikanth.c.s@oracle.com>
> [djwong: apply the same transformation to all log intent recovery]
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

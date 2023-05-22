Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF4A1C77B73
	for <linux-xfs@archiver.kernel.org>; Mon, 22 May 2023 22:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjEVWkp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 May 2023 18:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbjEVWkp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 May 2023 18:40:45 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1218CE6
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2023 15:40:43 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1ae875bf125so25741155ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2023 15:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684795242; x=1687387242;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OFlJifysQ/ijmQLf+jsUB3z2r/kLFgNMQet/k0pfZtQ=;
        b=RPry2rUkXIfa5jZkDv/iL5gnVpJxDGlXF7KcgB76KWkWqiLieRUqpHkHA65AwWTPZt
         ZLhH2izVJPeZfT4Pxe+RmTFn+BqXiG16fU+sL+lgmg2bMYYJvDhz+QsJIbPIuUUpuvSH
         2C6fuIpX118nipvMjtN1T+5BwLc3dBLzm1cQcxXCBKBs/WrL4ZcE8ZxvPCS6yMShjJfZ
         MW/BRVGbzWGOY48KflpXH7AqjbL4794Whmn/l7XTUOep9n2F/l/4wuSSyo2RAy19a5HN
         ajyj1FrQkas4DECSyZP8w2z20ul24wfoUse6NBsBxkvJaCsmqepSS7SkVfwraPypTWho
         YC4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684795242; x=1687387242;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OFlJifysQ/ijmQLf+jsUB3z2r/kLFgNMQet/k0pfZtQ=;
        b=CbC39+HLL9CNQn4pHztFCNLiVECXa/jj5TGUqp9cVJ3jTpR92+OM4L5yBg4xvrSYpE
         lSj7Eyu7Z/sfBi4XzPU732lcogx/xjRODmkqsJteYXZ7TulEbnUs+u6zksqZOiNm1jFS
         F13tzyPnJeV4TrtnEiXNjCxbl3T7xaeCjdm8AS3NLWWIDa2WyRqBtnh6+DIkdIlPuvGn
         /LMJLx1GPptraIWoLAwsEKJ1Idx4UwSXlqCDHqCEmeiWBlEdUkO57M+c7gP+UxYCd0Ef
         yRV+T9lkt5w1JHYM+7KLYQJo298DIcMAv+41i6eJCnfT/XUMByjgWAdAFHbkc7KvJtZP
         WJfg==
X-Gm-Message-State: AC+VfDx1FryW+s35L1+iun2W+tL34D43HsmqN8UcxeQbUh9csTbACBeO
        5hhutOkpL3PwjYfYZbfwlT+9VOiXjRn3SBu+XX8=
X-Google-Smtp-Source: ACHHUZ72NlpjMddhjq96WMldQ3hZGRkp1Cmqofh0Aa8dlo2IxnCiTeG/b1T0+7o30c/4OsvpRuXkeg==
X-Received: by 2002:a17:902:db07:b0:1ac:8dae:d842 with SMTP id m7-20020a170902db0700b001ac8daed842mr14535116plx.46.1684795242405;
        Mon, 22 May 2023 15:40:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id w6-20020a170902d70600b001a6a53c3b04sm5305522ply.306.2023.05.22.15.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 15:40:41 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q1ECj-002hcW-2m;
        Tue, 23 May 2023 08:40:37 +1000
Date:   Tue, 23 May 2023 08:40:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "djwong@kernel.org" <djwong@kernel.org>
Subject: Re: [PATCH] xfs: Don't block in xfs_extent_busy_flush
Message-ID: <ZGvvZaQWvxf2cqlz@dread.disaster.area>
References: <20230519171829.4108-1-wen.gang.wang@oracle.com>
 <ZGrCpXoEk9achabI@dread.disaster.area>
 <E6E92519-4AD7-4115-903F-00D7633B1B3A@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E6E92519-4AD7-4115-903F-00D7633B1B3A@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 22, 2023 at 06:20:11PM +0000, Wengang Wang wrote:
> > On May 21, 2023, at 6:17 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, May 19, 2023 at 10:18:29AM -0700, Wengang Wang wrote:
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
> > 
> > Ok, but it doesn't dirty the transaction or the EFD, which means....
> 
> Actually EAGAIN shouldn’t happen with the first record in EFIs because
> the trans->t_busy is empty in AGFL block allocation for the first record.
> So the dirtying work should already done with the first one.

You're assuming that the only thing we are going to want to return
-EAGAIN for freeing attamps for is busy extents. Being able to
restart btree operations by "commit and retry" opens up a
a whole new set of performance optimisations we can make to the
btree code.

IOWs, I want this functionality to be generic in nature, not
tailored specifically to one situation where an -EAGAIN needs to be
returned to trigger a commit an retry.

> >> @@ -369,6 +388,10 @@ xfs_trans_free_extent(
> >> error = __xfs_free_extent(tp, xefi->xefi_startblock,
> >> xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
> >> xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
> >> + if (error == -EAGAIN) {
> >> + xfs_fill_efd_with_efi(efdp);
> >> + return error;
> >> + }
> > 
> > .... this is incorrectly placed.
> > 
> > The very next lines say:
> > 
> >> /*
> >>  * Mark the transaction dirty, even on error. This ensures the
> >>  * transaction is aborted, which:
> > 
> > i.e. we have to make the transaction and EFD log item dirty even if
> > we have an error. In this case, the error is not fatal, but we still
> > have to ensure that we commit the EFD when we roll the transaction.
> > Hence the transaction and EFD still need to be dirtied on -EAGAIN...
> 
> see above.

See above :)

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
> > 
> > xfs_ail_max_lsn() and l_curr_cycle/l_curr_block are not the same
> > thing.  max_lsn points to the lsn of the last entry in the AIL (in
> > memory state), whilst curr_cycle/block points to the current
> > physical location of the log head in the on-disk journal.
> > 
> 
> Yes, I intended to use the lsn of the last entry in the AIL.

Again, they are not the same thing: using the last entry in the
AIL here is incorrect. We want to replay all the items in the AIL
that were active in the log, not up to the last item in the AIL. The
actively recovered log region ends at last_lsn as per above, whilst
xfs_ail_max_lsn() is not guaranteed to be less than last_lsn before
we start walking it.

> For the problem with xlog_recover_process_intents(), please see my reply to
> Darrick. On seeing the problem, my first try was to use “last_lsn” to stop
> the iteration but that didn’t help.  last_lsn was found quite bigger than even
> the new EFI lsn. While use xfs_ail_max_lsn() it solved the problem.

In what case are we queuing a *new* intent into the AIL that has a
LSN less than xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block)?
If we are doing that *anywhere*, then we have a likely journal
corruption bug in the code because it indicates we committed that
item to the journal over something in the log we are currently
replaying.

> > In this case, we can't use in-memory state to determine where to
> > stop the initial intent replay - recovery of other items may have
> > inserted new intents beyond the end of the physical region being
> > recovered, in which case using xfs_ail_max_lsn() will result in
> > incorrect behaviour here.
> 
> Yes, this patch is one of those (if some exist) introduce new intents (EFIs here).
> We add the new intents to the transaction first (xfs_defer_create_intent()), add
> the deferred operations to ‘capture_list’. And finally the deferred options in
> ‘capture_list’ is processed after the intent-iteration on the AIL.

The changes made in that transaction, including the newly logged
EFI, get committed before the rest of the work gets deferred via
xfs_defer_ops_capture_and_commit(). That commits the new efi (along
with all the changes that have already been made in the transaction)
to the CIL, and eventually the journal checkpoints and the new EFI
gets inserted into the AIL at the LSN of the checkpoint.

The LSN of the checkpoint is curr_cycle/block - the log head -
because that's where the start record of the checkpoint is
physically written.  As each iclog is filled, the log head moves
forward - it always points at the location that the next journal
write will be written to. At the end of a checkpoint, the LSN of the
start record is used for AIL insertion.

Hence if a new log item created by recovery has a LSN less than
last_lsn, then we have a serious bug somewhere that needs to be
found and fixed. The use of last_lsn tells us something has gone
badly wrong during recovery, the use of xfs_ail_max_lsn() removes
the detection of the issue and now we don't know that something has
gone badly wrong...

> For existing other cases (if there are) where new intents are added,
> they don’t use the capture_list for delayed operations? Do you have example then? 
> if so I think we should follow their way instead of adding the defer operations
> (but reply on the intents on AIL).

All of the intent recovery stuff uses
xfs_defer_ops_capture_and_commit() to commit the intent being
replayed and cause all further new intent processing in that chain
to be defered until after all the intents recovered from the journal
have been iterated. All those new intents end up in the AIL at a LSN
index >= last_lsn.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

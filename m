Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 595DCC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 15:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12D9264DE2
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 15:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbhA1PNk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 10:13:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40812 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229667AbhA1PNj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 10:13:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611846732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YTBY3ZPBozHwqHsrzUw9VWR4uSwKd9sotYrU6iMJkEA=;
        b=FuaZPrmEbxfBA1eCPJF2oy3nNFVrfEf8y2wtGxFfO2xivnPub5sra5TCzS8IvWf285O0xU
        mUXxQ636hKIIBGM83Zw8/cib3fGG/5bteYtBv4JsppDDoZ+u52Q+OsKJ82VY3AZFRBYNma
        R+6pw3KZqTPc0pQ7tbCVfqsoVU0DwNU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-60yxaUiiPoy_300VmzH9MA-1; Thu, 28 Jan 2021 10:12:09 -0500
X-MC-Unique: 60yxaUiiPoy_300VmzH9MA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E0B9192AB7D;
        Thu, 28 Jan 2021 15:12:08 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9150A10016FF;
        Thu, 28 Jan 2021 15:12:07 +0000 (UTC)
Date:   Thu, 28 Jan 2021 10:12:05 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: journal IO cache flush reductions
Message-ID: <20210128151205.GC2599027@bfoster>
References: <20210128044154.806715-1-david@fromorbit.com>
 <20210128044154.806715-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128044154.806715-4-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 03:41:52PM +1100, Dave Chinner wrote:
> From: Steve Lord <lord@sgi.com>
> 
> Currently every journal IO is issued as REQ_PREFLUSH | REQ_FUA to
> guarantee the ordering requirements the journal has w.r.t. metadata
> writeback. THe two ordering constraints are:
> 
> 1. we cannot overwrite metadata in the journal until we guarantee
> that the dirty metadata has been written back in place and is
> stable.
> 
> 2. we cannot write back dirty metadata until it has been written to
> the journal and guaranteed to be stable (and hence recoverable) in
> the journal.
> 
> THe ordering guarantees of #1 are provided by REQ_PREFLUSH. This
> causes the journal IO to issue a cache flush and wait for it to
> complete before issuing the write IO to the journal. Hence all
> completed metadata IO is guaranteed to be stable before the journal
> overwrites the old metadata.
> 
> THe ordering guarantees of #2 are provided by the REQ_FUA, which
> ensures the journal writes do not complete until they are on stable
> storage. Hence by the time the last journal IO in a checkpoint
> completes, we know that the entire checkpoint is on stable storage
> and we can unpin the dirty metadata and allow it to be written back.
> 
> This is the mechanism by which ordering was first implemented in XFS
> way back in 2002 by this commit:
> 
> commit 95d97c36e5155075ba2eb22b17562cfcc53fcf96
> Author: Steve Lord <lord@sgi.com>
> Date:   Fri May 24 14:30:21 2002 +0000
> 
>     Add support for drive write cache flushing - should the kernel
>     have the infrastructure
> 
> A lot has changed since then, most notably we now use delayed
> logging to checkpoint the filesystem to the journal rather than
> write each individual transaction to the journal. Cache flushes on
> journal IO are necessary when individual transactions are wholly
> contained within a single iclog. However, CIL checkpoints are single
> transactions that typically span hundreds to thousands of individual
> journal writes, and so the requirements for device cache flushing
> have changed.
> 
> That is, the ordering rules I state above apply to ordering of
> atomic transactions recorded in the journal, not to the journal IO
> itself. Hence we need to ensure metadata is stable before we start
> writing a new transaction to the journal (guarantee #1), and we need
> to ensure the entire transaction is stable in the journal before we
> start metadata writeback (guarantee #2).
> 
> Hence we only need a REQ_PREFLUSH on the journal IO that starts a
> new journal transaction to provide #1, and it is not on any other
> journal IO done within the context of that journal transaction.
> 

Conceptually, if the preflush is for metadata completion -> log
submission ordering and the fua is for log completion to metadata
submission ordering, then it seems quite logical that the current flush
pattern could be widened to provide similar guarantees for the
checkpoint model implemented by delayed logging.

> To ensure that the entire journal transaction is on stable storage
> before we run the completion code that unpins all the dirty metadata
> recorded in the journal transaction, the last write of the
> transaction must also ensure that the entire journal transaction is
> stable. We already know what IO that will be, thanks to the commit
> record we explicitly write to complete the transaction. We can order
> all the previous journal IO for this transaction by waiting for all
> the previous iclogs containing the transaction data to complete
> their IO, then issuing the commit record IO using REQ_PREFLUSH
> | REQ_FUA. The preflush ensures all the previous journal IO is
> stable before the commit record hits the log, and the REQ_FUA
> ensures that the commit record is stable before completion is
> signalled to the filesystem.
> 
> Hence using REQ_PREFLUSH on the first IO of a journal transaction,
> and then ordering the journal IO before issuing the commit record
> with REQ_PREFLUSH | REQ_FUA, we get all the same ordering guarantees
> that we currently achieve by issuing all journal IO with cache
> flushes.
> 
> As an optimisation, when the commit record lands in the same iclog
> as the journal transaction starts, we don't need to wait for
> anything and can simply issue the journal IO with REQ_PREFLUSH |
> REQ_FUA as we do right now. This means that for fsync() heavy
> workloads, the cache flush behaviour is completely unchanged and
> there is no degradation in performance as a result of optimise the
> multi-IO transaction case.
> 
> To further simplify the implementation, we also issue the initial IO
> in a journal transaction with REQ_FUA. THis ensures the journal is
> dirtied by the first IO in a long running transaction as quickly as
> possible. This helps ensure that log recovery will at least have a
> transaction header for the incomplete transaction in the log similar
> to the stable journal write behaviour we have now.
> 
...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c      | 34 ++++++++++++++++++++++------------
>  fs/xfs/xfs_log_priv.h |  3 +++
>  2 files changed, 25 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c5e3da23961c..8de93893e0e6 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
...
> @@ -2464,9 +2465,18 @@ xlog_write(
>  		ASSERT(log_offset <= iclog->ic_size - 1);
>  		ptr = iclog->ic_datap + log_offset;
>  
> -		/* start_lsn is the first lsn written to. That's all we need. */
> -		if (!*start_lsn)
> +		/*
> +		 * Start_lsn is the first lsn written to. That's all the caller
> +		 * needs to have returned. Setting it indicates the first iclog
> +		 * of a new checkpoint or the commit record for a checkpoint, so
> +		 * also mark the iclog as requiring a pre-flush to ensure all
> +		 * metadata writeback or journal IO in the checkpoint is
> +		 * correctly ordered against this new log write.
> +		 */
> +		if (!*start_lsn) {
>  			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +			iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
> +		}

My understanding is that one of the reasons for the preflush per iclog
approach is that we don't have any submission -> completion ordering
guarantees across iclogs. This is why we explicitly order commit record
completions and whatnot, to ensure the important bits are ordered
correctly. The fact we implement that ordering ourselves suggests that
PREFLUSH|FUA itself do not provide such ordering, though that's not
something I've investigated.

In any event, if the purpose fo the PREFLUSH is to ensure that metadata
in the targeted LSN range is committed to stable storage, and we have no
submission ordering guarantees across non-commit record iclogs, what
prevents a subsequent iclog from the same checkpoint from completing
before the first iclog with a PREFLUSH? If nothing, then what prevents
that subsequent iclog from overwriting a range of LSNs in the log that
have not been committed to stable storage (potentially leaving a
corruption vector in the event of a crash)? Wouldn't this now require
some form of start record completion ordering to ensure the integrity of
the flush?

Brian

>  
>  		/*
>  		 * This loop writes out as many regions as can fit in the amount
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index a7ac85aaff4e..9f1e627ccb74 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -133,6 +133,8 @@ enum xlog_iclog_state {
>  
>  #define XLOG_COVER_OPS		5
>  
> +#define XLOG_ICL_NEED_FLUSH     (1 << 0)        /* iclog needs REQ_PREFLUSH */
> +
>  /* Ticket reservation region accounting */ 
>  #define XLOG_TIC_LEN_MAX	15
>  
> @@ -201,6 +203,7 @@ typedef struct xlog_in_core {
>  	u32			ic_size;
>  	u32			ic_offset;
>  	enum xlog_iclog_state	ic_state;
> +	unsigned int		ic_flags;
>  	char			*ic_datap;	/* pointer to iclog data */
>  
>  	/* Callback structures need their own cacheline */
> -- 
> 2.28.0
> 


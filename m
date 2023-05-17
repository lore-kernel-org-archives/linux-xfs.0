Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19031C77B75
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 01:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbjEQBkM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 May 2023 21:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjEQBkL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2023 21:40:11 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40D53C06
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2023 18:40:09 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1ae54b623c2so109965ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2023 18:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684287609; x=1686879609;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/8FkmVQ9cEWnp9lT53MNPZ+cBCoXwjQ6fW4gqa/AU2s=;
        b=gSSldkmq2uoK205KhBtfsFxxGUKW6moAkRqsAdZnGiaXZkiQ+T5uLAJMoC0iDOq749
         gWauLIBDb70FD6EzS0cNbMd4Nm50Qk8GVb5S/ewPS9LN0qsOgq7iq6TI5xdLWi4MRFbT
         ILCZfJqNC7c1h0e9ZbbJ7B7fXeNp20C+ubb2a0X4bJguVh6/XZ9S4+jBMF4yrReM7pTk
         rFszkcJ9gxhVUhG//P+UT5nRsy+m/JufWtkjf1qTzA/YomosTa8D8MuMYSdBIdcRKINj
         ZeaMb6fgA/oL7aEZZBj7zK6QKEMfxqM2yMaS5fxxzP0fGiGTf//rEBiaN9qPh915Vtbr
         dkbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684287609; x=1686879609;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/8FkmVQ9cEWnp9lT53MNPZ+cBCoXwjQ6fW4gqa/AU2s=;
        b=MWCXgLRQJCu9MCqi2Y8xc1rgyvqI9Zw+hqbvQdBNaiXfGrcRs1vxQoz7g7kmhMY3Nf
         HnoLKEDK6+0d8uLCSfteu0/bouCGrbXYJj7FIEVOJ5GDL+9IkYMSTAtuNV43KwmYglis
         mG0e3z7oox0ERWrob88JysXNYExEA/vuavE0XTjdTO+Q/Hj4Hb/33RFM+vQLgAo4R2BH
         DZnxhqid1067tuCgCPLCAf/hRhOgbSRj0r370OkYnDpzHOne7LyQZtKKI3i6CsKblKUq
         jb5jIuij0Af/YyNNapCaBXkOcGwSZ+CHnB5huFXn6utHv5rhJMNsPoHjrWLqR+TK4APq
         KmEQ==
X-Gm-Message-State: AC+VfDx5yIr7MkBrU1AlZYtzqYo+swckLmvMeKD0EkcPu3LmnR+46m86
        Ra73+sA74MFAPJuMqdLYXDRumw==
X-Google-Smtp-Source: ACHHUZ6914SnYd+sRMT4b032nixyq4G41cKkjV7qc0BS8x2Ac7npVpVeyMJyh5f5+N8Keku5iaqX4A==
X-Received: by 2002:a17:903:2445:b0:1ad:c627:87de with SMTP id l5-20020a170903244500b001adc62787demr27372971pls.32.1684287609274;
        Tue, 16 May 2023 18:40:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id o18-20020a17090aeb9200b0024decfb1ec2sm244151pjy.30.2023.05.16.18.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 18:40:08 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1pz697-000NDe-2i;
        Wed, 17 May 2023 11:40:05 +1000
Date:   Wed, 17 May 2023 11:40:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Wengang Wang <wen.gang.wang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: avoid freeing multiple extents from same AG in
 pending transactions
Message-ID: <ZGQwdes/DQPXRJgj@dread.disaster.area>
References: <20230424225102.23402-1-wen.gang.wang@oracle.com>
 <20230512182455.GJ858799@frogsfrogsfrogs>
 <592C0DE1-F4F5-4C9A-8799-E9E81524CDC0@oracle.com>
 <20230512211326.GK858799@frogsfrogsfrogs>
 <050A91C4-54EC-4EB8-A701-7C9F640B7ADB@oracle.com>
 <11835435-29A1-4F34-9CE5-C9ED84567E98@oracle.com>
 <20230517005913.GM858799@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517005913.GM858799@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 16, 2023 at 05:59:13PM -0700, Darrick J. Wong wrote:
> Since 6.3 we got rid of the _THIS_AG indirection stuff and that becomes:
> 
> xfs_alloc_fix_freelist ->
> xfs_alloc_ag_vextent_size ->
> (run all the way to the end of the bnobt) ->
> xfs_extent_busy_flush ->
> <stall on the busy extent that's in @tp->busy_list>
> 
> xfs_extent_busy_flush does this, potentially while we're holding the
> freed extent in @tp->t_busy_list:
> 
> 	error = xfs_log_force(mp, XFS_LOG_SYNC);
> 	if (error)
> 		return;
> 
> 	do {
> 		prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
> 		if  (busy_gen != READ_ONCE(pag->pagb_gen))
> 			break;
> 		schedule();
> 	} while (1);
> 
> 	finish_wait(&pag->pagb_wait, &wait);
> 
> The log force kicks the CIL to process whatever other committed items
> might be lurking in the log.  *Hopefully* someone else freed an extent
> in the same AG, so the log force has now caused that *other* extent to
> get processed so it has now cleared the busy list.  Clearing something
> from the busy list increments the busy generation (aka pagb_gen).

*nod*

> Unfortunately, there aren't any other extents, so the busy_gen does not
> change, and the loop runs forever.
> 
> At this point, Dave writes:
> 
> [15:57] <dchinner> so if we enter that function with busy extents on the
> transaction, and we are doing an extent free operation, we should return
> after the sync log force and not do the generation number wait
> 
> [15:58] <dchinner> if we fail to allocate again after the sync log force
> and the generation number hasn't changed, then return -EAGAIN because no
> progress has been made.
> 
> [15:59] <dchinner> Then the transaction is rolled, the transaction busy
> list is cleared, and if the next allocation attempt fails becaues
> everything is busy, we go to sleep waiting for the generation to change
> 
> [16:00] <dchinner> but because the transaction does not hold any busy
> extents, it cannot deadlock here because it does not pin any extents
> that are in the busy tree....
> 
> [16:05] <dchinner> All the generation number is doing here is telling us
> whether there was busy extent resolution between the time we last
> skipped a viable extent because it was busy and when the flush
> completes.
> 
> [16:06] <dchinner> it doesn't mean the next allocation will succeed,
> just that progress has been made so trying the allocation attempt will
> at least get a different result to the previous scan.
> 
> I think the callsites go from this:
> 
> 	if (busy) {
> 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> 		trace_xfs_alloc_size_busy(args);
> 		xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
> 		goto restart;
> 	}

I was thinking this code changes to:

	flags |= XFS_ALLOC_FLAG_TRY_FLUSH;
	....
	<attempt allocation>
	....
	if (busy) {
		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
		trace_xfs_alloc_size_busy(args);
		error = xfs_extent_busy_flush(args->tp, args->pag,
				busy_gen, flags);
		if (!error) {
			flags &= ~XFS_ALLOC_FLAG_TRY_FLUSH;
			goto restart;
		}
		/* jump to cleanup exit point */
		goto out_error;
	}

Note the different first parameter - we pass args->tp, not args->mp
so that the flush has access to the transaction context...

> to something like this:
> 
> 	bool	try_log_flush = true;
> 	...
> restart:
> 	...
> 
> 	if (busy) {
> 		bool	progress;
> 
> 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> 		trace_xfs_alloc_size_busy(args);
> 
> 		/*
> 		 * If the current transaction has an extent on the busy
> 		 * list, we're allocating space as part of freeing
> 		 * space, and all the free space is busy, we can't hang
> 		 * here forever.  Force the log to try to unbusy free
> 		 * space that could have been freed by other
> 		 * transactions, and retry the allocation.  If the
> 		 * allocation fails a second time because all the free
> 		 * space is busy and nobody made any progress with
> 		 * clearing busy extents, return EAGAIN so the caller
> 		 * can roll this transaction.
> 		 */
> 		if ((flags & XFS_ALLOC_FLAG_FREEING) &&
> 		    !list_empty(&tp->t_busy_list)) {
> 			int log_flushed;
> 
> 			if (try_log_flush) {
> 				_xfs_log_force(mp, XFS_LOG_SYNC, &log_flushed);
> 				try_log_flush = false;
> 				goto restart;
> 			}
> 
> 			if (busy_gen == READ_ONCE(pag->pagb_gen))
> 				return -EAGAIN;
> 
> 			/* XXX should we set try_log_flush = true? */
> 			goto restart;
> 		}
> 
> 		xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
> 		goto restart;
> 	}
> 
> IOWs, I think Dave wants us to keep the changes in the allocator instead
> of spreading it around.

Sort of - I want the busy extent flush code to be isolated inside
xfs_extent_busy_flush(), not spread around the allocator. :)

xfs_extent_busy_flush(
	struct xfs_trans	*tp,
	struct xfs_perag	*pag,
	unsigned int		busy_gen,
	unsigned int		flags)
{
	error = xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
	if (error)
		return error;

	/*
	 * If we are holding busy extents, the caller may not want
	 * to block straight away. If we are being told just to try
	 * a flush or progress has been made since we last skipped a busy
	 * extent, return immediately to allow the caller to try
	 * again. If we are freeing extents, we might actually be
	 * holding the onyly free extents in the transaction busy
	 * list and the log force won't resolve that situation. In
	 * this case, return -EAGAIN in that case to tell the caller
	 * it needs to commit the busy extents it holds before
	 * retrying the extent free operation.
	 */
	if (!list_empty(&tp->t_busy_list)) {
		if (flags & XFS_ALLOC_FLAG_TRY_FLUSH)
			return 0;
		if (busy_gen != READ_ONCE(pag->pagb_gen))
			return 0;
		if (flags & XFS_ALLOC_FLAG_FREEING)
			return -EAGAIN;
	}

	/* wait for progressing resolving busy extents */
	do {
		prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
		if  (busy_gen != READ_ONCE(pag->pagb_gen))
			break;
		schedule();
	} while (1);

	finish_wait(&pag->pagb_wait, &wait);
	return 0;
}

It seems cleaner to me to put this all in xfs_extent_busy_flush()
rather than having open-coded handling of extent free constraints in
each potential flush location. We already have retry semantics
around the flush, let's just extend them slightly....

-Dave.

-- 
Dave Chinner
david@fromorbit.com

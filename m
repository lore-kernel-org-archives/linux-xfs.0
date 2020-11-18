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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B7CC56202
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Nov 2020 05:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55CED24695
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Nov 2020 05:58:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TpBctl62"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgKRF6h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Nov 2020 00:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgKRF6h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Nov 2020 00:58:37 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179BFC0613D4
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 21:58:37 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id t37so365250pga.7
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 21:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WMOz5p92JfhYZWAsYUqOaWTqbqkXwLl6cpwiMeEvZlI=;
        b=TpBctl62z/hCVwmFtRNDiQY7CIRU03B+UC+gin/fr2lvQrH17+Zc4pDDqvYD3aIvva
         tj2TzHnA3WdJmsefEumVgJ4+YZEEDr87MO0i9dljNUWHfiKdGjVvoxbPYIWmwrpLudNt
         3jmBw57rHDk9zoLokEt3SKpE2F8o/BnCLbvQ6kp8i9lQGx13JttTVdMuWELNJwJdAckN
         iUAjeZWU5uWvohxTPOdktgd5+sSjdXDGMn3nZftdqBaQ7AZML1veLoCvwFeLQw9a4ajX
         VsCQ7T05ILYeVm2YDTGLYnlBj6dcwIOMw2wrLsc/17ZUKimpJq4TxSKExJzMD+oWikVa
         Jpbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WMOz5p92JfhYZWAsYUqOaWTqbqkXwLl6cpwiMeEvZlI=;
        b=F7S431fFHMcb0yxYT8Da8w8HZXZvHuxCX7a8ncBfrVSUAeNXYcDlfVQaIco0+lgnLM
         2nBd8wVLTO8aJD3dtdq8tR0vOjDtKKnRfNB/c+MruXskyTFvfN8S58pz9y+bWa/TY1rU
         WLTxhGdvheILIVFpiDOWxJ3eSjzKlSbjUwi5dzxe0d0K0obRP/hMynxkE0Qv5+6PjAaX
         Lgctsl4roKh42AJBZ+Q7Rsu00NFt1JoPrBz087MxVAmqCJgHn9gtKodHRhreO7eamtwq
         MTyLWrHyY1097mrumKUzFblUdYZ6F4XOESCfxKehDXqKmtVTn/uFWMXcNrdV3tcz+SDa
         HyjQ==
X-Gm-Message-State: AOAM531YdTtcRoFjQ+fC5ok0pV3GKcmGPzwZ5Wm9qbrkYiMlEM+NrxcN
        RUarbWimLcJ6EqOFN64iX8v9619qNwI=
X-Google-Smtp-Source: ABdhPJzLVWuvpN+bfBIfe7JgbP+0t6VNFyB8CVvaqp5ftna5+fXM9Cpa7DGmWTxtGRIjFqppZo7VNw==
X-Received: by 2002:aa7:84d0:0:b029:18b:fac7:29b with SMTP id x16-20020aa784d00000b029018bfac7029bmr2977531pfn.29.1605679116548;
        Tue, 17 Nov 2020 21:58:36 -0800 (PST)
Received: from garuda.localnet ([122.166.88.26])
        by smtp.gmail.com with ESMTPSA id o1sm1447093pgk.60.2020.11.17.21.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 21:58:35 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: ensure inobt record walks always make forward progress
Date:   Wed, 18 Nov 2020 11:28:32 +0530
Message-ID: <2306620.Cd8hHp5erb@garuda>
In-Reply-To: <20201117181456.GZ9695@magnolia>
References: <20201117181456.GZ9695@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 17 November 2020 11:44:56 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The aim of the inode btree record iterator function is to call a
> callback on every record in the btree.  To avoid having to tear down and
> recreate the inode btree cursor around every callback, it caches a
> certain number of records in a memory buffer.  After each batch of
> callback invocations, we have to perform a btree lookup to find the
> next record after where we left off.
> 
> However, if the keys of the inode btree are corrupt, the lookup might
> put us in the wrong part of the inode btree, causing the walk function
> to loop forever.  Therefore, we add extra cursor tracking to make sure
> that we never go backwards neither when performing the lookup nor when
> jumping to the next inobt record.  This also fixes an off by one error
> where upon resume the lookup should have been for the inode /after/ the
> point at which we stopped.
> 
> Found by fuzzing xfs/460 with keys[2].startino = ones causing bulkstat
> and quotacheck to hang.

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> 
> Fixes: a211432c27ff ("xfs: create simplified inode walk function")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: fix idiotic mismerge, sorry about that...
> ---
>  fs/xfs/xfs_iwalk.c |   27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index 233dcc8784db..2a45138831e3 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -55,6 +55,9 @@ struct xfs_iwalk_ag {
>  	/* Where do we start the traversal? */
>  	xfs_ino_t			startino;
>  
> +	/* What was the last inode number we saw when iterating the inobt? */
> +	xfs_ino_t			lastino;
> +
>  	/* Array of inobt records we cache. */
>  	struct xfs_inobt_rec_incore	*recs;
>  
> @@ -301,6 +304,9 @@ xfs_iwalk_ag_start(
>  	if (XFS_IS_CORRUPT(mp, *has_more != 1))
>  		return -EFSCORRUPTED;
>  
> +	iwag->lastino = XFS_AGINO_TO_INO(mp, agno,
> +				irec->ir_startino + XFS_INODES_PER_CHUNK - 1);
> +
>  	/*
>  	 * If the LE lookup yielded an inobt record before the cursor position,
>  	 * skip it and see if there's another one after it.
> @@ -347,15 +353,17 @@ xfs_iwalk_run_callbacks(
>  	struct xfs_mount		*mp = iwag->mp;
>  	struct xfs_trans		*tp = iwag->tp;
>  	struct xfs_inobt_rec_incore	*irec;
> -	xfs_agino_t			restart;
> +	xfs_agino_t			next_agino;
>  	int				error;
>  
> +	next_agino = XFS_INO_TO_AGINO(mp, iwag->lastino) + 1;
> +
>  	ASSERT(iwag->nr_recs > 0);
>  
>  	/* Delete cursor but remember the last record we cached... */
>  	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
>  	irec = &iwag->recs[iwag->nr_recs - 1];
> -	restart = irec->ir_startino + XFS_INODES_PER_CHUNK - 1;
> +	ASSERT(next_agino == irec->ir_startino + XFS_INODES_PER_CHUNK);
>  
>  	error = xfs_iwalk_ag_recs(iwag);
>  	if (error)
> @@ -372,7 +380,7 @@ xfs_iwalk_run_callbacks(
>  	if (error)
>  		return error;
>  
> -	return xfs_inobt_lookup(*curpp, restart, XFS_LOOKUP_GE, has_more);
> +	return xfs_inobt_lookup(*curpp, next_agino, XFS_LOOKUP_GE, has_more);
>  }
>  
>  /* Walk all inodes in a single AG, from @iwag->startino to the end of the AG. */
> @@ -396,6 +404,7 @@ xfs_iwalk_ag(
>  
>  	while (!error && has_more) {
>  		struct xfs_inobt_rec_incore	*irec;
> +		xfs_ino_t			rec_fsino;
>  
>  		cond_resched();
>  		if (xfs_pwork_want_abort(&iwag->pwork))
> @@ -407,6 +416,15 @@ xfs_iwalk_ag(
>  		if (error || !has_more)
>  			break;
>  
> +		/* Make sure that we always move forward. */
> +		rec_fsino = XFS_AGINO_TO_INO(mp, agno, irec->ir_startino);
> +		if (iwag->lastino != NULLFSINO &&
> +		    XFS_IS_CORRUPT(mp, iwag->lastino >= rec_fsino)) {
> +			error = -EFSCORRUPTED;
> +			goto out;
> +		}
> +		iwag->lastino = rec_fsino + XFS_INODES_PER_CHUNK - 1;
> +
>  		/* No allocated inodes in this chunk; skip it. */
>  		if (iwag->skip_empty && irec->ir_freecount == irec->ir_count) {
>  			error = xfs_btree_increment(cur, 0, &has_more);
> @@ -535,6 +553,7 @@ xfs_iwalk(
>  		.trim_start	= 1,
>  		.skip_empty	= 1,
>  		.pwork		= XFS_PWORK_SINGLE_THREADED,
> +		.lastino	= NULLFSINO,
>  	};
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
>  	int			error;
> @@ -623,6 +642,7 @@ xfs_iwalk_threaded(
>  		iwag->data = data;
>  		iwag->startino = startino;
>  		iwag->sz_recs = xfs_iwalk_prefetch(inode_records);
> +		iwag->lastino = NULLFSINO;
>  		xfs_pwork_queue(&pctl, &iwag->pwork);
>  		startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
>  		if (flags & XFS_INOBT_WALK_SAME_AG)
> @@ -696,6 +716,7 @@ xfs_inobt_walk(
>  		.startino	= startino,
>  		.sz_recs	= xfs_inobt_walk_prefetch(inobt_records),
>  		.pwork		= XFS_PWORK_SINGLE_THREADED,
> +		.lastino	= NULLFSINO,
>  	};
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
>  	int			error;
> 


-- 
chandan




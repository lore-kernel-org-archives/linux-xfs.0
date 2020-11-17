Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FEBC2D0E4
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 07:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EB98221EB
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 07:14:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hlE7AmbP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgKQHN5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 02:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgKQHN5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 02:13:57 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0E9C0613CF
        for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2020 23:13:57 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id p68so5067661pga.6
        for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2020 23:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HXHxIMqAwRRRAY7zzn/WrI4GTrDq4Xv3McMpEQeHqaQ=;
        b=hlE7AmbPJ0QO5SXRP54ZhUaNIp2DKWTaa6WrzlbInn+kSxnSnJ2YfTpSmozuZR4cea
         i4M1QzGxks1SZeqVA+I6GeakoT6aj6tfo2y6xviFpDfUowEj3vbyagRzvZSb3SUMV5HF
         iGDoJ/qab+5jUl6q7ih7ppYZgjQknRP8z5YXBmbG2YssRqi6roJ/2Ze3hMj6m3DIwHfs
         iC9AzxOjz8VcQvuRaNOft/iMJBNj44gAm2R4UpVX0O+JhwZFxeTCte5Dr3xb9R+J+Ssa
         qY0otliJR+jX+Z8Zk9BCo3Js+zE4eD386bxKx2AKU9FhCnjHhPdNrJVlXc+KMKXVgmcC
         mukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HXHxIMqAwRRRAY7zzn/WrI4GTrDq4Xv3McMpEQeHqaQ=;
        b=FvozphTmejKTRVIMv/TAF3xX6ttODxDGFyHg/dZ0c4FgA99ich96hKz7piDcVIobLR
         m5FPh16rk0RIiPygIp2z02ANpxKFXhJo7JWZnYwiWC5syPTCqAPgJApbSk2VmwoTlzp3
         Vh6ISs7Duc7Jfa2rKTS+mgedhLzQw6a92CYQ4TTWpX4Ez5CLNyoZwEg5W7Al5UemYrQ1
         hMIwSclKR36VwYzQPvgEI0XObKtjUt6qiXkyAa575/J8GOf29Q6/L/QzxrOVEDmAc2IG
         6k2KQw7jodZWpjkKTHGVhzxI9IIc+UTet3kFEUplMaMRTD39iEqm8CLbZGLSZATO8eHG
         zXSQ==
X-Gm-Message-State: AOAM531Admzi9Q40rYQwnEdbPWGAycZ2nSOUTbp3P2vO3C0jdVomGNww
        Ia/EA/KX3f24mejjaGlbwUtHWzSt/fo=
X-Google-Smtp-Source: ABdhPJwd9RUXrK4Xy9jugFvUsQs7dFCppqOtujUwQdcQuQ9KWJoVj5Mz35Oqq2utxJUNEeaKfmSHYA==
X-Received: by 2002:a62:84d2:0:b029:18a:f574:fded with SMTP id k201-20020a6284d20000b029018af574fdedmr17670493pfd.31.1605597236741;
        Mon, 16 Nov 2020 23:13:56 -0800 (PST)
Received: from garuda.localnet ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id ha21sm1791808pjb.2.2020.11.16.23.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 23:13:55 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: ensure inobt record walks always make forward progress
Date:   Tue, 17 Nov 2020 12:43:53 +0530
Message-ID: <2361502.6kiv4OgxuR@garuda>
In-Reply-To: <20201114191446.GR9695@magnolia>
References: <20201114191446.GR9695@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday 15 November 2020 12:44:46 AM IST Darrick J. Wong wrote:
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
> 
> Fixes: a211432c27ff ("xfs: create simplified inode walk function")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_iwalk.c |   26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index 233dcc8784db..889ed867670c 100644
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
> @@ -214,6 +217,8 @@ xfs_iwalk_ag_recs(
>  				return error;
>  		}
>  	}
> +	iwag->lastino = XFS_AGINO_TO_INO(mp, agno,
> +				irec->ir_startino + XFS_INODES_PER_CHUNK - 1);

The above is not required since lastino is already updated by xfs_iwalk_ag()
for each inobt record it comes across. Also, 'irec' is being used outside of
the scope of its declaration resulting in a compilation error.

>  
>  	return 0;
>  }
> @@ -347,15 +352,17 @@ xfs_iwalk_run_callbacks(
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
> @@ -372,7 +379,7 @@ xfs_iwalk_run_callbacks(
>  	if (error)
>  		return error;
>  
> -	return xfs_inobt_lookup(*curpp, restart, XFS_LOOKUP_GE, has_more);
> +	return xfs_inobt_lookup(*curpp, next_agino, XFS_LOOKUP_GE, has_more);
>  }
>  
>  /* Walk all inodes in a single AG, from @iwag->startino to the end of the AG. */
> @@ -396,6 +403,7 @@ xfs_iwalk_ag(
>  
>  	while (!error && has_more) {
>  		struct xfs_inobt_rec_incore	*irec;
> +		xfs_ino_t			rec_fsino;
>  
>  		cond_resched();
>  		if (xfs_pwork_want_abort(&iwag->pwork))
> @@ -407,6 +415,15 @@ xfs_iwalk_ag(
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
> @@ -535,6 +552,7 @@ xfs_iwalk(
>  		.trim_start	= 1,
>  		.skip_empty	= 1,
>  		.pwork		= XFS_PWORK_SINGLE_THREADED,
> +		.lastino	= NULLFSINO,
>  	};
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
>  	int			error;
> @@ -623,6 +641,7 @@ xfs_iwalk_threaded(
>  		iwag->data = data;
>  		iwag->startino = startino;
>  		iwag->sz_recs = xfs_iwalk_prefetch(inode_records);
> +		iwag->lastino = NULLFSINO;
>  		xfs_pwork_queue(&pctl, &iwag->pwork);
>  		startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
>  		if (flags & XFS_INOBT_WALK_SAME_AG)
> @@ -696,6 +715,7 @@ xfs_inobt_walk(
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




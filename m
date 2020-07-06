Return-Path: <SRS0=eqR3=AR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA89C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jul 2020 13:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D56E0206DF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jul 2020 13:40:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NwRoWFRr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbgGFNkU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jul 2020 09:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729133AbgGFNkU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jul 2020 09:40:20 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08C8C061755
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jul 2020 06:40:19 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mn17so3512003pjb.4
        for <linux-xfs@vger.kernel.org>; Mon, 06 Jul 2020 06:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5Ph/q9slangCLJNE1XUYiHbhUntJwEtCZACcwqMSG5w=;
        b=NwRoWFRrq0E9UfKT4XKfDfqq6YmyTBB9NlyzZ+LP0R31w1QSxgB6z9OkB1Z623Ia9k
         zBpHGNDNeEEMPExLYlwKxpm+ThBVq2gbQsJQeaa7uvrjjH4gCaGtdtFWiqPqn1CjrptH
         vDC01YW1NPTwdVGF4MCafIHY7J6c1rYYCcrrxxF/pD2rpAy0InlAB4/njHRg+rKK8huh
         9f4XxiopM/plLHB5qKNXlbIjW6VJZDM65hfXn28m12rqsq6geTY3D5CSnh8SAeeDRzv3
         bkVncLf10pYzzLkEP8OIdjeoybkQhGuC5ruznXhoEdNgIKxF/F42CYcVVUKJ43L5sBT6
         aztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Ph/q9slangCLJNE1XUYiHbhUntJwEtCZACcwqMSG5w=;
        b=q5u2rFRoJZjD91Zb7pLrHIEyw+u3kwRydSZ2gspLbL/L+XIHqYH+Sjm4KaX+ykrkK4
         +1MOywLdLoXThZCCJULNOWP0HcG2H1VLgVmHHH8vconH6np1grDaQ8YFOYxorRqmwVz1
         im4Pb+txT7QS21byFqi8gdIcTn1QOqHSO0rgitb0kVHFraQ5LuDDn6TSeDtbDrZ3N2Yj
         4JSOTVMgo8uQU4sZGtMYo3M6iGIxnpsyAQ4GOjrVbWwRlsn3sYSjugK1MDfkwvTz3gVe
         wKja9G2/KemUmzUDIW8c18D3VPYJrPpEMMIjK61UuQaIetAYAPZhkIG3zo+eeNSRCjhX
         JJDQ==
X-Gm-Message-State: AOAM533oQb1HjJOYUPFJlm/shj1GGH7I8E45VEHs8i6izYm5byBvdr+m
        R7Pa1SQOAtaa5hJ2h8DQWUmUcuhm
X-Google-Smtp-Source: ABdhPJw3DKpz8InsBNIl3PFJWe3GQJPn6F/0EjzOy8ScHGM+Fj5vDfOxlJlqVJ3IphOisDnCOyvyhA==
X-Received: by 2002:a17:90a:c087:: with SMTP id o7mr48684249pjs.37.1594042819539;
        Mon, 06 Jul 2020 06:40:19 -0700 (PDT)
Received: from garuda.localnet ([122.167.225.228])
        by smtp.gmail.com with ESMTPSA id f72sm19634674pfa.66.2020.07.06.06.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 06:40:19 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/18] xfs: refactor xfs_trans_apply_dquot_deltas
Date:   Mon, 06 Jul 2020 19:10:16 +0530
Message-ID: <2009509.OecK6LfPaT@garuda>
In-Reply-To: <159353181889.2864738.7577728127911412217.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia> <159353181889.2864738.7577728127911412217.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 30 June 2020 9:13:38 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hoist the code that adjusts the incore quota reservation count
> adjustments into a separate function, both to reduce the level of
> indentation and also to reduce the amount of open-coded logic.
>

The changes are logically consistent with the previous behaviour.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_trans_dquot.c |  103 +++++++++++++++++++++-------------------------
>  1 file changed, 46 insertions(+), 57 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 30a011dc9828..701923ea6c04 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -293,6 +293,37 @@ xfs_trans_dqlockedjoin(
>  	}
>  }
>  
> +/* Apply dqtrx changes to the quota reservation counters. */
> +static inline void
> +xfs_apply_quota_reservation_deltas(
> +	struct xfs_dquot_res	*res,
> +	uint64_t		reserved,
> +	int64_t			res_used,
> +	int64_t			count_delta)
> +{
> +	if (reserved != 0) {
> +		/*
> +		 * Subtle math here: If reserved > res_used (the normal case),
> +		 * we're simply subtracting the unused transaction quota
> +		 * reservation from the dquot reservation.
> +		 *
> +		 * If, however, res_used > reserved, then we have allocated
> +		 * more quota blocks than were reserved for the transaction.
> +		 * We must add that excess to the dquot reservation since it
> +		 * tracks (usage + resv) and by definition we didn't reserve
> +		 * that excess.
> +		 */
> +		res->reserved -= abs(reserved - res_used);
> +	} else if (count_delta != 0) {
> +		/*
> +		 * These blks were never reserved, either inside a transaction
> +		 * or outside one (in a delayed allocation). Also, this isn't
> +		 * always a negative number since we sometimes deliberately
> +		 * skip quota reservations.
> +		 */
> +		res->reserved += count_delta;
> +	}
> +}
>  
>  /*
>   * Called by xfs_trans_commit() and similar in spirit to
> @@ -327,6 +358,8 @@ xfs_trans_apply_dquot_deltas(
>  		xfs_trans_dqlockedjoin(tp, qa);
>  
>  		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
> +			uint64_t	blk_res_used;
> +
>  			qtrx = &qa[i];
>  			/*
>  			 * The array of dquots is filled
> @@ -396,71 +429,27 @@ xfs_trans_apply_dquot_deltas(
>  			 * In case of delayed allocations, there's no
>  			 * reservation that a transaction structure knows of.
>  			 */
> -			if (qtrx->qt_blk_res != 0) {
> -				uint64_t	blk_res_used = 0;
> +			blk_res_used = max_t(int64_t, 0, qtrx->qt_bcount_delta);
> +			xfs_apply_quota_reservation_deltas(&dqp->q_blk,
> +					qtrx->qt_blk_res, blk_res_used,
> +					qtrx->qt_bcount_delta);
>  
> -				if (qtrx->qt_bcount_delta > 0)
> -					blk_res_used = qtrx->qt_bcount_delta;
> -
> -				if (qtrx->qt_blk_res != blk_res_used) {
> -					if (qtrx->qt_blk_res > blk_res_used)
> -						dqp->q_blk.reserved -= (xfs_qcnt_t)
> -							(qtrx->qt_blk_res -
> -							 blk_res_used);
> -					else
> -						dqp->q_blk.reserved -= (xfs_qcnt_t)
> -							(blk_res_used -
> -							 qtrx->qt_blk_res);
> -				}
> -			} else {
> -				/*
> -				 * These blks were never reserved, either inside
> -				 * a transaction or outside one (in a delayed
> -				 * allocation). Also, this isn't always a
> -				 * negative number since we sometimes
> -				 * deliberately skip quota reservations.
> -				 */
> -				if (qtrx->qt_bcount_delta) {
> -					dqp->q_blk.reserved +=
> -					      (xfs_qcnt_t)qtrx->qt_bcount_delta;
> -				}
> -			}
>  			/*
>  			 * Adjust the RT reservation.
>  			 */
> -			if (qtrx->qt_rtblk_res != 0) {
> -				if (qtrx->qt_rtblk_res != qtrx->qt_rtblk_res_used) {
> -					if (qtrx->qt_rtblk_res >
> -					    qtrx->qt_rtblk_res_used)
> -					       dqp->q_rtb.reserved -= (xfs_qcnt_t)
> -						       (qtrx->qt_rtblk_res -
> -							qtrx->qt_rtblk_res_used);
> -					else
> -					       dqp->q_rtb.reserved -= (xfs_qcnt_t)
> -						       (qtrx->qt_rtblk_res_used -
> -							qtrx->qt_rtblk_res);
> -				}
> -			} else {
> -				if (qtrx->qt_rtbcount_delta)
> -					dqp->q_rtb.reserved +=
> -					    (xfs_qcnt_t)qtrx->qt_rtbcount_delta;
> -			}
> +			xfs_apply_quota_reservation_deltas(&dqp->q_rtb,
> +					qtrx->qt_rtblk_res,
> +					qtrx->qt_rtblk_res_used,
> +					qtrx->qt_rtbcount_delta);
>  
>  			/*
>  			 * Adjust the inode reservation.
>  			 */
> -			if (qtrx->qt_ino_res != 0) {
> -				ASSERT(qtrx->qt_ino_res >=
> -				       qtrx->qt_ino_res_used);
> -				if (qtrx->qt_ino_res > qtrx->qt_ino_res_used)
> -					dqp->q_ino.reserved -= (xfs_qcnt_t)
> -						(qtrx->qt_ino_res -
> -						 qtrx->qt_ino_res_used);
> -			} else {
> -				if (qtrx->qt_icount_delta)
> -					dqp->q_ino.reserved +=
> -					    (xfs_qcnt_t)qtrx->qt_icount_delta;
> -			}
> +			ASSERT(qtrx->qt_ino_res >= qtrx->qt_ino_res_used);
> +			xfs_apply_quota_reservation_deltas(&dqp->q_ino,
> +					qtrx->qt_ino_res,
> +					qtrx->qt_ino_res_used,
> +					qtrx->qt_icount_delta);
>  
>  			ASSERT(dqp->q_blk.reserved >= dqp->q_blk.count);
>  			ASSERT(dqp->q_ino.reserved >= dqp->q_ino.count);
> 
> 


-- 
chandan




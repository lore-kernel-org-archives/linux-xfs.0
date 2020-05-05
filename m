Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B6FC47256
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 07:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5910A20663
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 07:32:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DZP8K4KY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgEEHce (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 03:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725320AbgEEHcd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 03:32:33 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDECC061A0F
        for <linux-xfs@vger.kernel.org>; Tue,  5 May 2020 00:32:33 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 18so468081pfv.8
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 00:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FXEycHnkWq0hk0WjBOgToGfyO4Yp1TxQ8ovFfKF5rnE=;
        b=DZP8K4KY/+CzsmfewVz/9PyLgx4nhFrGIiHk5OCt59VqsdsEVKZn73fTw3C+vaCDum
         vzkqv0GG3gnNOur7FcqgVlzThvRDdumu/ktKhAYtClpbzq6/Nrqtxy1QmuucaAcaB4D6
         THghSFVvCQsnE5jWUXDHQeOdKHAI+TiDZefIa7Ozwp2I8797//e3AIIFk+Im/0VQZErg
         U/ANkLK2FFEKa3y+m1sf0+Y9CrPlLq5Ou7b5nrDw+U0pp6l+fMKMKL7iYAQwsHcABZx2
         GmlKFDJjT0TsQH0PMKgYUGs8iqSJjdpHYBGcyAJmfITuYmiSLDx9OkvbZMNHaaLfhtjQ
         Ettw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FXEycHnkWq0hk0WjBOgToGfyO4Yp1TxQ8ovFfKF5rnE=;
        b=InkGizSN39QDr8h+shJCg4XHi5moxY4fVghKmQGaICi2ZUIBQ0K0i27+XV7ZMcggHM
         ALN+0XyEqxzhXwyf45nLIyPqG8/Is4WNWmYyUAqPyDc8zzoSzEmtYXMManiHRY4/UEYp
         kpyUNYPzi8FuttXHmEMapcm7tv8BDnqrOA8Vxszh5CiSbZBEsaSLBbKccrvrTNjtJiRZ
         42Sksn+sZvyjweWSFgnQNK7PJz1Uh2nIXqjkzn+L+y/5iHoOpIEhF4Z9JVsP+EU/JZrV
         vOn0udChPyVyifJRVfOKaUps60UokIwoSZEakdCDI9pUoBzWeJVJ3MFYe0SDJADtkCLS
         gklg==
X-Gm-Message-State: AGi0PubbuXsBJsoAhAWFW7/Vi+kWaV/HamsiAiEh8GCBnkA8gqVft1Ox
        awifFfNHVMU2KsDWNPS2bI358e40bFg=
X-Google-Smtp-Source: APiQypIX1zfoajg4EPsG9AlXiOelzsE7SWLh8IXwvwQ0JGp8y/eErvKTcJ+Qu/TL0Npag5IKvQjTfw==
X-Received: by 2002:a63:6543:: with SMTP id z64mr1869368pgb.260.1588663952928;
        Tue, 05 May 2020 00:32:32 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id j32sm945387pgb.55.2020.05.05.00.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 00:32:32 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/28] xfs: remove log recovery quotaoff item dispatch for pass2 commit functions
Date:   Tue, 05 May 2020 13:02:30 +0530
Message-ID: <1738067.pr95DSMXaA@garuda>
In-Reply-To: <158864111362.182683.13426589599394215389.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864111362.182683.13426589599394215389.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:41:53 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Quotaoff doesn't actually do anything, so take advantage of the
> commit_pass2 pointer being optional and get rid of the switch
> statement clause.
>

If we did have an invalid item the check in xlog_recover_commit_trans() would
have caught it. Hence we don't require yet another invalid item type check.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dquot_item_recover.c |    1 +
>  fs/xfs/xfs_log_recover.c        |   33 ++++++---------------------------
>  2 files changed, 7 insertions(+), 27 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> index 07ff943972a3..a07c1c8344d8 100644
> --- a/fs/xfs/xfs_dquot_item_recover.c
> +++ b/fs/xfs/xfs_dquot_item_recover.c
> @@ -197,4 +197,5 @@ xlog_recover_quotaoff_commit_pass1(
>  const struct xlog_recover_item_ops xlog_quotaoff_item_ops = {
>  	.item_type		= XFS_LI_QUOTAOFF,
>  	.commit_pass1		= xlog_recover_quotaoff_commit_pass1,
> +	.commit_pass2		= NULL, /* nothing to do in pass2 */
>  };
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index a5158e9e0662..929e2caeeb42 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2034,31 +2034,6 @@ xlog_buf_readahead(
>  		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
>  }
>  
> -STATIC int
> -xlog_recover_commit_pass2(
> -	struct xlog			*log,
> -	struct xlog_recover		*trans,
> -	struct list_head		*buffer_list,
> -	struct xlog_recover_item	*item)
> -{
> -	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS2);
> -
> -	if (item->ri_ops && item->ri_ops->commit_pass2)
> -		return item->ri_ops->commit_pass2(log, buffer_list, item,
> -				trans->r_lsn);
> -
> -	switch (ITEM_TYPE(item)) {
> -	case XFS_LI_QUOTAOFF:
> -		/* nothing to do in pass2 */
> -		return 0;
> -	default:
> -		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
> -			__func__, ITEM_TYPE(item));
> -		ASSERT(0);
> -		return -EFSCORRUPTED;
> -	}
> -}
> -
>  STATIC int
>  xlog_recover_items_pass2(
>  	struct xlog                     *log,
> @@ -2070,8 +2045,12 @@ xlog_recover_items_pass2(
>  	int				error = 0;
>  
>  	list_for_each_entry(item, item_list, ri_list) {
> -		error = xlog_recover_commit_pass2(log, trans,
> -					  buffer_list, item);
> +		trace_xfs_log_recover_item_recover(log, trans, item,
> +				XLOG_RECOVER_PASS2);
> +
> +		if (item->ri_ops->commit_pass2)
> +			error = item->ri_ops->commit_pass2(log, buffer_list,
> +					item, trans->r_lsn);
>  		if (error)
>  			return error;
>  	}
> 
> 


-- 
chandan




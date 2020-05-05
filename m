Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBBCC47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 13:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A58620757
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 13:19:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aYY2ciS5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgEENTY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 09:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728892AbgEENTX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 09:19:23 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96272C061A0F
        for <linux-xfs@vger.kernel.org>; Tue,  5 May 2020 06:19:23 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d184so874834pfd.4
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 06:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EhKfoILA/OHXv2dU5Q3Y+Mo5u+2QuTH2EKn1gDl77uU=;
        b=aYY2ciS58yNgr2qlH1lRWegiVefBn3/SzQcPQ/lGpI9wgmksRcynBjBznMVp4CVpa/
         SC4OhhfCw6sCpob+Hmd6oxWDPjHkRChUrUdHmuBcwFpXY7LXmaP+7tkp/VEKCHRT440i
         qa4Rh8B1/vrI9cYk0ZdCHECODtOXoVAmXO0BNMqhAJxQhpoD15LeJBH7GCSLX1QRrpWR
         h+TnzGPssqoDSA6+70gyCNJyDqYVgwqlX963HNB+JKo1xme07rqstnfid+t9dOFgBjqG
         1I3BTv55ke/VvEv9xeHIMhlEKBniiqmPdBKOKjRmhQYH6/F/fUuxvK8rmBjf4Z4u7kdq
         R4tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EhKfoILA/OHXv2dU5Q3Y+Mo5u+2QuTH2EKn1gDl77uU=;
        b=f0DRqpSuG08Wl6IF6ekme/+NJ0GYih6Vz14IdDbUYO+rs9bMZaPaMNKCueu31Qb8mt
         K+Bk8eaedjFhORXX70lMohj5Xx3ykwNveXw46HXTZpj48SdlxMPVrgsnsqt0OvSkPDit
         a+niDyeA5eskoFxwOhkXfoy31edbdkZi7Ag7RgFwHjSkLHndwbzB2RVAcW9KXksCxc+b
         U8/7MFy/ZPchacUCTNF8gbv8guniCm1+kzIlHNYB8RDOJlIi9Zww+vmnl/p0TZsjWeU+
         2UDUVSKX3UCe3syclpCa+2Ix2B5jR1shtPvxbuUYP3jGMuKXIYF3QYYhWRuz8CmGf2W+
         iB5w==
X-Gm-Message-State: AGi0PuYSQM8YQ8pwNiS9z3fUoGvza+XrLaZCwr/S5Ik5wzMtVWPWkNu/
        0bIJNF0sSFep9/pZG3WDOxg=
X-Google-Smtp-Source: APiQypKoIiMxDUtmBKLVCBVzfbHMM9uviiYSU92l8jd3uZb8yuamHJ1ODd1GL7XE4BT+jnvow7U2LA==
X-Received: by 2002:a63:151e:: with SMTP id v30mr2811910pgl.329.1588684760619;
        Tue, 05 May 2020 06:19:20 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id b8sm2030439pft.11.2020.05.05.06.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 06:19:19 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/28] xfs: refactor xlog_recover_process_unlinked
Date:   Tue, 05 May 2020 18:49:17 +0530
Message-ID: <1967481.PxtkyhZy26@garuda>
In-Reply-To: <158864115522.182683.9248036319539577559.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864115522.182683.9248036319539577559.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:42:35 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hoist the unlinked inode processing logic out of the AG loop and into
> its own function.  No functional changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_unlink_recover.c |   91 +++++++++++++++++++++++++------------------
>  1 file changed, 52 insertions(+), 39 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_unlink_recover.c b/fs/xfs/xfs_unlink_recover.c
> index 2a19d096e88d..413b34085640 100644
> --- a/fs/xfs/xfs_unlink_recover.c
> +++ b/fs/xfs/xfs_unlink_recover.c
> @@ -145,54 +145,67 @@ xlog_recover_process_one_iunlink(
>   * scheduled on this CPU to ensure other scheduled work can run without undue
>   * latency.
>   */
> -void
> -xlog_recover_process_unlinked(
> -	struct xlog		*log)
> +STATIC int
> +xlog_recover_process_iunlinked(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno)
>  {
> -	struct xfs_mount	*mp;
>  	struct xfs_agi		*agi;
>  	struct xfs_buf		*agibp;
> -	xfs_agnumber_t		agno;
>  	xfs_agino_t		agino;
>  	int			bucket;
>  	int			error;
>  
> -	mp = log->l_mp;
> -
> -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		/*
> -		 * Find the agi for this ag.
> -		 */
> -		error = xfs_read_agi(mp, NULL, agno, &agibp);
> -		if (error) {
> -			/*
> -			 * AGI is b0rked. Don't process it.
> -			 *
> -			 * We should probably mark the filesystem as corrupt
> -			 * after we've recovered all the ag's we can....
> -			 */
> -			continue;
> -		}
> +	/*
> +	 * Find the agi for this ag.
> +	 */
> +	error = xfs_read_agi(mp, NULL, agno, &agibp);
> +	if (error) {
>  		/*
> -		 * Unlock the buffer so that it can be acquired in the normal
> -		 * course of the transaction to truncate and free each inode.
> -		 * Because we are not racing with anyone else here for the AGI
> -		 * buffer, we don't even need to hold it locked to read the
> -		 * initial unlinked bucket entries out of the buffer. We keep
> -		 * buffer reference though, so that it stays pinned in memory
> -		 * while we need the buffer.
> +		 * AGI is b0rked. Don't process it.
> +		 *
> +		 * We should probably mark the filesystem as corrupt
> +		 * after we've recovered all the ag's we can....
>  		 */
> -		agi = agibp->b_addr;
> -		xfs_buf_unlock(agibp);
> -
> -		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
> -			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
> -			while (agino != NULLAGINO) {
> -				agino = xlog_recover_process_one_iunlink(mp,
> -							agno, agino, bucket);
> -				cond_resched();
> -			}
> +		return error;


This causes a change in behaviour i.e. an error return from here would cause
xlog_recover_process_unlinked() to break "loop on all AGs". Before this
change, XFS would continue to process all the remaining AGs as described by
the above comment.


> +	}
> +
> +	/*
> +	 * Unlock the buffer so that it can be acquired in the normal
> +	 * course of the transaction to truncate and free each inode.
> +	 * Because we are not racing with anyone else here for the AGI
> +	 * buffer, we don't even need to hold it locked to read the
> +	 * initial unlinked bucket entries out of the buffer. We keep
> +	 * buffer reference though, so that it stays pinned in memory
> +	 * while we need the buffer.
> +	 */
> +	agi = agibp->b_addr;
> +	xfs_buf_unlock(agibp);
> +
> +	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
> +		agino = be32_to_cpu(agi->agi_unlinked[bucket]);
> +		while (agino != NULLAGINO) {
> +			agino = xlog_recover_process_one_iunlink(mp,
> +						agno, agino, bucket);
> +			cond_resched();
>  		}
> -		xfs_buf_rele(agibp);
> +	}
> +	xfs_buf_rele(agibp);
> +
> +	return 0;
> +}
> +
> +void
> +xlog_recover_process_unlinked(
> +	struct xlog		*log)
> +{
> +	struct xfs_mount	*mp = log->l_mp;
> +	xfs_agnumber_t		agno;
> +	int			error;
> +
> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> +		error = xlog_recover_process_iunlinked(mp, agno);
> +		if (error)
> +			break;
>  	}
>  }
> 
> 


-- 
chandan




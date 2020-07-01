Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6463CC433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40ABA2074D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:34:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rWMSZpGR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgGAIes (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728721AbgGAIer (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:34:47 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584FFC061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:34:47 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bf7so312218plb.2
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2020 01:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T/An2KQ+AKl1UfdUo506gbWwJr3QN1MKMNuthzASQKU=;
        b=rWMSZpGRIw/wvpExgVWePscR3lljSoOfvpWbViuY5T4rWppom6alm7/xJBn7PRHPB/
         irJHqTJ3SNqfHik7KSgpDOrdaVbYGFuRu3D0WnnC9++jRxp0F68EHDePvcRuzg1UnC7J
         w53KfClQJC53Vu4lLmj7n+UUGClO+iYp15MeHF2jxtnX+bJ3rZzpOBgH/LZ6A5T+qCKN
         HRHQgzij8NbRHJFUHEdSF3Ae4x+1FGCIqpdHiH2CQ31xa1EYBdP2/Ips9jLswiz3SI0Y
         4mmkJ82SfPwgU5fDehcTtO0pQ+3WjDkq2mtEdWL7RN9oNOPKNTp7X11FXUm2Vj98KSW3
         E1HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T/An2KQ+AKl1UfdUo506gbWwJr3QN1MKMNuthzASQKU=;
        b=sWUNoyNNLV21U/JTZ1g3fZUTrhKhH4n15DRQdlvlAPCCRj0IQnR/dU0ydeC4qREFoR
         N0q5XLd79GFVbHTRwdFXYyh5DBLS3vlXlCdoeyzdn35I1xcWYh7QD3SXOlZKx6SXyYFz
         /3V/lY4GJkYZHr8ln+GQtF37NMUzNI6Jyj54nnbeeaUIv4QyxpEIUiIuDBZ9dMejX0Vm
         qrLyaQbtEbZx8Y7gV+hBoXV408UdrY7L9YI2Tpep+Fsk8iq2LebJ+u69yzVj9kOPempV
         wSb6u8+yp1w1ffPFKTWAG6aJmYoUNvLRXk2pXKmWRergMIfGZR1lcRrKPbl15MgrqvrI
         XjPw==
X-Gm-Message-State: AOAM533DV/EoiokB2OE4MS49hxPCQwGoSE6tZdlZ2ePnvWFCy3jkrHsa
        TVLl3EkwkVvk2J190krdSF4=
X-Google-Smtp-Source: ABdhPJxoKX+lvbOsy+Q32QjRWLZ1e7dlSuvtzTeHH6WRWx5aTckcFaKd+Yum3m1qgqORl0vMpO0mbQ==
X-Received: by 2002:a17:90a:319:: with SMTP id 25mr27717038pje.77.1593592486907;
        Wed, 01 Jul 2020 01:34:46 -0700 (PDT)
Received: from garuda.localnet ([122.171.188.144])
        by smtp.gmail.com with ESMTPSA id 63sm5083879pfd.65.2020.07.01.01.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 01:34:46 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/18] xfs: validate ondisk/incore dquot flags
Date:   Wed, 01 Jul 2020 14:03:10 +0530
Message-ID: <2301729.XddXFWAJP6@garuda>
In-Reply-To: <159353172899.2864738.6438709598863248951.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia> <159353172899.2864738.6438709598863248951.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 30 June 2020 9:12:09 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> While loading dquot records off disk, make sure that the quota type
> flags are the same between the incore dquot and the ondisk dquot.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dquot.c |   23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index d5b7f03e93c8..46c8ca83c04d 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -524,13 +524,27 @@ xfs_dquot_alloc(
>  }
>  
>  /* Copy the in-core quota fields in from the on-disk buffer. */
> -STATIC void
> +STATIC int
>  xfs_dquot_from_disk(
>  	struct xfs_dquot	*dqp,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
>  
> +	/*
> +	 * The only field the verifier didn't check was the quota type flag, so
> +	 * do that here.
> +	 */
> +	if ((dqp->dq_flags & XFS_DQ_ALLTYPES) !=
> +	    (ddqp->d_flags & XFS_DQ_ALLTYPES) ||
> +	    dqp->q_core.d_id != ddqp->d_id) {
> +		xfs_alert(bp->b_mount,
> +			  "Metadata corruption detected at %pS, quota %u",
> +			  __this_address, be32_to_cpu(dqp->q_core.d_id));
> +		xfs_alert(bp->b_mount, "Unmount and run xfs_repair");
> +		return -EFSCORRUPTED;
> +	}
> +
>  	/* copy everything from disk dquot to the incore dquot */
>  	memcpy(&dqp->q_core, ddqp, sizeof(struct xfs_disk_dquot));
>  
> @@ -544,6 +558,7 @@ xfs_dquot_from_disk(
>  
>  	/* initialize the dquot speculative prealloc thresholds */
>  	xfs_dquot_set_prealloc_limits(dqp);
> +	return 0;
>  }
>  
>  /* Allocate and initialize the dquot buffer for this in-core dquot. */
> @@ -617,9 +632,11 @@ xfs_qm_dqread(
>  	 * further.
>  	 */
>  	ASSERT(xfs_buf_islocked(bp));
> -	xfs_dquot_from_disk(dqp, bp);
> -
> +	error = xfs_dquot_from_disk(dqp, bp);
>  	xfs_buf_relse(bp);
> +	if (error)
> +		goto err;
> +
>  	*dqpp = dqp;
>  	return error;
>  
> 
> 


-- 
chandan




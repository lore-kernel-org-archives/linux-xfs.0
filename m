Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1BD3C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 12:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D00E520657
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 12:50:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kykmV4AI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731183AbgGOMub (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 08:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728766AbgGOMua (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 08:50:30 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C81C061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 05:50:30 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id b9so2353803plx.6
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 05:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5rFIFsXaK22E6KfZDjA78UkkLrTEHe59WT74SIxiDQE=;
        b=kykmV4AIve72ID+XZQ8HwibEfScwzBXUinIcOgyMTQRdvBktNHdFCHkFxVWjm66PwP
         aLbbKAuG1O5h8/G2onepEUnVidWPIooEOnIAxe9wsiUy3RuFjaxmddNwDxCR4lHf2v5X
         3GngncK36bZHPGcHfHAPgTIHqowrPhfQh/1mYnGm0ZCJo5Mf1xHkG20iC6fTl1UNNv/O
         gZbnCkagbuFyb9RQL8tag0vZWRzar23bAsVyr3HtvSg8vQnp+ZLgsxiwEIVsoxTh+0wq
         iwPvrP+XAuzQddk2t8CJgQswqEBqjZkZFR9c1IHVqsPjJDBjdMUA1R43CXoVPRhDCCJA
         zaAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5rFIFsXaK22E6KfZDjA78UkkLrTEHe59WT74SIxiDQE=;
        b=J6gy8iu2E1VGWLFe/U4m+qtsnvWeFyNnGkufP3po/9flDvNlWji0+IL5/h7UsUgWb1
         B29NsJa00hvQvuPGo7I0mmX8DjBxP4DqfZzel8uTugIpyEiIlB2jq3yjrBU9wWIt5AWn
         FmC61k1G0UYS59oXUe7C8MeeXGu8D371kALE5G2woY214WHzjaevBqhiShtaJ5bbWK9n
         ajMeff3IxG/oUSkROTEI5qdgI4rSrjwyDS+Sj0CO2NhwuBCL74KPGuivA/nuWZOhptjU
         y+e6Ql3r5CY0EBNba4IoD7pVEB/a6O3pXFphArLdJ05Ekt9JU/DzjujMwBMKJ8qq00ef
         snZw==
X-Gm-Message-State: AOAM5325dsu1+m8qvBzh9c/Zz6JYTDiG38G042DqfjvikNO+20V7NfBm
        FSyLpnMbMabAbl5cFQsUwM36OjvR
X-Google-Smtp-Source: ABdhPJxjZWUA9QgZjqSbi0J0ctol3XngF2CSspOSkzEkUBGPUGo6Io2/Z0zltcbSzC+s3fsCW9nxCw==
X-Received: by 2002:a17:90a:f2c3:: with SMTP id gt3mr10476650pjb.92.1594817429303;
        Wed, 15 Jul 2020 05:50:29 -0700 (PDT)
Received: from garuda.localnet ([122.171.186.26])
        by smtp.gmail.com with ESMTPSA id l16sm2174095pff.167.2020.07.15.05.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 05:50:28 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/26] xfs: validate ondisk/incore dquot flags
Date:   Wed, 15 Jul 2020 18:20:02 +0530
Message-ID: <2742268.hU260WgNyQ@garuda>
In-Reply-To: <159477785242.3263162.9079810070691814130.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia> <159477785242.3263162.9079810070691814130.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 15 July 2020 7:20:52 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> While loading dquot records off disk, make sure that the quota type
> flags are the same between the incore dquot and the ondisk dquot.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_dquot.c |   23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 76353c9a723e..7503c6695569 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -23,6 +23,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
>  #include "xfs_bmap_btree.h"
> +#include "xfs_error.h"
>  
>  /*
>   * Lock order:
> @@ -524,13 +525,26 @@ xfs_dquot_alloc(
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
> +	 * Ensure that we got the type and ID we were looking for.
> +	 * Everything else was checked by the dquot buffer verifier.
> +	 */
> +	if ((ddqp->d_flags & XFS_DQ_ALLTYPES) != dqp->dq_flags ||
> +	    ddqp->d_id != dqp->q_core.d_id) {
> +		xfs_alert_tag(bp->b_mount, XFS_PTAG_VERIFIER_ERROR,
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




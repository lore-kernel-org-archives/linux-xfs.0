Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BC5C47089
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Nov 2022 23:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbiK1Xa3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Nov 2022 18:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234699AbiK1Xa0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2022 18:30:26 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8361B326C7
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 15:30:25 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 140so12043590pfz.6
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 15:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/IOdLakO8ABzwedxcWnJjqY7QmYuZp1ksWCsEyktvNU=;
        b=PtcaLdolfbI94PbhXibpQKT3kTDVpj5StkWff66CamClwVtgwuHdz2As4Z3QRSN282
         011VXWnFgZ/EZmSIom53Xv59tPEhC1Xwe/PFiI27cVgCQTM9T9R8mVa4vKFiJiR232Wf
         ddA8MYl4JeXZ/P+OiGT8D0Z+HbriyigoQZJIDH026ZStcEnWkmxSpfdXzVjRUb0ZoCEH
         rR01rIxT/4eNk2U4lshXGtXmlIatyPrKM0ZbYoVeAGhNz1bzqDHddu8ewFuRIkswkXIh
         5dNWDCxEdufAUoDMzYGocUV7DEf4M0pY0lWRnW55Pg2b3bLm/GVJSkq9nckhYCTPPgdf
         WqLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/IOdLakO8ABzwedxcWnJjqY7QmYuZp1ksWCsEyktvNU=;
        b=w00vL0dt5Kl7+uwZOILWE6A4HuqktTwnB5AUmx4mkEcAx87kCRfJurVJxkpwVjUxoN
         de01VPSLaCxSfqlREmQgWDRPg8PwGn+5lzuuK+iTLiWN7f53f/51++Dj/9AtfE1NiXuE
         0p8p00d/MIkHgvFN3+hJ2lw4tU700Ef6xtQCdCXELkhFTb7xFqxh2VI5U171EQgVgy9p
         o9Q9hqPNVyrKq0DnpAzCrJhQaBDOO+vh04SpbHcrUzknHqQwZmX2vmbgwHNygD9Y9rZR
         8X7CGf7nKbuLUzb0peW37nNdSenTnKz0l/DvBtvckiq3wcv8gmqdiTrhP2Jx7yBrcmWA
         PiYg==
X-Gm-Message-State: ANoB5pmUzGoq8WjuSazTSAGoZeJsZWvRKD8eBRJbM/GElA3JRGUJcbdE
        JZP7PmQedIUvnRsZg2q3JHT0ew==
X-Google-Smtp-Source: AA0mqf4JmVyGWh8FDppfBxU7twvNjlK/KE39hRc6cK8T+LFASUKJBCiMhv/OXmjKY1hNNnnVB7Nmnw==
X-Received: by 2002:a62:e908:0:b0:574:53f4:c4d6 with SMTP id j8-20020a62e908000000b0057453f4c4d6mr28979951pfh.81.1669678224991;
        Mon, 28 Nov 2022 15:30:24 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id o25-20020aa79799000000b0056c3a0dc65fsm8501769pfp.71.2022.11.28.15.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 15:30:24 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oznZt-002DMH-G8; Tue, 29 Nov 2022 10:30:21 +1100
Date:   Tue, 29 Nov 2022 10:30:21 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 10/9] xfs: add debug knob to slow down writeback for fun
Message-ID: <20221128233021.GW3600936@dread.disaster.area>
References: <20221123055812.747923-1-david@fromorbit.com>
 <Y4U3XWf5j1zVGvV4@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4U3XWf5j1zVGvV4@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 28, 2022 at 02:34:05PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a new error injection knob so that we can arbitrarily slow down
> writeback to test for race conditions and aberrant reclaim behavior if
> the writeback mechanisms are slow to issue writeback.  This will enable
> functional testing for the ifork sequence counters introduced in commit
> 745b3f76d1c8 ("xfs: maintain a sequence count for inode fork
> manipulations").
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_errortag.h |    4 +++-
>  fs/xfs/xfs_aops.c            |   12 ++++++++++--
>  fs/xfs/xfs_error.c           |   11 +++++++++++
>  fs/xfs/xfs_error.h           |   22 ++++++++++++++++++++++
>  4 files changed, 46 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 580ccbd5aadc..f5f629174eca 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -61,7 +61,8 @@
>  #define XFS_ERRTAG_LARP					39
>  #define XFS_ERRTAG_DA_LEAF_SPLIT			40
>  #define XFS_ERRTAG_ATTR_LEAF_TO_NODE			41
> -#define XFS_ERRTAG_MAX					42
> +#define XFS_ERRTAG_WB_DELAY_MS				42
> +#define XFS_ERRTAG_MAX					43
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -107,5 +108,6 @@
>  #define XFS_RANDOM_LARP					1
>  #define XFS_RANDOM_DA_LEAF_SPLIT			1
>  #define XFS_RANDOM_ATTR_LEAF_TO_NODE			1
> +#define XFS_RANDOM_WB_DELAY_MS				3000
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index a22d90af40c8..4a13260527b9 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -17,6 +17,8 @@
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_util.h"
>  #include "xfs_reflink.h"
> +#include "xfs_errortag.h"
> +#include "xfs_error.h"
>  
>  struct xfs_writepage_ctx {
>  	struct iomap_writepage_ctx ctx;
> @@ -217,11 +219,15 @@ xfs_imap_valid(
>  	 * checked (and found nothing at this offset) could have added
>  	 * overlapping blocks.
>  	 */
> -	if (XFS_WPC(wpc)->data_seq != READ_ONCE(ip->i_df.if_seq))
> +	if (XFS_WPC(wpc)->data_seq != READ_ONCE(ip->i_df.if_seq)) {
> +		XFS_ERRORTAG_REPORT(ip->i_mount, XFS_ERRTAG_WB_DELAY_MS);
>  		return false;
> +	}
>  	if (xfs_inode_has_cow_data(ip) &&
> -	    XFS_WPC(wpc)->cow_seq != READ_ONCE(ip->i_cowfp->if_seq))
> +	    XFS_WPC(wpc)->cow_seq != READ_ONCE(ip->i_cowfp->if_seq)) {
> +		XFS_ERRORTAG_REPORT(ip->i_mount, XFS_ERRTAG_WB_DELAY_MS);
>  		return false;

These should be tracepoints, right?

Otherwise I don't see a problem with the delay code.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

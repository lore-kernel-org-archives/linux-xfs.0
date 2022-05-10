Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DFEC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 21:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiEJV1l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 17:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiEJV1k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 17:27:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBF61EEC1
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 14:27:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B37AEB81FB3
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 21:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4F9C385CD;
        Tue, 10 May 2022 21:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652218056;
        bh=LtoI/Pd+kxMwozpqwTAKcca7QyevIvnuWm5gGc4+2/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G2G2FA1AvwrmwjM3H+MBSxLTx1XxcWvjTSneH4RoeBdSdvBMmWb1mNDcRw24qMrxW
         Ws5FTipOGcVCE4tahEf09w0Piox2mkqtwrMTMGGIWGFpb+6v/8EspqelVWAM8KD2tK
         TT2xo+bfDvjNkeHfXuRc6W9qyRgVokUOTTpouuWHySFeZX6WHPtfJgne6xx9c4d4Ko
         nbB2Yg9aC8p+Lrtoc9OqHoY46Te5gu4EPnSU3qT11k04s55FT2NHWtvEQlmvuLRCIo
         pvyfbnlhX3WMb4MH7QUC6fWv2ggKOFtu5Q+d0sFlYH4TZ3xe2j7IfE1TO5BZ3yajSU
         ZeXeWbWljeNgw==
Date:   Tue, 10 May 2022 14:27:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 3/3] xfs: don't set quota warning values
Message-ID: <20220510212735.GE27195@magnolia>
References: <20220510202800.40339-1-catherine.hoang@oracle.com>
 <20220510202800.40339-4-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510202800.40339-4-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 10, 2022 at 01:28:00PM -0700, Catherine Hoang wrote:
> Having just dropped support for quota warning limits and warning
> counters, the warning fields no longer have any meaning. Prevent these
> fields from being set by removing QC_WARNS_MASK from XFS_QC_SETINFO_MASK
> and XFS_QC_MASK.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

Long live quota warning counters!

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_qm_syscalls.c | 3 +--
>  fs/xfs/xfs_quotaops.c    | 2 +-
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 2149c203b1d0..74ac9ca9e119 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -217,8 +217,7 @@ xfs_qm_scall_quotaon(
>  	return 0;
>  }
>  
> -#define XFS_QC_MASK \
> -	(QC_LIMIT_MASK | QC_TIMER_MASK | QC_WARNS_MASK)
> +#define XFS_QC_MASK (QC_LIMIT_MASK | QC_TIMER_MASK)
>  
>  /*
>   * Adjust limits of this quota, and the defaults if passed in.  Returns true
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index 50391730241f..9c162e69976b 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -98,7 +98,7 @@ xfs_quota_type(int type)
>  	}
>  }
>  
> -#define XFS_QC_SETINFO_MASK (QC_TIMER_MASK | QC_WARNS_MASK)
> +#define XFS_QC_SETINFO_MASK (QC_TIMER_MASK)
>  
>  /*
>   * Adjust quota timers & warnings
> -- 
> 2.27.0
> 

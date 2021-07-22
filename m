Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59EF7C63793
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 15:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38BF761279
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 15:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhGVPLr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 11:11:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232320AbhGVPLr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jul 2021 11:11:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD8A86101E;
        Thu, 22 Jul 2021 15:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626969142;
        bh=G2N2tXfEhXFOViSYc4Rkw+VznrmRQsRShw45q4vWvE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VToqqNkRtpRtw+NL7cwUg14PHcXhQB+V0QGKRyyP/tQ009V4pHa7BFQfUDQdFooLb
         dxZCgOgS2Wnin6F7zdT0rVXP/hoAGEvzfZuyPrTnjFI9iTMy1Ber1dozHLWJvpSEP5
         gaclfYex5kpmjqmDvpNuOGv8gpizMh1sr6myN2pFoPtlW6F4p6P5PttWYNmvJJrTOc
         bwLUVFlDWwQvuP9FGAl0MZ/MtFMKnAdgDm9HLly23MXVo4bslAM00eXvYNOz9r5SmF
         +1u78C1uAQrCXB5YMj52R0NVCtSug/JjWwhAeTJg4EFmna+Y5Q6Gl6mpo6KZViww4n
         umQ72npYk37vw==
Date:   Thu, 22 Jul 2021 08:52:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: flush data dev on external log write
Message-ID: <20210722155221.GA8612@magnolia>
References: <20210722015335.3063274-1-david@fromorbit.com>
 <20210722015335.3063274-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722015335.3063274-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 11:53:31AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We incorrectly flush the log device instead of the data device when
> trying to ensure metadata is correctly on disk before writing the
> unmount record.
> 
> Fixes: eef983ffeae7 ("xfs: journal IO cache flush reductions")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

DOH

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 36fa2650b081..96434cc4df6e 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -833,7 +833,7 @@ xlog_write_unmount_record(
>  	 * stamp the tail LSN into the unmount record.
>  	 */
>  	if (log->l_targ != log->l_mp->m_ddev_targp)
> -		blkdev_issue_flush(log->l_targ->bt_bdev);
> +		blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
>  	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS);
>  }
>  
> -- 
> 2.31.1
> 

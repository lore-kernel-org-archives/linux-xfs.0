Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 587F8C47083
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 21:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AAF3613EA
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 21:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhFBVjF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 17:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229724AbhFBVjF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 17:39:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4016600D4;
        Wed,  2 Jun 2021 21:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622669841;
        bh=Fa18FW/9NCH+U0pX0zHMY0nzsNGrITGLmN+YQv66zZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KReQcXrs5O/j7oTnV5W1Ma2EqK6Md1N/0xzGtzF1V27IrvTbmj7oyqwQz9HQ+bOZn
         UyYXyldtg/TGccKZWkDT3ZeBAIs7rOjD3e/7KohlrJXDfqwCLKQ7c9KSpW10U/QUbx
         6GhBcGolcaPaQ5jxr/THAEMLSPilJsyLmy08nIEGzARPVs3E9LIMuXjr+oJn+eTTb1
         gFDydqbVPTl/lWGApqaohIY9ah0t+hmYr8M6Q+WrnCrlsAXADlHMAbWf5ia0BTa3TJ
         v+/KazkS5UOijOJR78Hmjzmj/8iHHS7rIXiUqQzHtlwJ/mFEoqxIwfknAngpqLyG0P
         QDmF2UWcLJCAg==
Date:   Wed, 2 Jun 2021 14:37:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: add a free space extent change reservation
Message-ID: <20210602213721.GM26380@locust>
References: <20210527045202.1155628-1-david@fromorbit.com>
 <20210527045202.1155628-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527045202.1155628-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 02:52:00PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Lots of the transaction reservation code reserves space for an
> extent allocation. It is inconsistently implemented, and many of
> them get it wrong. Introduce a new function to calculate the log
> space reservation for adding or removing an extent from the free
> space btrees.
> 
> This function reserves space for logging the AGF, the AGFL and the
> free space btrees, avoiding the need to account for them seperately
> in every reservation that manipulates free space.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index d1a0848cb52e..6363cacb790f 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -79,6 +79,23 @@ xfs_allocfree_log_count(
>  	return blocks;
>  }
>  
> +/*
> + * Log reservation required to add or remove a single extent to the free space
> + * btrees.  This requires modifying:
> + *
> + * the agf header: 1 sector
> + * the agfl header: 1 sector
> + * the allocation btrees: 2 trees * (max depth - 1) * block size
> + */
> +uint
> +xfs_allocfree_extent_res(
> +	struct xfs_mount *mp)
> +{
> +	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
> +	       xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> +				XFS_FSB_TO_B(mp, 1));
> +}
> +

No caller?  I think the next patch should get merged into this one.

--D

>  /*
>   * Logging inodes is really tricksy. They are logged in memory format,
>   * which means that what we write into the log doesn't directly translate into
> -- 
> 2.31.1
> 

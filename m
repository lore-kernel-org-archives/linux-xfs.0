Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62415 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753487AbdDQS15 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Apr 2017 14:27:57 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C014080F8D
        for <linux-xfs@vger.kernel.org>; Mon, 17 Apr 2017 18:27:56 +0000 (UTC)
Date: Mon, 17 Apr 2017 13:27:47 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs: remove use of do_div with 32-bit dividend in quota
 debug code
Message-ID: <20170417182747.GA24287@redhat.com>
References: <e6022a70-8f09-633d-e99a-30186ea8c3d2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6022a70-8f09-633d-e99a-30186ea8c3d2@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sat, Apr 15, 2017 at 09:46:09AM -0500, Eric Sandeen wrote:
> The kbuild test robot caught this; in debug code we have another
> caller of do_div with a 32-bit dividend (j) which is caught now
> that we are using the kernel-supplied do_div.
> 
> None of the values used here are 64-bit; just use simple division.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good.

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index b669b12..dedeb7f 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -851,8 +851,7 @@ struct xfs_qm_isolate {
>  	 * started afresh by xfs_qm_quotacheck.
>  	 */
>  #ifdef DEBUG
> -	j = XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
> -	do_div(j, sizeof(xfs_dqblk_t));
> +	j = XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) / sizeof(xfs_dqblk_t);
>  	ASSERT(mp->m_quotainfo->qi_dqperchunk == j);
>  #endif
>  	dqb = bp->b_addr;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

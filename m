Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89DDC04A95
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 19:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbiIWTVi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 15:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiIWTVf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 15:21:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B116EBD69
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 12:21:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95E9161387
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 19:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CFFC433C1;
        Fri, 23 Sep 2022 19:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663960893;
        bh=wsGWfb0utMYkk0C6MY2DOwAj7ko9EgtEHg/WM4Udeac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bl/WKbuG7Nxer+Nhihls2i1PKmWvWm//JDnhzgYuHHGIyuhtnD5KXkT3xCjhL5TF4
         ONicGKg/n4Tz42vGpw/jE3Z3UMW+TKDDjDKq6Lyl8XyxQLrc6cwmwQdma/iVHOkdmo
         ok0wR1VP4pf0mI/o71+1MvPxaLxM2mWxgp5pLd/5emRVmTdfm1UPrv6A4StSkM1ta/
         VKJhSPLVLOCzQsbEmFduFm4CCNqCsvPBDztrYzYK8nsu+yMyNfLWsQqWF51OLboZdc
         1kg8C2Pazr3pCdsbW5jzb7GgbUyBbAyYbJxUSFoVlVvqGRqGIZouH2PTWuNgUp+aVc
         LR+Oae8C84x8g==
Date:   Fri, 23 Sep 2022 12:21:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 05/26] xfs: Hold inode locks in xfs_rename
Message-ID: <Yy4HPUJR7Wathz+A@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-6-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922054458.40826-6-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 21, 2022 at 10:44:37PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Modify xfs_rename to hold all inode locks across a rename operation
> We will need this later when we add parent pointers
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 35 ++++++++++++++++++++++-------------
>  1 file changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 9a3174a8f895..4bfa4a1579f0 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2837,18 +2837,16 @@ xfs_rename(
>  	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
>  
>  	/*
> -	 * Join all the inodes to the transaction. From this point on,
> -	 * we can rely on either trans_commit or trans_cancel to unlock
> -	 * them.
> +	 * Join all the inodes to the transaction.
>  	 */
> -	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, src_dp, 0);
>  	if (new_parent)
> -		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
> +		xfs_trans_ijoin(tp, target_dp, 0);
> +	xfs_trans_ijoin(tp, src_ip, 0);
>  	if (target_ip)
> -		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
> +		xfs_trans_ijoin(tp, target_ip, 0);
>  	if (wip)
> -		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
> +		xfs_trans_ijoin(tp, wip, 0);
>  
>  	/*
>  	 * If we are using project inheritance, we only allow renames
> @@ -2862,10 +2860,12 @@ xfs_rename(
>  	}
>  
>  	/* RENAME_EXCHANGE is unique from here on. */
> -	if (flags & RENAME_EXCHANGE)
> -		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
> +	if (flags & RENAME_EXCHANGE) {
> +		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
>  					target_dp, target_name, target_ip,
>  					spaceres);
> +		goto out_unlock;
> +	}
>  
>  	/*
>  	 * Try to reserve quota to handle an expansion of the target directory.
> @@ -3090,12 +3090,21 @@ xfs_rename(
>  		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
>  
>  	error = xfs_finish_rename(tp);
> -	if (wip)
> -		xfs_irele(wip);
> -	return error;
> +
> +	goto out_unlock;
>  
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
> +out_unlock:
> +	/* Unlock inodes in reverse order */
> +	for (i = num_inodes - 1; i >= 0; i--) {
> +		if (inodes[i])
> +			xfs_iunlock(inodes[i], XFS_ILOCK_EXCL);
> +
> +		/* Skip duplicate inodes if src and target dps are the same */
> +		if (i && (inodes[i] == inodes[i - 1]))
> +			i--;
> +	}

Could you hoist this to a static inline xfs_iunlock_after_rename
function that is adjacent to xfs_sort_for_rename, please?  It's easier
to verify that it does the right thing w.r.t. multiple array references
pointing to the same incore inode when the two array management
functions are right next to each other.

static inline void
xfs_iunlock_after_rename(
	struct xfs_inode	**i_tab,
	int			num_inodes)
{
	for (i = num_inodes - 1; i >= 0; i--) {
		/* Skip duplicate inodes if src and target dps are the same */
		if (!i_tab[i] || (i > 0 && i_tab[i] == i_tab[i - 1]))
			continue;
		xfs_iunlock(i_tab[i], XFS_ILOCK_EXCL);
	}
}

With that cleaned up,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  out_release_wip:
>  	if (wip)
>  		xfs_irele(wip);
> -- 
> 2.25.1
> 

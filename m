Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 425BEC433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 19:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1B7623441
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 19:51:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388610AbhATTvf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 14:51:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388291AbhATTmv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Jan 2021 14:42:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2233923441;
        Wed, 20 Jan 2021 19:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611171727;
        bh=upIieIVmVSKrAazkCHlVjdXOGsmxIMKuz7y+gnDNlsg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Faj2q43xJDpVw+gDq3QAAHW5JQWnx5p7Pl1D8bLXpyd8HRG0OpOdw0v5dCVAM+hkz
         NTONlW++DABbMVxndCfztVbcopwRuoodUm9su/KowUR67BM+iOJ1ppHPKNtA60LTAP
         RCi57bGd/XGC+pBK8WB3H/RnYoeBS2oKtbnJf8eECQhXLeeVEhCmXCttbppW0EojJp
         4HwsK93co1mf+V0OhrS9mQ0O+ngxxldFV0UQhP8nKGdxsNyezyLPfWo8mJQAh3bbct
         MPAuu8DiLNQvepeD/SO3app2aGB0DB8e+eoV6UK1//vXxt9OwXuDSWXzQS7j0+0BhP
         XH2tTI1sxXsyg==
Date:   Wed, 20 Jan 2021 11:42:06 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] fs/xfs: convert comma to semicolon
Message-ID: <20210120194206.GP3134581@magnolia>
References: <20201211084112.1931-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211084112.1931-1-zhengyongjun3@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 11, 2020 at 04:41:12PM +0800, Zheng Yongjun wrote:
> Replace a comma between expression statements by a semicolon.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Apparently I forgot to ack this before merging it...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_btree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 2d25bab68764..51dbff9b0908 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -4070,7 +4070,7 @@ xfs_btree_delrec(
>  	 * surviving block, and log it.
>  	 */
>  	xfs_btree_set_numrecs(left, lrecs + rrecs);
> -	xfs_btree_get_sibling(cur, right, &cptr, XFS_BB_RIGHTSIB),
> +	xfs_btree_get_sibling(cur, right, &cptr, XFS_BB_RIGHTSIB);
>  	xfs_btree_set_sibling(cur, left, &cptr, XFS_BB_RIGHTSIB);
>  	xfs_btree_log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
>  
> -- 
> 2.22.0
> 

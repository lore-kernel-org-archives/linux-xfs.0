Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B19C4321A
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3159264EFD
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238399AbhCDASG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:18:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1386271AbhCCSOG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 13:14:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2ECE64E6F;
        Wed,  3 Mar 2021 18:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614795206;
        bh=c+s4B8rlEDKXoUfUpUiIaX3afcmU31NXKRsFoVg5V/g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xv+pg1XK0aZ+CaznWyCCGUkSc8TctjR4qHzE38JkJGP6VJ3uSoUlFi0N4GZxhVR0B
         zdQzvkaOFjshcqoOFduRiS2FShZRs2X/+ADicgS93lY3bQlK3ehXECfgnfF4Err5yg
         57yMGJaqxr3ta7Xe4rvL8PptOhgjVSJ21ihpcAWbvSTeppcqdZYL3Nvrm2qhrG6QMx
         2GPDWJE6JrCQaINlhHRVoYl4lkKx8wBGMZFgAt7bItv8PkLGPPCEUGDcvMGfrv4e2G
         xuKBiXs70CETsuQ7zBBj38U1ioI3kXvu+eT/d170OX4Kjp3kHKXGza4f2DOmb2GeIX
         DKhrST/YEpS6g==
Date:   Wed, 3 Mar 2021 10:13:25 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v7 1/5] xfs: update lazy sb counters immediately for
 resizefs
Message-ID: <20210303181325.GA3419940@magnolia>
References: <20210302024816.2525095-1-hsiangkao@redhat.com>
 <20210302024816.2525095-2-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302024816.2525095-2-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 10:48:12AM +0800, Gao Xiang wrote:
> sb_fdblocks will be updated lazily if lazysbcount is enabled,
> therefore when shrinking the filesystem sb_fdblocks could be
> larger than sb_dblocks and xfs_validate_sb_write() would fail.
> 
> Even for growfs case, it'd be better to update lazy sb counters
> immediately to reflect the real sb counters.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_fsops.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index a2a407039227..9f9ba8bd0213 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -128,6 +128,15 @@ xfs_growfs_data_private(
>  				 nb - mp->m_sb.sb_dblocks);
>  	if (id.nfree)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> +
> +	/*
> +	 * Sync sb counters now to reflect the updated values. This is
> +	 * particularly important for shrink because the write verifier
> +	 * will fail if sb_fdblocks is ever larger than sb_dblocks.
> +	 */
> +	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> +		xfs_log_sb(tp);
> +
>  	xfs_trans_set_sync(tp);
>  	error = xfs_trans_commit(tp);
>  	if (error)
> -- 
> 2.27.0
> 

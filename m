Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F20B2C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C425261A21
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237354AbhCXSKl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237271AbhCXSKX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:10:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C84C361A06;
        Wed, 24 Mar 2021 18:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616609423;
        bh=FWfXTxg/ArBF3nuqH8ksf1XvEQ3ktq9eyw2HJ5IzSIs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rSKW5Rc6kk/5+bkoN70uTBurytnNahZYmAhwfdjwZD6qKpD2ubJU/YCJ2wL+j2Jxn
         V3t/eGRYWfkNjHYGbz8uQXEMQ1+im6ohd0EzFAPqwPe/HS9F2/BAip9LgA8HpygiL/
         d5DEYlNagV+uqFuZoN28gEZAxR2A1j1IcxGEkJXoYTNHxQKVmtsB8jnSLDPK+XZM23
         mbBCXkoOqcWWeUrEno5AP0r5uz+4wGvbq/kkqIiKnKEuB2fo4NjTmk+rRfPvlYF3Pa
         Y+IHtBbPFvquQ3I7rydmH5OYmbpy2hgJvFhYAvcVwj6P+t9z5I7qNABOSjFg0NLmgO
         1lbjYY1F/ybHA==
Date:   Wed, 24 Mar 2021 11:10:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/18] xfs: remove the unused xfs_icdinode_has_bigtime
 helper
Message-ID: <20210324181022.GC22100@magnolia>
References: <20210324142129.1011766-1-hch@lst.de>
 <20210324142129.1011766-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324142129.1011766-5-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 03:21:15PM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Heh.  Sloppy Darrick! <slaps wrist>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.h | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 9e1ae38380b3c0..b3097ea8b53366 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -32,11 +32,6 @@ struct xfs_icdinode {
>  	struct timespec64 di_crtime;	/* time created */
>  };
>  
> -static inline bool xfs_icdinode_has_bigtime(const struct xfs_icdinode *icd)
> -{
> -	return icd->di_flags2 & XFS_DIFLAG2_BIGTIME;
> -}
> -
>  /*
>   * Inode location information.  Stored in the inode and passed to
>   * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
> -- 
> 2.30.1
> 

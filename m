Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA3BC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 18:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C10E4619DB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 18:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhC3SLB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 14:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232490AbhC3SKp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 14:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CF56619CB;
        Tue, 30 Mar 2021 18:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617127845;
        bh=cp05V6d3f8u0PW6G1YGyE6LdWqpMXbyMAveZslQx5kk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bz+OCMW+zOGJTecC7En4h1Ka6YYiYWJs3cd+lU4PUrbpvOKsDWzXO2XWTpNynIevC
         PIk7bOkqSLfmWiLvcBbLKYkQKM19pWo15wFzkqBQjZ56diV3fy3UyXUYXrYIA0JtMW
         5Zv6YZjbWacZgl2RWKyeowL0RB/YetGTBfR/RpxsG4X0CoBtw6Juq32pT9OAdA3FOO
         6GxIHBn6p5JlEuHkbBXkfP6m+pMbDOBauw7aIC+oZVrdFvHMsx4pL7o6km0KbFz2nH
         lieoQAwz6grT9Ta4FE5MRbHGYvIM4ywNvZsje2FsU+XN+m8qMcjMKq6kYhgVfqzslW
         fX9PTB0GDuGVw==
Date:   Tue, 30 Mar 2021 11:10:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: eager inode attr fork init needs attr feature
 awareness
Message-ID: <20210330181044.GV4090233@magnolia>
References: <20210330053059.1339949-1-david@fromorbit.com>
 <20210330053059.1339949-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330053059.1339949-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 04:30:56PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The pitfalls of regression testing on a machine without realising
> that selinux was disabled. Only set the attr fork during inode
> allocation if the attr feature bits are already set on the
> superblock.
> 
> Fixes: e6a688c33238 ("xfs: initialise attr fork on inode create")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks reasonable to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c09bb39baeea..3b516ab7f22b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -887,7 +887,7 @@ xfs_init_new_inode(
>  	 * this saves us from needing to run a separate transaction to set the
>  	 * fork offset in the immediate future.
>  	 */
> -	if (init_xattrs) {
> +	if (init_xattrs && xfs_sb_version_hasattr(&mp->m_sb)) {
>  		ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
>  		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
>  	}
> -- 
> 2.31.0
> 

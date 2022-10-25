Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 955C4FA3741
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 21:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbiJYVeX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 17:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbiJYVeW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 17:34:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F205D10AC12
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 14:34:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91B6F61B89
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 21:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC33CC433C1;
        Tue, 25 Oct 2022 21:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666733661;
        bh=UXsw2QiQn75GKqlEKr4q1FYK9HZ8ld6PktGutK0irxw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XoPlH802rg7F4IEZQJrGoNGWTXyZt4AC+IvXcex1gEGSNW9FFHG5pL1Do/i1w2Nac
         wup25KNDMPTP27NwPn2twUZUgTUu/c00MH3JK8YC7iyfja79OphrHHtuzL2pRwtNgD
         Dzxdp8p1ai/2gVE2VN0710msevWe8X4WNgrfo07DRQAeHUoPi6ySeXIb4jipJDmbzN
         b9Lu8TW+OcerU/pT1pYX6nKEcELGy9pbAnNC35sU2SUxxn1eIimQ3+Je9UhPQP3g6W
         kFWD02XpYmaXX+Nnnq41OwZkn9/6LsvMrNeyOpyblThM807ZFX4KrQ6P9uLzBUcah0
         03LB2cOVMceiA==
Date:   Tue, 25 Oct 2022 14:34:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 24/27] xfs: Filter XFS_ATTR_PARENT for getfattr
Message-ID: <Y1hWXBsi/BPii7qW@magnolia>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
 <20221021222936.934426-25-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021222936.934426-25-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 21, 2022 at 03:29:33PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Parent pointers returned to the get_fattr tool cause errors since
> the tool cannot parse parent pointers.  Fix this by filtering parent
> parent pointers from xfs_xattr_put_listent.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_xattr.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index d9067c5f6bd6..5b57f6348d63 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -234,6 +234,9 @@ xfs_xattr_put_listent(
>  
>  	ASSERT(context->count >= 0);
>  
> +	if (flags & XFS_ATTR_PARENT)
> +		return;
> +
>  	if (flags & XFS_ATTR_ROOT) {
>  #ifdef CONFIG_XFS_POSIX_ACL
>  		if (namelen == SGI_ACL_FILE_SIZE &&
> -- 
> 2.25.1
> 

Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D69C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 17:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbiDLRIs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 13:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354692AbiDLRIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 13:08:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C95F60AA8
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 10:06:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED9FEB81F2A
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 17:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B5DC385A5;
        Tue, 12 Apr 2022 17:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649783186;
        bh=RByuzeI3uMsD1ezDXTLtWyXFSaHLV6fXy3dCSCxdYXg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PSAJDzsf+gdaxJPFwiTcNF2mHPPpbZ2nCOFH4Xn+4puLR2pfcJ3rSkv7/XXdwW3rw
         T2tvFao0F1sRrTvocujR2yZA06Ah+19w6U5NSO0XS8aerMKjH73u1QwStqK093yvjw
         a+sifXxaBi2+oyu1yi1yjqDwMMXoYDu+GMlB+jbIFZI9ah3ExIzf2TZh5lDiLI85UK
         Jdzeb9YgJ9rMQjgsZx9yGR6cjGyVeMCx/b2SrkZjT5J6rUB1Ct2HJSPf5UcvPIpywC
         vSdnJfZSaUwmLtc2/wDMJn+X9PG6MF3cX817Xm18R+u5NmQoeGWUyR2lHxFVliqjie
         kTiCpaH33QxPA==
Date:   Tue, 12 Apr 2022 10:06:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Use generic_file_open()
Message-ID: <20220412170626.GE16799@magnolia>
References: <20220409155220.2573777-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409155220.2573777-1-willy@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 09, 2022 at 04:52:20PM +0100, Matthew Wilcox (Oracle) wrote:
> Remove the open-coded check of O_LARGEFILE.  This changes the errno
> to be the same as other filesystems; it was changed generically in
> 2.6.24 but that fix skipped XFS.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

LGTM,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5bddb1e9e0b3..c5541d062d0d 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1167,12 +1167,10 @@ xfs_file_open(
>  	struct inode	*inode,
>  	struct file	*file)
>  {
> -	if (!(file->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
> -		return -EFBIG;
>  	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
>  		return -EIO;
>  	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
> -	return 0;
> +	return generic_file_open(inode, file);
>  }
>  
>  STATIC int
> -- 
> 2.34.1
> 

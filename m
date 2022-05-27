Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F5E6C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 16:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242165AbiE0QMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 12:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348589AbiE0QMD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 12:12:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E7B48E58
        for <linux-xfs@vger.kernel.org>; Fri, 27 May 2022 09:12:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A2DE61DCB
        for <linux-xfs@vger.kernel.org>; Fri, 27 May 2022 16:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9393FC385A9;
        Fri, 27 May 2022 16:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653667921;
        bh=lafImoAQBPsAPjgYNCNL/JXOBUzs3TKCMACeKzillI4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eeH6xjlTusfNWWnTC7VS54nNTvZ/65wVOomLPAhe43yLO1w/FPkcTpeKJWApajSKB
         DyWxbwqhl7VwRfm06+OGTmvEvK87EwFKovAWGQIBAGPgaNgEvhPfPSx16T4vviAaqD
         y185mBc4c1jQKYyLDlOr8PwK0EQ1AgiS6/gTRWa8TOJQ8rFL6XL5iVa0m05xKEUC24
         JiXbOyaDRZR9f8uwFmC1p7kTkEuHecLfMeGegFqIodel2eSfaUf338Xt010TwTeqhW
         F9d6vNxbji+y2/vnJTSf1JSsRDiTyCPLKEOkDkcmFZodM1sL59smFWpfMCu0kBqTRC
         A4E6A6HPeGzXA==
Date:   Fri, 27 May 2022 09:12:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix xfs_ifree() error handling to not leak perag ref
Message-ID: <YpD4UQRIefSW8s2O@magnolia>
References: <20220527133428.2291945-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527133428.2291945-1-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 27, 2022 at 09:34:28AM -0400, Brian Foster wrote:
> For some reason commit 9a5280b312e2e ("xfs: reorder iunlink remove
> operation in xfs_ifree") replaced a jump to the exit path in the
> event of an xfs_difree() error with a direct return, which skips
> releasing the perag reference acquired at the top of the function.
> Restore the original code to drop the reference on error.
> 
> Fixes: 9a5280b312e2e ("xfs: reorder iunlink remove operation in xfs_ifree")
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Doh.  Good catch!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index b2879870a17e..52d6f2c7d58b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2622,7 +2622,7 @@ xfs_ifree(
>  	 */
>  	error = xfs_difree(tp, pag, ip->i_ino, &xic);
>  	if (error)
> -		return error;
> +		goto out;
>  
>  	error = xfs_iunlink_remove(tp, pag, ip);
>  	if (error)
> -- 
> 2.34.1
> 

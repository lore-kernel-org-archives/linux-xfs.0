Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D963C2B9F4
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 18:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 465416195D
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 18:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhFYSWk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Jun 2021 14:22:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhFYSWi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Jun 2021 14:22:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1534E6195B;
        Fri, 25 Jun 2021 18:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624645217;
        bh=Z9f+aKLR0PNMQ+J9H8JUZzxEQtRaykxdrS07DjXMFEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eZokSngDTZxCCnDdtW2oh77RmhwNpt9byO8U3hK+RSIyD60ZtVQHV9t82bBjHxONw
         1LWPL+nx/dsd1HgGgTGMK0rnFLuEiVHsDaUcC4fb7cvS9cP9DUEGOAtt/ufN9QU9l2
         dY8pcYqT95nKw7ErS3DDHvpdhuT0mwfsV20qA+tvnqxE2/GqgnL8BIMtat2S54f/+P
         g0k4F14XI/o4mmhZRgXRm/wz+D8M8ekdDAvUE9qzlN1tjJcOOb6SAacWCNenO0APE3
         SZmalHRFUWcfNUUl14IRCHZAbG0rij3LfDhZDz3h3oP67Fd5/1EWjzwqbrHFeQUWQ3
         hXrhAwz/gOsEg==
Date:   Fri, 25 Jun 2021 11:20:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Initialize error in xfs_attr_remove_iter
Message-ID: <20210625182016.GA13784@locust>
References: <20210622210852.9511-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622210852.9511-1-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 22, 2021 at 02:08:52PM -0700, Allison Henderson wrote:
> A recent bug report generated a warning that a code path in
> xfs_attr_remove_iter could potentially return error uninitialized in the
> case of XFS_DAS_RM_SHRINK state.  Fix this by initializing error.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 611dc67..d9d7d51 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1375,7 +1375,7 @@ xfs_attr_remove_iter(
>  {
>  	struct xfs_da_args		*args = dac->da_args;
>  	struct xfs_da_state		*state = dac->da_state;
> -	int				retval, error;
> +	int				retval, error = 0;
>  	struct xfs_inode		*dp = args->dp;
>  
>  	trace_xfs_attr_node_removename(args);
> -- 
> 2.7.4
> 

Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C68C7EE2F
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 17:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238291AbjEWRo4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 13:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238314AbjEWRow (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 13:44:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DB590
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 10:44:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFA2662CC9
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 17:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3636EC433D2;
        Tue, 23 May 2023 17:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684863890;
        bh=iMntZb3Cwg8Px3TyFTKfjhhJP0UjubBKC4sCO6y4UhY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n7bQc2eaYCnNpBnMFcG1PMiyDYRio4uMdfZYlq4BOt/znZ+B7S0NUmQ/tWYZDAEOz
         i/n7i4lvlPTV30TbEKuif9vcxMd4Gne8LlHxLtl9OUGy7ISMifJ107XpioPs92+klP
         IiOAJ0bmf7B0LxdJAvlwlxn6lND8jZZimXb/BSTE4fI2iAp6Rw3ugcIlRRpgLlWcbH
         mBKSpvK4Tfl3lNnpXoi4BFLecoK36/ZKUed+SQRBiUy8lLqaI73CKgvP91/09RS7of
         NTOtqqUcaut4KRdbFl+VV0qiqAgQyk9XGZoHO+JESQkxZ3O51Eg/hD+ZqDWYCCtVbO
         9uk1TtXXSnMyA==
Date:   Tue, 23 May 2023 10:44:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/24] mdrestore: Introduce struct mdrestore_ops
Message-ID: <20230523174449.GY11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-19-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-19-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:44PM +0530, Chandan Babu R wrote:
> We will need two sets of functions to work with two versions of metadump
> formats. This commit adds the definition for 'struct mdrestore_ops' to hold
> pointers to version specific mdrestore functions.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks ok, though I think those three int fields are really bool, right?

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  mdrestore/xfs_mdrestore.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 8c847c5a3..895e5cdab 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -7,10 +7,18 @@
>  #include "libxfs.h"
>  #include "xfs_metadump.h"
>  
> +struct mdrestore_ops {
> +	void (*read_header)(void *header, FILE *mdfp);
> +	void (*show_info)(void *header, const char *mdfile);
> +	void (*restore)(void *header, FILE *mdfp, int data_fd,
> +			bool is_target_file);
> +};
> +
>  static struct mdrestore {
> -	int	show_progress;
> -	int	show_info;
> -	int	progress_since_warning;
> +	struct mdrestore_ops	*mdrops;
> +	int			show_progress;
> +	int			show_info;
> +	int			progress_since_warning;
>  } mdrestore;
>  
>  static void
> -- 
> 2.39.1
> 

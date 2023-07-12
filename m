Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F31AEB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 17:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbjGLRfw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbjGLRfw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 13:35:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935531FEB
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 10:35:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 276BF61892
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 17:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF1AC433C9;
        Wed, 12 Jul 2023 17:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689183348;
        bh=RYVKUKi9xulCo5NgAIAfRfmF9OnGnnlzABhgBB9tQ/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vORFr6iEsdzMCDHSGe0NS40ht5KFfwCYJrYzn1xXJKF8MF1uXKw8Z5JLwiqHtAfo7
         I7QKtxpia33ZIHxECQgebwDdZNM4mBzbkyzIKnxUFMWqYo+xRRkgxAeKp15K2MAPPb
         XSPO55I6sQGoZKZUIyq3zjMnxqKU9PSS0Qof5bsTOlkr9afqmGAN3kfKp8ItemT2Y8
         4Pbu7rAoNCY0/F69k87Ss218FTVoZgx32OXYwRIk9VIHL8jgzFOEXptBgVrCvhCtUc
         hkYp216RasuluPXYSLpAUCR1ZHTxGCQX4jXvzMVZlnajwZweDQY1wP6qR8LY8g+1N9
         6lAlbYfANci2g==
Date:   Wed, 12 Jul 2023 10:35:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 14/23] mdrestore: Declare boolean variables with bool
 type
Message-ID: <20230712173547.GL108251@frogsfrogsfrogs>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-15-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606092806.1604491-15-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 02:57:57PM +0530, Chandan Babu R wrote:
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  mdrestore/xfs_mdrestore.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 481dd00c..ca28c48e 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -7,9 +7,9 @@
>  #include "libxfs.h"
>  #include "xfs_metadump.h"
>  
> -static int	show_progress = 0;
> -static int	show_info = 0;
> -static int	progress_since_warning = 0;
> +static bool	show_progress = false;
> +static bool	show_info = false;
> +static bool	progress_since_warning = false;
>  
>  static void
>  fatal(const char *msg, ...)
> @@ -35,7 +35,7 @@ print_progress(const char *fmt, ...)
>  
>  	printf("\r%-59s", buf);
>  	fflush(stdout);
> -	progress_since_warning = 1;
> +	progress_since_warning = true;
>  }
>  
>  /*
> @@ -202,10 +202,10 @@ main(
>  	while ((c = getopt(argc, argv, "giV")) != EOF) {
>  		switch (c) {
>  			case 'g':
> -				show_progress = 1;
> +				show_progress = true;
>  				break;
>  			case 'i':
> -				show_info = 1;
> +				show_info = true;
>  				break;
>  			case 'V':
>  				printf("%s version %s\n", progname, VERSION);
> -- 
> 2.39.1
> 

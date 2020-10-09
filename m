Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8514C433E7
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 09:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FDE22225A
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 09:53:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NHG0pFcg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgJIJxA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 05:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgJIJxA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 05:53:00 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A73EC0613D2
        for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2020 02:53:00 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b26so6423359pff.3
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2020 02:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qd+tmpUpsGmp2QU+4Pf/8hsuNfIZvmzgWhPKdDm7tyg=;
        b=NHG0pFcgt59FWApeJqWsw0lyuTGgzFJk6qMAzbqyrn2wBI7XMINZ9zPscYCXK92ne/
         LJW2aoFxae+Ms9acVOUMwiq53vVsDLH14P8ohnzsizy538Dha6hBP+qwKRwy4SOvnJW0
         MamWCVWNEJYGM/8GUJcV158MLDoCwMDaNO9OEbwSga9dCRikltSrPUc8tsPFqJh5X0Rp
         dvOTj4SmmdCka3ouixL9SJZTOv15ba5Eagts563/87WyaPAQz8IVsYcMGhjDdevKCa1g
         hsIYei6NbKCDrzUxVrnEr3txmOYcc9YtoO+9Fc9u9m+Q6VQ3+KfjpLErDcPeCbhlpz6R
         TCdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qd+tmpUpsGmp2QU+4Pf/8hsuNfIZvmzgWhPKdDm7tyg=;
        b=uDP/wwkcstSHfR9tCyDlxz/WoPj2HzQKXq5xja538ykB916YYDlK8Gr2NaUGV2zeQX
         ZoQN10aPCR6kL8xhhbwQnRnqDuqh8/Vdz0pjs+Ps/bSYpPBbz5eN4la9tF9cOvaS3nGf
         KRAVGWSqABu2nu5zYyHMHxzrPDUEfdfvxuRuHiEhG/6Ga+STWZO34d1k5Vc0ALgUSU5J
         HYb+IHQqDZ4wDQechA6WCDIbFGqW2EWxhHBz4J7RXlMjleZGekFh7OMxk4ZRRZUJMnzW
         QHiwep6AaQ9jHLis8lUkQeeOU60DaI8zx/ktTcIXXqnq/P7A0wJ8IAzeF+x0inv0l8fA
         pKbw==
X-Gm-Message-State: AOAM532lF2G/VtT9fb99B9boje4F5y/M7UEVf/JQAP4wWu+Qihz2NNlW
        SNDV+Po0ytpIwjM1Uxs48Ok=
X-Google-Smtp-Source: ABdhPJyTBJwNbuu0tQgSHRj9D39ym/gsY3Jh27xpnc4m5rfgsoIYNRq8w64uDNbyNlAFM2tla9Krzw==
X-Received: by 2002:a17:90a:fe13:: with SMTP id ck19mr3698265pjb.207.1602237180035;
        Fri, 09 Oct 2020 02:53:00 -0700 (PDT)
Received: from garuda.localnet ([122.171.36.77])
        by smtp.gmail.com with ESMTPSA id i24sm9871425pfd.15.2020.10.09.02.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 02:52:59 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, sandeen@redhat.com
Subject: Re: [PATCH v2.2 2/3] xfs: make xfs_growfs_rt update secondary superblocks
Date:   Fri, 09 Oct 2020 15:21:38 +0530
Message-ID: <2785429.vsROyPpyBe@garuda>
In-Reply-To: <20201008221905.GR6540@magnolia>
References: <160216932411.313389.9231180037053830573.stgit@magnolia> <160216933700.313389.9746852330724569803.stgit@magnolia> <20201008221905.GR6540@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 9 October 2020 3:49:05 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we call growfs on the data device, we update the secondary
> superblocks to reflect the updated filesystem geometry.  We need to do
> this for growfs on the realtime volume too, because a future xfs_repair
> run could try to fix the filesystem using a backup superblock.
> 
> This was observed by the online superblock scrubbers while running
> xfs/233.  One can also trigger this by growing an rt volume, cycling the
> mount, and creating new rt files.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2.2: don't update on error, don't fail to free memory on error
> ---
>  fs/xfs/xfs_rtalloc.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 1c3969807fb9..f9119ba3e9d0 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -18,7 +18,7 @@
>  #include "xfs_trans_space.h"
>  #include "xfs_icache.h"
>  #include "xfs_rtalloc.h"
> -
> +#include "xfs_sb.h"
>  
>  /*
>   * Read and return the summary information for a given extent size,
> @@ -1102,7 +1102,13 @@ xfs_growfs_rt(
>  		if (error)
>  			break;
>  	}
> +	if (error)
> +		goto out_free;
>  
> +	/* Update secondary superblocks now the physical grow has completed */
> +	error = xfs_update_secondary_sbs(mp);
> +
> +out_free:
>  	/*
>  	 * Free the fake mp structure.
>  	 */
> 

How about ...

if (!error) {
	/* Update secondary superblocks now the physical grow has completed */
	error = xfs_update_secondary_sbs(mp);
}

/*
 * Free the fake mp structure.
 */
...
... 

With the above construct we can get rid of the goto label.

-- 
chandan




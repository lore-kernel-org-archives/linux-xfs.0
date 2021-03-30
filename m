Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6521C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 18:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96F036192C
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 18:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbhC3Sv4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 14:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232824AbhC3Sv0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 14:51:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D18D6192C;
        Tue, 30 Mar 2021 18:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617130286;
        bh=tiyBW8n4ihytNp0PfrBTINnwsgD0GJUDl/r8DiAzsak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BnQCyPMxcIhiarHTGAVaufcnQX/trS+iJahvq2F5N49+S+X0ELDS5efYbDCLh2h0I
         uxKRxOTgeY8ONSc9Agta8sz3ce8ztMiG0sslmcDn02oeO4IlPt2PaGuonSxZsgjm4J
         1QZi1O0OhwGWuEuNoRmFY1HEJhj/37hyxg7lsqzTrP1YsCoi0ZV4LT2aBf9m2tqHYp
         ru9aZ3ULWOlwcyoH6XQhdekQ6pXaZKSEn+CLmitW+HLKnKVw92u2g8XgYTYfdYKSAL
         FDQ4NLiqD+8WdGIbVKWfya2OojZiCHzRraHdB9A7f3vj+Ug6gWbCwfLmHR+rRBqgp2
         zvTdI7itf3nHQ==
Date:   Tue, 30 Mar 2021 11:51:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Leah Neukirchen <leah@vuxu.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: include <signal.h> for platform_crash
Message-ID: <20210330185124.GZ4090233@magnolia>
References: <20210330155741.17193-1-leah@vuxu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330155741.17193-1-leah@vuxu.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 05:57:42PM +0200, Leah Neukirchen wrote:
> Needed for kill(2) prototype and SIGKILL definition.
> Fixes build on musl 1.1.24.
> 
> Signed-off-by: Leah Neukirchen <leah@vuxu.org>

Looks good to me, and I'll remind everyone that we (your maintainers)
rely on the help of the wider community for building and testing on
non-default configurations.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  include/linux.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux.h b/include/linux.h
> index 7bf59e07..a22f7812 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -18,6 +18,7 @@
>  #include <endian.h>
>  #include <stdbool.h>
>  #include <stdio.h>
> +#include <signal.h>
>  #include <asm/types.h>
>  #include <mntent.h>
>  #include <fcntl.h>
> -- 
> 2.31.0
> 

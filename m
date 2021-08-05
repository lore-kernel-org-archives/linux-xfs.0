Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3270C4338F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 17:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7F82610A2
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 17:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239768AbhHERbk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Aug 2021 13:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230004AbhHERbj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Aug 2021 13:31:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FEA960F42;
        Thu,  5 Aug 2021 17:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628184685;
        bh=mhV1IA46chs6r0oYEaxpc5f9AbYycS8b9Y3dBVJ8pio=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cFZJDgSkrdTzCvflTibvVU4yyvG22S//3ov1qH7wz932fifRQmON6SLZoaWvxnuj5
         bf/30sK7nAPkfSo1ZN6HJJx6LhYHEI5Krep7iO+zK9xCccPJGlgzwHuxybSqE1aPoS
         F9fuTdvO2uSpTkJ12rspzUZ3TRdtIwXXbcCEu2oZL9zIJ8lTSyPPQDr3plAWvhh83U
         qZQHahx7Xx23IK+pCyT7alhAx4az+bn1VSg6C3JAzGiBQU1DNHTyH6WwqSctO7BH9e
         3W9A4vJMjWDLTtYA4htX0Beehe8kMX2D4mpcA55Em7QdYkqVpU9E8/R6g3r0ID+97m
         Kw4dSzlAeLO4g==
Date:   Thu, 5 Aug 2021 10:31:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: Add another assertion to inline data handling
Message-ID: <20210805173125.GG3601405@magnolia>
References: <20210803193134.1198733-1-willy@infradead.org>
 <20210803193134.1198733-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803193134.1198733-2-willy@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 03, 2021 at 08:31:34PM +0100, Matthew Wilcox (Oracle) wrote:
> Check that the file tail does not cross a page boundary.  Requested by
> Andreas.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/buffered-io.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 8ee0211bea86..586d9d078ce1 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -215,6 +215,8 @@ static int iomap_read_inline_data(struct inode *inode, struct page *page,
>  	if (PageUptodate(page))
>  		return PAGE_SIZE - poff;
>  
> +	if (WARN_ON_ONCE(size > PAGE_SIZE - poff))
> +		return -EIO;
>  	if (WARN_ON_ONCE(size > PAGE_SIZE -
>  			 offset_in_page(iomap->inline_data)))
>  		return -EIO;
> -- 
> 2.30.2
> 

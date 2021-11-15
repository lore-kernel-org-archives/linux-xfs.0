Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 578FDC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 16:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FDEB63210
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 16:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhKOQtE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Nov 2021 11:49:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:39512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231845AbhKOQs1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Nov 2021 11:48:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AA0561B9F;
        Mon, 15 Nov 2021 16:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636994730;
        bh=z5MlQ5ioenB1ssjfhPYQsEBl9P01+wXOotwyWUby+wU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GPwp3O6emSL8hjWF7io3ndOUk1fgfwaPOXx3xUua3UVec6hnPzKk35upnG7hbKsrt
         N+OmzhX1hCZOloJlDC99ueLxfD7y6BEB2BRMYL3mPbRawuzKyKacz0W0sRrN13xVir
         BtiNxEsp6Zq0mDsUHYxZzyPXYyyGeq0zGhKYZ8IDzNCyu5wzsFMxmqiDks62+nIuyi
         Y8ezonLIUK8TBCIrPsdvsf+TdTlSYumYHogbhaExuPTff4E9C0mJKVGwqqkR9gdtN1
         ysOLsv49OThSmdEjD6viYE7rR8cZejqqYMdVtbOwkd5ED28XJsC18h2jZ/ZsFrxolm
         V4pi7Z5fHsz2Q==
Date:   Mon, 15 Nov 2021 08:45:30 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Boian Bonev <bbonev@ipacct.com>
Cc:     linux-xfs@vger.kernel.org, bage@debian.org
Subject: Re: [PATCH] Avoid format truncation
Message-ID: <20211115164530.GF24307@magnolia>
References: <20211114211457.199710-1-bbonev@ipacct.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211114211457.199710-1-bbonev@ipacct.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 14, 2021 at 11:14:58PM +0200, Boian Bonev wrote:
> io.c:644:17: note: ‘snprintf’ output between 4 and 14 bytes into a destination of size 8
> 
> Signed-off-by: Boian Bonev <bbonev@ipacct.com>

I really hope nobody ever gets to a cursor depth of 4 billion, but the
logic is correct, so...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  db/io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/db/io.c b/db/io.c
> index c79cf105..154c3bd9 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -638,7 +638,7 @@ stack_f(
>  	char	**argv)
>  {
>  	int	i;
> -	char	tagbuf[8];
> +	char	tagbuf[14];
>  
>  	for (i = iocur_sp; i > 0; i--) {
>  		snprintf(tagbuf, sizeof(tagbuf), "%d: ", i);
> -- 
> 2.33.1
> 

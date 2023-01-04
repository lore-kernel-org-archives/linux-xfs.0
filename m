Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1640FC63707
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Jan 2023 16:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjADQZz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Jan 2023 11:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239999AbjADQZR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2023 11:25:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687A63D1C1
        for <linux-xfs@vger.kernel.org>; Wed,  4 Jan 2023 08:24:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08593617AE
        for <linux-xfs@vger.kernel.org>; Wed,  4 Jan 2023 16:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646C0C433F1;
        Wed,  4 Jan 2023 16:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672849483;
        bh=h89W5fHGwB3rpxAeaZDsUkf9H0QOo1DzBgvh8AAgAfI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ThFLmoZgYY2147icg5Zp0L63qStM46LqE5dDdFTL2/0jiQX3fAYXMBPmSffm8AFDx
         7n0QsBoe0N3hFby/tvS8lc5OO9e8Ga+cZGsJX8KYGj9UOVbM7+Zt7+67e1Bi1mPxoa
         Nuasoi89/SRIbYjKtpQ2KYTt5ubFjO2cNlGA0zfxJp2oye4ALDzmeD6W+3LmXfGK9H
         csNH69cJtYaFcdl4rm+AJkxiz8ZRXhYtdLEO4u9bLdqu5GLsqpHNUmIaJ+sIouP830
         Q10tCrPhk5/207ABkATkIo6I5tJ65V51pbc9hfv5dSja6U+l4gBSKWpK3j/bdrKy2y
         oxyIkNVgXaOHw==
Date:   Wed, 4 Jan 2023 08:24:42 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix extent busy updating
Message-ID: <Y7WoStJT4ImufLct@magnolia>
References: <20230103193217.4941-1-wen.gang.wang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103193217.4941-1-wen.gang.wang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 03, 2023 at 11:32:17AM -0800, Wengang Wang wrote:
> In xfs_extent_busy_update_extent() case 6 and 7, whenever bno is modified on
> extent busy, the relavent length has to be modified accordingly.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/xfs/xfs_extent_busy.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index ad22a003f959..f3d328e4a440 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -236,6 +236,7 @@ xfs_extent_busy_update_extent(
>  		 *
>  		 */
>  		busyp->bno = fend;
> +		busyp->length = bend - fend;

Looks correct to me, but how did you find this?  Is there some sort of
test case we could attach to this?

--D

>  	} else if (bbno < fbno) {
>  		/*
>  		 * Case 8:
> -- 
> 2.21.0 (Apple Git-122.2)
> 

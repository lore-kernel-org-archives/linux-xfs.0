Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1ED7C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 09:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6917C206BE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 09:06:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jDS5LrGH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgIQJGr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 05:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgIQJGr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 05:06:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0125DC061756
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 02:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kn2MqWdM95h72/Uc8Pc2wEXPOCIb6jXdr86yqm/FVfE=; b=jDS5LrGHZ1y5Y59Pm9+KhPlnMj
        PvFEuEfzSK4T9Rt7CSGCEQRVNZP/SNeVx8nQb9ZDJwax61p6a0bKtJ1Ffn1J70PBsOLCquZXrQ7d9
        hQLnU5dfkJGXkC3Gn8pXo3rzoOykP7OtSrraTA8tD9zye6HIsGzLBMjKV2Nyv+RfrYio2q3VfJ5U+
        AqWZ6cVKJv0XHl5ZBFLtJCCsmef49ltH1w/nO+rEOuYqaHO6NFjNxdtlXxUsWkCAoNRVTiQyGgKn6
        BvbG9ZcSTn5QcE1J66zDAYRFlTqDNmhNx40VDM4/VT09B2BJVcZd27EzYJf9xB4sFIl/tvV2f86bB
        9DzqxIUw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIpsL-0003qU-Js; Thu, 17 Sep 2020 09:06:45 +0000
Date:   Thu, 17 Sep 2020 10:06:45 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/2] xfs: free the intent item when allocating recovery
 transaction fails
Message-ID: <20200917090645.GB13366@infradead.org>
References: <160031332353.3624373.16349101558356065522.stgit@magnolia>
 <20200917070135.GV7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917070135.GV7955@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 12:01:35AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The recovery functions of all four log intent items fail to free the
> intent item if the transaction allocation fails.  Fix this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_item.c     |    5 ++++-
>  fs/xfs/xfs_extfree_item.c  |    5 ++++-
>  fs/xfs/xfs_refcount_item.c |    5 ++++-
>  fs/xfs/xfs_rmap_item.c     |    5 ++++-
>  4 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 2b1cf3ed8172..85d18cd708ba 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -484,8 +484,11 @@ xfs_bui_item_recover(
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
>  			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
> -	if (error)
> +	if (error) {
> +		xfs_bui_release(buip);
>  		return error;
> +	}

This should probably use a common label instead of duplicating the
release three times.

That beind said I don't think we need either the existing or newly
added calls.  At the end of log recovery we always call
xlog_recover_cancel_intents, which will release all intents remaining
in the AIL.

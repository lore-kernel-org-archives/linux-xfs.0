Return-Path: <SRS0=s1/4=C4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC92BC43463
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 06:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45113208B8
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 06:27:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lCXdhkjq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgISG1X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Sep 2020 02:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgISG1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Sep 2020 02:27:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878F7C0613CE
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 23:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=c7i7RbJYdn7KNwQIgDI4fWRZrCyCPn3fiRM2Rx5Xzhk=; b=lCXdhkjq4dmsnPOPQ5Jf7APPuv
        80DWDd9xxMqRxYpFEtZ5cWaVti8nmOXvV5rK+R2xj9X0fwpd/5d+O1FX0BqIbj5mC4avML50Le8b5
        jxv3Ijx8AF8gjzV7CASMN1gxvpn/Vx4YUrX5c2JU+qwAGOdLKGkADtHgbPI+T/5dfTPPJPImImlDs
        efzw3az8Y4HuZFW+kHav7ZymGptMCvwsU/zz6iw7bF4YXt7Dl/8/h9xdlXLoV1Edt70Bl78rbJ7xd
        0WDu8HLR8GP00h4TKGJFtuD2jePQsaNV8gUzM20Wr8ZurB1ojoPWE7qIKZmFVYNW43uX17xYuMEJp
        Bt3LLB4Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJWKy-0003cW-Fy; Sat, 19 Sep 2020 06:27:08 +0000
Date:   Sat, 19 Sep 2020 07:27:08 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v2 4/7] xfs: do the assert for all the log done items in
 xfs_trans_cancel
Message-ID: <20200919062708.GA13501@infradead.org>
References: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
 <1600342728-21149-5-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600342728-21149-5-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 07:38:45PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> We should do the assert for all the log intent-done items if they appear
> here. This patch detect intent-done items by the fact that their item ops
> don't have iop_unpin and iop_push methods.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/xfs_trans.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index ca18a040336a..0d5d5a53fa5a 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -925,6 +925,13 @@ xfs_trans_commit(
>  	return __xfs_trans_commit(tp, false);
>  }
>  
> +/* Is this a log intent-done item? */
> +static inline bool xlog_item_is_intent_done(struct xfs_log_item *lip)
> +{
> +	return lip->li_ops->iop_unpin == NULL &&
> +	       lip->li_ops->iop_push == NULL;
> +}

I think this helper should go into xfs_trans.h, next to the
xfs_log_item log item definition.  And xlog_item_is_intent should
be moved there as well.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

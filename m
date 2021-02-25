Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36ECCC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB2F064F06
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbhBYIwS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 03:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236030AbhBYIwR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 03:52:17 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3264C061574
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 00:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lqOF2PiMDLuVMvI8KDNetOQwHqQ+2Qhms0D5mXkgaso=; b=LTYOktlL/Y+ZLHO/L01dVhfScp
        HSBGItb4Uq9OHnJckQgKavoazNhII6sKLH3KkyG5RYddDfSsb2Zg5Sa6e/DvWsSCyz4wbXv3C4Sei
        F113ne1h93FQLImXM7SS+NzfDjtBTa+FCzatlHyr7zAxeXzW5gpxIUktOeJ1TNaGeES3sD/8n0lP6
        aNnNKDE7jXKILcS6fjhJQR5yFHNShbH5gLUk/GjnzBOp41ZQLnUIRXa7hTvGake3rQkqkulHMbxP4
        t7iwWzmsievNhAUgMe6FW8YxeRWRyNYHxf2kCjc6cfut1P2yC3wxVJV2+PRLLPBo+aluk44dsF6ZX
        3RAxMDrQ==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFCMu-00AUGy-Fu; Thu, 25 Feb 2021 08:51:34 +0000
Date:   Thu, 25 Feb 2021 09:49:20 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: remove need_start_rec parameter from
 xlog_write()
Message-ID: <YDdkkPyKSnPfll3n@infradead.org>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223033442.3267258-7-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	if (optype & XLOG_START_TRANS)
> +		headers++;

This deserves a comment.

> +	len = xlog_write_calc_vec_length(ticket, log_vector, optype);
> +	if (start_lsn)
> +		*start_lsn = 0;

I'd slightly prefer that allowing a NULL start_lsn was a separate prep
patch.  As-is it really clutters the patch and detracts from the real
change.

>  			int			copy_len;
>  			int			copy_off;
>  			bool			ordered = false;
> +			bool			wrote_start_rec = false;
>  
>  			/* ordered log vectors have no regions to write */
>  			if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED) {
> @@ -2502,13 +2501,15 @@ xlog_write(
>  			 * write a start record. Only do this for the first
>  			 * iclog we write to.
>  			 */
> -			if (need_start_rec) {
> +			if (optype & XLOG_START_TRANS) {

So this relies on the fact that the only callers that passes an optype of
XLOG_START_TRANS only writes a single lv.  I think we want an assert for
that somewhere to avoid a bad surprise later.

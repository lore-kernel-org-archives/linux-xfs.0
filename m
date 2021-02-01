Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 812F1C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 12:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46A4A64E9E
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 12:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhBAMhY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 07:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhBAMhX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Feb 2021 07:37:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3346DC06174A
        for <linux-xfs@vger.kernel.org>; Mon,  1 Feb 2021 04:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VxtUVwNcLLZYQ8LHxvMFtuHZ7Aewx603vgrw+kBJlJs=; b=lcg1z64rL1eJRd8EVkcmjJcMOj
        zkL8D51mYWFrGMa2pY40eB/UrlK5vp9OWY1MBxNWd4/FcfX94vWclgU1VaUoCmUBOGTrQZRIKCEo/
        XGn2WQzUFFOk6zg7hP0d80AH4IkgFQ31gwvLNWhj3SVx52r85HVAhsPBQtElxGi1jJXuJODrYtMxx
        MxJpMPq7XqbYI6OaE7jWoI5Lnk9ggyS358oOr/QxVpE6dgup2vpXAmtvOA76zX6LLObhzXR2ZvSel
        qDq6849jK3wEnVHNKCYIXd91rf4X73o29YBsKTQDsgJJK/xkwADIIh5ty83APLz3C9ociMPuhWh50
        lRBZMYXA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l6YRZ-00Dlah-2K; Mon, 01 Feb 2021 12:36:39 +0000
Date:   Mon, 1 Feb 2021 12:36:37 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 09/12] xfs: flush eof/cowblocks if we can't reserve quota
 for chown
Message-ID: <20210201123637.GC3279223@infradead.org>
References: <161214512641.140945.11651856181122264773.stgit@magnolia>
 <161214517714.140945.1957722027452288290.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161214517714.140945.1957722027452288290.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 31, 2021 at 06:06:17PM -0800, Darrick J. Wong wrote:
> @@ -1175,6 +1177,13 @@ xfs_trans_alloc_ichange(
>  	if (new_udqp || new_gdqp || new_pdqp) {
>  		error = xfs_trans_reserve_quota_chown(tp, ip, new_udqp,
>  				new_gdqp, new_pdqp, force);
> +		if (!retried && (error == -EDQUOT || error == -ENOSPC)) {

One more :)

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

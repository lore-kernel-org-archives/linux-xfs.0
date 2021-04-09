Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A247DC43460
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 05:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7818361185
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 05:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhDIFb0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 01:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233196AbhDIFbY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Apr 2021 01:31:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72245C061761
        for <linux-xfs@vger.kernel.org>; Thu,  8 Apr 2021 22:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YulvUgVc5S7hx/RvbMumGlA/qBQz9SjH8V3Q+/9Xgu0=; b=UMrk8eAOYvGBY2d1henAeHnC9y
        s+OAnW2oymdyAgr0bQe9rt+w8Eox3n1vYdScMiWy9yxhg9jSH4poYtyBKsEkEEuJv8zdb5gump/T3
        /QUzeV1WaUj/Oj3Ga7da0EvqrRKs3L6nu1TyNS6owd1D81zOEq9xpgQxMQHP24GU7Lc8iRtKPDC0Z
        wQgvfKdIXb8jYUi1KCnmFruOAwcIh/+q0JbWRvF5+ctMkyTd9g6vlBz+ApjKRxfXg1H+2a01IhHOV
        BB2/l+Ruu68lZ2HDge5biI29wHwTDFqg7hp2pL4zTZiR6sdRJZihTDwYUhhNZ7xTTxnx9DqTufkmE
        /AbK0S5A==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lUjjR-00HRTE-Ku; Fri, 09 Apr 2021 05:31:03 +0000
Date:   Fri, 9 Apr 2021 06:31:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, hch@infradead.org,
        chandanrlinux@gmail.com
Subject: Re: [PATCH v2] xfs: get rid of the ip parameter to xchk_setup_*
Message-ID: <20210409053101.GA4156479@infradead.org>
References: <20210408010114.GT3957620@magnolia>
 <20210408200830.GW3957620@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408200830.GW3957620@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 08, 2021 at 01:08:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that the scrub context stores a pointer to the file that was used to
> invoke the scrub call, the struct xfs_inode pointer that we passed to
> all the setup functions is no longer necessary.  This is only ever used
> if the caller wants us to scrub the metadata of the open file.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

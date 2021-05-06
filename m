Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D57C433ED
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 06:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AA7A61402
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 06:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbhEFGlI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 May 2021 02:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhEFGlH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 May 2021 02:41:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A623C061574
        for <linux-xfs@vger.kernel.org>; Wed,  5 May 2021 23:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NM2qV1uTAAROIXhBw2/J8koa6QoXXeTdXtmRzT2PIzk=; b=E1L3dwEyX+F1kyEpxbVgQ3knYh
        oo1bVIZqNLlj5MhihJQaOd30Tc7sRXbDHoViAmIFBGci0tMK+hnSYpMtxeOa7RJ1tWYXy3jWZHawM
        QZxNAdvgKkTqGfcvxQIzg9Idu5KZkCpXkXbhaLoSLRQVrmszo+5vsIy2NGXh1bwzCrjsTbrtu6303
        8vmcwSpBkNCHY0cuoHaBdO+fWeJcaoYsm7ttUK827+P4vQlq9Y8qgEa1DqhuNKFTyNYtmk5c95Fu0
        JaHjQUAqQl4bKT48uqShm5Se21vKZvrCTSoF91EwWwGAyFAQCiGcvZyXLJy0BfCxa5qOF+CJCBs96
        cBtCwFdA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1leXfw-001Nos-SU; Thu, 06 May 2021 06:39:58 +0000
Date:   Thu, 6 May 2021 07:39:56 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] libxfs: copy crtime correctly now that it's timespec64
Message-ID: <20210506063956.GA328487@infradead.org>
References: <20210505170142.GC8582@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505170142.GC8582@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 05, 2021 at 10:01:42AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The incore i_mtime and di_crtime are both timespec64 now, which means
> that tv_sec is a 64-bit value.  Don't cast that to int32_t when we're
> creating an inode, because we'll end up truncating the creation time
> incorrectly, should an xfsprogs of this vintage make it to 2039. :P
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

I'm not sure the struct copy comment is all that useful, but otherwise
this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

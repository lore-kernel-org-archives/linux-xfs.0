Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40640C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 17:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F38D864DAA
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 17:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbhA0RCJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 12:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235149AbhA0Q7j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jan 2021 11:59:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964FBC061574
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 08:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2zzwyeS7sPdMrUUYxGSyY9ypCzOTDLFjECjNEWsPnQM=; b=CaCIqCVFyoVNh3sI161QO5wfdC
        tGKI8jhun8X+2E/tfRoIultX+QLGlEO65XX6uKXrzPiub3rkF1ZAlioj87Md+/7tslZHMlnaOLJRH
        4A/mBrv3fcfvjUzLYY8pY6L48vCNEpYXKw2HT/jxJaJEpdZVtqkE1ccz2UMtXxMavFcNGrkGRTCxY
        0hZPfLcscJLvcajwD2dnibaJ2PwCFmOgQ9Y6orHtJWYf6L3yKjK1LKsg58IqBSJvszgVkzhtLwxwu
        nr1PIIoQgySoOeC+zstDfr5mxLVuuI+r/sU8nzgCvNUlIqroPMbc6vB83pwoktXrHZO7JmHY3SO1I
        QsGX5s1Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l4o9a-007G7q-Id; Wed, 27 Jan 2021 16:58:51 +0000
Date:   Wed, 27 Jan 2021 16:58:50 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 5/4] xfs: fix up build warnings when quotas are disabled
Message-ID: <20210127165850.GA1730140@infradead.org>
References: <161142789504.2170981.1372317837643770452.stgit@magnolia>
 <20210126045128.GL7698@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126045128.GL7698@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 25, 2021 at 08:51:28PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix some build warnings on gcc 10.2 when quotas are disabled.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

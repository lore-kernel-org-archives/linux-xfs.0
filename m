Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED5BC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 17:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B910864DD1
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 17:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbhA0RGZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 12:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235184AbhA0REv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jan 2021 12:04:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACD1C0613D6
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 09:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lSUsaKmTADPaQk9kCavD9Ul8i9yIcJzUf2BzTwzV4do=; b=HTUSUlXij4AhWgxRKcliK7IugM
        sN8dzWSzBFP52JrnZn0FLzs8kAi1hF8IXdH/qPqRrV9s6NahGWB+cVqZtwyUHzj+CfouwsqyHbOmH
        n/7ZtI7oYqMOjXPZDtTg01oXUCGFw1W236Ju85G+8RRawVQjWTND/WsdeRoHZAAL6qC8jPK8bu8YN
        12oUNejpeKFcFIYtaGWGVo3E620MR/5Wfc6++G3iEHyZlhX5KYgjsxqywEvxtr0pt1nYVeRs292Rn
        UZPyCSaRAlw/XDmfjjq8vVzaCLE03X85dIUQnvt88UW5MhxTLSxZ+0ZbL+7PFTfqJ8jF7CSJ9Oj7G
        4Tkgf5CA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l4oET-007GTL-Gh; Wed, 27 Jan 2021 17:03:54 +0000
Date:   Wed, 27 Jan 2021 17:03:53 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 10/9] xfs: expose the blockgc workqueue knobs publicly
Message-ID: <20210127170353.GD1730140@infradead.org>
References: <161142800187.2173480.17415824680111946713.stgit@magnolia>
 <20210126051313.GV7698@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126051313.GV7698@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 25, 2021 at 09:13:13PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Expose the workqueue sysfs knobs for the speculative preallocation gc
> workers on all kernels, and update the sysadmin information.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

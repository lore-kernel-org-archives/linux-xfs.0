Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5861C63697
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 10:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 784D422249
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 10:42:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kECmfhXf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgKNKmM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Nov 2020 05:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbgKNKmL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Nov 2020 05:42:11 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF35C0613D1;
        Sat, 14 Nov 2020 02:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=prNZhJ75zLqme8/W6HWPkmfRV5DMNTJa5iqBHN+YL30=; b=kECmfhXfx0XvOIwGhNeD5fw6KK
        t3KGgcl9Qr7uUvBQ6Neuav5sk6jrfzkkNaa2pEicfLiArs85UzyeU9Yy/AKC+cs3fLfxkT3R9gXdZ
        KV7ULS9viPHOTvE+x3CwzfLOzByxXcx5cX+oZOSpHNQAubjZVDxl7kA9qfFcgmtpbUT5TN7Y2bkGA
        ldJh0BCUTxsTAqSCYLHj/QkZr1+pMl6v0CxIzd2wfp2/E40lwJt8nEYea1PF1bhEl77YrxtHXpsCw
        cmzTSJ3qLQ5c/j6dQmt601dijDHM934CcBVnnQTCyyxh8Mq3gEGmIY7vYpz980ZJ91sKXFB1yM+Sq
        WEc98a9A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kdt0T-00036M-3D; Sat, 14 Nov 2020 10:42:09 +0000
Date:   Sat, 14 Nov 2020 10:42:09 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/4] fsx: fix strncpy usage error
Message-ID: <20201114104209.GD11074@infradead.org>
References: <160505547722.1389938.14377167906399924976.stgit@magnolia>
 <160505548377.1389938.2367585875193826371.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160505548377.1389938.2367585875193826371.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 10, 2020 at 04:44:43PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We shouldn't feed sizeof() to strncpy as the string length.  Just use
> snprintf, which at least doesn't have the zero termination problems.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

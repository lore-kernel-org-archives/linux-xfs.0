Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F3E0C55ABD
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D73520809
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:33:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m0H0T5WN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731311AbgKJSd4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731263AbgKJSd4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:33:56 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC0FC0613D1
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 10:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eq0uqS/dvsAe0jPckHKaSAxUscoVnDh3KbfShzzc9IQ=; b=m0H0T5WNHeu6oxpl8EfEcGdS9E
        ZLsd8c7EoOxOK60U6PY43MGE1TJeUxIu10XPYmLsQJqWVsSQGTECMd9LxteSl2kxVdiMOL24lQFRR
        nLYyK55nUGuUnTJkwGsLePQGUsv0BxHsQyM/G9xk/hmhearrTBJk+UmnRif4Rmya5PB7t3HpGk9gK
        q/WX/lwrhq33Iz0/ppA+daKct0Ktz0MEPnJF/wzB2kDtI6pYUr8cAwdBM7Kfhc7OfM/iKaEVIhAe3
        RhFKKjKM1/2RIoo8BhvT3Vvl02GymyTuoLUoaw1u6HfPwKrJlsqlTnmCh8uSTCzD6LqF2EFKWPAKm
        ycnTHodw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcYSo-0002UB-Hv; Tue, 10 Nov 2020 18:33:54 +0000
Date:   Tue, 10 Nov 2020 18:33:54 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/3] xfs: set the unwritten bit in rmap lookup flags in
 xchk_bmap_get_rmapextents
Message-ID: <20201110183354.GB9418@infradead.org>
References: <160494582942.772693.12774142799511044233.stgit@magnolia>
 <160494584199.772693.777818995688769739.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160494584199.772693.777818995688769739.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 09, 2020 at 10:17:22AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When the bmbt scrubber is looking up rmap extents, we need to set the
> extent flags from the bmbt record fully.  This will matter once we fix
> the rmap btree comparison functions to check those flags correctly.
> 
> Fixes: d852657ccfc0 ("xfs: cross-reference reverse-mapping btree")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Return-Path: <SRS0=ZMk+=CA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D86EDC433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 09:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B28D020825
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 09:06:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sL7QHBr3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgHVJGM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Aug 2020 05:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgHVJGL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Aug 2020 05:06:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69568C061573
        for <linux-xfs@vger.kernel.org>; Sat, 22 Aug 2020 02:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vrP8E/Hzs5pZPMG+BR36rXcL5zPLBxpQSl9+FHpYWFQ=; b=sL7QHBr3MzR2PucL6+AcNrARIy
        rDS1hwXa6j59YvxVkMG9ixoCSDeNRzN1N9tUp0tkiFKRfHDfe0F99dX7/LhgF438H4i58+e6eJBCv
        bOtVJ1vgZ2/bZ3O5PYvfSoJIRlXuptWVIaM6asFF9FVXU7h4Jxmucb5kWnqXb89anksoXQHd9lfFt
        +NiJS6cP25GIsPIpq2swDJnTBk5DNVbh5oEJWIIadISOXCgNZtyN0XzXYFrWDGaDb83zzYNIic8R5
        p048QtEOGUCLWsFwis+GBg6uzoUYbRORlQLRdQD+iz63/aa4ylwjQwn/yQgnXJRbeNOaM6R2mrVRm
        E6fIHB2A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9PTW-0007Cp-2y; Sat, 22 Aug 2020 09:06:10 +0000
Date:   Sat, 22 Aug 2020 10:06:10 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/13] xfs: add log item precommit operation
Message-ID: <20200822090610.GA27199@infradead.org>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092556.2567285-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

While looking to find how this is used, I noticed that it only
starts to get used in patch 12.  Maybe move it just before that
to help the reviewers keep context? 

> +	struct xfs_log_item	*lia = container_of(a,
> +					struct xfs_log_item, li_trans);
> +	struct xfs_log_item	*lib = container_of(b,
> +					struct xfs_log_item, li_trans);

lib as a variable name reads a little strange :)

What about li1 and li2?

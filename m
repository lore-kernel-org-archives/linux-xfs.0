Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16AB7C4346E
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 05:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9638823600
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 05:44:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CnpWJ/IQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgIXFob (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 01:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgIXFoa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 01:44:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B836C0613CE
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 22:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Cmp8U2tahsdDVS135RVHm53VIysZpHyH5z7VUmt7G34=; b=CnpWJ/IQholTW5M0+vTyMXduui
        7IFupprruJz9wXfHDgabkBJBGuqgDhFgfuNmQbVifL6BADPp1fDpw2VlArXLgHCpmJhkuSe7mqYOx
        RqRDs4tyzkVQWvnSlKKPiDlIGdpNw3OZshbKJeo0rQRSvdB6uxnT16ztMa/nw5PKBqx/bijNA6SYK
        8lIGN1ZCP/m6Wr5AfpMLkGtGeb5bAIyUNe/HgxVb1YCeNJadBBlDcZEyHDzUjax28OoCfOQTJ09Hp
        COqbmS1oxquQ/yjTvHEyignyidweh84K3NC1aVx21odyjf+KkcGYwnmEQFdjT0DiHcM+d/bElYgFW
        FRtFhZMg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kLK3R-0005jI-88; Thu, 24 Sep 2020 05:44:29 +0000
Date:   Thu, 24 Sep 2020 06:44:29 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: avoid shared rmap operations for attr fork extents
Message-ID: <20200924054429.GA21562@infradead.org>
References: <20200923182340.GV7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923182340.GV7955@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 23, 2020 at 11:23:40AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During code review, I noticed that the rmap code uses the (slower)
> shared mappings rmap functions for any extent of a reflinked file, even
> if those extents are for the attr fork, which doesn't support sharing.
> We can speed up rmap a tiny bit by optimizing out this case.

This looks correct:

Reviewed-by: Christoph Hellwig <hch@lst.de>

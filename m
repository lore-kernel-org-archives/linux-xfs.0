Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C52DC433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E54F1206A1
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:08:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MDdX6HoF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgGAIIY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgGAIIX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:08:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEEFC061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bRXtXnryk6l4eRvgZ/TOr5ZfXk/X5HoAgVw5M41APok=; b=MDdX6HoFA/Et2dMglT1lfPxE0g
        DvldFFnHMQ9BFp+wI6eGOgQQaUpnYogzB+nFBzmFq8BB9q7+8xP2aqwfZ+ZnQ1HS55eRB5fjvtG+s
        9AaFIeTn9PtMXOMEjq8fX+2EpW07FB3CpOEMNI8rdmY3n2Xma6gmq8N2yBxREZO0Dubf/JdfWotQs
        kfW84zIj+yVvAhoTnX4ELx3KXHCIhCv0Hc44CruOfsoqLfD9YHo98kkKig3S44z9/RkZiAHX2yOy5
        uxu6oD8Z6yuZfGFLE1LxvwALnTbk+w8Jas35Pqsfs5jpFYD0fFLAZJvVNln3QG7SdB1borRLzy8Fb
        zYRpzdyw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqXn4-0005NE-Jq; Wed, 01 Jul 2020 08:08:22 +0000
Date:   Wed, 1 Jul 2020 09:08:22 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Subject: Re: [PATCH 2/9] xfs: rename xfs_bmap_is_real_extent to
 is_written_extent
Message-ID: <20200701080822.GB20101@infradead.org>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
 <159304787204.874036.10765296473918147829.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159304787204.874036.10765296473918147829.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 06:17:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The name of this predicate is a little misleading -- it decides if the
> extent mapping is allocated and written.  Change the name to be more
> direct, as we're going to add a new predicate in the next patch.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

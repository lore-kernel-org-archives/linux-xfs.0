Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14EBFC54E4B
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 08:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E376D20714
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 08:14:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GMY+THP3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgELIOY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 04:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725823AbgELIOY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 04:14:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4349FC061A0C
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 01:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gvE1q8WHicYQVj7wjQCptLLT4/0JXNd8sca1HApw5WI=; b=GMY+THP3+xVNA2GxesmxQH54qU
        yEdMx7gbkAtiEEJzBxX54BsSm0/iRFLPhW747WHtLl7MqyTwXC/gW8cJi6jLQbeWdA4CVnkPC4xP6
        ImbQcsdewN+2ZxbhuUGFHRgU/tlW1a7zjqz0scoCy7s8PzkwaO+JAO3obx9mHv2wh+OMgTZImYtWY
        ZJFlP8bVqmikwXQJ4cAyFoJWrcH6BzS/bHk1Qe5V3V6g6lB0Sy1/hUfP2b2xP5LadELLhWxIvlztt
        RH8GP4JI9vJ94OFGgsTqB3gSTW4qHyyegYo6xTcms49IVa7ZIsIR88X2F0zDE5QI9sFFAm12k//P2
        glnt0Ryw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYQ3T-0002WU-SA; Tue, 12 May 2020 08:14:23 +0000
Date:   Tue, 12 May 2020 01:14:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: separate read-only variables in struct xfs_mount
Message-ID: <20200512081423.GA7689@infradead.org>
References: <20200512025949.1807131-1-david@fromorbit.com>
 <20200512025949.1807131-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512025949.1807131-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I'm surprised the difference is that big.  The moves look obviously
fine, but why do you put the precalculated fields in the middle
of struct xfs_mount instead of at the end?

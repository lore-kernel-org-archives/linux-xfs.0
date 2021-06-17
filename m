Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E49D5C2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 07:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C10B161076
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 07:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhFQIBI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 04:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbhFQIBF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 04:01:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E145FC06175F
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 00:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tubiJLJY2VW6q3g8sOiPjsq1Uj56TJs8G+T3wl5yaO8=; b=XKmNSW3wwvo7Ryboh6sm9vIeVq
        34gDBoK/clbN69L61XQ5VRj0CZUMoxW+VlxNRGMB5oiOacQlhrYKKkk/D703hMkA+5pKwgDndF/tw
        aLdVuZVTTWTEbOwJr8mWb+HDx8WefQ+5zta4fuep8lxt1jGEp2BGipZDIsfxI8EZ3cuw1bSI/71Mq
        cj3aZRTd6HkIeE9oFBnb3B5XBD4NxfU/udePSKkd4P5a4Cc2YZhEXZ0u7a4kf5urdP30GNLOB/xhP
        9UPK4x+CmsSuCUHHLgBzal20HybSfapBqICb9KaF+Lp06r317yP7Pj30jcArPI/zhn7CPmI3J91gt
        TvGL8A2g==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltmv9-008tVK-I8; Thu, 17 Jun 2021 07:58:47 +0000
Date:   Thu, 17 Jun 2021 08:58:39 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix type mismatches in the inode reclaim
 functions
Message-ID: <YMsArwA7rDAcLhS/@infradead.org>
References: <162388772484.3427063.6225456710511333443.stgit@locust>
 <162388773053.3427063.16153257434224756166.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162388773053.3427063.16153257434224756166.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 04:55:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It's currently unlikely that we will ever end up with more than 4
> billion inodes waiting for reclamation, but the fs object code uses long
> int for object counts and we're certainly capable of generating that
> many.  Instead of truncating the internal counters, widen them and
> report the object counts correctly.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

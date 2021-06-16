Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3D5C48BE5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 08:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9F9061246
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 08:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhFPIVU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 04:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbhFPIVT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 04:21:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE82C061574
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jun 2021 01:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IeKWoPCGnuDUlE0Qj+k+QITvkUzYHO6N5+nzj7QyfAc=; b=oy7DJUbJxT2cakHJOb+RRe3T0n
        RqdOtDXG2Yqlhws0lNxzcl/iDRjkSwhn4qzT1Ht4kopS+4B6Gdmorzn/DthqvBgzDEq7zcmroL7eQ
        Cxzsoc/si8ddnEGy7w/jZS6n+YKeAUg6bTAK6Cl+ITYFEf37wOA11TWMyKjp6HFt6IXPlHE+CCs+a
        NX+QNNCDPbqbyoR0yVT7V2zfm44vhAk1O9HuzBklnA98c/xIjRsjpw9L1h2BF/EiEBMp3YY/CPbNS
        ycZW0eZB/EbGuk3Rw3kyd2yQHrTWF605NLYFfrCYQP4nhgg52Oo7HYHQ/izLuln/kUzqZY7F6SZGG
        9bLs+M4A==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltQlF-007nTj-Jb; Wed, 16 Jun 2021 08:18:59 +0000
Date:   Wed, 16 Jun 2021 09:18:57 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        bfoster@redhat.com
Subject: Re: [PATCH 02/16] xfs: move xfs_inactive call to
 xfs_inode_mark_reclaimable
Message-ID: <YMmz8ZZ8S/Xuk9PD@infradead.org>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
 <162360480791.1530792.12003297610956705274.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162360480791.1530792.12003297610956705274.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 13, 2021 at 10:20:07AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move the xfs_inactive call and all the other debugging checks and stats
> updates into xfs_inode_mark_reclaimable because most of that are
> implementation details about the inode cache.  This is preparation for
> deferred inactivation that is coming up.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

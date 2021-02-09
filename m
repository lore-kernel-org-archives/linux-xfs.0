Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C49C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3F9C64EC9
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhBIJU6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 04:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbhBIJSj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 04:18:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460D3C061793
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 01:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=B45nqammOBdBZEb1KNshC9Ub/q2ooukuX4Q4oPJYDmY=; b=JWGas/wgaxuagwvUaXcdLtv20d
        Ck1HhqsnDGJ1h7h11xcF/KoDWSbG+EiGVNoQkXrYLu5ytpF7LB9iq00e1a7/jgufAjQXskrxZQNSa
        //9f/TU8fGAlxbs4gDMB/flbhJuy6YOwpvBOsgrn1TF6BKYDUCn+CkHd2S5PpUaybg9lzOV5nTqLC
        /6BN6cClOGdd3CaBo7+grmATWuGfOkh9wJh7vFtYnJqeLeSkixWs1Ms2Px5BCF82jEVlZWZBjsGs1
        KyXQlXpbGZ0Iqf/r4ZfkARMKX4Q17MaeqcwFbZlCOviqUmpkBIuDPAzd76jsdWydHl54FOtRXwEw5
        okXASX7g==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9PA4-007Dlh-Bm; Tue, 09 Feb 2021 09:18:20 +0000
Date:   Tue, 9 Feb 2021 09:18:20 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, hch@lst.de,
        bfoster@redhat.com
Subject: Re: [PATCH 1/2] xfs_repair: enable inobtcount upgrade via repair
Message-ID: <20210209091820.GK1718132@infradead.org>
References: <161284386265.3058138.14199712814454514885.stgit@magnolia>
 <161284386826.3058138.11503745885795466104.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284386826.3058138.11503745885795466104.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:11:08PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Use xfs_repair to add the inode btree counter feature to a filesystem.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

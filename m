Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC25DC433E9
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5378064EB9
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhBIJYB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 04:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbhBIJTi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 04:19:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E339C061788
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 01:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rV+6v0kuxIXhZmnFq19VsbhJCJQnQjInbYFaDhDG/Ao=; b=TnoEE5ZLqC/OTOVHOfxTq+zJ3O
        9+4SLkdhiRIFTeBkrIdJhF7CfsIduLcYqU5KDsSxn+fyE5Ri4yJReZL1p1DAaeIGrLoTiCfARgqhL
        dbtktCsTNdio7NbqzbGS5RurQa9iBqtre/JtUcLQec8A5uFYro+aP3+TDS9R5ytLGQq04LG74nK3T
        QD3/5UdRYV9VDNQA8HRBUTXZZ3imSkRXHcXHCk5+Su5FEnOWm1FBS7699RMR+1G2s1pfHN03Kyj8U
        VR9y6nigTFAdd5Q9KIGrP2IwQIJrouCII/rBx14cPiW6DVuqk6j5bDRyozFmX8Na8A1Z8EcSLiH5D
        ziaqq6rA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9PAc-007Don-2O; Tue, 09 Feb 2021 09:18:54 +0000
Date:   Tue, 9 Feb 2021 09:18:54 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, hch@lst.de,
        bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs_repair: enable bigtime upgrade via repair
Message-ID: <20210209091854.GL1718132@infradead.org>
References: <161284386265.3058138.14199712814454514885.stgit@magnolia>
 <161284387398.3058138.5317754248430984165.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284387398.3058138.5317754248430984165.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:11:14PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Upgrade existing V5 filesystems to support large timestamps up to 2486.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD45C388F7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 112DA2473C
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:52:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r9QZb2RS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgJ1VwG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:52:06 -0400
Received: from casper.infradead.org ([90.155.50.34]:44160 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728250AbgJ1VwF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:52:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=11Vxh/efZtTN3x8SHx5+hem5clTti8adt5aZ4afIyYE=; b=r9QZb2RSmxB55eJoNBj/nIgB4O
        vL5ka//9KBH+WlNxuR111CVY+rOlIXH3xrOMSOXtUv38kB2vvCwlY95Ozb+y0hU3B69B0P5F0G+9n
        pE7nTOrf1RUxQht0gnDAyNpR2fIk5NNirl7xJzeopylDe5nmxSQ7eqmHSP9Dl3WHF+9iML7Jqi2Qs
        GDJo8o9arpWZ38nUQfgzJ56Z9H/qpQo+vH2WEr2nvOcsVB52wuPvvmfgV1I+Rx/XihvXkYfjDmiY+
        6c0wDkayVPZ28d6tROBTLRMuX1OvH9C7uSw3E5MoP2kKi/ZYK6yF10T3uhJitOsWURApTd7VTbYmv
        GBZoPg4A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXfxq-0000Iz-Ji; Wed, 28 Oct 2020 07:33:46 +0000
Date:   Wed, 28 Oct 2020 07:33:46 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_db: report ranges of invalid rt blocks
Message-ID: <20201028073346.GE32068@infradead.org>
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
 <160375513208.879169.14762082637245127153.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375513208.879169.14762082637245127153.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 04:32:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Copy-pasta the block range reporting code from check_range into
> check_rrange so that we don't flood stdout with a ton of low value
> messages when a bit flips somewhere in rt metadata.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

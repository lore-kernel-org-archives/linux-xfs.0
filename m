Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC08C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C153D2077D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:21:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TKX8WYN/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbgGAIVo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728552AbgGAIVm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:21:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808DBC061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ew7hnIBkYy7EB89/E2AG6G+vTeTcNVH5DIe8j0FCTCw=; b=TKX8WYN/M+31+vDRUBbl/MkRgZ
        wFdEYNysxHCXgsO6PfoPzgbGLbfCqwz3MJs5PH52vmdjTh74Y3uZ+iBnQ0q/8yy2hGxjmS/kEXK6d
        m+tntV48BwxB+ls7pxb4doNaWS0qecnE/8RZuzZtQJst+yEUYqzYN1oGO9Y63OGzS95MgdReavDeD
        ziytIygq76WwFn5J8BGpP0etBYlCSvOKq/Wy3RxNkEZSRsQaLWQd4cyMh6rn3BbDEO4axY0UbvKd1
        oluqGbmBA8enCsTAPSPCuQn7bgo1Z/qExYumc1ry8111e4b5+GGYgwe/CsUz4GC6vgTt/xbn7d354
        MF93IK2g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqXzx-00060Y-7J; Wed, 01 Jul 2020 08:21:41 +0000
Date:   Wed, 1 Jul 2020 09:21:41 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Subject: Re: [PATCH 4/9] xfs: only reserve quota blocks for bmbt changes if
 we're changing the data fork
Message-ID: <20200701082141.GD20101@infradead.org>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
 <159304788616.874036.5580426142663484238.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159304788616.874036.5580426142663484238.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 06:18:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've reworked xfs_reflink_remap_extent to remap only one
> extent per transaction, we actually know if the extent being removed is
> an allocated mapping.  This means that we now know ahead of time if
> we're going to be touching the data fork.
> 
> Since we only need blocks for a bmbt split if we're going to update the
> data fork, we only need to get quota reservation if we know we're going
> to touch the data fork.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

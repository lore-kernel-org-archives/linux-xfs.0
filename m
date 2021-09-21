Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68F60C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Sep 2021 08:56:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4619F604DA
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Sep 2021 08:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhIUI6S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Sep 2021 04:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhIUI6S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Sep 2021 04:58:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6D3C061574
        for <linux-xfs@vger.kernel.org>; Tue, 21 Sep 2021 01:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6uOw+iW0cvnFglit6IRBDUZdEdS2PYuzWdTYASqSx4I=; b=c2z5gtJInBzi5LttiakUBpRzap
        m7bFAj2g2YHHYgH2AwOlpG1PUg+QFnbfO66Zgb/cuEuM6iE/IZY6T7CrD5QawIFkLX1HhTwQVWtIV
        uvBdUixMcxg05+1Dd83dLOGe+XRK+lvLNIfPojSixRQOkLijIt75w+mmMRHy7AsACqhqFMNqirwbq
        T7IcVdWiD1zEPh2ixSQXrz0SwV9RtDi48bsaEYimEVjTyfP+8ekvw/7LLQU42Gc4ZEBg1CbeDgsJf
        daBurUTZx8whbDLAnQpNxLgy3ILf5TN1Am0NZMAC1RjxgCucmftO0oJlQa56evVjK3ZXGMREHoil6
        tpU1qLUQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mSbZK-003eXe-0i; Tue, 21 Sep 2021 08:56:09 +0000
Date:   Tue, 21 Sep 2021 09:56:02 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/14] xfs: fix maxlevels comparisons in the btree
 staging code
Message-ID: <YUmeIkK4aBCW1lJK@infradead.org>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192859919.416199.9790046292707106095.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163192859919.416199.9790046292707106095.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 17, 2021 at 06:29:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The btree geometry computation function has an off-by-one error in that
> it does not allow maximally tall btrees (nlevels == XFS_BTREE_MAXLEVELS).
> This can result in repairs failing unnecessarily on very fragmented
> filesystems.  Subsequent patches to remove MAXLEVELS usage in favor of
> the per-btree type computations will make this a much more likely
> occurrence.

Shouldn't this go in first as a fix?

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

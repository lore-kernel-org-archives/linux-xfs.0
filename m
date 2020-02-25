Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D3CC35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADA1A2082F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:50:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KYZzoV2a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbgBYRub (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:50:31 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58964 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730236AbgBYRub (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:50:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QUamGBEY+94IxycvbSxUXrWWMyeZCTUrPTU2y6vj5YI=; b=KYZzoV2aCXS/RLSFU4hSZnNOTj
        FIwRjl4MoOhEjV/1NT9GMY5xnHgiMsoXUbLQPjB/R0T20Cjr8hiipBPyCp4Nu04wVaqxMlYAf1TFm
        TNSdpx8R5jt1hA3lu3dEVpcpaAUVOlxANTvdSGgyL7PndbAOMBlJQlmQkQ/kYv43lo2hS+Xmk03Q3
        h3+FI6z0S2QL5fH0YfT69Ai+FtWpUjbiVJI9Wk6DXblRT+kIHSTIneZnlzAg9Anr1He7foOuupwE2
        V7a9PRi1U6bH65yYDJYDe2pyG6PL7jZgFopYcl7EmUNeT5fbBO40oEFzrHNH/beRzL2xSlNBBo12O
        lw0Xp6hg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eLl-0000rs-UV; Tue, 25 Feb 2020 17:50:29 +0000
Date:   Tue, 25 Feb 2020 09:50:29 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/25] libxfs: straighten out libxfs_writebuf naming
 confusion
Message-ID: <20200225175029.GQ20570@infradead.org>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258959675.451378.7827280897436736817.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258959675.451378.7827280897436736817.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:13:16PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> libxfs_writebuf is not a well named function -- it marks the buffer
> dirty and then releases the caller's reference.  The actual write comes
> when the cache is flushed, either because someone explicitly told the
> cache to flush or because we started buffer reclaim.
> 
> Make the buffer release explicit in the callers and rename the function
> to say what it actually does -- it marks the buffer dirty outside of
> transaction context.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

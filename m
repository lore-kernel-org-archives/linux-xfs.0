Return-Path: <SRS0=fGHA=XF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF785C3A5A2
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Sep 2019 06:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F786208E4
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Sep 2019 06:46:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z7hPQ1S3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404292AbfIJGqM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Sep 2019 02:46:12 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55178 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729634AbfIJGqL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Sep 2019 02:46:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yLpnp9uHgMYp3hH4ehbKvmYxxrA8LK2APXaQVFB+v64=; b=Z7hPQ1S3AW71W1+Tz/0af51Uf
        CKMlZY1HZA7WNjhzTS2W+ixfkrtC1kKEGFRfZnOu/ABotxpT4c7whtIOdiMFgcywTaOVxAX7WUa10
        yiOyGHv6S/1wiaALNf51WXfQVWgO8p99kLM+06zBUuTxodKEVZAKgthfq5MdrXmc9WtnjugZ/tTTl
        jwB+YbwwOgnIzcWhq+s+PGSJvjSdfXt2gUSKgt0nBMM172gJf41dsyUB+H9AsFLhdOIi24+g3I1as
        1Gj4iMfljhOqSGWZobRGlQLTSyM2LZxL71ZTUKxddVQ1K29qn1c2nelWvXH+oo3bsznWCeKCGNVW4
        E4PxT3RoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i7Zuj-0001GI-NL; Tue, 10 Sep 2019 06:46:09 +0000
Date:   Mon, 9 Sep 2019 23:46:09 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] libxfs: revert FSGEOMETRY v5 -> v4 hack
Message-ID: <20190910064609.GA31220@infradead.org>
References: <156774089024.2643497.2754524603021685770.stgit@magnolia>
 <156774093481.2643497.5230418343512898938.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156774093481.2643497.5230418343512898938.stgit@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 08:35:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Revert the #define redirection of XFS_IOC_FSGEOMETRY to the old V4
> ioctl.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

As said before I think we should keep this as a v5 define and not
reuse a non-versioned name.

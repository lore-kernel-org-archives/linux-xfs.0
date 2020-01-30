Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD94C2D0DB
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 18:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79EFF20658
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 18:17:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eaJKTucr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgA3SRj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 13:17:39 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48252 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728815AbgA3SRi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 13:17:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lei7pvLt8tV/iA+5PtUYISKhXa9C+oBXYgSVDw4B+ns=; b=eaJKTucr6bJR1yhdlMM7fyCg1
        sZ97TO0GRK8/QzUMXee3jK7rP6Aq8Fy7opNt0CgnH6RymcECPsWwOhALRwY6xQh2P1xqLEGwVMUlI
        gzh0wU/xWYWzsPtVDfD46scl8vTJvYQzfaNJsryIPlPiGvxDUE5SnxCxVRZoJHGsRc66NrlfKYXjB
        EtYrbQB/CQ2Mn79GXjWpC3yXz19K1+RdCGmAsXq9GgzkOf5qfdUkUgwdTJ8PAWV/Tig9kkv0GKx8Q
        9EZAxRtg6dnE/kIe1zldYZvoVfnB3IZ8ginCG6Ij+J76rEH0vb1dL5ej5JlNM8A6FTQDDq/dcZPkS
        AQ4/UfxxQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ixENl-0007BH-5v; Thu, 30 Jan 2020 18:17:37 +0000
Date:   Thu, 30 Jan 2020 10:17:37 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/8] libxfs: remove duplicate attr function declarations
Message-ID: <20200130181737.GA27318@infradead.org>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
 <20200130181330.GY3447196@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130181330.GY3447196@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 30, 2020 at 10:13:30AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove these function declarations since they're in libxfs/xfs_attr.h
> and are therefore redundant.

Looks fine - in fact I have these removals in my attr series, just
piecemail..

Reviewed-by: Christoph Hellwig <hch@lst.de>

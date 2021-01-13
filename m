Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 036BAC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 15:07:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2EE923383
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 15:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbhAMPHy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 10:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbhAMPHy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 10:07:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6285C061575
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jan 2021 07:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gwqY3GcpIRBdSH0ZRCdjLkPMkEU4G5sECLJNOWwzcEc=; b=BN4hiWK3FyypQD0lF0xOXDXbae
        sHtgNcZqKn7+74Rwf916P0pdVV01cyz2IjQuS84qXRgt7r5MCKOYs0ajhjOnesSYfzGdKsobXo3sh
        t1qI2bFqsrJ3xXD7EyOuno6B95QNXTUkwpVgRv2C9fCt+08jjbH9ZR4qpScAbRnBBJCSCl6J5NSRa
        Zii36lIYO6S3ahJV8frrIAQs4SgDEQWPKf5oV5pkEnD/whZ+u9Ll7VOPt38CblqGkyczd5jOk6+Od
        LS5+njwORz3WvmSD1mfWQvr+TF/FWViMrOXZxZO7dm4NZvsbHwWen8DDxD2DNCCl04BQCUDgtjpox
        dKFnKlcw==;
Received: from 213-225-33-181.nat.highway.a1.net ([213.225.33.181] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzhjF-006OWp-Ux; Wed, 13 Jan 2021 15:06:57 +0000
Date:   Wed, 13 Jan 2021 16:06:32 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: only walk the incore inode tree once per
 blockgc scan
Message-ID: <X/8MeHhdwKLf3TCb@infradead.org>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
 <161040742666.1582286.3910636058356753098.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161040742666.1582286.3910636058356753098.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 03:23:46PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Perform background block preallocation gc scans more efficiently by
> walking the incore inode tree once.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good.  If you could find a way to avoid the forward declarations
I'd be even more happy :)

Reviewed-by: Christoph Hellwig <hch@lst.de>

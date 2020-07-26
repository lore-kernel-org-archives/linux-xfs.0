Return-Path: <SRS0=7j32=BF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB5A5C433E1
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jul 2020 15:15:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B54DB206E3
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jul 2020 15:15:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UahsiBU7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgGZPPH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jul 2020 11:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgGZPPG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jul 2020 11:15:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97317C0619D2;
        Sun, 26 Jul 2020 08:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ev1VURu58iCEGwGbY/Qyy/++BloxrBTIN1o2rMikomM=; b=UahsiBU7A6+9mo/fhhXeXL2qD3
        TpiwmeEApj/aVfbo+YJfzwvcDEor563+JOoSvBV9gV+wz7MQP7YM54XfrAloA/1xc9FL6MHkOQ9tX
        BwS+3LThvFdg/eKn1ycY9kZoNFFrHWKO6zm46gqDm7aJpkVEeNGKCjofB34Sr86Sv0noi0Id5gtMW
        GeRtR4Wxu7qYP+aOx8Rtqcagi37vAizrZWTrOwTlw+4/PRtZUTTLFjegagAFJm/Aa4Xoj1WIKGNXl
        ZVLocjCeMJejFwju0nnL8F+kVBLvJALZ1rjnN5oSmgqI5wp97EN5kNUEzfprzjl9Z26jCR81dl8AU
        JFCXqLDw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jziMi-0006XA-1t; Sun, 26 Jul 2020 15:15:04 +0000
Date:   Sun, 26 Jul 2020 16:15:04 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iomap: Ensure iop->uptodate matches PageUptodate
Message-ID: <20200726151504.GA24553@infradead.org>
References: <20200726091052.30576-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200726091052.30576-1-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 26, 2020 at 10:10:52AM +0100, Matthew Wilcox (Oracle) wrote:
> If the filesystem has block size < page size and we end up calling
> iomap_page_create() in iomap_page_mkwrite_actor(), the uptodate bits
> would be zero, which causes us to skip writeback of blocks which are
> !uptodate in iomap_writepage_map().  This can lead to user data loss.
> 
> Found using generic/127 with the THP patches.  I don't think this can be
> reproduced on mainline using that test (the THP code causes iomap_pages
> to be discarded more frequently), but inspection shows it can happen
> with an appropriate series of operations.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

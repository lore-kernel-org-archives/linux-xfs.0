Return-Path: <SRS0=Kgg+=CR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B3A1C43461
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 15:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38F2420738
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 15:16:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b4sont4J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbgIHPQk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 11:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730243AbgIHPQW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 11:16:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630BAC0068FB;
        Tue,  8 Sep 2020 08:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nCeojqv6Cdl3bIDyPUvvQo+Kcvz6OKyJs7qAaNHnJyE=; b=b4sont4Jxv3OF8hog4D2f+5uQr
        JMHLr1gOQuJ7RkwhGtwGgPkBtyr8duBVwnzrc/4CZpinU3kZB4YopkPAy1YYysDzEbEAkoTq/Bh3P
        rT7gzDhr+1ASO3BQZwaYRSXg0HXJsV2vMP6UR3ipUcesacnsvb2xZ4/tP2T9WF59W08OBITxsn3bP
        jZOruDuPUPHrRcPavRX7JkDR250GZ/QL1InHJ20fLVidyseyZRpnYN5XGixT5EAheWSKQxv/XQkdn
        hVTU/gphFNym2fdCDMK8RuhA798AcI3ZmnFwT24WGNODrtCR2Pq3JFAuRhu+6QyjWX4TeVgZ5wZcy
        TlKbvdMw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFf9V-0003WH-4T; Tue, 08 Sep 2020 15:03:21 +0000
Date:   Tue, 8 Sep 2020 16:03:21 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: Mark read blocks uptodate in write_begin
Message-ID: <20200908150321.GP6039@infradead.org>
References: <20200907203707.3964-1-willy@infradead.org>
 <20200907203707.3964-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907203707.3964-3-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 07, 2020 at 09:37:07PM +0100, Matthew Wilcox (Oracle) wrote:
> When bringing (portions of) a page uptodate, we were marking blocks that
> were zeroed as being uptodate, but not blocks that were read from storage.
> 
> Like the previous commit, this problem was found with generic/127 and
> a kernel which failed readahead I/Os.  This bug causes writes to be
> silently lost when working with flaky storage.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

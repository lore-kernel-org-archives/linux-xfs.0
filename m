Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7618C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BC6F20707
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:41:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e4xV2hx1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgH0IlO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgH0IlN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 04:41:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D63BC061264;
        Thu, 27 Aug 2020 01:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kCDwh714vx6JpM9OxrrZFig4MnZIKPAe4emls/wRWFk=; b=e4xV2hx1QjxcBvvjPLZC2yQKC2
        z0p+A9rzXH46HU6Hnb0Fa44YAEV8lfbtJs7ITmMrdaUzQvGQdkcLzq26/ZWVnMG7o9Xq6XoeEWOq4
        z0NNwRkoo1DOfGglwB6OUlp5h0mN1LZL1UugAyanNoGhh/A1UfAvWkkW7Nhwe/QMh4ohCZvFSA8eG
        AnXOhzHJhZ1cGnqlcpv8zx6p1fVdNNM10G66Ctr0ApExmF1uQA5hr0AG4ZVVgdB7CY7eTnduqJKVJ
        7QsqjYYmHqNXzm4DrOsUdvZsQW8es6U+OifFi+pOFSzE0mwFPaZwKYFZ3TYj2dFoEmLPe9tZmL5iF
        sSIHc6CA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBDT5-000480-Om; Thu, 27 Aug 2020 08:41:11 +0000
Date:   Thu, 27 Aug 2020 09:41:11 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] iomap: Convert iomap_write_end types
Message-ID: <20200827084111.GF11067@infradead.org>
References: <20200824145511.10500-1-willy@infradead.org>
 <20200824145511.10500-9-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824145511.10500-9-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 24, 2020 at 03:55:09PM +0100, Matthew Wilcox (Oracle) wrote:
> iomap_write_end cannot return an error, so switch it to return
> size_t instead of int and remove the error checking from the callers.
> Also convert the arguments to size_t from unsigned int, in case anyone
> ever wants to support a page size larger than 2GB.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

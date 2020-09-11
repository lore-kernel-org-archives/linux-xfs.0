Return-Path: <SRS0=CRyL=CU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A16CC2BC11
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 06:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D94AB221F0
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 06:43:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iOa8WVA0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbgIKGnG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Sep 2020 02:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgIKGm6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Sep 2020 02:42:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17176C061756;
        Thu, 10 Sep 2020 23:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aIvY0q20GUY/DyC1n3nmNDnvd2ld2xPPMKNm8jNNfkM=; b=iOa8WVA07pDrSye4+Sgz/bCdG7
        rG9Wvg4hwkJeg9OyR+jG6wGqjzEWeTJPBPRlulGaPOS8UQZBVL3v+KPzz0WfLKwmrsxExuJ5t5xC5
        g3J0StagGG7heOkmNejJ2RO5a5Kvk0eL9K7O7byeRuioMbN3ZBxYUCJm8k9q6vSg+oLVpkaeIS9T+
        fZf53xjd66KreZwQg9XqEGbThYuwm+YofNf/i+KbJjLceEwM1rLoD+dVeahBKNYDwpYu/LwqinWqA
        hQy5DfAYGwoUs4wZuoGCRTDTlsjSnnTSPgon+3SyLB+AkkNy0/stPaoD3NvES6scv3l3F42l2mz3W
        VscFLl6Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kGclq-0007pp-Lt; Fri, 11 Sep 2020 06:42:54 +0000
Date:   Fri, 11 Sep 2020 07:42:54 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org,
        Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: Re: [PATCH v2 9/9] iomap: Change calling convention for zeroing
Message-ID: <20200911064254.GA24511@infradead.org>
References: <20200910234707.5504-1-willy@infradead.org>
 <20200910234707.5504-10-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910234707.5504-10-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 11, 2020 at 12:47:07AM +0100, Matthew Wilcox (Oracle) wrote:
> Pass the full length to iomap_zero() and dax_iomap_zero(), and have
> them return how many bytes they actually handled.  This is preparatory
> work for handling THP, although it looks like DAX could actually take
> advantage of it if there's a larger contiguous area.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

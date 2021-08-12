Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6D2C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 392F761058
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbhHLIZi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233921AbhHLIZg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 04:25:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F50C061765
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 01:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zKP64c3na4ZKC1rJduK92QN3dH7iyL2eMyDImOUlxNg=; b=u+UP6WELPogH8yw8tgvaAOmSBc
        /FRTGkaAz0d9DQDDvK7JD16qt5+/LSORrNlHSyyjc0KyqAPWMO2uaKqEdbt7rfnVjhShJCkjRaYBM
        jqLF7SY4YJmj/Z60YFwuVlHv44T6WADZqTZT2glC54I59d8ypIBBlWVIeJRJaV6G+l4DbGsS/2BW4
        +HWYML7iPRWJHeisHdEzWndz5ybBQ9doearHmPzkjAlMidC/LQz8mzgsePVQgJiaPayQOiq/uPIVw
        2ZokFGuV7/WHDPmIifOs3kCUGI+nhoTzqzFgr7b39DbgcEZG4pN883EoWyWeSkjC1/uYuEsjGXoSH
        TKVQV82g==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE60F-00ELCa-GK; Thu, 12 Aug 2021 08:24:21 +0000
Date:   Thu, 12 Aug 2021 09:23:51 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: rename buffer cache index variable b_bn
Message-ID: <YRTal4x6M21Nc7Dz@infradead.org>
References: <20210810052851.42312-1-david@fromorbit.com>
 <20210810052851.42312-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810052851.42312-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 10, 2021 at 03:28:51PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> TO stop external users from using b_bn as the disk address of the
> buffer, rename it to b_index to indicate that it is the buffer cache
> index, not the block number of the buffer. Code that needs the disk
> address should use xfs_buf_daddr() to obtain it.
> 
> Do the rename and clean up any of the remaining b_bn cruft that is
> left over and is now unused.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although the XFS_BUF_SET_ADDR really is a separate thing and should
probably have been a separate patch.

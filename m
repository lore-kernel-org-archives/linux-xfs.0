Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D0DFC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 07:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F60522BEA
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 07:21:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MyQSNuzi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgH0HVE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 03:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgH0HVD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 03:21:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE4EC061264
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vTNIWOoPQCtGcp0azNbd2ycLYPeMYWg+sYmc2dEAIu8=; b=MyQSNuziHTqfY8cZ/zNLTdW1Gr
        WJqSrMdweN0v//24YUmH8pR+noJfM31nYNOGc7rGSEnGuUb+XRffSJo/LYhvf6XNqeEroJPFV2YDv
        9MU6D6vtPj9n5go+bXjPgU8FOSzsgPSQ9j/CVaUDuV0XRhVzsr87cobb8gt+tHDw4GnT2LbppyKty
        NmWnRuajLQujzFDICRvDhByiAcgJQ8HcBqt5KkJ1RNWmnZ7PcD2fNch3GQVwXJZLvVMbe+lBqRYmE
        UGEpXKiVHyVFZ+GoWuWFBOOTTFcQfZOeXP9sYbedKDleoNHHWQaqGQvz+sK0/rg/GF7QukL4mXqhw
        MQghLstQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBCDV-00074i-Gq; Thu, 27 Aug 2020 07:21:01 +0000
Date:   Thu, 27 Aug 2020 08:21:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/13] xfs: add unlink list pointers to xfs_inode
Message-ID: <20200827072101.GE25305@infradead.org>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-6-david@fromorbit.com>
 <20200822090339.GB25623@infradead.org>
 <20200825051753.GM12131@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825051753.GM12131@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 25, 2020 at 03:17:53PM +1000, Dave Chinner wrote:
> That's precisely the complexity this code gets rid of. i.e. the
> complex reverse pointer mapping rhashtable that had to be able to
> handle rhashtable memory allocation failures and so required
> fallbacks to straight buffer based unlink list walking. I much
> prefer that we burn a little bit more memory for *much* simpler,
> faster and more flexible code....

It's not like we care about memory allocation failures else where.
I suspect an xarray could work pretty well here, but I can look into
that myself once I find a little time.

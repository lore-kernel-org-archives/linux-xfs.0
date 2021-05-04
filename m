Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36BB2C433B4
	for <linux-xfs@archiver.kernel.org>; Tue,  4 May 2021 06:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CE52611AC
	for <linux-xfs@archiver.kernel.org>; Tue,  4 May 2021 06:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhEDG63 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 May 2021 02:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbhEDG63 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 May 2021 02:58:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C21C061574
        for <linux-xfs@vger.kernel.org>; Mon,  3 May 2021 23:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Bfj4jyFsvcX4xftr0tEb3iVIkUi29lS5fs+DCwVXvsM=; b=Dknm8vWuvqS8K6KM2c9W17f6vQ
        HjuFHWeVwr1XUWtSOA7h15oE4nATj4guauIj2LPAGilfqCejFrmP6c8oocL5EjndehnF48SZrMx/Y
        Y64ARWDfD8felrBYnTZKuG3NbFMpLQ5A6mw5jq4VDGP17KdaFYjXqrkhS8UkqZPcxdxKypeaTOyae
        BXn0eQMhAkmor4ZfL4eK78/seRn3qWv2pIyQ8tHX4CrL3TyT1FwR13gHEK5pTzhIysWkE5dDYXdta
        gZVvMBP6UqpMd5767l7wsyLtQMJYM6qc6y0X9P230d7VuA511oFqUvI+3CjPMd1TIkoHSnkCCe0eJ
        xvOKvgbg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ldozQ-00GFup-8n; Tue, 04 May 2021 06:57:12 +0000
Date:   Tue, 4 May 2021 07:57:04 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: mkfs is broken due to platform_zero_range
Message-ID: <20210504065704.GA3871777@infradead.org>
References: <20210504002053.GC7448@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504002053.GC7448@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We'll need to quirk the device in the kernel.  Can you send the report
including the output of 'nvme id-ctrl /dev/nvme0' to the linux-nvme
list?

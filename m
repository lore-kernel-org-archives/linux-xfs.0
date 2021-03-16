Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7219C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 08:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7827B64E4D
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 08:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhCPIoa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 04:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbhCPIoB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Mar 2021 04:44:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDBCC06174A
        for <linux-xfs@vger.kernel.org>; Tue, 16 Mar 2021 01:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QoftQ4PTeYuUGwtKjPaPyjgRF1DZHIoA7Jq9mPJZSZk=; b=bvm0Wvdw2cY3izcmXKATlnQHBC
        yAsopE8i73JBjzLlM8G76xvv6GgOqvrjLAINZXRsi6+kbCQgCzjo1aychcIeGHgeXG9hh0rbKUx0z
        upNuJvdPSsALc5enanVGeyX+EaAYgeg6qY6VUoZUUh8hyRKFTSei9rOmsVvjBcLDR9XEhEzu05wTo
        qm/Om+yyZ8++H2z19I7XmxC49Zw1PS6MzEILXkFz4wFSvpl7CnY3z3zVI5HR5bPMP9H1A2iJbo6Dw
        /oHQykHzVH/M7a6Obce1tt/k8Gzd4/acJYv1BhXHHoBiw9eH2/SfUQiPp9BRjRNe8TKLktxLhX+dI
        yMQzMGNg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lM5IK-001g56-EF; Tue, 16 Mar 2021 08:43:28 +0000
Date:   Tue, 16 Mar 2021 08:43:16 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/45] xfs: async blkdev cache flush
Message-ID: <20210316084316.GD398013@infradead.org>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-6-david@fromorbit.com>
 <87eegq3rja.fsf@garuda>
 <20210308222407.GA3419940@magnolia>
 <YE9yCbItv9Q8V0ic@bfoster>
 <20210315163222.GC22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315163222.GC22100@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 15, 2021 at 09:32:22AM -0700, Darrick J. Wong wrote:
> Yes, I agree with that principle.  However, the use case for !done isn't
> clear ot me -- what is the point of issuing a flush and not waiting for
> the results?

There is none.  This check should go away.

> 
> Can PREFLUSHes generate IO errors?  And if they do, why don't we return
> the error to the caller?

The caller owns the bio and can look at bi_status itself.

Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E58B7C48BE8
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 14:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE31561222
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 14:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbhFROaV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 10:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234507AbhFROaV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 10:30:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B465C061574
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jun 2021 07:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=q6mf9bEOKjqsZ8xxf0Vg1SpD4LCyw7Dj0/m6K7JpCOg=; b=HjUQ3km7jZgwJfUlSLUf5mpZxS
        2fnTFZsoQSYJOCvFSGrQCARAwflqjKeFm/2mRnYOqy3DZq3pJHrisdvwV5VJc1/+3uqwPKqAgGk+N
        uqk4sG0ixiGt/CRCJ5y81BqAZpizZxREke5bmmo6nR5eupAyOHOSTP1REjIawjVsIxSK+2d5jOOqI
        MyPpTzKOSnxOFFbYhvx4lijrkKsefuSlUTkKnEFA2VrHHR3UThf6YysMVwBsVb4w87licyCphT5Zk
        OG2oqLS5LQSZSWD3FqlG7TBJFq4DJaz8C3IeH2Sk2eQxbLscvAtjFu7mV6lZNsfH/Lqk9vfxMmxP3
        2oLuq7HA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1luFTJ-00AMBj-KG; Fri, 18 Jun 2021 14:27:53 +0000
Date:   Fri, 18 Jun 2021 15:27:49 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: factor out log write ordering from
 xlog_cil_push_work()
Message-ID: <YMytZZVUOtDVyyAj@infradead.org>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210617082617.971602-6-david@fromorbit.com>
 <20210617195904.GW158209@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617195904.GW158209@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 12:59:04PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 17, 2021 at 06:26:14PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > So we can use it for start record ordering as well as commit record
> > ordering in future.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> This tricked me for a second until I realized that xlog_cil_order_write
> is the chunk of code just prior to the xlog_cil_write_commit_record
> call.

Yeah, moving the caller at the same time as the factoring is a trick
test for every reader.  I think this needs to be documented in the
commit log.  Or even better moved to a separate log, but it seems you
get shot for that kind of suggestion on the xfs list these days..

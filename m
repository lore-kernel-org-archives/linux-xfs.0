Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B359C433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 05:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0BB764DED
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 05:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbhA2F6I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Jan 2021 00:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhA2F6H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Jan 2021 00:58:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7D1C061573
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 21:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kH8+XvwQcoFQOXOKSejkD+P2JzLaVQyOjJJGpIGLh5Y=; b=RmpedheKbRx7pOjUYrMkk4+3VP
        JFAWgDC4Wt2f7iLzji1UDDDQG3yN5bToo88fai/pf7awJTcosr1JjdnFVr+lAyI+jjeLrcX3tXIU2
        trmZTPyL9iMLa+VUscqZ6sfxVeMxaD84NS7Acd7+TmdGe40HQx91WYbw8ReoZRLkUl27dhJATYMox
        kkbfCs4hBBzXxQmI+btET5cydRVATuotozXH+3zDyT/sdQATjibdNiuhq1vAULqj+L/SmANve6JGe
        xSF0kUVgtAcebaGM97k8bsbU6A5CWRy+3OuSbWDrSjgvJRZjPYiFB7O41kSNHm3s+eOdHl6Lb/GV9
        eGD0EjAw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l5MmZ-009S51-2X; Fri, 29 Jan 2021 05:57:23 +0000
Date:   Fri, 29 Jan 2021 05:57:23 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 06/13] xfs: reduce quota reservation when doing a dax
 unwritten extent conversion
Message-ID: <20210129055723.GA2252837@infradead.org>
References: <161188658869.1943645.4527151504893870676.stgit@magnolia>
 <161188662355.1943645.4498589995636729261.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161188662355.1943645.4498589995636729261.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 06:17:03PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In commit 3b0fe47805802, we reduced the free space requirement to
> perform a pre-write unwritten extent conversion on an S_DAX file.  Since
> we're not actually allocating any space, the logic goes, we only need
> enough reservation to handle shape changes in the bmbt.
> 
> The same logic should have been applied to quota -- we're not allocating
> any space, so we only need to reserve enough quota to handle the bmbt
> shape changes.
> 
> Fixes: 3b0fe4780580 ("xfs: Don't use reserved blocks for data blocks with DAX")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

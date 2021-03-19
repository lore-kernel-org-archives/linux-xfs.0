Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E82C433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 16:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04D7B61942
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 16:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhCSQtP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 12:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbhCSQsu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Mar 2021 12:48:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363A4C06174A
        for <linux-xfs@vger.kernel.org>; Fri, 19 Mar 2021 09:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9djMfXiBj/gKMK1aShyZ9ySYCN6XCBNM+KUF3aPFIfE=; b=E/65e852IOBnbCFT8e0S1UnLvy
        yGsUbyXyBc6daLCWf23wlm35WiDvBzdCZXdHv6xgcoRmejYxN61N7c2MwhHa9zjpDhMVlC/7ma1Fj
        I/jniwcxaXtdIV3QSbuf2jLKKBnyh18b+J0M3GoRFjdlf7RLp3kKWNlGqS8KkbH/F6hRFXn1LPeud
        DuTbRgLdCIfiFfr+CNFAex8aFwtB097ZYhLfVvHPrPZUbpYRimwBVYhmLOSL6FrMT76qWjUk4VDz6
        Lbg3ZyLXFDzyyyrilpaMXAXSxoNqmuCEFQ+cUtscMfGZhvkZB/ahzZLVt5gttoqRhdqhjklYf8cHa
        HxRHA3BA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lNIIK-004iZ5-Px; Fri, 19 Mar 2021 16:48:27 +0000
Date:   Fri, 19 Mar 2021 16:48:16 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: remove tag parameter from xfs_inode_walk{,_ag}
Message-ID: <20210319164816.GA1123710@infradead.org>
References: <161610681966.1887634.12780057277967410395.stgit@magnolia>
 <161610682523.1887634.9689710010549931486.stgit@magnolia>
 <20210319062501.GC955126@infradead.org>
 <20210319164354.GQ22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319164354.GQ22100@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 09:43:54AM -0700, Darrick J. Wong wrote:
> One thing that occurs to me -- do the quota and rt metadata inodes end
> up on the sb inode list?  The rt metadata inodes definitely contribute
> to the root dquot's inode counts.

Yes, everything going through xfs_iget ends up on ->s_inodes.  But they
a) don't have dquots and b) we specifically skip the quota inodes (but
not the RT ones) in the existing code already.

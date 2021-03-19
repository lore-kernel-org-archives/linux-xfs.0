Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B0FC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 06:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7211464F6E
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 06:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbhCSGgj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 02:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbhCSGgP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Mar 2021 02:36:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457CBC06174A
        for <linux-xfs@vger.kernel.org>; Thu, 18 Mar 2021 23:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tZw4q+LpNY7xPZq4827yhXJC3hLCfEzh/x87P/vz6Qk=; b=XA2pwEZTqz/zaXz3QqIUJqOAz8
        RmIcdnDteHw1q/vFxvGIg+ZMUgFlLj97uySCneZTgQmwaZDpqTOGEXKXc+/jMW3FWA1lmF3klLxrX
        sF7eGAYTQPTY4P+MaDiBV8J4g/I1lZ55cIHFafRIr724M7EhhVmiJ5flJNYPdnu7AZeXVKwW+l3/l
        G7MqKuCPV4wtFqIMrJf27vre4t8SywygyNGUuSCa4k/bsxUV93WoYf9C9JoeMXaQqpz7XlTrnwQ9N
        IjV8ru+kYTWxXFwyFgmuTP/byndQpqRnHrPaKrp3HEp/oKEIQzJxF8fYba5Q9WG5Q/8RkZqwgWQpK
        pwbe9nkw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lN8jR-0043Xo-1f; Fri, 19 Mar 2021 06:35:48 +0000
Date:   Fri, 19 Mar 2021 06:35:37 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: move the check for post-EOF mappings into
 xfs_can_free_eofblocks
Message-ID: <20210319063537.GB965589@infradead.org>
References: <161610680641.1887542.10509468263256161712.stgit@magnolia>
 <161610681767.1887542.5197301352012661570.stgit@magnolia>
 <20210319055907.GB955126@infradead.org>
 <20210319060534.GF1670408@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319060534.GF1670408@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 18, 2021 at 11:05:34PM -0700, Darrick J. Wong wrote:
> xfs_inactive doesn't take the iolock because (evidently) at some point
> there were lockdep complaints about taking it in reclaim context.  By
> the time the inode reaches inactivation context, there can't be any
> other users of it anyway -- the last caller dropped its reference, we
> tore down the VFS inode, and anyone who wants to resuscitate the inode
> will wait in xfs_iget for us to finish.

Yes.  What I meant is that if we can deduce that we are in inactive
somehow (probably using the VFS inode state) we can ASSERT that we
are either in inactive or hold the iolock.

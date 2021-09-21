Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D799DC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Sep 2021 09:04:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE9F760EE4
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Sep 2021 09:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhIUJGD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Sep 2021 05:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhIUJGD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Sep 2021 05:06:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4BDC061574
        for <linux-xfs@vger.kernel.org>; Tue, 21 Sep 2021 02:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jJDzcwRgsAVQLKWMuLUxhQ9IiQg5NJdlg47IJLyeYvI=; b=EV7XfRHbjwXQqGUjCe9SVjDpj2
        XXxNUuoAbVqKvfHsPms3fvPmRzvp7mb/nuzrJkA8l1JvBYgfxmmYd4n70MKhw6rOd5mMVPLpsbWCq
        zTzTAyJsQ7IeatffGs01bpwHz9o5o8bVZz1gVvbAUR+/ntk5sehdVgn83eQa9BZHSlGD06nbOiRX1
        8N5zi68qsZdd/EubzaXFEJHu7eJW2dW0hXXG9mK8N5jnCVd2QfJ5glMiuyN7E6O4bd8rqYbvktaEY
        OYLGjgvo4tlo/dHHyJ+XE5PqCZRtUVKpDcS5m2Lx8yMZ2g0l7oGApOCOtPCPZTPQ4oGZlBF34yuM7
        zZB1Pw8g==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mSbgr-003epn-J6; Tue, 21 Sep 2021 09:03:57 +0000
Date:   Tue, 21 Sep 2021 10:03:49 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, chandan.babu@oracle.com,
        chandanrlinux@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/14] xfs: dynamically allocate cursors based on
 maxlevels
Message-ID: <YUmf9Zmp01WcEw0T@infradead.org>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192861018.416199.11733078081556457241.stgit@magnolia>
 <20210920230635.GM1756565@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920230635.GM1756565@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 21, 2021 at 09:06:35AM +1000, Dave Chinner wrote:
> On Fri, Sep 17, 2021 at 06:30:10PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Replace the statically-sized btree cursor zone with dynamically sized
> > allocations so that we can reduce the memory overhead for per-AG bt
> > cursors while handling very tall btrees for rt metadata.
> 
> Hmmmmm. We do a *lot* of btree cursor allocation and freeing under
> load. Keeping that in a single slab rather than using heap memory is
> a good idea for stuff like this for many reasons...

Or rather a few slabs for the different kind of cursors.  But otherwise
agreed.

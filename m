Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C45CC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 17:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA23964DA2
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 17:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbhA0RA4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 12:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbhA0Q6c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jan 2021 11:58:32 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D6FC061573
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 08:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=I683NeL2tnvR2IRPyGeclLuQUuP6aOiX4zBRhR5qjbo=; b=jK0J4HniR9Dw0aawqSwuRb9bhF
        AuR5RZ4N0xKxYJeGwROg6VyCPZlhOcddfCtODoBP1jkqbi6Wl0tNXoRWHe054RLwxV2G+xN6vlhXh
        TpAU1WnXS3znACiWgNudTFbp8NIaQyokJ9gx279pw7GAnRrPOJb4/mDJNA8zfsmgLlHR2vS5Q8EFN
        HBVV2ZRi7/tTK/sSDQd5OHpJrGcDxBcT62h2npJwiG8JPQJYKLjUCLj9rYysMEkdYPQSVcfT2eg+A
        6GQ5eDK50t5ZQqoTtUi3lObKFvNvWZ1bgbMWjwE7SOZ0OKTzXVYAtZgdmajtgEfLBdxJvcnDmdqMv
        +6p7y8Cw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l4o8M-007G3q-Ta; Wed, 27 Jan 2021 16:57:38 +0000
Date:   Wed, 27 Jan 2021 16:57:34 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 11/11] xfs: flush speculative space allocations when we
 run out of space
Message-ID: <20210127165734.GA1729362@infradead.org>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142798066.2171939.9311024588681972086.stgit@magnolia>
 <20210124094816.GE670331@infradead.org>
 <20210125200216.GE7698@magnolia>
 <20210125210628.GP2047559@bfoster>
 <20210126002901.GI7698@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126002901.GI7698@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 25, 2021 at 04:29:01PM -0800, Darrick J. Wong wrote:
> ...except that doing so will collide with what we've been telling Yafang
> (as part of his series to detect nested transactions) as far as when is
> the appropriate time to set current->journal_info/PF_MEMALLOC_NOFS.

Can't we do that based on a log/blk reservation?  If not I'm also fine
with going back to your original goto based loop, it just looked rather
cumbersome to me.

Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36D3C433B4
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 08:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CBA160BD3
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 08:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbhDGIBA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 04:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhDGIBA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Apr 2021 04:01:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A21C06174A
        for <linux-xfs@vger.kernel.org>; Wed,  7 Apr 2021 01:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IkpPbvAt8IQqpxNdm/uEA3XybkUDzIUK4FC0f/Rtuvw=; b=B5f21vQW1xslzB6FNl8iMLLtqi
        pPl97j957u+m4GzDWPokFfR6Jyn4LG++IkzJU+VhHs+1p/HA5oTSMndanVRCbFNUy6LNJoRSyfvLj
        F8/Y+CH4tJiwykbUnAdds+f+PqDL+tA4icId5RVWJyewA+nYEw3GgO5XLPtlpD5rykY5S7QKBJRRs
        g0Xh9YWAX4nLdQfsPByjjNmvPq65N3p3MSD4fLuKQBHk3Bj8kcfUls2vFn5DT1EuTsSGhpj+tg5ni
        ivbJQja/39HJBljEiyuhSNYzZRSTTBkDHRi7hv1jDm0bDqfZHrQszSBa/jin8T+NqmVUCbh9Lp96e
        /LyyzGuw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lU37B-00E7o1-79; Wed, 07 Apr 2021 08:00:43 +0000
Date:   Wed, 7 Apr 2021 09:00:41 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] xfs: transaction subsystem quiesce mechanism
Message-ID: <20210407080041.GB3363884@infradead.org>
References: <20210406144238.814558-1-bfoster@redhat.com>
 <20210406144238.814558-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406144238.814558-3-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 06, 2021 at 10:42:37AM -0400, Brian Foster wrote:
> The updated quotaoff logging algorithm depends on a runtime quiesce
> of the transaction subsystem to guarantee all transactions after a
> certain point detect quota subsystem changes. Implement this
> mechanism using an internal lock, similar to the external filesystem
> freeze mechanism. This is also somewhat analogous to the old percpu
> transaction counter mechanism, but we don't actually need a counter.

Stupid question that already came up when seeing the replies to my
s_inodes patch:  Why do we even care about quotaoff?  Is there any
real life use case for quotaoff, at least the kind that disables
accounting (vs enforcement)?  IMHO we spend a lot of effort on this
corner case that has no practical value, and just removing support
for quotaoff might serve us much better in the long run.

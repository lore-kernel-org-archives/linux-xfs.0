Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B4FAC433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 13:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 513DE64DAE
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 13:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhBANAC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 08:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhBANAA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Feb 2021 08:00:00 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DC4C061573
        for <linux-xfs@vger.kernel.org>; Mon,  1 Feb 2021 04:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UypnU4xwvPutf8sf9hx1wtPzneASbWB+JCMdPTwtYZI=; b=OZplyMPBeEC0r9zabPIZQmz0eE
        jlSs5Q7RGQBL+knhg5+CKgOKj3QfPeKLzxoyBsOFSHkwkUVWtuzZpI4oEMTZPvX0xl/FyRB5fDUzy
        Mbr0Vhr/+5FEZ04oG9Ib1LKexMRT8QUmAOqMnIlFX96mNxzb2I9uB0ElTlpy4YicvQetQ2QE3LWpC
        Y5omI/nR1wNq5HSeVgcXnreuXwJ646BMqv4f5LVuD2bNBukkssmllN3rhXqfPI5f7UYIVzxcAfJYx
        //jBRs6x+yn2ESp2VZqrG0ZoVAFi8JcXUw30ZP6IQ1jTKokk7/Z6nXSojOBTd4E6VfFEKkjehcHA7
        0S/kxrXg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l6YnW-00Dn0b-6Z; Mon, 01 Feb 2021 12:59:18 +0000
Date:   Mon, 1 Feb 2021 12:59:18 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: separate CIL commit record IO
Message-ID: <20210201125918.GA3285231@infradead.org>
References: <20210128044154.806715-1-david@fromorbit.com>
 <20210128044154.806715-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128044154.806715-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 03:41:51PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To allow for iclog IO device cache flush behaviour to be optimised,
> we first need to separate out the commit record iclog IO from the
> rest of the checkpoint so we can wait for the checkpoint IO to
> complete before we issue the commit record.
> 
> This separate is only necessary if the commit record is being

s/separate/separation/g

> written into a different iclog to the start of the checkpoint. If
> the entire checkpoint and commit is in the one iclog, then they are
> both covered by the one set of cache flush primitives on the iclog
> and hence there is no need to separate them.
> 
> Otherwise, we need to wait for all the previous iclogs to complete
> so they are ordered correctly and made stable by the REQ_PREFLUSH
> that the commit record iclog IO issues. This guarantees that if a
> reader sees the commit record in the journal, they will also see the
> entire checkpoint that commit record closes off.
> 
> This also provides the guarantee that when the commit record IO
> completes, we can safely unpin all the log items in the checkpoint
> so they can be written back because the entire checkpoint is stable
> in the journal.

I'm a little worried about the direction for devices without a volatile
write cache like all highend enterprise SSDs, Arrays and hard drives,
where we not introduce another synchronization point without any gains
from the reduction in FUA/flush traffic that is a no-op there.

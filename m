Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC65C00A8F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Oct 2023 12:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbjJXMJz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Oct 2023 08:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbjJXMJy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2023 08:09:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F506120;
        Tue, 24 Oct 2023 05:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cirv4ndqjxPdzRBdPJic5vaz9dOLi3WYy0YXH6TCVi0=; b=pHo0uJ5Ga4SZ4iq+fNOeCu2Fuh
        kthT3tF81ELkOCP0cRABWYjp+7x9icLmh+tcYokQOrc2tb3XPY7GH+8w599Uuc/GzeRvIcaZ3VM4g
        EH5WfRUincNOpQJxLwS9NOEU2iHloEIZOHUhM2nEhA0tbrfpaI2uAEKLVDUozd94I62JSggGGEYjO
        VSqWBbQM9pAKg7TudzHnun+nukAl5X72P1I+1Y9ejtnB4zHugb8fBDK572NqOaI26VX7AFOKOKX4a
        urmWo//FZWKNBUxXHmnbzBtV0bnaSZZEtyLiCVe0x3zUAC/9ArBKn2OSYq4bDHKihn2XrctpfTa3R
        dEBVHitg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qvGEF-002M4u-QL; Tue, 24 Oct 2023 12:09:48 +0000
Date:   Tue, 24 Oct 2023 13:09:47 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] filemap: add a per-mapping stable writes flag
Message-ID: <ZTe0C90lRfp7nnlz@casper.infradead.org>
References: <20231024064416.897956-1-hch@lst.de>
 <20231024064416.897956-2-hch@lst.de>
 <CAOi1vP_mF_A6OmNvYPvmBcS-CHQkwOHqsZ1oAZCJXQmow3QUMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOi1vP_mF_A6OmNvYPvmBcS-CHQkwOHqsZ1oAZCJXQmow3QUMw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 24, 2023 at 02:03:36PM +0200, Ilya Dryomov wrote:
> > +static inline void mapping_clear_stable_writes(struct address_space *mapping)
> 
> Hi Christoph,
> 
> Nit: mapping_clear_stable_writes() is unused.

It's used in patch 3

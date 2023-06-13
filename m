Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 328E8EB64D0
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jun 2023 13:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239539AbjFMNe3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jun 2023 09:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240133AbjFMNe1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jun 2023 09:34:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA4610EC;
        Tue, 13 Jun 2023 06:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=N950dvjtG/k/DDXqXESHqcm/sUH57Wlt9aTONE78An8=; b=FGYlE5QNMntLzrdCt814PKiJXn
        xYXYQM4q6bvvKZBYTidsnJ6F3r8x9Khfbt44L9M9HHOeEYDDPpWqQQw2XV48OMCXnQkCtkGVzItDS
        SaNSU1vjekacjM1Nf2wz+tmCWIbqEAmPzK49W3oKscdSRBr9NzzQufiWbIs8go8k37Fcgbeoh987S
        hHpg/eNC1c1aKJSLJkGahXSctFowXyM2uN5fzVUeASvEl+HHdGjV3j67oX2Eo+7f3DU1+moXX7RjM
        moIVXphpXxsbtp2Z+GTmuVCTk81RXqz/yxI4u9r28hfDhsPW/4d68roqKWGKjB8LuwOPG5lCcQNYt
        NEGdcGHA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1q94A7-003wRI-Dv; Tue, 13 Jun 2023 13:34:19 +0000
Date:   Tue, 13 Jun 2023 14:34:19 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v3 6/8] filemap: Allow __filemap_get_folio to allocate
 large folios
Message-ID: <ZIhwW9pEAS8ULc9X@casper.infradead.org>
References: <20230612203910.724378-1-willy@infradead.org>
 <20230612203910.724378-7-willy@infradead.org>
 <ZIeg4Uak9meY1tZ7@dread.disaster.area>
 <ZIe7i4kklXphsfu0@casper.infradead.org>
 <ZIfGpWYNA1yd5K/l@dread.disaster.area>
 <ZIfNrnUsJbcWGSD8@casper.infradead.org>
 <ZIggux3yxAudUSB1@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIggux3yxAudUSB1@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 13, 2023 at 05:54:35PM +1000, Dave Chinner wrote:
> On Tue, Jun 13, 2023 at 03:00:14AM +0100, Matthew Wilcox wrote:
> > On Tue, Jun 13, 2023 at 11:30:13AM +1000, Dave Chinner wrote:
> > > I think this ends up being sub-optimal and fairly non-obvious
> > > non-obvious behaviour from the iomap side of the fence which is
> > > clearly asking for high-order folios to be allocated. i.e. a small
> > > amount of allocate-around to naturally align large folios when the
> > > page cache is otherwise empty would make a big difference to the
> > > efficiency of non-large-folio-aligned sequential writes...
> > 
> > At this point we're arguing about what I/O pattern to optimise for.
> > I'm going for a "do no harm" approach where we only allocate exactly as
> > much memory as we did before.  You're advocating for a
> > higher-risk/higher-reward approach.
> 
> Not really - I'm just trying to understand the behaviour the change
> will result in, compared to what would be considered optimal as it's
> not clearly spelled out in either the code or the commit messages.

I suppose it depends what you think we're optimising for.  If it's
minimum memory consumption, then the current patchset is optimal ;-) If
it's minimum number of folios allocated for a particular set of writes,
then your proposal makes sense.  I do think we should end up doing
something along the lines of your sketch; it just doesn't need to be now.

> > I'd like to see some amount of per-fd write history (as we have per-fd
> > readahead history) to decide whether to allocate large folios ahead of
> > the current write position.  As with readahead, I'd like to see that even
> > doing single-byte writes can result in the allocation of large folios,
> > as long as the app has done enough of them.
> 
> *nod*
> 
> We already have some hints in the iomaps that can tell you this sort
> of thing. e.g. if ->iomap_begin() returns a delalloc iomap that
> extends beyond the current write, we're performing a sequence of
> multiple sequential writes.....

Well, if this is something the FS is already tracking, then we can
either try to lift that functionality into the page cache, or just take
advantage of the FS knowledge.  In iomap_write_begin(), we have access
to the srcmap and the iomap, and we can pass in something other than
the length of the write as the hint to __iomap_get_folio() for the
size of the folio we would like.

I should probably clean up the kernel-doc for iomap_get_folio() ...

- * @len: length of write
+ * @len: Suggested size of folio to create.


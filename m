Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E1BC7EE2E
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 17:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236791AbjFLRys (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 13:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236811AbjFLRyn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 13:54:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C883810DC;
        Mon, 12 Jun 2023 10:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=S/s1ddqePgmoNMOZAfQC+8K1eX2Z30E6NVOtj66/zlo=; b=MHiF2ewOZEuR78oa4hF5HFGKCU
        dcrCGvnZ1MrUq+buk8tANPC646jzSeC0xcitH5ILj6IfEbbCLkTAlUiiyRMSHuy0FaSSIyWjM7WBy
        7kvyNpwzfA7+7hkrcbXrZU4DegCM1T8gDabuBRQrdAIaAm3iR8yym5zZWmZgjxQYhv75LROxOUSfK
        71AV9I9f4oRNXSpDAHQcBdEF7RtYYUvHPQ4+J8L6rEt/rjFmQmQs71W+Og88LRLuGGU+GGFOYcKgT
        mHOf4/fe4SC42naoTPXDFu2wawH7G8yBhygdRvFbVf/6wZGgUeuM3Y0p+QCY0P2DYtIOIJX0M+hPO
        8XuOHMnQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1q8lkT-002tdI-AX; Mon, 12 Jun 2023 17:54:37 +0000
Date:   Mon, 12 Jun 2023 18:54:37 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Disha Goel <disgoel@linux.ibm.com>
Subject: Re: [PATCHv9 1/6] iomap: Rename iomap_page to iomap_folio_state and
 others
Message-ID: <ZIdb3TrwnhcQ3ULw@casper.infradead.org>
References: <20230612155911.GC11441@frogsfrogsfrogs>
 <87ttvcpodt.fsf@doe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ttvcpodt.fsf@doe.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 12, 2023 at 11:13:42PM +0530, Ritesh Harjani wrote:
> "Darrick J. Wong" <djwong@kernel.org> writes:
> > Ritesh: Please pick whichever variant you like, and that's it, no more
> > discussion.
> 
> static inline struct iomap_folio_state *to_folio_state(struct folio *folio)
> {
>     return folio->private;
> }
> 
> Sure this looks fine to me. So, I am hoping that there is no need to check
> folio_test_private(folio) PG_private flag here before returning
> folio->private (which was the case in original code to_iomap_page())
> 
> I did take a cursory look and didn't find any reason to test for doing
> folio_test_private(folio) here. It should always remain set between
> iomap_ifs_alloc() and iomap_ifs_free().
> 
> - IIUC, it is mostly for MM subsystem to see whether there is a
> private FS data attached to a folio for which they think we might have
> to call FS callback. for e.g. .is_dirty_writeback callback.
> - Or like FS can use it within it's own subsystem to say whether a
> folio is being associated with an in-progress read or write request. (e.g. NFS?)

The PG_private flag is being obsoleted in favour of just testing
folio->private for being NULL.  It's still in widespread use, but I'm
removing it as I change code.  I think we'll probably get rid of PG_error
first, but the more page flags we free up the better.  PG_hwpoison is
also scheduled for removal, but that requires folios to be dynamically
allocated first, so freeing that bit probably comes third.

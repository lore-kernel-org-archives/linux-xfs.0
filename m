Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3078CCDB474
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 22:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442973AbjJLWLJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 18:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442981AbjJLWLI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 18:11:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A997B8
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 15:11:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4F8C433C7;
        Thu, 12 Oct 2023 22:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697148666;
        bh=SeA+bqlXepL0kNrjGVl1/pdIiKYO7xY65pwsQQWO5ZQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aYq0LUgLOPJp2wsz7CDEO6dNoOUWzQc3GxS467TWzfZa6x0Qdj/hPjuj9JveqaSjk
         NgUyyrNJUr3aWYb3F7p7j7f0+4FcYu9QM2A5MvxUxGstsawjZkZv/xVBU8ngMDEBrt
         ktU/q229TI1Jv7e+iltIzmdtmhaaOlJvzFJXijTgq/WLj9cQhsdoxJJHD8EeCiw3A9
         E80VUdh6wGUwEiwUHooiydUwc17kysRMno3llLuu/2ATcoR2TXNS+yGfFnfmlgM9dz
         UZM1RNm2a5qCUl/6iervbokVl4ZscMrUtKL5PDzomBtQuKEqS+wy9l7tfMH4/l3Hj0
         P8ttSz9rQYZnQ==
Date:   Thu, 12 Oct 2023 15:11:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCH 6/8] xfs: use accessor functions for bitmap words
Message-ID: <20231012221106.GO21298@frogsfrogsfrogs>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs>
 <169704721721.1773834.17403646854103787383.stgit@frogsfrogsfrogs>
 <20231012061916.GA3667@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012061916.GA3667@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 08:19:16AM +0200, Christoph Hellwig wrote:
> On Wed, Oct 11, 2023 at 11:07:48AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create get and set functions for rtbitmap words so that we can redefine
> > the ondisk format with a specific endianness.  Note that this requires
> > the definition of a distinct type for ondisk rtbitmap words so that the
> > compiler can perform proper typechecking as we go back and forth.
> > 
> > In the upcoming rtgroups feature, we're going to fix the problem that
> > rtwords are written in host endian order, which means we'll need the
> > distinct rtword/rtword_raw types.
> 
> I've been looking over this and I have to say I kinda hate the
> abstraction level.
> 
> Having to deal with both the union xfs_rtword_ondisk, and the
> normal in-memory rtword just feels cumbersome.
> 
> I'd go for an API that gets/sets the values based on [bp, word] indices
> instead.  That would also need helpers for logging the buffer ranges
> based on indices, which seems helpful for the code quality anyway.
> 
> I don't really want to burden that on you and would offer to do that
> work myself after we work before this merged.

Hmm, so you want to go from:

	union xfs_rtword_ondisk *start, *end, *b;

	start = b = xfs_rbmblock_wordptr(bp, startword);
	end = xfs_rbmblock_wordptr(bp, endword);

	while (b < end) {
		somevalue = xfs_rtbitmap_getword(mp, b);
		somevalue |= somemask;
		xfs_rtbitmap_setword(mp, b, somevalue);
		b++;
	}

	xfs_trans_log_buf(tp, bp, start - bp->b_addr, b - bp->b_addr);

to something like:

	for (word = startword; word <= endword; word++) {
		somevalue = xfs_rtbitmap_getword(mp, b);
		somevalue |= somemask;
		xfs_rtbitmap_setword(mp, bp, word, somevalue);
	}
	xfs_rtbitmap_log_buf(tp, bp, startword, endword);

I think that could be done with relatively little churn, though it's
unfortunate that the second version does 2x(shift + addition) each time
it goes through the loop instead of the pointer increment that the first
version does.

--D

Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F19BFCDB47E
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Oct 2023 16:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjJMQ64 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Oct 2023 12:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjJMQ6x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2023 12:58:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D56A9
        for <linux-xfs@vger.kernel.org>; Fri, 13 Oct 2023 09:58:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECD6C43395;
        Fri, 13 Oct 2023 16:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697216332;
        bh=FRyuJ/FQrQJC63fjbJ32JpkLLxaANhyV6Uw8yvI250Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=azVbV6gILRHimLlTsk0nbBVzqqSL6UwADrS4NoR/xzV8H5XkKz6eXJB0P4ooYW3hT
         cukbkrZ7jclzthEkhPqnaTihQtfivMR2OBO6zOH46+1l1YZc7mle5d3Wz13Y1Rp7iX
         8PXEm5RZ4g9DCREwRCU8pz0UmtBQ6K3cxNgu8+d3cfI5Jci2CAjYqhLzp9NXLCUm0c
         wvsXU0nZW5MYNcfSnwbumWJYca3qQD58aCjRY97fTnN0Ual5R9BVAeCTH+BNx4A7eu
         62Z46KnTCyGIt862mh4L1dPCBdcsNAPCMkj4vlMrFMo5D14JfljjxG7AeqlEIWjpXX
         IXZ6NayrxPUaQ==
Date:   Fri, 13 Oct 2023 09:58:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCH 6/8] xfs: use accessor functions for bitmap words
Message-ID: <20231013165851.GA11402@frogsfrogsfrogs>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs>
 <169704721721.1773834.17403646854103787383.stgit@frogsfrogsfrogs>
 <20231012061916.GA3667@lst.de>
 <20231012221106.GO21298@frogsfrogsfrogs>
 <20231013042833.GE5562@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231013042833.GE5562@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 13, 2023 at 06:28:33AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 12, 2023 at 03:11:06PM -0700, Darrick J. Wong wrote:
> > Hmm, so you want to go from:
> > 
> > 	union xfs_rtword_ondisk *start, *end, *b;
> > 
> > 	start = b = xfs_rbmblock_wordptr(bp, startword);
> > 	end = xfs_rbmblock_wordptr(bp, endword);
> > 
> > 	while (b < end) {
> > 		somevalue = xfs_rtbitmap_getword(mp, b);
> > 		somevalue |= somemask;
> > 		xfs_rtbitmap_setword(mp, b, somevalue);
> > 		b++;
> > 	}
> > 
> > 	xfs_trans_log_buf(tp, bp, start - bp->b_addr, b - bp->b_addr);
> > 
> > to something like:
> > 
> > 	for (word = startword; word <= endword; word++) {
> > 		somevalue = xfs_rtbitmap_getword(mp, b);
> > 		somevalue |= somemask;
> > 		xfs_rtbitmap_setword(mp, bp, word, somevalue);
> > 	}
> > 	xfs_rtbitmap_log_buf(tp, bp, startword, endword);
> 
> Yes. (although xfs_rtbitmap_log_buf can't just take the words directly
> of course, and the xfs_rtbitmap_getword needs word and not the now
> not existing b).
> 
> > I think that could be done with relatively little churn, though it's
> > unfortunate that the second version does 2x(shift + addition) each time
> > it goes through the loop instead of the pointer increment that the first
> > version does.
> 
> I don't really think it matter compared to all the other overhead,
> and it keeps a much nicer API.

<nod> I suppose one could go the horrid iter function route to get
around the multiply, though at this point there's an awful lot of code
to do something very simple:

struct xfs_rbmword_cur {
	struct xfs_buf	*bp;
	xfs_rtword_t	*wordptr;
	unsigned int	endword;
	unsigned int	word;
};

static inline bool
xfs_rtbitmap_word_iter(
	struct xfs_rbmword_cur	*cur,
	xfs_rtword_t		*val)
{
	if (cur->word >= cur->endword)
		return false;

	if (!cur->wordptr)
		cur->wordptr = xfs_rbmblock_wordptr(cur->bp, cur->word);

	*val = *cur->wordptr;
	cur->word++;
	cur->wordptr++;
	return true;
}

static inline void
xfs_rtbitmap_word_set(
	struct xfs_rbmword_cur	*cur,
	xfs_rtword_t		val)
{
	*(cur->wordptr - 1) = val;
}

Usage:

	struct xfs_rbword_cur	cur = {
		.bp		= bp,
		.word		= startword,
		.endword	= endword,
	};
	xfs_rtword_t		val;

	while (xfs_rtbitmap_word_iter(&cur, &val)) {
		val |= somemask;
		xfs_rtbitmap_word_set(cur, val);
	}
	xfs_rtbitmap_log_buf(tp, bp, startword, endword);

--D

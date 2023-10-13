Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DEE4C41513
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Oct 2023 04:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjJME2j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Oct 2023 00:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJME2i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2023 00:28:38 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4406AB7
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 21:28:37 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2376C67373; Fri, 13 Oct 2023 06:28:34 +0200 (CEST)
Date:   Fri, 13 Oct 2023 06:28:33 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@osandov.com
Subject: Re: [PATCH 6/8] xfs: use accessor functions for bitmap words
Message-ID: <20231013042833.GE5562@lst.de>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs> <169704721721.1773834.17403646854103787383.stgit@frogsfrogsfrogs> <20231012061916.GA3667@lst.de> <20231012221106.GO21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012221106.GO21298@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 03:11:06PM -0700, Darrick J. Wong wrote:
> Hmm, so you want to go from:
> 
> 	union xfs_rtword_ondisk *start, *end, *b;
> 
> 	start = b = xfs_rbmblock_wordptr(bp, startword);
> 	end = xfs_rbmblock_wordptr(bp, endword);
> 
> 	while (b < end) {
> 		somevalue = xfs_rtbitmap_getword(mp, b);
> 		somevalue |= somemask;
> 		xfs_rtbitmap_setword(mp, b, somevalue);
> 		b++;
> 	}
> 
> 	xfs_trans_log_buf(tp, bp, start - bp->b_addr, b - bp->b_addr);
> 
> to something like:
> 
> 	for (word = startword; word <= endword; word++) {
> 		somevalue = xfs_rtbitmap_getword(mp, b);
> 		somevalue |= somemask;
> 		xfs_rtbitmap_setword(mp, bp, word, somevalue);
> 	}
> 	xfs_rtbitmap_log_buf(tp, bp, startword, endword);

Yes. (although xfs_rtbitmap_log_buf can't just take the words directly
of course, and the xfs_rtbitmap_getword needs word and not the now
not existing b).

> I think that could be done with relatively little churn, though it's
> unfortunate that the second version does 2x(shift + addition) each time
> it goes through the loop instead of the pointer increment that the first
> version does.

I don't really think it matter compared to all the other overhead,
and it keeps a much nicer API.


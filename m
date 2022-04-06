Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABECEC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 17:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239555AbiDFRsO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239777AbiDFRru (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 13:47:50 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F1A22B6CD
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 09:24:45 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2B8DF68AFE; Wed,  6 Apr 2022 18:24:42 +0200 (CEST)
Date:   Wed, 6 Apr 2022 18:24:42 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: replace xfs_buf_incore with an XBF_NOALLOC
 flag to xfs_buf_get*
Message-ID: <20220406162441.GA590@lst.de>
References: <20220403120119.235457-1-hch@lst.de> <20220403120119.235457-3-hch@lst.de> <20220403215443.GO1544202@dread.disaster.area> <20220405145509.GA15992@lst.de> <20220405212133.GY1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405212133.GY1544202@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 06, 2022 at 07:21:33AM +1000, Dave Chinner wrote:
> > I had that earlier, but having xfs_buf_incore as the odd one out that
> > still returns a buffer (like most XFS buffer cache routines did back
> > a long time ago) just did seem pretty odd compared tothe rest.
> 
> Then let's fix that to use the same interface as everything else,
> and that simplifies the implementation down to just:
> 
> static inline int
> xfs_buf_incore(
> 	struct xfs_buftarg	*target,
> 	xfs_daddr_t		blkno,
> 	size_t			numblks,
> 	xfs_buf_flags_t		flags,
> 	struct xfs_buf		**bpp)
> {
> 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> 
> 	return xfs_buf_get_map(target, &map, 1, _XBF_INCORE | flags,
> 				NULL, bpp);
> }
> 
> And, FWIW, the _XBF_NOALLOC flag really wants to be _XBF_INCORE - we
> need it to describe the lookup behaviour the flag provides, not the
> internal implementation detail that acheives the desired
> behaviour....

At least in my mental model a 'find but do not allocate' matches
the lookup behavior more than the somewhat odd 'incore' name.  I know
it is something traditional Unix including IRIX has used forever,
but it is a bit of an odd choice with no history in Linux.

That being said the flag and the wrapper should match, so IFF we keep
xfs_buf_incore the flag should also be _XBF_INCORE.  Still not my
preference, though.

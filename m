Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A317C4167B
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 02:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586235AbiDFCzS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 22:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449339AbiDEWYk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Apr 2022 18:24:40 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2EDAE14DA36
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 14:21:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 38FE7534449;
        Wed,  6 Apr 2022 07:21:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nbqcH-00ECaQ-6b; Wed, 06 Apr 2022 07:21:33 +1000
Date:   Wed, 6 Apr 2022 07:21:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: replace xfs_buf_incore with an XBF_NOALLOC flag
 to xfs_buf_get*
Message-ID: <20220405212133.GY1544202@dread.disaster.area>
References: <20220403120119.235457-1-hch@lst.de>
 <20220403120119.235457-3-hch@lst.de>
 <20220403215443.GO1544202@dread.disaster.area>
 <20220405145509.GA15992@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405145509.GA15992@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=624cb2de
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=qPlps0tX9aB5Q7pZR_0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 05, 2022 at 04:55:09PM +0200, Christoph Hellwig wrote:
> On Mon, Apr 04, 2022 at 07:54:43AM +1000, Dave Chinner wrote:
> > /*
> >  * Lock and return the buffer that matches the requested range if
> >  * and only if it is present in the cache already.
> >  */
> > static inline struct xfs_buf *
> > xfs_buf_incore(
> > 	struct xfs_buftarg	*target,
> > 	xfs_daddr_t		blkno,
> > 	size_t			numblks,
> > 	xfs_buf_flags_t		flags)
> > {
> > 	struct xfs_buf		*bp;
> > 	int			error;
> > 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> > 
> > 	error = xfs_buf_get_map(target, &map, 1, _XBF_NOALLOC | flags,
> > 				NULL, &bp);
> > 	if (error)
> > 		return NULL;
> > 	return bp;
> > }
> > 
> > Then none of the external callers need to be changed, and we don't
> > introduce new external xfs_buf_get() callers.
> 
> I had that earlier, but having xfs_buf_incore as the odd one out that
> still returns a buffer (like most XFS buffer cache routines did back
> a long time ago) just did seem pretty odd compared tothe rest.

Then let's fix that to use the same interface as everything else,
and that simplifies the implementation down to just:

static inline int
xfs_buf_incore(
	struct xfs_buftarg	*target,
	xfs_daddr_t		blkno,
	size_t			numblks,
	xfs_buf_flags_t		flags,
	struct xfs_buf		**bpp)
{
	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);

	return xfs_buf_get_map(target, &map, 1, _XBF_INCORE | flags,
				NULL, bpp);
}

And, FWIW, the _XBF_NOALLOC flag really wants to be _XBF_INCORE - we
need it to describe the lookup behaviour the flag provides, not the
internal implementation detail that acheives the desired
behaviour....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

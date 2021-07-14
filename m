Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 795E0C07E9A
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 09:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62B5D61073
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 09:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238701AbhGNJky (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 05:40:54 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:49512 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238189AbhGNJky (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 05:40:54 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id A23DB5284;
        Wed, 14 Jul 2021 19:38:01 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3bL5-006Ob6-PQ; Wed, 14 Jul 2021 19:37:59 +1000
Date:   Wed, 14 Jul 2021 19:37:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/16] xfs: sb verifier doesn't handle uncached sb buffer
Message-ID: <20210714093759.GX664593@dread.disaster.area>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-2-david@fromorbit.com>
 <YO6HhyRIupe08o5/@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YO6HhyRIupe08o5/@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=sENThMeq9PwEWyEF6OAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 07:43:19AM +0100, Christoph Hellwig wrote:
> On Wed, Jul 14, 2021 at 02:18:57PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The verifier checks explicitly for bp->b_bn == XFS_SB_DADDR to match
> > the primary superblock buffer, but the primary superblock is an
> > uncached buffer and so bp->b_bn is always -1ULL. Hence this never
> > matches and the CRC error reporting is wholly dependent on the
> > mount superblock already being populated so CRC feature checks pass
> > and allow CRC errors to be reported.
> > 
> > Fix this so that the primary superblock CRC error reporting is not
> > dependent on already having read the superblock into memory.
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> .. in the long run we really need to kill of b_bn to avoid this
> kind of confusion.

b_bn is supposed to only be an internal cache index these days. We
need that index in the first cacheline of the struct xfs_buf for
performance reasons (so traversals fetch only a single cacheline per
level), so perhaps a rename is in order just to catch all these
remaining users that shouldn't be using it...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2AB2C12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B668E61361
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbhGNXDw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:03:52 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:38797 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230388AbhGNXDw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 19:03:52 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 711725466;
        Thu, 15 Jul 2021 09:00:58 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3ns9-006brL-1v; Thu, 15 Jul 2021 09:00:57 +1000
Date:   Thu, 15 Jul 2021 09:00:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/16] xfs: sb verifier doesn't handle uncached sb buffer
Message-ID: <20210714230057.GA664593@dread.disaster.area>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-2-david@fromorbit.com>
 <20210714224450.GT22402@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714224450.GT22402@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=kykfbrR5c0l-5Y_U_pcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 03:44:50PM -0700, Darrick J. Wong wrote:
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
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_sb.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index 04f5386446db..4a4586bd2ba2 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -636,7 +636,7 @@ xfs_sb_read_verify(
> >  
> >  		if (!xfs_buf_verify_cksum(bp, XFS_SB_CRC_OFF)) {
> >  			/* Only fail bad secondaries on a known V5 filesystem */
> > -			if (bp->b_bn == XFS_SB_DADDR ||
> > +			if (bp->b_maps[0].bm_bn == XFS_SB_DADDR ||
> 
> I did not know that b_bn only applies to cached buffers.
> 
> Would you mind ... I dunno, updating the comment in the struct xfs_buf
> declaration to make this clearer?
> 
> 	/*
> 	 * Block number of buffer, when this buffer is cached.  For
> 	 * uncached buffers, only the buffer map (i.e. b_maps[0].bm_bn)
> 	 * contains the block number.
> 	 */
> 	xfs_daddr_t		b_bn;

Even that isn't stating the whole truth. b_maps[0].bm_bn contains
the current daddr for all buffers, regardless of whether they are
cached or not. This is what the IO path uses to provide the physical
address for the bio we submit...

Looking at the kernel code, there is still a lot of users of
bp->b_bn, and we've still got inconsistent use of XFS_BUF_ADDR, too.
I think fixing this all up needs a separate patchset - there's relatively
little outside libxfs/ in userspace that uses bp->b_bn directly
(largely repair, which is a 50/50 mix of b_bn and XFS_BUF_ADDR(bp))
so we should be able to clean this up entirely.

I suspect that converting all the external users to a
xfs_buf_daddr(bp) helper is the way to go here, and then renaming
b_bn to something else and use it only in xfs_buf.c for cache
indexing...

I'll put together another patchset to clean this up - it's separate
to the mount features rework, and this patch is only here because
when I change the feature check in the || case of this check to use
mount flags, the primary superblock buffer verification on first
read no longer flags CRC errors....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

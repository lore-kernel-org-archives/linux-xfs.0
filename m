Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C00C12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08FFB613C2
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhGNXGk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:06:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229928AbhGNXGk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 19:06:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A402613CA;
        Wed, 14 Jul 2021 23:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626303828;
        bh=zsprkB9kW7POQhoSWNFz13WatlSTaXK8giahnMGHshA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E4Tav6/iUiAyMdyHKJSCmEY2vt/0r5h2Axl1KL9xlbGZLQZSCUBITSHd4d4YzFPY7
         dSSa3VYorBZw1Bnp5chMTp/VsS885Ygt6avTJOHQDSUh7hstS2opPURrdKu5nhAVGS
         mLEH5Dxw879fDCxcMqDcbwTQwvgv4HdEL7EP6viUICtPjcXBYV9/tWxTAImsolLBBQ
         8Ip7LTgn2/8zkyjuIboOoENTj78V1A7/1kxsE1IDga4Dl7Lnz4yXsyctg2kH9XCeRg
         RD5lqPh9UPocHCnBHddlAyB0yTAunOqtZY6i7YmHvpGcNwbXtmz1Ccd7QzRtICIF+M
         56JFlJctzPWLA==
Date:   Wed, 14 Jul 2021 16:03:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/16] xfs: sb verifier doesn't handle uncached sb buffer
Message-ID: <20210714230347.GZ22402@magnolia>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-2-david@fromorbit.com>
 <20210714224450.GT22402@magnolia>
 <20210714230057.GA664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714230057.GA664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 15, 2021 at 09:00:57AM +1000, Dave Chinner wrote:
> On Wed, Jul 14, 2021 at 03:44:50PM -0700, Darrick J. Wong wrote:
> > On Wed, Jul 14, 2021 at 02:18:57PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > The verifier checks explicitly for bp->b_bn == XFS_SB_DADDR to match
> > > the primary superblock buffer, but the primary superblock is an
> > > uncached buffer and so bp->b_bn is always -1ULL. Hence this never
> > > matches and the CRC error reporting is wholly dependent on the
> > > mount superblock already being populated so CRC feature checks pass
> > > and allow CRC errors to be reported.
> > > 
> > > Fix this so that the primary superblock CRC error reporting is not
> > > dependent on already having read the superblock into memory.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_sb.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > index 04f5386446db..4a4586bd2ba2 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > @@ -636,7 +636,7 @@ xfs_sb_read_verify(
> > >  
> > >  		if (!xfs_buf_verify_cksum(bp, XFS_SB_CRC_OFF)) {
> > >  			/* Only fail bad secondaries on a known V5 filesystem */
> > > -			if (bp->b_bn == XFS_SB_DADDR ||
> > > +			if (bp->b_maps[0].bm_bn == XFS_SB_DADDR ||
> > 
> > I did not know that b_bn only applies to cached buffers.
> > 
> > Would you mind ... I dunno, updating the comment in the struct xfs_buf
> > declaration to make this clearer?
> > 
> > 	/*
> > 	 * Block number of buffer, when this buffer is cached.  For
> > 	 * uncached buffers, only the buffer map (i.e. b_maps[0].bm_bn)
> > 	 * contains the block number.
> > 	 */
> > 	xfs_daddr_t		b_bn;
> 
> Even that isn't stating the whole truth. b_maps[0].bm_bn contains
> the current daddr for all buffers, regardless of whether they are
> cached or not. This is what the IO path uses to provide the physical
> address for the bio we submit...

<nod>

> Looking at the kernel code, there is still a lot of users of
> bp->b_bn, and we've still got inconsistent use of XFS_BUF_ADDR, too.
> I think fixing this all up needs a separate patchset - there's relatively
> little outside libxfs/ in userspace that uses bp->b_bn directly
> (largely repair, which is a 50/50 mix of b_bn and XFS_BUF_ADDR(bp))
> so we should be able to clean this up entirely.
> 
> I suspect that converting all the external users to a
> xfs_buf_daddr(bp) helper is the way to go here, and then renaming
> b_bn to something else and use it only in xfs_buf.c for cache
> indexing...

Agreed.

> I'll put together another patchset to clean this up - it's separate
> to the mount features rework, and this patch is only here because
> when I change the feature check in the || case of this check to use
> mount flags, the primary superblock buffer verification on first
> read no longer flags CRC errors....

<nod> Definitely something to tack on the end.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

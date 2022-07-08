Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D13DEC43334
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jul 2022 04:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236876AbiGHE71 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jul 2022 00:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236708AbiGHE70 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jul 2022 00:59:26 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD89676EB3
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 21:59:24 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6339467373; Fri,  8 Jul 2022 06:59:21 +0200 (CEST)
Date:   Fri, 8 Jul 2022 06:59:21 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>, hch@lst.de,
        oliver.sang@intel.com
Subject: Re: [PATCH] xfs: fix use-after-free in xattr node block
 inactivation
Message-ID: <20220708045921.GA15474@lst.de>
References: <YsdcZY8KtyFmPdmS@magnolia> <20220708042653.GQ227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220708042653.GQ227878@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 08, 2022 at 02:26:53PM +1000, Dave Chinner wrote:
> > 			child_blkno,
> > 			XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0,
> > 			&child_bp);
> > 	if (error)
> > 		return error;
> > 	error = bp->b_error;
> > 
> > That doesn't look right -- I think this should be dereferencing
> > child_bp, not bp.
> 
> It shouldn't even be there. If xfs_trans_get_buf() returns a buffer,
> it should not have a pending error on it at all. i.e. it's supposed
> to return either an error or a buffer handle that is ready for use.

Agreed. Consumers of the buffer cache API should never look at b_error
because they will not see buffers with b_error set at all.

> Whoever wrote this didn't, for some reason, use the da btree path
> tracking (i.e. a struct xfs_da_state) to keep track of all the
> parent buffers of the current child being invalidated. That would
> make this code a whole lot simpler and neater....

Yeah.  The brelese seems to go back to:

commit 677821a1ab2301629aa0370835babb33bc6c919e
Author: Doug Doucette <doucette@engr.sgi.com>
Date:   Fri Dec 6 22:05:46 1996 +0000

    Fold in ficus changes not yet merged in:
    revision 1.32
    date: 1996/11/21 23:31:08;  author: doucette;  state: Exp;  lines: +69 -205
    Rewrite inactive attribute code to avoid freeing any of the data blocks
    until the very end.  We still walk the on-disk structure, but just
    call xfs_trans_binval on the buffers we get.  Then we call the truncate
    code to get rid of the data blocks.  This means we don't need a block
    reservation.

and the loop іtself is even older.  But the da_state had been around
since 1996, so that isn't really an excuse.

> > +		error = child_bp->b_error;
> >  		if (error) {
> >  			xfs_trans_brelse(*trans, child_bp);
> >  			return error;
> 
> I'd just remove the child_bp error checking altogether - if there
> was an IOi or corruption error on it, that shouldn't keep us from
> invalidating it to free the underlying space. We're trashing the
> contents, so who cares if the contents is already trashed?

Yeah.  I also don't see how a b_error could even magically appear
here without xfs_trans_get_buf returning an error first.

> Also, you probably need to set bp = NULL after the
> xfs_trans_brelse() call at the bottom of the loop....

Yes.

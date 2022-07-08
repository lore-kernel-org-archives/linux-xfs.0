Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E188CC43334
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jul 2022 15:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238238AbiGHPpL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jul 2022 11:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233930AbiGHPpK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jul 2022 11:45:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35F82AE1F
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 08:45:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6748160EB6
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 15:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D0DC341C0;
        Fri,  8 Jul 2022 15:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657295108;
        bh=q/CCG9nXxV3Jw1Qs32YkMyur/xqeYXnhGIobdk95/fE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eWpc3GRye1oISTub3KKQqPZGaVla3eupc8Sm2st3yPh/s6zQk2Tdy3x9qF38ob+55
         s+axC7HPwJU9Z0Z+v3Am2ReXA/Y7NCdSWhKLtiTNgNg5kLnMvEJwQ7TC1AAvHDZZN4
         7S+ziNPdl3ZC8iepl/RrrcrcuUrJtrDFp13uAniFwkAXCMN5/ocnx82NPL0mxF6uvj
         e2OV/alaPCU+yl9GNvHFl3gOGtDvyr7Fj4Ca9LwLN9y3NFLEXg/I6aPpiaeOZCbCcr
         xZMGoW/gsugOPHxpAxeKvdde8DsESOZEhnPzPHsgd7As/+GbU89tOXv53PW6wgjqz9
         Kjgm9k2SUQbXw==
Date:   Fri, 8 Jul 2022 08:45:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dave Chinner <david@fromorbit.com>,
        xfs <linux-xfs@vger.kernel.org>, oliver.sang@intel.com
Subject: Re: [PATCH] xfs: fix use-after-free in xattr node block inactivation
Message-ID: <YshRBKiWdt2/6jq+@magnolia>
References: <YsdcZY8KtyFmPdmS@magnolia>
 <20220708042653.GQ227878@dread.disaster.area>
 <20220708045921.GA15474@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220708045921.GA15474@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 08, 2022 at 06:59:21AM +0200, Christoph Hellwig wrote:
> On Fri, Jul 08, 2022 at 02:26:53PM +1000, Dave Chinner wrote:
> > > 			child_blkno,
> > > 			XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0,
> > > 			&child_bp);
> > > 	if (error)
> > > 		return error;
> > > 	error = bp->b_error;
> > > 
> > > That doesn't look right -- I think this should be dereferencing
> > > child_bp, not bp.
> > 
> > It shouldn't even be there. If xfs_trans_get_buf() returns a buffer,
> > it should not have a pending error on it at all. i.e. it's supposed
> > to return either an error or a buffer handle that is ready for use.

Ah, right, because flags == 0, so we clear b_error anyway.

> Agreed. Consumers of the buffer cache API should never look at b_error
> because they will not see buffers with b_error set at all.

<nod> Thinking about this further -- if the earlier da3_node_read
reads a corrupt buffer off disk, it'll exit early, and if the AIL
happens to push the buffer and the write verifier fails, the log will be
dead, so there's no value added by probing bp->b_error.  I'll remove the
whole if block entirely.

> > Whoever wrote this didn't, for some reason, use the da btree path
> > tracking (i.e. a struct xfs_da_state) to keep track of all the
> > parent buffers of the current child being invalidated. That would
> > make this code a whole lot simpler and neater....
> 
> Yeah.  The brelese seems to go back to:
> 
> commit 677821a1ab2301629aa0370835babb33bc6c919e
> Author: Doug Doucette <doucette@engr.sgi.com>
> Date:   Fri Dec 6 22:05:46 1996 +0000
> 
>     Fold in ficus changes not yet merged in:
>     revision 1.32
>     date: 1996/11/21 23:31:08;  author: doucette;  state: Exp;  lines: +69 -205
>     Rewrite inactive attribute code to avoid freeing any of the data blocks
>     until the very end.  We still walk the on-disk structure, but just
>     call xfs_trans_binval on the buffers we get.  Then we call the truncate
>     code to get rid of the data blocks.  This means we don't need a block
>     reservation.
> 
> and the loop іtself is even older.  But the da_state had been around
> since 1996, so that isn't really an excuse.
> 
> > > +		error = child_bp->b_error;
> > >  		if (error) {
> > >  			xfs_trans_brelse(*trans, child_bp);
> > >  			return error;
> > 
> > I'd just remove the child_bp error checking altogether - if there
> > was an IOi or corruption error on it, that shouldn't keep us from
> > invalidating it to free the underlying space. We're trashing the
> > contents, so who cares if the contents is already trashed?
> 
> Yeah.  I also don't see how a b_error could even magically appear
> here without xfs_trans_get_buf returning an error first.

xfs_trans_get_buf doesn't check b_error on the buffer it returns.  I
think only the _read_buf variants actually look at that.

> > Also, you probably need to set bp = NULL after the
> > xfs_trans_brelse() call at the bottom of the loop....
> 
> Yes.

Done.

--D

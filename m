Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A22CDB47E
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Oct 2023 17:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbjJRREO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 13:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjJRREK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 13:04:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8A1116
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 10:04:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEE9C433C7;
        Wed, 18 Oct 2023 17:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697648648;
        bh=e18BX+aZVzoyq9i6bD4aaHI3aFjSJlMxvpFghob76To=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZWe0LgYhDaVVnZEEOY3ku13p7+R2DgdRjo6koSpnvysgyzvyOznLeottogJQPSsnf
         5PrYoEZyiitFpnNqlzqOjYCuI6axxqzt8/GWmo+CVPHpqOniPTWAmLy1xMgmvQ4f0B
         x4jpoQvYclDIOQTY9oogahbKm09332zdmHjzS6BrhZ9gsmAlrWTxhjcGsW4kpxgt+P
         WhtwV51Nlp76Wp8zqmOujMxQTS9HqvcW167QsKqa2npHzXQ0wwDfozk8++q0PnB9Eh
         GcgZfv8dxdzJbvgh9Oj2Uu871aAlX8if8d6xi8JaurJDloiSXgDyClZMAMnMaIgw1o
         +o5gQ4jX3kulQ==
Date:   Wed, 18 Oct 2023 10:04:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dave Chinner <dchinner@redhat.com>, osandov@fb.com,
        osandov@osandov.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: consolidate realtime allocation arguments
Message-ID: <20231018170407.GI3195650@frogsfrogsfrogs>
References: <169755742570.3167911.7092954680401838151.stgit@frogsfrogsfrogs>
 <169755742594.3167911.2655847193439153279.stgit@frogsfrogsfrogs>
 <20231018061648.GA17687@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018061648.GA17687@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 18, 2023 at 08:16:48AM +0200, Christoph Hellwig wrote:
> On Tue, Oct 17, 2023 at 08:54:08AM -0700, Darrick J. Wong wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Consolidate the arguments passed around the rt allocator into a
> > struct xfs_rtalloc_arg similar to how the btree allocator arguments
> > are consolidated in a struct xfs_alloc_arg....
> 
> Overall this looks good to me, but a few cosmetic comments:
> 
> > +	struct xfs_rtalloc_args	*args,
> > +	xfs_fileoff_t		block,		/* block number in bitmap or summary */
> > +	int			issum,		/* is summary not bitmap */
> > +	struct xfs_buf		**bpp)		/* output: buffer for the block */
> 
> we should either also document the new args argument, or drop all the
> other argument comments like we've done in many places.  If we want
> to keep them it would be good to do the trivial reformatting so that
> they don't extend over the 80 character readability limit.

I prefer to leave the comments because they were immensely helpful for
figuring out the correct variable types in the refactoring series.  If
they can help someone else (e.g. 2024 me) figure out what this code
does, they're worth leaving in.

However, I'll fix the formatting errors to try to get the lines back to
around 80col.  I'll also get rid of the pointless comments like:

int error; /* error value */

> > +	struct xfs_mount	*mp = args->mount;
> 
> mount is a bit of an odd name for the member.  We usuall calls this
> mp in most structures like our normal variable name (with tp->t_mountp
> as one notable odd exception).
> 
> > +	error = xfs_trans_read_buf(mp, args->trans, mp->m_ddev_targp,
> >  				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
> >  				   mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);
> 
> ->trans has some precedence in the dir/attr code, but I think tp
> would still be more logical.

Agreed.

--D

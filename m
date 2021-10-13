Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E67BFC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 16:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C28096052B
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 16:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhJMQ5K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:57:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230228AbhJMQ5K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Oct 2021 12:57:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B8BB61027;
        Wed, 13 Oct 2021 16:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634144106;
        bh=CES9jeN6akWyVACABoccX/M+4J3q95+xn2JzSGiEo30=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r+U6JFOlQqE/VY1q5Ouyt62BuY5KdtGuBWcR5eVLsMM8A0li+E1k+qd/iSZOxx1HB
         pe5kh5NujWWPX63yjLXwgi/Af2JUiC+CA+2KmLNxjZaAH5t5GgAwdCzikRgX4Z3MI/
         gGX8deU5ifoxMLvlqsLN3ePhVkdzQJKaylMbq2eOiSosb11GGZkJlU2SHJ3q/zQUMs
         MDzOlDX5QWUnjHQ/PBRH9urOOxGcVG5n28y2zeDWEtZNH/x/i8rebEOdiXdHb9Ormp
         SUnw7rsPVnfgUSSoP+9yOIXVhUn3+T1xL5AUQMEbEFkt/EPIu41fhcD0Qm1V0cLJou
         uBOw7wp1+EUoQ==
Date:   Wed, 13 Oct 2021 09:55:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 09/15] xfs: dynamically allocate cursors based on
 maxlevels
Message-ID: <20211013165505.GW24307@magnolia>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
 <163408160334.4151249.13708314780740357223.stgit@magnolia>
 <20211013054041.GB2361455@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013054041.GB2361455@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 13, 2021 at 04:40:41PM +1100, Dave Chinner wrote:
> On Tue, Oct 12, 2021 at 04:33:23PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > To support future btree code, we need to be able to size btree cursors
> > dynamically for very large btrees.  Switch the maxlevels computation to
> > use the precomputed values in the superblock, and create cursors that
> > can handle a certain height.  For now, we retain the btree cursor zone
> > that can handle up to 9-level btrees, and create larger cursors (which
> > shouldn't happen currently) from the heap as a failsafe.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_alloc_btree.c    |    2 +-
> >  fs/xfs/libxfs/xfs_bmap_btree.c     |    3 ++-
> >  fs/xfs/libxfs/xfs_btree.h          |   13 +++++++++++--
> >  fs/xfs/libxfs/xfs_ialloc_btree.c   |    3 ++-
> >  fs/xfs/libxfs/xfs_refcount_btree.c |    3 ++-
> >  fs/xfs/libxfs/xfs_rmap_btree.c     |    3 ++-
> >  fs/xfs/xfs_super.c                 |    4 ++--
> >  7 files changed, 22 insertions(+), 9 deletions(-)
> 
> minor nit:
> 
> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index 43766e5b680f..b8761a2fc24b 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -94,6 +94,12 @@ uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
> >  
> >  #define	XFS_BTREE_MAXLEVELS	9	/* max of all btrees */
> >  
> > +/*
> > + * The btree cursor zone hands out cursors that can handle up to this many
> > + * levels.  This is the known maximum for all btree types.
> > + */
> > +#define XFS_BTREE_CUR_ZONE_MAXLEVELS	(9)
> 
> XFS_BTREE_CUR_CACHE_MAXLEVELS	9

Fixed.

--D

> Otherwise looks OK.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> -- 
> Dave Chinner
> david@fromorbit.com

Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 763D1C433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 16:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42FA861A26
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 16:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhCZQeX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Mar 2021 12:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229871AbhCZQeL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Mar 2021 12:34:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EA4A61A02;
        Fri, 26 Mar 2021 16:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616776451;
        bh=Kuycgdz29sRIuDSGj9nRrFmQv2aHliQRcbmXvz0xLOY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fr1RiMGp+b2xCKSpPrLNPg0PmwpC4fePcEYl5uUmHnLCVKTA8ZzgTXox0QPmaMGQB
         bG4DiCUcAKKSRPYfGiiDa/Zd5of7T68UClTZWnwYnm1dlxJGNr2snO3NcoYCleyssV
         z79VsLFgq3fQ0T9RQQ2u5OGFgZUookb3pG6riQUNxCDlb2ih0Hm26m957eWSK7aoDD
         N9bdGLPtOngrC6hJPrdRpXVDPI1aJiub60Qf7q3oAAuvNYnTze6EBjrkw+YhYKBI3D
         aBZmXY8CQMU9x5hIPCoqygHgKIS41Zl9OrI6iVhYfvKUxVGbdyvyevFibM1Hj8m2pc
         y5YkbfcDgqizQ==
Date:   Fri, 26 Mar 2021 09:34:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: refactor per-AG inode tagging functions
Message-ID: <20210326163410.GX4090233@magnolia>
References: <161671807287.621936.13471099564526590235.stgit@magnolia>
 <161671810634.621936.14531357513724748267.stgit@magnolia>
 <20210326064809.GG3421955@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326064809.GG3421955@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 26, 2021 at 06:48:09AM +0000, Christoph Hellwig wrote:
> On Thu, Mar 25, 2021 at 05:21:46PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In preparation for adding another incore inode tree tag, refactor the
> > code that sets and clears tags from the per-AG inode tree and the tree
> > of per-AG structures, and remove the open-coded versions used by the
> > blockgc code.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_icache.c |  127 ++++++++++++++++++++++++---------------------------
> >  fs/xfs/xfs_icache.h |    2 -
> >  fs/xfs/xfs_super.c  |    2 -
> >  fs/xfs/xfs_trace.h  |    6 +-
> >  4 files changed, 65 insertions(+), 72 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 2b25fe679b0e..4c124bc98f39 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -29,6 +29,7 @@
> >  /* Forward declarations to reduce indirect calls */
> >  static int xfs_blockgc_scan_inode(struct xfs_inode *ip,
> >  		struct xfs_eofblocks *eofb);
> > +static inline void xfs_blockgc_queue(struct xfs_perag *pag);
> >  static bool xfs_reclaim_inode_grab(struct xfs_inode *ip);
> >  static void xfs_reclaim_inode(struct xfs_inode *ip, struct xfs_perag *pag);
> >  
> > @@ -163,46 +164,78 @@ xfs_reclaim_work_queue(
> >  	rcu_read_unlock();
> >  }
> >  
> > +/* Set a tag on both the AG incore inode tree and the AG radix tree. */
> >  static void
> > +xfs_perag_set_ici_tag(
> > +	struct xfs_perag	*pag,
> > +	xfs_agino_t		agino,
> > +	unsigned int		tag)
> 
> Looking at the callers - I think the logic to lookup the pag and set the
> inode flag should also go in here.

I deliberately didn't do that here because of what happens in the
deferred inactivation patch.  After calling xfs_inactive, we have to
transition the inode from INACTIVATING to RECLAIMABLE (along with the
radix tree tags) without anybody being able to see intermediate state:

	/*
	 * Move the inode from the inactivation phase to the reclamation phase
	 * by clearing both inactivation inode state flags and marking the
	 * inode reclaimable.  Schedule background reclaim to run later.
	 */
	spin_lock(&pag->pag_ici_lock);
	spin_lock(&ip->i_flags_lock);

	ip->i_flags &= ~(XFS_NEED_INACTIVE | XFS_INACTIVATING);
	ip->i_flags |= XFS_IRECLAIMABLE;

	xfs_perag_clear_ici_tag(pag, agino, XFS_ICI_INODEGC_TAG);
	xfs_perag_set_ici_tag(pag, agino, XFS_ICI_RECLAIM_TAG);

	spin_unlock(&ip->i_flags_lock);
	spin_unlock(&pag->pag_ici_lock);

Which is why the xfs_perag_*_ici_tag callers are left in charge of
looking up the pag and taking locks as needed.

> Currently only xfs_inode_destroy
> nests i_Flags log inside the pag_ici_lock, but I don't see how that
> would harm the xfs_blockgc_set_iflag case.

The other wart is that IEOFBLOCKS and ICOWBLOCKS share the same radix
tree tag, which complicates the clearing logic, and I thought it best
to let the callers deal with that.

> I suspect the unlocked
> check in xfs_blockgc_set_iflag would harm in the reclaim case either.

"wouldn't"?

> 
> >  void
> > +xfs_inode_destroy(
> 
> I find this new name a little confusing.  What about
> xfs_inode_mark_reclaimable?

Fixed.

> But overall this new scheme looks nice to me.

Thanks!

--D

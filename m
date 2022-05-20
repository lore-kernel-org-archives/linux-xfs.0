Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 922EFC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 15:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347413AbiETPtU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 11:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238120AbiETPtU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 11:49:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C41B5C85D
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 08:49:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32342B82B7A
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 15:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41E0C385A9;
        Fri, 20 May 2022 15:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653061756;
        bh=eDShFVAdPcpdHcO4lAkb5lTQn+kvQvlgaV8bGH5Rl7E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c3dWuRJkt+ApwYQJfbbZkexTuaCeESsFzPKgPznRkFvNXqzZNYPlsqNTf5Hqtj+YS
         4tIsadm3fs/IUaQRONZXEUf/CVevmLuRCsTk89QOZyUqn17syJvY9GRNCB0Tpq7Ihu
         p5NVV/yyaU/CeHdQSsuyrNtNKMb4k/rkMk5IY78B9tZhEwJle1MNnx3bvil9YW10Dh
         x3d7k9YsCkB3vlM/hAAshRqmnPuW2g7/1wIwq1z8xZ8fb0XI2l3hMHUysKjpc/E2hJ
         hz1LrsAHMw3GA9UJft/5Ue4s4JC7gX26D+6LzQwawuN+WZ5DmQmla8NyaupVmFTBbT
         70BvJYoUtwcIA==
Date:   Fri, 20 May 2022 08:49:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: clean up xfs_attr_node_hasname
Message-ID: <Yoe4ewF8H18Elzel@magnolia>
References: <165290014409.1647637.4876706578208264219.stgit@magnolia>
 <165290014984.1647637.6457441230229883518.stgit@magnolia>
 <20220520034210.GD1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520034210.GD1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 20, 2022 at 01:42:10PM +1000, Dave Chinner wrote:
> On Wed, May 18, 2022 at 11:55:49AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The calling conventions of this function are a mess -- callers /can/
> > provide a pointer to a pointer to a state structure, but it's not
> > required, and as evidenced by the last two patches, the callers that do
> > weren't be careful enough about how to deal with an existing da state.
> > 
> > Push the allocation and freeing responsibilty to the callers, which
> > means that callers from the xattr node state machine steps now have the
> > visibility to allocate or free the da state structure as they please.
> > As a bonus, the node remove/add paths for larp-mode replaces can reset
> > the da state structure instead of freeing and immediately reallocating
> > it.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c     |   63 +++++++++++++++++++++---------------------
> >  fs/xfs/libxfs/xfs_da_btree.c |   11 +++++++
> >  fs/xfs/libxfs/xfs_da_btree.h |    1 +
> >  3 files changed, 44 insertions(+), 31 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 576de34cfca0..3838109ef288 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -61,8 +61,8 @@ STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
> >  static int xfs_attr_node_try_addname(struct xfs_attr_item *attr);
> >  STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item *attr);
> >  STATIC int xfs_attr_node_remove_attr(struct xfs_attr_item *attr);
> > -STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> > -				 struct xfs_da_state **state);
> > +STATIC int xfs_attr_node_lookup(struct xfs_da_args *args,
> > +		struct xfs_da_state *state);
> >  
> >  int
> >  xfs_inode_hasattr(
> > @@ -594,6 +594,19 @@ xfs_attr_leaf_mark_incomplete(
> >  	return xfs_attr3_leaf_setflag(args);
> >  }
> >  
> > +/* Ensure the da state of an xattr deferred work item is ready to go. */
> > +static inline void
> > +xfs_attr_item_ensure_da_state(
> 
> xfs_attr_item_init_da_state().
> 
> Other than that, it's a nice cleanup. I can rename the function
> locally if you want.

Yes, please.  I don't have any further updates for this patch.

--D

> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -- 
> Dave Chinner
> david@fromorbit.com

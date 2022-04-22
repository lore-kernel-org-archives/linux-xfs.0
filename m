Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F1BC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Apr 2022 22:53:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbiDVWz6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Apr 2022 18:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbiDVWzj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Apr 2022 18:55:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870343A9EA7
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 15:19:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F98562107
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 22:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86F6C385A4;
        Fri, 22 Apr 2022 22:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650665900;
        bh=SzHZMyqlsqMvHSyKSLnDRaHBBAbv8PHUS2+/wYir+EU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tRRsEvkuZexZ+KhK9330MPjKdFdUrrQx3tyTqKURpGZheaHW6r71uUWYwdicmfTG3
         QfNywA9zSyrhVdZ047Kg5/8y8ckgpvAFBziJDTkwBDdsAM/7BC3/AeqQWq4Sj38gwg
         OF+Cn1jEfCEfPkDtc2UxJfyp3xnGb69rouVCN2Poo5O5JTtBulmIesLw3OjmIKMMbt
         Ms9MxHrAdc1ZSkzImXL+u4DGw9uuy3wbP0E3c8qxiVijy89CrXyZQLZCUUBoW7sjVs
         47l7NaxKioytzMOntU3xdkW5XsiPvVwVth2E3B+Ms/V+CdCbx0ly2VJC5sQX4xruKW
         kQUI3RowgItvA==
Date:   Fri, 22 Apr 2022 15:18:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: stop artificially limiting the length of bunmap
 calls
Message-ID: <20220422221820.GH17059@magnolia>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
 <164997687142.383881.7160925177236303538.stgit@magnolia>
 <20220422220120.GA1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422220120.GA1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 23, 2022 at 08:01:20AM +1000, Dave Chinner wrote:
> On Thu, Apr 14, 2022 at 03:54:31PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In commit e1a4e37cc7b6, we clamped the length of bunmapi calls on the
> > data forks of shared files to avoid two failure scenarios: one where the
> > extent being unmapped is so sparsely shared that we exceed the
> > transaction reservation with the sheer number of refcount btree updates
> > and EFI intent items; and the other where we attach so many deferred
> > updates to the transaction that we pin the log tail and later the log
> > head meets the tail, causing the log to livelock.
> > 
> > We avoid triggering the first problem by tracking the number of ops in
> > the refcount btree cursor and forcing a requeue of the refcount intent
> > item any time we think that we might be close to overflowing.  This has
> > been baked into XFS since before the original e1a4 patch.
> > 
> > A recent patchset fixed the second problem by changing the deferred ops
> > code to finish all the work items created by each round of trying to
> > complete a refcount intent item, which eliminates the long chains of
> > deferred items (27dad); and causing long-running transactions to relog
> > their intent log items when space in the log gets low (74f4d).
> > 
> > Because this clamp affects /any/ unmapping request regardless of the
> > sharing factors of the component blocks, it degrades the performance of
> > all large unmapping requests -- whereas with an unshared file we can
> > unmap millions of blocks in one go, shared files are limited to
> > unmapping a few thousand blocks at a time, which causes the upper level
> > code to spin in a bunmapi loop even if it wasn't needed.
> > 
> > This also eliminates one more place where log recovery behavior can
> > differ from online behavior, because bunmapi operations no longer need
> > to requeue.
> > 
> > Partial-revert-of: e1a4e37cc7b6 ("xfs: try to avoid blowing out the transaction reservation when bunmaping a shared extent")
> > Depends: 27dada070d59 ("xfs: change the order in which child and parent defer ops ar finished")
> > Depends: 74f4d6a1e065 ("xfs: only relog deferred intent items if free space in the log gets low")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c     |   22 +---------------------
> >  fs/xfs/libxfs/xfs_refcount.c |    5 ++---
> >  fs/xfs/libxfs/xfs_refcount.h |    8 ++------
> >  3 files changed, 5 insertions(+), 30 deletions(-)
> 
> This looks reasonable, but I'm wondering how the original problem
> was discovered and whether this has been tested against that
> original problem situation to ensure we aren't introducing a
> regression here....

generic/447, and yes, I have forced it to run a deletion of 1 million
extents without incident. :)

I should probably amend that test to note that it's an exerciser for
e1a4e37cc7b6.

> > diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
> > index 9eb01edbd89d..6b265f6075b8 100644
> > --- a/fs/xfs/libxfs/xfs_refcount.h
> > +++ b/fs/xfs/libxfs/xfs_refcount.h
> > @@ -66,15 +66,11 @@ extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
> >   * reservation and crash the fs.  Each record adds 12 bytes to the
> >   * log (plus any key updates) so we'll conservatively assume 32 bytes
> >   * per record.  We must also leave space for btree splits on both ends
> > - * of the range and space for the CUD and a new CUI.
> > + * of the range and space for the CUD and a new CUI.  Each EFI that we
> > + * attach to the transaction also consumes ~32 bytes.
> >   */
> >  #define XFS_REFCOUNT_ITEM_OVERHEAD	32
> 
> FWIW, I think this is a low-ball number - each EFI also consumes an
> ophdr (12 bytes) for the region identifier in the log, so it's
> actually 44 bytes, not 32 bytes that will be consumed.  It is not
> necessary to address this in this patchset, though.

<Nod>

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

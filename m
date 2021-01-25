Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E018C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 19:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4BEE206DC
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 19:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732031AbhAYTz4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 14:55:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732120AbhAYTz2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Jan 2021 14:55:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 255CC206DC;
        Mon, 25 Jan 2021 19:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611604487;
        bh=KA1VfqTGjIQcCofVMW6Vm83VcPU46qNpJva6LoxPJYs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aTMpNK2eeM4/wO3lR1ISxGRCPg3S+1R3sgQ/jK87L14Re3vVn8ni6QFYN19icERFZ
         mwAIXvsvjXo/keIwnGJjY3BmD4LfIiMPGE3ZyHF5RK8awWAYcMU0Q3ALDZf37UoV96
         0nyb1aBY1su4A2v4SeoMlz22i0Il07rpMzTxowI8G0c+rmK+rPeTbD2U7sfpqEi6RW
         FNlAk0mpmcnAK2KyGKwfmrsntfG+NDT0QO+4uYAUDbpxItHkKdPG2U39ACLALax38V
         udDuzmH3qH5KKOxuYmKi8Y3x/SWFXeKWH9BY8O0gftJ+gU/HF6Z3Z9wx0HkIwS0Giu
         tkVvqMb6hDqTg==
Date:   Mon, 25 Jan 2021 11:54:46 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 02/11] xfs: don't stall cowblocks scan if we can't take
 locks
Message-ID: <20210125195446.GD7698@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142793080.2171939.11486862758521454210.stgit@magnolia>
 <20210125181406.GH2047559@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125181406.GH2047559@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 25, 2021 at 01:14:06PM -0500, Brian Foster wrote:
> On Sat, Jan 23, 2021 at 10:52:10AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Don't stall the cowblocks scan on a locked inode if we possibly can.
> > We'd much rather the background scanner keep moving.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_icache.c |   21 ++++++++++++++++++---
> >  1 file changed, 18 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index c71eb15e3835..89f9e692fde7 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -1605,17 +1605,31 @@ xfs_inode_free_cowblocks(
> >  	void			*args)
> >  {
> >  	struct xfs_eofblocks	*eofb = args;
> > +	bool			wait;
> >  	int			ret = 0;
> >  
> > +	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
> > +
> >  	if (!xfs_prep_free_cowblocks(ip))
> >  		return 0;
> >  
> >  	if (!xfs_inode_matches_eofb(ip, eofb))
> >  		return 0;
> >  
> > -	/* Free the CoW blocks */
> > -	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> > -	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> > +	/*
> > +	 * If the caller is waiting, return -EAGAIN to keep the background
> > +	 * scanner moving and revisit the inode in a subsequent pass.
> > +	 */
> > +	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> > +		if (wait)
> > +			return -EAGAIN;
> > +		return 0;
> > +	}
> > +	if (!xfs_ilock_nowait(ip, XFS_MMAPLOCK_EXCL)) {
> > +		if (wait)
> > +			ret = -EAGAIN;
> > +		goto out_iolock;
> > +	}
> 
> Hmm.. I'd be a little concerned over this allowing a scan to repeat
> indefinitely with a competing workload because a restart doesn't carry
> over any state from the previous scan. I suppose the
> xfs_prep_free_cowblocks() checks make that slightly less likely on a
> given file, but I more wonder about a scenario with a large set of
> inodes in a particular AG with a sufficient amount of concurrent
> activity. All it takes is one trylock failure per scan to have to start
> the whole thing over again... hm?

I'm not quite sure what to do here -- xfs_inode_free_eofblocks already
has the ability to return EAGAIN, which (I think) means that it's
already possible for the low-quota scan to stall indefinitely if the
scan can't lock the inode.

I think we already had a stall limiting factor here in that all the
other threads in the system that hit EDQUOT will drop their IOLOCKs to
scan the fs, which means that while they loop around the scanner they
can only be releasing quota and driving us towards having fewer inodes
with the same dquots and either blockgc tag set.

--D

> Brian
> 
> >  
> >  	/*
> >  	 * Check again, nobody else should be able to dirty blocks or change
> > @@ -1625,6 +1639,7 @@ xfs_inode_free_cowblocks(
> >  		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
> >  
> >  	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> > +out_iolock:
> >  	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> >  
> >  	return ret;
> > 
> 

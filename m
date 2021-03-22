Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26E8C433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 22:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80DAC619A5
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 22:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhCVWO0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 18:14:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhCVWN5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Mar 2021 18:13:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C96416192B;
        Mon, 22 Mar 2021 22:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616451237;
        bh=JJbwjEC1wjfvHeIqfT7CRNhaTSGO+8XJNYV3E5oX/3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ug308JmaYdSD5UzdT7XIgDkqt6Bmahyrog0ZFAOauhm4dbKycoEnhrW6z/+ZPZf7j
         5LL6IqEV1neVxYnNFW3JGTCbzEUCNLq4SWgFc018MZzsNqVaIX3i87G5Xap9YC9l/v
         AUrzlq9SfXADRTDJTVpdnAT1EmBc6s+ezbrlBt4RtZNuDW7IB4Uo4LUH5g/gRGMb1s
         K2OPDXuPMDT0F+02AZ7/PoDPXPYVzbpTxS4giw/cYIaXKrK9ocnoFo/d3hkU/ikJR5
         9Qkm6px/fB7XuokELXELTbGitINZjoPEny0ae6HDwgDyoFltZJrnPOKu8y3VsrdD9X
         YiIRMaIfloaVQ==
Date:   Mon, 22 Mar 2021 15:13:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: only reset incore inode health state flags when
 reclaiming an inode
Message-ID: <20210322221354.GF22100@magnolia>
References: <20210320164007.GX22100@magnolia>
 <20210322213016.GU63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322213016.GU63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 23, 2021 at 08:30:16AM +1100, Dave Chinner wrote:
> On Sat, Mar 20, 2021 at 09:40:07AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > While running some fuzz tests on inode metadata, I noticed that the
> > filesystem health report (as provided by xfs_spaceman) failed to report
> > the file corruption even when spaceman was run immediately after running
> > xfs_scrub to detect the corruption.  That isn't the intended behavior;
> > one ought to be able to run scrub to detect errors in the ondisk
> > metadata and be able to access to those reports for some time after the
> > scrub.
> > 
> > After running the same sequence through an instrumented kernel, I
> > discovered the reason why -- scrub igets the file, scans it, marks it
> > sick, and ireleases the inode.  When the VFS lets go of the incore
> > inode, it moves to RECLAIMABLE state.  If spaceman igets the incore
> > inode before it moves to RECLAIM state, iget reinitializes the VFS
> > state, clears the sick and checked masks, and hands back the inode.  At
> > this point, the caller has the exact same incore inode, but with all the
> > health state erased.
> > 
> > In other words, we're erasing the incore inode's health state flags when
> > we've decided NOT to sever the link between the incore inode and the
> > ondisk inode.  This is wrong, so we need to remove the lines that zero
> > the fields from xfs_iget_cache_hit.
> > 
> > As a precaution, we add the same lines into xfs_reclaim_inode just after
> > we sever the link between incore and ondisk inode.  Strictly speaking
> > this isn't necessary because once an inode has gone through reclaim it
> > must go through xfs_inode_alloc (which also zeroes the state) and
> > xfs_iget is careful to check for mismatches between the inode it pulls
> > out of the radix tree and the one it wants.
> > 
> > Fixes: 6772c1f11206 ("xfs: track metadata health status")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_icache.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 595bda69b18d..5325fa28d099 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -587,8 +587,6 @@ xfs_iget_cache_hit(
> >  		ip->i_flags |= XFS_INEW;
> >  		xfs_inode_clear_reclaim_tag(pag, ip->i_ino);
> >  		inode->i_state = I_NEW;
> > -		ip->i_sick = 0;
> > -		ip->i_checked = 0;
> >  
> >  		spin_unlock(&ip->i_flags_lock);
> >  		spin_unlock(&pag->pag_ici_lock);
> > @@ -1205,6 +1203,8 @@ xfs_reclaim_inode(
> >  	spin_lock(&ip->i_flags_lock);
> >  	ip->i_flags = XFS_IRECLAIM;
> >  	ip->i_ino = 0;
> > +	ip->i_sick = 0;
> > +	ip->i_checked = 0;
> >  	spin_unlock(&ip->i_flags_lock);
> >  
> >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 
> This is only going to keep the health information around on a
> DONTCACHE inode for a few extra seconds. If the scrub takes longer
> to run than it takes for the background inode reclaimer thread to
> run again (every 5s by default), then the health information for
> that inode is still trashed by this patch and the problem still
> exists.
> 
> I suspect that unhealthy inodes need to have IDONTCACHE cleared so
> that they don't get reclaimed until there is memory pressure, hence
> giving scrub/spaceman some time to set/report health issues.

Yes, it seems reasonable to cancel DONTCACHE if you're marking an inode
sick, and for iget to ignore DONTCACHE if the inode is in memory and is
marked sick.  This also sounds like a second patch. :)

> Perhaps we should not reclaim the unhealthy inodes until they've been
> marked as "seen"....

I'm hesitant to pin an inode in memory if it's unhealthy, because that
seems like it could lead to further problems if a large number of inodes
get marked sick and memory reclaim can't free enough RAM to enable a
recovery action (like shutting down the fs and unmounting it).

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

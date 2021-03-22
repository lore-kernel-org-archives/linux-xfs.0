Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C20C7C433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 21:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84DCA6198E
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 21:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCVVaZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 17:30:25 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:34918 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229508AbhCVVaT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 17:30:19 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id D79CF102B0AB;
        Tue, 23 Mar 2021 08:30:16 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lOS7s-005amK-Cn; Tue, 23 Mar 2021 08:30:16 +1100
Date:   Tue, 23 Mar 2021 08:30:16 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: only reset incore inode health state flags when
 reclaiming an inode
Message-ID: <20210322213016.GU63242@dread.disaster.area>
References: <20210320164007.GX22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210320164007.GX22100@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=lA46TapvIksECz0co-wA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Mar 20, 2021 at 09:40:07AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While running some fuzz tests on inode metadata, I noticed that the
> filesystem health report (as provided by xfs_spaceman) failed to report
> the file corruption even when spaceman was run immediately after running
> xfs_scrub to detect the corruption.  That isn't the intended behavior;
> one ought to be able to run scrub to detect errors in the ondisk
> metadata and be able to access to those reports for some time after the
> scrub.
> 
> After running the same sequence through an instrumented kernel, I
> discovered the reason why -- scrub igets the file, scans it, marks it
> sick, and ireleases the inode.  When the VFS lets go of the incore
> inode, it moves to RECLAIMABLE state.  If spaceman igets the incore
> inode before it moves to RECLAIM state, iget reinitializes the VFS
> state, clears the sick and checked masks, and hands back the inode.  At
> this point, the caller has the exact same incore inode, but with all the
> health state erased.
> 
> In other words, we're erasing the incore inode's health state flags when
> we've decided NOT to sever the link between the incore inode and the
> ondisk inode.  This is wrong, so we need to remove the lines that zero
> the fields from xfs_iget_cache_hit.
> 
> As a precaution, we add the same lines into xfs_reclaim_inode just after
> we sever the link between incore and ondisk inode.  Strictly speaking
> this isn't necessary because once an inode has gone through reclaim it
> must go through xfs_inode_alloc (which also zeroes the state) and
> xfs_iget is careful to check for mismatches between the inode it pulls
> out of the radix tree and the one it wants.
> 
> Fixes: 6772c1f11206 ("xfs: track metadata health status")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 595bda69b18d..5325fa28d099 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -587,8 +587,6 @@ xfs_iget_cache_hit(
>  		ip->i_flags |= XFS_INEW;
>  		xfs_inode_clear_reclaim_tag(pag, ip->i_ino);
>  		inode->i_state = I_NEW;
> -		ip->i_sick = 0;
> -		ip->i_checked = 0;
>  
>  		spin_unlock(&ip->i_flags_lock);
>  		spin_unlock(&pag->pag_ici_lock);
> @@ -1205,6 +1203,8 @@ xfs_reclaim_inode(
>  	spin_lock(&ip->i_flags_lock);
>  	ip->i_flags = XFS_IRECLAIM;
>  	ip->i_ino = 0;
> +	ip->i_sick = 0;
> +	ip->i_checked = 0;
>  	spin_unlock(&ip->i_flags_lock);
>  
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);

This is only going to keep the health information around on a
DONTCACHE inode for a few extra seconds. If the scrub takes longer
to run than it takes for the background inode reclaimer thread to
run again (every 5s by default), then the health information for
that inode is still trashed by this patch and the problem still
exists.

I suspect that unhealthy inodes need to have IDONTCACHE cleared so
that they don't get reclaimed until there is memory pressure, hence
giving scrub/spaceman some time to set/report health issues. Perhaps
we should not reclaim the unhealthy inodes until they've been marked
as "seen"....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

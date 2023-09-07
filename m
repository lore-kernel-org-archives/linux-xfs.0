Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A84EC8742
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Sep 2023 18:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbjIGSep (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 14:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjIGSep (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2023 14:34:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF8292
        for <linux-xfs@vger.kernel.org>; Thu,  7 Sep 2023 11:34:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FAAC433C9;
        Thu,  7 Sep 2023 18:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694111681;
        bh=sr8dO4MHYBNhAdxMWAMcDcSFP85B5TiYk4PqG7bNTOo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mEetLAtnCqkXpkBCEkCKQ1mtKBs4340F1GAlDRHz8wW0ARL8be6HsVuTkPE6scAFE
         wGK3/q+wMxt/efWMuUVNGegBvenxeJn+o/YtgXlZFWkWP87J81shZqK74AGKSxgfiI
         sTErALL8dIRmVisEngfMV7ilMc392KHj/TT59sDW7g5I+mqhP0wk4ENaqT9Bw2kdWU
         VOuMbZaJsRgTz3mLD9GisuxAeT7CW8Ujy//OMKZqrI+xlbPA4lGgYb05iV6DOH2FLB
         ixA7wcfEGOp3MhZV5SrovorzGuV1wPr8llsicZ20mrkb+BA8zJn42BPWnnxOakyEl4
         EfprvZkxHmGfA==
Date:   Thu, 7 Sep 2023 11:34:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     chandan.babu@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1.1 3/3] xfs: make inode unlinked bucket recovery work
 with quotacheck
Message-ID: <20230907183441.GN28202@frogsfrogsfrogs>
References: <169375774749.3323693.18063212270653101716.stgit@frogsfrogsfrogs>
 <169375776451.3323693.17265659636054853468.stgit@frogsfrogsfrogs>
 <20230905163303.GU28186@frogsfrogsfrogs>
 <ZPl3ucKG33L7NI8B@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPl3ucKG33L7NI8B@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 07, 2023 at 05:11:53PM +1000, Dave Chinner wrote:
> On Tue, Sep 05, 2023 at 09:33:03AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Teach quotacheck to reload the unlinked inode lists when walking the
> > inode table.  This requires extra state handling, since it's possible
> > that a reloaded inode will get inactivated before quotacheck tries to
> > scan it; in this case, we need to ensure that the reloaded inode does
> > not have dquots attached when it is freed.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> > v1.1: s/CONFIG_QUOTA/CONFIG_XFS_QUOTA/ and fix tracepoint flags decoding
> > ---
> >  fs/xfs/xfs_inode.c |   12 +++++++++---
> >  fs/xfs/xfs_inode.h |    5 ++++-
> >  fs/xfs/xfs_mount.h |   10 +++++++++-
> >  fs/xfs/xfs_qm.c    |    7 +++++++
> >  4 files changed, 29 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 56f6bde6001b..22af7268169b 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1743,9 +1743,13 @@ xfs_inactive(
> >  	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
> >  		truncate = 1;
> >  
> > -	error = xfs_qm_dqattach(ip);
> > -	if (error)
> > -		goto out;
> > +	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
> > +		xfs_qm_dqdetach(ip);
> > +	} else {
> > +		error = xfs_qm_dqattach(ip);
> > +		if (error)
> > +			goto out;
> > +	}
> 
> That needs a comment - I'm not going to remember why sometimes we
> detatch dquots instead of attach them here....

	/*
	 * If this inode is being inactivated during a quotacheck and
	 * has not yet been scanned by quotacheck, we /must/ remove the
	 * dquots from the inode before inactivation changes the block
	 * and inode counts.  Most probably this is a result of
	 * reloading the incore iunlinked list to purge unrecovered
	 * unlinked inodes.
	 */

How does that sound?

> ....
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index 6abcc34fafd8..7256090c3895 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -1160,6 +1160,10 @@ xfs_qm_dqusage_adjust(
> >  	if (error)
> >  		return error;
> >  
> > +	error = xfs_inode_reload_unlinked(ip);
> > +	if (error)
> > +		goto error0;
> 
> Same comment here about doing millions of transaction create/cancel
> for inodes that have non-zero link counts....
> 
> Also, same comment here about shutting down on reload error because
> the irele() call will inactivate the inode and try to remove it from
> the unlinked list....

Ok, fixed this callsite too.

Thank you for looking at this series!

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

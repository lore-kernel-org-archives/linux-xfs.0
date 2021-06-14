Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 292B9C2B9F4
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 17:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 001C0613B6
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 17:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbhFNRgj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 13:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231499AbhFNRgi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jun 2021 13:36:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D79E61350;
        Mon, 14 Jun 2021 17:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623692075;
        bh=3jGkw28robQvF7xpp9xVN6lRRttSwEI+mBx8V20pD8s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hqLbeQOt9oSqAIt6aPBr7zjJuLNEbbaF2WZQrv1+ArQPDQtPhZ1hwqCMslWa2+0Sy
         69lcsLeH3z8oMulEMnlUkQ2ddJ1UEBwgTCYpjJBEGjOXOecdgS8VVmKHEgEvps4PBb
         uGAFyc4sgbWl+JhtJR16bIIDDyQ+kf0CfC8dWJIZQpgjtctJK8aZ9K3RN//2tMNixa
         b3KmG/ez5tai7RW7nmzkgdvQGCVFopwbKvDmBdv2bJqveg500N4Xx06LDwEUArB8rs
         Tbvdgjy6tSFBzhPHdnS9tdE/TNyWEyTrhcI242DNVPukxlobtwVM3rLxyydhKt4W37
         MTGWHgwbQYRCQ==
Date:   Mon, 14 Jun 2021 10:34:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH 04/16] xfs: clean up xfs_inactive a little bit
Message-ID: <20210614173435.GN2945738@locust>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
 <162360481889.1530792.8153660904394768299.stgit@locust>
 <YMeAZ0IMnNTCgPQp@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMeAZ0IMnNTCgPQp@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 14, 2021 at 12:14:31PM -0400, Brian Foster wrote:
> On Sun, Jun 13, 2021 at 10:20:18AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Move the dqattach further up in xfs_inactive.  In theory we should
> > always have dquots attached if there are CoW blocks, but this makes the
> > usage pattern more consistent with the rest of xfs (attach dquots, then
> > start making changes).
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> Something like "xfs: attach dquots earlier in xfs_inactive()" might be a
> more appropriate patch title..?
> 
> Otherwise seems reasonable:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> (It also seems like this could be a standalone patch, merged
> independently instead of carrying it around with this series.)

<nod> Will do, thanks for reviewing these! :)

--D

> 
> >  fs/xfs/xfs_inode.c |   11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 85b2b11b5217..67786814997c 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1717,7 +1717,7 @@ xfs_inode_needs_inactive(
> >   */
> >  void
> >  xfs_inactive(
> > -	xfs_inode_t	*ip)
> > +	struct xfs_inode	*ip)
> >  {
> >  	struct xfs_mount	*mp;
> >  	int			error;
> > @@ -1743,6 +1743,11 @@ xfs_inactive(
> >  	if (xfs_is_metadata_inode(ip))
> >  		goto out;
> >  
> > +	/* Ensure dquots are attached prior to making changes to this file. */
> > +	error = xfs_qm_dqattach(ip);
> > +	if (error)
> > +		goto out;
> > +
> >  	/* Try to clean out the cow blocks if there are any. */
> >  	if (xfs_inode_has_cow_data(ip))
> >  		xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
> > @@ -1768,10 +1773,6 @@ xfs_inactive(
> >  	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
> >  		truncate = 1;
> >  
> > -	error = xfs_qm_dqattach(ip);
> > -	if (error)
> > -		goto out;
> > -
> >  	if (S_ISLNK(VFS_I(ip)->i_mode))
> >  		error = xfs_inactive_symlink(ip);
> >  	else if (truncate)
> > 
> 

Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26AE3C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 11 May 2022 01:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236761AbiEKBIy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 21:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbiEKBIx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 21:08:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D13C210BB9
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 18:08:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE276B82029
        for <linux-xfs@vger.kernel.org>; Wed, 11 May 2022 01:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E95C385D3;
        Wed, 11 May 2022 01:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652231329;
        bh=KfhF3zaFYgutUXiDjtn6NnvmRCiSdtcSkjZa9o4OUDM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o2eMWp5lhm2qqourIaGElyHL0IE8AgJ/nfWKpKBOSDJqKaSRUvSauz+ym/DqAid3I
         jpspM6D7FksSEbVlqLAzVpQGpPsDGhR2bBSw6uGNxEXCQidfRWYYqAlobjlL1hvEit
         1e1WakGPdc7+H+lYWuIlhfJ+Xm51I4BW6bsN7APjsuntq+nTfkkTRbvxLXUnMMX123
         dKbuyw3KF7CN3wuOsG1lnk5yzuY5+woN6uZvEZhahkJBAQw01jhBUEh6yHLrUOgZV+
         2zP3AEuzmmb2BM16pB5P7YhmLdow0aldempoyT5VKn47MEqUpH4k8CYa2IIxqE1xw3
         dwfjqO7atjchQ==
Date:   Tue, 10 May 2022 18:08:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/18] xfs: separate out initial attr_set states
Message-ID: <20220511010848.GB27195@magnolia>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-6-david@fromorbit.com>
 <20220510231234.GI27195@magnolia>
 <20220511010651.GZ1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511010651.GZ1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 11, 2022 at 11:06:51AM +1000, Dave Chinner wrote:
> On Tue, May 10, 2022 at 04:12:34PM -0700, Darrick J. Wong wrote:
> > On Mon, May 09, 2022 at 10:41:25AM +1000, Dave Chinner wrote:
> > > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > > index c9c867e3406c..ad52b5dc59e4 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.h
> > > +++ b/fs/xfs/libxfs/xfs_attr.h
> > > @@ -530,4 +553,35 @@ void xfs_attri_destroy_cache(void);
> > >  int __init xfs_attrd_init_cache(void);
> > >  void xfs_attrd_destroy_cache(void);
> > >  
> > > +/*
> > > + * Check to see if the attr should be upgraded from non-existent or shortform to
> > > + * single-leaf-block attribute list.
> > > + */
> > > +static inline bool
> > > +xfs_attr_is_shortform(
> > > +	struct xfs_inode    *ip)
> > > +{
> > > +	return ip->i_afp->if_format == XFS_DINODE_FMT_LOCAL ||
> > > +	       (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
> > > +		ip->i_afp->if_nextents == 0);
> > > +}
> > > +
> > > +static inline enum xfs_delattr_state
> > > +xfs_attr_init_add_state(struct xfs_da_args *args)
> > > +{
> > > +	if (!args->dp->i_afp)
> > > +		return XFS_DAS_DONE;
> > 
> > If we're in add/replace attr call without an attr fork, why do we go
> > straight to finished?
> 
> I suspect I've fixed all the issues that triggered crashes here
> because args->dp->i_afp was null. THere were transient states in a
> replace operaiton when the remove takes away the last attr, removes
> the attr fork, then calls the ADD operation. The add operation
> assumes that the attr fork has already been set up, and so bad
> things happened here.
> 
> This also occurred when setting up recovery operations - recovery of
> an add/replace could start from that same "there's no attr fork"
> condition, and so calling xfs_inode_has_attr() or
> xfs_attr_is_shortform() direct from the reocovery setup code would
> go splat because ip->i_afp was null.
> 
> I'm going to leave this for the moment (cleanup note made) because I
> don't want to have to find out that I missed a corner case somewhere
> they hard way right now. It's basically there to stop log recovery
> crashing hard, which only occurs when the experimental larp code is
> running, so I think this is safe to leave for a later cleanup.

Hmm, in that case, can this become:

	if (!args->dp->i_afp) {
		ASSERT(0);
		return XFS_DAS_DONE;
	}

And then you can add:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

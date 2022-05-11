Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25375C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 11 May 2022 15:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343929AbiEKPkL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 May 2022 11:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343941AbiEKPkE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 May 2022 11:40:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD4D22440A
        for <linux-xfs@vger.kernel.org>; Wed, 11 May 2022 08:39:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5005EB824D0
        for <linux-xfs@vger.kernel.org>; Wed, 11 May 2022 15:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10736C34113;
        Wed, 11 May 2022 15:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652283593;
        bh=DrPqVm9VMSVPOffk7TxKgiUGgdhfJmPMh6iIwk2tsRg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n3KfGachj3pug6h3U8nIO4jJ2AfZmSCpwkqvQhz0wBroD2sn5aGnpbDhOp2tFqDHH
         uCg+fPaIeX+WJdwV1nGsfFUctPYuCfulg/H1TcYz6SyOriVcPg6hTaPCj6JUSRqVUP
         35hYEMbwxekruE53cyaN18Z8f+HYrCGXfH0RHiYtu7C1TBIifgKqHjp1OAJ1o56p3t
         qacHVOFz0wNW/PHF/69NCfhhdXqEx2NJxSdLU7RPQBKSreVSWg6cb4iRokWIjTJYQ8
         1nheIA+Ac/9cc86Te2K4miF9+HuEM9PQYb90PLodxbhbm6J0atzBPPWC+tI4G9nBDC
         jpuOKmB9NWpEg==
Date:   Wed, 11 May 2022 08:39:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/18] xfs: separate out initial attr_set states
Message-ID: <20220511153952.GF27195@magnolia>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-6-david@fromorbit.com>
 <20220510231234.GI27195@magnolia>
 <20220511010651.GZ1098723@dread.disaster.area>
 <20220511010848.GB27195@magnolia>
 <20220511013851.GD1098723@dread.disaster.area>
 <20220511083513.GJ1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511083513.GJ1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 11, 2022 at 06:35:13PM +1000, Dave Chinner wrote:
> On Wed, May 11, 2022 at 11:38:51AM +1000, Dave Chinner wrote:
> > On Tue, May 10, 2022 at 06:08:48PM -0700, Darrick J. Wong wrote:
> > > On Wed, May 11, 2022 at 11:06:51AM +1000, Dave Chinner wrote:
> > > > On Tue, May 10, 2022 at 04:12:34PM -0700, Darrick J. Wong wrote:
> > > > > On Mon, May 09, 2022 at 10:41:25AM +1000, Dave Chinner wrote:
> > > > > > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > > > > > index c9c867e3406c..ad52b5dc59e4 100644
> > > > > > --- a/fs/xfs/libxfs/xfs_attr.h
> > > > > > +++ b/fs/xfs/libxfs/xfs_attr.h
> > > > > > @@ -530,4 +553,35 @@ void xfs_attri_destroy_cache(void);
> > > > > >  int __init xfs_attrd_init_cache(void);
> > > > > >  void xfs_attrd_destroy_cache(void);
> > > > > >  
> > > > > > +/*
> > > > > > + * Check to see if the attr should be upgraded from non-existent or shortform to
> > > > > > + * single-leaf-block attribute list.
> > > > > > + */
> > > > > > +static inline bool
> > > > > > +xfs_attr_is_shortform(
> > > > > > +	struct xfs_inode    *ip)
> > > > > > +{
> > > > > > +	return ip->i_afp->if_format == XFS_DINODE_FMT_LOCAL ||
> > > > > > +	       (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
> > > > > > +		ip->i_afp->if_nextents == 0);
> > > > > > +}
> > > > > > +
> > > > > > +static inline enum xfs_delattr_state
> > > > > > +xfs_attr_init_add_state(struct xfs_da_args *args)
> > > > > > +{
> > > > > > +	if (!args->dp->i_afp)
> > > > > > +		return XFS_DAS_DONE;
> > > > > 
> > > > > If we're in add/replace attr call without an attr fork, why do we go
> > > > > straight to finished?
> > > > 
> > > > I suspect I've fixed all the issues that triggered crashes here
> > > > because args->dp->i_afp was null. THere were transient states in a
> > > > replace operaiton when the remove takes away the last attr, removes
> > > > the attr fork, then calls the ADD operation. The add operation
> > > > assumes that the attr fork has already been set up, and so bad
> > > > things happened here.
> > > > 
> > > > This also occurred when setting up recovery operations - recovery of
> > > > an add/replace could start from that same "there's no attr fork"
> > > > condition, and so calling xfs_inode_has_attr() or
> > > > xfs_attr_is_shortform() direct from the reocovery setup code would
> > > > go splat because ip->i_afp was null.
> > > > 
> > > > I'm going to leave this for the moment (cleanup note made) because I
> > > > don't want to have to find out that I missed a corner case somewhere
> > > > they hard way right now. It's basically there to stop log recovery
> > > > crashing hard, which only occurs when the experimental larp code is
> > > > running, so I think this is safe to leave for a later cleanup.
> > > 
> > > Hmm, in that case, can this become:
> > > 
> > > 	if (!args->dp->i_afp) {
> > > 		ASSERT(0);
> > > 		return XFS_DAS_DONE;
> > > 	}
> > 
> > OK.
> 
> Ok, now generic/051 has reminded me exactly what this was for.
> 
> Shortform attr remove will remove the attr and the attr fork from
> this code:
> 
>         case XFS_DAS_SF_REMOVE:                                                  
>                 error = xfs_attr_sf_removename(args);                            
>                 attr->xattri_dela_state = xfs_attr_complete_op(attr,             
>                                                 xfs_attr_init_add_state(args));  
>                 break;                                                           
> 
> But if we are doing this as part of a REPLACE operation and we
> still need to add the new attr, it calls xfs_attr_init_add_state()
> to get the add state we should start with. That then hits the
> null args->dp->i_afp case because the fork got removed.
> 
> This can't happen if we are doing a replace op, so we'd then check
> if it's a shortform attr fork and return XFS_DAS_SF_ADD for the
> replace to then execute. But it's not a replace op, so we can
> have a null attr fork.
> 
> I'm going to restore the old code with a comment so that I don't
> forget this again.
> 
> /*
>  * If called from the completion of a attr remove to determine
>  * the next state, the attribute fork may be null. This can occur on
>  * a pure remove, but we grab the next state before we check if a
>  * replace operation is being performed. Hence if the attr fork is
>  * null, it's a pure remove operation and we are done.
>  */

Ahh, I see -- sf_removename will /never/ kill i_afp if we're doing a
DA_OP_REPLACE or ADDNAME, and leaf_removename also won't do that if
we're doing DA_OP_REPLACE.  IOWs, only a removexattr operation can
result in i_afp being freed.

And the XATTR_CREATE operation always guarantee that i_afp is non-null
before we start, so xfs_attr_defer_add should never be called with
args->dp->i_afp == NULL, hence it'll never hit that state.

Would you mind adding a sentence to the comment?

"A pure create ensures the existence of i_afp and never encounters this
state."

FBO of maintainers who aren't quite as uptodate on how xattrs work? ;)

(Admittedly all this will probably go away if we stop freeing i_afp, but
I wasn't going to push on that until the LARP stuff settles...)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

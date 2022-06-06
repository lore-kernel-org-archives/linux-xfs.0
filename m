Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07856C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 00:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348715AbiFFAIv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jun 2022 20:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345935AbiFFAIv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jun 2022 20:08:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AA54A93E
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 17:08:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 008E2B80DEF
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 00:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41AFC385A5;
        Mon,  6 Jun 2022 00:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654474126;
        bh=svLEFmpUyrYJn5P7SxK5MElEop7XUwqOnZ8gJxLgCgA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PkQXRFHOY34SL6BszRW0x8ek/mSC31A2VZw1eH+t/OStmygQvbUnHOZ/4ru3YY/Xq
         v+xTgRadv8YW1QHzNWhjI51or+Vnu8K03W1/qVQzu7U7HRrqiKMzh1YgjGPH41sB4+
         csdkV5/KghGbtaS2fFnTWph7OVQtu33crkqFHoNwPhuPZu9ejbcOV7sldBTcIrKI5J
         seBB6KNXDaEPTXD1c8z/yI+j0MolftjHVcqW8GMW9/gOgcsqvjehCLpyEIMSbtvSa8
         3k9/1lP5Pbxqijv4sLFQHUNeECeCV5IqQnDCxqFNMNJOOz0ngrLWVuVvNKKWpN1FkO
         SNapCZhjIS7WA==
Date:   Sun, 5 Jun 2022 17:08:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: fix TOCTOU race involving the new logged xattrs
 control knob
Message-ID: <Yp1FjrXqwcAgMYg/@magnolia>
References: <YpzbrQdA9voYKRCE@magnolia>
 <20220605224743.GM1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605224743.GM1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 06, 2022 at 08:47:43AM +1000, Dave Chinner wrote:
> On Sun, Jun 05, 2022 at 09:37:01AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > I found a race involving the larp control knob, aka the debugging knob
> > that lets developers enable logging of extended attribute updates:
> > 
> > Thread 1			Thread 2
> > 
> > echo 0 > /sys/fs/xfs/debug/larp
> > 				setxattr(REPLACE)
> > 				xfs_has_larp (returns false)
> > 				xfs_attr_set
> > 
> > echo 1 > /sys/fs/xfs/debug/larp
> > 
> > 				xfs_attr_defer_replace
> > 				xfs_attr_init_replace_state
> > 				xfs_has_larp (returns true)
> > 				xfs_attr_init_remove_state
> > 
> > 				<oops, wrong DAS state!>
> > 
> > This isn't a particularly severe problem right now because xattr logging
> > is only enabled when CONFIG_XFS_DEBUG=y, and developers *should* know
> > what they're doing.
> > 
> > However, the eventual intent is that callers should be able to ask for
> > the assistance of the log in persisting xattr updates.  This capability
> > might not be required for /all/ callers, which means that dynamic
> > control must work correctly.  Once an xattr update has decided whether
> > or not to use logged xattrs, it needs to stay in that mode until the end
> > of the operation regardless of what subsequent parallel operations might
> > do.
> > 
> > Therefore, it is an error to continue sampling xfs_globals.larp once
> > xfs_attr_change has made a decision about larp, and it was not correct
> > for me to have told Allison that ->create_intent functions can sample
> > the global log incompat feature bitfield to decide to elide a log item.
> > 
> > Instead, create a new op flag for the xfs_da_args structure, and convert
> > all other callers of xfs_has_larp and xfs_sb_version_haslogxattrs within
> > the attr update state machine to look for the operations flag.
> 
> *nod*
> 
> ....
> 
> > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > index 4a28c2d77070..135d44133477 100644
> > --- a/fs/xfs/xfs_attr_item.c
> > +++ b/fs/xfs/xfs_attr_item.c
> > @@ -413,18 +413,20 @@ xfs_attr_create_intent(
> >  	struct xfs_mount		*mp = tp->t_mountp;
> >  	struct xfs_attri_log_item	*attrip;
> >  	struct xfs_attr_intent		*attr;
> > +	struct xfs_da_args		*args;
> >  
> >  	ASSERT(count == 1);
> >  
> > -	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
> > -		return NULL;
> > -
> >  	/*
> >  	 * Each attr item only performs one attribute operation at a time, so
> >  	 * this is a list of one
> >  	 */
> >  	attr = list_first_entry_or_null(items, struct xfs_attr_intent,
> >  			xattri_list);
> > +	args = attr->xattri_da_args;
> > +
> > +	if (!(args->op_flags & XFS_DA_OP_LOGGED))
> > +		return NULL;
> 
> Hmmmm.  For the non-LARP case, do we need to be checking
> 
> 	if (!attr)
> 		return NULL;
> 
> now?

I don't think that's necessary, since the struct xfs_attr_intent is
always allocated and used to track the incore state of the operation,
even when we aren't going to use the log items.

> > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > index 35e13e125ec6..149a8f537b06 100644
> > --- a/fs/xfs/xfs_xattr.c
> > +++ b/fs/xfs/xfs_xattr.c
> > @@ -68,6 +68,18 @@ xfs_attr_rele_log_assist(
> >  	xlog_drop_incompat_feat(mp->m_log);
> >  }
> >  
> > +#ifdef DEBUG
> > +static inline bool
> > +xfs_attr_want_log_assist(
> > +	struct xfs_mount	*mp)
> > +{
> > +	/* Logged xattrs require a V5 super for log_incompat */
> > +	return xfs_has_crc(mp) && xfs_globals.larp;
> > +}
> > +#else
> > +# define xfs_attr_want_log_assist(mp)	false
> > +#endif
> 
> If you are moving this code, let's clean it up a touch so that it
> is the internal logic that is conditional, not the function itself.
> 
> static inline bool
> xfs_attr_want_log_assist(
> 	struct xfs_mount	*mp)
> {
> #ifdef DEBUG
> 	/* Logged xattrs require a V5 super for log_incompat */
> 	return xfs_has_crc(mp) && xfs_globals.larp;
> #else
> 	return false;
> #endif
> }

I don't mind turning this into a straight function move.  I'd figured
that Linus' style preference is usually against putting conditional
compilation inside functions, but for a static inline I really don't
care either way.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

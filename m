Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5483AC43334
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jun 2022 22:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348649AbiFEWrt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jun 2022 18:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240474AbiFEWrs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jun 2022 18:47:48 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 839BE1172
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 15:47:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2543310E706C;
        Mon,  6 Jun 2022 08:47:45 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nxz27-0038zS-O9; Mon, 06 Jun 2022 08:47:43 +1000
Date:   Mon, 6 Jun 2022 08:47:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: fix TOCTOU race involving the new logged xattrs
 control knob
Message-ID: <20220605224743.GM1098723@dread.disaster.area>
References: <YpzbrQdA9voYKRCE@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YpzbrQdA9voYKRCE@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=629d3291
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=LP08cwMIPuYS6LvU-34A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 05, 2022 at 09:37:01AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I found a race involving the larp control knob, aka the debugging knob
> that lets developers enable logging of extended attribute updates:
> 
> Thread 1			Thread 2
> 
> echo 0 > /sys/fs/xfs/debug/larp
> 				setxattr(REPLACE)
> 				xfs_has_larp (returns false)
> 				xfs_attr_set
> 
> echo 1 > /sys/fs/xfs/debug/larp
> 
> 				xfs_attr_defer_replace
> 				xfs_attr_init_replace_state
> 				xfs_has_larp (returns true)
> 				xfs_attr_init_remove_state
> 
> 				<oops, wrong DAS state!>
> 
> This isn't a particularly severe problem right now because xattr logging
> is only enabled when CONFIG_XFS_DEBUG=y, and developers *should* know
> what they're doing.
> 
> However, the eventual intent is that callers should be able to ask for
> the assistance of the log in persisting xattr updates.  This capability
> might not be required for /all/ callers, which means that dynamic
> control must work correctly.  Once an xattr update has decided whether
> or not to use logged xattrs, it needs to stay in that mode until the end
> of the operation regardless of what subsequent parallel operations might
> do.
> 
> Therefore, it is an error to continue sampling xfs_globals.larp once
> xfs_attr_change has made a decision about larp, and it was not correct
> for me to have told Allison that ->create_intent functions can sample
> the global log incompat feature bitfield to decide to elide a log item.
> 
> Instead, create a new op flag for the xfs_da_args structure, and convert
> all other callers of xfs_has_larp and xfs_sb_version_haslogxattrs within
> the attr update state machine to look for the operations flag.

*nod*

....

> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 4a28c2d77070..135d44133477 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -413,18 +413,20 @@ xfs_attr_create_intent(
>  	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_attri_log_item	*attrip;
>  	struct xfs_attr_intent		*attr;
> +	struct xfs_da_args		*args;
>  
>  	ASSERT(count == 1);
>  
> -	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
> -		return NULL;
> -
>  	/*
>  	 * Each attr item only performs one attribute operation at a time, so
>  	 * this is a list of one
>  	 */
>  	attr = list_first_entry_or_null(items, struct xfs_attr_intent,
>  			xattri_list);
> +	args = attr->xattri_da_args;
> +
> +	if (!(args->op_flags & XFS_DA_OP_LOGGED))
> +		return NULL;

Hmmmm.  For the non-LARP case, do we need to be checking

	if (!attr)
		return NULL;

now?

> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 35e13e125ec6..149a8f537b06 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -68,6 +68,18 @@ xfs_attr_rele_log_assist(
>  	xlog_drop_incompat_feat(mp->m_log);
>  }
>  
> +#ifdef DEBUG
> +static inline bool
> +xfs_attr_want_log_assist(
> +	struct xfs_mount	*mp)
> +{
> +	/* Logged xattrs require a V5 super for log_incompat */
> +	return xfs_has_crc(mp) && xfs_globals.larp;
> +}
> +#else
> +# define xfs_attr_want_log_assist(mp)	false
> +#endif

If you are moving this code, let's clean it up a touch so that it
is the internal logic that is conditional, not the function itself.

static inline bool
xfs_attr_want_log_assist(
	struct xfs_mount	*mp)
{
#ifdef DEBUG
	/* Logged xattrs require a V5 super for log_incompat */
	return xfs_has_crc(mp) && xfs_globals.larp;
#else
	return false;
#endif
}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

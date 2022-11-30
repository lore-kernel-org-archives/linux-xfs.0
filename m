Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E78C9C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Nov 2022 00:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiK3AOQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 19:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbiK3ANt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 19:13:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3B271F39
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 16:13:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30BCCB81897
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 00:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB51C433C1;
        Wed, 30 Nov 2022 00:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669767225;
        bh=tLbY/X4oUYg06/OxDOhlat04A8dBJvD+82RqlE62mXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KMNJFLy7Y6NJxp3nlwRTBeHrYXGWn15gj8U8jDLL0y5rRF3Mh2/65x9roCE8SrH/u
         YP3LI6PSzCsUTU4ROQxj3yF88gXaJUPRWc+bkuAvHjVb2hlqh2FCF5BO2f0nbXGiNV
         ryS6zovOfIajlnSt8vxVEzFt+qpbsPA2Nl0uUM0QOVjyWINEGLmDjcp1MFhO7wRhPB
         fFXmB/4PaU5dgT0hQzarOMq9Wicx050g1alwkJYIq1gCy3pQPypIAXZwm77u7S1jX3
         TzAWJgAmN+BuONmOJOzXLnTF+W27zk7HlqgLV5z9jc0hxFYPrWl+GMspgQ3MlJRc0r
         HqE6NhgLW1m1g==
Date:   Tue, 29 Nov 2022 16:13:45 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: hoist refcount record merge predicates
Message-ID: <Y4agOW31nIxz0whD@magnolia>
References: <166975928548.3768925.15141817742859398250.stgit@magnolia>
 <166975929118.3768925.9568770405264708473.stgit@magnolia>
 <20221129223531.GJ3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129223531.GJ3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 30, 2022 at 09:35:31AM +1100, Dave Chinner wrote:
> On Tue, Nov 29, 2022 at 02:01:31PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Hoist these multiline conditionals into separate static inline helpers
> > to improve readability and set the stage for corruption fixes that will
> > be introduced in the next patch.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_refcount.c |  126 +++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 110 insertions(+), 16 deletions(-)
> 
> Looks OK. Minor nit below.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > index 3f34bafe18dd..8c68994d09f3 100644
> > --- a/fs/xfs/libxfs/xfs_refcount.c
> > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > @@ -815,11 +815,116 @@ xfs_refcount_find_right_extents(
> >  /* Is this extent valid? */
> >  static inline bool
> >  xfs_refc_valid(
> > -	struct xfs_refcount_irec	*rc)
> > +	const struct xfs_refcount_irec	*rc)
> >  {
> >  	return rc->rc_startblock != NULLAGBLOCK;
> >  }
> >  
> > +static inline bool
> > +xfs_refc_want_merge_center(
> > +	const struct xfs_refcount_irec	*left,
> > +	const struct xfs_refcount_irec	*cleft,
> > +	const struct xfs_refcount_irec	*cright,
> > +	const struct xfs_refcount_irec	*right,
> > +	bool				cleft_is_cright,
> > +	enum xfs_refc_adjust_op		adjust,
> > +	unsigned long long		*ulenp)
> > +{
> > +	unsigned long long		ulen = left->rc_blockcount;
> > +
> > +	/*
> > +	 * To merge with a center record, both shoulder records must be
> > +	 * adjacent to the record we want to adjust.  This is only true if
> > +	 * find_left and find_right made all four records valid.
> > +	 */
> > +	if (!xfs_refc_valid(left)  || !xfs_refc_valid(right) ||
> > +	    !xfs_refc_valid(cleft) || !xfs_refc_valid(cright))
> > +		return false;
> > +
> > +	/* There must only be one record for the entire range. */
> > +	if (!cleft_is_cright)
> > +		return false;
> > +
> > +	/* The shoulder record refcounts must match the new refcount. */
> > +	if (left->rc_refcount != cleft->rc_refcount + adjust)
> > +		return false;
> > +	if (right->rc_refcount != cleft->rc_refcount + adjust)
> > +		return false;
> > +
> > +	/*
> > +	 * The new record cannot exceed the max length.  The funny computation
> > +	 * of ulen avoids casting.
> > +	 */
> > +	ulen += cleft->rc_blockcount + right->rc_blockcount;
> > +	if (ulen >= MAXREFCEXTLEN)
> > +		return false;
> 
> The comment took me a bit of spelunking to decipher what the "funny
> computation" was. Better to spell it out directly (catch u32
> overflows) than just hint that there's somethign special about it.
> Say:
> 
> 	/*
> 	 * The new record cannot exceed the max length. ulen is a
> 	 * ULL as the individual record block counts can be up to
> 	 * (u32 - 1) in length hence we need to catch u32 addition
> 	 * overflows here.
> 	 */

Done; thanks for the quick review!

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

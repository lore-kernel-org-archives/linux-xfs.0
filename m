Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B23F6C433ED
	for <linux-xfs@archiver.kernel.org>; Sat, 15 May 2021 15:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8124A613D1
	for <linux-xfs@archiver.kernel.org>; Sat, 15 May 2021 15:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhEOPlu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 15 May 2021 11:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232851AbhEOPlt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 15 May 2021 11:41:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 452C861377;
        Sat, 15 May 2021 15:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621093236;
        bh=cdg6gp74z4+DByMVGh5XtS5KnYD/RSXpc+t6MCf8/ms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UbYbvIVq83CgbmbveKXxgl/wVTvE15FsQLsjBq5976qkJBZqzM2SPl7NIssZ49pPd
         mpx4kA+t5ybDXGc8FRYk7CC4vIeAOqgM5v7rFWEZ072glvso/tc2A6dZUoBVzTWoLD
         1xRTqFxhZUF4xbR7e77bbpgONfn1XxUUV5/z0RlGzLADGn5aj94EWcVX4Gdgc2BQdG
         uswGQW+B4aH0Pagl526VjImzzk6XnKcvxCi4+yi5K4k3Fh38KFmfwkDSirLDEmFOq/
         BFFnSh1SgWjgupinAUWpt7fJdL8Gha7w0fa2Px4F3ZzhIjkbqJBjncUQsEfISPiFgu
         wy+RDh/Hvictg==
Date:   Sat, 15 May 2021 08:40:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v18 04/11] xfs: Add helper xfs_attr_set_fmt
Message-ID: <20210515154036.GR9675@magnolia>
References: <20210512161408.5516-1-allison.henderson@oracle.com>
 <20210512161408.5516-5-allison.henderson@oracle.com>
 <20210513234604.GD9675@magnolia>
 <50c0cda3-d3e2-2d02-4958-123f08b535e7@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50c0cda3-d3e2-2d02-4958-123f08b535e7@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 14, 2021 at 10:42:05PM -0700, Allison Henderson wrote:
> 
> 
> On 5/13/21 4:46 PM, Darrick J. Wong wrote:
> > On Wed, May 12, 2021 at 09:14:01AM -0700, Allison Henderson wrote:
> > > This patch adds a helper function xfs_attr_set_fmt.  This will help
> > > isolate the code that will require state management from the portions
> > > that do not.  xfs_attr_set_fmt returns 0 when the attr has been set and
> > > no further action is needed.  It returns -EAGAIN when shortform has been
> > > transformed to leaf, and the calling function should proceed the set the
> > > attr in leaf form.
> > > 
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > 
> > Er... can't you combine patches 3 and 4 into a single patch that
> > renames xfs_attr_set_shortform -> xfs_attr_set_fmt and drops the
> > **leafbp parameter?  Smushing the two together it's a bit more obvious
> > what's really changing here (which really isn't that much!) so:
> > 
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > (Though I think I would like the two combined for v19.  But let's see
> > what I think of the whole series by the time I reach the end, eh? :) )
> So... did your feelings change much by the end of the set?  I have to admit,
> looking at the combination of these two patches, the diff does not look
> particularly attractive.  During all our refactoring efforts, I think we did
> a little bit of a circle between these two.
> 
> Rather than sending out a v19 with a poor patch that will most certainly
> result in a v20... how about I slap them together, and send them out in an
> RFC explaining what it is?  That way people can look at it and we can
> discuss what we really want to keep.  Because from looking at the diff,
> there's really only a few bits of functional changes, that would probably be
> appropriate to lump in with patch 11 if everyone is in agreement.  Then
> possibly just drop 3 and 4?

Since you now have the same set of RVB tags for patches 3 and 4, I think
it's ok to combine them into a single patch with the same set of RVBs.

(As in: generate diff files for the entire stgit/quilt/guilt stack, pop
to patch 3 in the stack, apply patch 4's diff, update the commit message
for patch 3, commit patch 3, then delete patch 4 from the stack.)

Then tack all the cleanup stuffs onto the end as patches 12-whatever.

That way the cleanups happen and as far as I'm concerned you're not
making any tweaks to the v18 changes that are so large as to demand
re-review.

--D

> 
> Allison
> 
> 
> > 
> > --D
> > 
> > > ---
> > >   fs/xfs/libxfs/xfs_attr.c | 79 ++++++++++++++++++++++++++++--------------------
> > >   1 file changed, 46 insertions(+), 33 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index 32133a0..1a618a2 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -236,6 +236,48 @@ xfs_attr_is_shortform(
> > >   		ip->i_afp->if_nextents == 0);
> > >   }
> > > +STATIC int
> > > +xfs_attr_set_fmt(
> > > +	struct xfs_da_args	*args)
> > > +{
> > > +	struct xfs_buf          *leaf_bp = NULL;
> > > +	struct xfs_inode	*dp = args->dp;
> > > +	int			error2, error = 0;
> > > +
> > > +	/*
> > > +	 * Try to add the attr to the attribute list in the inode.
> > > +	 */
> > > +	error = xfs_attr_try_sf_addname(dp, args);
> > > +	if (error != -ENOSPC) {
> > > +		error2 = xfs_trans_commit(args->trans);
> > > +		args->trans = NULL;
> > > +		return error ? error : error2;
> > > +	}
> > > +
> > > +	/*
> > > +	 * It won't fit in the shortform, transform to a leaf block.
> > > +	 * GROT: another possible req'mt for a double-split btree op.
> > > +	 */
> > > +	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	/*
> > > +	 * Prevent the leaf buffer from being unlocked so that a
> > > +	 * concurrent AIL push cannot grab the half-baked leaf buffer
> > > +	 * and run into problems with the write verifier.
> > > +	 */
> > > +	xfs_trans_bhold(args->trans, leaf_bp);
> > > +	error = xfs_defer_finish(&args->trans);
> > > +	xfs_trans_bhold_release(args->trans, leaf_bp);
> > > +	if (error) {
> > > +		xfs_trans_brelse(args->trans, leaf_bp);
> > > +		return error;
> > > +	}
> > > +
> > > +	return -EAGAIN;
> > > +}
> > > +
> > >   /*
> > >    * Set the attribute specified in @args.
> > >    */
> > > @@ -244,8 +286,7 @@ xfs_attr_set_args(
> > >   	struct xfs_da_args	*args)
> > >   {
> > >   	struct xfs_inode	*dp = args->dp;
> > > -	struct xfs_buf          *leaf_bp = NULL;
> > > -	int			error2, error = 0;
> > > +	int			error;
> > >   	/*
> > >   	 * If the attribute list is already in leaf format, jump straight to
> > > @@ -254,36 +295,9 @@ xfs_attr_set_args(
> > >   	 * again.
> > >   	 */
> > >   	if (xfs_attr_is_shortform(dp)) {
> > > -		/*
> > > -		 * Try to add the attr to the attribute list in the inode.
> > > -		 */
> > > -		error = xfs_attr_try_sf_addname(dp, args);
> > > -		if (error != -ENOSPC) {
> > > -			error2 = xfs_trans_commit(args->trans);
> > > -			args->trans = NULL;
> > > -			return error ? error : error2;
> > > -		}
> > > -
> > > -		/*
> > > -		 * It won't fit in the shortform, transform to a leaf block.
> > > -		 * GROT: another possible req'mt for a double-split btree op.
> > > -		 */
> > > -		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> > > -		if (error)
> > > -			return error;
> > > -
> > > -		/*
> > > -		 * Prevent the leaf buffer from being unlocked so that a
> > > -		 * concurrent AIL push cannot grab the half-baked leaf buffer
> > > -		 * and run into problems with the write verifier.
> > > -		 */
> > > -		xfs_trans_bhold(args->trans, leaf_bp);
> > > -		error = xfs_defer_finish(&args->trans);
> > > -		xfs_trans_bhold_release(args->trans, leaf_bp);
> > > -		if (error) {
> > > -			xfs_trans_brelse(args->trans, leaf_bp);
> > > +		error = xfs_attr_set_fmt(args);
> > > +		if (error != -EAGAIN)
> > >   			return error;
> > > -		}
> > >   	}
> > >   	if (xfs_attr_is_leaf(dp)) {
> > > @@ -317,8 +331,7 @@ xfs_attr_set_args(
> > >   			return error;
> > >   	}
> > > -	error = xfs_attr_node_addname(args);
> > > -	return error;
> > > +	return xfs_attr_node_addname(args);
> > >   }
> > >   /*
> > > -- 
> > > 2.7.4
> > > 

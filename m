Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C1EC433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Apr 2021 11:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1673461178
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Apr 2021 11:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhDZLuF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Apr 2021 07:50:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37917 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231970AbhDZLuE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Apr 2021 07:50:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619437762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Snzy91FnAOYuTyzoGIjiB5fhrTiK2cNIBXdzVfIDuDs=;
        b=Nk0H1n5XDaEMnf6RdlM3Y38CFzvKA8v+XnfCmgLebb8EgZ+b+TG7wu2G4pGYbxsBNKtdn7
        CHkJyV4Dw5SQDax6cGXmN8+uEkcTB+zoxFClikxB2IPzQ+LSnA7QZuambB4YZgQn9jZAup
        QKS/E4Uq609J0BCpnoHHDUn3iknBb14=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-6k4vScURMNGDz2gg7Ts3tg-1; Mon, 26 Apr 2021 07:49:20 -0400
X-MC-Unique: 6k4vScURMNGDz2gg7Ts3tg-1
Received: by mail-qk1-f200.google.com with SMTP id l19-20020a37f5130000b02902e3dc23dc92so16503113qkk.15
        for <linux-xfs@vger.kernel.org>; Mon, 26 Apr 2021 04:49:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Snzy91FnAOYuTyzoGIjiB5fhrTiK2cNIBXdzVfIDuDs=;
        b=uStXQyg2Xn3GGwAC3OeuiDKGI6uacwWMm4fsOOAcT90Pl0fvxsmTbdXd5MNEW9Q1UD
         JSNR0lsmfcfoNnf0lGm3KhXS2EJrp/YecIUWYMGVwxyqUpG3cFjbSsonNZ40OrroZJip
         FeGv990I6JOU/wS4RSAzRhfEkWnmSsJrI4+79wAV6zKz4tm92YkGTdIH+klgfGCx/vlO
         EOcrk/KBt5J3tP8L7CHqBhQtjtYeY7Ez/opso9H6mY2UNM+fuAAnIfRDbea+JtsyEr3k
         kjufM/gnHGF/K9qUv1b4qlBTJAIqzgJzthTM5kTGpsvkO5o99+nBybsSF5HNxp+HG0AE
         t/AQ==
X-Gm-Message-State: AOAM530hz+2RUt4w7G/6n811qea/aLQZ/+2tOrrU9BkQJWf915vui6Lb
        s2cbVkt/YI9i4k9FRw1/ByPxbLSPWHh8DIAuMs194qpSiuQCLSkul74Zn+ng9yDZLnCuzNOAIN2
        yeUQ1f8pyUX1aIq9C35Mu
X-Received: by 2002:ac8:5a03:: with SMTP id n3mr15775505qta.178.1619437759482;
        Mon, 26 Apr 2021 04:49:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlqonq2ADlHgoS1RpLjWd+uXAV11zsa/7eU7QnFAlU1Yz+BGt/mEXrRe4y3hVYwyGRGwbgKA==
X-Received: by 2002:ac8:5a03:: with SMTP id n3mr15775481qta.178.1619437759104;
        Mon, 26 Apr 2021 04:49:19 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id 3sm1439958qko.120.2021.04.26.04.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 04:49:18 -0700 (PDT)
Date:   Mon, 26 Apr 2021 07:49:13 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v17 10/11] xfs: Add delay ready attr remove routines
Message-ID: <YIaouQ2cWRcitiev@bfoster>
References: <20210416092045.2215-1-allison.henderson@oracle.com>
 <20210416092045.2215-11-allison.henderson@oracle.com>
 <YIL+j3BmnDOEqHrp@bfoster>
 <85c61f76-81e1-9c03-3171-0f01759c46de@oracle.com>
 <20210424155645.GX3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210424155645.GX3122264@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 24, 2021 at 08:56:45AM -0700, Darrick J. Wong wrote:
> On Fri, Apr 23, 2021 at 08:27:28PM -0700, Allison Henderson wrote:
> > 
> > 
> > On 4/23/21 10:06 AM, Brian Foster wrote:
> > > On Fri, Apr 16, 2021 at 02:20:44AM -0700, Allison Henderson wrote:
> > > > This patch modifies the attr remove routines to be delay ready. This
> > > > means they no longer roll or commit transactions, but instead return
> > > > -EAGAIN to have the calling routine roll and refresh the transaction. In
> > > > this series, xfs_attr_remove_args is merged with
> > > > xfs_attr_node_removename become a new function, xfs_attr_remove_iter.
> > > > This new version uses a sort of state machine like switch to keep track
> > > > of where it was when EAGAIN was returned. A new version of
> > > > xfs_attr_remove_args consists of a simple loop to refresh the
> > > > transaction until the operation is completed. A new XFS_DAC_DEFER_FINISH
> > > > flag is used to finish the transaction where ever the existing code used
> > > > to.
> > > > 
> > > > Calls to xfs_attr_rmtval_remove are replaced with the delay ready
> > > > version __xfs_attr_rmtval_remove. We will rename
> > > > __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
> > > > done.
> > > > 
> > > > xfs_attr_rmtval_remove itself is still in use by the set routines (used
> > > > during a rename).  For reasons of preserving existing function, we
> > > > modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
> > > > set.  Similar to how xfs_attr_remove_args does here.  Once we transition
> > > > the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
> > > > used and will be removed.
> > > > 
> > > > This patch also adds a new struct xfs_delattr_context, which we will use
> > > > to keep track of the current state of an attribute operation. The new
> > > > xfs_delattr_state enum is used to track various operations that are in
> > > > progress so that we know not to repeat them, and resume where we left
> > > > off before EAGAIN was returned to cycle out the transaction. Other
> > > > members take the place of local variables that need to retain their
> > > > values across multiple function recalls.  See xfs_attr.h for a more
> > > > detailed diagram of the states.
> > > > 
> > > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > > ---
> > > >   fs/xfs/libxfs/xfs_attr.c        | 208 +++++++++++++++++++++++++++-------------
> > > >   fs/xfs/libxfs/xfs_attr.h        | 131 +++++++++++++++++++++++++
> > > >   fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
> > > >   fs/xfs/libxfs/xfs_attr_remote.c |  48 ++++++----
> > > >   fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
> > > >   fs/xfs/xfs_attr_inactive.c      |   2 +-
> > > >   6 files changed, 305 insertions(+), 88 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > > index ed06b60..0bea8dd 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > ...
> > > > @@ -1231,70 +1262,117 @@ xfs_attr_node_remove_cleanup(
> > > >   }
> > > >   /*
> > > > - * Remove a name from a B-tree attribute list.
> > > > + * Remove the attribute specified in @args.
> > > >    *
> > > >    * This will involve walking down the Btree, and may involve joining
> > > >    * leaf nodes and even joining intermediate nodes up to and including
> > > >    * the root node (a special case of an intermediate node).
> > > > + *
> > > > + * This routine is meant to function as either an in-line or delayed operation,
> > > > + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
> > > > + * functions will need to handle this, and recall the function until a
> > > > + * successful error code is returned.
> > > >    */
> > > > -STATIC int
> > > > -xfs_attr_node_removename(
> > > > -	struct xfs_da_args	*args)
> > > > +int
> > > > +xfs_attr_remove_iter(
> > > > +	struct xfs_delattr_context	*dac)
> > > >   {
> > > > -	struct xfs_da_state	*state;
> > > > -	int			retval, error;
> > > > -	struct xfs_inode	*dp = args->dp;
> > > > +	struct xfs_da_args		*args = dac->da_args;
> > > > +	struct xfs_da_state		*state = dac->da_state;
> > > > +	int				retval, error;
> > > > +	struct xfs_inode		*dp = args->dp;
> > > >   	trace_xfs_attr_node_removename(args);
> > > ...
> > > > +	case XFS_DAS_CLNUP:
> > > > +		retval = xfs_attr_node_remove_cleanup(args, state);
> > > 
> > > This is a nit, but when reading the code the "cleanup" name gives the
> > > impression that this is a resource cleanup or something along those
> > > lines, when this is actually a primary component of the operation where
> > > we remove the attr name. That took me a second to find. Could we tweak
> > > the state and rename the helper to something like DAS_RMNAME  /
> > > _node_remove_name() so the naming is a bit more explicit?
> > Sure, this helper is actually added in patch 2 of this set.  I can rename it
> > there?  People have already added their rvb's, but I'm assuming people are
> > not bothered by small tweeks like that?  That way this patch just sort of
> > moves it and XFS_DAS_CLNUP can turn into XFS_DAS_RMNAME here.
> 
> <bikeshed> "RMNAME" looks too similar to "RENAME" for my old eyes, can
> we please pick something else?  Like "RM_NAME", or "REMOVE_NAME" ?
> 

Either of those seem fine to me, FWIW. I think anything that expresses
removal of the name/entry over the more generic "cleanup" name is an
improvement..

Brian

> --D
> 
> > 
> > > 
> > > > -	/*
> > > > -	 * Check to see if the tree needs to be collapsed.
> > > > -	 */
> > > > -	if (retval && (state->path.active > 1)) {
> > > > -		error = xfs_da3_join(state);
> > > > -		if (error)
> > > > -			goto out;
> > > > -		error = xfs_defer_finish(&args->trans);
> > > > -		if (error)
> > > > -			goto out;
> > > >   		/*
> > > > -		 * Commit the Btree join operation and start a new trans.
> > > > +		 * Check to see if the tree needs to be collapsed. Set the flag
> > > > +		 * to indicate that the calling function needs to move the
> > > > +		 * shrink operation
> > > >   		 */
> > > > -		error = xfs_trans_roll_inode(&args->trans, dp);
> > > > -		if (error)
> > > > -			goto out;
> > > > -	}
> > > > +		if (retval && (state->path.active > 1)) {
> > > > +			error = xfs_da3_join(state);
> > > > +			if (error)
> > > > +				goto out;
> > > > -	/*
> > > > -	 * If the result is small enough, push it all into the inode.
> > > > -	 */
> > > > -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> > > > -		error = xfs_attr_node_shrink(args, state);
> > > > +			dac->flags |= XFS_DAC_DEFER_FINISH;
> > > > +			dac->dela_state = XFS_DAS_RM_SHRINK;
> > > > +			return -EAGAIN;
> > > > +		}
> > > > +
> > > > +		/* fallthrough */
> > > > +	case XFS_DAS_RM_SHRINK:
> > > > +		/*
> > > > +		 * If the result is small enough, push it all into the inode.
> > > > +		 */
> > > > +		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> > > > +			error = xfs_attr_node_shrink(args, state);
> > > > +
> > > > +		break;
> > > > +	default:
> > > > +		ASSERT(0);
> > > > +		error = -EINVAL;
> > > > +		goto out;
> > > > +	}
> > > > +	if (error == -EAGAIN)
> > > > +		return error;
> > > >   out:
> > > >   	if (state)
> > > >   		xfs_da_state_free(state);
> > > ...
> > > > diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> > > > index 48d8e9c..908521e7 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr_remote.c
> > > > +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> > > ...
> > > > @@ -685,31 +687,29 @@ xfs_attr_rmtval_remove(
> > > >   	 * Keep de-allocating extents until the remote-value region is gone.
> > > >   	 */
> > > >   	do {
> > > > -		retval = __xfs_attr_rmtval_remove(args);
> > > > -		if (retval && retval != -EAGAIN)
> > > > -			return retval;
> > > > +		error = __xfs_attr_rmtval_remove(&dac);
> > > > +		if (error != -EAGAIN)
> > > > +			break;
> > > 
> > > Shouldn't this retain the (error && error != -EAGAIN) logic to roll the
> > > transaction after the final unmap? Even if this is transient, it's
> > > probably best to preserve behavior if this is unintentional.
> > Sure, I dont think it's intentional, I think back in v10 we had a different
> > arangement here with a helper inside the while() expression that had
> > equivelent error handling logic.  But that got nak'd in the next review and
> > I think I likley forgot to put back this handling.  Will fix.
> > 
> > > 
> > > Otherwise my only remaining feedback was to add/tweak some comments that
> > > I think make the iteration function easier to follow. I've appended a
> > > diff for that. If you agree with the changes feel free to just fold them
> > > in and/or tweak as necessary. With those various nits and Chandan's
> > > feedback addressed, I think this patch looks pretty good.
> > Sure, those all look reasonable.  Will add.  Thanks for the reviews!
> > Allison
> > 
> > > 
> > > Brian
> > > 
> > > --- 8< ---
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index 0bea8dd34902..ee885c649c26 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -1289,14 +1289,21 @@ xfs_attr_remove_iter(
> > >   		if (!xfs_inode_hasattr(dp))
> > >   			return -ENOATTR;
> > > +		/*
> > > +		 * Shortform or leaf formats don't require transaction rolls and
> > > +		 * thus state transitions. Call the right helper and return.
> > > +		 */
> > >   		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
> > >   			ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> > >   			return xfs_attr_shortform_remove(args);
> > >   		}
> > > -
> > >   		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> > >   			return xfs_attr_leaf_removename(args);
> > > +		/*
> > > +		 * Node format may require transaction rolls. Set up the
> > > +		 * state context and fall into the state machine.
> > > +		 */
> > >   		if (!dac->da_state) {
> > >   			error = xfs_attr_node_removename_setup(dac);
> > >   			if (error)
> > > @@ -1304,7 +1311,7 @@ xfs_attr_remove_iter(
> > >   			state = dac->da_state;
> > >   		}
> > > -	/* fallthrough */
> > > +		/* fallthrough */
> > >   	case XFS_DAS_RMTBLK:
> > >   		dac->dela_state = XFS_DAS_RMTBLK;
> > > @@ -1316,7 +1323,8 @@ xfs_attr_remove_iter(
> > >   		 */
> > >   		if (args->rmtblkno > 0) {
> > >   			/*
> > > -			 * May return -EAGAIN. Remove blocks until 0 is returned
> > > +			 * May return -EAGAIN. Roll and repeat until all remote
> > > +			 * blocks are removed.
> > >   			 */
> > >   			error = __xfs_attr_rmtval_remove(dac);
> > >   			if (error == -EAGAIN)
> > > @@ -1325,26 +1333,26 @@ xfs_attr_remove_iter(
> > >   				goto out;
> > >   			/*
> > > -			 * Refill the state structure with buffers, the prior
> > > -			 * calls released our buffers.
> > > +			 * Refill the state structure with buffers (the prior
> > > +			 * calls released our buffers) and close out this
> > > +			 * transaction before proceeding.
> > >   			 */
> > >   			ASSERT(args->rmtblkno == 0);
> > >   			error = xfs_attr_refillstate(state);
> > >   			if (error)
> > >   				goto out;
> > > -
> > >   			dac->dela_state = XFS_DAS_CLNUP;
> > >   			dac->flags |= XFS_DAC_DEFER_FINISH;
> > >   			return -EAGAIN;
> > >   		}
> > > +		/* fallthrough */
> > >   	case XFS_DAS_CLNUP:
> > >   		retval = xfs_attr_node_remove_cleanup(args, state);
> > >   		/*
> > > -		 * Check to see if the tree needs to be collapsed. Set the flag
> > > -		 * to indicate that the calling function needs to move the
> > > -		 * shrink operation
> > > +		 * Check to see if the tree needs to be collapsed. If so, roll
> > > +		 * the transacton and fall into the shrink state.
> > >   		 */
> > >   		if (retval && (state->path.active > 1)) {
> > >   			error = xfs_da3_join(state);
> > > @@ -1360,10 +1368,12 @@ xfs_attr_remove_iter(
> > >   	case XFS_DAS_RM_SHRINK:
> > >   		/*
> > >   		 * If the result is small enough, push it all into the inode.
> > > +		 * This is our final state so it's safe to return a dirty
> > > +		 * transaction.
> > >   		 */
> > >   		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> > >   			error = xfs_attr_node_shrink(args, state);
> > > -
> > > +		ASSERT(error != -EAGAIN);
> > >   		break;
> > >   	default:
> > >   		ASSERT(0);
> > > 
> 


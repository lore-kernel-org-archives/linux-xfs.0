Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 240CFC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Dec 2020 04:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC1752231F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Dec 2020 04:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgLWEF6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Dec 2020 23:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgLWEF5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Dec 2020 23:05:57 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37FBC0613D3
        for <linux-xfs@vger.kernel.org>; Tue, 22 Dec 2020 20:05:16 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id m5so2476096pjv.5
        for <linux-xfs@vger.kernel.org>; Tue, 22 Dec 2020 20:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M0ZCtqdHdnGxtwVAXsz7jPSALA2GMVSNxK+l3L9Lb8s=;
        b=EOuiCrfQzMywTxEbMJ1p584OGiZyb8kvPavLGmJbrFKcNQ/H07cEdY47urQtI3VSfe
         4jwtdm8cHxmZfuB2nwCcCcE+leHuKcrfEsbhMnBpg07NJENPLqbijCQe10BTLWLk5jCJ
         XSdyJcC/MANX/sW5/oMBbYKAX8EEL0i+e018qn8HCAL2gyRzBPq25AxJdk+ZTz9rb1SJ
         x3s6A8iH30SSw8fQIqXBw8/gzwCaMQ12ih6OX3EW1Pwjl73A8eJUFIXV5+U9M+zLfnQm
         0erLkHSwVOK37lWmGLlbeJt6kwXp83bSL9xkKOSvoIBVPyP0UoYSpF5tHhjXFbyeILce
         C0EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M0ZCtqdHdnGxtwVAXsz7jPSALA2GMVSNxK+l3L9Lb8s=;
        b=sUMyiYo8ak+7M4PTBrPtC61UyeROMNoiror6IQmI+FRT++wGIXF2OsbYmsG8yJNwUc
         hGfunpNC2/3wOtoPdNOZRvuvZew6Y/QH0apONWNXktgfUN9pEccwb4Dn8aLZQ+WcneJX
         w6B/IBvS6hOQv/YJ2ZNbj3gghXW3c05U+CxJyg9ozlY1jmWSN0F1j7L9ALROQFGYEljl
         ov3shPAlRhyFIHX5v7V4SbPYo3diVDim47Qp6qmqQ16brte6/WeJM7pE8akZ9nypKt3Q
         Xf6uIyA0DjnAgJ/XH7C9+twrTlyg3g4tmVOeSXrlRZApe3PNXob2q/Fe2jpSlpdG3xkB
         Kg1g==
X-Gm-Message-State: AOAM533ZxkykeVycE5yCj9zX4FXmI5aqlSlx4xHfo9sFSe15+RSjk5LS
        9keuywC3tkQjlU5h8iPf1O0hWs/sb35DKw==
X-Google-Smtp-Source: ABdhPJy6jgdmJ1DJYxqrAg4U+H8mKaWoHLuTK07KfhiGYR+J5Ok+sUEKN1lcXGKIdnI8fGClcJ/FUg==
X-Received: by 2002:a17:902:12c:b029:da:e63c:dc92 with SMTP id 41-20020a170902012cb02900dae63cdc92mr23859888plb.71.1608696316245;
        Tue, 22 Dec 2020 20:05:16 -0800 (PST)
Received: from garuda.localnet ([122.171.58.160])
        by smtp.gmail.com with ESMTPSA id s23sm4115688pgj.29.2020.12.22.20.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 20:05:15 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v14 04/15] xfs: Add delay ready attr remove routines
Date:   Wed, 23 Dec 2020 09:35:13 +0530
Message-ID: <8252842.uSKlfKVlir@garuda>
In-Reply-To: <f43342e3-2839-11e5-daf9-00fc109cfc66@oracle.com>
References: <20201218072917.16805-1-allison.henderson@oracle.com> <2492487.0L5myOU7vU@garuda> <f43342e3-2839-11e5-daf9-00fc109cfc66@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 22 Dec 2020 08:41:49 -0700, Allison Henderson wrote:
>=20
> On 12/22/20 12:22 AM, Chandan Babu R wrote:
> > On Fri, 18 Dec 2020 00:29:06 -0700, Allison Henderson wrote:
> >> This patch modifies the attr remove routines to be delay ready. This
> >> means they no longer roll or commit transactions, but instead return
> >> -EAGAIN to have the calling routine roll and refresh the transaction. =
In
> >> this series, xfs_attr_remove_args has become xfs_attr_remove_iter, whi=
ch
> >> uses a sort of state machine like switch to keep track of where it was
> >> when EAGAIN was returned. xfs_attr_node_removename has also been
> >> modified to use the switch, and a new version of xfs_attr_remove_args
> >> consists of a simple loop to refresh the transaction until the operati=
on
> >> is completed. A new XFS_DAC_DEFER_FINISH flag is used to finish the
> >> transaction where ever the existing code used to.
> >>
> >> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
> >> version __xfs_attr_rmtval_remove. We will rename
> >> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
> >> done.
> >>
> >> xfs_attr_rmtval_remove itself is still in use by the set routines (used
> >> during a rename).  For reasons of preserving existing function, we
> >> modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
> >> set.  Similar to how xfs_attr_remove_args does here.  Once we transiti=
on
> >> the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
> >> used and will be removed.
> >>
> >> This patch also adds a new struct xfs_delattr_context, which we will u=
se
> >> to keep track of the current state of an attribute operation. The new
> >> xfs_delattr_state enum is used to track various operations that are in
> >> progress so that we know not to repeat them, and resume where we left
> >> off before EAGAIN was returned to cycle out the transaction. Other
> >> members take the place of local variables that need to retain their
> >> values across multiple function recalls.  See xfs_attr.h for a more
> >> detailed diagram of the states.
> >>
> >> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> >> ---
> >>   fs/xfs/libxfs/xfs_attr.c        | 218 +++++++++++++++++++++++++++++-=
=2D---------
> >>   fs/xfs/libxfs/xfs_attr.h        | 100 ++++++++++++++++++
> >>   fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
> >>   fs/xfs/libxfs/xfs_attr_remote.c |  48 +++++----
> >>   fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
> >>   fs/xfs/xfs_attr_inactive.c      |   2 +-
> >>   6 files changed, 288 insertions(+), 84 deletions(-)
> >>
> >> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> >> index 1969b88..b6330f9 100644
> >> --- a/fs/xfs/libxfs/xfs_attr.c
> >> +++ b/fs/xfs/libxfs/xfs_attr.c
> >> @@ -53,7 +53,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args =
*args, struct xfs_buf **bp);
> >>    */
> >>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> >>   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> >> -STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> >> +STATIC int xfs_attr_node_removename_iter(struct xfs_delattr_context *=
dac);
> >>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> >>   				 struct xfs_da_state **state);
> >>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> >> @@ -264,6 +264,34 @@ xfs_attr_set_shortform(
> >>   }
> >>  =20
> >>   /*
> >> + * Checks to see if a delayed attribute transaction should be rolled.=
  If so,
> >> + * also checks for a defer finish.  Transaction is finished and rolle=
d as
> >> + * needed, and returns true of false if the delayed operation should =
continue.
> >> + */
> >> +int
> >> +xfs_attr_trans_roll(
> >> +	struct xfs_delattr_context	*dac)
> >> +{
> >> +	struct xfs_da_args		*args =3D dac->da_args;
> >> +	int				error;
> >> +
> >> +	if (dac->flags & XFS_DAC_DEFER_FINISH) {
> >> +		/*
> >> +		 * The caller wants us to finish all the deferred ops so that we
> >> +		 * avoid pinning the log tail with a large number of deferred
> >> +		 * ops.
> >> +		 */
> >> +		dac->flags &=3D ~XFS_DAC_DEFER_FINISH;
> >> +		error =3D xfs_defer_finish(&args->trans);
> >> +		if (error)
> >> +			return error;
> >> +	} else
> >> +		error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> >> +
> >> +	return error;
> >> +}
> >> +
> >> +/*
> >>    * Set the attribute specified in @args.
> >>    */
> >>   int
> >> @@ -364,23 +392,58 @@ xfs_has_attr(
> >>    */
> >>   int
> >>   xfs_attr_remove_args(
> >> -	struct xfs_da_args      *args)
> >> +	struct xfs_da_args	*args)
> >>   {
> >> -	struct xfs_inode	*dp =3D args->dp;
> >> -	int			error;
> >> +	int				error;
> >> +	struct xfs_delattr_context	dac =3D {
> >> +		.da_args	=3D args,
> >> +	};
> >> +
> >> +	do {
> >> +		error =3D xfs_attr_remove_iter(&dac);
> >> +		if (error !=3D -EAGAIN)
> >> +			break;
> >> +
> >> +		error =3D xfs_attr_trans_roll(&dac);
> >> +		if (error)
> >> +			return error;
> >> +
> >> +	} while (true);
> >> +
> >> +	return error;
> >> +}
> >>  =20
> >> -	if (!xfs_inode_hasattr(dp)) {
> >> -		error =3D -ENOATTR;
> >> -	} else if (dp->i_afp->if_format =3D=3D XFS_DINODE_FMT_LOCAL) {
> >> +/*
> >> + * Remove the attribute specified in @args.
> >> + *
> >> + * This function may return -EAGAIN to signal that the transaction ne=
eds to be
> >> + * rolled.  Callers should continue calling this function until they =
receive a
> >> + * return value other than -EAGAIN.
> >> + */
> >> +int
> >> +xfs_attr_remove_iter(
> >> +	struct xfs_delattr_context	*dac)
> >> +{
> >> +	struct xfs_da_args		*args =3D dac->da_args;
> >> +	struct xfs_inode		*dp =3D args->dp;
> >> +
> >> +	/* If we are shrinking a node, resume shrink */
> >> +	if (dac->dela_state =3D=3D XFS_DAS_RM_SHRINK)
> >> +		goto node;
> >> +
> >> +	if (!xfs_inode_hasattr(dp))
> >> +		return -ENOATTR;
> >> +
> >> +	if (dp->i_afp->if_format =3D=3D XFS_DINODE_FMT_LOCAL) {
> >>   		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> >> -		error =3D xfs_attr_shortform_remove(args);
> >> -	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> >> -		error =3D xfs_attr_leaf_removename(args);
> >> -	} else {
> >> -		error =3D xfs_attr_node_removename(args);
> >> +		return xfs_attr_shortform_remove(args);
> >>   	}
> >>  =20
> >> -	return error;
> >> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> >> +		return xfs_attr_leaf_removename(args);
> >> +node:
> >> +	/* If we are not short form or leaf, then proceed to remove node */
> >> +	return  xfs_attr_node_removename_iter(dac);
> >>   }
> >>  =20
> >>   /*
> >> @@ -1178,10 +1241,11 @@ xfs_attr_leaf_mark_incomplete(
> >>    */
> >>   STATIC
> >>   int xfs_attr_node_removename_setup(
> >> -	struct xfs_da_args	*args,
> >> -	struct xfs_da_state	**state)
> >> +	struct xfs_delattr_context	*dac)
> >>   {
> >=20
> > In xfs_attr_node_removename_setup(), if either of
> > xfs_attr_leaf_mark_incomplete() or xfs_attr_rmtval_invalidate() returns=
 with a
> > non-zero value, the memory pointed to by dac->da_state is not freed. Th=
is
> > happens because the caller (i.e. xfs_attr_node_removename_iter()) check=
s for
> > the non-NULL value of its local variable "state" to actually free the
> > corresponding memory.
> >=20
> Ok, for this one it think it makes more sense to put an extra free in=20
> the helper rather than have the caller handle it.  Will fix.
>=20
> Do you have a tool thats tracing this out, or is it just by hand?=20
> Because if it's a tool, I should probably be using it too :-)
>

Unfortunately, I found this by reading through the code changes. Tools to
figure these out would be great to have since it would let us focus mostly =
on
the larger picture.

> Thanks!
> Allison
>=20
>=20
> >> -	int			error;
> >> +	struct xfs_da_args		*args =3D dac->da_args;
> >> +	struct xfs_da_state		**state =3D &dac->da_state;
> >> +	int				error;
> >>  =20
> >>   	error =3D xfs_attr_node_hasname(args, state);
> >>   	if (error !=3D -EEXIST)
> >> @@ -1203,13 +1267,16 @@ int xfs_attr_node_removename_setup(
> >>   }
> >>  =20
> >>   STATIC int
> >> -xfs_attr_node_remove_rmt(
> >> -	struct xfs_da_args	*args,
> >> -	struct xfs_da_state	*state)
> >> +xfs_attr_node_remove_rmt (
> >> +	struct xfs_delattr_context	*dac,
> >> +	struct xfs_da_state		*state)
> >>   {
> >> -	int			error =3D 0;
> >> +	int				error =3D 0;
> >>  =20
> >> -	error =3D xfs_attr_rmtval_remove(args);
> >> +	/*
> >> +	 * May return -EAGAIN to request that the caller recall this function
> >> +	 */
> >> +	error =3D __xfs_attr_rmtval_remove(dac);
> >>   	if (error)
> >>   		return error;
> >>  =20
> >> @@ -1240,28 +1307,34 @@ xfs_attr_node_remove_cleanup(
> >>   }
> >>  =20
> >>   /*
> >> - * Remove a name from a B-tree attribute list.
> >> + * Step through removeing a name from a B-tree attribute list.
> >>    *
> >>    * This will involve walking down the Btree, and may involve joining
> >>    * leaf nodes and even joining intermediate nodes up to and including
> >>    * the root node (a special case of an intermediate node).
> >> + *
> >> + * This routine is meant to function as either an inline or delayed o=
peration,
> >> + * and may return -EAGAIN when the transaction needs to be rolled.  C=
alling
> >> + * functions will need to handle this, and recall the function until a
> >> + * successful error code is returned.
> >>    */
> >>   STATIC int
> >>   xfs_attr_node_remove_step(
> >> -	struct xfs_da_args	*args,
> >> -	struct xfs_da_state	*state)
> >> +	struct xfs_delattr_context	*dac)
> >>   {
> >> -	int			error;
> >> -	struct xfs_inode	*dp =3D args->dp;
> >> -
> >> -
> >> +	struct xfs_da_args		*args =3D dac->da_args;
> >> +	struct xfs_da_state		*state =3D dac->da_state;
> >> +	int				error =3D 0;
> >>   	/*
> >>   	 * If there is an out-of-line value, de-allocate the blocks.
> >>   	 * This is done before we remove the attribute so that we don't
> >>   	 * overflow the maximum size of a transaction and/or hit a deadlock.
> >>   	 */
> >>   	if (args->rmtblkno > 0) {
> >> -		error =3D xfs_attr_node_remove_rmt(args, state);
> >> +		/*
> >> +		 * May return -EAGAIN. Remove blocks until args->rmtblkno =3D=3D 0
> >> +		 */
> >> +		error =3D xfs_attr_node_remove_rmt(dac, state);
> >>   		if (error)
> >>   			return error;
> >>   	}
> >> @@ -1274,51 +1347,74 @@ xfs_attr_node_remove_step(
> >>    *
> >>    * This routine will find the blocks of the name to remove, remove t=
hem and
> >>    * shrink the tree if needed.
> >> + *
> >> + * This routine is meant to function as either an inline or delayed o=
peration,
> >> + * and may return -EAGAIN when the transaction needs to be rolled.  C=
alling
> >> + * functions will need to handle this, and recall the function until a
> >> + * successful error code is returned.
> >>    */
> >>   STATIC int
> >> -xfs_attr_node_removename(
> >> -	struct xfs_da_args	*args)
> >> +xfs_attr_node_removename_iter(
> >> +	struct xfs_delattr_context	*dac)
> >>   {
> >> -	struct xfs_da_state	*state =3D NULL;
> >> -	int			retval, error;
> >> -	struct xfs_inode	*dp =3D args->dp;
> >> +	struct xfs_da_args		*args =3D dac->da_args;
> >> +	struct xfs_da_state		*state =3D NULL;
> >> +	int				retval, error;
> >> +	struct xfs_inode		*dp =3D args->dp;
> >>  =20
> >>   	trace_xfs_attr_node_removename(args);
> >>  =20
> >> -	error =3D xfs_attr_node_removename_setup(args, &state);
> >> -	if (error)
> >> -		goto out;
> >> +	if (!dac->da_state) {
> >> +		error =3D xfs_attr_node_removename_setup(dac);
> >> +		if (error)
> >> +			goto out;
> >> +	}
> >> +	state =3D dac->da_state;
> >>  =20
> >> -	error =3D xfs_attr_node_remove_step(args, state);
> >> -	if (error)
> >> -		goto out;
> >> +	switch (dac->dela_state) {
> >> +	case XFS_DAS_UNINIT:
> >> +		/*
> >> +		 * repeatedly remove remote blocks, remove the entry and join.
> >> +		 * returns -EAGAIN or 0 for completion of the step.
> >> +		 */
> >> +		error =3D xfs_attr_node_remove_step(dac);
> >> +		if (error)
> >> +			break;
> >>  =20
> >> -	retval =3D xfs_attr_node_remove_cleanup(args, state);
> >> +		retval =3D xfs_attr_node_remove_cleanup(args, state);
> >>  =20
> >> -	/*
> >> -	 * Check to see if the tree needs to be collapsed.
> >> -	 */
> >> -	if (retval && (state->path.active > 1)) {
> >> -		error =3D xfs_da3_join(state);
> >> -		if (error)
> >> -			return error;
> >> -		error =3D xfs_defer_finish(&args->trans);
> >> -		if (error)
> >> -			return error;
> >>   		/*
> >> -		 * Commit the Btree join operation and start a new trans.
> >> +		 * Check to see if the tree needs to be collapsed. Set the flag
> >> +		 * to indicate that the calling function needs to move the
> >> +		 * shrink operation
> >>   		 */
> >> -		error =3D xfs_trans_roll_inode(&args->trans, dp);
> >> -		if (error)
> >> -			return error;
> >> -	}
> >> +		if (retval && (state->path.active > 1)) {
> >> +			error =3D xfs_da3_join(state);
> >> +			if (error)
> >> +				return error;
> >>  =20
> >> -	/*
> >> -	 * If the result is small enough, push it all into the inode.
> >> -	 */
> >> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> >> -		error =3D xfs_attr_node_shrink(args, state);
> >> +			dac->flags |=3D XFS_DAC_DEFER_FINISH;
> >> +			dac->dela_state =3D XFS_DAS_RM_SHRINK;
> >> +			return -EAGAIN;
> >> +		}
> >> +
> >> +		/* fallthrough */
> >> +	case XFS_DAS_RM_SHRINK:
> >> +		/*
> >> +		 * If the result is small enough, push it all into the inode.
> >> +		 */
> >> +		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> >> +			error =3D xfs_attr_node_shrink(args, state);
> >> +
> >> +		break;
> >> +	default:
> >> +		ASSERT(0);
> >> +		error =3D -EINVAL;
> >> +		goto out;
> >> +	}
> >>  =20
> >> +	if (error =3D=3D -EAGAIN)
> >> +		return error;
> >>   out:
> >>   	if (state)
> >>   		xfs_da_state_free(state);
> >> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> >> index 3e97a93..3154ef4 100644
> >> --- a/fs/xfs/libxfs/xfs_attr.h
> >> +++ b/fs/xfs/libxfs/xfs_attr.h
> >> @@ -74,6 +74,102 @@ struct xfs_attr_list_context {
> >>   };
> >>  =20
> >>  =20
> >> +/*
> >> + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> + * Structure used to pass context around among the delayed routines.
> >> + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> + */
> >> +
> >> +/*
> >> + * Below is a state machine diagram for attr remove operations. The  =
XFS_DAS_*
> >> + * states indicate places where the function would return -EAGAIN, an=
d then
> >> + * immediately resume from after being recalled by the calling functi=
on. States
> >> + * marked as a "subroutine state" indicate that they belong to a subr=
outine, and
> >> + * so the calling function needs to pass them back to that subroutine=
 to allow
> >> + * it to finish where it left off. But they otherwise do not have a r=
ole in the
> >> + * calling function other than just passing through.
> >> + *
> >> + * xfs_attr_remove_iter()
> >> + *              =E2=94=82
> >> + *              v
> >> + *        found attr blks? =E2=94=80=E2=94=80=E2=94=80n=E2=94=80=E2=
=94=80=E2=94=90
> >> + *              =E2=94=82                v
> >> + *              =E2=94=82         find and invalidate
> >> + *              y         the blocks. mark
> >> + *              =E2=94=82         attr incomplete
> >> + *              =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> >> + *              =E2=94=82
> >> + *              v
> >> + *      remove a block with
> >> + *    xfs_attr_node_remove_step <=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=90
> >> + *              =E2=94=82                    =E2=94=82
> >> + *              v                    =E2=94=82
> >> + *      still have blks =E2=94=80=E2=94=80y=E2=94=80=E2=94=80> return=
 -EAGAIN.
> >> + *        to remove?          re-enter with one
> >> + *              =E2=94=82            less blk to remove
> >> + *              n
> >> + *              =E2=94=82
> >> + *              v
> >> + *       remove leaf and
> >> + *       update hash with
> >> + *   xfs_attr_node_remove_cleanup
> >> + *              =E2=94=82
> >> + *              v
> >> + *           need to
> >> + *        shrink tree? =E2=94=80n=E2=94=80=E2=94=90
> >> + *              =E2=94=82         =E2=94=82
> >> + *              y         =E2=94=82
> >> + *              =E2=94=82         =E2=94=82
> >> + *              v         =E2=94=82
> >> + *          join leaf     =E2=94=82
> >> + *              =E2=94=82         =E2=94=82
> >> + *              v         =E2=94=82
> >> + *      XFS_DAS_RM_SHRINK =E2=94=82
> >> + *              =E2=94=82         =E2=94=82
> >> + *              v         =E2=94=82
> >> + *       do the shrink    =E2=94=82
> >> + *              =E2=94=82         =E2=94=82
> >> + *              v         =E2=94=82
> >> + *          free state <=E2=94=80=E2=94=80=E2=94=98
> >> + *              =E2=94=82
> >> + *              v
> >> + *            done
> >> + *
> >> + */
> >> +
> >> +/*
> >> + * Enum values for xfs_delattr_context.da_state
> >> + *
> >> + * These values are used by delayed attribute operations to keep trac=
k  of where
> >> + * they were before they returned -EAGAIN.  A return code of -EAGAIN =
signals the
> >> + * calling function to roll the transaction, and then recall the subr=
outine to
> >> + * finish the operation.  The enum is then used by the subroutine to =
jump back
> >> + * to where it was and resume executing where it left off.
> >> + */
> >> +enum xfs_delattr_state {
> >> +	XFS_DAS_UNINIT		=3D 0,  /* No state has been set yet */
> >> +	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
> >> +};
> >> +
> >> +/*
> >> + * Defines for xfs_delattr_context.flags
> >> + */
> >> +#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
> >> +
> >> +/*
> >> + * Context used for keeping track of delayed attribute operations
> >> + */
> >> +struct xfs_delattr_context {
> >> +	struct xfs_da_args      *da_args;
> >> +
> >> +	/* Used in xfs_attr_node_removename to roll through removing blocks =
*/
> >> +	struct xfs_da_state     *da_state;
> >> +
> >> +	/* Used to keep track of current state of delayed operation */
> >> +	unsigned int            flags;
> >> +	enum xfs_delattr_state  dela_state;
> >> +};
> >> +
> >>   /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>    * Function prototypes for the kernel.
> >>    *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
*/
> >> @@ -91,6 +187,10 @@ int xfs_attr_set(struct xfs_da_args *args);
> >>   int xfs_attr_set_args(struct xfs_da_args *args);
> >>   int xfs_has_attr(struct xfs_da_args *args);
> >>   int xfs_attr_remove_args(struct xfs_da_args *args);
> >> +int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
> >> +int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
> >>   bool xfs_attr_namecheck(const void *name, size_t length);
> >> +void xfs_delattr_context_init(struct xfs_delattr_context *dac,
> >> +			      struct xfs_da_args *args);
> >>  =20
> >>   #endif	/* __XFS_ATTR_H__ */
> >> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_le=
af.c
> >> index d6ef69a..3780141 100644
> >> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> >> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> >> @@ -19,8 +19,8 @@
> >>   #include "xfs_bmap_btree.h"
> >>   #include "xfs_bmap.h"
> >>   #include "xfs_attr_sf.h"
> >> -#include "xfs_attr_remote.h"
> >>   #include "xfs_attr.h"
> >> +#include "xfs_attr_remote.h"
> >>   #include "xfs_attr_leaf.h"
> >>   #include "xfs_error.h"
> >>   #include "xfs_trace.h"
> >> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_=
remote.c
> >> index 48d8e9c..f09820c 100644
> >> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> >> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> >> @@ -674,10 +674,12 @@ xfs_attr_rmtval_invalidate(
> >>    */
> >>   int
> >>   xfs_attr_rmtval_remove(
> >> -	struct xfs_da_args      *args)
> >> +	struct xfs_da_args		*args)
> >>   {
> >> -	int			error;
> >> -	int			retval;
> >> +	int				error;
> >> +	struct xfs_delattr_context	dac  =3D {
> >> +		.da_args	=3D args,
> >> +	};
> >>  =20
> >>   	trace_xfs_attr_rmtval_remove(args);
> >>  =20
> >> @@ -685,31 +687,29 @@ xfs_attr_rmtval_remove(
> >>   	 * Keep de-allocating extents until the remote-value region is gone.
> >>   	 */
> >>   	do {
> >> -		retval =3D __xfs_attr_rmtval_remove(args);
> >> -		if (retval && retval !=3D -EAGAIN)
> >> -			return retval;
> >> +		error =3D __xfs_attr_rmtval_remove(&dac);
> >> +		if (error !=3D -EAGAIN)
> >> +			break;
> >>  =20
> >> -		/*
> >> -		 * Close out trans and start the next one in the chain.
> >> -		 */
> >> -		error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> >> +		error =3D xfs_attr_trans_roll(&dac);
> >>   		if (error)
> >>   			return error;
> >> -	} while (retval =3D=3D -EAGAIN);
> >> +	} while (true);
> >>  =20
> >> -	return 0;
> >> +	return error;
> >>   }
> >>  =20
> >>   /*
> >>    * Remove the value associated with an attribute by deleting the out=
=2Dof-line
> >> - * buffer that it is stored on. Returns EAGAIN for the caller to refr=
esh the
> >> + * buffer that it is stored on. Returns -EAGAIN for the caller to ref=
resh the
> >>    * transaction and re-call the function
> >>    */
> >>   int
> >>   __xfs_attr_rmtval_remove(
> >> -	struct xfs_da_args	*args)
> >> +	struct xfs_delattr_context	*dac)
> >>   {
> >> -	int			error, done;
> >> +	struct xfs_da_args		*args =3D dac->da_args;
> >> +	int				error, done;
> >>  =20
> >>   	/*
> >>   	 * Unmap value blocks for this attr.
> >> @@ -719,12 +719,20 @@ __xfs_attr_rmtval_remove(
> >>   	if (error)
> >>   		return error;
> >>  =20
> >> -	error =3D xfs_defer_finish(&args->trans);
> >> -	if (error)
> >> -		return error;
> >> -
> >> -	if (!done)
> >> +	/*
> >> +	 * We dont need an explicit state here to pick up where we left off.=
  We
> >> +	 * can figure it out using the !done return code.  Calling function =
only
> >> +	 * needs to keep recalling this routine until we indicate to stop by
> >> +	 * returning anything other than -EAGAIN. The actual value of
> >> +	 * attr->xattri_dela_state may be some value reminicent of the calli=
ng
> >> +	 * function, but it's value is irrelevant with in the context of this
> >> +	 * function.  Once we are done here, the next state is set as needed
> >> +	 * by the parent
> >> +	 */
> >> +	if (!done) {
> >> +		dac->flags |=3D XFS_DAC_DEFER_FINISH;
> >>   		return -EAGAIN;
> >> +	}
> >>  =20
> >>   	return error;
> >>   }
> >> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_=
remote.h
> >> index 9eee615..002fd30 100644
> >> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> >> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> >> @@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
> >>   int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec=
 *map,
> >>   		xfs_buf_flags_t incore_flags);
> >>   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> >> -int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
> >> +int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
> >>   #endif /* __XFS_ATTR_REMOTE_H__ */
> >> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> >> index bfad669..aaa7e66 100644
> >> --- a/fs/xfs/xfs_attr_inactive.c
> >> +++ b/fs/xfs/xfs_attr_inactive.c
> >> @@ -15,10 +15,10 @@
> >>   #include "xfs_da_format.h"
> >>   #include "xfs_da_btree.h"
> >>   #include "xfs_inode.h"
> >> +#include "xfs_attr.h"
> >>   #include "xfs_attr_remote.h"
> >>   #include "xfs_trans.h"
> >>   #include "xfs_bmap.h"
> >> -#include "xfs_attr.h"
> >>   #include "xfs_attr_leaf.h"
> >>   #include "xfs_quota.h"
> >>   #include "xfs_dir2.h"
> >>
> >=20
> >=20
>=20


=2D-=20
chandan




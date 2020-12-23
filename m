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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F17D3C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Dec 2020 08:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ECF6207A5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Dec 2020 08:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbgLWIAu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Dec 2020 03:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbgLWIAt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Dec 2020 03:00:49 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6293DC0613D3
        for <linux-xfs@vger.kernel.org>; Wed, 23 Dec 2020 00:00:09 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id c22so10102100pgg.13
        for <linux-xfs@vger.kernel.org>; Wed, 23 Dec 2020 00:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=40n3tghMmvr1fBWSVjH1P6kFgiB1mKLxSsV8XRDukOE=;
        b=kXB6yT7rbekPAzB1Lo47Do6DQfgmf8RJb0iyL6aD1yUzCNBnl2JQ8R+WqJuW7B+fka
         JrWuUFpOxs8WViefISVRVmQt/UigRFv/6S0HuwniesYbv+bPxQnnaqC8ThKJIlDB1jUv
         q4zUO/7NNB5c2f3L38gUj29ZJ3ORs7TfAMN1Osjij5Tbdhl3c7mYmZntnEBbgDSPGUj/
         i63dYKeZawRCKSR1dYj45NOpKKh/UBc7y9LTyV4AzRG+K4C+xtxVD9mqS/sQYNYSbrtE
         dlA719H3TV7Q9JHdYnWe3yLVJ6hnaZyZHWm316FwyunMKKC4z0DvhoMhjjHdebjPa+Kw
         6C/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=40n3tghMmvr1fBWSVjH1P6kFgiB1mKLxSsV8XRDukOE=;
        b=WUNWxlb6G31aXphbSMvfYe1dDiNef9P9/pjmTSIsCWGryWN9Uz0QYcai6OcVTeF3KU
         dAKR8eFw0FjmuK7hc40wSYiiaPegMQABKVAZTgn+EG+RRn7ijkFB7zHamMm1l1+s6HuL
         QKNn2EBQtXUvR6fUY2KFlV/gcohwcJdoTSGbGDtzFTOR/aFU+htZyLxtNj30uW+OP32v
         cyiR23nYqbmpCXUVbf/eFVq9RrLzDnQFTo8+uiCU2Ueo8PxqHKru3GvA4nbcDk7ouguV
         cXgGCb9fwJjimkova4ZKG1/N9knWw6OCoT3EB28MPdy7aFjZblxVfgvpb/ODPyjh0t0C
         b0GQ==
X-Gm-Message-State: AOAM5323CEDwAjd4CSycCLFbagVfQnYd96T4n6WO84ah8AHMKWsRlvk5
        rciMTCrMPaWQWR94n36gBWvbzfPtKdA=
X-Google-Smtp-Source: ABdhPJyiPF7dt61yU8ebpV/smT+eIV4ZD0CHzbwgBvD8KytX2avNcyo9NLDNE+/vr0V2II+mHxHlzg==
X-Received: by 2002:a63:d903:: with SMTP id r3mr23183913pgg.445.1608710408552;
        Wed, 23 Dec 2020 00:00:08 -0800 (PST)
Received: from garuda.localnet ([122.171.58.160])
        by smtp.gmail.com with ESMTPSA id 193sm22627399pfz.36.2020.12.23.00.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 00:00:07 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v14 05/15] xfs: Add delay ready attr set routines
Date:   Wed, 23 Dec 2020 13:30:05 +0530
Message-ID: <14114612.x9Zgue1qBj@garuda>
In-Reply-To: <20201218072917.16805-6-allison.henderson@oracle.com>
References: <20201218072917.16805-1-allison.henderson@oracle.com> <20201218072917.16805-6-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 18 Dec 2020 00:29:07 -0700, Allison Henderson wrote:
> This patch modifies the attr set routines to be delay ready. This means
> they no longer roll or commit transactions, but instead return -EAGAIN
> to have the calling routine roll and refresh the transaction.  In this
> series, xfs_attr_set_args has become xfs_attr_set_iter, which uses a
> state machine like switch to keep track of where it was when EAGAIN was
> returned. See xfs_attr.h for a more detailed diagram of the states.
>=20
> Two new helper functions have been added: xfs_attr_rmtval_set_init and

I don't see xfs_attr_rmtval_set_init() being added in this patch. Maybe it
needs to be removed from the description.

> xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
> xfs_attr_rmtval_set, but they store the current block in the delay attr
> context to allow the caller to roll the transaction between allocations.
> This helps to simplify and consolidate code used by
> xfs_attr_leaf_addname and xfs_attr_node_addname. xfs_attr_set_args has
> now become a simple loop to refresh the transaction until the operation
> is completed.  Lastly, xfs_attr_rmtval_remove is no longer used, and is
> removed.
>=20
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        | 357 ++++++++++++++++++++++++++--------=
=2D-----
>  fs/xfs/libxfs/xfs_attr.h        | 235 +++++++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_attr_remote.c |  98 +++++++----
>  fs/xfs/libxfs/xfs_attr_remote.h |   5 +-
>  fs/xfs/xfs_trace.h              |   1 -
>  5 files changed, 541 insertions(+), 155 deletions(-)
>=20
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index b6330f9..cd72512 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -44,7 +44,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *ar=
gs);
>   * Internal routines when attribute list is one block.
>   */
>  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
> -STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
> +STATIC int xfs_attr_leaf_addname(struct xfs_delattr_context *dac);
>  STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_bu=
f **bp);
> =20
> @@ -52,12 +52,15 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *=
args, struct xfs_buf **bp);
>   * Internal routines when attribute list is more than one block.
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> -STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> +STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
>  STATIC int xfs_attr_node_removename_iter(struct xfs_delattr_context *dac=
);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_bu=
f *bp);
> +STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
> +			     struct xfs_buf **leaf_bp);
> =20
>  int
>  xfs_inode_hasattr(
> @@ -218,8 +221,11 @@ xfs_attr_is_shortform(
> =20
>  /*
>   * Attempts to set an attr in shortform, or converts short form to leaf =
form if
> - * there is not enough room.  If the attr is set, the transaction is com=
mitted
> - * and set to NULL.
> + * there is not enough room.  This function is meant to operate as a hel=
per
> + * routine to the delayed attribute functions.  It returns -EAGAIN to in=
dicate
> + * that the calling function should roll the transaction, and then proce=
ed to
> + * add the attr in leaf form.  This subroutine does not expect to be rec=
alled
> + * again like the other delayed attr routines do.
>   */
>  STATIC int
>  xfs_attr_set_shortform(
> @@ -227,16 +233,16 @@ xfs_attr_set_shortform(
>  	struct xfs_buf		**leaf_bp)
>  {
>  	struct xfs_inode	*dp =3D args->dp;
> -	int			error, error2 =3D 0;
> +	int			error =3D 0;
> =20
>  	/*
>  	 * Try to add the attr to the attribute list in the inode.
>  	 */
>  	error =3D xfs_attr_try_sf_addname(dp, args);
> +
> +	/* Should only be 0, -EEXIST or -ENOSPC */
>  	if (error !=3D -ENOSPC) {
> -		error2 =3D xfs_trans_commit(args->trans);
> -		args->trans =3D NULL;
> -		return error ? error : error2;
> +		return error;
>  	}
>  	/*
>  	 * It won't fit in the shortform, transform to a leaf block.  GROT:
> @@ -249,18 +255,15 @@ xfs_attr_set_shortform(
>  	/*
>  	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
>  	 * push cannot grab the half-baked leaf buffer and run into problems
> -	 * with the write verifier. Once we're done rolling the transaction we
> -	 * can release the hold and add the attr to the leaf.
> +	 * with the write verifier.
>  	 */
>  	xfs_trans_bhold(args->trans, *leaf_bp);
> -	error =3D xfs_defer_finish(&args->trans);
> -	xfs_trans_bhold_release(args->trans, *leaf_bp);
> -	if (error) {
> -		xfs_trans_brelse(args->trans, *leaf_bp);
> -		return error;
> -	}
> =20
> -	return 0;
> +	/*
> +	 * We're still in XFS_DAS_UNINIT state here.  We've converted the attr
> +	 * fork to leaf format and will restart with the leaf add.
> +	 */
> +	return -EAGAIN;
>  }
> =20
>  /*
> @@ -268,7 +271,7 @@ xfs_attr_set_shortform(
>   * also checks for a defer finish.  Transaction is finished and rolled as
>   * needed, and returns true of false if the delayed operation should con=
tinue.
>   */
> -int
> +STATIC int
>  xfs_attr_trans_roll(
>  	struct xfs_delattr_context	*dac)
>  {
> @@ -298,34 +301,95 @@ int
>  xfs_attr_set_args(
>  	struct xfs_da_args	*args)
>  {
> -	struct xfs_inode	*dp =3D args->dp;
> -	struct xfs_buf          *leaf_bp =3D NULL;
> -	int			error =3D 0;
> +	struct xfs_buf			*leaf_bp =3D NULL;
> +	int				error =3D 0;
> +	struct xfs_delattr_context	dac =3D {
> +		.da_args	=3D args,
> +	};
> +
> +	do {
> +		error =3D xfs_attr_set_iter(&dac, &leaf_bp);
> +		if (error !=3D -EAGAIN)
> +			break;
> +
> +		error =3D xfs_attr_trans_roll(&dac);
> +		if (error)
> +			return error;
> +	} while (true);
> +
> +	return error;
> +}
> +
> +/*
> + * Set the attribute specified in @args.
> + * This routine is meant to function as a delayed operation, and may ret=
urn
> + * -EAGAIN when the transaction needs to be rolled.  Calling functions w=
ill need
> + * to handle this, and recall the function until a successful error code=
 is
> + * returned.
> + */
> +STATIC int
> +xfs_attr_set_iter(
> +	struct xfs_delattr_context	*dac,
> +	struct xfs_buf			**leaf_bp)
> +{
> +	struct xfs_da_args		*args =3D dac->da_args;
> +	struct xfs_inode		*dp =3D args->dp;
> +	int				error =3D 0;
> +
> +	/* State machine switch */
> +	switch (dac->dela_state) {
> +	case XFS_DAS_FLIP_LFLAG:
> +	case XFS_DAS_FOUND_LBLK:
> +	case XFS_DAS_RM_LBLK:
> +		return xfs_attr_leaf_addname(dac);
> +	case XFS_DAS_FOUND_NBLK:
> +	case XFS_DAS_FLIP_NFLAG:
> +	case XFS_DAS_ALLOC_NODE:
> +		return xfs_attr_node_addname(dac);
> +	case XFS_DAS_UNINIT:
> +		break;
> +	default:
> +		ASSERT(dac->dela_state !=3D XFS_DAS_RM_SHRINK);
> +		break;
> +	}
> =20
>  	/*
>  	 * If the attribute list is already in leaf format, jump straight to
>  	 * leaf handling.  Otherwise, try to add the attribute to the shortform
>  	 * list; if there's no room then convert the list to leaf format and try
> -	 * again.
> +	 * again. No need to set state as we will be in leaf form when we come
> +	 * back
>  	 */
>  	if (xfs_attr_is_shortform(dp)) {
> =20
>  		/*
> -		 * If the attr was successfully set in shortform, the
> -		 * transaction is committed and set to NULL.  Otherwise, is it
> -		 * converted from shortform to leaf, and the transaction is
> -		 * retained.
> +		 * If the attr was successfully set in shortform, no need to
> +		 * continue.  Otherwise, is it converted from shortform to leaf
> +		 * and -EAGAIN is returned.
>  		 */
> -		error =3D xfs_attr_set_shortform(args, &leaf_bp);
> -		if (error || !args->trans)
> -			return error;
> +		error =3D xfs_attr_set_shortform(args, leaf_bp);
> +		if (error =3D=3D -EAGAIN)
> +			dac->flags |=3D XFS_DAC_DEFER_FINISH;
> +
> +		return error;
>  	}
> =20
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -		error =3D xfs_attr_leaf_addname(args);
> -		if (error !=3D -ENOSPC)
> -			return error;
> +	/*
> +	 * After a shortform to leaf conversion, we need to hold the leaf and
> +	 * cycle out the transaction.  When we get back, we need to release
> +	 * the leaf to release the hold on the leaf buffer.
> +	 */
> +	if (*leaf_bp !=3D NULL) {
> +		xfs_trans_bhold_release(args->trans, *leaf_bp);
> +		*leaf_bp =3D NULL;
> +	}
> +
> +	if (!xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +		return xfs_attr_node_addname(dac);
> =20
> +	error =3D xfs_attr_leaf_try_add(args, *leaf_bp);
> +	switch (error) {
> +	case -ENOSPC:
>  		/*
>  		 * Promote the attribute list to the Btree format.
>  		 */
> @@ -334,25 +398,22 @@ xfs_attr_set_args(
>  			return error;
> =20
>  		/*
> -		 * Finish any deferred work items and roll the transaction once
> -		 * more.  The goal here is to call node_addname with the inode
> -		 * and transaction in the same state (inode locked and joined,
> -		 * transaction clean) no matter how we got to this step.
> -		 */
> -		error =3D xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> -
> -		/*
> -		 * Commit the current trans (including the inode) and
> -		 * start a new one.
> +		 * Finish any deferred work items and roll the
> +		 * transaction once more.  The goal here is to call
> +		 * node_addname with the inode and transaction in the
> +		 * same state (inode locked and joined, transaction
> +		 * clean) no matter how we got to this step.
> +		 *
> +		 * At this point, we are still in XFS_DAS_UNINIT, but
> +		 * when we come back, we'll be a node, so we'll fall
> +		 * down into the node handling code below

 ... node handling code above?.

Apart from the above nits I don't see any issues w.r.t the logical correctn=
ess
of the code. Hence,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

>  		 */
> -		error =3D xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			return error;
> +		dac->flags |=3D XFS_DAC_DEFER_FINISH;
> +		return -EAGAIN;
> +	case 0:
> +		dac->dela_state =3D XFS_DAS_FOUND_LBLK;
> +		return -EAGAIN;
>  	}
> -
> -	error =3D xfs_attr_node_addname(args);
>  	return error;
>  }
> =20
> @@ -728,28 +789,30 @@ xfs_attr_leaf_try_add(
>   *
>   * This leaf block cannot have a "remote" value, we only call this routi=
ne
>   * if bmap_one_block() says there is only one block (ie: no remote blks).
> + *
> + * This routine is meant to function as a delayed operation, and may ret=
urn
> + * -EAGAIN when the transaction needs to be rolled.  Calling functions w=
ill need
> + * to handle this, and recall the function until a successful error code=
 is
> + * returned.
>   */
>  STATIC int
>  xfs_attr_leaf_addname(
> -	struct xfs_da_args	*args)
> +	struct xfs_delattr_context	*dac)
>  {
> -	int			error, forkoff;
> -	struct xfs_buf		*bp =3D NULL;
> -	struct xfs_inode	*dp =3D args->dp;
> -
> -	trace_xfs_attr_leaf_addname(args);
> -
> -	error =3D xfs_attr_leaf_try_add(args, bp);
> -	if (error)
> -		return error;
> +	struct xfs_da_args		*args =3D dac->da_args;
> +	struct xfs_buf			*bp =3D NULL;
> +	int				error, forkoff;
> +	struct xfs_inode		*dp =3D args->dp;
> =20
> -	/*
> -	 * Commit the transaction that added the attr name so that
> -	 * later routines can manage their own transactions.
> -	 */
> -	error =3D xfs_trans_roll_inode(&args->trans, dp);
> -	if (error)
> -		return error;
> +	/* State machine switch */
> +	switch (dac->dela_state) {
> +	case XFS_DAS_FLIP_LFLAG:
> +		goto das_flip_flag;
> +	case XFS_DAS_RM_LBLK:
> +		goto das_rm_lblk;
> +	default:
> +		break;
> +	}
> =20
>  	/*
>  	 * If there was an out-of-line value, allocate the blocks we
> @@ -757,12 +820,34 @@ xfs_attr_leaf_addname(
>  	 * after we create the attribute so that we don't overflow the
>  	 * maximum size of a transaction and/or hit a deadlock.
>  	 */
> -	if (args->rmtblkno > 0) {
> -		error =3D xfs_attr_rmtval_set(args);
> +
> +	/* Open coded xfs_attr_rmtval_set without trans handling */
> +	if ((dac->flags & XFS_DAC_LEAF_ADDNAME_INIT) =3D=3D 0) {
> +		dac->flags |=3D XFS_DAC_LEAF_ADDNAME_INIT;
> +		if (args->rmtblkno > 0) {
> +			error =3D xfs_attr_rmtval_find_space(dac);
> +			if (error)
> +				return error;
> +		}
> +	}
> +
> +	/*
> +	 * Roll through the "value", allocating blocks on disk as
> +	 * required.
> +	 */
> +	if (dac->blkcnt > 0) {
> +		error =3D xfs_attr_rmtval_set_blk(dac);
>  		if (error)
>  			return error;
> +
> +		dac->flags |=3D XFS_DAC_DEFER_FINISH;
> +		return -EAGAIN;
>  	}
> =20
> +	error =3D xfs_attr_rmtval_set_value(args);
> +	if (error)
> +		return error;
> +
>  	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>  		/*
>  		 * Added a "remote" value, just clear the incomplete flag.
> @@ -782,29 +867,30 @@ xfs_attr_leaf_addname(
>  	 * In a separate transaction, set the incomplete flag on the "old" attr
>  	 * and clear the incomplete flag on the "new" attr.
>  	 */
> -
>  	error =3D xfs_attr3_leaf_flipflags(args);
>  	if (error)
>  		return error;
>  	/*
>  	 * Commit the flag value change and start the next trans in series.
>  	 */
> -	error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> -	if (error)
> -		return error;
> -
> +	dac->dela_state =3D XFS_DAS_FLIP_LFLAG;
> +	return -EAGAIN;
> +das_flip_flag:
>  	/*
>  	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>  	 * (if it exists).
>  	 */
>  	xfs_attr_restore_rmt_blk(args);
> =20
> -	if (args->rmtblkno) {
> -		error =3D xfs_attr_rmtval_invalidate(args);
> -		if (error)
> -			return error;
> +	error =3D xfs_attr_rmtval_invalidate(args);
> +	if (error)
> +		return error;
> =20
> -		error =3D xfs_attr_rmtval_remove(args);
> +	/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
> +	dac->dela_state =3D XFS_DAS_RM_LBLK;
> +das_rm_lblk:
> +	if (args->rmtblkno) {
> +		error =3D __xfs_attr_rmtval_remove(dac);
>  		if (error)
>  			return error;
>  	}
> @@ -970,23 +1056,38 @@ xfs_attr_node_hasname(
>   *
>   * "Remote" attribute values confuse the issue and atomic rename operati=
ons
>   * add a whole extra layer of confusion on top of that.
> + *
> + * This routine is meant to function as a delayed operation, and may ret=
urn
> + * -EAGAIN when the transaction needs to be rolled.  Calling functions w=
ill need
> + * to handle this, and recall the function until a successful error code=
 is
> + *returned.
>   */
>  STATIC int
>  xfs_attr_node_addname(
> -	struct xfs_da_args	*args)
> +	struct xfs_delattr_context	*dac)
>  {
> -	struct xfs_da_state	*state;
> -	struct xfs_da_state_blk	*blk;
> -	struct xfs_inode	*dp;
> -	int			retval, error;
> +	struct xfs_da_args		*args =3D dac->da_args;
> +	struct xfs_da_state		*state =3D NULL;
> +	struct xfs_da_state_blk		*blk;
> +	int				retval =3D 0;
> +	int				error =3D 0;
> =20
>  	trace_xfs_attr_node_addname(args);
> =20
> -	/*
> -	 * Fill in bucket of arguments/results/context to carry around.
> -	 */
> -	dp =3D args->dp;
> -restart:
> +	/* State machine switch */
> +	switch (dac->dela_state) {
> +	case XFS_DAS_FLIP_NFLAG:
> +		goto das_flip_flag;
> +	case XFS_DAS_FOUND_NBLK:
> +		goto das_found_nblk;
> +	case XFS_DAS_ALLOC_NODE:
> +		goto das_alloc_node;
> +	case XFS_DAS_RM_NBLK:
> +		goto das_rm_nblk;
> +	default:
> +		break;
> +	}
> +
>  	/*
>  	 * Search to see if name already exists, and get back a pointer
>  	 * to where it should go.
> @@ -1032,19 +1133,16 @@ xfs_attr_node_addname(
>  			error =3D xfs_attr3_leaf_to_node(args);
>  			if (error)
>  				goto out;
> -			error =3D xfs_defer_finish(&args->trans);
> -			if (error)
> -				goto out;
> =20
>  			/*
> -			 * Commit the node conversion and start the next
> -			 * trans in the chain.
> +			 * Now that we have converted the leaf to a node, we can
> +			 * roll the transaction, and try xfs_attr3_leaf_add
> +			 * again on re-entry.  No need to set dela_state to do
> +			 * this. dela_state is still unset by this function at
> +			 * this point.
>  			 */
> -			error =3D xfs_trans_roll_inode(&args->trans, dp);
> -			if (error)
> -				goto out;
> -
> -			goto restart;
> +			dac->flags |=3D XFS_DAC_DEFER_FINISH;
> +			return -EAGAIN;
>  		}
> =20
>  		/*
> @@ -1056,9 +1154,7 @@ xfs_attr_node_addname(
>  		error =3D xfs_da3_split(state);
>  		if (error)
>  			goto out;
> -		error =3D xfs_defer_finish(&args->trans);
> -		if (error)
> -			goto out;
> +		dac->flags |=3D XFS_DAC_DEFER_FINISH;
>  	} else {
>  		/*
>  		 * Addition succeeded, update Btree hashvals.
> @@ -1066,6 +1162,11 @@ xfs_attr_node_addname(
>  		xfs_da3_fixhashpath(state, &state->path);
>  	}
> =20
> +	if (!args->rmtblkno && !(args->op_flags & XFS_DA_OP_RENAME)) {
> +		retval =3D error;
> +		goto out;
> +	}
> +
>  	/*
>  	 * Kill the state structure, we're done with it and need to
>  	 * allow the buffers to come back later.
> @@ -1073,13 +1174,9 @@ xfs_attr_node_addname(
>  	xfs_da_state_free(state);
>  	state =3D NULL;
> =20
> -	/*
> -	 * Commit the leaf addition or btree split and start the next
> -	 * trans in the chain.
> -	 */
> -	error =3D xfs_trans_roll_inode(&args->trans, dp);
> -	if (error)
> -		goto out;
> +	dac->dela_state =3D XFS_DAS_FOUND_NBLK;
> +	return -EAGAIN;
> +das_found_nblk:
> =20
>  	/*
>  	 * If there was an out-of-line value, allocate the blocks we
> @@ -1088,7 +1185,27 @@ xfs_attr_node_addname(
>  	 * maximum size of a transaction and/or hit a deadlock.
>  	 */
>  	if (args->rmtblkno > 0) {
> -		error =3D xfs_attr_rmtval_set(args);
> +		/* Open coded xfs_attr_rmtval_set without trans handling */
> +		error =3D xfs_attr_rmtval_find_space(dac);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * Roll through the "value", allocating blocks on disk as
> +		 * required.  Set the state in case of -EAGAIN return code
> +		 */
> +		dac->dela_state =3D XFS_DAS_ALLOC_NODE;
> +das_alloc_node:
> +		if (dac->blkcnt > 0) {
> +			error =3D xfs_attr_rmtval_set_blk(dac);
> +			if (error)
> +				return error;
> +
> +			dac->flags |=3D XFS_DAC_DEFER_FINISH;
> +			return -EAGAIN;
> +		}
> +
> +		error =3D xfs_attr_rmtval_set_value(args);
>  		if (error)
>  			return error;
>  	}
> @@ -1118,22 +1235,24 @@ xfs_attr_node_addname(
>  	/*
>  	 * Commit the flag value change and start the next trans in series
>  	 */
> -	error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> -	if (error)
> -		goto out;
> -
> +	dac->dela_state =3D XFS_DAS_FLIP_NFLAG;
> +	return -EAGAIN;
> +das_flip_flag:
>  	/*
>  	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>  	 * (if it exists).
>  	 */
>  	xfs_attr_restore_rmt_blk(args);
> =20
> -	if (args->rmtblkno) {
> -		error =3D xfs_attr_rmtval_invalidate(args);
> -		if (error)
> -			return error;
> +	error =3D xfs_attr_rmtval_invalidate(args);
> +	if (error)
> +		return error;
> =20
> -		error =3D xfs_attr_rmtval_remove(args);
> +	/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
> +	dac->dela_state =3D XFS_DAS_RM_NBLK;
> +das_rm_nblk:
> +	if (args->rmtblkno) {
> +		error =3D __xfs_attr_rmtval_remove(dac);
>  		if (error)
>  			return error;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 3154ef4..e101238 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -135,6 +135,227 @@ struct xfs_attr_list_context {
>   *              v
>   *            done
>   *
> + *
> + * Below is a state machine diagram for attr set operations.
> + *
> + * It seems the challenge with undertanding this system comes from tryin=
g to
> + * absorb the state machine all at once, when really one should only be =
looking
> + * at it with in the context of a single function.  Once a state sensiti=
ve
> + * function is called, the idea is that it "takes ownership" of the
> + * statemachine. It isn't concerned with the states that may have belong=
ed to
> + * it's calling parent.  Only the states relevant to itself or any other
> + * subroutines there in.  Once a calling function hands off the statemac=
hine to
> + * a subroutine, it needs to respect the simple rule that it doesn't "ow=
n" the
> + * statemachine anymore, and it's the responsibility of that calling fun=
ction to
> + * propagate the -EAGAIN back up the call stack.  Upon reentry, it is co=
mmitted
> + * to re-calling that subroutine until it returns something other than -=
EAGAIN.
> + * Once that subroutine signals completion (by returning anything other =
than
> + * -EAGAIN), the calling function can resume using the statemachine.
> + *
> + *  xfs_attr_set_iter()
> + *              =E2=94=82
> + *              v
> + *   =E2=94=8C=E2=94=80y=E2=94=80 has an attr fork?
> + *   =E2=94=82          |
> + *   =E2=94=82          n
> + *   =E2=94=82          |
> + *   =E2=94=82          V
> + *   =E2=94=82       add a fork
> + *   =E2=94=82          =E2=94=82
> + *   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
> + *              =E2=94=82
> + *              V
> + *   =E2=94=8C=E2=94=80n=E2=94=80=E2=94=80 is shortform?
> + *   =E2=94=82          |
> + *   =E2=94=82          y
> + *   =E2=94=82          |
> + *   =E2=94=82          V
> + *   =E2=94=82 xfs_attr_set_shortform
> + *   =E2=94=82          |
> + *   =E2=94=82          V
> + *   =E2=94=82      had enough =E2=94=80=E2=94=80y=E2=94=80=E2=94=80> do=
ne
> + *   =E2=94=82        space?
> + *   =E2=94=82          =E2=94=82
> + *   =E2=94=82          n
> + *   =E2=94=82          =E2=94=82
> + *   =E2=94=82          V
> + *   =E2=94=82     return -EAGAIN
> + *   =E2=94=82   Re-enter in leaf form
> + *   =E2=94=82          =E2=94=82
> + *   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
> + *              =E2=94=82
> + *              V
> + *       release leaf buffer
> + *          if needed
> + *              =E2=94=82
> + *              V
> + *   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80n=E2=94=80=E2=94=80 fork has
> + *   =E2=94=82      only 1 blk?
> + *   =E2=94=82          =E2=94=82
> + *   =E2=94=82          y
> + *   =E2=94=82          =E2=94=82
> + *   =E2=94=82          v
> + *   =E2=94=82 xfs_attr_leaf_try_add()
> + *   =E2=94=82                  =E2=94=82
> + *   =E2=94=82                  v
> + *   =E2=94=82              had enough
> + *   =E2=94=82       =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80n=E2=
=94=80=E2=94=80 space?
> + *   =E2=94=82       =E2=94=82          =E2=94=82
> + *   =E2=94=82       v          =E2=94=82
> + *   =E2=94=82 return -EAGAIN   =E2=94=82
> + *   =E2=94=82  re-enter in     y
> + *   =E2=94=82   node form      =E2=94=82
> + *   =E2=94=82       =E2=94=82          =E2=94=82
> + *   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=98          =E2=94=82
> + *   =E2=94=82                  v
> + *   =E2=94=82  XFS_DAS_FOUND_LBLK =E2=94=80=E2=94=80=E2=94=90
> + *   =E2=94=82                       =E2=94=82
> + *   =E2=94=82  XFS_DAS_FLIP_LFLAG =E2=94=80=E2=94=80=E2=94=A4
> + *   =E2=94=82  (subroutine state)   =E2=94=82
> + *   =E2=94=82                       =E2=94=82
> + *   =E2=94=82                       =E2=94=94=E2=94=80>xfs_attr_leaf_ad=
dname()
> + *   =E2=94=82                                =E2=94=82
> + *   =E2=94=82                                v
> + *   =E2=94=82                     =E2=94=8C=E2=94=80=E2=94=80first time=
 through?
> + *   =E2=94=82                     =E2=94=82          =E2=94=82
> + *   =E2=94=82                     =E2=94=82          y
> + *   =E2=94=82                     =E2=94=82          =E2=94=82
> + *   =E2=94=82                     n          v
> + *   =E2=94=82                     =E2=94=82    if we have rmt blks
> + *   =E2=94=82                     =E2=94=82    find space for them
> + *   =E2=94=82                     =E2=94=82          =E2=94=82
> + *   =E2=94=82                     =E2=94=94=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
> + *   =E2=94=82                                =E2=94=82
> + *   =E2=94=82                                v
> + *   =E2=94=82                           still have
> + *   =E2=94=82                     =E2=94=8C=E2=94=80n=E2=94=80 blks to =
alloc? <=E2=94=80=E2=94=80=E2=94=90
> + *   =E2=94=82                     =E2=94=82          =E2=94=82         =
  =E2=94=82
> + *   =E2=94=82                     =E2=94=82          y           =E2=94=
=82
> + *   =E2=94=82                     =E2=94=82          =E2=94=82         =
  =E2=94=82
> + *   =E2=94=82                     =E2=94=82          v           =E2=94=
=82
> + *   =E2=94=82                     =E2=94=82     alloc one blk    =E2=94=
=82
> + *   =E2=94=82                     =E2=94=82     return -EAGAIN =E2=94=
=80=E2=94=80=E2=94=98
> + *   =E2=94=82                     =E2=94=82    re-enter with one
> + *   =E2=94=82                     =E2=94=82    less blk to alloc
> + *   =E2=94=82                     =E2=94=82
> + *   =E2=94=82                     =E2=94=82
> + *   =E2=94=82                     =E2=94=94=E2=94=80=E2=94=80=E2=94=80>=
 set the rmt
> + *   =E2=94=82                              value
> + *   =E2=94=82                                =E2=94=82
> + *   =E2=94=82                                v
> + *   =E2=94=82                              was this
> + *   =E2=94=82                             a rename? =E2=94=80=E2=94=80n=
=E2=94=80=E2=94=90
> + *   =E2=94=82                                =E2=94=82          =E2=94=
=82
> + *   =E2=94=82                                y          =E2=94=82
> + *   =E2=94=82                                =E2=94=82          =E2=94=
=82
> + *   =E2=94=82                                v          =E2=94=82
> + *   =E2=94=82                          flip incomplete  =E2=94=82
> + *   =E2=94=82                              flag         =E2=94=82
> + *   =E2=94=82                                =E2=94=82          =E2=94=
=82
> + *   =E2=94=82                                v          =E2=94=82
> + *   =E2=94=82                        XFS_DAS_FLIP_LFLAG =E2=94=82
> + *   =E2=94=82                                =E2=94=82          =E2=94=
=82
> + *   =E2=94=82                                v          =E2=94=82
> + *   =E2=94=82                              remove       =E2=94=82
> + *   =E2=94=82          XFS_DAS_RM_LBLK =E2=94=80> old name      =E2=94=
=82
> + *   =E2=94=82                   ^            =E2=94=82          =E2=94=
=82
> + *   =E2=94=82                   =E2=94=82            v          =E2=94=
=82
> + *   =E2=94=82                   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80y=E2=94=80=E2=94=80 more to      =E2=94=82
> + *   =E2=94=82                              remove       =E2=94=82
> + *   =E2=94=82                                =E2=94=82          =E2=94=
=82
> + *   =E2=94=82                                n          =E2=94=82
> + *   =E2=94=82                                =E2=94=82          =E2=94=
=82
> + *   =E2=94=82                                v          =E2=94=82
> + *   =E2=94=82                               done <=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> + *   =E2=94=94=E2=94=80=E2=94=80> XFS_DAS_FOUND_NBLK =E2=94=80=E2=94=80=
=E2=94=90
> + *        (subroutine state)   =E2=94=82
> + *                             =E2=94=82
> + *        XFS_DAS_ALLOC_NODE =E2=94=80=E2=94=80=E2=94=A4
> + *        (subroutine state)   =E2=94=82
> + *                             =E2=94=82
> + *        XFS_DAS_FLIP_NFLAG =E2=94=80=E2=94=80=E2=94=A4
> + *        (subroutine state)   =E2=94=82
> + *                             =E2=94=82
> + *                             =E2=94=94=E2=94=80>xfs_attr_node_addname()
> + *                                     =E2=94=82
> + *                                     v
> + *                               determine if this
> + *                              is create or rename
> + *                            find space to store attr
> + *                                     =E2=94=82
> + *                                     v
> + *               =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80n=E2=94=80=E2=94=80=E2=94=80=E2=94=80 fits in a node leaf?
> + *               =E2=94=82               ^     =E2=94=82
> + *       single leaf node?       =E2=94=82     =E2=94=82
> + *         =E2=94=82            =E2=94=82        =E2=94=82     y
> + *         n            y        =E2=94=82     =E2=94=82
> + *         =E2=94=82            =E2=94=82        =E2=94=82     v
> + *         v            v        =E2=94=82   update
> + *     split if   grow the leaf =E2=94=80=E2=94=98  hashvals
> + *      needed     return -EAGAIN      =E2=94=82
> + *         =E2=94=82      retry leaf add       =E2=94=82
> + *         =E2=94=82        on reentry         =E2=94=82
> + *         =E2=94=82                           =E2=94=82
> + *         =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
> + *                                     v
> + *                                need to alloc =E2=94=80=E2=94=80n=E2=
=94=80=E2=94=80> done
> + *                                or flip flag?
> + *                                     =E2=94=82
> + *                                     y
> + *                                     =E2=94=82
> + *                                     v
> + *                             XFS_DAS_FOUND_NBLK
> + *                                     =E2=94=82
> + *                                     v
> + *                       =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80n=E2=94=80=E2=94=80  need to
> + *                       =E2=94=82        alloc blks?
> + *                       =E2=94=82             =E2=94=82
> + *                       =E2=94=82             y
> + *                       =E2=94=82             =E2=94=82
> + *                       =E2=94=82             v
> + *                       =E2=94=82        find space
> + *                       =E2=94=82             =E2=94=82
> + *                       =E2=94=82             v
> + *                       =E2=94=82  =E2=94=8C=E2=94=80>XFS_DAS_ALLOC_NODE
> + *                       =E2=94=82  =E2=94=82          =E2=94=82
> + *                       =E2=94=82  =E2=94=82          v
> + *                       =E2=94=82  =E2=94=82      alloc blk
> + *                       =E2=94=82  =E2=94=82          =E2=94=82
> + *                       =E2=94=82  =E2=94=82          v
> + *                       =E2=94=82  =E2=94=94=E2=94=80=E2=94=80y=E2=94=
=80=E2=94=80 need to alloc
> + *                       =E2=94=82         more blocks?
> + *                       =E2=94=82             =E2=94=82
> + *                       =E2=94=82             n
> + *                       =E2=94=82             =E2=94=82
> + *                       =E2=94=82             v
> + *                       =E2=94=82      set the rmt value
> + *                       =E2=94=82             =E2=94=82
> + *                       =E2=94=82             v
> + *                       =E2=94=82          was this
> + *                       =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80> a rename? =E2=94=80=E2=94=80n=E2=94=
=80=E2=94=90
> + *                                     =E2=94=82          =E2=94=82
> + *                                     y          =E2=94=82
> + *                                     =E2=94=82          =E2=94=82
> + *                                     v          =E2=94=82
> + *                               flip incomplete  =E2=94=82
> + *                                   flag         =E2=94=82
> + *                                     =E2=94=82          =E2=94=82
> + *                                     v          =E2=94=82
> + *                             XFS_DAS_FLIP_NFLAG =E2=94=82
> + *                                     =E2=94=82          =E2=94=82
> + *                                     v          =E2=94=82
> + *                                   remove       =E2=94=82
> + *               XFS_DAS_RM_NBLK =E2=94=80> old name      =E2=94=82
> + *                        ^            =E2=94=82          =E2=94=82
> + *                        =E2=94=82            v          =E2=94=82
> + *                        =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80y=E2=94=80=E2=94=80 more to      =E2=94=82
> + *                                   remove       =E2=94=82
> + *                                     =E2=94=82          =E2=94=82
> + *                                     n          =E2=94=82
> + *                                     =E2=94=82          =E2=94=82
> + *                                     v          =E2=94=82
> + *                                    done <=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> + *
>   */
> =20
>  /*
> @@ -149,12 +370,20 @@ struct xfs_attr_list_context {
>  enum xfs_delattr_state {
>  	XFS_DAS_UNINIT		=3D 0,  /* No state has been set yet */
>  	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
> +	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr */
> +	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr */
> +	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr flag */
> +	XFS_DAS_RM_LBLK,	      /* A rename is removing leaf blocks */
> +	XFS_DAS_ALLOC_NODE,	      /* We are allocating node blocks */
> +	XFS_DAS_FLIP_NFLAG,	      /* Flipped node INCOMPLETE attr flag */
> +	XFS_DAS_RM_NBLK,	      /* A rename is removing node blocks */
>  };
> =20
>  /*
>   * Defines for xfs_delattr_context.flags
>   */
>  #define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
> +#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
> =20
>  /*
>   * Context used for keeping track of delayed attribute operations
> @@ -162,6 +391,11 @@ enum xfs_delattr_state {
>  struct xfs_delattr_context {
>  	struct xfs_da_args      *da_args;
> =20
> +	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
> +	struct xfs_bmbt_irec	map;
> +	xfs_dablk_t		lblkno;
> +	int			blkcnt;
> +
>  	/* Used in xfs_attr_node_removename to roll through removing blocks */
>  	struct xfs_da_state     *da_state;
> =20
> @@ -188,7 +422,6 @@ int xfs_attr_set_args(struct xfs_da_args *args);
>  int xfs_has_attr(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
> -int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
>  bool xfs_attr_namecheck(const void *name, size_t length);
>  void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>  			      struct xfs_da_args *args);
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_rem=
ote.c
> index f09820c..6af86bf 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -441,7 +441,7 @@ xfs_attr_rmtval_get(
>   * Find a "hole" in the attribute address space large enough for us to d=
rop the
>   * new attribute's value into
>   */
> -STATIC int
> +int
>  xfs_attr_rmt_find_hole(
>  	struct xfs_da_args	*args)
>  {
> @@ -468,7 +468,7 @@ xfs_attr_rmt_find_hole(
>  	return 0;
>  }
> =20
> -STATIC int
> +int
>  xfs_attr_rmtval_set_value(
>  	struct xfs_da_args	*args)
>  {
> @@ -628,6 +628,69 @@ xfs_attr_rmtval_set(
>  }
> =20
>  /*
> + * Find a hole for the attr and store it in the delayed attr context.  T=
his
> + * initializes the context to roll through allocating an attr extent for=
 a
> + * delayed attr operation
> + */
> +int
> +xfs_attr_rmtval_find_space(
> +	struct xfs_delattr_context	*dac)
> +{
> +	struct xfs_da_args		*args =3D dac->da_args;
> +	struct xfs_bmbt_irec		*map =3D &dac->map;
> +	int				error;
> +
> +	dac->lblkno =3D 0;
> +	dac->blkcnt =3D 0;
> +	args->rmtblkcnt =3D 0;
> +	args->rmtblkno =3D 0;
> +	memset(map, 0, sizeof(struct xfs_bmbt_irec));
> +
> +	error =3D xfs_attr_rmt_find_hole(args);
> +	if (error)
> +		return error;
> +
> +	dac->blkcnt =3D args->rmtblkcnt;
> +	dac->lblkno =3D args->rmtblkno;
> +
> +	return 0;
> +}
> +
> +/*
> + * Write one block of the value associated with an attribute into the
> + * out-of-line buffer that we have defined for it. This is similar to a =
subset
> + * of xfs_attr_rmtval_set, but records the current block to the delayed =
attr
> + * context, and leaves transaction handling to the caller.
> + */
> +int
> +xfs_attr_rmtval_set_blk(
> +	struct xfs_delattr_context	*dac)
> +{
> +	struct xfs_da_args		*args =3D dac->da_args;
> +	struct xfs_inode		*dp =3D args->dp;
> +	struct xfs_bmbt_irec		*map =3D &dac->map;
> +	int nmap;
> +	int error;
> +
> +	nmap =3D 1;
> +	error =3D xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)dac->lblkno,
> +				dac->blkcnt, XFS_BMAPI_ATTRFORK, args->total,
> +				map, &nmap);
> +	if (error)
> +		return error;
> +
> +	ASSERT(nmap =3D=3D 1);
> +	ASSERT((map->br_startblock !=3D DELAYSTARTBLOCK) &&
> +	       (map->br_startblock !=3D HOLESTARTBLOCK));
> +
> +	/* roll attribute extent map forwards */
> +	dac->lblkno +=3D map->br_blockcount;
> +	dac->blkcnt -=3D map->br_blockcount;
> +
> +	return 0;
> +}
> +
> +/*
>   * Remove the value associated with an attribute by deleting the
>   * out-of-line buffer that it is stored on.
>   */
> @@ -669,37 +732,6 @@ xfs_attr_rmtval_invalidate(
>  }
> =20
>  /*
> - * Remove the value associated with an attribute by deleting the
> - * out-of-line buffer that it is stored on.
> - */
> -int
> -xfs_attr_rmtval_remove(
> -	struct xfs_da_args		*args)
> -{
> -	int				error;
> -	struct xfs_delattr_context	dac  =3D {
> -		.da_args	=3D args,
> -	};
> -
> -	trace_xfs_attr_rmtval_remove(args);
> -
> -	/*
> -	 * Keep de-allocating extents until the remote-value region is gone.
> -	 */
> -	do {
> -		error =3D __xfs_attr_rmtval_remove(&dac);
> -		if (error !=3D -EAGAIN)
> -			break;
> -
> -		error =3D xfs_attr_trans_roll(&dac);
> -		if (error)
> -			return error;
> -	} while (true);
> -
> -	return error;
> -}
> -
> -/*
>   * Remove the value associated with an attribute by deleting the out-of-=
line
>   * buffer that it is stored on. Returns -EAGAIN for the caller to refres=
h the
>   * transaction and re-call the function
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_rem=
ote.h
> index 002fd30..8ad68d5 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -10,9 +10,12 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int att=
rlen);
> =20
>  int xfs_attr_rmtval_get(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set(struct xfs_da_args *args);
> -int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *ma=
p,
>  		xfs_buf_flags_t incore_flags);
>  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>  int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
> +int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
> +int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
> +int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
> +int xfs_attr_rmtval_find_space(struct xfs_delattr_context *dac);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 5a263ae..9074b8b 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1943,7 +1943,6 @@ DEFINE_ATTR_EVENT(xfs_attr_refillstate);
> =20
>  DEFINE_ATTR_EVENT(xfs_attr_rmtval_get);
>  DEFINE_ATTR_EVENT(xfs_attr_rmtval_set);
> -DEFINE_ATTR_EVENT(xfs_attr_rmtval_remove);
> =20
>  #define DEFINE_DA_EVENT(name) \
>  DEFINE_EVENT(xfs_da_class, name, \
>=20


=2D-=20
chandan




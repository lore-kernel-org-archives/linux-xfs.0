Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD15DC63777
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 22:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76F7F206E9
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 22:19:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FYgbH7Me"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730993AbgJ1WS7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732267AbgJ1WSl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 18:18:41 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A938C0613CF
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 15:18:41 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id k65so1201128oih.8
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 15:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vffwA7WIr2U57d9g1cU2Gahwvsn2Vg82cFBXmfUyUGE=;
        b=FYgbH7Me0Uy0eyKtpxoguU6JjneL2i2RucWpDvkSNdqwYhwD2SLc7VlTJYjDm73y6p
         +QEvOcd8xzvxg4cSNO6MLkk0C42ry6rmIZxTbHZS8LrmWAb3nB/N2LXmNDdw6J21q5nG
         y/qXNJiDtpjftgE1XqWsdogSV7ZZy//pp9daACauVEs650Sa7pNFWV+mv4CyYLNUPQgH
         s38rWkfAVLMzNU45a3fGXfoiU6Gnkmw2UAp6NU0E+dyRM/z3yWXg7itJVwbqUydNUdxE
         5cYIja1oDahAmtQLH5sVqPa72RBvC+HKecozPxpyasEEUoEL4IY82/EBGf35Mslrg8Wu
         /DFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vffwA7WIr2U57d9g1cU2Gahwvsn2Vg82cFBXmfUyUGE=;
        b=RoPzDCCF+PF8i46sxirNczyindHqvGAi+IpZwbPrN6RnXc4ADa1KxZGhekRzQRz5or
         UIu6YB74MFb9cBPyfkhv/c+UbzljPOkRXqhKd+v1hnXgQEab9Wxssy/NWis0l5nrlQH3
         ttVrhDFdDK+NL75DfihFACiLL68teAthDeLZifph7q18/MzCWYwCLdn1+GB4OtkJzGrE
         aasyhJmQ7ybCC77ETILsOyDuTug3195QIkasb/0TUo87Ju65XucABp8Wfqmr6DgZHMWt
         OKsL+SsNgzWbc3SRGlJC7eKTg3DImQyF7KEAAMwusyUAWOoe98erZvjUMpKMVO3euGQ8
         Og6Q==
X-Gm-Message-State: AOAM533sWpkd7sNu3Gn37TcOEEOtUSzzRfCVMnv2N5lTFLlaKDtxj5GB
        /Ve9Io1GjyrsH8xAhYW48AI+hI7U2tKp2w==
X-Google-Smtp-Source: ABdhPJzZgMYaNhfxXs2wVUSLvtCQYzTeDKP8VqkZJPQwVeWGHrlG1v7Q57pnDnBHY9MFLrr+P+dKGA==
X-Received: by 2002:a17:90b:16c2:: with SMTP id iy2mr26754pjb.172.1603886685324;
        Wed, 28 Oct 2020 05:04:45 -0700 (PDT)
Received: from garuda.localnet ([122.179.16.19])
        by smtp.gmail.com with ESMTPSA id a2sm5726632pfo.11.2020.10.28.05.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 05:04:43 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v13 02/10] xfs: Add delay ready attr remove routines
Date:   Wed, 28 Oct 2020 17:34:40 +0530
Message-ID: <8152446.Nj3QbannZa@garuda>
In-Reply-To: <fa801ceb-9783-52f9-60c0-5d5b4e58c83d@oracle.com>
References: <20201023063435.7510-1-allison.henderson@oracle.com> <4848306.imHCL76uUN@garuda> <fa801ceb-9783-52f9-60c0-5d5b4e58c83d@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 27 October 2020 9:02:05 PM IST Allison Henderson wrote:
>=20
> On 10/27/20 2:59 AM, Chandan Babu R wrote:
> > On Friday 23 October 2020 12:04:27 PM IST Allison Henderson wrote:
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
> >> is completed.  A new XFS_DAC_DEFER_FINISH flag is used to finish the
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
> >>   fs/xfs/libxfs/xfs_attr.c        | 200 +++++++++++++++++++++++++++++-=
=2D---------
> >>   fs/xfs/libxfs/xfs_attr.h        |  72 +++++++++++++++
> >>   fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
> >>   fs/xfs/libxfs/xfs_attr_remote.c |  37 ++++----
> >>   fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
> >>   fs/xfs/xfs_attr_inactive.c      |   2 +-
> >>   6 files changed, 241 insertions(+), 74 deletions(-)
> >>
> >> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> >> index f4d39bf..6ca94cb 100644
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
> >> @@ -264,6 +264,33 @@ xfs_attr_set_shortform(
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
> >> +	int				error =3D 0;
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
> >> +	}
> >> +
> >> +	return xfs_trans_roll_inode(&args->trans, args->dp);
> >> +}
> >> +
> >> +/*
> >>    * Set the attribute specified in @args.
> >>    */
> >>   int
> >> @@ -364,23 +391,54 @@ xfs_has_attr(
> >>    */
> >>   int
> >>   xfs_attr_remove_args(
> >> -	struct xfs_da_args      *args)
> >> +	struct xfs_da_args	*args)
> >>   {
> >> -	struct xfs_inode	*dp =3D args->dp;
> >> -	int			error;
> >> +	int				error =3D 0;
> >=20
> > I guess the explicit initialization of "error" can be removed since the
> > value returned by the call to xfs_attr_remove_iter() will overwrite it.
> Sure, will fix
> >=20
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
> >> +
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
> >> +	if (dac->dela_state =3D=3D XFS_DAS_RM_SHRINK)
> >> +		goto node;
> >>  =20
> >>   	if (!xfs_inode_hasattr(dp)) {
> >> -		error =3D -ENOATTR;
> >> +		return -ENOATTR;
> >>   	} else if (dp->i_afp->if_format =3D=3D XFS_DINODE_FMT_LOCAL) {
> >>   		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> >> -		error =3D xfs_attr_shortform_remove(args);
> >> +		return xfs_attr_shortform_remove(args);
> >>   	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> >> -		error =3D xfs_attr_leaf_removename(args);
> >> -	} else {
> >> -		error =3D xfs_attr_node_removename(args);
> >> +		return xfs_attr_leaf_removename(args);
> >>   	}
> >> -
> >> -	return error;
> >> +node:
> >> +	return  xfs_attr_node_removename_iter(dac);
> >>   }
> >>  =20
> >>   /*
> >> @@ -1178,10 +1236,11 @@ xfs_attr_leaf_mark_incomplete(
> >>    */
> >>   STATIC
> >>   int xfs_attr_node_removename_setup(
> >> -	struct xfs_da_args	*args,
> >> -	struct xfs_da_state	**state)
> >> +	struct xfs_delattr_context	*dac,
> >> +	struct xfs_da_state		**state)
> >>   {
> >> -	int			error;
> >> +	struct xfs_da_args		*args =3D dac->da_args;
> >> +	int				error;
> >>  =20
> >>   	error =3D xfs_attr_node_hasname(args, state);
> >>   	if (error !=3D -EEXIST)
> >> @@ -1191,6 +1250,12 @@ int xfs_attr_node_removename_setup(
> >>   	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic =3D=3D
> >>   		XFS_ATTR_LEAF_MAGIC);
> >>  =20
> >> +	/*
> >> +	 * Store state in the context incase we need to cycle out the
> >> +	 * transaction
> >> +	 */
> >> +	dac->da_state =3D *state;
> >> +
> >>   	if (args->rmtblkno > 0) {
> >>   		error =3D xfs_attr_leaf_mark_incomplete(args, *state);
> >>   		if (error)
> >> @@ -1203,13 +1268,16 @@ int xfs_attr_node_removename_setup(
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
> >> @@ -1221,21 +1289,27 @@ xfs_attr_node_remove_rmt(
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
> >> -	struct xfs_da_state_blk	*blk;
> >> -	int			retval, error;
> >> -	struct xfs_inode	*dp =3D args->dp;
> >> +	struct xfs_da_args		*args =3D dac->da_args;
> >> +	struct xfs_da_state		*state;
> >> +	struct xfs_da_state_blk		*blk;
> >> +	int				retval, error =3D 0;
> >>  =20
> >> +	state =3D dac->da_state;
> >>  =20
> >>   	/*
> >>   	 * If there is an out-of-line value, de-allocate the blocks.
> >> @@ -1243,7 +1317,10 @@ xfs_attr_node_remove_step(
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
> >> @@ -1257,21 +1334,18 @@ xfs_attr_node_remove_step(
> >>   	xfs_da3_fixhashpath(state, &state->path);
> >>  =20
> >>   	/*
> >> -	 * Check to see if the tree needs to be collapsed.
> >> +	 * Check to see if the tree needs to be collapsed.  Set the flag to
> >> +	 * indicate that the calling function needs to move the to shrink
> >> +	 * operation
> >>   	 */
> >>   	if (retval && (state->path.active > 1)) {
> >>   		error =3D xfs_da3_join(state);
> >>   		if (error)
> >>   			return error;
> >> -		error =3D xfs_defer_finish(&args->trans);
> >> -		if (error)
> >> -			return error;
> >> -		/*
> >> -		 * Commit the Btree join operation and start a new trans.
> >> -		 */
> >> -		error =3D xfs_trans_roll_inode(&args->trans, dp);
> >> -		if (error)
> >> -			return error;
> >> +
> >> +		dac->flags |=3D XFS_DAC_DEFER_FINISH;
> >> +		dac->dela_state =3D XFS_DAS_RM_SHRINK;
> >> +		return -EAGAIN;
> >>   	}
> >>  =20
> >>   	return error;
> >> @@ -1282,31 +1356,53 @@ xfs_attr_node_remove_step(
> >>    *
> >>    * This routine will find the blocks of the name to remove, remove t=
hem and
> >>    * shirnk the tree if needed.
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
> >> -	struct xfs_da_state	*state;
> >> -	int			error;
> >> -	struct xfs_inode	*dp =3D args->dp;
> >> +	struct xfs_da_args		*args =3D dac->da_args;
> >> +	struct xfs_da_state		*state;
> >> +	int				error;
> >> +	struct xfs_inode		*dp =3D args->dp;
> >>  =20
> >>   	trace_xfs_attr_node_removename(args);
> >> +	state =3D dac->da_state;
> >>  =20
> >> -	error =3D xfs_attr_node_removename_setup(args, &state);
> >> -	if (error)
> >> -		goto out;
> >> +	if ((dac->flags & XFS_DAC_NODE_RMVNAME_INIT) =3D=3D 0) {
> >> +		dac->flags |=3D XFS_DAC_NODE_RMVNAME_INIT;
> >> +		error =3D xfs_attr_node_removename_setup(dac, &state);
> >> +		if (error)
> >> +			goto out;
> >> +	}
> >>  =20
> >> -	error =3D xfs_attr_node_remove_step(args, state);
> >> -	if (error)
> >> -		goto out;
> >> +	switch (dac->dela_state) {
> >> +	case XFS_DAS_UNINIT:
> >> +		error =3D xfs_attr_node_remove_step(dac);
> >> +		if (error)
> >> +			break;
> >>  =20
> >> -	/*
> >> -	 * If the result is small enough, push it all into the inode.
> >> -	 */
> >> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> >> -		error =3D xfs_attr_node_shrink(args, state);
> >> +		/* do not break, proceed to shrink if needed */
> >> +	case XFS_DAS_RM_SHRINK:
> >> +		/*
> >> +		 * If the result is small enough, push it all into the inode.
> >> +		 */
> >> +		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> >> +			error =3D xfs_attr_node_shrink(args, state);
> >>  =20
> >> +		break;
> >> +	default:
> >> +		ASSERT(0);
> >> +		return -EINVAL;
> >=20
> > I don't think it is possible in a real world scenario, but if "state" w=
ere
> > pointing to allocated memory then the above return value might leak the
> > corresponding memory.
> Hmm, trying to follow you here.... I'm assuming you meant dela_state=20
> instead of state since that's what controls the switch.  The dac=20
> structure is zeroed when allocated to avoid this.  Most of the time when=
=20
> this switch executes, dela_state is zero.  I did have to add the=20
> XFS_DAS_UNINIT from the previous suggestion in the last revision though=20
> or it generates warnings.
> >

Sorry, I should have clarified that I was referring to the allocated
memory pointed to by dac->da_state. If dac->da_state was pointing to a valid
memory location and dac->dela_state's value is not equal to either
XFS_DAS_UNINIT nor XFS_DAS_RM_SHRINK then the code under the "default" clau=
se
will execute causing -EINVAL to be returned. This could leak the memory
pointed to by dac->da_state.


> > Apart from the above nit, the remaining changes look good to me.
> Ok, thanks for the review!
> Allison
>=20
> >=20
> > Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> >=20
> >> +	}
> >> +
> >> +	if (error =3D=3D -EAGAIN)
> >> +		return error;
> >>   out:
> >>   	if (state)
> >>   		xfs_da_state_free(state);
> >> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> >> index 3e97a93..64dcf0f 100644
> >> --- a/fs/xfs/libxfs/xfs_attr.h
> >> +++ b/fs/xfs/libxfs/xfs_attr.h
> >> @@ -74,6 +74,74 @@ struct xfs_attr_list_context {
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
> >> + *	  XFS_DAS_RM_SHRINK =E2=94=80=E2=94=90
> >> + *	  (subroutine state) =E2=94=82
> >> + *	                     =E2=94=94=E2=94=80>xfs_attr_node_removename()
> >> + *	                                      =E2=94=82
> >> + *	                                      v
> >> + *	                                   need to
> >> + *	                                shrink tree? =E2=94=80n=E2=94=80=
=E2=94=90
> >> + *	                                      =E2=94=82         =E2=94=82
> >> + *	                                      y         =E2=94=82
> >> + *	                                      =E2=94=82         =E2=94=82
> >> + *	                                      v         =E2=94=82
> >> + *	                              XFS_DAS_RM_SHRINK =E2=94=82
> >> + *	                                      =E2=94=82         =E2=94=82
> >> + *	                                      v         =E2=94=82
> >> + *	                                     done <=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=98
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
> >> +#define XFS_DAC_NODE_RMVNAME_INIT	0x02 /* xfs_attr_node_removename in=
it */
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
> >> @@ -91,6 +159,10 @@ int xfs_attr_set(struct xfs_da_args *args);
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
> >> index bb128db..338377e 100644
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
> >> index 48d8e9c..1426c15 100644
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
> >> @@ -685,19 +687,17 @@ xfs_attr_rmtval_remove(
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
> >>  =20
> >> -	return 0;
> >> +	} while (true);
> >> +
> >> +	return error;
> >>   }
> >>  =20
> >>   /*
> >> @@ -707,9 +707,10 @@ xfs_attr_rmtval_remove(
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
> >> @@ -719,12 +720,10 @@ __xfs_attr_rmtval_remove(
> >>   	if (error)
> >>   		return error;
> >>  =20
> >> -	error =3D xfs_defer_finish(&args->trans);
> >> -	if (error)
> >> -		return error;
> >> -
> >> -	if (!done)
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




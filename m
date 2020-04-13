Return-Path: <SRS0=wgma=55=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E52DC2BA19
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Apr 2020 12:30:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5BE42063A
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Apr 2020 12:30:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c4+hQM8+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgDMMab (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Apr 2020 08:30:31 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26783 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728392AbgDMMaa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Apr 2020 08:30:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586781027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u38DdUJSf2NHsnC6Owt6WVoz8qk6RiE1A+KuBKJ1YTw=;
        b=c4+hQM8+JXlx+LeCRzUtuKBAw10AYG2paBxPPZFbO0BFJBzzi5EG2j5DGSH2SXsFoKTgxy
        c88pM8x612k+FCrJrN9XIyM/kSJjbh+iDDaJKMckgs0AaAuNgeCGMs70srrQd1wLgpCv0A
        7c3yHEzIny6lzvdIvN/gbQmX6yKsSYU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-um9XE-7IN2-fQpay4jgTaQ-1; Mon, 13 Apr 2020 08:30:25 -0400
X-MC-Unique: um9XE-7IN2-fQpay4jgTaQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C795F107ACC4;
        Mon, 13 Apr 2020 12:30:23 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 20361CFE14;
        Mon, 13 Apr 2020 12:30:23 +0000 (UTC)
Date:   Mon, 13 Apr 2020 08:30:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 18/20] xfs: Add delay ready attr remove routines
Message-ID: <20200413123021.GA57285@bfoster>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-19-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200403221229.4995-19-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 03, 2020 at 03:12:27PM -0700, Allison Collins wrote:
> This patch modifies the attr remove routines to be delay ready. This
> means they no longer roll or commit transactions, but instead return
> -EAGAIN to have the calling routine roll and refresh the transaction. I=
n
> this series, xfs_attr_remove_args has become xfs_attr_remove_iter, whic=
h
> uses a sort of state machine like switch to keep track of where it was
> when EAGAIN was returned. xfs_attr_node_removename has also been
> modified to use the switch, and a new version of xfs_attr_remove_args
> consists of a simple loop to refresh the transaction until the operatio=
n
> is completed.
>=20
> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
> counter parts: xfs_attr_rmtval_invalidate (appearing in the setup
> helper) and then __xfs_attr_rmtval_remove. We will rename
> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
> done.
>=20
> This patch also adds a new struct xfs_delattr_context, which we will us=
e
> to keep track of the current state of an attribute operation. The new
> xfs_delattr_state enum is used to track various operations that are in
> progress so that we know not to repeat them, and resume where we left
> off before EAGAIN was returned to cycle out the transaction. Other
> members take the place of local variables that need to retain their
> values across multiple function recalls.
>=20
> Below is a state machine diagram for attr remove operations. The
> XFS_DAS_* states indicate places where the function would return
> -EAGAIN, and then immediately resume from after being recalled by the
> calling function.  States marked as a "subroutine state" indicate that
> they belong to a subroutine, and so the calling function needs to pass
> them back to that subroutine to allow it to finish where it left off.
> But they otherwise do not have a role in the calling function other tha=
n
> just passing through.
>=20
>  xfs_attr_remove_iter()
>          XFS_DAS_RM_SHRINK     =E2=94=80=E2=94=90
>          (subroutine state)     =E2=94=82
>                                 =E2=94=82
>          XFS_DAS_RMTVAL_REMOVE =E2=94=80=E2=94=A4
>          (subroutine state)     =E2=94=82
>                                 =E2=94=94=E2=94=80>xfs_attr_node_remove=
name()
>                                                  =E2=94=82
>                                                  v
>                                          need to remove
>                                    =E2=94=8C=E2=94=80n=E2=94=80=E2=94=80=
  rmt blocks?
>                                    =E2=94=82             =E2=94=82
>                                    =E2=94=82             y
>                                    =E2=94=82             =E2=94=82
>                                    =E2=94=82             v
>                                    =E2=94=82  =E2=94=8C=E2=94=80>XFS_DA=
S_RMTVAL_REMOVE
>                                    =E2=94=82  =E2=94=82          =E2=94=
=82
>                                    =E2=94=82  =E2=94=82          v
>                                    =E2=94=82  =E2=94=94=E2=94=80=E2=94=80=
y=E2=94=80=E2=94=80 more blks
>                                    =E2=94=82         to remove?
>                                    =E2=94=82             =E2=94=82
>                                    =E2=94=82             n
>                                    =E2=94=82             =E2=94=82
>                                    =E2=94=82             v
>                                    =E2=94=82         need to
>                                    =E2=94=94=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80> shrink tree? =E2=94=80n=E2=94=80=E2=94=90
>                                                  =E2=94=82         =E2=94=
=82
>                                                  y         =E2=94=82
>                                                  =E2=94=82         =E2=94=
=82
>                                                  v         =E2=94=82
>                                          XFS_DAS_RM_SHRINK =E2=94=82
>                                                  =E2=94=82         =E2=94=
=82
>                                                  v         =E2=94=82
>                                                 done <=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=98
>=20
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---

All in all this is starting to look much more simple to me, at least in
the remove path. ;P There's only a few states and the markers that are
introduced are fairly straightforward, etc. Comments to follow..

>  fs/xfs/libxfs/xfs_attr.c | 168 ++++++++++++++++++++++++++++++++++++---=
--------
>  fs/xfs/libxfs/xfs_attr.h |  38 +++++++++++
>  2 files changed, 168 insertions(+), 38 deletions(-)
>=20
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d735570..f700976 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -45,7 +45,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *=
args);
>   */
>  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
> -STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> +STATIC int xfs_attr_leaf_removename(struct xfs_delattr_context *dac);
>  STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_=
buf **bp);
> =20
>  /*
> @@ -53,12 +53,21 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args=
 *args, struct xfs_buf **bp);
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> -STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> +STATIC int xfs_attr_node_removename(struct xfs_delattr_context *dac);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> =20
> +STATIC void
> +xfs_delattr_context_init(
> +	struct xfs_delattr_context	*dac,
> +	struct xfs_da_args		*args)
> +{
> +	memset(dac, 0, sizeof(struct xfs_delattr_context));
> +	dac->da_args =3D args;
> +}
> +
>  int
>  xfs_inode_hasattr(
>  	struct xfs_inode	*ip)
> @@ -356,20 +365,66 @@ xfs_has_attr(
>   */
>  int
>  xfs_attr_remove_args(
> -	struct xfs_da_args      *args)
> +	struct xfs_da_args	*args)
>  {
> +	int			error =3D 0;
> +	struct			xfs_delattr_context dac;
> +
> +	xfs_delattr_context_init(&dac, args);
> +
> +	do {
> +		error =3D xfs_attr_remove_iter(&dac);
> +		if (error !=3D -EAGAIN)
> +			break;
> +
> +		if (dac.flags & XFS_DAC_DEFER_FINISH) {
> +			dac.flags &=3D ~XFS_DAC_DEFER_FINISH;
> +			error =3D xfs_defer_finish(&args->trans);
> +			if (error)
> +				break;
> +		}
> +
> +		error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> +		if (error)
> +			break;
> +	} while (true);
> +
> +	return error;
> +}
> +
> +/*
> + * Remove the attribute specified in @args.
> + *
> + * This function may return -EAGAIN to signal that the transaction nee=
ds to be
> + * rolled.  Callers should continue calling this function until they r=
eceive a
> + * return value other than -EAGAIN.
> + */
> +int
> +xfs_attr_remove_iter(
> +	struct xfs_delattr_context *dac)
> +{
> +	struct xfs_da_args	*args =3D dac->da_args;
>  	struct xfs_inode	*dp =3D args->dp;
>  	int			error;
> =20
> +	/* State machine switch */
> +	switch (dac->dela_state) {
> +	case XFS_DAS_RM_SHRINK:
> +	case XFS_DAS_RMTVAL_REMOVE:
> +		return xfs_attr_node_removename(dac);
> +	default:
> +		break;
> +	}
> +

Hmm.. so we're duplicating the call instead of using labels..? I'm
wondering if this can be elegantly combined with the if/else branches
below, particularly since node format is the only situation that seems
to require a roll here.

>  	if (!xfs_inode_hasattr(dp)) {
>  		error =3D -ENOATTR;
>  	} else if (dp->i_d.di_aformat =3D=3D XFS_DINODE_FMT_LOCAL) {
>  		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>  		error =3D xfs_attr_shortform_remove(args);
>  	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -		error =3D xfs_attr_leaf_removename(args);
> +		error =3D xfs_attr_leaf_removename(dac);
>  	} else {
> -		error =3D xfs_attr_node_removename(args);
> +		error =3D xfs_attr_node_removename(dac);
>  	}
> =20
>  	return error;
> @@ -794,11 +849,12 @@ xfs_attr_leaf_hasname(
>   */
>  STATIC int
>  xfs_attr_leaf_removename(
> -	struct xfs_da_args	*args)
> +	struct xfs_delattr_context	*dac)
>  {
> -	struct xfs_inode	*dp;
> -	struct xfs_buf		*bp;
> -	int			error, forkoff;
> +	struct xfs_da_args		*args =3D dac->da_args;
> +	struct xfs_inode		*dp;
> +	struct xfs_buf			*bp;
> +	int				error, forkoff;
> =20
>  	trace_xfs_attr_leaf_removename(args);
> =20
> @@ -825,9 +881,8 @@ xfs_attr_leaf_removename(
>  		/* bp is gone due to xfs_da_shrink_inode */
>  		if (error)
>  			return error;
> -		error =3D xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> +
> +		dac->flags |=3D XFS_DAC_DEFER_FINISH;

There's no -EAGAIN return here, is this an exit path for the remove?

>  	}
>  	return 0;
>  }
> @@ -1128,12 +1183,13 @@ xfs_attr_node_addname(
>   */
>  STATIC int
>  xfs_attr_node_shrink(
> -	struct xfs_da_args	*args,
> -	struct xfs_da_state     *state)
> +	struct xfs_delattr_context	*dac,
> +	struct xfs_da_state		*state)
>  {
> -	struct xfs_inode	*dp =3D args->dp;
> -	int			error, forkoff;
> -	struct xfs_buf		*bp;
> +	struct xfs_da_args		*args =3D dac->da_args;
> +	struct xfs_inode		*dp =3D args->dp;
> +	int				error, forkoff;
> +	struct xfs_buf			*bp;
> =20
>  	/*
>  	 * Have to get rid of the copy of this dabuf in the state.
> @@ -1153,9 +1209,7 @@ xfs_attr_node_shrink(
>  		if (error)
>  			return error;
> =20
> -		error =3D xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> +		dac->flags |=3D XFS_DAC_DEFER_FINISH;

Same question here.

>  	} else
>  		xfs_trans_brelse(args->trans, bp);
> =20
> @@ -1194,13 +1248,15 @@ xfs_attr_leaf_mark_incomplete(
> =20
>  /*
>   * Initial setup for xfs_attr_node_removename.  Make sure the attr is =
there and
> - * the blocks are valid.  Any remote blocks will be marked incomplete.
> + * the blocks are valid.  Any remote blocks will be marked incomplete =
and
> + * invalidated.
>   */
>  STATIC
>  int xfs_attr_node_removename_setup(
> -	struct xfs_da_args	*args,
> -	struct xfs_da_state	**state)
> +	struct xfs_delattr_context	*dac,
> +	struct xfs_da_state		**state)
>  {
> +	struct xfs_da_args	*args =3D dac->da_args;
>  	int			error;
>  	struct xfs_da_state_blk	*blk;
> =20
> @@ -1212,10 +1268,21 @@ int xfs_attr_node_removename_setup(
>  	ASSERT(blk->bp !=3D NULL);
>  	ASSERT(blk->magic =3D=3D XFS_ATTR_LEAF_MAGIC);
> =20
> +	/*
> +	 * Store blk and state in the context incase we need to cycle out the
> +	 * transaction
> +	 */
> +	dac->blk =3D blk;
> +	dac->da_state =3D *state;
> +
>  	if (args->rmtblkno > 0) {
>  		error =3D xfs_attr_leaf_mark_incomplete(args, *state);
>  		if (error)
>  			return error;
> +
> +		error =3D xfs_attr_rmtval_invalidate(args);
> +		if (error)
> +			return error;

Seems like this moves code, which should probably happen in a separate
patch.

>  	}
> =20
>  	return 0;
> @@ -1228,7 +1295,10 @@ xfs_attr_node_removename_rmt (
>  {
>  	int			error =3D 0;
> =20
> -	error =3D xfs_attr_rmtval_remove(args);
> +	/*
> +	 * May return -EAGAIN to request that the caller recall this function
> +	 */
> +	error =3D __xfs_attr_rmtval_remove(args);
>  	if (error)
>  		return error;
> =20
> @@ -1249,19 +1319,37 @@ xfs_attr_node_removename_rmt (
>   * This will involve walking down the Btree, and may involve joining
>   * leaf nodes and even joining intermediate nodes up to and including
>   * the root node (a special case of an intermediate node).
> + *
> + * This routine is meant to function as either an inline or delayed op=
eration,
> + * and may return -EAGAIN when the transaction needs to be rolled.  Ca=
lling
> + * functions will need to handle this, and recall the function until a
> + * successful error code is returned.
>   */
>  STATIC int
>  xfs_attr_node_removename(
> -	struct xfs_da_args	*args)
> +	struct xfs_delattr_context	*dac)
>  {
> +	struct xfs_da_args	*args =3D dac->da_args;
>  	struct xfs_da_state	*state;
>  	struct xfs_da_state_blk	*blk;
>  	int			retval, error;
>  	struct xfs_inode	*dp =3D args->dp;
> =20
>  	trace_xfs_attr_node_removename(args);
> +	state =3D dac->da_state;
> +	blk =3D dac->blk;
> +
> +	/* State machine switch */
> +	switch (dac->dela_state) {
> +	case XFS_DAS_RMTVAL_REMOVE:
> +		goto das_rmtval_remove;
> +	case XFS_DAS_RM_SHRINK:
> +		goto das_rm_shrink;
> +	default:
> +		break;
> +	}
> =20
> -	error =3D xfs_attr_node_removename_setup(args, &state);
> +	error =3D xfs_attr_node_removename_setup(dac, &state);
>  	if (error)
>  		goto out;
> =20
> @@ -1270,10 +1358,16 @@ xfs_attr_node_removename(
>  	 * This is done before we remove the attribute so that we don't
>  	 * overflow the maximum size of a transaction and/or hit a deadlock.
>  	 */
> +
> +das_rmtval_remove:
> +

I wonder if we need this label just to protect the setup. Perhaps if we
had something like:

	/* set up the remove only once... */
	if (dela_state =3D=3D 0)
		error =3D xfs_attr_node_removename_setup(...);

... we could reduce another state.

We could also accomplish the same thing with an explicit state to
indicate the setup already occurred or a new dac flag, though I'm not
sure a flag is appropriate if it would only be used here.

Brian

>  	if (args->rmtblkno > 0) {
>  		error =3D xfs_attr_node_removename_rmt(args, state);
> -		if (error)
> -			goto out;
> +		if (error) {
> +			if (error =3D=3D -EAGAIN)
> +				dac->dela_state =3D XFS_DAS_RMTVAL_REMOVE;
> +			return error;
> +		}
>  	}
> =20
>  	/*
> @@ -1291,22 +1385,20 @@ xfs_attr_node_removename(
>  		error =3D xfs_da3_join(state);
>  		if (error)
>  			goto out;
> -		error =3D xfs_defer_finish(&args->trans);
> -		if (error)
> -			goto out;
> -		/*
> -		 * Commit the Btree join operation and start a new trans.
> -		 */
> -		error =3D xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			goto out;
> +
> +		dac->flags |=3D XFS_DAC_DEFER_FINISH;
> +		dac->dela_state =3D XFS_DAS_RM_SHRINK;
> +		return -EAGAIN;
>  	}
> =20
> +das_rm_shrink:
> +	dac->dela_state =3D XFS_DAS_RM_SHRINK;
> +
>  	/*
>  	 * If the result is small enough, push it all into the inode.
>  	 */
>  	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> -		error =3D xfs_attr_node_shrink(args, state);
> +		error =3D xfs_attr_node_shrink(dac, state);
> =20
>  	error =3D 0;
>  out:
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 66575b8..0e8ae1a 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -74,6 +74,43 @@ struct xfs_attr_list_context {
>  };
> =20
> =20
> +/*
> + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> + * Structure used to pass context around among the delayed routines.
> + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> + */
> +
> +/*
> + * Enum values for xfs_delattr_context.da_state
> + *
> + * These values are used by delayed attribute operations to keep track=
  of where
> + * they were before they returned -EAGAIN.  A return code of -EAGAIN s=
ignals the
> + * calling function to roll the transaction, and then recall the subro=
utine to
> + * finish the operation.  The enum is then used by the subroutine to j=
ump back
> + * to where it was and resume executing where it left off.
> + */
> +enum xfs_delattr_state {
> +				      /* Zero is uninitalized */
> +	XFS_DAS_RM_SHRINK	=3D 1,  /* We are shrinking the tree */
> +	XFS_DAS_RMTVAL_REMOVE,	      /* We are removing remote value blocks *=
/
> +};
> +
> +/*
> + * Defines for xfs_delattr_context.flags
> + */
> +#define XFS_DAC_DEFER_FINISH    0x1 /* indicates to finish the transac=
tion */
> +
> +/*
> + * Context used for keeping track of delayed attribute operations
> + */
> +struct xfs_delattr_context {
> +	struct xfs_da_args      *da_args;
> +	struct xfs_da_state     *da_state;
> +	struct xfs_da_state_blk *blk;
> +	unsigned int            flags;
> +	enum xfs_delattr_state  dela_state;
> +};
> +
>  /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   * Function prototypes for the kernel.
>   *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D*=
/
> @@ -91,6 +128,7 @@ int xfs_attr_set(struct xfs_da_args *args);
>  int xfs_attr_set_args(struct xfs_da_args *args);
>  int xfs_has_attr(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
> +int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>  bool xfs_attr_namecheck(const void *name, size_t length);
> =20
>  #endif	/* __XFS_ATTR_H__ */
> --=20
> 2.7.4
>=20


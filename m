Return-Path: <SRS0=6B5E=57=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0078DC2BA19
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 12:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B84EA2137B
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 12:18:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aDUJGdeh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368870AbgDOMS0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 08:18:26 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49303 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2409264AbgDOLqO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Apr 2020 07:46:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586951169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tJmKgEz/fHLf0Ek9MNaiLYSYT77ZKmUawY3VApG2SJg=;
        b=aDUJGdehQ2c+LF2YoCUcj+hJi5yLyl4FYACKONRKgEIRhpJ4bBCDAMeD8F2hGm0nmSy/Cd
        BqIKeWFQa0J6VUvCxWy241NZcqh3Xdnxd6wQ//veAYVCYRROXa674DsjIBXUna04G0tWVw
        aGj4VDge136HFpvgOSBeEVtbTxARMxc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-KiHrwcRcMoGbj2k6vVCkLw-1; Wed, 15 Apr 2020 07:46:07 -0400
X-MC-Unique: KiHrwcRcMoGbj2k6vVCkLw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F6F3800D5B;
        Wed, 15 Apr 2020 11:46:06 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 94D1BC0DB9;
        Wed, 15 Apr 2020 11:46:05 +0000 (UTC)
Date:   Wed, 15 Apr 2020 07:46:03 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org, dchinner@redhat.com
Subject: Re: [PATCH v8 18/20] xfs: Add delay ready attr remove routines
Message-ID: <20200415114603.GB2140@bfoster>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-19-allison.henderson@oracle.com>
 <20200413123021.GA57285@bfoster>
 <4c38d38f-ad8a-24dc-9d00-815fc433dfdb@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4c38d38f-ad8a-24dc-9d00-815fc433dfdb@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 14, 2020 at 02:35:43PM -0700, Allison Collins wrote:
>=20
>=20
> On 4/13/20 5:30 AM, Brian Foster wrote:
> > On Fri, Apr 03, 2020 at 03:12:27PM -0700, Allison Collins wrote:
> > > This patch modifies the attr remove routines to be delay ready. Thi=
s
> > > means they no longer roll or commit transactions, but instead retur=
n
> > > -EAGAIN to have the calling routine roll and refresh the transactio=
n. In
> > > this series, xfs_attr_remove_args has become xfs_attr_remove_iter, =
which
> > > uses a sort of state machine like switch to keep track of where it =
was
> > > when EAGAIN was returned. xfs_attr_node_removename has also been
> > > modified to use the switch, and a new version of xfs_attr_remove_ar=
gs
> > > consists of a simple loop to refresh the transaction until the oper=
ation
> > > is completed.
> > >=20
> > > Calls to xfs_attr_rmtval_remove are replaced with the delay ready
> > > counter parts: xfs_attr_rmtval_invalidate (appearing in the setup
> > > helper) and then __xfs_attr_rmtval_remove. We will rename
> > > __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
> > > done.
> > >=20
> > > This patch also adds a new struct xfs_delattr_context, which we wil=
l use
> > > to keep track of the current state of an attribute operation. The n=
ew
> > > xfs_delattr_state enum is used to track various operations that are=
 in
> > > progress so that we know not to repeat them, and resume where we le=
ft
> > > off before EAGAIN was returned to cycle out the transaction. Other
> > > members take the place of local variables that need to retain their
> > > values across multiple function recalls.
> > >=20
> > > Below is a state machine diagram for attr remove operations. The
> > > XFS_DAS_* states indicate places where the function would return
> > > -EAGAIN, and then immediately resume from after being recalled by t=
he
> > > calling function.  States marked as a "subroutine state" indicate t=
hat
> > > they belong to a subroutine, and so the calling function needs to p=
ass
> > > them back to that subroutine to allow it to finish where it left of=
f.
> > > But they otherwise do not have a role in the calling function other=
 than
> > > just passing through.
> > >=20
> > >   xfs_attr_remove_iter()
> > >           XFS_DAS_RM_SHRINK     =E2=94=80=E2=94=90
> > >           (subroutine state)     =E2=94=82
> > >                                  =E2=94=82
> > >           XFS_DAS_RMTVAL_REMOVE =E2=94=80=E2=94=A4
> > >           (subroutine state)     =E2=94=82
> > >                                  =E2=94=94=E2=94=80>xfs_attr_node_r=
emovename()
> > >                                                   =E2=94=82
> > >                                                   v
> > >                                           need to remove
> > >                                     =E2=94=8C=E2=94=80n=E2=94=80=E2=
=94=80  rmt blocks?
> > >                                     =E2=94=82             =E2=94=82
> > >                                     =E2=94=82             y
> > >                                     =E2=94=82             =E2=94=82
> > >                                     =E2=94=82             v
> > >                                     =E2=94=82  =E2=94=8C=E2=94=80>X=
FS_DAS_RMTVAL_REMOVE
> > >                                     =E2=94=82  =E2=94=82          =E2=
=94=82
> > >                                     =E2=94=82  =E2=94=82          v
> > >                                     =E2=94=82  =E2=94=94=E2=94=80=E2=
=94=80y=E2=94=80=E2=94=80 more blks
> > >                                     =E2=94=82         to remove?
> > >                                     =E2=94=82             =E2=94=82
> > >                                     =E2=94=82             n
> > >                                     =E2=94=82             =E2=94=82
> > >                                     =E2=94=82             v
> > >                                     =E2=94=82         need to
> > >                                     =E2=94=94=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80> shrink tree? =E2=94=80n=E2=94=80=E2=94=90
> > >                                                   =E2=94=82        =
 =E2=94=82
> > >                                                   y         =E2=94=82
> > >                                                   =E2=94=82        =
 =E2=94=82
> > >                                                   v         =E2=94=82
> > >                                           XFS_DAS_RM_SHRINK =E2=94=82
> > >                                                   =E2=94=82        =
 =E2=94=82
> > >                                                   v         =E2=94=82
> > >                                                  done <=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> > >=20
> > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > ---
> >=20
> > All in all this is starting to look much more simple to me, at least =
in
> > the remove path. ;P There's only a few states and the markers that ar=
e
> > introduced are fairly straightforward, etc. Comments to follow..
> >=20
> > >   fs/xfs/libxfs/xfs_attr.c | 168 ++++++++++++++++++++++++++++++++++=
++-----------
> > >   fs/xfs/libxfs/xfs_attr.h |  38 +++++++++++
> > >   2 files changed, 168 insertions(+), 38 deletions(-)
> > >=20
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index d735570..f700976 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -45,7 +45,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args=
_t *args);
> > >    */
> > >   STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
> > >   STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
> > > -STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> > > +STATIC int xfs_attr_leaf_removename(struct xfs_delattr_context *da=
c);
> > >   STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct=
 xfs_buf **bp);
> > >   /*
> > > @@ -53,12 +53,21 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_=
args *args, struct xfs_buf **bp);
> > >    */
> > >   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> > >   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> > > -STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> > > +STATIC int xfs_attr_node_removename(struct xfs_delattr_context *da=
c);
> > >   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> > >   				 struct xfs_da_state **state);
> > >   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> > >   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> > > +STATIC void
> > > +xfs_delattr_context_init(
> > > +	struct xfs_delattr_context	*dac,
> > > +	struct xfs_da_args		*args)
> > > +{
> > > +	memset(dac, 0, sizeof(struct xfs_delattr_context));
> > > +	dac->da_args =3D args;
> > > +}
> > > +
> > >   int
> > >   xfs_inode_hasattr(
> > >   	struct xfs_inode	*ip)
> > > @@ -356,20 +365,66 @@ xfs_has_attr(
> > >    */
> > >   int
> > >   xfs_attr_remove_args(
> > > -	struct xfs_da_args      *args)
> > > +	struct xfs_da_args	*args)
> > >   {
> > > +	int			error =3D 0;
> > > +	struct			xfs_delattr_context dac;
> > > +
> > > +	xfs_delattr_context_init(&dac, args);
> > > +
> > > +	do {
> > > +		error =3D xfs_attr_remove_iter(&dac);
> > > +		if (error !=3D -EAGAIN)
> > > +			break;
> > > +
> > > +		if (dac.flags & XFS_DAC_DEFER_FINISH) {
> > > +			dac.flags &=3D ~XFS_DAC_DEFER_FINISH;
> > > +			error =3D xfs_defer_finish(&args->trans);
> > > +			if (error)
> > > +				break;
> > > +		}
> > > +
> > > +		error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> > > +		if (error)
> > > +			break;
> > > +	} while (true);
> > > +
> > > +	return error;
> > > +}
> > > +
> > > +/*
> > > + * Remove the attribute specified in @args.
> > > + *
> > > + * This function may return -EAGAIN to signal that the transaction=
 needs to be
> > > + * rolled.  Callers should continue calling this function until th=
ey receive a
> > > + * return value other than -EAGAIN.
> > > + */
> > > +int
> > > +xfs_attr_remove_iter(
> > > +	struct xfs_delattr_context *dac)
> > > +{
> > > +	struct xfs_da_args	*args =3D dac->da_args;
> > >   	struct xfs_inode	*dp =3D args->dp;
> > >   	int			error;
> > > +	/* State machine switch */
> > > +	switch (dac->dela_state) {
> > > +	case XFS_DAS_RM_SHRINK:
> > > +	case XFS_DAS_RMTVAL_REMOVE:
> > > +		return xfs_attr_node_removename(dac);
> > > +	default:
> > > +		break;
> > > +	}
> > > +
> >=20
> > Hmm.. so we're duplicating the call instead of using labels..?
>=20
> Yes, this was a suggestion made during v7.  I suspect Dave may have bee=
n
> wanting to simplify things by escaping the use of labels.  At least in =
so
> far as the remove path is concerned.  Though he may not have realized t=
his
> would create a duplication call?  I will cc him here; the conditions fo=
r
> calling xfs_attr_node_removename are: the below if/else sequence exhaus=
ts
> with no successes, and defaults into the else case (ie: the entry
> condition), OR one of the above states is set (which is a re-entry
> condition)
>=20

Ok.

>=20
> I'm
> > wondering if this can be elegantly combined with the if/else branches
> > below, particularly since node format is the only situation that seem=
s
> > to require a roll here.
> >=20
> > >   	if (!xfs_inode_hasattr(dp)) {
> > >   		error =3D -ENOATTR;
> > >   	} else if (dp->i_d.di_aformat =3D=3D XFS_DINODE_FMT_LOCAL) {
> > >   		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> > >   		error =3D xfs_attr_shortform_remove(args);
> > >   	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> > > -		error =3D xfs_attr_leaf_removename(args);
> > > +		error =3D xfs_attr_leaf_removename(dac);
> > >   	} else {
> > > -		error =3D xfs_attr_node_removename(args);
> > > +		error =3D xfs_attr_node_removename(dac);
> > >   	}
> > >   	return error;
>=20
> If we want to try and combine this into if/elses with no duplication, I
> believe the simplest arrangement would look something like this:
>=20
>=20
> int
> xfs_attr_remove_iter(
> 	struct xfs_delattr_context *dac)
> {
> 	struct xfs_da_args	*args =3D dac->da_args;
> 	struct xfs_inode	*dp =3D args->dp;
>=20
> 	if (dac->dela_state !=3D XFS_DAS_RM_SHRINK &&
> 	    dac->dela_state !=3D XFS_DAS_RMTVAL_REMOVE) {
> 		if (!xfs_inode_hasattr(dp)) {
> 			return -ENOATTR;
> 		} else if (dp->i_d.di_aformat =3D=3D XFS_DINODE_FMT_LOCAL) {
> 			ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> 			return xfs_attr_shortform_remove(args);
> 		} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> 			return xfs_attr_leaf_removename(dac);
> 		}
> 	}
>=20
> 	return xfs_attr_node_removename(dac);
> }
>=20
> Let me know what folks think of that.  I'm not always clear on where pe=
ople
> stand with aesthetics. (IE, is it better to have a duplicate call if it=
 gets
> rid of a label?  Is the solution with the least amount of LOC always
> preferable?)  This area seems simple enough maybe we can get it ironed =
out
> here with out another version.
>=20
> IMHO I think the above code sort of obfuscates that the code flow is re=
ally
> just one if/else switch with one function that has the statemachine
> behavior.  But its not bad either if that's what people prefer.  I'd li=
ke to
> find something every can be sort of happy with.  :-)
>=20

If you want my .02, some combination of the above is cleanest from an
aesthetic pov:

{
	...
	if (RM_SHRINK || RMTVAL_REMOVE)
		goto node;

	if (!hasattr)
		return -ENOATTR;
	else if (local)
		return shortform_remove();
	else if (oneblock)
		return leaf_removename();

node:
	return node_removename();
}

I find that easiest to read at a glance, but I don't feel terribly
strongly about it I guess.

> > > @@ -794,11 +849,12 @@ xfs_attr_leaf_hasname(
> > >    */
> > >   STATIC int
> > >   xfs_attr_leaf_removename(
> > > -	struct xfs_da_args	*args)
> > > +	struct xfs_delattr_context	*dac)
> > >   {
> > > -	struct xfs_inode	*dp;
> > > -	struct xfs_buf		*bp;
> > > -	int			error, forkoff;
> > > +	struct xfs_da_args		*args =3D dac->da_args;
> > > +	struct xfs_inode		*dp;
> > > +	struct xfs_buf			*bp;
> > > +	int				error, forkoff;
> > >   	trace_xfs_attr_leaf_removename(args);
> > > @@ -825,9 +881,8 @@ xfs_attr_leaf_removename(
> > >   		/* bp is gone due to xfs_da_shrink_inode */
> > >   		if (error)
> > >   			return error;
> > > -		error =3D xfs_defer_finish(&args->trans);
> > > -		if (error)
> > > -			return error;
> > > +
> > > +		dac->flags |=3D XFS_DAC_DEFER_FINISH;
> >=20
> > There's no -EAGAIN return here, is this an exit path for the remove?
> I think so, maybe I can remove this and the other one you pointed out i=
n
> patch 12 along with the other unneeded transaction handling.
>=20
> >=20
> > >   	}
> > >   	return 0;
> > >   }
> > > @@ -1128,12 +1183,13 @@ xfs_attr_node_addname(
> > >    */
> > >   STATIC int
> > >   xfs_attr_node_shrink(
> > > -	struct xfs_da_args	*args,
> > > -	struct xfs_da_state     *state)
> > > +	struct xfs_delattr_context	*dac,
> > > +	struct xfs_da_state		*state)
> > >   {
> > > -	struct xfs_inode	*dp =3D args->dp;
> > > -	int			error, forkoff;
> > > -	struct xfs_buf		*bp;
> > > +	struct xfs_da_args		*args =3D dac->da_args;
> > > +	struct xfs_inode		*dp =3D args->dp;
> > > +	int				error, forkoff;
> > > +	struct xfs_buf			*bp;
> > >   	/*
> > >   	 * Have to get rid of the copy of this dabuf in the state.
> > > @@ -1153,9 +1209,7 @@ xfs_attr_node_shrink(
> > >   		if (error)
> > >   			return error;
> > > -		error =3D xfs_defer_finish(&args->trans);
> > > -		if (error)
> > > -			return error;
> > > +		dac->flags |=3D XFS_DAC_DEFER_FINISH;
> >=20
> > Same question here.
> >=20
> > >   	} else
> > >   		xfs_trans_brelse(args->trans, bp);
> > > @@ -1194,13 +1248,15 @@ xfs_attr_leaf_mark_incomplete(
> > >   /*
> > >    * Initial setup for xfs_attr_node_removename.  Make sure the att=
r is there and
> > > - * the blocks are valid.  Any remote blocks will be marked incompl=
ete.
> > > + * the blocks are valid.  Any remote blocks will be marked incompl=
ete and
> > > + * invalidated.
> > >    */
> > >   STATIC
> > >   int xfs_attr_node_removename_setup(
> > > -	struct xfs_da_args	*args,
> > > -	struct xfs_da_state	**state)
> > > +	struct xfs_delattr_context	*dac,
> > > +	struct xfs_da_state		**state)
> > >   {
> > > +	struct xfs_da_args	*args =3D dac->da_args;
> > >   	int			error;
> > >   	struct xfs_da_state_blk	*blk;
> > > @@ -1212,10 +1268,21 @@ int xfs_attr_node_removename_setup(
> > >   	ASSERT(blk->bp !=3D NULL);
> > >   	ASSERT(blk->magic =3D=3D XFS_ATTR_LEAF_MAGIC);
> > > +	/*
> > > +	 * Store blk and state in the context incase we need to cycle out=
 the
> > > +	 * transaction
> > > +	 */
> > > +	dac->blk =3D blk;
> > > +	dac->da_state =3D *state;
> > > +
> > >   	if (args->rmtblkno > 0) {
> > >   		error =3D xfs_attr_leaf_mark_incomplete(args, *state);
> > >   		if (error)
> > >   			return error;
> > > +
> > > +		error =3D xfs_attr_rmtval_invalidate(args);
> > > +		if (error)
> > > +			return error;
> >=20
> > Seems like this moves code, which should probably happen in a separat=
e
> > patch.
> Ok, this pairs with the  xfs_attr_rmtval_remove to __xfs_attr_rmtval_re=
move
> below.  Basically xfs_attr_rmtval_remove is the combination of
> xfs_attr_rmtval_invalidate and __xfs_attr_rmtval_remove. So thats why w=
e see
> xfs_attr_rmtval_remove going away and xfs_attr_rmtval_invalidate +
> __xfs_attr_rmtval_remove coming in.
>=20
> How about a patch that pulls xfs_attr_rmtval_invalidate out of
> xfs_attr_rmtval_remove and into the calling functions?  I think that mi=
ght
> be more clear.
>=20

Yes, separate patch please. I think that if the earlier refactoring
parts of the series are split out properly (i.e., no dependencies on
subsequent patches) and reviewed, perhaps we can start getting some of
those patches merged while the latter bits are worked out.

> >=20
> > >   	}
> > >   	return 0;
> > > @@ -1228,7 +1295,10 @@ xfs_attr_node_removename_rmt (
> > >   {
> > >   	int			error =3D 0;
> > > -	error =3D xfs_attr_rmtval_remove(args);
> > > +	/*
> > > +	 * May return -EAGAIN to request that the caller recall this func=
tion
> > > +	 */
> > > +	error =3D __xfs_attr_rmtval_remove(args);
> > >   	if (error)
> > >   		return error;
> > > @@ -1249,19 +1319,37 @@ xfs_attr_node_removename_rmt (
> > >    * This will involve walking down the Btree, and may involve join=
ing
> > >    * leaf nodes and even joining intermediate nodes up to and inclu=
ding
> > >    * the root node (a special case of an intermediate node).
> > > + *
> > > + * This routine is meant to function as either an inline or delaye=
d operation,
> > > + * and may return -EAGAIN when the transaction needs to be rolled.=
  Calling
> > > + * functions will need to handle this, and recall the function unt=
il a
> > > + * successful error code is returned.
> > >    */
> > >   STATIC int
> > >   xfs_attr_node_removename(
> > > -	struct xfs_da_args	*args)
> > > +	struct xfs_delattr_context	*dac)
> > >   {
> > > +	struct xfs_da_args	*args =3D dac->da_args;
> > >   	struct xfs_da_state	*state;
> > >   	struct xfs_da_state_blk	*blk;
> > >   	int			retval, error;
> > >   	struct xfs_inode	*dp =3D args->dp;
> > >   	trace_xfs_attr_node_removename(args);
> > > +	state =3D dac->da_state;
> > > +	blk =3D dac->blk;
> > > +
> > > +	/* State machine switch */
> > > +	switch (dac->dela_state) {
> > > +	case XFS_DAS_RMTVAL_REMOVE:
> > > +		goto das_rmtval_remove;
> > > +	case XFS_DAS_RM_SHRINK:
> > > +		goto das_rm_shrink;
> > > +	default:
> > > +		break;
> > > +	}
> > > -	error =3D xfs_attr_node_removename_setup(args, &state);
> > > +	error =3D xfs_attr_node_removename_setup(dac, &state);
> > >   	if (error)
> > >   		goto out;
> > > @@ -1270,10 +1358,16 @@ xfs_attr_node_removename(
> > >   	 * This is done before we remove the attribute so that we don't
> > >   	 * overflow the maximum size of a transaction and/or hit a deadl=
ock.
> > >   	 */
> > > +
> > > +das_rmtval_remove:
> > > +
> >=20
> > I wonder if we need this label just to protect the setup. Perhaps if =
we
> > had something like:
> >=20
> > 	/* set up the remove only once... */
> > 	if (dela_state =3D=3D 0)
> > 		error =3D xfs_attr_node_removename_setup(...);
> >=20
> > ... we could reduce another state.
> >=20
> > We could also accomplish the same thing with an explicit state to
> > indicate the setup already occurred or a new dac flag, though I'm not
> > sure a flag is appropriate if it would only be used here.
> >=20
> > Brian
>=20
> Mmmm, dela_state =3D=3D 0 will conflict a bit when we get into fully de=
layed
> attrs.  Basically when this is getting called from the delayed operatio=
ns
> path, it sets dela_state to a new XFS_DAS_INIT. Because we have to set =
up
> args mid fight, we need the extra state to not do that twice.
>=20

Can we address that when the conflict is introduced?

> But even without getting into that right away, what you're proposing on=
ly
> gets rid of the label.  It doesnt get rid of the state.  We still have =
to
> set the state to not be zero (or what ever the initial value is).  So w=
e
> still need the unique value of  XFS_DAS_RMTVAL_REMOVE
>=20

Yeah, I was partly thinking of the setup call being tied to a flag
rather than a state. That way the logic is something like the typical:

	if (!setup)
		do_setup();
	...

... and it's one less bit of code tied into the state machine. All in
all, it's more that having a label right at the top of a function like
that kind of looks like it's asking for some form of simplification.

> Really what you would need here in order to do what you are describeing=
 is
> dela_state !=3D XFS_DAS_RMTVAL_REMOVE.  If I assume to simplify away to=
 the
> lease amount of LOC we get this:
>=20
>=20
> STATIC int
> xfs_attr_node_removename(
>         struct xfs_delattr_context      *dac)
> {
>         struct xfs_da_args      *args =3D dac->da_args;
>         struct xfs_da_state     *state;
>         struct xfs_da_state_blk *blk;
>         int                     retval, error;
>         struct xfs_inode        *dp =3D args->dp;
>=20
>         trace_xfs_attr_node_removename(args);
>         state =3D dac->da_state;
>         blk =3D dac->blk;
>=20
>         if (dac->dela_state =3D=3D XFS_DAS_RM_SHRINK) {
>                 goto das_rm_shrink;
>         } else if (dac->dela_state !=3D XFS_DAS_RMTVAL_REMOVE) {
>                 error =3D xfs_attr_node_removename_setup(dac, &state);
>                 if (error)
>                         goto out;
>         }
>=20
>         /*
>          * If there is an out-of-line value, de-allocate the blocks.
>          * This is done before we remove the attribute so that we don't
>          * overflow the maximum size of a transaction and/or hit a dead=
lock.
>          */
>=20
>         if (args->rmtblkno > 0) {
>                 error =3D xfs_attr_node_removename_rmt(args, state);
>                 if (error) {
>                         if (error =3D=3D -EAGAIN)
>                                 dac->dela_state =3D XFS_DAS_RMTVAL_REMO=
VE;
>                         return error;
>                 }
>         }
>=20
> .....
>=20
>=20
> Let me know what folks think of this.  Again, I think I like the switch=
es
> and the labels just because it makes it more clear where the jump point=
s
> are, even if its more LOC.  But again, this isnt bad either if this is =
more
> preferable to folks.  If there's another arrangment that is preferable,=
 let
> me know, it's not difficult to run it through the test cases to make su=
re
> it's functional.  It may be a faster way to hash out what people want t=
o
> see.
>=20

I prefer to see the state management stuff as boilerplate as possible.
The above pattern of creating separate reentry calls to the same
functions is not nearly as clear to me, particularly in this instance
where we have multiple branches of reentry logic (as opposed to the
earlier example of only one).

IOW, I agree that the jumps are preferable and more intuitive. I'm just
trying to be reductive by considering what could be factored out vs.
trying to fundamentally rework the approach or aggressively reduce LOC
or anything like that. IMO, simplicity of the code is usually top
priority.

Brian

> Thank you again for all the reviewing!!!
>=20
> Allison
>=20
> >=20
> > >   	if (args->rmtblkno > 0) {
> > >   		error =3D xfs_attr_node_removename_rmt(args, state);
> > > -		if (error)
> > > -			goto out;
> > > +		if (error) {
> > > +			if (error =3D=3D -EAGAIN)
> > > +				dac->dela_state =3D XFS_DAS_RMTVAL_REMOVE;
> > > +			return error;
> > > +		}
> > >   	}
> > >   	/*
> > > @@ -1291,22 +1385,20 @@ xfs_attr_node_removename(
> > >   		error =3D xfs_da3_join(state);
> > >   		if (error)
> > >   			goto out;
> > > -		error =3D xfs_defer_finish(&args->trans);
> > > -		if (error)
> > > -			goto out;
> > > -		/*
> > > -		 * Commit the Btree join operation and start a new trans.
> > > -		 */
> > > -		error =3D xfs_trans_roll_inode(&args->trans, dp);
> > > -		if (error)
> > > -			goto out;
> > > +
> > > +		dac->flags |=3D XFS_DAC_DEFER_FINISH;
> > > +		dac->dela_state =3D XFS_DAS_RM_SHRINK;
> > > +		return -EAGAIN;
> > >   	}
> > > +das_rm_shrink:
> > > +	dac->dela_state =3D XFS_DAS_RM_SHRINK;
> > > +
> > >   	/*
> > >   	 * If the result is small enough, push it all into the inode.
> > >   	 */
> > >   	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> > > -		error =3D xfs_attr_node_shrink(args, state);
> > > +		error =3D xfs_attr_node_shrink(dac, state);
> > >   	error =3D 0;
> > >   out:
> > > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > > index 66575b8..0e8ae1a 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.h
> > > +++ b/fs/xfs/libxfs/xfs_attr.h
> > > @@ -74,6 +74,43 @@ struct xfs_attr_list_context {
> > >   };
> > > +/*
> > > + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > > + * Structure used to pass context around among the delayed routine=
s.
> > > + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > > + */
> > > +
> > > +/*
> > > + * Enum values for xfs_delattr_context.da_state
> > > + *
> > > + * These values are used by delayed attribute operations to keep t=
rack  of where
> > > + * they were before they returned -EAGAIN.  A return code of -EAGA=
IN signals the
> > > + * calling function to roll the transaction, and then recall the s=
ubroutine to
> > > + * finish the operation.  The enum is then used by the subroutine =
to jump back
> > > + * to where it was and resume executing where it left off.
> > > + */
> > > +enum xfs_delattr_state {
> > > +				      /* Zero is uninitalized */
> > > +	XFS_DAS_RM_SHRINK	=3D 1,  /* We are shrinking the tree */
> > > +	XFS_DAS_RMTVAL_REMOVE,	      /* We are removing remote value bloc=
ks */
> > > +};
> > > +
> > > +/*
> > > + * Defines for xfs_delattr_context.flags
> > > + */
> > > +#define XFS_DAC_DEFER_FINISH    0x1 /* indicates to finish the tra=
nsaction */
> > > +
> > > +/*
> > > + * Context used for keeping track of delayed attribute operations
> > > + */
> > > +struct xfs_delattr_context {
> > > +	struct xfs_da_args      *da_args;
> > > +	struct xfs_da_state     *da_state;
> > > +	struct xfs_da_state_blk *blk;
> > > +	unsigned int            flags;
> > > +	enum xfs_delattr_state  dela_state;
> > > +};
> > > +
> > >   /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > >    * Function prototypes for the kernel.
> > >    *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D*/
> > > @@ -91,6 +128,7 @@ int xfs_attr_set(struct xfs_da_args *args);
> > >   int xfs_attr_set_args(struct xfs_da_args *args);
> > >   int xfs_has_attr(struct xfs_da_args *args);
> > >   int xfs_attr_remove_args(struct xfs_da_args *args);
> > > +int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
> > >   bool xfs_attr_namecheck(const void *name, size_t length);
> > >   #endif	/* __XFS_ATTR_H__ */
> > > --=20
> > > 2.7.4
> > >=20
> >=20
>=20


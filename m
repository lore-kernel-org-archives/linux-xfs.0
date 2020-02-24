Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD20CC11D2F
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 17:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DFBD2084E
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 17:03:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mn0pEJAL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgBXRDr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 12:03:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24739 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727421AbgBXRDr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 12:03:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582563824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CRJO862RFW7NibJMsZX8jySN2j/wBqjGwtpR3ofgr1w=;
        b=Mn0pEJALKpxZbEeq72Xz8J/aTitDrrGCVYYh8CwNy2FkzaawnWc7/EReDSZH2EJ+XEl3qw
        efktRH3oQyFf8frtpoi4hKFocbLTE2HS1w9M1ZT67thGI1iCHrr9W4Cw/OAi0i6rZ9Q0ge
        kKJ2Gf5gLtFeVjbliudxqh5aes/ow0E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-my82BNq1NiGZ_hbg_3oQfg-1; Mon, 24 Feb 2020 12:03:41 -0500
X-MC-Unique: my82BNq1NiGZ_hbg_3oQfg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEB26107B26F;
        Mon, 24 Feb 2020 17:03:40 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 285698C061;
        Mon, 24 Feb 2020 17:03:40 +0000 (UTC)
Date:   Mon, 24 Feb 2020 12:03:38 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 13/19] xfs: Add delay ready attr remove routines
Message-ID: <20200224170338.GH15761@bfoster>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-14-allison.henderson@oracle.com>
 <20200224152555.GG15761@bfoster>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20200224152555.GG15761@bfoster>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2020 at 10:25:55AM -0500, Brian Foster wrote:
> On Sat, Feb 22, 2020 at 07:06:05PM -0700, Allison Collins wrote:
> > This patch modifies the attr remove routines to be delay ready. This =
means they no
> > longer roll or commit transactions, but instead return -EAGAIN to hav=
e the calling
> > routine roll and refresh the transaction. In this series, xfs_attr_re=
move_args has
> > become xfs_attr_remove_iter, which uses a sort of state machine like =
switch to keep
> > track of where it was when EAGAIN was returned. xfs_attr_node_removen=
ame has also
> > been modified to use the switch, and a  new version of xfs_attr_remov=
e_args
> > consists of a simple loop to refresh the transaction until the operat=
ion is
> > completed.
> >=20
> > This patch also adds a new struct xfs_delattr_context, which we will =
use to keep
> > track of the current state of an attribute operation. The new xfs_del=
attr_state
> > enum is used to track various operations that are in progress so that=
 we know not
> > to repeat them, and resume where we left off before EAGAIN was return=
ed to cycle
> > out the transaction. Other members take the place of local variables =
that need
> > to retain their values across multiple function recalls.
> >=20
> > Below is a state machine diagram for attr remove operations. The XFS_=
DAS_* states
> > indicate places where the function would return -EAGAIN, and then imm=
ediately
> > resume from after being recalled by the calling function.  States mar=
ked as a
> > "subroutine state" indicate that they belong to a subroutine, and so =
the calling
> > function needs to pass them back to that subroutine to allow it to fi=
nish where
> > it left off. But they otherwise do not have a role in the calling fun=
ction other
> > than just passing through.
> >=20
> >  xfs_attr_remove_iter()
> >          XFS_DAS_RM_SHRINK     =E2=94=80=E2=94=90
> >          (subroutine state)     =E2=94=82
> >                                 =E2=94=82
> >          XFS_DAS_RMTVAL_REMOVE =E2=94=80=E2=94=A4
> >          (subroutine state)     =E2=94=82
> >                                 =E2=94=94=E2=94=80>xfs_attr_node_remo=
vename()
> >                                                  =E2=94=82
> >                                                  v
> >                                          need to remove
> >                                    =E2=94=8C=E2=94=80n=E2=94=80=E2=94=
=80  rmt blocks?
> >                                    =E2=94=82             =E2=94=82
> >                                    =E2=94=82             y
> >                                    =E2=94=82             =E2=94=82
> >                                    =E2=94=82             v
> >                                    =E2=94=82  =E2=94=8C=E2=94=80>XFS_=
DAS_RMTVAL_REMOVE
> >                                    =E2=94=82  =E2=94=82          =E2=94=
=82
> >                                    =E2=94=82  =E2=94=82          v
> >                                    =E2=94=82  =E2=94=94=E2=94=80=E2=94=
=80y=E2=94=80=E2=94=80 more blks
> >                                    =E2=94=82         to remove?
> >                                    =E2=94=82             =E2=94=82
> >                                    =E2=94=82             n
> >                                    =E2=94=82             =E2=94=82
> >                                    =E2=94=82             v
> >                                    =E2=94=82         need to
> >                                    =E2=94=94=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80> shrink tree? =E2=94=80n=E2=94=80=E2=94=90
> >                                                  =E2=94=82         =E2=
=94=82
> >                                                  y         =E2=94=82
> >                                                  =E2=94=82         =E2=
=94=82
> >                                                  v         =E2=94=82
> >                                          XFS_DAS_RM_SHRINK =E2=94=82
> >                                                  =E2=94=82         =E2=
=94=82
> >                                                  v         =E2=94=82
> >                                                 done <=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> >=20
>=20
> Wow. :P I guess I have nothing against verbose commit logs, but I wonde=
r
> how useful this level of documentation is for a patch that shouldn't
> really change the existing flow of the operation.
>=20
> > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c     | 114 +++++++++++++++++++++++++++++++++=
++++------
> >  fs/xfs/libxfs/xfs_attr.h     |   1 +
> >  fs/xfs/libxfs/xfs_da_btree.h |  30 ++++++++++++
> >  fs/xfs/scrub/common.c        |   2 +
> >  fs/xfs/xfs_acl.c             |   2 +
> >  fs/xfs/xfs_attr_list.c       |   1 +
> >  fs/xfs/xfs_ioctl.c           |   2 +
> >  fs/xfs/xfs_ioctl32.c         |   2 +
> >  fs/xfs/xfs_iops.c            |   2 +
> >  fs/xfs/xfs_xattr.c           |   1 +
> >  10 files changed, 141 insertions(+), 16 deletions(-)
> >=20
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 5d73bdf..cd3a3f7 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -368,11 +368,60 @@ xfs_has_attr(
> >   */
> >  int
> >  xfs_attr_remove_args(
> > +	struct xfs_da_args	*args)
> > +{
> > +	int			error =3D 0;
> > +	int			err2 =3D 0;
> > +
> > +	do {
> > +		error =3D xfs_attr_remove_iter(args);
> > +		if (error && error !=3D -EAGAIN)
> > +			goto out;
> > +
>=20
> I'm a little confused on the logic of this loop given that the only
> caller commits the transaction (which also finishes dfops). IOW, it
> seems we shouldn't ever need to finish/roll when error !=3D -EAGAIN. If
> that is the case, this can be simplified to something like:
>=20
> int
> xfs_attr_remove_args(
>         struct xfs_da_args      *args)
> {
>         int                     error;
>=20
>         do {
>                 error =3D xfs_attr_remove_iter(args);
>                 if (error !=3D -EAGAIN)
>                         break;
>=20
>                 if (args->dac.flags & XFS_DAC_FINISH_TRANS) {
>                         args->dac.flags &=3D ~XFS_DAC_FINISH_TRANS;
>                         error =3D xfs_defer_finish(&args->trans);
>                         if (error)
>                                 break;
>                 }
>=20
>                 error =3D xfs_trans_roll_inode(&args->trans, args->dp);
>                 if (error)
>                         break;
>         } while (true);
>=20
>         return error;
> }
>=20
> That has the added benefit of eliminating the whole err2 pattern, which
> always strikes me as a landmine.
>=20
> > +		if (args->dac.flags & XFS_DAC_FINISH_TRANS) {
>=20
> BTW, _FINISH_TRANS also seems misnamed given that we finish deferred
> operations, not necessarily the transaction. XFS_DAC_DEFER_FINISH?
>=20
> > +			args->dac.flags &=3D ~XFS_DAC_FINISH_TRANS;
> > +
> > +			err2 =3D xfs_defer_finish(&args->trans);
> > +			if (err2) {
> > +				error =3D err2;
> > +				goto out;
> > +			}
> > +		}
> > +
> > +		err2 =3D xfs_trans_roll_inode(&args->trans, args->dp);
> > +		if (err2) {
> > +			error =3D err2;
> > +			goto out;
> > +		}
> > +
> > +	} while (error =3D=3D -EAGAIN);
> > +out:
> > +	return error;
> > +}
> > +
> > +/*
> > + * Remove the attribute specified in @args.
> > + *
> > + * This function may return -EAGAIN to signal that the transaction n=
eeds to be
> > + * rolled.  Callers should continue calling this function until they=
 receive a
> > + * return value other than -EAGAIN.
> > + */
> > +int
> > +xfs_attr_remove_iter(
> >  	struct xfs_da_args      *args)
> >  {
> >  	struct xfs_inode	*dp =3D args->dp;
> >  	int			error;
> > =20
> > +	/* State machine switch */
> > +	switch (args->dac.dela_state) {
> > +	case XFS_DAS_RM_SHRINK:
> > +	case XFS_DAS_RMTVAL_REMOVE:
> > +		goto node;
> > +	default:
> > +		break;
> > +	}
> > +
> >  	if (!xfs_inode_hasattr(dp)) {
> >  		error =3D -ENOATTR;
> >  	} else if (dp->i_d.di_aformat =3D=3D XFS_DINODE_FMT_LOCAL) {
> > @@ -381,6 +430,7 @@ xfs_attr_remove_args(
> >  	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> >  		error =3D xfs_attr_leaf_removename(args);
> >  	} else {
> > +node:
> >  		error =3D xfs_attr_node_removename(args);
> >  	}
> > =20
> > @@ -895,9 +945,8 @@ xfs_attr_leaf_removename(
> >  		/* bp is gone due to xfs_da_shrink_inode */
> >  		if (error)
> >  			return error;
> > -		error =3D xfs_defer_finish(&args->trans);
> > -		if (error)
> > -			return error;
> > +
> > +		args->dac.flags |=3D XFS_DAC_FINISH_TRANS;
> >  	}
> >  	return 0;
> >  }
> > @@ -1218,6 +1267,11 @@ xfs_attr_node_addname(
> >   * This will involve walking down the Btree, and may involve joining
> >   * leaf nodes and even joining intermediate nodes up to and includin=
g
> >   * the root node (a special case of an intermediate node).
> > + *
> > + * This routine is meant to function as either an inline or delayed =
operation,
> > + * and may return -EAGAIN when the transaction needs to be rolled.  =
Calling
> > + * functions will need to handle this, and recall the function until=
 a
> > + * successful error code is returned.
> >   */
> >  STATIC int
> >  xfs_attr_node_removename(
> > @@ -1230,10 +1284,24 @@ xfs_attr_node_removename(
> >  	struct xfs_inode	*dp =3D args->dp;
> > =20
> >  	trace_xfs_attr_node_removename(args);
> > +	state =3D args->dac.da_state;
> > +	blk =3D args->dac.blk;
> > +
> > +	/* State machine switch */
> > +	switch (args->dac.dela_state) {
> > +	case XFS_DAS_RMTVAL_REMOVE:
> > +		goto rm_node_blks;
> > +	case XFS_DAS_RM_SHRINK:
> > +		goto rm_shrink;
> > +	default:
> > +		break;
> > +	}
> > =20
> >  	error =3D xfs_attr_node_hasname(args, &state);
> >  	if (error !=3D -EEXIST)
> >  		goto out;
> > +	else
> > +		error =3D 0;
>=20
> This doesn't look necessary.
>=20
> > =20
> >  	/*
> >  	 * If there is an out-of-line value, de-allocate the blocks.
> > @@ -1243,6 +1311,14 @@ xfs_attr_node_removename(
> >  	blk =3D &state->path.blk[ state->path.active-1 ];
> >  	ASSERT(blk->bp !=3D NULL);
> >  	ASSERT(blk->magic =3D=3D XFS_ATTR_LEAF_MAGIC);
> > +
> > +	/*
> > +	 * Store blk and state in the context incase we need to cycle out t=
he
> > +	 * transaction
> > +	 */
> > +	args->dac.blk =3D blk;
> > +	args->dac.da_state =3D state;
> > +
> >  	if (args->rmtblkno > 0) {
> >  		/*
> >  		 * Fill in disk block numbers in the state structure
> > @@ -1261,13 +1337,21 @@ xfs_attr_node_removename(
> >  		if (error)
> >  			goto out;
> > =20
> > -		error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> > +		error =3D xfs_attr_rmtval_invalidate(args);
>=20
> Remind me why we lose the above trans roll? I vaguely recall that this
> was intentional, but I could be mistaken...
>=20
> >  		if (error)
> >  			goto out;
> > +	}
> > =20
> > -		error =3D xfs_attr_rmtval_remove(args);
> > -		if (error)
> > -			goto out;
> > +rm_node_blks:
> > +
> > +	if (args->rmtblkno > 0) {
> > +		error =3D xfs_attr_rmtval_unmap(args);
> > +
> > +		if (error) {
> > +			if (error =3D=3D -EAGAIN)
> > +				args->dac.dela_state =3D XFS_DAS_RMTVAL_REMOVE;
>=20
> Might be helpful for the code labels to match the state names. I.e., us=
e
> das_rmtval_remove: for the label above.
>=20
> > +			return error;
> > +		}
> > =20
> >  		/*
> >  		 * Refill the state structure with buffers, the prior calls
> > @@ -1293,17 +1377,15 @@ xfs_attr_node_removename(
> >  		error =3D xfs_da3_join(state);
> >  		if (error)
> >  			goto out;
> > -		error =3D xfs_defer_finish(&args->trans);
> > -		if (error)
> > -			goto out;
> > -		/*
> > -		 * Commit the Btree join operation and start a new trans.
> > -		 */
> > -		error =3D xfs_trans_roll_inode(&args->trans, dp);
> > -		if (error)
> > -			goto out;
> > +
> > +		args->dac.flags |=3D XFS_DAC_FINISH_TRANS;
> > +		args->dac.dela_state =3D XFS_DAS_RM_SHRINK;
> > +		return -EAGAIN;
> >  	}
> > =20
> > +rm_shrink:
> > +	args->dac.dela_state =3D XFS_DAS_RM_SHRINK;
> > +
>=20
> There's an xfs_defer_finish() call further down this function. Should
> that be replaced with the flag?
>=20
> Finally, I mentioned in a previous review that this function should
> probably be further broken down before fitting in the state management
> stuff. It doesn't look like that happened so I've attached a diff that
> is just intended to give an idea of what I mean by sectioning off the
> hunks that might be able to break down into helpers. The helpers
> wouldn't contain any state management, so we create a clear separation
> between the state code and functional components. I think this initial
> refactoring would make the introduction of state much more simple (and
> perhaps alleviate the need for the huge diagram). It might also be
> interesting to see how much of the result could be folded up further
> into _removename_iter()...
>=20

Gah.. attached for real this time.

Brian

> Brian
>=20
> >  	/*
> >  	 * If the result is small enough, push it all into the inode.
> >  	 */
> > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > index ce7b039..ea873a5 100644
> > --- a/fs/xfs/libxfs/xfs_attr.h
> > +++ b/fs/xfs/libxfs/xfs_attr.h
> > @@ -155,6 +155,7 @@ int xfs_attr_set_args(struct xfs_da_args *args);
> >  int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int=
 flags);
> >  int xfs_has_attr(struct xfs_da_args *args);
> >  int xfs_attr_remove_args(struct xfs_da_args *args);
> > +int xfs_attr_remove_iter(struct xfs_da_args *args);
> >  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
> >  		  int flags, struct attrlist_cursor_kern *cursor);
> >  bool xfs_attr_namecheck(const void *name, size_t length);
> > diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btre=
e.h
> > index 14f1be3..3c78498 100644
> > --- a/fs/xfs/libxfs/xfs_da_btree.h
> > +++ b/fs/xfs/libxfs/xfs_da_btree.h
> > @@ -50,9 +50,39 @@ enum xfs_dacmp {
> >  };
> > =20
> >  /*
> > + * Enum values for xfs_delattr_context.da_state
> > + *
> > + * These values are used by delayed attribute operations to keep tra=
ck  of where
> > + * they were before they returned -EAGAIN.  A return code of -EAGAIN=
 signals the
> > + * calling function to roll the transaction, and then recall the sub=
routine to
> > + * finish the operation.  The enum is then used by the subroutine to=
 jump back
> > + * to where it was and resume executing where it left off.
> > + */
> > +enum xfs_delattr_state {
> > +	XFS_DAS_RM_SHRINK,	/* We are shrinking the tree */
> > +	XFS_DAS_RMTVAL_REMOVE,	/* We are removing remote value blocks */
> > +};
> > +
> > +/*
> > + * Defines for xfs_delattr_context.flags
> > + */
> > +#define	XFS_DAC_FINISH_TRANS	0x1 /* indicates to finish the transact=
ion */
> > +
> > +/*
> > + * Context used for keeping track of delayed attribute operations
> > + */
> > +struct xfs_delattr_context {
> > +	struct xfs_da_state	*da_state;
> > +	struct xfs_da_state_blk *blk;
> > +	unsigned int		flags;
> > +	enum xfs_delattr_state	dela_state;
> > +};
> > +
> > +/*
> >   * Structure to ease passing around component names.
> >   */
> >  typedef struct xfs_da_args {
> > +	struct xfs_delattr_context dac; /* context used for delay attr ops =
*/
> >  	struct xfs_da_geometry *geo;	/* da block geometry */
> >  	struct xfs_name	name;		/* name, length and argument  flags*/
> >  	uint8_t		filetype;	/* filetype of inode for directories */
> > diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> > index 1887605..9a649d1 100644
> > --- a/fs/xfs/scrub/common.c
> > +++ b/fs/xfs/scrub/common.c
> > @@ -24,6 +24,8 @@
> >  #include "xfs_rmap_btree.h"
> >  #include "xfs_log.h"
> >  #include "xfs_trans_priv.h"
> > +#include "xfs_da_format.h"
> > +#include "xfs_da_btree.h"
> >  #include "xfs_attr.h"
> >  #include "xfs_reflink.h"
> >  #include "scrub/scrub.h"
> > diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> > index 42ac847..d65e6d8 100644
> > --- a/fs/xfs/xfs_acl.c
> > +++ b/fs/xfs/xfs_acl.c
> > @@ -10,6 +10,8 @@
> >  #include "xfs_trans_resv.h"
> >  #include "xfs_mount.h"
> >  #include "xfs_inode.h"
> > +#include "xfs_da_format.h"
> > +#include "xfs_da_btree.h"
> >  #include "xfs_attr.h"
> >  #include "xfs_trace.h"
> >  #include "xfs_error.h"
> > diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> > index d37743b..881b9a4 100644
> > --- a/fs/xfs/xfs_attr_list.c
> > +++ b/fs/xfs/xfs_attr_list.c
> > @@ -12,6 +12,7 @@
> >  #include "xfs_trans_resv.h"
> >  #include "xfs_mount.h"
> >  #include "xfs_da_format.h"
> > +#include "xfs_da_btree.h"
> >  #include "xfs_inode.h"
> >  #include "xfs_trans.h"
> >  #include "xfs_bmap.h"
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 28c07c9..7c1d9da 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -15,6 +15,8 @@
> >  #include "xfs_iwalk.h"
> >  #include "xfs_itable.h"
> >  #include "xfs_error.h"
> > +#include "xfs_da_format.h"
> > +#include "xfs_da_btree.h"
> >  #include "xfs_attr.h"
> >  #include "xfs_bmap.h"
> >  #include "xfs_bmap_util.h"
> > diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> > index 769581a..d504f8f 100644
> > --- a/fs/xfs/xfs_ioctl32.c
> > +++ b/fs/xfs/xfs_ioctl32.c
> > @@ -17,6 +17,8 @@
> >  #include "xfs_itable.h"
> >  #include "xfs_fsops.h"
> >  #include "xfs_rtalloc.h"
> > +#include "xfs_da_format.h"
> > +#include "xfs_da_btree.h"
> >  #include "xfs_attr.h"
> >  #include "xfs_ioctl.h"
> >  #include "xfs_ioctl32.h"
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index e85bbf5..a2d299f 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -13,6 +13,8 @@
> >  #include "xfs_inode.h"
> >  #include "xfs_acl.h"
> >  #include "xfs_quota.h"
> > +#include "xfs_da_format.h"
> > +#include "xfs_da_btree.h"
> >  #include "xfs_attr.h"
> >  #include "xfs_trans.h"
> >  #include "xfs_trace.h"
> > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > index 74133a5..d8dc72d 100644
> > --- a/fs/xfs/xfs_xattr.c
> > +++ b/fs/xfs/xfs_xattr.c
> > @@ -10,6 +10,7 @@
> >  #include "xfs_log_format.h"
> >  #include "xfs_da_format.h"
> >  #include "xfs_inode.h"
> > +#include "xfs_da_btree.h"
> >  #include "xfs_attr.h"
> >  #include "xfs_acl.h"
> > =20
> > --=20
> > 2.7.4
> >=20
>=20

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xfs_attr_node_removename.diff"

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index cd3a3f75c429..e0eaa274b70b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1297,6 +1297,7 @@ xfs_attr_node_removename(
 		break;
 	}
 
+#if 0
 	error = xfs_attr_node_hasname(args, &state);
 	if (error != -EEXIST)
 		goto out;
@@ -1341,9 +1342,13 @@ xfs_attr_node_removename(
 		if (error)
 			goto out;
 	}
+#else
+	error = xfs_attr_node_removename_setup();
+#endif
 
 rm_node_blks:
 
+#if 0
 	if (args->rmtblkno > 0) {
 		error = xfs_attr_rmtval_unmap(args);
 
@@ -1361,6 +1366,11 @@ xfs_attr_node_removename(
 		if (error)
 			goto out;
 	}
+#else
+	args->dac.dela_state = XFS_DAS_RMTVAL_REMOVE;
+	error = xfs_attr_node_removename_rmt();
+	/* -EAGAIN */
+#endif
 
 	/*
 	 * Remove the name and update the hashvals in the tree.
@@ -1370,6 +1380,7 @@ xfs_attr_node_removename(
 	retval = xfs_attr3_leaf_remove(blk->bp, args);
 	xfs_da3_fixhashpath(state, &state->path);
 
+#if 0
 	/*
 	 * Check to see if the tree needs to be collapsed.
 	 */
@@ -1413,6 +1424,12 @@ xfs_attr_node_removename(
 			xfs_trans_brelse(args->trans, bp);
 	}
 	error = 0;
+#else
+rm_shrink:
+	args->dac.dela_state = XFS_DAS_RM_SHRINK;
+	error = xfs_attr_node_removename_shrink();
+	/* -EAGAIN */
+#endif
 
 out:
 	if (state)

--OXfL5xGRrasGEqWY--


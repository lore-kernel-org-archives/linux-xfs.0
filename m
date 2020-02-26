Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E24A3C4BA10
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 13:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99B7A24683
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 13:48:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RVyTDbio"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgBZNs3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 08:48:29 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59996 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726974AbgBZNs3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 08:48:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582724906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=boU6BNh5TPQo1UQuuuXj63haMDCujx2/k5Ihng10g2I=;
        b=RVyTDbio/1uID3E1x0P3wEpKCOshhobffN/P9n7zOu4f0hPzANv90ifibRGTAu1q/vudET
        X9JxdmLTulpqu0yBjLl5mNHl1gJmCvI5BYFckP3VSX1T2PRjQlsJ256rnVUCOts6xrCxT4
        vrOngjs/4cxiK539mn3ApyAaJRYY8JU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-OiF-LWWUOmuW0qC3SI7KpQ-1; Wed, 26 Feb 2020 08:48:23 -0500
X-MC-Unique: OiF-LWWUOmuW0qC3SI7KpQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8A411402;
        Wed, 26 Feb 2020 13:48:22 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F8C160BE1;
        Wed, 26 Feb 2020 13:48:22 +0000 (UTC)
Date:   Wed, 26 Feb 2020 08:48:20 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 13/19] xfs: Add delay ready attr remove routines
Message-ID: <20200226134820.GB19695@bfoster>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-14-allison.henderson@oracle.com>
 <20200224152555.GG15761@bfoster>
 <65a72135-01dd-7a7a-bfa4-5365512c3233@oracle.com>
 <20200225133426.GD21304@bfoster>
 <d1ce5ba7-99dd-82b1-a187-68dd4fab048e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d1ce5ba7-99dd-82b1-a187-68dd4fab048e@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 10:36:18PM -0700, Allison Collins wrote:
>=20
>=20
> On 2/25/20 6:34 AM, Brian Foster wrote:
> > On Mon, Feb 24, 2020 at 04:14:48PM -0700, Allison Collins wrote:
> > > On 2/24/20 8:25 AM, Brian Foster wrote:
> > > > On Sat, Feb 22, 2020 at 07:06:05PM -0700, Allison Collins wrote:
> > > > > This patch modifies the attr remove routines to be delay ready.=
 This means they no
> > > > > longer roll or commit transactions, but instead return -EAGAIN =
to have the calling
> > > > > routine roll and refresh the transaction. In this series, xfs_a=
ttr_remove_args has
> > > > > become xfs_attr_remove_iter, which uses a sort of state machine=
 like switch to keep
> > > > > track of where it was when EAGAIN was returned. xfs_attr_node_r=
emovename has also
> > > > > been modified to use the switch, and a  new version of xfs_attr=
_remove_args
> > > > > consists of a simple loop to refresh the transaction until the =
operation is
> > > > > completed.
> > > > >=20
> > > > > This patch also adds a new struct xfs_delattr_context, which we=
 will use to keep
> > > > > track of the current state of an attribute operation. The new x=
fs_delattr_state
> > > > > enum is used to track various operations that are in progress s=
o that we know not
> > > > > to repeat them, and resume where we left off before EAGAIN was =
returned to cycle
> > > > > out the transaction. Other members take the place of local vari=
ables that need
> > > > > to retain their values across multiple function recalls.
> > > > >=20
> > > > > Below is a state machine diagram for attr remove operations. Th=
e XFS_DAS_* states
> > > > > indicate places where the function would return -EAGAIN, and th=
en immediately
> > > > > resume from after being recalled by the calling function.  Stat=
es marked as a
> > > > > "subroutine state" indicate that they belong to a subroutine, a=
nd so the calling
> > > > > function needs to pass them back to that subroutine to allow it=
 to finish where
> > > > > it left off. But they otherwise do not have a role in the calli=
ng function other
> > > > > than just passing through.
> > > > >=20
> > > > >    xfs_attr_remove_iter()
> > > > >            XFS_DAS_RM_SHRINK     =E2=94=80=E2=94=90
> > > > >            (subroutine state)     =E2=94=82
> > > > >                                   =E2=94=82
> > > > >            XFS_DAS_RMTVAL_REMOVE =E2=94=80=E2=94=A4
> > > > >            (subroutine state)     =E2=94=82
> > > > >                                   =E2=94=94=E2=94=80>xfs_attr_n=
ode_removename()
> > > > >                                                    =E2=94=82
> > > > >                                                    v
> > > > >                                            need to remove
> > > > >                                      =E2=94=8C=E2=94=80n=E2=94=80=
=E2=94=80  rmt blocks?
> > > > >                                      =E2=94=82             =E2=94=
=82
> > > > >                                      =E2=94=82             y
> > > > >                                      =E2=94=82             =E2=94=
=82
> > > > >                                      =E2=94=82             v
> > > > >                                      =E2=94=82  =E2=94=8C=E2=94=
=80>XFS_DAS_RMTVAL_REMOVE
> > > > >                                      =E2=94=82  =E2=94=82      =
    =E2=94=82
> > > > >                                      =E2=94=82  =E2=94=82      =
    v
> > > > >                                      =E2=94=82  =E2=94=94=E2=94=
=80=E2=94=80y=E2=94=80=E2=94=80 more blks
> > > > >                                      =E2=94=82         to remov=
e?
> > > > >                                      =E2=94=82             =E2=94=
=82
> > > > >                                      =E2=94=82             n
> > > > >                                      =E2=94=82             =E2=94=
=82
> > > > >                                      =E2=94=82             v
> > > > >                                      =E2=94=82         need to
> > > > >                                      =E2=94=94=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80> shrink tree? =E2=94=80n=E2=94=80=E2=94=90
> > > > >                                                    =E2=94=82   =
      =E2=94=82
> > > > >                                                    y         =E2=
=94=82
> > > > >                                                    =E2=94=82   =
      =E2=94=82
> > > > >                                                    v         =E2=
=94=82
> > > > >                                            XFS_DAS_RM_SHRINK =E2=
=94=82
> > > > >                                                    =E2=94=82   =
      =E2=94=82
> > > > >                                                    v         =E2=
=94=82
> > > > >                                                   done <=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> > > > >=20
> > > >=20
> > > > Wow. :P I guess I have nothing against verbose commit logs, but I=
 wonder
> > > > how useful this level of documentation is for a patch that should=
n't
> > > > really change the existing flow of the operation.
> > >=20
> > > Yes Darrick had requested a diagram in the last review, so I had pu=
t this
> > > together.  I wasnt sure where the best place to put it even was, so=
 I put it
> > > here at least for now.  I have no idea if there is a limit on commi=
t message
> > > length, but if there is, I'm pretty sure I blew right past it in th=
is patch
> > > and the next.  Maybe if anything it can just be here for now while =
we work
> > > through things?
> > >=20
> >=20
> > No problem.. if it's useful it's good to have a record of out around
> > somewhere until the end result is more stabilized and we can determin=
e
> > whether this warrants a permanent home somewhere in the code.
> >=20
> > > >=20
> > > > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > > > ---
> > > > >    fs/xfs/libxfs/xfs_attr.c     | 114 +++++++++++++++++++++++++=
++++++++++++------
> > > > >    fs/xfs/libxfs/xfs_attr.h     |   1 +
> > > > >    fs/xfs/libxfs/xfs_da_btree.h |  30 ++++++++++++
> > > > >    fs/xfs/scrub/common.c        |   2 +
> > > > >    fs/xfs/xfs_acl.c             |   2 +
> > > > >    fs/xfs/xfs_attr_list.c       |   1 +
> > > > >    fs/xfs/xfs_ioctl.c           |   2 +
> > > > >    fs/xfs/xfs_ioctl32.c         |   2 +
> > > > >    fs/xfs/xfs_iops.c            |   2 +
> > > > >    fs/xfs/xfs_xattr.c           |   1 +
> > > > >    10 files changed, 141 insertions(+), 16 deletions(-)
> > > > >=20
> > > > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.=
c
> > > > > index 5d73bdf..cd3a3f7 100644
> > > > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > > > @@ -368,11 +368,60 @@ xfs_has_attr(
> > > > >     */
> > > > >    int
> > > > >    xfs_attr_remove_args(
> > > > > +	struct xfs_da_args	*args)
> > > > > +{
> > > > > +	int			error =3D 0;
> > > > > +	int			err2 =3D 0;
> > > > > +
> > > > > +	do {
> > > > > +		error =3D xfs_attr_remove_iter(args);
> > > > > +		if (error && error !=3D -EAGAIN)
> > > > > +			goto out;
> > > > > +
> > > >=20
> > > > I'm a little confused on the logic of this loop given that the on=
ly
> > > > caller commits the transaction (which also finishes dfops). IOW, =
it
> > > > seems we shouldn't ever need to finish/roll when error !=3D -EAGA=
IN. If
> > > > that is the case, this can be simplified to something like:
> > > Well, we need to do it when error =3D=3D -EAGAIN or 0, right? Which=
 I think
> > > better imitates the defer_finish routines.  That's why a lot of the=
 existing
> > > code that just finishes off with a transaction just sort of gets sa=
wed off
> > > at the end. Otherwise they would need one more state just to return=
 -EAGAIN
> > > as the last thing they have to do. Did that make sense?
> > >=20
> >=20
> > Hmm.. I could just be missing something or not far along enough in th=
e
> > series. Can you point me at an example of where we need to finish/rol=
l
> > before the caller of xfs_attr_remove_args() commits the transaction?
> >=20
> Ok, in looking for an example, realized all such examples appear in the=
 next
> patch ;-)  So maybe we can get away with simplifying it in this patch.
>=20

Ah, Ok. Yeah, I think that would be best so long as it is correct, since
right now at least we have separate xfs_attr_[set|remove]_args() loop
functions and I didn't see any code that warranted the extra roll in the
remove path.

> For the next patch though, it's any place the roll/finish disappears, a=
nd an
> "return -EAGAIN" does not.  For example, at the end of
> xfs_attr_leaf_addname.
>=20

I see, thanks. Hmmm... so I think that particular example is basically a
programming pattern thing moreso than a functional requirement. I.e.,
the current _clearflag() function clears the flag and rolls the
transaction perhaps simply so it can be reliably used in different
contexts. The use in the _addname() case is functionally spurious afaict
because we roll the transaction only to make no further changes and then
commit the final transaction in the higher level code.

I could see leaving the loop as is if this were the case for every exit
path back to xfs_attr_set_args(), but is that really the case? If not,
haven't we introduced a spurious roll for any zero return back to the
_args() function? I think it might be best to fix up the loop to not
roll on error =3D=3D 0, explicitly plumb in the -EAGAIN in those spurious
cases like _addname() where we currently roll, and then come up with a
follow up patch to remove the ones that end up as spurious. That way
we're not conflating too much refactoring with functional change and can
review/document the functional change independently (i.e., if removing
one of those rolls ends up introducing a bug, we don't have to revert an
entire refactoring patch to restore original behavior).

Now that I think of it, the better option is probably to remove the
xfs_trans_roll_inode() call from _addname() first, before these patches
introduce the delay ready infrastructure, since it's already isolated as
spurious at that point. That should be a simple patch with a
clear/obvious explanation.

Brian

> > > >=20
> > > > int
> > > > xfs_attr_remove_args(
> > > >           struct xfs_da_args      *args)
> > > > {
> > > >           int                     error;
> > > >=20
> > > >           do {
> > > >                   error =3D xfs_attr_remove_iter(args);
> > > >                   if (error !=3D -EAGAIN)
> > > >                           break;
> > > >=20
> > > >                   if (args->dac.flags & XFS_DAC_FINISH_TRANS) {
> > > >                           args->dac.flags &=3D ~XFS_DAC_FINISH_TR=
ANS;
> > > >                           error =3D xfs_defer_finish(&args->trans=
);
> > > >                           if (error)
> > > >                                   break;
> > > >                   }
> > > >=20
> > > >                   error =3D xfs_trans_roll_inode(&args->trans, ar=
gs->dp);
> > > >                   if (error)
> > > >                           break;
> > > >           } while (true);
> > > >=20
> > > >           return error;
> > > > }
> > > >=20
> > > > That has the added benefit of eliminating the whole err2 pattern,=
 which
> > > > always strikes me as a landmine.
> > > >=20
> > > > > +		if (args->dac.flags & XFS_DAC_FINISH_TRANS) {
> > > >=20
> > > > BTW, _FINISH_TRANS also seems misnamed given that we finish defer=
red
> > > > operations, not necessarily the transaction. XFS_DAC_DEFER_FINISH=
?
> > > Sure, will update
> > >=20
> > > >=20
> > > > > +			args->dac.flags &=3D ~XFS_DAC_FINISH_TRANS;
> > > > > +
> > > > > +			err2 =3D xfs_defer_finish(&args->trans);
> > > > > +			if (err2) {
> > > > > +				error =3D err2;
> > > > > +				goto out;
> > > > > +			}
> > > > > +		}
> > > > > +
> > > > > +		err2 =3D xfs_trans_roll_inode(&args->trans, args->dp);
> > > > > +		if (err2) {
> > > > > +			error =3D err2;
> > > > > +			goto out;
> > > > > +		}
> > > > > +
> > > > > +	} while (error =3D=3D -EAGAIN);
> > > > > +out:
> > > > > +	return error;
> > > > > +}
> > > > > +
> > > > > +/*
> > > > > + * Remove the attribute specified in @args.
> > > > > + *
> > > > > + * This function may return -EAGAIN to signal that the transac=
tion needs to be
> > > > > + * rolled.  Callers should continue calling this function unti=
l they receive a
> > > > > + * return value other than -EAGAIN.
> > > > > + */
> > > > > +int
> > > > > +xfs_attr_remove_iter(
> > > > >    	struct xfs_da_args      *args)
> > > > >    {
> > > > >    	struct xfs_inode	*dp =3D args->dp;
> > > > >    	int			error;
> > > > > +	/* State machine switch */
> > > > > +	switch (args->dac.dela_state) {
> > > > > +	case XFS_DAS_RM_SHRINK:
> > > > > +	case XFS_DAS_RMTVAL_REMOVE:
> > > > > +		goto node;
> > > > > +	default:
> > > > > +		break;
> > > > > +	}
> > > > > +
> > > > >    	if (!xfs_inode_hasattr(dp)) {
> > > > >    		error =3D -ENOATTR;
> > > > >    	} else if (dp->i_d.di_aformat =3D=3D XFS_DINODE_FMT_LOCAL) =
{
> > > > > @@ -381,6 +430,7 @@ xfs_attr_remove_args(
> > > > >    	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> > > > >    		error =3D xfs_attr_leaf_removename(args);
> > > > >    	} else {
> > > > > +node:
> > > > >    		error =3D xfs_attr_node_removename(args);
> > > > >    	}
> > > > > @@ -895,9 +945,8 @@ xfs_attr_leaf_removename(
> > > > >    		/* bp is gone due to xfs_da_shrink_inode */
> > > > >    		if (error)
> > > > >    			return error;
> > > > > -		error =3D xfs_defer_finish(&args->trans);
> > > > > -		if (error)
> > > > > -			return error;
> > > > > +
> > > > > +		args->dac.flags |=3D XFS_DAC_FINISH_TRANS;
> > > > >    	}
> > > > >    	return 0;
> > > > >    }
> > > > > @@ -1218,6 +1267,11 @@ xfs_attr_node_addname(
> > > > >     * This will involve walking down the Btree, and may involve=
 joining
> > > > >     * leaf nodes and even joining intermediate nodes up to and =
including
> > > > >     * the root node (a special case of an intermediate node).
> > > > > + *
> > > > > + * This routine is meant to function as either an inline or de=
layed operation,
> > > > > + * and may return -EAGAIN when the transaction needs to be rol=
led.  Calling
> > > > > + * functions will need to handle this, and recall the function=
 until a
> > > > > + * successful error code is returned.
> > > > >     */
> > > > >    STATIC int
> > > > >    xfs_attr_node_removename(
> > > > > @@ -1230,10 +1284,24 @@ xfs_attr_node_removename(
> > > > >    	struct xfs_inode	*dp =3D args->dp;
> > > > >    	trace_xfs_attr_node_removename(args);
> > > > > +	state =3D args->dac.da_state;
> > > > > +	blk =3D args->dac.blk;
> > > > > +
> > > > > +	/* State machine switch */
> > > > > +	switch (args->dac.dela_state) {
> > > > > +	case XFS_DAS_RMTVAL_REMOVE:
> > > > > +		goto rm_node_blks;
> > > > > +	case XFS_DAS_RM_SHRINK:
> > > > > +		goto rm_shrink;
> > > > > +	default:
> > > > > +		break;
> > > > > +	}
> > > > >    	error =3D xfs_attr_node_hasname(args, &state);
> > > > >    	if (error !=3D -EEXIST)
> > > > >    		goto out;
> > > > > +	else
> > > > > +		error =3D 0;
> > > >=20
> > > > This doesn't look necessary.
> > > Well, at this point error has to be -EEXIST.  Which is great becaus=
e we need
> > > the attr to exist, but we dont want to return that as error for thi=
s
> > > function.  Which can happen if error is not otherwise set.
> > >=20
> >=20
> > AFAICT every codepath after this assigns error one way or another bef=
ore
> > it's returned. There's another error =3D 0 assignment just before the=
 out:
> > label.
> Ok, I see it.  Will remove.
>=20
> >=20
> > > >=20
> > > > >    	/*
> > > > >    	 * If there is an out-of-line value, de-allocate the blocks=
.
> > > > > @@ -1243,6 +1311,14 @@ xfs_attr_node_removename(
> > > > >    	blk =3D &state->path.blk[ state->path.active-1 ];
> > > > >    	ASSERT(blk->bp !=3D NULL);
> > > > >    	ASSERT(blk->magic =3D=3D XFS_ATTR_LEAF_MAGIC);
> > > > > +
> > > > > +	/*
> > > > > +	 * Store blk and state in the context incase we need to cycle=
 out the
> > > > > +	 * transaction
> > > > > +	 */
> > > > > +	args->dac.blk =3D blk;
> > > > > +	args->dac.da_state =3D state;
> > > > > +
> > > > >    	if (args->rmtblkno > 0) {
> > > > >    		/*
> > > > >    		 * Fill in disk block numbers in the state structure
> > > > > @@ -1261,13 +1337,21 @@ xfs_attr_node_removename(
> > > > >    		if (error)
> > > > >    			goto out;
> > > > > -		error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> > > > > +		error =3D xfs_attr_rmtval_invalidate(args);
> > > >=20
> > > > Remind me why we lose the above trans roll? I vaguely recall that=
 this
> > > > was intentional, but I could be mistaken...
> > > I think we removed it in v5.  We used to have a  XFS_DAS_RM_INVALID=
ATE
> > > state, but then we reasoned that because these are just in-core cha=
nges, we
> > > didnt need it, so we eliminated this state entirely.
> > >=20
> > > Maybe i just add a comment here?  Just as a reminder
> > >=20
> >=20
> > Ah, Ok. Normally I'd say document things like this in the commit log =
so
> > we don't lose track, though I don't know how much space we have there=
.
> > ;)
> Ok, I'll see if I can squeeze in a few more lines :-)
>=20
> >=20
> > > >=20
> > > > >    		if (error)
> > > > >    			goto out;
> > > > > +	}
> > > > > -		error =3D xfs_attr_rmtval_remove(args);
> > > > > -		if (error)
> > > > > -			goto out;
> > > > > +rm_node_blks:
> > > > > +
> > > > > +	if (args->rmtblkno > 0) {
> > > > > +		error =3D xfs_attr_rmtval_unmap(args);
> > > > > +
> > > > > +		if (error) {
> > > > > +			if (error =3D=3D -EAGAIN)
> > > > > +				args->dac.dela_state =3D XFS_DAS_RMTVAL_REMOVE;
> > > >=20
> > > > Might be helpful for the code labels to match the state names. I.=
e., use
> > > > das_rmtval_remove: for the label above.
> > > Sure, I can update add the das prefix.
> > >=20
> > > >=20
> > > > > +			return error;
> > > > > +		}
> > > > >    		/*
> > > > >    		 * Refill the state structure with buffers, the prior call=
s
> > > > > @@ -1293,17 +1377,15 @@ xfs_attr_node_removename(
> > > > >    		error =3D xfs_da3_join(state);
> > > > >    		if (error)
> > > > >    			goto out;
> > > > > -		error =3D xfs_defer_finish(&args->trans);
> > > > > -		if (error)
> > > > > -			goto out;
> > > > > -		/*
> > > > > -		 * Commit the Btree join operation and start a new trans.
> > > > > -		 */
> > > > > -		error =3D xfs_trans_roll_inode(&args->trans, dp);
> > > > > -		if (error)
> > > > > -			goto out;
> > > > > +
> > > > > +		args->dac.flags |=3D XFS_DAC_FINISH_TRANS;
> > > > > +		args->dac.dela_state =3D XFS_DAS_RM_SHRINK;
> > > > > +		return -EAGAIN;
> > > > >    	}
> > > > > +rm_shrink:
> > > > > +	args->dac.dela_state =3D XFS_DAS_RM_SHRINK;
> > > > > +
> > > >=20
> > > > There's an xfs_defer_finish() call further down this function. Sh=
ould
> > > > that be replaced with the flag?
> > > >=20
> > > > Finally, I mentioned in a previous review that this function shou=
ld
> > > > probably be further broken down before fitting in the state manag=
ement
> > > > stuff. It doesn't look like that happened so I've attached a diff=
 that
> > > > is just intended to give an idea of what I mean by sectioning off=
 the
> > > > hunks that might be able to break down into helpers. The helpers
> > > > wouldn't contain any state management, so we create a clear separ=
ation
> > > > between the state code and functional components.
> > > Yes, it's xfs_attr_node_shrink in patch 15.  I moved it to another =
patch to
> > > try and keep the activity in this one to a minimum.  Apologies if i=
t
> > > surprised you!  And then i mistakenly had taken the XFS_DAC_FINISH_=
TRANS
> > > flag with it.  I meant to keep all the state machine stuff here.  W=
ill fix!
> > >=20
> >=20
> > Ok, I might have just not got there yet.
> >=20
> > > I think this initial
> > > > refactoring would make the introduction of state much more simple
> > >=20
> > > I guess I didn't think people would be partial to introducing helpe=
rs before
> > > or after the state logic.  I put them after in this set because the=
 states
> > > are visible now, so I though it would make the goal of modularizing=
 code
> > > between the states more clear to folks.  Do you think I should move=
 it back
> > > behind the state machine patches?
> > >=20
> >=20
> > I do think the refactoring should be done first. This does make it mo=
re
> > challenging for the developer (IMO) because I know I'd probably have =
to
> > hack around with the state bits to have a better idea of how to refac=
tor
> > things in some cases, and then go back and retrofit the refactoring.
> >=20
> > The advantage is that the heavy lifting in this series becomes agnost=
ic
> > to the state bits. Refactoring patches are easier to review and we ca=
n
> > make progress because there's less of a need to carry those out of tr=
ee
> > through however many versions of the state code we'll need before
> > getting it merged. Once the code is sufficiently factored, the state
> > code should be much simpler to introduce and review since we hopefull=
y
> > won't be jumping around into the middle of functions, multiple branch=
es
> > of logic deep, etc.
> >=20
> > (I see Dave commented similarly on a couple of the subsequent patches=
. I
> > 100% agree with the approach he describes there and that is similar t=
o
> > what I was trying to describe with the diff I attached in my earlier
> > mail...)
> >=20
> > Brian
>=20
> Alrighty then, will move back.  Thanks, and thanks again for the review=
s!!
>=20
> Allison
>=20
> >=20
> > > (and
> > > > perhaps alleviate the need for the huge diagram).
> > > Well, I get the impression that people find the series sort of scar=
y and
> > > maybe the diagrams help them a bit.  Maybe we can take them out lat=
er after
> > > people feel like they are comfortable with things?
> > >=20
> > > It might also be
> > > > interesting to see how much of the result could be folded up furt=
her
> > > > into _removename_iter()...
> > >=20
> > > Yes, I think that is the goal we're reaching for.  I will add the o=
ther
> > > helpers I see in your diff too.
> > >=20
> > > Thanks for the reviews!
> > > Allison
> > >=20
> > > >=20
> > > > Brian
> > > >=20
> > > > >    	/*
> > > > >    	 * If the result is small enough, push it all into the inod=
e.
> > > > >    	 */
> > > > > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.=
h
> > > > > index ce7b039..ea873a5 100644
> > > > > --- a/fs/xfs/libxfs/xfs_attr.h
> > > > > +++ b/fs/xfs/libxfs/xfs_attr.h
> > > > > @@ -155,6 +155,7 @@ int xfs_attr_set_args(struct xfs_da_args *a=
rgs);
> > > > >    int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *n=
ame, int flags);
> > > > >    int xfs_has_attr(struct xfs_da_args *args);
> > > > >    int xfs_attr_remove_args(struct xfs_da_args *args);
> > > > > +int xfs_attr_remove_iter(struct xfs_da_args *args);
> > > > >    int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bu=
fsize,
> > > > >    		  int flags, struct attrlist_cursor_kern *cursor);
> > > > >    bool xfs_attr_namecheck(const void *name, size_t length);
> > > > > diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_d=
a_btree.h
> > > > > index 14f1be3..3c78498 100644
> > > > > --- a/fs/xfs/libxfs/xfs_da_btree.h
> > > > > +++ b/fs/xfs/libxfs/xfs_da_btree.h
> > > > > @@ -50,9 +50,39 @@ enum xfs_dacmp {
> > > > >    };
> > > > >    /*
> > > > > + * Enum values for xfs_delattr_context.da_state
> > > > > + *
> > > > > + * These values are used by delayed attribute operations to ke=
ep track  of where
> > > > > + * they were before they returned -EAGAIN.  A return code of -=
EAGAIN signals the
> > > > > + * calling function to roll the transaction, and then recall t=
he subroutine to
> > > > > + * finish the operation.  The enum is then used by the subrout=
ine to jump back
> > > > > + * to where it was and resume executing where it left off.
> > > > > + */
> > > > > +enum xfs_delattr_state {
> > > > > +	XFS_DAS_RM_SHRINK,	/* We are shrinking the tree */
> > > > > +	XFS_DAS_RMTVAL_REMOVE,	/* We are removing remote value blocks=
 */
> > > > > +};
> > > > > +
> > > > > +/*
> > > > > + * Defines for xfs_delattr_context.flags
> > > > > + */
> > > > > +#define	XFS_DAC_FINISH_TRANS	0x1 /* indicates to finish the tr=
ansaction */
> > > > > +
> > > > > +/*
> > > > > + * Context used for keeping track of delayed attribute operati=
ons
> > > > > + */
> > > > > +struct xfs_delattr_context {
> > > > > +	struct xfs_da_state	*da_state;
> > > > > +	struct xfs_da_state_blk *blk;
> > > > > +	unsigned int		flags;
> > > > > +	enum xfs_delattr_state	dela_state;
> > > > > +};
> > > > > +
> > > > > +/*
> > > > >     * Structure to ease passing around component names.
> > > > >     */
> > > > >    typedef struct xfs_da_args {
> > > > > +	struct xfs_delattr_context dac; /* context used for delay att=
r ops */
> > > > >    	struct xfs_da_geometry *geo;	/* da block geometry */
> > > > >    	struct xfs_name	name;		/* name, length and argument  flags*=
/
> > > > >    	uint8_t		filetype;	/* filetype of inode for directories */
> > > > > diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> > > > > index 1887605..9a649d1 100644
> > > > > --- a/fs/xfs/scrub/common.c
> > > > > +++ b/fs/xfs/scrub/common.c
> > > > > @@ -24,6 +24,8 @@
> > > > >    #include "xfs_rmap_btree.h"
> > > > >    #include "xfs_log.h"
> > > > >    #include "xfs_trans_priv.h"
> > > > > +#include "xfs_da_format.h"
> > > > > +#include "xfs_da_btree.h"
> > > > >    #include "xfs_attr.h"
> > > > >    #include "xfs_reflink.h"
> > > > >    #include "scrub/scrub.h"
> > > > > diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> > > > > index 42ac847..d65e6d8 100644
> > > > > --- a/fs/xfs/xfs_acl.c
> > > > > +++ b/fs/xfs/xfs_acl.c
> > > > > @@ -10,6 +10,8 @@
> > > > >    #include "xfs_trans_resv.h"
> > > > >    #include "xfs_mount.h"
> > > > >    #include "xfs_inode.h"
> > > > > +#include "xfs_da_format.h"
> > > > > +#include "xfs_da_btree.h"
> > > > >    #include "xfs_attr.h"
> > > > >    #include "xfs_trace.h"
> > > > >    #include "xfs_error.h"
> > > > > diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> > > > > index d37743b..881b9a4 100644
> > > > > --- a/fs/xfs/xfs_attr_list.c
> > > > > +++ b/fs/xfs/xfs_attr_list.c
> > > > > @@ -12,6 +12,7 @@
> > > > >    #include "xfs_trans_resv.h"
> > > > >    #include "xfs_mount.h"
> > > > >    #include "xfs_da_format.h"
> > > > > +#include "xfs_da_btree.h"
> > > > >    #include "xfs_inode.h"
> > > > >    #include "xfs_trans.h"
> > > > >    #include "xfs_bmap.h"
> > > > > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > > > > index 28c07c9..7c1d9da 100644
> > > > > --- a/fs/xfs/xfs_ioctl.c
> > > > > +++ b/fs/xfs/xfs_ioctl.c
> > > > > @@ -15,6 +15,8 @@
> > > > >    #include "xfs_iwalk.h"
> > > > >    #include "xfs_itable.h"
> > > > >    #include "xfs_error.h"
> > > > > +#include "xfs_da_format.h"
> > > > > +#include "xfs_da_btree.h"
> > > > >    #include "xfs_attr.h"
> > > > >    #include "xfs_bmap.h"
> > > > >    #include "xfs_bmap_util.h"
> > > > > diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> > > > > index 769581a..d504f8f 100644
> > > > > --- a/fs/xfs/xfs_ioctl32.c
> > > > > +++ b/fs/xfs/xfs_ioctl32.c
> > > > > @@ -17,6 +17,8 @@
> > > > >    #include "xfs_itable.h"
> > > > >    #include "xfs_fsops.h"
> > > > >    #include "xfs_rtalloc.h"
> > > > > +#include "xfs_da_format.h"
> > > > > +#include "xfs_da_btree.h"
> > > > >    #include "xfs_attr.h"
> > > > >    #include "xfs_ioctl.h"
> > > > >    #include "xfs_ioctl32.h"
> > > > > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > > > > index e85bbf5..a2d299f 100644
> > > > > --- a/fs/xfs/xfs_iops.c
> > > > > +++ b/fs/xfs/xfs_iops.c
> > > > > @@ -13,6 +13,8 @@
> > > > >    #include "xfs_inode.h"
> > > > >    #include "xfs_acl.h"
> > > > >    #include "xfs_quota.h"
> > > > > +#include "xfs_da_format.h"
> > > > > +#include "xfs_da_btree.h"
> > > > >    #include "xfs_attr.h"
> > > > >    #include "xfs_trans.h"
> > > > >    #include "xfs_trace.h"
> > > > > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > > > > index 74133a5..d8dc72d 100644
> > > > > --- a/fs/xfs/xfs_xattr.c
> > > > > +++ b/fs/xfs/xfs_xattr.c
> > > > > @@ -10,6 +10,7 @@
> > > > >    #include "xfs_log_format.h"
> > > > >    #include "xfs_da_format.h"
> > > > >    #include "xfs_inode.h"
> > > > > +#include "xfs_da_btree.h"
> > > > >    #include "xfs_attr.h"
> > > > >    #include "xfs_acl.h"
> > > > > --=20
> > > > > 2.7.4
> > > > >=20
> > > >=20
> > >=20
> >=20
>=20


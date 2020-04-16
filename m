Return-Path: <SRS0=bcFD=6A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 466B8C2BB85
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Apr 2020 11:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09012208E4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Apr 2020 11:02:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dimjygBL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505442AbgDPLCY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 07:02:24 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42966 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2505958AbgDPLBQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Apr 2020 07:01:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587034872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=86gKZjNUxfQd8tsK3ufG0hUy+4kINnviOhnhLaSB1vQ=;
        b=dimjygBLGN1NQRtZvFv6nyna2JbzxuUoZ9SKJ9oRWS8kfqIZVn7izD52sajCCwLLOda/uh
        DtZ9F90DLUBgUP98hHCbroPAl90mGX0afg+EoxrjO47WGV138fOiDD/R4oQzgCI4fQ2A/g
        VadLq3qdfv7SJ2bzXOO6Oh4NQvzkAJ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-FtHnnNs0OGiqEfK6lTLgUw-1; Thu, 16 Apr 2020 07:01:10 -0400
X-MC-Unique: FtHnnNs0OGiqEfK6lTLgUw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 660D613F7;
        Thu, 16 Apr 2020 11:01:09 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B215B1036D03;
        Thu, 16 Apr 2020 11:01:08 +0000 (UTC)
Date:   Thu, 16 Apr 2020 07:01:06 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 19/20] xfs: Add delay ready attr set routines
Message-ID: <20200416110106.GB6945@bfoster>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-20-allison.henderson@oracle.com>
 <20200413134035.GD57285@bfoster>
 <75c97cd3-8953-3e8d-232b-53e09d76675b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <75c97cd3-8953-3e8d-232b-53e09d76675b@oracle.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 15, 2020 at 03:08:11PM -0700, Allison Collins wrote:
>=20
>=20
> On 4/13/20 6:40 AM, Brian Foster wrote:
> > On Fri, Apr 03, 2020 at 03:12:28PM -0700, Allison Collins wrote:
> > > This patch modifies the attr set routines to be delay ready. This m=
eans
> > > they no longer roll or commit transactions, but instead return -EAG=
AIN
> > > to have the calling routine roll and refresh the transaction.  In t=
his
> > > series, xfs_attr_set_args has become xfs_attr_set_iter, which uses =
a
> > > state machine like switch to keep track of where it was when EAGAIN=
 was
> > > returned.
> > >=20
> > > Two new helper functions have been added: xfs_attr_rmtval_set_init =
and
> > > xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
> > > xfs_attr_rmtval_set, but they store the current block in the delay =
attr
> > > context to allow the caller to roll the transaction between allocat=
ions.
> > > This helps to simplify and consolidate code used by
> > > xfs_attr_leaf_addname and xfs_attr_node_addname. xfs_attr_set_args =
has
> > > now become a simple loop to refresh the transaction until the opera=
tion
> > > is completed.  Lastly, xfs_attr_rmtval_remove is no longer used, an=
d is
> > > removed.
> > >=20
> > > Below is a state machine diagram for attr set operations. The XFS_D=
AS_*
> > > states indicate places where the function would return -EAGAIN, and=
 then
> > > immediately resume from after being recalled by the calling functio=
n.
> > > States marked as a "subroutine state" indicate that they belong to =
a
> > > subroutine, and so the calling function needs to pass them back to =
that
> > > subroutine to allow it to finish where it left off.  But they other=
wise
> > > do not have a role in the calling function other than just passing
> > > through.
> > >=20
> > >   xfs_attr_set_iter()
> > >                   =E2=94=82
> > >                   v
> > >             need to upgrade
> > >            from sf to leaf? =E2=94=80=E2=94=80n=E2=94=80=E2=94=90
> > >                   =E2=94=82             =E2=94=82
> > >                   y             =E2=94=82
> > >                   =E2=94=82             =E2=94=82
> > >                   V             =E2=94=82
> > >            XFS_DAS_ADD_LEAF     =E2=94=82
> > >                   =E2=94=82             =E2=94=82
> > >                   v             =E2=94=82
> > >    =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80n=
=E2=94=80=E2=94=80 fork has   <=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=98
> > >    =E2=94=82         only 1 blk?
> > >    =E2=94=82              =E2=94=82
> > >    =E2=94=82              y
> > >    =E2=94=82              =E2=94=82
> > >    =E2=94=82              v
> > >    =E2=94=82     xfs_attr_leaf_try_add()
> > >    =E2=94=82              =E2=94=82
> > >    =E2=94=82              v
> > >    =E2=94=82          had enough
> > >    =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80n=
=E2=94=80=E2=94=80   space?
> > >    =E2=94=82              =E2=94=82
> > >    =E2=94=82              y
> > >    =E2=94=82              =E2=94=82
> > >    =E2=94=82              v
> > >    =E2=94=82      XFS_DAS_FOUND_LBLK  =E2=94=80=E2=94=80=E2=94=90
> > >    =E2=94=82                            =E2=94=82
> > >    =E2=94=82      XFS_DAS_FLIP_LFLAG  =E2=94=80=E2=94=80=E2=94=A4
> > >    =E2=94=82      (subroutine state)    =E2=94=82
> > >    =E2=94=82                            =E2=94=82
> > >    =E2=94=82      XFS_DAS_ALLOC_LEAF  =E2=94=80=E2=94=80=E2=94=A4
> > >    =E2=94=82      (subroutine state)    =E2=94=82
> > >    =E2=94=82                            =E2=94=94=E2=94=80>xfs_attr=
_leaf_addname()
> > >    =E2=94=82                                              =E2=94=82
> > >    =E2=94=82                                              v
> > >    =E2=94=82                                =E2=94=8C=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80n=E2=94=80=E2=94=80  need to
> > >    =E2=94=82                                =E2=94=82        alloc =
blks?
> > >    =E2=94=82                                =E2=94=82             =E2=
=94=82
> > >    =E2=94=82                                =E2=94=82             y
> > >    =E2=94=82                                =E2=94=82             =E2=
=94=82
> > >    =E2=94=82                                =E2=94=82             v
> > >    =E2=94=82                                =E2=94=82  =E2=94=8C=E2=
=94=80>XFS_DAS_ALLOC_LEAF
> > >    =E2=94=82                                =E2=94=82  =E2=94=82   =
       =E2=94=82
> > >    =E2=94=82                                =E2=94=82  =E2=94=82   =
       v
> > >    =E2=94=82                                =E2=94=82  =E2=94=94=E2=
=94=80=E2=94=80y=E2=94=80=E2=94=80 need to alloc
> > >    =E2=94=82                                =E2=94=82         more =
blocks?
> > >    =E2=94=82                                =E2=94=82             =E2=
=94=82
> > >    =E2=94=82                                =E2=94=82             n
> > >    =E2=94=82                                =E2=94=82             =E2=
=94=82
> > >    =E2=94=82                                =E2=94=82             v
> > >    =E2=94=82                                =E2=94=82          was =
this
> > >    =E2=94=82                                =E2=94=94=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80> a rename? =E2=94=
=80=E2=94=80n=E2=94=80=E2=94=90
> > >    =E2=94=82                                              =E2=94=82=
          =E2=94=82
> > >    =E2=94=82                                              y        =
  =E2=94=82
> > >    =E2=94=82                                              =E2=94=82=
          =E2=94=82
> > >    =E2=94=82                                              v        =
  =E2=94=82
> > >    =E2=94=82                                        flip incomplete=
  =E2=94=82
> > >    =E2=94=82                                            flag       =
  =E2=94=82
> > >    =E2=94=82                                              =E2=94=82=
          =E2=94=82
> > >    =E2=94=82                                              v        =
  =E2=94=82
> > >    =E2=94=82                                      XFS_DAS_FLIP_LFLA=
G =E2=94=82
> > >    =E2=94=82                                              =E2=94=82=
          =E2=94=82
> > >    =E2=94=82                                              v        =
  =E2=94=82
> > >    =E2=94=82                                            remove     =
  =E2=94=82
> > >    =E2=94=82                        XFS_DAS_RM_LBLK =E2=94=80> old =
name      =E2=94=82
> > >    =E2=94=82                                 ^            =E2=94=82=
          =E2=94=82
> > >    =E2=94=82                                 =E2=94=82            v=
          =E2=94=82
> > >    =E2=94=82                                 =E2=94=94=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80y=E2=94=80=E2=94=80 more to      =E2=
=94=82
> > >    =E2=94=82                                            remove     =
  =E2=94=82
> > >    =E2=94=82                                              =E2=94=82=
          =E2=94=82
> > >    =E2=94=82                                              n        =
  =E2=94=82
> > >    =E2=94=82                                              =E2=94=82=
          =E2=94=82
> > >    =E2=94=82                                              v        =
  =E2=94=82
> > >    =E2=94=82                                             done <=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> > >    =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80> XFS_DAS_LEAF_TO_N=
ODE =E2=94=80=E2=94=90
> > >                                 =E2=94=82
> > >           XFS_DAS_FOUND_NBLK  =E2=94=80=E2=94=80=E2=94=A4
> > >           (subroutine state)    =E2=94=82
> > >                                 =E2=94=82
> > >           XFS_DAS_ALLOC_NODE  =E2=94=80=E2=94=80=E2=94=A4
> > >           (subroutine state)    =E2=94=82
> > >                                 =E2=94=82
> > >           XFS_DAS_FLIP_NFLAG  =E2=94=80=E2=94=80=E2=94=A4
> > >           (subroutine state)    =E2=94=82
> > >                                 =E2=94=82
> > >                                 =E2=94=94=E2=94=80>xfs_attr_node_ad=
dname()
> > >                                                   =E2=94=82
> > >                                                   v
> > >                                           find space to store
> > >                                          attr. Split if needed
> > >                                                   =E2=94=82
> > >                                                   v
> > >                                           XFS_DAS_FOUND_NBLK
> > >                                                   =E2=94=82
> > >                                                   v
> > >                                     =E2=94=8C=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80n=E2=94=80=E2=94=80  need to
> > >                                     =E2=94=82        alloc blks?
> > >                                     =E2=94=82             =E2=94=82
> > >                                     =E2=94=82             y
> > >                                     =E2=94=82             =E2=94=82
> > >                                     =E2=94=82             v
> > >                                     =E2=94=82  =E2=94=8C=E2=94=80>X=
FS_DAS_ALLOC_NODE
> > >                                     =E2=94=82  =E2=94=82          =E2=
=94=82
> > >                                     =E2=94=82  =E2=94=82          v
> > >                                     =E2=94=82  =E2=94=94=E2=94=80=E2=
=94=80y=E2=94=80=E2=94=80 need to alloc
> > >                                     =E2=94=82         more blocks?
> > >                                     =E2=94=82             =E2=94=82
> > >                                     =E2=94=82             n
> > >                                     =E2=94=82             =E2=94=82
> > >                                     =E2=94=82             v
> > >                                     =E2=94=82          was this
> > >                                     =E2=94=94=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80> a rename? =E2=94=80=E2=94=
=80n=E2=94=80=E2=94=90
> > >                                                   =E2=94=82        =
  =E2=94=82
> > >                                                   y          =E2=94=
=82
> > >                                                   =E2=94=82        =
  =E2=94=82
> > >                                                   v          =E2=94=
=82
> > >                                             flip incomplete  =E2=94=
=82
> > >                                                 flag         =E2=94=
=82
> > >                                                   =E2=94=82        =
  =E2=94=82
> > >                                                   v          =E2=94=
=82
> > >                                           XFS_DAS_FLIP_NFLAG =E2=94=
=82
> > >                                                   =E2=94=82        =
  =E2=94=82
> > >                                                   v          =E2=94=
=82
> > >                                                 remove       =E2=94=
=82
> > >                             XFS_DAS_RM_NBLK =E2=94=80> old name    =
  =E2=94=82
> > >                                      ^            =E2=94=82        =
  =E2=94=82
> > >                                      =E2=94=82            v        =
  =E2=94=82
> > >                                      =E2=94=94=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80y=E2=94=80=E2=94=80 more to      =E2=94=82
> > >                                                 remove       =E2=94=
=82
> > >                                                   =E2=94=82        =
  =E2=94=82
> > >                                                   n          =E2=94=
=82
> > >                                                   =E2=94=82        =
  =E2=94=82
> > >                                                   v          =E2=94=
=82
> > >                                                  done <=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> > >=20
> > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > ---
> >=20
> > Only a cursory pass given the previous feedback...
> >=20
> > >   fs/xfs/libxfs/xfs_attr.c        | 384 +++++++++++++++++++++++++++=
-------------
> > >   fs/xfs/libxfs/xfs_attr.h        |  16 ++
> > >   fs/xfs/libxfs/xfs_attr_leaf.c   |   1 +
> > >   fs/xfs/libxfs/xfs_attr_remote.c | 111 +++++++-----
> > >   fs/xfs/libxfs/xfs_attr_remote.h |   4 +
> > >   fs/xfs/xfs_attr_inactive.c      |   1 +
> > >   fs/xfs/xfs_trace.h              |   1 -
> > >   7 files changed, 351 insertions(+), 167 deletions(-)
> > >=20
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index f700976..c160b7a 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -44,7 +44,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args=
_t *args);
> > >    * Internal routines when attribute list is one block.
> > >    */
> > >   STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
> > > -STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
> > > +STATIC int xfs_attr_leaf_addname(struct xfs_delattr_context *dac);
> > >   STATIC int xfs_attr_leaf_removename(struct xfs_delattr_context *d=
ac);
> > >   STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct=
 xfs_buf **bp);
> > > @@ -52,12 +52,13 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_=
args *args, struct xfs_buf **bp);
> > >    * Internal routines when attribute list is more than one block.
> > >    */
> > >   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> > > -STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> > > +STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
> > >   STATIC int xfs_attr_node_removename(struct xfs_delattr_context *d=
ac);
> > >   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> > >   				 struct xfs_da_state **state);
> > >   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> > >   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> > > +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct =
xfs_buf *bp);
> > >   STATIC void
> > >   xfs_delattr_context_init(
> > > @@ -227,8 +228,11 @@ xfs_attr_is_shortform(
> > >   /*
> > >    * Attempts to set an attr in shortform, or converts the tree to =
leaf form if
> > > - * there is not enough room.  If the attr is set, the transaction =
is committed
> > > - * and set to NULL.
> > > + * there is not enough room.  This function is meant to operate as=
 a helper
> > > + * routine to the delayed attribute functions.  It returns -EAGAIN=
 to indicate
> > > + * that the calling function should roll the transaction, and then=
 proceed to
> > > + * add the attr in leaf form.  This subroutine does not expect to =
be recalled
> > > + * again like the other delayed attr routines do.
> > >    */
> > >   STATIC int
> > >   xfs_attr_set_shortform(
> > > @@ -236,16 +240,16 @@ xfs_attr_set_shortform(
> > >   	struct xfs_buf		**leaf_bp)
> > >   {
> > >   	struct xfs_inode	*dp =3D args->dp;
> > > -	int			error, error2 =3D 0;
> > > +	int			error =3D 0;
> > >   	/*
> > >   	 * Try to add the attr to the attribute list in the inode.
> > >   	 */
> > >   	error =3D xfs_attr_try_sf_addname(dp, args);
> > > +
> > > +	/* Should only be 0, -EEXIST or ENOSPC */
> > >   	if (error !=3D -ENOSPC) {
> > > -		error2 =3D xfs_trans_commit(args->trans);
> > > -		args->trans =3D NULL;
> > > -		return error ? error : error2;
> > > +		return error;
> > >   	}
> > >   	/*
> > >   	 * It won't fit in the shortform, transform to a leaf block.  GR=
OT:
> > > @@ -258,18 +262,10 @@ xfs_attr_set_shortform(
> > >   	/*
> > >   	 * Prevent the leaf buffer from being unlocked so that a concurr=
ent AIL
> > >   	 * push cannot grab the half-baked leaf buffer and run into prob=
lems
> > > -	 * with the write verifier. Once we're done rolling the transacti=
on we
> > > -	 * can release the hold and add the attr to the leaf.
> > > +	 * with the write verifier.
> > >   	 */
> > >   	xfs_trans_bhold(args->trans, *leaf_bp);
> > > -	error =3D xfs_defer_finish(&args->trans);
> > > -	xfs_trans_bhold_release(args->trans, *leaf_bp);
> > > -	if (error) {
> > > -		xfs_trans_brelse(args->trans, *leaf_bp);
> > > -		return error;
> > > -	}
> > > -
> > > -	return 0;
> > > +	return -EAGAIN;
> > >   }
> > >   /*
> > > @@ -279,9 +275,83 @@ int
> > >   xfs_attr_set_args(
> > >   	struct xfs_da_args	*args)
> > >   {
> > > -	struct xfs_inode	*dp =3D args->dp;
> > > -	struct xfs_buf          *leaf_bp =3D NULL;
> > > -	int			error =3D 0;
> > > +	struct xfs_buf			*leaf_bp =3D NULL;
> > > +	int				error =3D 0;
> > > +	struct xfs_delattr_context	dac;
> > > +
> > > +	xfs_delattr_context_init(&dac, args);
> > > +
> > > +	do {
> > > +		error =3D xfs_attr_set_iter(&dac, &leaf_bp);
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
> > > +
> > > +		if (leaf_bp) {
> > > +			xfs_trans_bjoin(args->trans, leaf_bp);
> > > +			xfs_trans_bhold(args->trans, leaf_bp);
> > > +		}
> > > +
> > > +	} while (true);
> > > +
> > > +	return error;
> > > +}
> > > +
> > > +/*
> > > + * Set the attribute specified in @args.
> > > + * This routine is meant to function as a delayed operation, and m=
ay return
> > > + * -EAGAIN when the transaction needs to be rolled.  Calling funct=
ions will need
> > > + * to handle this, and recall the function until a successful erro=
r code is
> > > + * returned.
> > > + */
> > > +int
> > > +xfs_attr_set_iter(
> > > +	struct xfs_delattr_context	*dac,
> > > +	struct xfs_buf			**leaf_bp)
> > > +{
> > > +	struct xfs_da_args		*args =3D dac->da_args;
> > > +	struct xfs_inode		*dp =3D args->dp;
> > > +	int				error =3D 0;
> > > +	int				sf_size;
> > > +
> > > +	/* State machine switch */
> > > +	switch (dac->dela_state) {
> > > +	case XFS_DAS_ADD_LEAF:
> > > +		goto das_add_leaf;
> > > +	case XFS_DAS_ALLOC_LEAF:
> > > +	case XFS_DAS_FLIP_LFLAG:
> > > +	case XFS_DAS_FOUND_LBLK:
> > > +		goto das_leaf;
> > > +	case XFS_DAS_FOUND_NBLK:
> > > +	case XFS_DAS_FLIP_NFLAG:
> > > +	case XFS_DAS_ALLOC_NODE:
> > > +	case XFS_DAS_LEAF_TO_NODE:
> > > +		goto das_node;
> > > +	default:
> > > +		break;
> > > +	}
> > > +
> > > +	/*
> > > +	 * New inodes may not have an attribute fork yet. So set the attr=
ibute
> > > +	 * fork appropriately
> > > +	 */
> > > +	if (XFS_IFORK_Q((args->dp)) =3D=3D 0) {
> > > +		sf_size =3D sizeof(struct xfs_attr_sf_hdr) +
> > > +		     XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
> > > +		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
> > > +		args->dp->i_afp =3D kmem_zone_zalloc(xfs_ifork_zone, 0);
> > > +		args->dp->i_afp->if_flags =3D XFS_IFEXTENTS;
> > > +	}
> >=20
> > Is this hunk moved from somewhere? If so, we should probably handle t=
hat
> > in a separate patch. I think we really want these last couple of patc=
hes
> > to introduce the state/markers and not much else.
> Oh, this hunk is new, not moved, I believe it's been here since I picke=
d up
> the series quite a while ago.  It actually has more to do with parent
> pointers than delayed atts.  Basically when we try to add the parent po=
inter
> during a create, the inode isnt fully constructed yet, so we have add t=
he
> fork here. I will put this in a separate patch and move it further up t=
he
> set.
>=20

Ok.

> >=20
> > >   	/*
> > >   	 * If the attribute list is already in leaf format, jump straigh=
t to
> > > @@ -292,40 +362,53 @@ xfs_attr_set_args(
> > >   	if (xfs_attr_is_shortform(dp)) {
> > >   		/*
> > > -		 * If the attr was successfully set in shortform, the
> > > -		 * transaction is committed and set to NULL.  Otherwise, is it
> > > -		 * converted from shortform to leaf, and the transaction is
> > > -		 * retained.
> > > +		 * If the attr was successfully set in shortform, no need to
> > > +		 * continue.  Otherwise, is it converted from shortform to leaf
> > > +		 * and -EAGAIN is returned.
> > >   		 */
> > > -		error =3D xfs_attr_set_shortform(args, &leaf_bp);
> > > -		if (error || !args->trans)
> > > -			return error;
> > > +		error =3D xfs_attr_set_shortform(args, leaf_bp);
> > > +		if (error =3D=3D -EAGAIN) {
> > > +			dac->flags |=3D XFS_DAC_DEFER_FINISH;
> > > +			dac->dela_state =3D XFS_DAS_ADD_LEAF;
> > > +		}
> > > +		return error;
> >=20
> > Similar to the previous patch, I wonder if we need the explicit state=
s
> > that are otherwise handled by existing inode state. For example, if t=
he
> > above returns -EAGAIN, xfs_attr_is_shortform() is no longer true on
> > reentry, right? If that's the case for the other conversions, it seem=
s
> > like we might only need one state (XFS_DAS_FOUND_LBLK) for this
> > function.
> Ok, it looks like I can get away with out XFS_DAS_ADD_LEAF and
> XFS_DAS_LEAF_TO_NODE.
>=20
> This is actually a little similar to how it was done when I was trying =
to
> use flags instead of the state enums a long time ago.  At the time, I g=
ot
> the impression people were concerned about the complexity and
> maintainability.  So we went back to the enums because the explicite ju=
mping
> made it clear where the re-entry was to resume, and reduced the risk th=
at a
> person may mistakenly introduce a change that disrupts the reentry flow=
.
> Though perhaps the current arrangement of refactoring has made that les=
s
> concerning?
>=20

Perhaps. I think it just depends on context. It might not make sense to
try and implement such a reentry model down in the node code where we
have N different non-deterministic states to deal with; as opposed to
here where we're looking at one of a handful of high level formats and
the behavior is very predictable: try to add to the current format, else
convert to the next.

> >=20
> > BTW, that general approach might be more clear if we lifted the forma=
t
> > conversions into this level from down in the format specific add
> > handlers. The goal would be to make the high level flow look somethin=
g
> > like:
> >=20
> > 	if (shortform) {
> > 		error =3D sf_try_add();
> > 		if (error =3D=3D -ENOSPC) {
> > 			shortform_to_leaf(...);
> > 			...
> > 			return -EAGAIN;
> > 		}
> Well, actually this piece was hoisted out into the helper function in p=
atch
> 13.  So pulling this up is sort of like letting go of patch 13. :-)
>=20
> The history is: initially I had tried to reduce indentation here in v6 =
by
> taking advantage of the _add_leaf label. Because I think in v5 we were
> trying to unnest where some of the jump points were.  So in v6 I had:
> "if(!shortform) goto leaf;" Which un-nests this shortform code.
>=20
> Then in the v7 review I think Dave suggested I should add the helper an=
d
> invert the check. So now we have "if(shortform()){ call_helper(); handl=
e
> -EAGAIN; }"
>=20
> So pulling up is a bit of a circle now.  But still functional if people
> prefer it as it was.  Just need to keep track of the history so we avoi=
d
> going around again. :-)
>=20

I don't think you need to drop that patch necessarily, but perhaps keep
the conversion part to a separate helper and then introduce a similar
patch for other formats..? In any event, that was just a followup
thought so it might be reasonable to defer it to the next version and
for now just see what it looks like to rely on the format states.

>=20
> > 	} else if (xfs_bmap_one_block(...)) {
> Mmm.... cant jump into the leaf logic right away.  We need to handle
> releasing leaf_bp which looks like it got lost in the pseudo code?  IIR=
C
> there is a race condition with the AIL that is resolved by holding the =
leaf
> buffer across the transaction roll.  So we need to check for that and
> release it upon reentry.
>=20

That sounds more like an implementation detail. leaf_bp is set when we
convert from shortform, so isn't this the next state either way?

>=20
> > 		error =3D xfs_attr_leaf_try_add(args, *leaf_bp);
> > 		if (error =3D=3D -ENOSPC) {
> > 			leaf_to_node(...);
> > 			return -EAGAIN;
> > 		}
> Ok, so lift ENOSPC handler from xfs_attr_leaf_try_add
>=20
> >=20
> > 		... state stuff for leaf add ...
> > 	} else {
> > 		error =3D xfs_attr_node_addname(dac);
> > 	}
> >=20
> > Hm? Of course, something like that should be incorporated via
> > independent refactoring patches.
> I think what this becomes right now is:
>=20
> Drop patch 13
> Add new patch xfs: Lift ENOSPC handler from xfs_attr_leaf_try_add
>=20
> ?
>=20

Re: above, I don't think the patch needs to necessarily go away. Feel
free to table this for now, just something to think about...

> >=20
> > >   	}
> > > -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> > > -		error =3D xfs_attr_leaf_addname(args);
> > > -		if (error !=3D -ENOSPC)
> > > -			return error;
> > > +das_add_leaf:
> > > -		/*
> > > -		 * Commit that transaction so that the node_addname()
> > > -		 * call can manage its own transactions.
> > > -		 */
> > > -		error =3D xfs_defer_finish(&args->trans);
> > > -		if (error)
> > > -			return error;
> > > +	/*
> > > +	 * After a shortform to leaf conversion, we need to hold the leaf=
 and
> > > +	 * cylce out the transaction.  When we get back, we need to relea=
se
> > > +	 * the leaf.
> > > +	 */
> > > +	if (*leaf_bp !=3D NULL) {
> > > +		xfs_trans_brelse(args->trans, *leaf_bp);
> > > +		*leaf_bp =3D NULL;
> > > +	}
> > > -		/*
> > > -		 * Commit the current trans (including the inode) and
> > > -		 * start a new one.
> > > -		 */
> > > -		error =3D xfs_trans_roll_inode(&args->trans, dp);
> > > -		if (error)
> > > +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> > > +		error =3D xfs_attr_leaf_try_add(args, *leaf_bp);
> > > +		switch (error) {
> > > +		case -ENOSPC:
> > > +			dac->flags |=3D XFS_DAC_DEFER_FINISH;
> > > +			dac->dela_state =3D XFS_DAS_LEAF_TO_NODE;
> > > +			return -EAGAIN;
> > > +		case 0:
> > > +			dac->dela_state =3D XFS_DAS_FOUND_LBLK;
> > > +			return -EAGAIN;
> > > +		default:
> > >   			return error;
> > > -
> > > +		}
> > > +das_leaf:
> > > +		error =3D xfs_attr_leaf_addname(dac);
> > > +		if (error =3D=3D -ENOSPC) {
> > > +			dac->dela_state =3D XFS_DAS_LEAF_TO_NODE;
> > > +			return -EAGAIN;
> > > +		}
> > > +		return error;
> > >   	}
> > > -
> > > -	error =3D xfs_attr_node_addname(args);
> > > +das_node:
> > > +	error =3D xfs_attr_node_addname(dac);
> > >   	return error;
> > >   }
> > > @@ -716,28 +799,32 @@ xfs_attr_leaf_try_add(
> > >    *
> > >    * This leaf block cannot have a "remote" value, we only call thi=
s routine
> > >    * if bmap_one_block() says there is only one block (ie: no remot=
e blks).
> > > + *
> > > + * This routine is meant to function as a delayed operation, and m=
ay return
> > > + * -EAGAIN when the transaction needs to be rolled.  Calling funct=
ions will need
> > > + * to handle this, and recall the function until a successful erro=
r code is
> > > + * returned.
> > >    */
> > >   STATIC int
> > >   xfs_attr_leaf_addname(
> > > -	struct xfs_da_args	*args)
> > > +	struct xfs_delattr_context	*dac)
> > >   {
> > > -	int			error, forkoff;
> > > -	struct xfs_buf		*bp =3D NULL;
> > > -	struct xfs_inode	*dp =3D args->dp;
> > > -
> > > -	trace_xfs_attr_leaf_addname(args);
> > > -
> > > -	error =3D xfs_attr_leaf_try_add(args, bp);
> > > -	if (error)
> > > -		return error;
> > > +	struct xfs_da_args		*args =3D dac->da_args;
> > > +	struct xfs_buf			*bp =3D NULL;
> > > +	int				error, forkoff;
> > > +	struct xfs_inode		*dp =3D args->dp;
> > > -	/*
> > > -	 * Commit the transaction that added the attr name so that
> > > -	 * later routines can manage their own transactions.
> > > -	 */
> > > -	error =3D xfs_trans_roll_inode(&args->trans, dp);
> > > -	if (error)
> > > -		return error;
> > > +	/* State machine switch */
> > > +	switch (dac->dela_state) {
> > > +	case XFS_DAS_FLIP_LFLAG:
> > > +		goto das_flip_flag;
> > > +	case XFS_DAS_ALLOC_LEAF:
> > > +		goto das_alloc_leaf;
> > > +	case XFS_DAS_RM_LBLK:
> > > +		goto das_rm_lblk;
> > > +	default:
> > > +		break;
> > > +	}
> > >   	/*
> > >   	 * If there was an out-of-line value, allocate the blocks we
> > > @@ -746,7 +833,28 @@ xfs_attr_leaf_addname(
> > >   	 * maximum size of a transaction and/or hit a deadlock.
> > >   	 */
> > >   	if (args->rmtblkno > 0) {
> > > -		error =3D xfs_attr_rmtval_set(args);
> > > +
> > > +		/* Open coded xfs_attr_rmtval_set without trans handling */
> > > +		error =3D xfs_attr_rmtval_set_init(dac);
> > > +		if (error)
> > > +			return error;
> > > +
> > > +		/*
> > > +		 * Roll through the "value", allocating blocks on disk as
> > > +		 * required.
> > > +		 */
> > > +das_alloc_leaf:
> >=20
> > If we filter out the setup above, it seems like this state could be
> > reduced to check for ->blkcnt > 0.
> By filter out the set up, you mean to introduce the setup flag like you
> mentioned earlier? For example:
> 	if(flags & setup =3D=3D 0){
> 		setup();
> 		flags |=3D setup;
> 	}
>=20
> To be clear, if we did that, we're talking about adding an "int setup_f=
lags"
> to the dac. And then defineing a XFS_DAC_SETUP_* scheme. Like a
> XFS_DAC_SETUP_ADD_NAME, and an XFS_DAC_SETUP_NODE_REMVE_NAME and so on.
> Because we cant have multiple functions sharing the same set up flag if=
 they
> ever call each others.
>=20
> Is that what you mean to imply?  Otherwise I may not be clear on what y=
ou
> mean by filtering out the set up.
>=20

Well we already have a flag scheme for the defer thing, right? Is there
any reason we couldn't define a similar DAC_DEFER_INIT and let each
operation (add/remove) use it as appropriate? Note again that I'm just
trying to think about potential simplifications. If there are isolated
functions that can be made clearly/simply idempotent (like init/setup
helpers tend to be), then doing so might be helpful. I.e., if
xfs_attr_rmtval_set_init() could do something like:

{
	if (dax->flags & DAC_RMTVAL_SET_INIT)
		return;

	dax->flags |=3D DAC_RMTVAL_SET_INIT;
	...
}

... and that removes an execution state, then that might be a win. If it
requires more complexity than that, then perhaps the suggestion is not
worthwile. ;P

> >=20
> > > +		while (dac->blkcnt > 0) {
> > > +			error =3D xfs_attr_rmtval_set_blk(dac);
> > > +			if (error)
> > > +				return error;
> > > +
> > > +			dac->flags |=3D XFS_DAC_DEFER_FINISH;
> > > +			dac->dela_state =3D XFS_DAS_ALLOC_LEAF;
> > > +			return -EAGAIN;
> > > +		}
> > > +
> > > +		error =3D xfs_attr_rmtval_set_value(args);
> > >   		if (error)
> > >   			return error;
> > >   	}
> > > @@ -765,22 +873,25 @@ xfs_attr_leaf_addname(
> > >   		error =3D xfs_attr3_leaf_flipflags(args);
> > >   		if (error)
> > >   			return error;
> > > -		/*
> > > -		 * Commit the flag value change and start the next trans in
> > > -		 * series.
> > > -		 */
> > > -		error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> > > -		if (error)
> > > -			return error;
> > > -
> > > +		dac->dela_state =3D XFS_DAS_FLIP_LFLAG;
> > > +		return -EAGAIN;
> > > +das_flip_flag:
> > >   		/*
> > >   		 * Dismantle the "old" attribute/value pair by removing
> > >   		 * a "remote" value (if it exists).
> > >   		 */
> > >   		xfs_attr_restore_rmt_blk(args);
> > > +		xfs_attr_rmtval_invalidate(args);
> > > +das_rm_lblk:
> > >   		if (args->rmtblkno) {
> > > -			error =3D xfs_attr_rmtval_remove(args);
> > > +			error =3D __xfs_attr_rmtval_remove(args);
> > > +
> > > +			if (error =3D=3D -EAGAIN) {
> > > +				dac->dela_state =3D XFS_DAS_RM_LBLK;
> > > +				return -EAGAIN;
> > > +			}
> > > +
> >=20
> > This whole function looks like it could use more refactoring to split
> > out the rename case.
> Hmm, how about we take every thing inside the "if (args->op_flags &
> XFS_DA_OP_RENAME) {"  and put it in a xfs_attr_leaf_rename() helper? Th=
en
> pull the helper into the calling function?
>=20

That would help. I'm not sure what the optimal breakdown is off the top
of my head tbh. This function is kind of a logical beast between dealing
with remote blocks and rename and combinations of the two, so I'd have
to stare at that one some more. In general the goal should be to try and
avoid jumping in the middle of logic branches as much as possible so
there's a nice and visible distinction between the state code and the
functional code.

Brian

> >=20
> > >   			if (error)
> > >   				return error;
> > >   		}
> > > @@ -799,15 +910,11 @@ xfs_attr_leaf_addname(
> > >   		/*
> > >   		 * If the result is small enough, shrink it all into the inode.
> > >   		 */
> > > -		if ((forkoff =3D xfs_attr_shortform_allfit(bp, dp))) {
> > > +		forkoff =3D xfs_attr_shortform_allfit(bp, dp);
> > > +		if (forkoff)
> > >   			error =3D xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> > > -			/* bp is gone due to xfs_da_shrink_inode */
> > > -			if (error)
> > > -				return error;
> > > -			error =3D xfs_defer_finish(&args->trans);
> > > -			if (error)
> > > -				return error;
> > > -		}
> > > +
> > > +		dac->flags |=3D XFS_DAC_DEFER_FINISH;
> > >   	} else if (args->rmtblkno > 0) {
> > >   		/*
> > > @@ -967,16 +1074,23 @@ xfs_attr_node_hasname(
> > >    *
> > >    * "Remote" attribute values confuse the issue and atomic rename =
operations
> > >    * add a whole extra layer of confusion on top of that.
> > > + *
> > > + * This routine is meant to function as a delayed operation, and m=
ay return
> > > + * -EAGAIN when the transaction needs to be rolled.  Calling funct=
ions will need
> > > + * to handle this, and recall the function until a successful erro=
r code is
> > > + *returned.
> > >    */
> > >   STATIC int
> > >   xfs_attr_node_addname(
> > > -	struct xfs_da_args	*args)
> > > +	struct xfs_delattr_context	*dac)
> > >   {
> > > -	struct xfs_da_state	*state;
> > > -	struct xfs_da_state_blk	*blk;
> > > -	struct xfs_inode	*dp;
> > > -	struct xfs_mount	*mp;
> > > -	int			retval, error;
> > > +	struct xfs_da_args		*args =3D dac->da_args;
> > > +	struct xfs_da_state		*state =3D NULL;
> > > +	struct xfs_da_state_blk		*blk;
> > > +	struct xfs_inode		*dp;
> > > +	struct xfs_mount		*mp;
> > > +	int				retval =3D 0;
> > > +	int				error =3D 0;
> > >   	trace_xfs_attr_node_addname(args);
> > > @@ -985,7 +1099,21 @@ xfs_attr_node_addname(
> > >   	 */
> > >   	dp =3D args->dp;
> > >   	mp =3D dp->i_mount;
> > > -restart:
> > > +
> > > +	/* State machine switch */
> > > +	switch (dac->dela_state) {
> > > +	case XFS_DAS_FLIP_NFLAG:
> > > +		goto das_flip_flag;
> > > +	case XFS_DAS_FOUND_NBLK:
> > > +		goto das_found_nblk;
> > > +	case XFS_DAS_ALLOC_NODE:
> > > +		goto das_alloc_node;
> > > +	case XFS_DAS_RM_NBLK:
> > > +		goto das_rm_nblk;
> > > +	default:
> > > +		break;
> > > +	}
> > > +
> > >   	/*
> > >   	 * Search to see if name already exists, and get back a pointer
> > >   	 * to where it should go.
> > > @@ -1031,19 +1159,13 @@ xfs_attr_node_addname(
> > >   			error =3D xfs_attr3_leaf_to_node(args);
> > >   			if (error)
> > >   				goto out;
> > > -			error =3D xfs_defer_finish(&args->trans);
> > > -			if (error)
> > > -				goto out;
> > >   			/*
> > > -			 * Commit the node conversion and start the next
> > > -			 * trans in the chain.
> > > +			 * Restart routine from the top.  No need to set  the
> > > +			 * state
> > >   			 */
> > > -			error =3D xfs_trans_roll_inode(&args->trans, dp);
> > > -			if (error)
> > > -				goto out;
> > > -
> > > -			goto restart;
> > > +			dac->flags |=3D XFS_DAC_DEFER_FINISH;
> > > +			return -EAGAIN;
> > >   		}
> > >   		/*
> > > @@ -1055,9 +1177,7 @@ xfs_attr_node_addname(
> > >   		error =3D xfs_da3_split(state);
> > >   		if (error)
> > >   			goto out;
> > > -		error =3D xfs_defer_finish(&args->trans);
> > > -		if (error)
> > > -			goto out;
> > > +		dac->flags |=3D XFS_DAC_DEFER_FINISH;
> > >   	} else {
> > >   		/*
> > >   		 * Addition succeeded, update Btree hashvals.
> > > @@ -1072,13 +1192,9 @@ xfs_attr_node_addname(
> > >   	xfs_da_state_free(state);
> > >   	state =3D NULL;
> > > -	/*
> > > -	 * Commit the leaf addition or btree split and start the next
> > > -	 * trans in the chain.
> > > -	 */
> > > -	error =3D xfs_trans_roll_inode(&args->trans, dp);
> > > -	if (error)
> > > -		goto out;
> > > +	dac->dela_state =3D XFS_DAS_FOUND_NBLK;
> > > +	return -EAGAIN;
> > > +das_found_nblk:
> >=20
> > Same deal here. Any time we have this return -EAGAIN followed by a la=
bel
> > pattern I think we're going to want to think about refactoring things
> > more first to avoid dumping it in the middle of some unnecessarily la=
rge
> > function.
> Ok, similar pattern here too then?  Everything in "if (args->op_flags &
> XFS_DA_OP_RENAME) {" goes in a new xfs_attr_node_rename() helper?  Then
> hoist upwards?
>=20
> Thanks for the reviewing!!
> Allison
>=20
> >=20
> > Brian
> >=20
> > >   	/*
> > >   	 * If there was an out-of-line value, allocate the blocks we
> > > @@ -1087,7 +1203,27 @@ xfs_attr_node_addname(
> > >   	 * maximum size of a transaction and/or hit a deadlock.
> > >   	 */
> > >   	if (args->rmtblkno > 0) {
> > > -		error =3D xfs_attr_rmtval_set(args);
> > > +		/* Open coded xfs_attr_rmtval_set without trans handling */
> > > +		error =3D xfs_attr_rmtval_set_init(dac);
> > > +		if (error)
> > > +			return error;
> > > +
> > > +		/*
> > > +		 * Roll through the "value", allocating blocks on disk as
> > > +		 * required.
> > > +		 */
> > > +das_alloc_node:
> > > +		while (dac->blkcnt > 0) {
> > > +			error =3D xfs_attr_rmtval_set_blk(dac);
> > > +			if (error)
> > > +				return error;
> > > +
> > > +			dac->flags |=3D XFS_DAC_DEFER_FINISH;
> > > +			dac->dela_state =3D XFS_DAS_ALLOC_NODE;
> > > +			return -EAGAIN;
> > > +		}
> > > +
> > > +		error =3D xfs_attr_rmtval_set_value(args);
> > >   		if (error)
> > >   			return error;
> > >   	}
> > > @@ -1110,18 +1246,26 @@ xfs_attr_node_addname(
> > >   		 * Commit the flag value change and start the next trans in
> > >   		 * series
> > >   		 */
> > > -		error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> > > -		if (error)
> > > -			goto out;
> > > -
> > > +		dac->dela_state =3D XFS_DAS_FLIP_NFLAG;
> > > +		return -EAGAIN;
> > > +das_flip_flag:
> > >   		/*
> > >   		 * Dismantle the "old" attribute/value pair by removing
> > >   		 * a "remote" value (if it exists).
> > >   		 */
> > >   		xfs_attr_restore_rmt_blk(args);
> > > +		xfs_attr_rmtval_invalidate(args);
> > > +
> > > +das_rm_nblk:
> > >   		if (args->rmtblkno) {
> > > -			error =3D xfs_attr_rmtval_remove(args);
> > > +			error =3D __xfs_attr_rmtval_remove(args);
> > > +
> > > +			if (error =3D=3D -EAGAIN) {
> > > +				dac->dela_state =3D XFS_DAS_RM_NBLK;
> > > +				return -EAGAIN;
> > > +			}
> > > +
> > >   			if (error)
> > >   				return error;
> > >   		}
> > > @@ -1139,7 +1283,6 @@ xfs_attr_node_addname(
> > >   		error =3D xfs_da3_node_lookup_int(state, &retval);
> > >   		if (error)
> > >   			goto out;
> > > -
> > >   		/*
> > >   		 * Remove the name and update the hashvals in the tree.
> > >   		 */
> > > @@ -1147,7 +1290,6 @@ xfs_attr_node_addname(
> > >   		ASSERT(blk->magic =3D=3D XFS_ATTR_LEAF_MAGIC);
> > >   		error =3D xfs_attr3_leaf_remove(blk->bp, args);
> > >   		xfs_da3_fixhashpath(state, &state->path);
> > > -
> > >   		/*
> > >   		 * Check to see if the tree needs to be collapsed.
> > >   		 */
> > > @@ -1155,11 +1297,9 @@ xfs_attr_node_addname(
> > >   			error =3D xfs_da3_join(state);
> > >   			if (error)
> > >   				goto out;
> > > -			error =3D xfs_defer_finish(&args->trans);
> > > -			if (error)
> > > -				goto out;
> > > -		}
> > > +			dac->flags |=3D XFS_DAC_DEFER_FINISH;
> > > +		}
> > >   	} else if (args->rmtblkno > 0) {
> > >   		/*
> > >   		 * Added a "remote" value, just clear the incomplete flag.
> > > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > > index 0e8ae1a..67af9d1 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.h
> > > +++ b/fs/xfs/libxfs/xfs_attr.h
> > > @@ -93,6 +93,16 @@ enum xfs_delattr_state {
> > >   				      /* Zero is uninitalized */
> > >   	XFS_DAS_RM_SHRINK	=3D 1,  /* We are shrinking the tree */
> > >   	XFS_DAS_RMTVAL_REMOVE,	      /* We are removing remote value blo=
cks */
> > > +	XFS_DAS_ADD_LEAF,	      /* We are adding a leaf attr */
> > > +	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr */
> > > +	XFS_DAS_LEAF_TO_NODE,	      /* Converted leaf to node */
> > > +	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr */
> > > +	XFS_DAS_ALLOC_LEAF,	      /* We are allocating leaf blocks */
> > > +	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr flag */
> > > +	XFS_DAS_RM_LBLK,	      /* A rename is removing leaf blocks */
> > > +	XFS_DAS_ALLOC_NODE,	      /* We are allocating node blocks */
> > > +	XFS_DAS_FLIP_NFLAG,	      /* Flipped node INCOMPLETE attr flag */
> > > +	XFS_DAS_RM_NBLK,	      /* A rename is removing node blocks */
> > >   };
> > >   /*
> > > @@ -105,8 +115,13 @@ enum xfs_delattr_state {
> > >    */
> > >   struct xfs_delattr_context {
> > >   	struct xfs_da_args      *da_args;
> > > +	struct xfs_bmbt_irec	map;
> > > +	struct xfs_buf		*leaf_bp;
> > > +	xfs_fileoff_t		lfileoff;
> > >   	struct xfs_da_state     *da_state;
> > >   	struct xfs_da_state_blk *blk;
> > > +	xfs_dablk_t		lblkno;
> > > +	int			blkcnt;
> > >   	unsigned int            flags;
> > >   	enum xfs_delattr_state  dela_state;
> > >   };
> > > @@ -126,6 +141,7 @@ int xfs_attr_get_ilocked(struct xfs_da_args *ar=
gs);
> > >   int xfs_attr_get(struct xfs_da_args *args);
> > >   int xfs_attr_set(struct xfs_da_args *args);
> > >   int xfs_attr_set_args(struct xfs_da_args *args);
> > > +int xfs_attr_set_iter(struct xfs_delattr_context *dac, struct xfs_=
buf **leaf_bp);
> > >   int xfs_has_attr(struct xfs_da_args *args);
> > >   int xfs_attr_remove_args(struct xfs_da_args *args);
> > >   int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
> > > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr=
_leaf.c
> > > index f55402b..4d15f45 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > @@ -19,6 +19,7 @@
> > >   #include "xfs_bmap_btree.h"
> > >   #include "xfs_bmap.h"
> > >   #include "xfs_attr_sf.h"
> > > +#include "xfs_attr.h"
> > >   #include "xfs_attr_remote.h"
> > >   #include "xfs_attr.h"
> > >   #include "xfs_attr_leaf.h"
> > > diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_at=
tr_remote.c
> > > index fd4be9d..9607fd2 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_remote.c
> > > +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> > > @@ -443,7 +443,7 @@ xfs_attr_rmtval_get(
> > >    * Find a "hole" in the attribute address space large enough for =
us to drop the
> > >    * new attribute's value into
> > >    */
> > > -STATIC int
> > > +int
> > >   xfs_attr_rmt_find_hole(
> > >   	struct xfs_da_args	*args)
> > >   {
> > > @@ -470,7 +470,7 @@ xfs_attr_rmt_find_hole(
> > >   	return 0;
> > >   }
> > > -STATIC int
> > > +int
> > >   xfs_attr_rmtval_set_value(
> > >   	struct xfs_da_args	*args)
> > >   {
> > > @@ -630,6 +630,71 @@ xfs_attr_rmtval_set(
> > >   }
> > >   /*
> > > + * Find a hole for the attr and store it in the delayed attr conte=
xt.  This
> > > + * initializes the context to roll through allocating an attr exte=
nt for a
> > > + * delayed attr operation
> > > + */
> > > +int
> > > +xfs_attr_rmtval_set_init(
> > > +	struct xfs_delattr_context	*dac)
> > > +{
> > > +	struct xfs_da_args		*args =3D dac->da_args;
> > > +	struct xfs_bmbt_irec		*map =3D &dac->map;
> > > +	int error;
> > > +
> > > +	dac->lblkno =3D 0;
> > > +	dac->lfileoff =3D 0;
> > > +	dac->blkcnt =3D 0;
> > > +	args->rmtblkcnt =3D 0;
> > > +	args->rmtblkno =3D 0;
> > > +	memset(map, 0, sizeof(struct xfs_bmbt_irec));
> > > +
> > > +	error =3D xfs_attr_rmt_find_hole(args);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	dac->blkcnt =3D args->rmtblkcnt;
> > > +	dac->lblkno =3D args->rmtblkno;
> > > +
> > > +	return error;
> > > +}
> > > +
> > > +/*
> > > + * Write one block of the value associated with an attribute into =
the
> > > + * out-of-line buffer that we have defined for it. This is similar=
 to a subset
> > > + * of xfs_attr_rmtval_set, but records the current block to the de=
layed attr
> > > + * context, and leaves transaction handling to the caller.
> > > + */
> > > +int
> > > +xfs_attr_rmtval_set_blk(
> > > +	struct xfs_delattr_context	*dac)
> > > +{
> > > +	struct xfs_da_args		*args =3D dac->da_args;
> > > +	struct xfs_inode		*dp =3D args->dp;
> > > +	struct xfs_bmbt_irec		*map =3D &dac->map;
> > > +	int nmap;
> > > +	int error;
> > > +
> > > +	nmap =3D 1;
> > > +	error =3D xfs_bmapi_write(args->trans, dp,
> > > +		  (xfs_fileoff_t)dac->lblkno,
> > > +		  dac->blkcnt, XFS_BMAPI_ATTRFORK,
> > > +		  args->total, map, &nmap);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	ASSERT(nmap =3D=3D 1);
> > > +	ASSERT((map->br_startblock !=3D DELAYSTARTBLOCK) &&
> > > +	       (map->br_startblock !=3D HOLESTARTBLOCK));
> > > +
> > > +	/* roll attribute extent map forwards */
> > > +	dac->lblkno +=3D map->br_blockcount;
> > > +	dac->blkcnt -=3D map->br_blockcount;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +/*
> > >    * Remove the value associated with an attribute by deleting the
> > >    * out-of-line buffer that it is stored on.
> > >    */
> > > @@ -671,48 +736,6 @@ xfs_attr_rmtval_invalidate(
> > >   }
> > >   /*
> > > - * Remove the value associated with an attribute by deleting the
> > > - * out-of-line buffer that it is stored on.
> > > - */
> > > -int
> > > -xfs_attr_rmtval_remove(
> > > -	struct xfs_da_args      *args)
> > > -{
> > > -	xfs_dablk_t		lblkno;
> > > -	int			blkcnt;
> > > -	int			error =3D 0;
> > > -	int			done =3D 0;
> > > -
> > > -	trace_xfs_attr_rmtval_remove(args);
> > > -
> > > -	error =3D xfs_attr_rmtval_invalidate(args);
> > > -	if (error)
> > > -		return error;
> > > -	/*
> > > -	 * Keep de-allocating extents until the remote-value region is go=
ne.
> > > -	 */
> > > -	lblkno =3D args->rmtblkno;
> > > -	blkcnt =3D args->rmtblkcnt;
> > > -	while (!done) {
> > > -		error =3D xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
> > > -				    XFS_BMAPI_ATTRFORK, 1, &done);
> > > -		if (error)
> > > -			return error;
> > > -		error =3D xfs_defer_finish(&args->trans);
> > > -		if (error)
> > > -			return error;
> > > -
> > > -		/*
> > > -		 * Close out trans and start the next one in the chain.
> > > -		 */
> > > -		error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> > > -		if (error)
> > > -			return error;
> > > -	}
> > > -	return 0;
> > > -}
> > > -
> > > -/*
> > >    * Remove the value associated with an attribute by deleting the =
out-of-line
> > >    * buffer that it is stored on. Returns EAGAIN for the caller to =
refresh the
> > >    * transaction and recall the function
> > > diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_at=
tr_remote.h
> > > index ee3337b..482dff9 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_remote.h
> > > +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> > > @@ -15,4 +15,8 @@ int xfs_attr_rmtval_stale(struct xfs_inode *ip, s=
truct xfs_bmbt_irec *map,
> > >   		xfs_buf_flags_t incore_flags);
> > >   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> > >   int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
> > > +int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
> > > +int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
> > > +int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
> > > +int xfs_attr_rmtval_set_init(struct xfs_delattr_context *dac);
> > >   #endif /* __XFS_ATTR_REMOTE_H__ */
> > > diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.=
c
> > > index c42f90e..3e8cec5 100644
> > > --- a/fs/xfs/xfs_attr_inactive.c
> > > +++ b/fs/xfs/xfs_attr_inactive.c
> > > @@ -15,6 +15,7 @@
> > >   #include "xfs_da_format.h"
> > >   #include "xfs_da_btree.h"
> > >   #include "xfs_inode.h"
> > > +#include "xfs_attr.h"
> > >   #include "xfs_attr_remote.h"
> > >   #include "xfs_trans.h"
> > >   #include "xfs_bmap.h"
> > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > index a4323a6..26dc8bf 100644
> > > --- a/fs/xfs/xfs_trace.h
> > > +++ b/fs/xfs/xfs_trace.h
> > > @@ -1784,7 +1784,6 @@ DEFINE_ATTR_EVENT(xfs_attr_refillstate);
> > >   DEFINE_ATTR_EVENT(xfs_attr_rmtval_get);
> > >   DEFINE_ATTR_EVENT(xfs_attr_rmtval_set);
> > > -DEFINE_ATTR_EVENT(xfs_attr_rmtval_remove);
> > >   #define DEFINE_DA_EVENT(name) \
> > >   DEFINE_EVENT(xfs_da_class, name, \
> > > --=20
> > > 2.7.4
> > >=20
> >=20
>=20


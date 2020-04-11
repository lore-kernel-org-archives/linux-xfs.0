Return-Path: <SRS0=7tHi=53=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 747B0C2BA2B
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 12:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CAA92084D
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 12:58:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MY6iyDi7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgDKM57 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Apr 2020 08:57:59 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38064 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726037AbgDKM57 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Apr 2020 08:57:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586609877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6gs6xNFguC8zNu4QcUNnlv7LBlp/hMWKAT8qBk7jJrw=;
        b=MY6iyDi7QKJv4iLM3OTBgqsLYH1Ox5QFQMP1MoDfRWxeYdkKQC0YqEcf4fmWWoZs454u22
        /Azrq+/DHlNxIrbm6MVZbcK+X8Hd5iGPZyHccQQ0sqYDVxJS6JR1we0k+IxZwNJDALtCJP
        r9fZ8554BImOseEYkojunl4zsA/iWLc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-BYvbshEIOTyGQPtrJt2nXg-1; Sat, 11 Apr 2020 08:57:44 -0400
X-MC-Unique: BYvbshEIOTyGQPtrJt2nXg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02D161005509;
        Sat, 11 Apr 2020 12:57:44 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 85F4D5D9CA;
        Sat, 11 Apr 2020 12:57:43 +0000 (UTC)
Date:   Sat, 11 Apr 2020 08:57:41 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 13/20] xfs: Add helpers xfs_attr_is_shortform and
 xfs_attr_set_shortform
Message-ID: <20200411125741.GA49117@bfoster>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-14-allison.henderson@oracle.com>
 <20200407152301.GE28936@bfoster>
 <00b93566-bb7d-544d-698a-c239e7c5f7b3@oracle.com>
 <3c589d25-c931-6376-eefc-343b4828a820@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <3c589d25-c931-6376-eefc-343b4828a820@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 10, 2020 at 09:55:55AM -0700, Allison Collins wrote:
>=20
>=20
> On 4/7/20 2:53 PM, Allison Collins wrote:
> >=20
> >=20
> > On 4/7/20 8:23 AM, Brian Foster wrote:
> > > On Fri, Apr 03, 2020 at 03:12:22PM -0700, Allison Collins wrote:
> > > > In this patch, we hoist code from xfs_attr_set_args into two new =
helpers
> > > > xfs_attr_is_shortform and xfs_attr_set_shortform.=A0 These two wi=
ll help
> > > > to simplify xfs_attr_set_args when we get into delayed attrs late=
r.
> > > >=20
> > > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > > ---
> > > > =A0 fs/xfs/libxfs/xfs_attr.c | 107
> > > > +++++++++++++++++++++++++++++++----------------
> > > > =A0 1 file changed, 72 insertions(+), 35 deletions(-)
> > > >=20
> > > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > > index 4225a94..ba26ffe 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > > @@ -204,6 +204,66 @@ xfs_attr_try_sf_addname(
> > > > =A0 }
> > > > =A0 /*
> > > > + * Check to see if the attr should be upgraded from
> > > > non-existent or shortform to
> > > > + * single-leaf-block attribute list.
> > > > + */
> > > > +static inline bool
> > > > +xfs_attr_is_shortform(
> > > > +=A0=A0=A0 struct xfs_inode=A0=A0=A0 *ip)
> > > > +{
> > > > +=A0=A0=A0 return ip->i_d.di_aformat =3D=3D XFS_DINODE_FMT_LOCAL =
||
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0 (ip->i_d.di_aformat =3D=3D XFS_DINOD=
E_FMT_EXTENTS &&
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0 ip->i_d.di_anextents =3D=3D 0);
> > >=20
> > > Logic should be indented similar to the original:
> > >=20
> > > =A0=A0=A0=A0return ip->i_d.di_aformat =3D=3D XFS_DINODE_FMT_LOCAL |=
|
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (ip->i_d.di_aformat =3D=3D XFS_DINOD=
E_FMT_EXTENTS &&
> > > =A0=A0=A0=A0=A0=A0=A0 ip->i_d.di_anextents =3D=3D 0);
> Did you really mean to have the last line offset like this?  On second =
pass,
> it doesnt look similar to the original, and looks more like it may have=
 been
> a typo in the review.  Just trying to avoid more cycles on spacing goof=
s.
> Thx!
>=20

Nope. What is quoted here is not how my reply appears in my mailer. :/
Anyways, the last line is supposed to be aligned to the first character
inside the opening brace of the previous line.

Brian

> Allison
>=20
> > >=20
> > > Otherwise looks good:
> > >=20
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > Alrighty, will fix.=A0 Thanks!
> >=20
> > Allison
> >=20
> > >=20
> > > > +}
> > > > +
> > > > +/*
> > > > + * Attempts to set an attr in shortform, or converts the tree
> > > > to leaf form if
> > > > + * there is not enough room.=A0 If the attr is set, the
> > > > transaction is committed
> > > > + * and set to NULL.
> > > > + */
> > > > +STATIC int
> > > > +xfs_attr_set_shortform(
> > > > +=A0=A0=A0 struct xfs_da_args=A0=A0=A0 *args,
> > > > +=A0=A0=A0 struct xfs_buf=A0=A0=A0=A0=A0=A0=A0 **leaf_bp)
> > > > +{
> > > > +=A0=A0=A0 struct xfs_inode=A0=A0=A0 *dp =3D args->dp;
> > > > +=A0=A0=A0 int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 error, error2 =3D=
 0;
> > > > +
> > > > +=A0=A0=A0 /*
> > > > +=A0=A0=A0=A0 * Try to add the attr to the attribute list in the =
inode.
> > > > +=A0=A0=A0=A0 */
> > > > +=A0=A0=A0 error =3D xfs_attr_try_sf_addname(dp, args);
> > > > +=A0=A0=A0 if (error !=3D -ENOSPC) {
> > > > +=A0=A0=A0=A0=A0=A0=A0 error2 =3D xfs_trans_commit(args->trans);
> > > > +=A0=A0=A0=A0=A0=A0=A0 args->trans =3D NULL;
> > > > +=A0=A0=A0=A0=A0=A0=A0 return error ? error : error2;
> > > > +=A0=A0=A0 }
> > > > +=A0=A0=A0 /*
> > > > +=A0=A0=A0=A0 * It won't fit in the shortform, transform to a lea=
f block.=A0 GROT:
> > > > +=A0=A0=A0=A0 * another possible req'mt for a double-split btree =
op.
> > > > +=A0=A0=A0=A0 */
> > > > +=A0=A0=A0 error =3D xfs_attr_shortform_to_leaf(args, leaf_bp);
> > > > +=A0=A0=A0 if (error)
> > > > +=A0=A0=A0=A0=A0=A0=A0 return error;
> > > > +
> > > > +=A0=A0=A0 /*
> > > > +=A0=A0=A0=A0 * Prevent the leaf buffer from being unlocked so th=
at a
> > > > concurrent AIL
> > > > +=A0=A0=A0=A0 * push cannot grab the half-baked leaf buffer and r=
un into
> > > > problems
> > > > +=A0=A0=A0=A0 * with the write verifier. Once we're done rolling =
the
> > > > transaction we
> > > > +=A0=A0=A0=A0 * can release the hold and add the attr to the leaf=
.
> > > > +=A0=A0=A0=A0 */
> > > > +=A0=A0=A0 xfs_trans_bhold(args->trans, *leaf_bp);
> > > > +=A0=A0=A0 error =3D xfs_defer_finish(&args->trans);
> > > > +=A0=A0=A0 xfs_trans_bhold_release(args->trans, *leaf_bp);
> > > > +=A0=A0=A0 if (error) {
> > > > +=A0=A0=A0=A0=A0=A0=A0 xfs_trans_brelse(args->trans, *leaf_bp);
> > > > +=A0=A0=A0=A0=A0=A0=A0 return error;
> > > > +=A0=A0=A0 }
> > > > +
> > > > +=A0=A0=A0 return 0;
> > > > +}
> > > > +
> > > > +/*
> > > > =A0=A0 * Set the attribute specified in @args.
> > > > =A0=A0 */
> > > > =A0 int
> > > > @@ -212,48 +272,25 @@ xfs_attr_set_args(
> > > > =A0 {
> > > > =A0=A0=A0=A0=A0 struct xfs_inode=A0=A0=A0 *dp =3D args->dp;
> > > > =A0=A0=A0=A0=A0 struct xfs_buf=A0=A0=A0=A0=A0=A0=A0=A0=A0 *leaf_b=
p =3D NULL;
> > > > -=A0=A0=A0 int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 error, error2 =3D=
 0;
> > > > +=A0=A0=A0 int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 error =3D 0;
> > > > =A0=A0=A0=A0=A0 /*
> > > > -=A0=A0=A0=A0 * If the attribute list is non-existent or a shortf=
orm list,
> > > > -=A0=A0=A0=A0 * upgrade it to a single-leaf-block attribute list.
> > > > +=A0=A0=A0=A0 * If the attribute list is already in leaf format, =
jump
> > > > straight to
> > > > +=A0=A0=A0=A0 * leaf handling.=A0 Otherwise, try to add the attri=
bute to
> > > > the shortform
> > > > +=A0=A0=A0=A0 * list; if there's no room then convert the list to=
 leaf
> > > > format and try
> > > > +=A0=A0=A0=A0 * again.
> > > > =A0=A0=A0=A0=A0=A0 */
> > > > -=A0=A0=A0 if (dp->i_d.di_aformat =3D=3D XFS_DINODE_FMT_LOCAL ||
> > > > -=A0=A0=A0=A0=A0=A0=A0 (dp->i_d.di_aformat =3D=3D XFS_DINODE_FMT_=
EXTENTS &&
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0 dp->i_d.di_anextents =3D=3D 0)) {
> > > > -
> > > > -=A0=A0=A0=A0=A0=A0=A0 /*
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0 * Try to add the attr to the attribute =
list in the inode.
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0 */
> > > > -=A0=A0=A0=A0=A0=A0=A0 error =3D xfs_attr_try_sf_addname(dp, args=
);
> > > > -=A0=A0=A0=A0=A0=A0=A0 if (error !=3D -ENOSPC) {
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 error2 =3D xfs_trans_commit(ar=
gs->trans);
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 args->trans =3D NULL;
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return error ? error : error2;
> > > > -=A0=A0=A0=A0=A0=A0=A0 }
> > > > -
> > > > -=A0=A0=A0=A0=A0=A0=A0 /*
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0 * It won't fit in the shortform, transf=
orm to a leaf block.
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0 * GROT: another possible req'mt for a d=
ouble-split btree op.
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0 */
> > > > -=A0=A0=A0=A0=A0=A0=A0 error =3D xfs_attr_shortform_to_leaf(args,=
 &leaf_bp);
> > > > -=A0=A0=A0=A0=A0=A0=A0 if (error)
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return error;
> > > > +=A0=A0=A0 if (xfs_attr_is_shortform(dp)) {
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0 /*
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0 * Prevent the leaf buffer from being un=
locked so that a
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0 * concurrent AIL push cannot grab the h=
alf-baked leaf
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0 * buffer and run into problems with the=
 write verifier.
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0 * Once we're done rolling the transacti=
on we can release
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0 * the hold and add the attr to the leaf=
.
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0 * If the attr was successfully set in s=
hortform, the
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0 * transaction is committed and set to N=
ULL.=A0 Otherwise, is it
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0 * converted from shortform to leaf, and=
 the transaction is
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0 * retained.
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> > > > -=A0=A0=A0=A0=A0=A0=A0 xfs_trans_bhold(args->trans, leaf_bp);
> > > > -=A0=A0=A0=A0=A0=A0=A0 error =3D xfs_defer_finish(&args->trans);
> > > > -=A0=A0=A0=A0=A0=A0=A0 xfs_trans_bhold_release(args->trans, leaf_=
bp);
> > > > -=A0=A0=A0=A0=A0=A0=A0 if (error) {
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 xfs_trans_brelse(args->trans, =
leaf_bp);
> > > > +=A0=A0=A0=A0=A0=A0=A0 error =3D xfs_attr_set_shortform(args, &le=
af_bp);
> > > > +=A0=A0=A0=A0=A0=A0=A0 if (error || !args->trans)
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return error;
> > > > -=A0=A0=A0=A0=A0=A0=A0 }
> > > > =A0=A0=A0=A0=A0 }
> > > > =A0=A0=A0=A0=A0 if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> > > > --=20
> > > > 2.7.4
> > > >=20
> > >=20
>=20


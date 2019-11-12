Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E9D3C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 13:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FEAA2084F
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 13:37:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W3utQ+cb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKLNhh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 08:37:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52076 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725944AbfKLNhg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 08:37:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573565855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FIZUU0u5e1DVz+xalzUcMRrL/LQ4ZTnwNIRrKVYgq8Q=;
        b=W3utQ+cbwSyL7U/zdYO3/XkRTWylpMY1xjZG/GbrVdntWv1C4gDss6FyHec1socOqeRHT1
        P3g2U0y2mEKFJ6ijctcvWCwCoz73d0Db25DKCSzYKa1ibHCrREYzNOTdFpFoJ0YGTG60sY
        c3jMBMjBGHgFU1ZS7IZUH7TL1xWJzUw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-gh9LhvCIOauJ5bjHiB52iw-1; Tue, 12 Nov 2019 08:37:33 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E313685EE76;
        Tue, 12 Nov 2019 13:37:32 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E3D71B49F;
        Tue, 12 Nov 2019 13:37:32 +0000 (UTC)
Date:   Tue, 12 Nov 2019 08:37:30 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 17/17] xfs: Add delay ready attr set routines
Message-ID: <20191112133730.GB46980@bfoster>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-18-allison.henderson@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20191107012801.22863-18-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: gh9LhvCIOauJ5bjHiB52iw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 06:28:01PM -0700, Allison Collins wrote:
> This patch modifies the attr set routines to be delay ready.
> This means they no longer roll or commit transactions, but instead
> return -EAGAIN to have the calling routine roll and refresh the
> transaction.  In this series, xfs_attr_set_args has become
> xfs_attr_set_later, which uses a state machine to keep track
> of where it was when EAGAIN was returned.  Part of
> xfs_attr_leaf_addname has been factored out into a new helper
> function xfs_attr_leaf_try_add to allow transaction cycling between
> the two routines, and the flipflags logic has been removed since we
> can simply cancel the transaction upon error.  xfs_attr_set_args
> consists of a simple loop to refresh the transaction until the
> operation is completed.
>=20
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---

Pretty much the same fundamental comments here as for the remove patch.
Can we break things down further to avoid much of the jumping into if
branch behavior and such? I also wonder if it might be possible to split
this one up into smaller patches to fix up the leaf/node paths
separately, but additional prep refactoring might simplify things enough
on its own to make that unnecessary..

Brian

>  fs/xfs/libxfs/xfs_attr.c | 435 +++++++++++++++++++++++------------------=
------
>  fs/xfs/libxfs/xfs_attr.h |   1 +
>  2 files changed, 211 insertions(+), 225 deletions(-)
>=20
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 38d5c5c..97e5ae0 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -58,6 +58,7 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  =09=09=09=09 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_bu=
f *bp);
> =20
> =20
>  STATIC int
> @@ -250,9 +251,79 @@ int
>  xfs_attr_set_args(
>  =09struct xfs_da_args=09*args)
>  {
> +=09int=09=09=09error =3D 0;
> +=09int=09=09=09err2 =3D 0;
> +=09struct xfs_buf=09=09*leaf_bp =3D NULL;
> +
> +=09do {
> +=09=09error =3D xfs_attr_set_later(args, &leaf_bp);
> +=09=09if (error && error !=3D -EAGAIN)
> +=09=09=09goto out;
> +
> +=09=09xfs_trans_log_inode(args->trans, args->dp,
> +=09=09=09=09    XFS_ILOG_CORE | XFS_ILOG_ADATA);
> +
> +=09=09err2 =3D xfs_trans_roll(&args->trans);
> +=09=09if (err2) {
> +=09=09=09error =3D err2;
> +=09=09=09goto out;
> +=09=09}
> +
> +=09=09/* Rejoin inode and leaf if needed */
> +=09=09xfs_trans_ijoin(args->trans, args->dp, 0);
> +=09=09if (leaf_bp) {
> +=09=09=09xfs_trans_bjoin(args->trans, leaf_bp);
> +=09=09=09xfs_trans_bhold(args->trans, leaf_bp);
> +=09=09}
> +
> +=09} while (error =3D=3D -EAGAIN);
> +
> +out:
> +=09return error;
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
> +int
> +xfs_attr_set_later(
> +=09struct xfs_da_args=09*args,
> +=09struct xfs_buf          **leaf_bp)
> +{
>  =09struct xfs_inode=09*dp =3D args->dp;
> -=09struct xfs_buf          *leaf_bp =3D NULL;
> -=09int=09=09=09error, error2 =3D 0;;
> +=09int=09=09=09error =3D 0;
> +=09int=09=09=09sf_size;
> +
> +=09/* State machine switch */
> +=09switch (args->dc.dc_state) {
> +=09case XFS_DC_SF_TO_LEAF:
> +=09=09goto sf_to_leaf;
> +=09case XFS_DC_ALLOC_LEAF:
> +=09case XFS_DC_FOUND_LBLK:
> +=09=09goto leaf;
> +=09case XFS_DC_FOUND_NBLK:
> +=09case XFS_DC_ALLOC_NODE:
> +=09case XFS_DC_LEAF_TO_NODE:
> +=09=09goto node;
> +=09default:
> +=09=09break;
> +=09}
> +
> +=09/*
> +=09 * New inodes may not have an attribute fork yet. So set the attribut=
e
> +=09 * fork appropriately
> +=09 */
> +=09if (XFS_IFORK_Q((args->dp)) =3D=3D 0) {
> +=09=09sf_size =3D sizeof(struct xfs_attr_sf_hdr) +
> +=09=09     XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
> +=09=09xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
> +=09=09args->dp->i_afp =3D kmem_zone_zalloc(xfs_ifork_zone, 0);
> +=09=09args->dp->i_afp->if_flags =3D XFS_IFEXTENTS;
> +=09}
> =20
>  =09/*
>  =09 * If the attribute list is non-existent or a shortform list,
> @@ -272,21 +343,14 @@ xfs_attr_set_args(
>  =09=09 * Try to add the attr to the attribute list in the inode.
>  =09=09 */
>  =09=09error =3D xfs_attr_try_sf_addname(dp, args);
> -=09=09if (error !=3D -ENOSPC) {
> -=09=09=09if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
> -=09=09=09=09xfs_trans_set_sync(args->trans);
> -
> -=09=09=09error2 =3D xfs_trans_commit(args->trans);
> -=09=09=09args->trans =3D NULL;
> -=09=09=09return error ? error : error2;
> -=09=09}
> -
> +=09=09if (error !=3D -ENOSPC)
> +=09=09=09return error;
> =20
>  =09=09/*
>  =09=09 * It won't fit in the shortform, transform to a leaf block.
>  =09=09 * GROT: another possible req'mt for a double-split btree op.
>  =09=09 */
> -=09=09error =3D xfs_attr_shortform_to_leaf(args, &leaf_bp);
> +=09=09error =3D xfs_attr_shortform_to_leaf(args, leaf_bp);
>  =09=09if (error)
>  =09=09=09return error;
> =20
> @@ -294,43 +358,42 @@ xfs_attr_set_args(
>  =09=09 * Prevent the leaf buffer from being unlocked so that a
>  =09=09 * concurrent AIL push cannot grab the half-baked leaf
>  =09=09 * buffer and run into problems with the write verifier.
> -=09=09 * Once we're done rolling the transaction we can release
> -=09=09 * the hold and add the attr to the leaf.
>  =09=09 */
> -=09=09xfs_trans_bhold(args->trans, leaf_bp);
> -=09=09error =3D xfs_defer_finish(&args->trans);
> -=09=09xfs_trans_bhold_release(args->trans, leaf_bp);
> -=09=09if (error) {
> -=09=09=09xfs_trans_brelse(args->trans, leaf_bp);
> -=09=09=09return error;
> -=09=09}
> +
> +=09=09xfs_trans_bhold(args->trans, *leaf_bp);
> +=09=09args->dc.dc_state =3D XFS_DC_SF_TO_LEAF;
> +=09=09return -EAGAIN;
> +=09}
> +sf_to_leaf:
> +
> +=09/*
> +=09 * After a shortform to leaf conversion, we need to hold the leaf and
> +=09 * cylce out the transaction.  When we get back, we need to release
> +=09 * the leaf.
> +=09 */
> +=09if (*leaf_bp !=3D NULL) {
> +=09=09xfs_trans_brelse(args->trans, *leaf_bp);
> +=09=09*leaf_bp =3D NULL;
>  =09}
> =20
>  =09if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> +=09=09error =3D xfs_attr_leaf_try_add(args, *leaf_bp);
> +=09=09if (error =3D=3D -ENOSPC)
> +=09=09=09args->dc.dc_state =3D XFS_DC_LEAF_TO_NODE;
> +=09=09else if (error)
> +=09=09=09return error;
> +=09=09else
> +=09=09=09args->dc.dc_state =3D XFS_DC_FOUND_LBLK;
> +=09=09return -EAGAIN;
> +leaf:
>  =09=09error =3D xfs_attr_leaf_addname(args);
>  =09=09if (error =3D=3D -ENOSPC) {
> -=09=09=09/*
> -=09=09=09 * Commit that transaction so that the node_addname()
> -=09=09=09 * call can manage its own transactions.
> -=09=09=09 */
> -=09=09=09error =3D xfs_defer_finish(&args->trans);
> -=09=09=09if (error)
> -=09=09=09=09return error;
> -
> -=09=09=09/*
> -=09=09=09 * Commit the current trans (including the inode) and
> -=09=09=09 * start a new one.
> -=09=09=09 */
> -=09=09=09error =3D xfs_trans_roll_inode(&args->trans, dp);
> -=09=09=09if (error)
> -=09=09=09=09return error;
> -
> -=09=09=09/*
> -=09=09=09 * Fob the rest of the problem off on the Btree code.
> -=09=09=09 */
> -=09=09=09error =3D xfs_attr_node_addname(args);
> +=09=09=09args->dc.dc_state =3D XFS_DC_LEAF_TO_NODE;
> +=09=09=09return -EAGAIN;
>  =09=09}
>  =09} else {
> +=09=09args->dc.dc_state =3D XFS_DC_LEAF_TO_NODE;
> +node:
>  =09=09error =3D xfs_attr_node_addname(args);
>  =09}
>  =09return error;
> @@ -764,27 +827,26 @@ xfs_attr_leaf_try_add(
>   *
>   * This leaf block cannot have a "remote" value, we only call this routi=
ne
>   * if bmap_one_block() says there is only one block (ie: no remote blks)=
.
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
>  xfs_attr_leaf_addname(struct xfs_da_args=09*args)
>  {
> -=09int=09=09=09error, forkoff;
> -=09struct xfs_buf=09=09*bp =3D NULL;
> +=09int=09=09=09error, nmap;
>  =09struct xfs_inode=09*dp =3D args->dp;
> +=09struct xfs_bmbt_irec=09*map =3D &args->dc.map;
> =20
> -=09trace_xfs_attr_leaf_addname(args);
> -
> -=09error =3D xfs_attr_leaf_try_add(args, bp);
> -=09if (error)
> -=09=09return error;
> -
> -=09/*
> -=09 * Commit the transaction that added the attr name so that
> -=09 * later routines can manage their own transactions.
> -=09 */
> -=09error =3D xfs_trans_roll_inode(&args->trans, dp);
> -=09if (error)
> -=09=09return error;
> +=09/* State machine switch */
> +=09switch (args->dc.dc_state) {
> +=09case XFS_DC_ALLOC_LEAF:
> +=09=09goto alloc_leaf;
> +=09default:
> +=09=09break;
> +=09}
> =20
>  =09/*
>  =09 * If there was an out-of-line value, allocate the blocks we
> @@ -793,90 +855,58 @@ xfs_attr_leaf_addname(struct xfs_da_args=09*args)
>  =09 * maximum size of a transaction and/or hit a deadlock.
>  =09 */
>  =09if (args->rmtblkno > 0) {
> -=09=09error =3D xfs_attr_rmtval_set(args);
> -=09=09if (error)
> -=09=09=09return error;
> -=09}
> =20
> -=09/*
> -=09 * If this is an atomic rename operation, we must "flip" the
> -=09 * incomplete flags on the "new" and "old" attribute/value pairs
> -=09 * so that one disappears and one appears atomically.  Then we
> -=09 * must remove the "old" attribute/value pair.
> -=09 */
> -=09if (args->op_flags & XFS_DA_OP_RENAME) {
> -=09=09/*
> -=09=09 * In a separate transaction, set the incomplete flag on the
> -=09=09 * "old" attr and clear the incomplete flag on the "new" attr.
> -=09=09 */
> -=09=09error =3D xfs_attr3_leaf_flipflags(args);
> -=09=09if (error)
> -=09=09=09return error;
> -=09=09/*
> -=09=09 * Commit the flag value change and start the next trans in
> -=09=09 * series.
> -=09=09 */
> -=09=09error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> -=09=09if (error)
> -=09=09=09return error;
> +=09=09/* Open coded xfs_attr_rmtval_set without trans handling */
> =20
> -=09=09/*
> -=09=09 * Dismantle the "old" attribute/value pair by removing
> -=09=09 * a "remote" value (if it exists).
> -=09=09 */
> -=09=09args->index =3D args->index2;
> -=09=09args->blkno =3D args->blkno2;
> -=09=09args->rmtblkno =3D args->rmtblkno2;
> -=09=09args->rmtblkcnt =3D args->rmtblkcnt2;
> -=09=09args->rmtvaluelen =3D args->rmtvaluelen2;
> -=09=09if (args->rmtblkno) {
> -=09=09=09error =3D xfs_attr_rmtval_remove(args);
> -=09=09=09if (error)
> -=09=09=09=09return error;
> -=09=09}
> +=09=09args->dc.lfileoff =3D 0;
> +=09=09args->dc.lblkno =3D 0;
> +=09=09args->dc.blkcnt =3D 0;
> +=09=09args->rmtblkcnt =3D 0;
> +=09=09args->rmtblkno =3D 0;
> +=09=09memset(map, 0, sizeof(struct xfs_bmbt_irec));
> =20
> -=09=09/*
> -=09=09 * Read in the block containing the "old" attr, then
> -=09=09 * remove the "old" attr from that block (neat, huh!)
> -=09=09 */
> -=09=09error =3D xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
> -=09=09=09=09=09   XFS_DABUF_MAP_NOMAPPING, &bp);
> +=09=09error =3D xfs_attr_rmt_find_hole(args);
>  =09=09if (error)
>  =09=09=09return error;
> =20
> -=09=09xfs_attr3_leaf_remove(bp, args);
> +=09=09args->dc.blkcnt =3D args->rmtblkcnt;
> +=09=09args->dc.lblkno =3D args->rmtblkno;
> =20
>  =09=09/*
> -=09=09 * If the result is small enough, shrink it all into the inode.
> +=09=09 * Roll through the "value", allocating blocks on disk as
> +=09=09 * required.
>  =09=09 */
> -=09=09if ((forkoff =3D xfs_attr_shortform_allfit(bp, dp))) {
> -=09=09=09error =3D xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> -=09=09=09/* bp is gone due to xfs_da_shrink_inode */
> -=09=09=09if (error)
> -=09=09=09=09return error;
> -=09=09=09error =3D xfs_defer_finish(&args->trans);
> +alloc_leaf:
> +=09=09while (args->dc.blkcnt > 0) {
> +=09=09=09nmap =3D 1;
> +=09=09=09error =3D xfs_bmapi_write(args->trans, dp,
> +=09=09=09=09  (xfs_fileoff_t)args->dc.lblkno,
> +=09=09=09=09  args->dc.blkcnt, XFS_BMAPI_ATTRFORK,
> +=09=09=09=09  args->total, map, &nmap);
>  =09=09=09if (error)
>  =09=09=09=09return error;
> -=09=09}
> +=09=09=09ASSERT(nmap =3D=3D 1);
> +=09=09=09ASSERT((map->br_startblock !=3D DELAYSTARTBLOCK) &&
> +=09=09=09       (map->br_startblock !=3D HOLESTARTBLOCK));
> =20
> -=09=09/*
> -=09=09 * Commit the remove and start the next trans in series.
> -=09=09 */
> -=09=09error =3D xfs_trans_roll_inode(&args->trans, dp);
> +=09=09=09/* roll attribute extent map forwards */
> +=09=09=09args->dc.lblkno +=3D map->br_blockcount;
> +=09=09=09args->dc.blkcnt -=3D map->br_blockcount;
> =20
> -=09} else if (args->rmtblkno > 0) {
> -=09=09/*
> -=09=09 * Added a "remote" value, just clear the incomplete flag.
> -=09=09 */
> -=09=09error =3D xfs_attr3_leaf_clearflag(args);
> +=09=09=09args->dc.dc_state =3D XFS_DC_ALLOC_LEAF;
> +=09=09=09return -EAGAIN;
> +=09=09}
> +
> +=09=09error =3D xfs_attr_rmtval_set_value(args);
>  =09=09if (error)
>  =09=09=09return error;
> +=09}
> =20
> +=09if (args->rmtblkno > 0) {
>  =09=09/*
> -=09=09 * Commit the flag value change and start the next trans in
> -=09=09 * series.
> +=09=09 * Added a "remote" value, just clear the incomplete flag.
>  =09=09 */
> -=09=09error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> +=09=09error =3D xfs_attr3_leaf_clearflag(args);
>  =09}
>  =09return error;
>  }
> @@ -1017,16 +1047,23 @@ xfs_attr_node_hasname(
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
>  =09struct xfs_da_args=09*args)
>  {
> -=09struct xfs_da_state=09*state;
> +=09struct xfs_da_state=09*state =3D NULL;
>  =09struct xfs_da_state_blk=09*blk;
>  =09struct xfs_inode=09*dp;
> -=09struct xfs_mount=09*mp;
> -=09int=09=09=09retval, error;
> +=09int=09=09=09retval =3D 0;
> +=09int=09=09=09error =3D 0;
> +=09int=09=09=09nmap;
> +=09struct xfs_bmbt_irec    *map =3D &args->dc.map;
> =20
>  =09trace_xfs_attr_node_addname(args);
> =20
> @@ -1034,8 +1071,17 @@ xfs_attr_node_addname(
>  =09 * Fill in bucket of arguments/results/context to carry around.
>  =09 */
>  =09dp =3D args->dp;
> -=09mp =3D dp->i_mount;
> -restart:
> +
> +=09/* State machine switch */
> +=09switch (args->dc.dc_state) {
> +=09case XFS_DC_FOUND_NBLK:
> +=09=09goto found_nblk;
> +=09case XFS_DC_ALLOC_NODE:
> +=09=09goto alloc_node;
> +=09default:
> +=09=09break;
> +=09}
> +
>  =09/*
>  =09 * Search to see if name already exists, and get back a pointer
>  =09 * to where it should go.
> @@ -1085,19 +1131,12 @@ xfs_attr_node_addname(
>  =09=09=09error =3D xfs_attr3_leaf_to_node(args);
>  =09=09=09if (error)
>  =09=09=09=09goto out;
> -=09=09=09error =3D xfs_defer_finish(&args->trans);
> -=09=09=09if (error)
> -=09=09=09=09goto out;
> =20
>  =09=09=09/*
> -=09=09=09 * Commit the node conversion and start the next
> -=09=09=09 * trans in the chain.
> +=09=09=09 * Restart routine from the top.  No need to set  the
> +=09=09=09 * state
>  =09=09=09 */
> -=09=09=09error =3D xfs_trans_roll_inode(&args->trans, dp);
> -=09=09=09if (error)
> -=09=09=09=09goto out;
> -
> -=09=09=09goto restart;
> +=09=09=09return -EAGAIN;
>  =09=09}
> =20
>  =09=09/*
> @@ -1109,9 +1148,6 @@ xfs_attr_node_addname(
>  =09=09error =3D xfs_da3_split(state);
>  =09=09if (error)
>  =09=09=09goto out;
> -=09=09error =3D xfs_defer_finish(&args->trans);
> -=09=09if (error)
> -=09=09=09goto out;
>  =09} else {
>  =09=09/*
>  =09=09 * Addition succeeded, update Btree hashvals.
> @@ -1126,13 +1162,9 @@ xfs_attr_node_addname(
>  =09xfs_da_state_free(state);
>  =09state =3D NULL;
> =20
> -=09/*
> -=09 * Commit the leaf addition or btree split and start the next
> -=09 * trans in the chain.
> -=09 */
> -=09error =3D xfs_trans_roll_inode(&args->trans, dp);
> -=09if (error)
> -=09=09goto out;
> +=09args->dc.dc_state =3D XFS_DC_FOUND_NBLK;
> +=09return -EAGAIN;
> +found_nblk:
> =20
>  =09/*
>  =09 * If there was an out-of-line value, allocate the blocks we
> @@ -1141,104 +1173,57 @@ xfs_attr_node_addname(
>  =09 * maximum size of a transaction and/or hit a deadlock.
>  =09 */
>  =09if (args->rmtblkno > 0) {
> -=09=09error =3D xfs_attr_rmtval_set(args);
> -=09=09if (error)
> -=09=09=09return error;
> -=09}
> +=09=09/* Open coded xfs_attr_rmtval_set without trans handling */
> +=09=09args->dc.lblkno =3D 0;
> +=09=09args->dc.lfileoff =3D 0;
> +=09=09args->dc.blkcnt =3D 0;
> +=09=09args->rmtblkcnt =3D 0;
> +=09=09args->rmtblkno =3D 0;
> +=09=09memset(map, 0, sizeof(struct xfs_bmbt_irec));
> =20
> -=09/*
> -=09 * If this is an atomic rename operation, we must "flip" the
> -=09 * incomplete flags on the "new" and "old" attribute/value pairs
> -=09 * so that one disappears and one appears atomically.  Then we
> -=09 * must remove the "old" attribute/value pair.
> -=09 */
> -=09if (args->op_flags & XFS_DA_OP_RENAME) {
> -=09=09/*
> -=09=09 * In a separate transaction, set the incomplete flag on the
> -=09=09 * "old" attr and clear the incomplete flag on the "new" attr.
> -=09=09 */
> -=09=09error =3D xfs_attr3_leaf_flipflags(args);
> -=09=09if (error)
> -=09=09=09goto out;
> -=09=09/*
> -=09=09 * Commit the flag value change and start the next trans in
> -=09=09 * series
> -=09=09 */
> -=09=09error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> +=09=09error =3D xfs_attr_rmt_find_hole(args);
>  =09=09if (error)
> -=09=09=09goto out;
> +=09=09=09return error;
> =20
> +=09=09args->dc.blkcnt =3D args->rmtblkcnt;
> +=09=09args->dc.lblkno =3D args->rmtblkno;
>  =09=09/*
> -=09=09 * Dismantle the "old" attribute/value pair by removing
> -=09=09 * a "remote" value (if it exists).
> +=09=09 * Roll through the "value", allocating blocks on disk as
> +=09=09 * required.
>  =09=09 */
> -=09=09args->index =3D args->index2;
> -=09=09args->blkno =3D args->blkno2;
> -=09=09args->rmtblkno =3D args->rmtblkno2;
> -=09=09args->rmtblkcnt =3D args->rmtblkcnt2;
> -=09=09args->rmtvaluelen =3D args->rmtvaluelen2;
> -=09=09if (args->rmtblkno) {
> -=09=09=09error =3D xfs_attr_rmtval_remove(args);
> +alloc_node:
> +=09=09while (args->dc.blkcnt > 0) {
> +=09=09=09nmap =3D 1;
> +=09=09=09error =3D xfs_bmapi_write(args->trans, dp,
> +=09=09=09=09(xfs_fileoff_t)args->dc.lblkno, args->dc.blkcnt,
> +=09=09=09=09XFS_BMAPI_ATTRFORK, args->total, map, &nmap);
>  =09=09=09if (error)
>  =09=09=09=09return error;
> -=09=09}
> =20
> -=09=09/*
> -=09=09 * Re-find the "old" attribute entry after any split ops.
> -=09=09 * The INCOMPLETE flag means that we will find the "old"
> -=09=09 * attr, not the "new" one.
> -=09=09 */
> -=09=09args->name.type |=3D XFS_ATTR_INCOMPLETE;
> -=09=09state =3D xfs_da_state_alloc();
> -=09=09state->args =3D args;
> -=09=09state->mp =3D mp;
> -=09=09state->inleaf =3D 0;
> -=09=09error =3D xfs_da3_node_lookup_int(state, &retval);
> -=09=09if (error)
> -=09=09=09goto out;
> +=09=09=09ASSERT(nmap =3D=3D 1);
> +=09=09=09ASSERT((map->br_startblock !=3D DELAYSTARTBLOCK) &&
> +=09=09=09       (map->br_startblock !=3D HOLESTARTBLOCK));
> =20
> -=09=09/*
> -=09=09 * Remove the name and update the hashvals in the tree.
> -=09=09 */
> -=09=09blk =3D &state->path.blk[ state->path.active-1 ];
> -=09=09ASSERT(blk->magic =3D=3D XFS_ATTR_LEAF_MAGIC);
> -=09=09error =3D xfs_attr3_leaf_remove(blk->bp, args);
> -=09=09xfs_da3_fixhashpath(state, &state->path);
> +=09=09=09/* roll attribute extent map forwards */
> +=09=09=09args->dc.lblkno +=3D map->br_blockcount;
> +=09=09=09args->dc.blkcnt -=3D map->br_blockcount;
> =20
> -=09=09/*
> -=09=09 * Check to see if the tree needs to be collapsed.
> -=09=09 */
> -=09=09if (retval && (state->path.active > 1)) {
> -=09=09=09error =3D xfs_da3_join(state);
> -=09=09=09if (error)
> -=09=09=09=09goto out;
> -=09=09=09error =3D xfs_defer_finish(&args->trans);
> -=09=09=09if (error)
> -=09=09=09=09goto out;
> +=09=09=09args->dc.dc_state =3D XFS_DC_ALLOC_NODE;
> +=09=09=09return -EAGAIN;
>  =09=09}
> =20
> -=09=09/*
> -=09=09 * Commit and start the next trans in the chain.
> -=09=09 */
> -=09=09error =3D xfs_trans_roll_inode(&args->trans, dp);
> +=09=09error =3D xfs_attr_rmtval_set_value(args);
>  =09=09if (error)
> -=09=09=09goto out;
> +=09=09=09return error;
> +=09}
> =20
> -=09} else if (args->rmtblkno > 0) {
> +=09if (args->rmtblkno > 0) {
>  =09=09/*
>  =09=09 * Added a "remote" value, just clear the incomplete flag.
>  =09=09 */
>  =09=09error =3D xfs_attr3_leaf_clearflag(args);
>  =09=09if (error)
>  =09=09=09goto out;
> -
> -=09=09 /*
> -=09=09  * Commit the flag value change and start the next trans in
> -=09=09  * series.
> -=09=09  */
> -=09=09error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> -=09=09if (error)
> -=09=09=09goto out;
>  =09}
>  =09retval =3D error =3D 0;
> =20
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index fb8bf5b..c710387 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -149,6 +149,7 @@ int xfs_attr_get(struct xfs_inode *ip, struct xfs_nam=
e *name,
>  int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
>  =09=09 unsigned char *value, int valuelen, int flags);
>  int xfs_attr_set_args(struct xfs_da_args *args);
> +int xfs_attr_set_later(struct xfs_da_args *args, struct xfs_buf **leaf_b=
p);
>  int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int fla=
gs);
>  int xfs_has_attr(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
> --=20
> 2.7.4
>=20


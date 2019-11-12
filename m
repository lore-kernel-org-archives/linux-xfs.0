Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A8EC17440
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 13:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1B0D2084F
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 13:37:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N/WnhWZm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfKLNhJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 08:37:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47051 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726988AbfKLNhJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 08:37:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573565826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IXI7PXK+B6dPpr/1nRm6T6py5f6Fr2/AiTDSB7b+Eko=;
        b=N/WnhWZmZX7qwWaFM6LBSy8L7Yr+Wxfs7Bc0QWKl4xyoWztunkvYkzHJz7Cu35UHcZjtmY
        g/ygo+YWhmgXuwWll9nTuqXZfU8lyYx+EpAJ8lRAX8YC7o23xEjxFasvczfnloVTy7aXe3
        bsYTsJsrti5kSynMBjX7QFhygTitdro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-lgEqVsLYMEqT_qNda48oUw-1; Tue, 12 Nov 2019 08:37:05 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60F9685B6FB;
        Tue, 12 Nov 2019 13:37:04 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E57F729621;
        Tue, 12 Nov 2019 13:37:03 +0000 (UTC)
Date:   Tue, 12 Nov 2019 08:37:02 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 16/17] xfs: Add delay ready attr remove routines
Message-ID: <20191112133702.GA46980@bfoster>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-17-allison.henderson@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20191107012801.22863-17-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: lgEqVsLYMEqT_qNda48oUw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 06:28:00PM -0700, Allison Collins wrote:
> This patch modifies the attr remove routines to be delay ready.
> This means they no longer roll or commit transactions, but instead
> return -EAGAIN to have the calling routine roll and refresh the
> transaction.  In this series, xfs_attr_remove_args has become
> xfs_attr_remove_later, which uses a state machine to keep track
> of where it was when EAGAIN was returned.  xfs_attr_node_removename
> has also been modified to use the state machine, and a  new version of
> xfs_attr_remove_args consists of a simple loop to refresh the
> transaction until the operation is completed.
>=20
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---

On a cursory look, this is definitely more along the lines of what I was
thinking on the previous revisions. I would like to see if we can get a
bit more refactoring/cleanup before this point though. Further thoughts
inline..

>  fs/xfs/libxfs/xfs_attr.c | 123 +++++++++++++++++++++++++++++++++++++++--=
------
>  fs/xfs/libxfs/xfs_attr.h |   1 +
>  2 files changed, 104 insertions(+), 20 deletions(-)
>=20
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 626d4a98..38d5c5c 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -369,10 +369,56 @@ xfs_has_attr(
>   */
>  int
>  xfs_attr_remove_args(
> +=09struct xfs_da_args=09*args)
> +{
> +=09int=09=09=09error =3D 0;
> +=09int=09=09=09err2 =3D 0;
> +
> +=09do {
> +=09=09error =3D xfs_attr_remove_later(args);
> +=09=09if (error && error !=3D -EAGAIN)
> +=09=09=09goto out;

xfs_attr_remove_later() strikes me as an odd name with respect to the
functionality. Perhaps something like xfs_attr_remove_step() is
(slightly) more accurate..?

> +
> +=09=09xfs_trans_log_inode(args->trans, args->dp,
> +=09=09=09XFS_ILOG_CORE | XFS_ILOG_ADATA);
> +
> +=09=09err2 =3D xfs_trans_roll(&args->trans);
> +=09=09if (err2) {
> +=09=09=09error =3D err2;

Also do we really need two error codes in this function? It seems like
we should be able to write this with one, but I haven't tried it..

> +=09=09=09goto out;
> +=09=09}
> +
> +=09=09/* Rejoin inode */
> +=09=09xfs_trans_ijoin(args->trans, args->dp, 0);
> +
> +=09} while (error =3D=3D -EAGAIN);
> +out:
> +=09return error;
> +}
> +
> +/*
> + * Remove the attribute specified in @args.
> + * This routine is meant to function as a delayed operation, and may ret=
urn
> + * -EGAIN when the transaction needs to be rolled.  Calling functions wi=
ll need
> + * to handle this, and recall the function until a successful error code=
 is
> + * returned.
> + */
> +int
> +xfs_attr_remove_later(
>  =09struct xfs_da_args      *args)
>  {
>  =09struct xfs_inode=09*dp =3D args->dp;
> -=09int=09=09=09error;
> +=09int=09=09=09error =3D 0;
> +
> +=09/* State machine switch */
> +=09switch (args->dc.dc_state) {
> +=09case XFS_DC_RM_INVALIDATE:
> +=09case XFS_DC_RM_SHRINK:
> +=09case XFS_DC_RM_NODE_BLKS:
> +=09=09goto node;
> +=09default:
> +=09=09break;
> +=09}
> =20
>  =09if (!xfs_inode_hasattr(dp)) {
>  =09=09error =3D -ENOATTR;
> @@ -382,6 +428,7 @@ xfs_attr_remove_args(
>  =09} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>  =09=09error =3D xfs_attr_leaf_removename(args);
>  =09} else {
> +node:
>  =09=09error =3D xfs_attr_node_removename(args);
>  =09}
> =20
> @@ -892,9 +939,6 @@ xfs_attr_leaf_removename(
>  =09=09/* bp is gone due to xfs_da_shrink_inode */
>  =09=09if (error)
>  =09=09=09return error;
> -=09=09error =3D xfs_defer_finish(&args->trans);
> -=09=09if (error)
> -=09=09=09return error;
>  =09}
>  =09return 0;
>  }
> @@ -1212,6 +1256,11 @@ xfs_attr_node_addname(
>   * This will involve walking down the Btree, and may involve joining
>   * leaf nodes and even joining intermediate nodes up to and including
>   * the root node (a special case of an intermediate node).
> + *
> + * This routine is meant to function as a delayed operation, and may ret=
urn
> + * -EAGAIN when the transaction needs to be rolled.  Calling functions
> + * will need to handle this, and recall the function until a successful =
error
> + * code is returned.
>   */
>  STATIC int
>  xfs_attr_node_removename(
> @@ -1222,12 +1271,29 @@ xfs_attr_node_removename(
>  =09struct xfs_buf=09=09*bp;
>  =09int=09=09=09retval, error, forkoff;
>  =09struct xfs_inode=09*dp =3D args->dp;
> +=09int=09=09=09done =3D 0;
> =20
>  =09trace_xfs_attr_node_removename(args);
> +=09state =3D args->dc.da_state;
> +=09blk =3D args->dc.blk;
> +
> +=09/* State machine switch */
> +=09switch (args->dc.dc_state) {
> +=09case XFS_DC_RM_NODE_BLKS:
> +=09=09goto rm_node_blks;
> +=09case XFS_DC_RM_INVALIDATE:
> +=09=09goto rm_invalidate;
> +=09case XFS_DC_RM_SHRINK:
> +=09=09goto rm_shrink;
> +=09default:
> +=09=09break;

I wonder if it's worth having an explicit state for the initial path.
That could be useful for readability and debuggability in the future.

> +=09}
> =20
>  =09error =3D xfs_attr_node_hasname(args, &state);
>  =09if (error !=3D -EEXIST)
>  =09=09goto out;
> +=09else
> +=09=09error =3D 0;
> =20
>  =09/*
>  =09 * If there is an out-of-line value, de-allocate the blocks.
> @@ -1237,6 +1303,14 @@ xfs_attr_node_removename(
>  =09blk =3D &state->path.blk[ state->path.active-1 ];
>  =09ASSERT(blk->bp !=3D NULL);
>  =09ASSERT(blk->magic =3D=3D XFS_ATTR_LEAF_MAGIC);
> +
> +=09/*
> +=09 * Store blk and state in the context incase we need to cycle out the
> +=09 * transaction
> +=09 */
> +=09args->dc.blk =3D blk;
> +=09args->dc.da_state =3D state;
> +
>  =09if (args->rmtblkno > 0) {
>  =09=09/*
>  =09=09 * Fill in disk block numbers in the state structure
> @@ -1255,13 +1329,30 @@ xfs_attr_node_removename(
>  =09=09if (error)
>  =09=09=09goto out;
> =20
> -=09=09error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> +=09=09args->dc.dc_state =3D XFS_DC_RM_INVALIDATE;
> +=09=09return -EAGAIN;
> +rm_invalidate:
> +=09=09error =3D xfs_attr_rmtval_invalidate(args);
>  =09=09if (error)
>  =09=09=09goto out;
> +rm_node_blks:

While I think the design is the right idea, jumping down into a function
like this is pretty hairy. I think we should try to further break this
function down into smaller elements one way or another that model the
steps defined by the state structure. There's probably multiple ways to
do that. For example, the remote attr bits could be broken down into
a subfunction that processes the couple of states associated with remote
blocks. That said, ISTM it might be wiser to try and keep the state
processing in one place if possible. That would imply to break the
remote processing loop down into a couple functions. All in all, this
function might end up looking something like:

xfs_attr_node_removename()
{
=09/* switch statement and comment to document each state */

=09error =3D xfs_attr_node_hasname(args, &state);
=09...

=09if (remote) {
=09=09error =3D do_setflag();
=09=09if (error)
=09=09=09return error;

=09=09/* roll */
=09=09state =3D INVALIDATE;
=09=09return -EAGAIN;
=09}

rmt_invalidate:
=09state =3D INVALIDATE;
=09if (remote)
=09=09do_invalidate();
=09/* fallthru */

rmt_rm_blks:
=09state =3D RM_NODE_BLKS;
=09if (remote) {
=09=09/* loops and returns -EAGAIN until we fallthru */
=09=09error =3D rmt_remove_step();
=09=09if (error)
=09=09=09return error;

=09=09xfs_attr_refillstate();
=09}

/* maybe worth a new state here? */
removename:
=09state =3D REMOVENAME;
=09xfs_attr3_leaf_remove();
=09...
=09if (...) {
=09=09state =3D SHRINK;
=09=09return -EAGAIN;
=09}

shrink:
=09state =3D SHRINK;
=09error =3D do_shrink();

=09return 0;
}

I'm not totally sold on the idea of rolling the state forward explicitly
like this, but it seems like it could be a bit more maintainable. All in
all this is still fairly ugly, but this is mostly a mechanical attempt
to keep state management isolated and we can polish it up from there.
Thoughts?

Brian

> +=09=09/*
> +=09=09 * Unmap value blocks for this attr.  This is similar to
> +=09=09 * xfs_attr_rmtval_remove, but open coded here to return EAGAIN
> +=09=09 * for new transactions
> +=09=09 */
> +=09=09while (!done && !error) {
> +=09=09=09error =3D xfs_bunmapi(args->trans, args->dp,
> +=09=09=09=09    args->rmtblkno, args->rmtblkcnt,
> +=09=09=09=09    XFS_BMAPI_ATTRFORK, 1, &done);
> +=09=09=09if (error)
> +=09=09=09=09return error;
> =20
> -=09=09error =3D xfs_attr_rmtval_remove(args);
> -=09=09if (error)
> -=09=09=09goto out;
> +=09=09=09if (!done) {
> +=09=09=09=09args->dc.dc_state =3D XFS_DC_RM_NODE_BLKS;
> +=09=09=09=09return -EAGAIN;
> +=09=09=09}
> +=09=09}
> =20
>  =09=09/*
>  =09=09 * Refill the state structure with buffers, the prior calls
> @@ -1287,17 +1378,12 @@ xfs_attr_node_removename(
>  =09=09error =3D xfs_da3_join(state);
>  =09=09if (error)
>  =09=09=09goto out;
> -=09=09error =3D xfs_defer_finish(&args->trans);
> -=09=09if (error)
> -=09=09=09goto out;
> -=09=09/*
> -=09=09 * Commit the Btree join operation and start a new trans.
> -=09=09 */
> -=09=09error =3D xfs_trans_roll_inode(&args->trans, dp);
> -=09=09if (error)
> -=09=09=09goto out;
> +
> +=09=09args->dc.dc_state =3D XFS_DC_RM_SHRINK;
> +=09=09return -EAGAIN;
>  =09}
> =20
> +rm_shrink:
>  =09/*
>  =09 * If the result is small enough, push it all into the inode.
>  =09 */
> @@ -1319,9 +1405,6 @@ xfs_attr_node_removename(
>  =09=09=09/* bp is gone due to xfs_da_shrink_inode */
>  =09=09=09if (error)
>  =09=09=09=09goto out;
> -=09=09=09error =3D xfs_defer_finish(&args->trans);
> -=09=09=09if (error)
> -=09=09=09=09goto out;
>  =09=09} else
>  =09=09=09xfs_trans_brelse(args->trans, bp);
>  =09}
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 3b5dad4..fb8bf5b 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -152,6 +152,7 @@ int xfs_attr_set_args(struct xfs_da_args *args);
>  int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int fla=
gs);
>  int xfs_has_attr(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
> +int xfs_attr_remove_later(struct xfs_da_args *args);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  =09=09  int flags, struct attrlist_cursor_kern *cursor);
>  bool xfs_attr_namecheck(const void *name, size_t length);
> --=20
> 2.7.4
>=20


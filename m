Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5238FC43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 17:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0497120818
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 17:40:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gX5TiwGC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKKRk4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 12:40:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22350 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726879AbfKKRk4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 12:40:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573494054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p9rrXyQqYfLH/zmpOeRTx9Ziln3IaYGmi1fFmFCWqiE=;
        b=gX5TiwGCw4PQ+maJQ2Ge/vHpm0EGZW/ZnJwWQigKCixPaxBoBy41Cp4PHcyLjvVj0WBSZM
        a1tKd6lL4BpNkZboEpOtxi5LBlWkfK9X0hVn9mjWXsJ32LtBM/FTACrkx27/Lcggo6SfSE
        VFce7Tu0Qz+CUt2uKVJ9FAbw1lfk8fA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-BY96CZhTP-GNPtsz166ivw-1; Mon, 11 Nov 2019 12:40:53 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 624D08017E0;
        Mon, 11 Nov 2019 17:40:52 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ED7BB60852;
        Mon, 11 Nov 2019 17:40:51 +0000 (UTC)
Date:   Mon, 11 Nov 2019 12:40:50 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 05/17] xfs: Add xfs_has_attr and subroutines
Message-ID: <20191111174050.GC46312@bfoster>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-6-allison.henderson@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20191107012801.22863-6-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: BY96CZhTP-GNPtsz166ivw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 06:27:49PM -0700, Allison Collins wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
>=20
> This patch adds a new functions to check for the existence of
> an attribute.  Subroutines are also added to handle the cases
> of leaf blocks, nodes or shortform.  Common code that appears
> in existing attr add and remove functions have been factored
> out to help reduce the appearence of duplicated code.  We will
> need these routines later for delayed attributes since delayed
> operations cannot return error codes.
>=20
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---

This mostly looks good to me. Just some small nits..

>  fs/xfs/libxfs/xfs_attr.c      | 154 +++++++++++++++++++++++++++---------=
------
>  fs/xfs/libxfs/xfs_attr.h      |   1 +
>  fs/xfs/libxfs/xfs_attr_leaf.c | 107 ++++++++++++++++++-----------
>  fs/xfs/libxfs/xfs_attr_leaf.h |   2 +
>  4 files changed, 171 insertions(+), 93 deletions(-)
>=20
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 5cb83a8..c8a3273 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -310,6 +313,34 @@ xfs_attr_set_args(
>  }
> =20
>  /*
> + * Return EEXIST if attr is found, or ENOATTR if not
> + */
> +int
> +xfs_has_attr(
> +=09struct xfs_da_args      *args)
> +{
> +=09struct xfs_inode        *dp =3D args->dp;
> +=09struct xfs_buf=09=09*bp;
> +=09int                     error;
> +
> +=09if (!xfs_inode_hasattr(dp)) {
> +=09=09error =3D -ENOATTR;
> +=09} else if (dp->i_d.di_aformat =3D=3D XFS_DINODE_FMT_LOCAL) {
> +=09=09ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> +=09=09error =3D xfs_attr_shortform_hasname(args, NULL, NULL);
> +=09} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> +=09=09error =3D xfs_attr_leaf_hasname(args, &bp);
> +=09=09if (error !=3D -ENOATTR && error !=3D -EEXIST)
> +=09=09=09goto out;

Hmm.. is this basically an indirect check for whether bp is set? If so,
I think doing bp =3D NULL above and:

=09=09if (bp)
=09=09=09xfs_trans_brelse(args->trans, bp);

... is more straightforward.

> +=09=09xfs_trans_brelse(args->trans, bp);
> +=09} else {
> +=09=09error =3D xfs_attr_node_hasname(args, NULL);
> +=09}
> +out:
> +=09return error;
> +}
> +
> +/*
>   * Remove the attribute specified in @args.
>   */
>  int
...
> @@ -832,6 +869,38 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>  =09return error;
>  }
> =20
> +/*
> + * Return EEXIST if attr is found, or ENOATTR if not
> + * statep: If not null is set to point at the found state.  Caller will
> + * =09   be responsible for freeing the state in this case.
> + */
> +STATIC int
> +xfs_attr_node_hasname(
> +=09struct xfs_da_args=09*args,
> +=09struct xfs_da_state=09**statep)
> +{
> +=09struct xfs_da_state=09*state;
> +=09int=09=09=09retval, error;
> +
> +=09state =3D xfs_da_state_alloc();
> +=09state->args =3D args;
> +=09state->mp =3D args->dp->i_mount;
> +
> +=09/*
> +=09 * Search to see if name exists, and get back a pointer to it.
> +=09 */
> +=09error =3D xfs_da3_node_lookup_int(state, &retval);
> +=09if (error =3D=3D 0)
> +=09=09error =3D retval;
> +
> +=09if (statep !=3D NULL)
> +=09=09*statep =3D state;
> +=09else
> +=09=09xfs_da_state_free(state);
> +
> +=09return error;
> +}

The state allocation handling is a little wonky here in the error
scenario. I think precedent is that if we're returning an unexpected
error, we should probably just free state directly rather than rely on
the caller to do so. If the function returns "success" (meaning -EEXIST
or -ENOATTR), then the caller owns the state memory. It might also make
sense to NULL init the pointer either at the top of this helper or the
caller.

> +
>  /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   * External routines when attribute list size > geo->blksize
>   *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D*/
...
> @@ -1324,20 +1376,14 @@ xfs_attr_node_get(xfs_da_args_t *args)
> =20
>  =09trace_xfs_attr_node_get(args);
> =20
> -=09state =3D xfs_da_state_alloc();
> -=09state->args =3D args;
> -=09state->mp =3D args->dp->i_mount;
> -
>  =09/*
>  =09 * Search to see if name exists, and get back a pointer to it.
>  =09 */
> -=09error =3D xfs_da3_node_lookup_int(state, &retval);
> -=09if (error) {
> +=09error =3D xfs_attr_node_hasname(args, &state);
> +=09if (error !=3D -EEXIST) {
>  =09=09retval =3D error;

Can we kill retval in this function now? The only use is to assign error
to it.

>  =09=09goto out_release;
>  =09}
> -=09if (retval !=3D -EEXIST)
> -=09=09goto out_release;
> =20
>  =09/*
>  =09 * Get the value, local or "remote"
...
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.=
c
> index 93c3496..d06cfd6 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -655,18 +655,67 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
>  }
> =20
>  /*
> + * Return -EEXIST if attr is found, or -ENOATTR if not
> + * args:  args containing attribute name and namelen
> + * sfep:  If not null, pointer will be set to the last attr entry found =
on
> +=09  -EEXIST.  On -ENOATTR pointer is left at the last entry in the list
> + * basep: If not null, pointer is set to the byte offset of the entry in=
 the
> + *=09  list on -EEXIST.  On -ENOATTR, pointer is left at the byte offset=
 of
> + *=09  the last entry in the list
> + */
> +int
> +xfs_attr_shortform_hasname(
> +=09struct xfs_da_args=09 *args,
> +=09struct xfs_attr_sf_entry **sfep,
> +=09int=09=09=09 *basep)
> +{
> +=09struct xfs_attr_shortform *sf;
> +=09struct xfs_attr_sf_entry *sfe;
> +=09int=09=09=09base =3D sizeof(struct xfs_attr_sf_hdr);
> +=09int=09=09=09size =3D 0;
> +=09int=09=09=09end;
> +=09int=09=09=09i;
> +
> +=09base =3D sizeof(struct xfs_attr_sf_hdr);

Double init.

> +=09sf =3D (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
> +=09sfe =3D &sf->list[0];
> +=09end =3D sf->hdr.count;
> +=09for (i =3D 0; i < end; sfe =3D XFS_ATTR_SF_NEXTENTRY(sfe),
> +=09=09=09base +=3D size, i++) {
> +=09=09size =3D XFS_ATTR_SF_ENTSIZE(sfe);
> +=09=09if (sfe->namelen !=3D args->name.len)
> +=09=09=09continue;
> +=09=09if (memcmp(sfe->nameval, args->name.name, args->name.len) !=3D 0)
> +=09=09=09continue;
> +=09=09if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
> +=09=09=09continue;
> +=09=09break;
> +=09}
> +
> +=09if (sfep !=3D NULL)
> +=09=09*sfep =3D sfe;
> +
> +=09if (basep !=3D NULL)
> +=09=09*basep =3D base;
> +
> +=09if (i =3D=3D end)
> +=09=09return -ENOATTR;
> +=09return -EEXIST;
> +}
> +
> +/*
>   * Add a name/value pair to the shortform attribute list.
>   * Overflow from the inode has already been checked for.
>   */
>  void
>  xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>  {
> -=09xfs_attr_shortform_t *sf;
> -=09xfs_attr_sf_entry_t *sfe;
> -=09int i, offset, size;
> -=09xfs_mount_t *mp;
> -=09xfs_inode_t *dp;
> -=09struct xfs_ifork *ifp;
> +=09struct xfs_attr_shortform=09*sf;
> +=09struct xfs_attr_sf_entry=09*sfe;
> +=09int=09=09=09=09offset, size, error;
> +=09struct xfs_mount=09=09*mp;
> +=09struct xfs_inode=09=09*dp;
> +=09struct xfs_ifork=09=09*ifp;

Might as well fix up the typedef in the function signature (here and
below) as well.

Brian

> =20
>  =09trace_xfs_attr_sf_add(args);
> =20
> @@ -677,18 +726,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int fork=
off)
>  =09ifp =3D dp->i_afp;
>  =09ASSERT(ifp->if_flags & XFS_IFINLINE);
>  =09sf =3D (xfs_attr_shortform_t *)ifp->if_u1.if_data;
> -=09sfe =3D &sf->list[0];
> -=09for (i =3D 0; i < sf->hdr.count; sfe =3D XFS_ATTR_SF_NEXTENTRY(sfe), =
i++) {
> -#ifdef DEBUG
> -=09=09if (sfe->namelen !=3D args->name.len)
> -=09=09=09continue;
> -=09=09if (memcmp(args->name.name, sfe->nameval, args->name.len) !=3D 0)
> -=09=09=09continue;
> -=09=09if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
> -=09=09=09continue;
> -=09=09ASSERT(0);
> -#endif
> -=09}
> +=09error =3D xfs_attr_shortform_hasname(args, &sfe, NULL);
> +=09ASSERT(error !=3D -EEXIST);
> =20
>  =09offset =3D (char *)sfe - (char *)sf;
>  =09size =3D XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
> @@ -733,33 +772,23 @@ xfs_attr_fork_remove(
>  int
>  xfs_attr_shortform_remove(xfs_da_args_t *args)
>  {
> -=09xfs_attr_shortform_t *sf;
> -=09xfs_attr_sf_entry_t *sfe;
> -=09int base, size=3D0, end, totsize, i;
> -=09xfs_mount_t *mp;
> -=09xfs_inode_t *dp;
> +=09struct xfs_attr_shortform=09*sf;
> +=09struct xfs_attr_sf_entry=09*sfe;
> +=09int=09=09=09=09base, size =3D 0, end, totsize;
> +=09struct xfs_mount=09=09*mp;
> +=09struct xfs_inode=09=09*dp;
> +=09int=09=09=09=09error;
> =20
>  =09trace_xfs_attr_sf_remove(args);
> =20
>  =09dp =3D args->dp;
>  =09mp =3D dp->i_mount;
> -=09base =3D sizeof(xfs_attr_sf_hdr_t);
>  =09sf =3D (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
> -=09sfe =3D &sf->list[0];
> -=09end =3D sf->hdr.count;
> -=09for (i =3D 0; i < end; sfe =3D XFS_ATTR_SF_NEXTENTRY(sfe),
> -=09=09=09=09=09base +=3D size, i++) {
> -=09=09size =3D XFS_ATTR_SF_ENTSIZE(sfe);
> -=09=09if (sfe->namelen !=3D args->name.len)
> -=09=09=09continue;
> -=09=09if (memcmp(sfe->nameval, args->name.name, args->name.len) !=3D 0)
> -=09=09=09continue;
> -=09=09if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
> -=09=09=09continue;
> -=09=09break;
> -=09}
> -=09if (i =3D=3D end)
> -=09=09return -ENOATTR;
> +
> +=09error =3D xfs_attr_shortform_hasname(args, &sfe, &base);
> +=09if (error !=3D -EEXIST)
> +=09=09return error;
> +=09size =3D XFS_ATTR_SF_ENTSIZE(sfe);
> =20
>  =09/*
>  =09 * Fix up the attribute fork data, covering the hole
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.=
h
> index 017480e..e108b37 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -42,6 +42,8 @@ int=09xfs_attr_shortform_getvalue(struct xfs_da_args *a=
rgs);
>  int=09xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
>  =09=09=09struct xfs_buf **leaf_bp);
>  int=09xfs_attr_shortform_remove(struct xfs_da_args *args);
> +int=09xfs_attr_shortform_hasname(struct xfs_da_args *args,
> +=09=09=09       struct xfs_attr_sf_entry **sfep, int *basep);
>  int=09xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp=
);
>  int=09xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
>  xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
> --=20
> 2.7.4
>=20


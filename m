Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66EF6CA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 10:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E2C221479
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 10:04:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jFeLdqMC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfJ2KEG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 06:04:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38538 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725776AbfJ2KEG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 06:04:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572343444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8mZ0paMBYNdZ+a7xdhLlboQ4a9PAIMGkZA3Fvib/XMg=;
        b=jFeLdqMC+XR6evsko3Qkg6diaEZmd8bd7uyataKD1lLtm0XyUj6nnGInQu30pJxvUGTTNb
        bfJEStZIo/1E12i5RQ6fhxarcZQmhaZKXB7BiU+MhyALDwj0NZeYAU+U8yDA1WhbB8CNcW
        eNUcrPVVPRQ94AxQYEIC1by73RFYpD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-ARtjMVRaOfyZPBg8OZzDWw-1; Tue, 29 Oct 2019 06:04:01 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 073C01005509;
        Tue, 29 Oct 2019 10:04:00 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 92035600F4;
        Tue, 29 Oct 2019 10:03:59 +0000 (UTC)
Date:   Tue, 29 Oct 2019 06:03:57 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/4] xfs: namecheck attribute names before listing them
Message-ID: <20191029100357.GC41131@bfoster>
References: <157232182246.593721.4902116478429075171.stgit@magnolia>
 <157232183873.593721.440778415935090240.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157232183873.593721.440778415935090240.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: ARtjMVRaOfyZPBg8OZzDWw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 09:03:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Actually call namecheck on attribute names before we hand them over to
> userspace.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr_leaf.h |    4 +--
>  fs/xfs/xfs_attr_list.c        |   60 +++++++++++++++++++++++++++--------=
------
>  2 files changed, 41 insertions(+), 23 deletions(-)
>=20
>=20
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.=
h
> index 7b74e18becff..bb0880057ee3 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -67,8 +67,8 @@ int=09xfs_attr3_leaf_add(struct xfs_buf *leaf_buffer,
>  =09=09=09=09 struct xfs_da_args *args);
>  int=09xfs_attr3_leaf_remove(struct xfs_buf *leaf_buffer,
>  =09=09=09=09    struct xfs_da_args *args);
> -void=09xfs_attr3_leaf_list_int(struct xfs_buf *bp,
> -=09=09=09=09      struct xfs_attr_list_context *context);
> +int=09xfs_attr3_leaf_list_int(struct xfs_buf *bp,
> +=09=09=09=09struct xfs_attr_list_context *context);
> =20
>  /*
>   * Routines used for shrinking the Btree.
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 00758fdc2fec..c02f22d50e45 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -49,14 +49,16 @@ xfs_attr_shortform_compare(const void *a, const void =
*b)
>   * we can begin returning them to the user.
>   */
>  static int
> -xfs_attr_shortform_list(xfs_attr_list_context_t *context)
> +xfs_attr_shortform_list(
> +=09struct xfs_attr_list_context=09*context)
>  {
> -=09attrlist_cursor_kern_t *cursor;
> -=09xfs_attr_sf_sort_t *sbuf, *sbp;
> -=09xfs_attr_shortform_t *sf;
> -=09xfs_attr_sf_entry_t *sfe;
> -=09xfs_inode_t *dp;
> -=09int sbsize, nsbuf, count, i;
> +=09struct attrlist_cursor_kern=09*cursor;
> +=09struct xfs_attr_sf_sort=09=09*sbuf, *sbp;
> +=09struct xfs_attr_shortform=09*sf;
> +=09struct xfs_attr_sf_entry=09*sfe;
> +=09struct xfs_inode=09=09*dp;
> +=09int=09=09=09=09sbsize, nsbuf, count, i;
> +=09int=09=09=09=09error =3D 0;
> =20
>  =09ASSERT(context !=3D NULL);
>  =09dp =3D context->dp;
> @@ -84,6 +86,11 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *conte=
xt)
>  =09    (XFS_ISRESET_CURSOR(cursor) &&
>  =09     (dp->i_afp->if_bytes + sf->hdr.count * 16) < context->bufsize)) =
{
>  =09=09for (i =3D 0, sfe =3D &sf->list[0]; i < sf->hdr.count; i++) {
> +=09=09=09if (!xfs_attr_namecheck(sfe->nameval, sfe->namelen)) {
> +=09=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +=09=09=09=09=09=09 context->dp->i_mount);
> +=09=09=09=09return -EFSCORRUPTED;
> +=09=09=09}
>  =09=09=09context->put_listent(context,
>  =09=09=09=09=09     sfe->flags,
>  =09=09=09=09=09     sfe->nameval,
> @@ -161,10 +168,8 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *con=
text)
>  =09=09=09break;
>  =09=09}
>  =09}
> -=09if (i =3D=3D nsbuf) {
> -=09=09kmem_free(sbuf);
> -=09=09return 0;
> -=09}
> +=09if (i =3D=3D nsbuf)
> +=09=09goto out;
> =20
>  =09/*
>  =09 * Loop putting entries into the user buffer.
> @@ -174,6 +179,12 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *con=
text)
>  =09=09=09cursor->hashval =3D sbp->hash;
>  =09=09=09cursor->offset =3D 0;
>  =09=09}
> +=09=09if (!xfs_attr_namecheck(sbp->name, sbp->namelen)) {
> +=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +=09=09=09=09=09 context->dp->i_mount);
> +=09=09=09error =3D -EFSCORRUPTED;
> +=09=09=09goto out;
> +=09=09}
>  =09=09context->put_listent(context,
>  =09=09=09=09     sbp->flags,
>  =09=09=09=09     sbp->name,
> @@ -183,9 +194,9 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *cont=
ext)
>  =09=09=09break;
>  =09=09cursor->offset++;
>  =09}
> -
> +out:
>  =09kmem_free(sbuf);
> -=09return 0;
> +=09return error;
>  }
> =20
>  /*
> @@ -284,7 +295,7 @@ xfs_attr_node_list(
>  =09struct xfs_buf=09=09=09*bp;
>  =09struct xfs_inode=09=09*dp =3D context->dp;
>  =09struct xfs_mount=09=09*mp =3D dp->i_mount;
> -=09int=09=09=09=09error;
> +=09int=09=09=09=09error =3D 0;
> =20
>  =09trace_xfs_attr_node_list(context);
> =20
> @@ -358,7 +369,9 @@ xfs_attr_node_list(
>  =09 */
>  =09for (;;) {
>  =09=09leaf =3D bp->b_addr;
> -=09=09xfs_attr3_leaf_list_int(bp, context);
> +=09=09error =3D xfs_attr3_leaf_list_int(bp, context);
> +=09=09if (error)
> +=09=09=09break;
>  =09=09xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
>  =09=09if (context->seen_enough || leafhdr.forw =3D=3D 0)
>  =09=09=09break;
> @@ -369,13 +382,13 @@ xfs_attr_node_list(
>  =09=09=09return error;
>  =09}
>  =09xfs_trans_brelse(context->tp, bp);
> -=09return 0;
> +=09return error;
>  }
> =20
>  /*
>   * Copy out attribute list entries for attr_list(), for leaf attribute l=
ists.
>   */
> -void
> +int
>  xfs_attr3_leaf_list_int(
>  =09struct xfs_buf=09=09=09*bp,
>  =09struct xfs_attr_list_context=09*context)
> @@ -417,7 +430,7 @@ xfs_attr3_leaf_list_int(
>  =09=09}
>  =09=09if (i =3D=3D ichdr.count) {
>  =09=09=09trace_xfs_attr_list_notfound(context);
> -=09=09=09return;
> +=09=09=09return 0;
>  =09=09}
>  =09} else {
>  =09=09entry =3D &entries[0];
> @@ -457,6 +470,11 @@ xfs_attr3_leaf_list_int(
>  =09=09=09valuelen =3D be32_to_cpu(name_rmt->valuelen);
>  =09=09}
> =20
> +=09=09if (!xfs_attr_namecheck(name, namelen)) {
> +=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +=09=09=09=09=09 context->dp->i_mount);
> +=09=09=09return -EFSCORRUPTED;
> +=09=09}
>  =09=09context->put_listent(context, entry->flags,
>  =09=09=09=09=09      name, namelen, valuelen);
>  =09=09if (context->seen_enough)
> @@ -464,7 +482,7 @@ xfs_attr3_leaf_list_int(
>  =09=09cursor->offset++;
>  =09}
>  =09trace_xfs_attr_list_leaf_end(context);
> -=09return;
> +=09return 0;
>  }
> =20
>  /*
> @@ -483,9 +501,9 @@ xfs_attr_leaf_list(xfs_attr_list_context_t *context)
>  =09if (error)
>  =09=09return error;
> =20
> -=09xfs_attr3_leaf_list_int(bp, context);
> +=09error =3D xfs_attr3_leaf_list_int(bp, context);
>  =09xfs_trans_brelse(context->tp, bp);
> -=09return 0;
> +=09return error;
>  }
> =20
>  int
>=20


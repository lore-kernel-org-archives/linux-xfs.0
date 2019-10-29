Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A55CA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 10:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A5802087F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 10:04:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YIHdKzXP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfJ2KEL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 06:04:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42554 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725776AbfJ2KEL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 06:04:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572343450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mOojQSDAH++x/PzSkJYhAJEQOrlx5IbhpZiiGv2cFbQ=;
        b=YIHdKzXPhdFFlI9BkginQxAo5IcV+xtpPlg+Oa3qtNKww5HyKvcUc1ulI/yXegbUOCKKcT
        qHBOIi7lrXgmfdwYG0slXTOSJuzY68G8Ntq4TF3FTgVQB/56mGoR25cPfKb0WphSPoQ1+w
        2gGnd6VkKdMvZHHB284+Llgq9s9PbyU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-Ux_N2YWdOIyzB0w6PymU5g-1; Tue, 29 Oct 2019 06:04:07 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF200107AD28;
        Tue, 29 Oct 2019 10:04:06 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 461545DA60;
        Tue, 29 Oct 2019 10:04:06 +0000 (UTC)
Date:   Tue, 29 Oct 2019 06:04:04 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/4] xfs: namecheck directory entry names before listing
 them
Message-ID: <20191029100404.GD41131@bfoster>
References: <157232182246.593721.4902116478429075171.stgit@magnolia>
 <157232184576.593721.4790987759528633416.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157232184576.593721.4790987759528633416.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: Ux_N2YWdOIyzB0w6PymU5g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 09:04:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Actually call namecheck on directory entry names before we hand them
> over to userspace.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_dir2_readdir.c |   27 ++++++++++++++++++++++-----
>  1 file changed, 22 insertions(+), 5 deletions(-)
>=20
>=20
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 283df898dd9f..a0bec0931f3b 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -17,6 +17,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_bmap.h"
>  #include "xfs_trans.h"
> +#include "xfs_error.h"
> =20
>  /*
>   * Directory file type support functions
> @@ -115,6 +116,11 @@ xfs_dir2_sf_getdents(
>  =09=09ino =3D dp->d_ops->sf_get_ino(sfp, sfep);
>  =09=09filetype =3D dp->d_ops->sf_get_ftype(sfep);
>  =09=09ctx->pos =3D off & 0x7fffffff;
> +=09=09if (!xfs_dir2_namecheck(sfep->name, sfep->namelen)) {
> +=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +=09=09=09=09=09 dp->i_mount);
> +=09=09=09return -EFSCORRUPTED;
> +=09=09}
>  =09=09if (!dir_emit(ctx, (char *)sfep->name, sfep->namelen, ino,
>  =09=09=09    xfs_dir3_get_dtype(dp->i_mount, filetype)))
>  =09=09=09return 0;
> @@ -208,12 +214,16 @@ xfs_dir2_block_getdents(
>  =09=09/*
>  =09=09 * If it didn't fit, set the final offset to here & return.
>  =09=09 */
> +=09=09if (!xfs_dir2_namecheck(dep->name, dep->namelen)) {
> +=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +=09=09=09=09=09 dp->i_mount);
> +=09=09=09error =3D -EFSCORRUPTED;
> +=09=09=09goto out_rele;
> +=09=09}
>  =09=09if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
>  =09=09=09    be64_to_cpu(dep->inumber),
> -=09=09=09    xfs_dir3_get_dtype(dp->i_mount, filetype))) {
> -=09=09=09xfs_trans_brelse(args->trans, bp);
> -=09=09=09return 0;
> -=09=09}
> +=09=09=09    xfs_dir3_get_dtype(dp->i_mount, filetype)))
> +=09=09=09goto out_rele;
>  =09}
> =20
>  =09/*
> @@ -222,8 +232,9 @@ xfs_dir2_block_getdents(
>  =09 */
>  =09ctx->pos =3D xfs_dir2_db_off_to_dataptr(geo, geo->datablk + 1, 0) &
>  =09=09=09=09=09=09=09=090x7fffffff;
> +out_rele:
>  =09xfs_trans_brelse(args->trans, bp);
> -=09return 0;
> +=09return error;
>  }
> =20
>  /*
> @@ -456,6 +467,12 @@ xfs_dir2_leaf_getdents(
>  =09=09filetype =3D dp->d_ops->data_get_ftype(dep);
> =20
>  =09=09ctx->pos =3D xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
> +=09=09if (!xfs_dir2_namecheck(dep->name, dep->namelen)) {
> +=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +=09=09=09=09=09 dp->i_mount);
> +=09=09=09error =3D -EFSCORRUPTED;
> +=09=09=09break;
> +=09=09}
>  =09=09if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
>  =09=09=09    be64_to_cpu(dep->inumber),
>  =09=09=09    xfs_dir3_get_dtype(dp->i_mount, filetype)))
>=20


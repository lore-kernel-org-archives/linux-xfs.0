Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C2CCCA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 18:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A8AE214B2
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 18:19:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rdvt3gSr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391116AbfJ1STV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 14:19:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42827 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730690AbfJ1STU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 14:19:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572286759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jBzhBWRAb17GE/SmJAibI5YHLc6cJtqXu16KTCMVlHs=;
        b=Rdvt3gSr7T8yb6dL0XwjjlzK5c/QacaPbP9SkTkrX5S7x54dcCIJSRH8ieg2X9itR57v7z
        FC+DZi5csFFYVNszV+IsL/5dOc02n/yhOJC+NH5CRS+8F8S54f+wxR5QFOim61JJvgj+Ck
        2QTgHpLTxDLJk5HgWg2SHfQM6bBU7wc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-SRs-nIy9NSWqPmScEorzxg-1; Mon, 28 Oct 2019 14:19:18 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFE19107AD29;
        Mon, 28 Oct 2019 18:19:17 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B6F960C57;
        Mon, 28 Oct 2019 18:19:17 +0000 (UTC)
Date:   Mon, 28 Oct 2019 14:19:15 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: namecheck directory entry names before listing
 them
Message-ID: <20191028181915.GD26529@bfoster>
References: <157198048552.2873445.18067788660614948888.stgit@magnolia>
 <157198050564.2873445.4054092614183428143.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157198050564.2873445.4054092614183428143.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: SRs-nIy9NSWqPmScEorzxg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 10:15:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Actually call namecheck on directory entry names before we hand them
> over to userspace.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dir2_readdir.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>=20
>=20
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 283df898dd9f..a8fb0a6829fd 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
...
> @@ -208,6 +214,11 @@ xfs_dir2_block_getdents(
>  =09=09/*
>  =09=09 * If it didn't fit, set the final offset to here & return.
>  =09=09 */
> +=09=09if (!xfs_dir2_namecheck(dep->name, dep->namelen)) {
> +=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +=09=09=09=09=09 dp->i_mount);
> +=09=09=09return -EFSCORRUPTED;
> +=09=09}

xfs_trans_brelse(..., bp) (here and in _leaf_getdents())?

Brian

>  =09=09if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
>  =09=09=09    be64_to_cpu(dep->inumber),
>  =09=09=09    xfs_dir3_get_dtype(dp->i_mount, filetype))) {
> @@ -456,6 +467,11 @@ xfs_dir2_leaf_getdents(
>  =09=09filetype =3D dp->d_ops->data_get_ftype(dep);
> =20
>  =09=09ctx->pos =3D xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
> +=09=09if (!xfs_dir2_namecheck(dep->name, dep->namelen)) {
> +=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +=09=09=09=09=09 dp->i_mount);
> +=09=09=09return -EFSCORRUPTED;
> +=09=09}
>  =09=09if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
>  =09=09=09    be64_to_cpu(dep->inumber),
>  =09=09=09    xfs_dir3_get_dtype(dp->i_mount, filetype)))
>=20


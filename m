Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E78CBCA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 18:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C28AA214B2
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 18:19:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fJb8bwPr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391014AbfJ1STE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 14:19:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50693 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730690AbfJ1STE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 14:19:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572286743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RUntZUQtA1HaiKOKuzVILmkWB2BF6hHC1X5fhBcl044=;
        b=fJb8bwPrmBVVcQE+YFG/WlFoPnZ+qV7Udc+OfOUykoULc9OuHRCfzVE2cqxPoSMx5DD7cy
        RcqrNalx0dmiUXEkBDYxoeZ96qFjpyvpTU3OtPMnrTPCa8PXJQzp+8ahO7kcrH0t5+H9lj
        LjFS+GnbHgMvUbHEiQRi2kSAF+mV1MA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-aX-a_yJVMgeyPaipYFPuPA-1; Mon, 28 Oct 2019 14:19:00 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87B111005509;
        Mon, 28 Oct 2019 18:18:59 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 326A919C4F;
        Mon, 28 Oct 2019 18:18:59 +0000 (UTC)
Date:   Mon, 28 Oct 2019 14:18:57 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: namecheck attribute names before listing them
Message-ID: <20191028181857.GC26529@bfoster>
References: <157198048552.2873445.18067788660614948888.stgit@magnolia>
 <157198049955.2873445.974102983711142585.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157198049955.2873445.974102983711142585.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: aX-a_yJVMgeyPaipYFPuPA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 10:14:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Actually call namecheck on attribute names before we hand them over to
> userspace.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.h |    4 ++--
>  fs/xfs/xfs_attr_list.c        |   40 ++++++++++++++++++++++++++++++++---=
-----
>  2 files changed, 34 insertions(+), 10 deletions(-)
>=20
>=20
...
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 00758fdc2fec..3a1158a1347d 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
...
> @@ -174,6 +179,11 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *con=
text)
>  =09=09=09cursor->hashval =3D sbp->hash;
>  =09=09=09cursor->offset =3D 0;
>  =09=09}
> +=09=09if (!xfs_attr_namecheck(sbp->name, sbp->namelen)) {
> +=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +=09=09=09=09=09 context->dp->i_mount);
> +=09=09=09return -EFSCORRUPTED;
> +=09=09}

It looks like we still need to handle freeing sbuf in this path.

>  =09=09context->put_listent(context,
>  =09=09=09=09     sbp->flags,
>  =09=09=09=09     sbp->name,
...
> @@ -557,6 +574,13 @@ xfs_attr_put_listent(
>  =09ASSERT(context->firstu >=3D sizeof(*alist));
>  =09ASSERT(context->firstu <=3D context->bufsize);
> =20
> +=09if (!xfs_attr_namecheck(name, namelen)) {
> +=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> +=09=09=09=09 context->dp->i_mount);
> +=09=09context->seen_enough =3D -EFSCORRUPTED;
> +=09=09return;
> +=09}
> +

Any reason we call this here and the ->put_listent() callers?

Brian

>  =09/*
>  =09 * Only list entries in the right namespace.
>  =09 */
>=20


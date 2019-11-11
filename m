Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F39C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 18:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D36792173B
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 18:23:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cj8Gvjk+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKKSXZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 13:23:25 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42704 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726821AbfKKSXZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 13:23:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573496603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cr1Ty6anZ6GpufwHH/lyjklr+ovSxxS6/CrnlF6slYg=;
        b=cj8Gvjk+VHq1wtU5oDVenTz1pH3STrD0fbKtZvvA84t3cy8lNzgRaB4bUSr1E56Xj2V/Pc
        Y8yp3/IlEncVq/yWihv3IfQxcxcmqVcN8J9vYSNH9Zuk/jBiv9S/SATy3bym0igC/UwA+C
        neAnJrH9mJ7RfWu9flOEDgGxjX5hBIs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-niXTgO-FOlmyeYLBO2ibxQ-1; Mon, 11 Nov 2019 13:23:20 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65DD58C6787;
        Mon, 11 Nov 2019 18:23:19 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EC9049AF;
        Mon, 11 Nov 2019 18:23:18 +0000 (UTC)
Date:   Mon, 11 Nov 2019 13:23:17 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 13/17] xfs: Factor up trans roll in
 xfs_attr3_leaf_clearflag
Message-ID: <20191111182317.GD46312@bfoster>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-14-allison.henderson@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20191107012801.22863-14-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: niXTgO-FOlmyeYLBO2ibxQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 06:27:57PM -0700, Allison Collins wrote:
> New delayed allocation routines cannot be handling
> transactions so factor them up into the calling functions
>=20
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c      | 16 ++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.c |  5 +----
>  2 files changed, 17 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 2f9fb7a..5dcb19f 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -797,6 +797,14 @@ xfs_attr_leaf_addname(struct xfs_da_args=09*args)
>  =09=09 * Added a "remote" value, just clear the incomplete flag.
>  =09=09 */
>  =09=09error =3D xfs_attr3_leaf_clearflag(args);
> +=09=09if (error)
> +=09=09=09return error;
> +
> +=09=09/*
> +=09=09 * Commit the flag value change and start the next trans in
> +=09=09 * series.
> +=09=09 */
> +=09=09error =3D xfs_trans_roll_inode(&args->trans, args->dp);
>  =09}
>  =09return error;
>  }
> @@ -1154,6 +1162,14 @@ xfs_attr_node_addname(
>  =09=09error =3D xfs_attr3_leaf_clearflag(args);
>  =09=09if (error)
>  =09=09=09goto out;
> +
> +=09=09 /*
> +=09=09  * Commit the flag value change and start the next trans in
> +=09=09  * series.
> +=09=09  */
> +=09=09error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> +=09=09if (error)
> +=09=09=09goto out;
>  =09}
>  =09retval =3D error =3D 0;
> =20
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.=
c
> index 023c616..07eee3ff 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2802,10 +2802,7 @@ xfs_attr3_leaf_clearflag(
>  =09=09=09 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
>  =09}
> =20
> -=09/*
> -=09 * Commit the flag value change and start the next trans in series.
> -=09 */
> -=09return xfs_trans_roll_inode(&args->trans, args->dp);
> +=09return error;
>  }
> =20
>  /*
> --=20
> 2.7.4
>=20


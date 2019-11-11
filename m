Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01DFC43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 18:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1800214E0
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 18:24:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Me+C9Yuq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfKKSYM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 13:24:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32019 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726821AbfKKSYM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 13:24:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573496650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BOcZQkWA8aFf+rCn7by+jmiMs1kt/zJqfkYhSG5BzvU=;
        b=Me+C9Yuq7UW326MmMlqUwWuOtV+iMKd2epsCjvmbTafOAzixJ+sgx88pcDL3iKXfno1oxT
        uhR5n8HVy79JLWnJNUkIO8NQCBRNuCsaiqJCL0VsCQhS8zeRFM8Gyqv83xhc+Og1XKBFkP
        ccVvO+LrnrC96GrBmQ3Oo4vqOoIgvjU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-sa66AC1qPsS2uLvDlmrd7A-1; Mon, 11 Nov 2019 13:24:07 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B358518B9F67;
        Mon, 11 Nov 2019 18:24:06 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F52A59;
        Mon, 11 Nov 2019 18:24:06 +0000 (UTC)
Date:   Mon, 11 Nov 2019 13:24:04 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 15/17] xfs: Check for -ENOATTR or -EEXIST
Message-ID: <20191111182404.GF46312@bfoster>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-16-allison.henderson@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20191107012801.22863-16-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: sa66AC1qPsS2uLvDlmrd7A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 06:27:59PM -0700, Allison Collins wrote:
> Delayed operations cannot return error codes.  So we must check for
> these conditions first before starting set or remove operations
>=20
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>=20
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 5dcb19f..626d4a98 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -458,6 +458,27 @@ xfs_attr_set(
>  =09=09goto out_trans_cancel;
> =20
>  =09xfs_trans_ijoin(args.trans, dp, 0);
> +
> +=09error =3D xfs_has_attr(&args);
> +=09if (error =3D=3D -EEXIST) {
> +=09=09if (name->type & ATTR_CREATE)
> +=09=09=09goto out_trans_cancel;
> +=09=09else
> +=09=09=09name->type |=3D ATTR_REPLACE;
> +=09}
> +
> +=09if (error =3D=3D -ENOATTR && (name->type & ATTR_REPLACE))
> +=09=09goto out_trans_cancel;
> +
> +=09if (name->type & ATTR_REPLACE) {
> +=09=09name->type &=3D ~ATTR_REPLACE;
> +=09=09error =3D xfs_attr_remove_args(&args);
> +=09=09if (error)
> +=09=09=09goto out_trans_cancel;
> +
> +=09=09name->type |=3D ATTR_CREATE;
> +=09}
> +

I see Darrick already commented on this.. I think the behavior of the
existing rename code is to essentially create the new xattr with the
INCOMPLETE flag set so we can roll transactions, etc. without any
observable behavior to userspace. Once the new xattr is fully in place,
the rename is performed atomically from the userspace perspective by
flipping the INCOMPLETE flag from the newly constructed xattr to the old
one and we can then remove the old xattr from there.

>  =09error =3D xfs_attr_set_args(&args);
>  =09if (error)
>  =09=09goto out_trans_cancel;
> @@ -543,6 +564,10 @@ xfs_attr_remove(
>  =09 */
>  =09xfs_trans_ijoin(args.trans, dp, 0);
> =20
> +=09error =3D xfs_has_attr(&args);
> +=09if (error =3D=3D -ENOATTR)
> +=09=09goto out;
> +

Wouldn't we want to return any error that might occur here (except
-EEXIST), not just -ENOATTR if there's actually no xattr?

Brian

>  =09error =3D xfs_attr_remove_args(&args);
>  =09if (error)
>  =09=09goto out;
> --=20
> 2.7.4
>=20


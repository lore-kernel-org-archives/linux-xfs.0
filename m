Return-Path: <SRS0=K+Ru=YY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C90CA9EC3
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Oct 2019 11:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 089F72086D
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Oct 2019 11:36:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HGFmq5Zn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfJaLgs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Oct 2019 07:36:48 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44291 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726462AbfJaLgs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Oct 2019 07:36:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572521806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oPCHUGvUjfG7nd7np1pXhXOaUgzkarz8pKoalLarKMU=;
        b=HGFmq5ZnG7uvlwcApURvE/FtDh1vZVJ6VFXKp9QmswpdvAzBuol6JQSr7oSBdFX3RFSjjF
        p48omSQMwNURdnVWmDuYuCeE6y/NGZbVU0hBANIARwM6Wv7rHBboP6I/aLlb6BoH6uNMpF
        POSzGuGwPbYLmQ0mK8fAIEyLqsEvFKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-GPn-p7aJOyaDDdtxuY3hug-1; Thu, 31 Oct 2019 07:36:43 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3D70800EB4;
        Thu, 31 Oct 2019 11:36:42 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 47ACE5C1BB;
        Thu, 31 Oct 2019 11:36:42 +0000 (UTC)
Date:   Thu, 31 Oct 2019 07:36:40 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Pingfan Liu <kernelfans@gmail.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs/log: protect the logging content under xc_ctx_lock
Message-ID: <20191031113640.GA54006@bfoster>
References: <20191030133327.GA29340@mypc>
 <1572442631-4472-1-git-send-email-kernelfans@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1572442631-4472-1-git-send-email-kernelfans@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: GPn-p7aJOyaDDdtxuY3hug-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dropped linux-fsdevel from cc. There's no reason to spam -fsdevel with
low level XFS patches.

On Wed, Oct 30, 2019 at 09:37:11PM +0800, Pingfan Liu wrote:
> xc_cil_lock is not enough to protect the integrity of a trans logging.
> Taking the scenario:
>   cpuA                                 cpuB                          cpuC
>=20
>   xlog_cil_insert_format_items()
>=20
>   spin_lock(&cil->xc_cil_lock)
>   link transA's items to xc_cil,
>      including item1
>   spin_unlock(&cil->xc_cil_lock)

So you commit a transaction, item1 ends up on the CIL.

>                                                                       xlo=
g_cil_push() fetches transA's item under xc_cil_lock

xlog_cil_push() doesn't use ->xc_cil_lock, so I'm not sure what this
means. This sequence executes under ->xc_ctx_lock in write mode, which
locks out all transaction committers.

>                                        issue transB, modify item1

So presumably transB joins item1 while it is on the CIL from trans A and
commits.=20

>                                                                       xlo=
g_write(), but now, item1 contains content from transB and we have a broken=
 transA

I'm not following how this is possible. The CIL push above, under
exclusive lock, removes each log item from ->xc_cil and pulls the log
vectors off of the log items to form the lv chain on the CIL context.
This means that the transB commit either updates the lv attached to the
log item from transA with the latest in-core version or uses the new
shadow buffer allocated in the commit path of transB. Either way is fine
because there is no guarantee of per-transaction granularity in the
on-disk log. The purpose of the on-disk log is to guarantee filesystem
consistency after a crash.

All in all, I can't really tell what problem you're describing here. If
you believe there's an issue in this code, I'd suggest to either try and
instrument it manually to reproduce a demonstrable problem and/or
provide far more detailed of a description to explain it.

>=20
> Survive this race issue by putting under the protection of xc_ctx_lock.
> Meanwhile the xc_cil_lock can be dropped as xc_ctx_lock does it against
> xlog_cil_insert_items()
>=20
> Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Cc: Brian Foster <bfoster@redhat.com>
> To: linux-xfs@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> ---

FYI, this patch also doesn't apply to for-next. I'm guessing because
it's based on your previous patch to add the spinlock around the loop.

>  fs/xfs/xfs_log_cil.c | 35 +++++++++++++++++++----------------
>  1 file changed, 19 insertions(+), 16 deletions(-)
>=20
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 004af09..f8df3b5 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -723,22 +723,6 @@ xlog_cil_push(
>  =09 */
>  =09lv =3D NULL;
>  =09num_iovecs =3D 0;
> -=09spin_lock(&cil->xc_cil_lock);
> -=09while (!list_empty(&cil->xc_cil)) {

There's a comment just above that documents this loop that isn't
moved/modified.

> -=09=09struct xfs_log_item=09*item;
> -
> -=09=09item =3D list_first_entry(&cil->xc_cil,
> -=09=09=09=09=09struct xfs_log_item, li_cil);
> -=09=09list_del_init(&item->li_cil);
> -=09=09if (!ctx->lv_chain)
> -=09=09=09ctx->lv_chain =3D item->li_lv;
> -=09=09else
> -=09=09=09lv->lv_next =3D item->li_lv;
> -=09=09lv =3D item->li_lv;
> -=09=09item->li_lv =3D NULL;
> -=09=09num_iovecs +=3D lv->lv_niovecs;
> -=09}
> -=09spin_unlock(&cil->xc_cil_lock);
> =20
>  =09/*
>  =09 * initialise the new context and attach it to the CIL. Then attach
> @@ -783,6 +767,25 @@ xlog_cil_push(
>  =09up_write(&cil->xc_ctx_lock);
> =20
>  =09/*
> +=09 * cil->xc_cil_lock around this loop can be dropped, since xc_ctx_loc=
k
> +=09 * protects us against xlog_cil_insert_items().
> +=09 */
> +=09while (!list_empty(&cil->xc_cil)) {
> +=09=09struct xfs_log_item=09*item;
> +
> +=09=09item =3D list_first_entry(&cil->xc_cil,
> +=09=09=09=09=09struct xfs_log_item, li_cil);
> +=09=09list_del_init(&item->li_cil);
> +=09=09if (!ctx->lv_chain)
> +=09=09=09ctx->lv_chain =3D item->li_lv;
> +=09=09else
> +=09=09=09lv->lv_next =3D item->li_lv;
> +=09=09lv =3D item->li_lv;
> +=09=09item->li_lv =3D NULL;
> +=09=09num_iovecs +=3D lv->lv_niovecs;
> +=09}
> +

This places the associated loop outside of ->xc_ctx_lock, which means we
can now race modifying ->xc_cil during a CIL push and a transaction
commit. Have you tested this?

Brian

> +=09/*
>  =09 * Build a checkpoint transaction header and write it to the log to
>  =09 * begin the transaction. We need to account for the space used by th=
e
>  =09 * transaction header here as it is not accounted for in xlog_write()=
.
> --=20
> 2.7.5
>=20


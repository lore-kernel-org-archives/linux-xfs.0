Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E05CA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 12:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A148C208C0
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 12:53:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GA7RQpBB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfJ3MxY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 08:53:24 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36772 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726209AbfJ3MxY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 08:53:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572440002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xEm7If272zgBUaaTDZ9GOaX/N26+KNfnDd8n2XNZSWk=;
        b=GA7RQpBBtYRCnXMdp1yHvUVS1SxNFCvlNHEPp7vErVxCfBSQZI01rAWSJSXxIyt8WNZf2C
        oP8VmrIb0i3FKG7+yNl38WBTrIUYFuF0B55WtiNZF0YedO9eqPp/vPWM06NGTndINvwqCa
        flmdPMBgdylWfoIFC0dV0t5HhIKxvpw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-wY2Aes37MRCfG9JiAEpIgg-1; Wed, 30 Oct 2019 08:53:19 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 708AB1800D55;
        Wed, 30 Oct 2019 12:53:18 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E669119486;
        Wed, 30 Oct 2019 12:53:17 +0000 (UTC)
Date:   Wed, 30 Oct 2019 08:53:16 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Pingfan Liu <kernelfans@gmail.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] xfs/log: protect xc_cil in xlog_cil_push()
Message-ID: <20191030125316.GC46856@bfoster>
References: <1572416980-25274-1-git-send-email-kernelfans@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1572416980-25274-1-git-send-email-kernelfans@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: wY2Aes37MRCfG9JiAEpIgg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 30, 2019 at 02:29:40PM +0800, Pingfan Liu wrote:
> xlog_cil_push() is the reader and writer of xc_cil, and should be protect=
ed
> against xlog_cil_insert_items().
>=20
> Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> To: linux-xfs@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> ---
>  fs/xfs/xfs_log_cil.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index ef652abd..004af09 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -723,6 +723,7 @@ xlog_cil_push(
>  =09 */
>  =09lv =3D NULL;
>  =09num_iovecs =3D 0;
> +=09spin_lock(&cil->xc_cil_lock);
>  =09while (!list_empty(&cil->xc_cil)) {
>  =09=09struct xfs_log_item=09*item;
> =20
> @@ -737,6 +738,7 @@ xlog_cil_push(
>  =09=09item->li_lv =3D NULL;
>  =09=09num_iovecs +=3D lv->lv_niovecs;
>  =09}
> +=09spin_unlock(&cil->xc_cil_lock);

The majority of this function executes under exclusive ->xc_ctx_lock.
xlog_cil_insert_items() runs with the ->xc_ctx_lock taken in read mode.
The ->xc_cil_lock spinlock is used in the latter case to protect the
list under concurrent transaction commits.

Brian

> =20
>  =09/*
>  =09 * initialise the new context and attach it to the CIL. Then attach
> --=20
> 2.7.5
>=20


Return-Path: <SRS0=4VMi=2H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E93C43603
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 11:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AF85207FF
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 11:54:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OBabwBX6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfLQLyJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 06:54:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43149 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726141AbfLQLyI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 06:54:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576583647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=76oZGiscP2GD4GcldIKrJ1Dj3CzNBa5h/qoAUVXC0kU=;
        b=OBabwBX6XfShqXNJ/Bk0xmzveVp2YoEnP/ezyhVRBqkixcN33Md3tEonMNk48xdmS5x2Mx
        Y1e0vbAPLBc/8/wNARMI+UOE0NIz8LjSr8K6GyrUwlxL0pcnUCGbvZJxoFwQwWxiNvfswd
        n8HfkzOOQlNmgS/HWhEMVtVq+/0NtmU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-diG1lQ_GNgGJ6IZ5A0ppGw-1; Tue, 17 Dec 2019 06:54:04 -0500
X-MC-Unique: diG1lQ_GNgGJ6IZ5A0ppGw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5431E18FF677;
        Tue, 17 Dec 2019 11:54:03 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F16995C28D;
        Tue, 17 Dec 2019 11:54:02 +0000 (UTC)
Date:   Tue, 17 Dec 2019 06:54:01 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: don't warn about packed members
Message-ID: <20191217115401.GC48778@bfoster>
References: <20191216215245.13666-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191216215245.13666-1-david@fromorbit.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 17, 2019 at 08:52:45AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>=20
> gcc 9.2.1 throws lots of new warnings during the build like this:
>=20
> xfs_format.h:790:3: warning: taking address of packed member of =E2=80=98=
struct xfs_agfl=E2=80=99 may result in an unaligned pointer value [-Waddr=
ess-of-packed-member]
>   790 |   &(XFS_BUF_TO_AGFL(bp)->agfl_bno[0]) : \
>       |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> xfs_alloc.c:3149:13: note: in expansion of macro =E2=80=98XFS_BUF_TO_AG=
FL_BNO=E2=80=99
>  3149 |  agfl_bno =3D XFS_BUF_TO_AGFL_BNO(mp, agflbp);
>       |             ^~~~~~~~~~~~~~~~~~~
>=20
> We know this packed structure aligned correctly, so turn off this
> warning to shut gcc up.
>=20
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

I'm wondering if we could just use offsetof() in this case so we don't
have to disable a warning for the entire project, particularly if this
is triggered by a small number of macros..

Brian

>  include/builddefs.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 4700b52706a7..6fdc9ebb70c7 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -13,7 +13,7 @@ OPTIMIZER =3D @opt_build@
>  MALLOCLIB =3D @malloc_lib@
>  LOADERFLAGS =3D @LDFLAGS@
>  LTLDFLAGS =3D @LDFLAGS@
> -CFLAGS =3D @CFLAGS@ -D_FILE_OFFSET_BITS=3D64
> +CFLAGS =3D @CFLAGS@ -D_FILE_OFFSET_BITS=3D64 -Wno-address-of-packed-me=
mber
>  BUILD_CFLAGS =3D @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=3D64
> =20
>  LIBRT =3D @librt@
> --=20
> 2.24.0.rc0
>=20


Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76B8CA9EB7
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 13:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B95682184C
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 13:55:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MhetQxq6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbfJUNzG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 09:55:06 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46947 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728670AbfJUNzG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 09:55:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571666105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YNhbjzI8rpEgtWRkj6/Gf+A9wp1JiUWv6HdEyKv3lPU=;
        b=MhetQxq6UWlbdbWSiVB2p1adTFc9Udfdewd9E+l8NDoUzbANqiAhcUAXHWNF+5dyMZKQ0P
        A4zvVPfRdL/CTS7hTHJ1b0948000z9p5NCteGt9QgaFzO/IWPUZBMQz17ltty4kCgBFRxz
        r0kdcewU1oLpCZ+BVEuokQrIfguyFCk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-PrUlEiP6O62NsQEA6fF0Hw-1; Mon, 21 Oct 2019 09:55:01 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55740800D41;
        Mon, 21 Oct 2019 13:54:55 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 74BCBBA75;
        Mon, 21 Oct 2019 13:54:54 +0000 (UTC)
Date:   Mon, 21 Oct 2019 09:54:52 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH v4] fsstress: add renameat2 support
Message-ID: <20191021135452.GB26105@bfoster>
References: <5df7cc7b-31b4-69e2-f623-83a2c90bfca7@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5df7cc7b-31b4-69e2-f623-83a2c90bfca7@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: PrUlEiP6O62NsQEA6fF0Hw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 18, 2019 at 05:57:55PM +0800, kaixuxia wrote:
> Support the renameat2 syscall in fsstress.
>=20
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---
> Changes in v4:
>  -Fix long line((> 80 characters) problem.
>  -Fix the RENAME_WHITEOUT RENAME_EXCHANGE file flist problem.
>=20
>  ltp/fsstress.c | 174 +++++++++++++++++++++++++++++++++++++++++++++++----=
------
>  1 file changed, 143 insertions(+), 31 deletions(-)
>=20
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 51976f5..f268a5a 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
...
> @@ -4269,16 +4348,26 @@ rename_f(int opno, long r)
>  =09=09=09oldid =3D fep->id;
>  =09=09=09fix_parent(oldid, id);
>  =09=09}
> +
> +=09=09if (mode =3D=3D RENAME_WHITEOUT)
> +=09=09=09add_to_flist(FT_DEV, fep->id, fep->parent, 0);
> +=09=09else if (mode =3D=3D RENAME_EXCHANGE) {
> +=09=09=09del_from_flist(dflp - flist, dfep - dflp->fents);
> +=09=09=09add_to_flist(dflp - flist, fep->id, fep->parent,
> +=09=09=09=09     dfep->xattr_counter);

I think dfep->xattr_counter is overwritten by the del_from_flist() call.

Also if the source and the target happen to be on the same file type
list, what prevents the del_from_flist() call above from relocating the
entry associated with the target, invalidating the fep reference used
below? I'm wondering if we need some kind of entry swap helper function
here to get this right for the exchange case (i.e. pass two list+slot
pairs to swap and let the function make a local copy as appropriate)...

Brian

> +=09=09}
> +
>  =09=09del_from_flist(flp - flist, fep - flp->fents);
>  =09=09add_to_flist(flp - flist, id, parid, xattr_counter);
>  =09}
>  =09if (v) {
> -=09=09printf("%d/%d: rename %s to %s %d\n", procid, opno, f.path,
> +=09=09printf("%d/%d: rename(%s) %s to %s %d\n", procid,
> +=09=09=09opno, translate_renameat2_flags(mode), f.path,
>  =09=09=09newf.path, e);
>  =09=09if (e =3D=3D 0) {
> -=09=09=09printf("%d/%d: rename del entry: id=3D%d,parent=3D%d\n",
> +=09=09=09printf("%d/%d: rename source entry: id=3D%d,parent=3D%d\n",
>  =09=09=09=09procid, opno, fep->id, fep->parent);
> -=09=09=09printf("%d/%d: rename add entry: id=3D%d,parent=3D%d\n",
> +=09=09=09printf("%d/%d: rename target entry: id=3D%d,parent=3D%d\n",
>  =09=09=09=09procid, opno, id, parid);
>  =09=09}
>  =09}
> @@ -4287,6 +4376,29 @@ rename_f(int opno, long r)
>  }
> =20
>  void
> +rename_f(int opno, long r)
> +{
> +=09do_renameat2(opno, r, 0);
> +}
> +void
> +rnoreplace_f(int opno, long r)
> +{
> +=09do_renameat2(opno, r, RENAME_NOREPLACE);
> +}
> +
> +void
> +rexchange_f(int opno, long r)
> +{
> +=09do_renameat2(opno, r, RENAME_EXCHANGE);
> +}
> +
> +void
> +rwhiteout_f(int opno, long r)
> +{
> +=09do_renameat2(opno, r, RENAME_WHITEOUT);
> +}
> +
> +void
>  resvsp_f(int opno, long r)
>  {
>  =09int=09=09e;
> --=20
> 1.8.3.1
>=20
> --=20
> kaixuxia


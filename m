Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B354DCA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 16:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8596B20663
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 16:00:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HHb7iSb/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503250AbfJYQAT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:00:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41196 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2503539AbfJYQAS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 12:00:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572019217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rMYccXhObpzn/LtQ2xyPLpIygsBKHSm5xujI07DicIg=;
        b=HHb7iSb//Oa6sflu54xhmTviXbRPLpvLoMlILzPNNQKfhWkZXwQzbJOtynSbaEIByICItt
        3tEtvUncPdFAVIZmfLhhdP6FBo87AcgyVDyEmNWsy09yyq7+spqu139IVZKjdq9aCiPeQM
        Z0hTA7gSnLxuVrwmE/foseMt6+ORXrg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-xL2rYtyDOQyOUPVGQGfZLg-1; Fri, 25 Oct 2019 12:00:15 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98748800D4E;
        Fri, 25 Oct 2019 16:00:14 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 930F6600D1;
        Fri, 25 Oct 2019 16:00:13 +0000 (UTC)
Date:   Fri, 25 Oct 2019 12:00:11 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guaneryu@gmail.com, newtongao@tencent.com, jasperwang@tencent.com
Subject: Re: [PATCH 1/4] fsstress: show the real file id and parid in
 rename_f()
Message-ID: <20191025160011.GD11837@bfoster>
References: <cover.1571926790.git.kaixuxia@tencent.com>
 <d68b2f32b3dbe57427e6bacaeb6e4a32d8576b0c.1571926790.git.kaixuxia@tencent.com>
MIME-Version: 1.0
In-Reply-To: <d68b2f32b3dbe57427e6bacaeb6e4a32d8576b0c.1571926790.git.kaixuxia@tencent.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: xL2rYtyDOQyOUPVGQGfZLg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 10:20:48PM +0800, kaixuxia wrote:
> The source file id and parentid are overwritten by del_from_flist()
> call, and should show the actually values.
>=20
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  ltp/fsstress.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>=20
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 51976f5..95285f1 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -4227,6 +4227,7 @@ rename_f(int opno, long r)
>  =09pathname_t=09newf;
>  =09int=09=09oldid;
>  =09int=09=09parid;
> +=09int=09=09oldparid;
>  =09int=09=09v;
>  =09int=09=09v1;
> =20
> @@ -4265,10 +4266,12 @@ rename_f(int opno, long r)
>  =09if (e =3D=3D 0) {
>  =09=09int xattr_counter =3D fep->xattr_counter;
> =20
> -=09=09if (flp - flist =3D=3D FT_DIR) {
> -=09=09=09oldid =3D fep->id;
> +=09=09oldid =3D fep->id;
> +=09=09oldparid =3D fep->parent;
> +
> +=09=09if (flp - flist =3D=3D FT_DIR)
>  =09=09=09fix_parent(oldid, id);
> -=09=09}
> +
>  =09=09del_from_flist(flp - flist, fep - flp->fents);
>  =09=09add_to_flist(flp - flist, id, parid, xattr_counter);
>  =09}
> @@ -4277,7 +4280,7 @@ rename_f(int opno, long r)
>  =09=09=09newf.path, e);
>  =09=09if (e =3D=3D 0) {
>  =09=09=09printf("%d/%d: rename del entry: id=3D%d,parent=3D%d\n",
> -=09=09=09=09procid, opno, fep->id, fep->parent);
> +=09=09=09=09procid, opno, oldid, oldparid);
>  =09=09=09printf("%d/%d: rename add entry: id=3D%d,parent=3D%d\n",
>  =09=09=09=09procid, opno, id, parid);
>  =09=09}
> --=20
> 1.8.3.1
>=20


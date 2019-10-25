Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B55CA9EBC
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 16:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A97852054F
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 16:01:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZyN2iDbi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393630AbfJYQBn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:01:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28941 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2393710AbfJYQBn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 12:01:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572019301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gUTc3zbjdjzpw00hh/9LiSKfwMLiAfHTW5Bw5n+Wqjw=;
        b=ZyN2iDbimbslZcsfTy+kz7dAxzMWypWtUWB0w71DZtcv/iFB5yuU7a4clpDWkkYZHasSJJ
        6A9cfCuFiiuH4TZFMyjoTbMjxVvkZJbBO/5Xh41kl38CvKevGHEDFX9ONWBs0tpMga4G8Y
        SSFHZJzbOK/z1ihPEkMAoonOhnuw+qI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-r0VdJzAyMdujV5y_rlc_ug-1; Fri, 25 Oct 2019 12:01:38 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFADE800D41;
        Fri, 25 Oct 2019 16:01:36 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C45960852;
        Fri, 25 Oct 2019 16:01:36 +0000 (UTC)
Date:   Fri, 25 Oct 2019 12:01:34 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guaneryu@gmail.com, newtongao@tencent.com, jasperwang@tencent.com
Subject: Re: [PATCH 3/4] fsstress: add EXCHANGE renameat2 support
Message-ID: <20191025160134.GF11837@bfoster>
References: <cover.1571926790.git.kaixuxia@tencent.com>
 <71744e89979dfd25f1bffc44c70f6df214a5477b.1571926791.git.kaixuxia@tencent.com>
MIME-Version: 1.0
In-Reply-To: <71744e89979dfd25f1bffc44c70f6df214a5477b.1571926791.git.kaixuxia@tencent.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: r0VdJzAyMdujV5y_rlc_ug-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 10:20:50PM +0800, kaixuxia wrote:
> Support the EXCHANGE renameat2 syscall in fsstress.
>=20
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---
>  ltp/fsstress.c | 86 +++++++++++++++++++++++++++++++++++++++++++---------=
------
>  1 file changed, 64 insertions(+), 22 deletions(-)
>=20
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 5059639..958adf9 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
...
> @@ -1118,7 +1124,7 @@ fent_to_name(pathname_t *name, flist_t *flp, fent_t=
 *fep)
>  }
> =20
>  void
> -fix_parent(int oldid, int newid)
> +fix_parent(int oldid, int newid, int swap)
>  {
>  =09fent_t=09*fep;
>  =09flist_t=09*flp;
> @@ -1129,6 +1135,8 @@ fix_parent(int oldid, int newid)
>  =09=09for (j =3D 0, fep =3D flp->fents; j < flp->nfiles; j++, fep++) {
>  =09=09=09if (fep->parent =3D=3D oldid)
>  =09=09=09=09fep->parent =3D newid;
> +=09=09=09if (swap && fep->parent =3D=3D newid)
> +=09=09=09=09fep->parent =3D oldid;

We might as well use a bool for swap.

>  =09=09}
>  =09}
>  }
> @@ -4256,6 +4264,7 @@ out:
> =20
>  struct print_flags renameat2_flags [] =3D {
>  =09{ RENAME_NOREPLACE, "NOREPLACE"},
> +=09{ RENAME_EXCHANGE, "EXCHANGE"},
>  =09{ RENAME_WHITEOUT, "WHITEOUT"},
>  =09{ -1, NULL}
>  };
> @@ -4291,41 +4300,68 @@ do_renameat2(int opno, long r, int mode)
>  =09=09return;
>  =09}
> =20
> -=09/* get an existing directory for the destination parent directory nam=
e */
> -=09if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
> -=09=09parid =3D -1;
> -=09else
> -=09=09parid =3D dfep->id;
> -=09v |=3D v1;
> +=09/* Both pathnames must exist for the RENAME_EXCHANGE */

This comment should also say that the types must be the same.

> +=09if (mode =3D=3D RENAME_EXCHANGE) {
> +=09=09which =3D 1 << (flp - flist);
> +=09=09init_pathname(&newf);
> +=09=09if (!get_fname(which, random(), &newf, NULL, &dfep, &v)) {
> +=09=09=09if (v)
> +=09=09=09=09printf("%d/%d: rename - no target filename\n",
> +=09=09=09=09=09procid, opno);
> +=09=09=09free_pathname(&newf);
> +=09=09=09free_pathname(&f);
> +=09=09=09return;
> +=09=09}
> +=09=09v |=3D v1;
> +=09=09id =3D dfep->id;
> +=09=09parid =3D dfep->parent;
> +=09} else {
> +=09=09/*
> +=09=09 * get an existing directory for the destination parent
> +=09=09 * directory name.
> +=09=09 */
> +=09=09if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
> +=09=09=09parid =3D -1;
> +=09=09else
> +=09=09=09parid =3D dfep->id;
> +=09=09v |=3D v1;
> =20
> -=09/* generate a new path using an existing parent directory in name */
> -=09init_pathname(&newf);
> -=09e =3D generate_fname(dfep, flp - flist, &newf, &id, &v1);
> -=09v |=3D v1;
> -=09if (!e) {
> -=09=09if (v) {
> -=09=09=09(void)fent_to_name(&f, &flist[FT_DIR], dfep);
> -=09=09=09printf("%d/%d: rename - no filename from %s\n",
> -=09=09=09=09procid, opno, f.path);
> +=09=09/*
> +=09=09 * generate a new path using an existing parent directory
> +=09=09 * in name.
> +=09=09 */
> +=09=09init_pathname(&newf);
> +=09=09e =3D generate_fname(dfep, flp - flist, &newf, &id, &v1);
> +=09=09v |=3D v1;
> +=09=09if (!e) {
> +=09=09=09if (v) {
> +=09=09=09=09(void)fent_to_name(&f, &flist[FT_DIR], dfep);
> +=09=09=09=09printf("%d/%d: rename - no filename from %s\n",
> +=09=09=09=09=09procid, opno, f.path);
> +=09=09=09}
> +=09=09=09free_pathname(&newf);
> +=09=09=09free_pathname(&f);
> +=09=09=09return;
>  =09=09}
> -=09=09free_pathname(&newf);
> -=09=09free_pathname(&f);
> -=09=09return;
>  =09}
>  =09e =3D rename_path(&f, &newf, mode) < 0 ? errno : 0;
>  =09check_cwd();
>  =09if (e =3D=3D 0) {
>  =09=09int xattr_counter =3D fep->xattr_counter;
> +=09=09int swap =3D (mode =3D=3D RENAME_EXCHANGE) ? 1 : 0;
> =20
>  =09=09oldid =3D fep->id;
>  =09=09oldparid =3D fep->parent;
> =20
>  =09=09if (flp - flist =3D=3D FT_DIR)
> -=09=09=09fix_parent(oldid, id);
> +=09=09=09fix_parent(oldid, id, swap);

What about the other directory if we exchanged two dirs (also see my
comment on the previous version around the safety of doing two separate
swaps)? BTW however this turns out, it would also be useful to see some
comments in this area of code to explain it along with some content in
the commit log descriptions of both patches to document the limitations
of the various renameat2 modes.

Brian

> =20
>  =09=09if (mode =3D=3D RENAME_WHITEOUT)
>  =09=09=09add_to_flist(flp - flist, id, parid, xattr_counter);
> -=09=09else {
> +=09=09else if (mode =3D=3D RENAME_EXCHANGE) {
> +=09=09=09fep->xattr_counter =3D dfep->xattr_counter;
> +=09=09=09dfep->xattr_counter =3D xattr_counter;
> +=09=09} else {
>  =09=09=09del_from_flist(flp - flist, fep - flp->fents);
>  =09=09=09add_to_flist(flp - flist, id, parid, xattr_counter);
>  =09=09}
> @@ -4358,6 +4394,12 @@ rnoreplace_f(int opno, long r)
>  }
> =20
>  void
> +rexchange_f(int opno, long r)
> +{
> +=09do_renameat2(opno, r, RENAME_EXCHANGE);
> +}
> +
> +void
>  rwhiteout_f(int opno, long r)
>  {
>  =09do_renameat2(opno, r, RENAME_WHITEOUT);
> --=20
> 1.8.3.1
>=20


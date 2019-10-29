Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 860D9CA9EC4
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 13:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BEAE2087E
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 13:40:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="br98kULs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388696AbfJ2NkT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 09:40:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27009 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388453AbfJ2NkT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 09:40:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572356417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LzoC2UJTjvEMoHNmZt0dnBjgBu/mQvs3MMxG4oK2pi8=;
        b=br98kULsH/Eh5/PdPEwrdJbXw1BMyyA54w2Ufe0zUxoiEku5KhVquADk3/PHGxqngQIevN
        JmVkTzAxYy5Hk8yeLeVoX7AdAoh3RMYl/145gjhX46mHPkUJMvdzgZkNG0ZWwKo8971Db+
        h5gZ7pGxR3eg+OZdPsdj1KQIqnTHXTY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-y6tk0Aw3OROpXi8h4-EK1w-1; Tue, 29 Oct 2019 09:40:14 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45D19107AD28;
        Tue, 29 Oct 2019 13:40:13 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 945531001B32;
        Tue, 29 Oct 2019 13:40:12 +0000 (UTC)
Date:   Tue, 29 Oct 2019 09:40:10 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guaneryu@gmail.com, newtongao@tencent.com, jasperwang@tencent.com
Subject: Re: [PATCH v2 3/4] fsstress: add EXCHANGE renameat2 support
Message-ID: <20191029134010.GF41131@bfoster>
References: <cover.1572057903.git.kaixuxia@tencent.com>
 <8e8cf5e50bc3c26c90d2677d3194d36346ef0c24.1572057903.git.kaixuxia@tencent.com>
MIME-Version: 1.0
In-Reply-To: <8e8cf5e50bc3c26c90d2677d3194d36346ef0c24.1572057903.git.kaixuxia@tencent.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: y6tk0Aw3OROpXi8h4-EK1w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 26, 2019 at 07:18:37PM +0800, kaixuxia wrote:
> Support the EXCHANGE renameat2 syscall in fsstress.
>=20
> In order to maintain filelist/filename integrity, we restrict
> rexchange to files of the same type.
>=20
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---

While this looks pretty good to me at this point, I do notice instances
of the following in a quick test:

0/29: rename(EXCHANGE) d3/d9/dc/dd to d3/d9/dc/dd/df 22
...
0/43: rename(EXCHANGE) d3 to d3/d9/dc/d18 22
...

It looks like we're getting an EINVAL error on rexchange of directories.
That same operation seems to work fine via the ./src/renameat2 tool. Any
idea what's going on there?

Brian

>  ltp/fsstress.c | 92 ++++++++++++++++++++++++++++++++++++++++++++--------=
------
>  1 file changed, 71 insertions(+), 21 deletions(-)
>=20
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index ecc1adc..83d6337 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -69,6 +69,9 @@ static int renameat2(int dfd1, const char *path1,
>  #ifndef RENAME_NOREPLACE
>  #define RENAME_NOREPLACE=09(1 << 0)=09/* Don't overwrite target */
>  #endif
> +#ifndef RENAME_EXCHANGE
> +#define RENAME_EXCHANGE=09=09(1 << 1)=09/* Exchange source and dest */
> +#endif
>  #ifndef RENAME_WHITEOUT
>  #define RENAME_WHITEOUT=09=09(1 << 2)=09/* Whiteout source */
>  #endif
> @@ -115,6 +118,7 @@ typedef enum {
>  =09OP_REMOVEFATTR,
>  =09OP_RENAME,
>  =09OP_RNOREPLACE,
> +=09OP_REXCHANGE,
>  =09OP_RWHITEOUT,
>  =09OP_RESVSP,
>  =09OP_RMDIR,
> @@ -235,6 +239,7 @@ void=09readv_f(int, long);
>  void=09removefattr_f(int, long);
>  void=09rename_f(int, long);
>  void=09rnoreplace_f(int, long);
> +void=09rexchange_f(int, long);
>  void=09rwhiteout_f(int, long);
>  void=09resvsp_f(int, long);
>  void=09rmdir_f(int, long);
> @@ -296,6 +301,7 @@ opdesc_t=09ops[] =3D {
>  =09{ OP_REMOVEFATTR, "removefattr", removefattr_f, 1, 1 },
>  =09{ OP_RENAME, "rename", rename_f, 2, 1 },
>  =09{ OP_RNOREPLACE, "rnoreplace", rnoreplace_f, 2, 1 },
> +=09{ OP_REXCHANGE, "rexchange", rexchange_f, 2, 1 },
>  =09{ OP_RWHITEOUT, "rwhiteout", rwhiteout_f, 2, 1 },
>  =09{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
>  =09{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
> @@ -371,7 +377,7 @@ void=09del_from_flist(int, int);
>  int=09dirid_to_name(char *, int);
>  void=09doproc(void);
>  int=09fent_to_name(pathname_t *, flist_t *, fent_t *);
> -void=09fix_parent(int, int);
> +void=09fix_parent(int, int, bool);
>  void=09free_pathname(pathname_t *);
>  int=09generate_fname(fent_t *, int, pathname_t *, int *, int *);
>  int=09generate_xattr_name(int, char *, int);
> @@ -1118,7 +1124,7 @@ fent_to_name(pathname_t *name, flist_t *flp, fent_t=
 *fep)
>  }
> =20
>  void
> -fix_parent(int oldid, int newid)
> +fix_parent(int oldid, int newid, bool swap)
>  {
>  =09fent_t=09*fep;
>  =09flist_t=09*flp;
> @@ -1129,6 +1135,8 @@ fix_parent(int oldid, int newid)
>  =09=09for (j =3D 0, fep =3D flp->fents; j < flp->nfiles; j++, fep++) {
>  =09=09=09if (fep->parent =3D=3D oldid)
>  =09=09=09=09fep->parent =3D newid;
> +=09=09=09else if (swap && fep->parent =3D=3D newid)
> +=09=09=09=09fep->parent =3D oldid;
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
> @@ -4291,41 +4300,76 @@ do_renameat2(int opno, long r, int mode)
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
> +=09/*
> +=09 * Both pathnames must exist for the RENAME_EXCHANGE, and in
> +=09 * order to maintain filelist/filename integrity, we should
> +=09 * restrict exchange operation to files of the same type.
> +=09 */
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
> +=09=09 * Get an existing directory for the destination parent
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
> +=09=09 * Generate a new path using an existing parent directory
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
> +=09=09bool swap =3D (mode =3D=3D RENAME_EXCHANGE) ? true : false;
> =20
>  =09=09oldid =3D fep->id;
>  =09=09oldparid =3D fep->parent;
> =20
> +=09=09/*
> +=09=09 * Swap the parent ids for RENAME_EXCHANGE, and replace the
> +=09=09 * old parent id for the others.
> +=09=09 */
>  =09=09if (flp - flist =3D=3D FT_DIR)
> -=09=09=09fix_parent(oldid, id);
> +=09=09=09fix_parent(oldid, id, swap);
> =20
>  =09=09if (mode =3D=3D RENAME_WHITEOUT) {
>  =09=09=09fep->xattr_counter =3D 0;
>  =09=09=09add_to_flist(flp - flist, id, parid, xattr_counter);
> +=09=09} else if (mode =3D=3D RENAME_EXCHANGE) {
> +=09=09=09fep->xattr_counter =3D dfep->xattr_counter;
> +=09=09=09dfep->xattr_counter =3D xattr_counter;
>  =09=09} else {
>  =09=09=09del_from_flist(flp - flist, fep - flp->fents);
>  =09=09=09add_to_flist(flp - flist, id, parid, xattr_counter);
> @@ -4359,6 +4403,12 @@ rnoreplace_f(int opno, long r)
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


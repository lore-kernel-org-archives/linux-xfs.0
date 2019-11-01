Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DAD2CA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 17:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4664F2085B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 17:25:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F6T3+gJO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfKARZE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 13:25:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49092 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726979AbfKARZD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 13:25:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572629102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xCR/LW6jk3fvDvaZ5UhbRXHBnxJ/9qsI7jZBGASA6Ns=;
        b=F6T3+gJOjQ4n7DVV4eR9UORlbD6A4/2F3pxM3JSwwDZqPdG5HGeF3e5fjNn64S+3yONHoB
        8y7LqpfWjh/p5GSMDDXCf3UYM00vD3eADK+MNMceyA2mPi0/a170ecU+KwNv483JoGukFi
        M0GjdN3UGlk25Q4b3uf1IgvLO6t7XRs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-St4VKSQ1MZq_MrDyumnb2Q-1; Fri, 01 Nov 2019 13:24:58 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A66D107ACC2;
        Fri,  1 Nov 2019 17:24:57 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A1DA960126;
        Fri,  1 Nov 2019 17:24:55 +0000 (UTC)
Date:   Fri, 1 Nov 2019 13:24:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guaneryu@gmail.com, newtongao@tencent.com, jasperwang@tencent.com
Subject: Re: [PATCH v3 3/4] fsstress: add EXCHANGE renameat2 support
Message-ID: <20191101172453.GH59146@bfoster>
References: <cover.1572503039.git.kaixuxia@tencent.com>
 <cd82570764e56234fbbf8dd20cc9d51aee07c4df.1572503039.git.kaixuxia@tencent.com>
MIME-Version: 1.0
In-Reply-To: <cd82570764e56234fbbf8dd20cc9d51aee07c4df.1572503039.git.kaixuxia@tencent.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: St4VKSQ1MZq_MrDyumnb2Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 31, 2019 at 02:41:48PM +0800, kaixuxia wrote:
> Support the EXCHANGE renameat2 syscall in fsstress.
>=20
> In order to maintain filelist/filename integrity, we restrict
> rexchange to files of the same type.
>=20
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---

Looks good to me and no errors on a quick test:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  ltp/fsstress.c | 117 ++++++++++++++++++++++++++++++++++++++++++++++-----=
------
>  1 file changed, 96 insertions(+), 21 deletions(-)
>=20
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index ecc1adc..0125571 100644
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
> @@ -371,7 +377,8 @@ void=09del_from_flist(int, int);
>  int=09dirid_to_name(char *, int);
>  void=09doproc(void);
>  int=09fent_to_name(pathname_t *, flist_t *, fent_t *);
> -void=09fix_parent(int, int);
> +bool=09fents_ancestor_check(fent_t *, fent_t *);
> +void=09fix_parent(int, int, bool);
>  void=09free_pathname(pathname_t *);
>  int=09generate_fname(fent_t *, int, pathname_t *, int *, int *);
>  int=09generate_xattr_name(int, char *, int);
> @@ -1117,8 +1124,22 @@ fent_to_name(pathname_t *name, flist_t *flp, fent_=
t *fep)
>  =09return 1;
>  }
> =20
> +bool
> +fents_ancestor_check(fent_t *fep, fent_t *dfep)
> +{
> +=09fent_t  *tmpfep;
> +
> +=09for (tmpfep =3D fep; tmpfep->parent !=3D -1;
> +=09     tmpfep =3D dirid_to_fent(tmpfep->parent)) {
> +=09=09if (tmpfep->parent =3D=3D dfep->id)
> +=09=09=09return true;
> +=09}
> +
> +=09return false;
> +}
> +
>  void
> -fix_parent(int oldid, int newid)
> +fix_parent(int oldid, int newid, bool swap)
>  {
>  =09fent_t=09*fep;
>  =09flist_t=09*flp;
> @@ -1129,6 +1150,8 @@ fix_parent(int oldid, int newid)
>  =09=09for (j =3D 0, fep =3D flp->fents; j < flp->nfiles; j++, fep++) {
>  =09=09=09if (fep->parent =3D=3D oldid)
>  =09=09=09=09fep->parent =3D newid;
> +=09=09=09else if (swap && fep->parent =3D=3D newid)
> +=09=09=09=09fep->parent =3D oldid;
>  =09=09}
>  =09}
>  }
> @@ -4256,6 +4279,7 @@ out:
> =20
>  struct print_flags renameat2_flags [] =3D {
>  =09{ RENAME_NOREPLACE, "NOREPLACE"},
> +=09{ RENAME_EXCHANGE, "EXCHANGE"},
>  =09{ RENAME_WHITEOUT, "WHITEOUT"},
>  =09{ -1, NULL}
>  };
> @@ -4291,41 +4315,86 @@ do_renameat2(int opno, long r, int mode)
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
> +=09=09if (which =3D=3D FT_DIRm && (fents_ancestor_check(fep, dfep) ||
> +=09=09    fents_ancestor_check(dfep, fep))) {
> +=09=09=09if (v)
> +=09=09=09=09printf("%d/%d: rename(REXCHANGE) %s and %s "
> +=09=09=09=09=09"have ancestor-descendant relationship\n",
> +=09=09=09=09=09procid, opno, f.path, newf.path);
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
> @@ -4359,6 +4428,12 @@ rnoreplace_f(int opno, long r)
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


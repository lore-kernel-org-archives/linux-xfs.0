Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78862CA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 13:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F0C521479
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 13:39:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FTb1SGr8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388705AbfJ2Nj5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 09:39:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32135 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388274AbfJ2Nj5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 09:39:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572356395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IBlhEju1Lk76XrMZF3WSf+WuceNv7IZPhggY4Fopwls=;
        b=FTb1SGr8NOKCeCwvUpEOnAmBUEpU6xWKRAGK/xw1hnjY8zx0J5FpS/K+yXEEqpCQKb0iH1
        0LOc/FRTWbtPug1TFuOjsPeHK5Cqgi323ktF7BLwZo4CaE4qkxKepRVS9zQINZ30lO9wdq
        vT9+BIqnJktAHG4tjXXtDT7uZE2OMXg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-NlBxdZk_NQuOc9ftnsQ2kg-1; Tue, 29 Oct 2019 09:39:53 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CF0C107AD28;
        Tue, 29 Oct 2019 13:39:52 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D82519C4F;
        Tue, 29 Oct 2019 13:39:50 +0000 (UTC)
Date:   Tue, 29 Oct 2019 09:39:48 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guaneryu@gmail.com, newtongao@tencent.com, jasperwang@tencent.com
Subject: Re: [PATCH v2 2/4] fsstress: add NOREPLACE and WHITEOUT renameat2
 support
Message-ID: <20191029133948.GE41131@bfoster>
References: <cover.1572057903.git.kaixuxia@tencent.com>
 <f7b2754cc5648b70379357d6210a4dc194e44de0.1572057903.git.kaixuxia@tencent.com>
MIME-Version: 1.0
In-Reply-To: <f7b2754cc5648b70379357d6210a4dc194e44de0.1572057903.git.kaixuxia@tencent.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: NlBxdZk_NQuOc9ftnsQ2kg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 26, 2019 at 07:18:36PM +0800, kaixuxia wrote:
> Support the renameat2(NOREPLACE and WHITEOUT) syscall in fsstress.
>=20
> The fent id correlates with filename and the filename correlates
> to type in flist, and the RWHITEOUT operation would leave a dev
> node around with whatever the name of the source file was, so in
> order to maintain filelist/filename integrity, we should restrict
> RWHITEOUT source file to device nodes.
>=20
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---

Looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  ltp/fsstress.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++---=
------
>  1 file changed, 90 insertions(+), 15 deletions(-)
>=20
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 95285f1..ecc1adc 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -44,6 +44,35 @@ io_context_t=09io_ctx;
>  #define IOV_MAX 1024
>  #endif
> =20
> +#ifndef HAVE_RENAMEAT2
> +#if !defined(SYS_renameat2) && defined(__x86_64__)
> +#define SYS_renameat2 316
> +#endif
> +
> +#if !defined(SYS_renameat2) && defined(__i386__)
> +#define SYS_renameat2 353
> +#endif
> +
> +static int renameat2(int dfd1, const char *path1,
> +=09=09     int dfd2, const char *path2,
> +=09=09     unsigned int flags)
> +{
> +#ifdef SYS_renameat2
> +=09return syscall(SYS_renameat2, dfd1, path1, dfd2, path2, flags);
> +#else
> +=09errno =3D ENOSYS;
> +=09return -1;
> +#endif
> +}
> +#endif
> +
> +#ifndef RENAME_NOREPLACE
> +#define RENAME_NOREPLACE=09(1 << 0)=09/* Don't overwrite target */
> +#endif
> +#ifndef RENAME_WHITEOUT
> +#define RENAME_WHITEOUT=09=09(1 << 2)=09/* Whiteout source */
> +#endif
> +
>  #define FILELEN_MAX=09=09(32*4096)
> =20
>  typedef enum {
> @@ -85,6 +114,8 @@ typedef enum {
>  =09OP_READV,
>  =09OP_REMOVEFATTR,
>  =09OP_RENAME,
> +=09OP_RNOREPLACE,
> +=09OP_RWHITEOUT,
>  =09OP_RESVSP,
>  =09OP_RMDIR,
>  =09OP_SETATTR,
> @@ -203,6 +234,8 @@ void=09readlink_f(int, long);
>  void=09readv_f(int, long);
>  void=09removefattr_f(int, long);
>  void=09rename_f(int, long);
> +void=09rnoreplace_f(int, long);
> +void=09rwhiteout_f(int, long);
>  void=09resvsp_f(int, long);
>  void=09rmdir_f(int, long);
>  void=09setattr_f(int, long);
> @@ -262,6 +295,8 @@ opdesc_t=09ops[] =3D {
>  =09/* remove (delete) extended attribute */
>  =09{ OP_REMOVEFATTR, "removefattr", removefattr_f, 1, 1 },
>  =09{ OP_RENAME, "rename", rename_f, 2, 1 },
> +=09{ OP_RNOREPLACE, "rnoreplace", rnoreplace_f, 2, 1 },
> +=09{ OP_RWHITEOUT, "rwhiteout", rwhiteout_f, 2, 1 },
>  =09{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
>  =09{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
>  =09/* set attribute flag (FS_IOC_SETFLAGS ioctl) */
> @@ -354,7 +389,7 @@ int=09open_path(pathname_t *, int);
>  DIR=09*opendir_path(pathname_t *);
>  void=09process_freq(char *);
>  int=09readlink_path(pathname_t *, char *, size_t);
> -int=09rename_path(pathname_t *, pathname_t *);
> +int=09rename_path(pathname_t *, pathname_t *, int);
>  int=09rmdir_path(pathname_t *);
>  void=09separate_pathname(pathname_t *, char *, pathname_t *);
>  void=09show_ops(int, char *);
> @@ -1519,7 +1554,7 @@ readlink_path(pathname_t *name, char *lbuf, size_t =
lbufsiz)
>  }
> =20
>  int
> -rename_path(pathname_t *name1, pathname_t *name2)
> +rename_path(pathname_t *name1, pathname_t *name2, int mode)
>  {
>  =09char=09=09buf1[NAME_MAX + 1];
>  =09char=09=09buf2[NAME_MAX + 1];
> @@ -1528,14 +1563,18 @@ rename_path(pathname_t *name1, pathname_t *name2)
>  =09pathname_t=09newname2;
>  =09int=09=09rval;
> =20
> -=09rval =3D rename(name1->path, name2->path);
> +=09if (mode =3D=3D 0)
> +=09=09rval =3D rename(name1->path, name2->path);
> +=09else
> +=09=09rval =3D renameat2(AT_FDCWD, name1->path,
> +=09=09=09=09 AT_FDCWD, name2->path, mode);
>  =09if (rval >=3D 0 || errno !=3D ENAMETOOLONG)
>  =09=09return rval;
>  =09separate_pathname(name1, buf1, &newname1);
>  =09separate_pathname(name2, buf2, &newname2);
>  =09if (strcmp(buf1, buf2) =3D=3D 0) {
>  =09=09if (chdir(buf1) =3D=3D 0) {
> -=09=09=09rval =3D rename_path(&newname1, &newname2);
> +=09=09=09rval =3D rename_path(&newname1, &newname2, mode);
>  =09=09=09assert(chdir("..") =3D=3D 0);
>  =09=09}
>  =09} else {
> @@ -1555,7 +1594,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
>  =09=09=09append_pathname(&newname2, "../");
>  =09=09=09append_pathname(&newname2, name2->path);
>  =09=09=09if (chdir(buf1) =3D=3D 0) {
> -=09=09=09=09rval =3D rename_path(&newname1, &newname2);
> +=09=09=09=09rval =3D rename_path(&newname1, &newname2, mode);
>  =09=09=09=09assert(chdir("..") =3D=3D 0);
>  =09=09=09}
>  =09=09} else {
> @@ -1563,7 +1602,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
>  =09=09=09append_pathname(&newname1, "../");
>  =09=09=09append_pathname(&newname1, name1->path);
>  =09=09=09if (chdir(buf2) =3D=3D 0) {
> -=09=09=09=09rval =3D rename_path(&newname1, &newname2);
> +=09=09=09=09rval =3D rename_path(&newname1, &newname2, mode);
>  =09=09=09=09assert(chdir("..") =3D=3D 0);
>  =09=09=09}
>  =09=09}
> @@ -4215,8 +4254,17 @@ out:
>  =09free_pathname(&f);
>  }
> =20
> +struct print_flags renameat2_flags [] =3D {
> +=09{ RENAME_NOREPLACE, "NOREPLACE"},
> +=09{ RENAME_WHITEOUT, "WHITEOUT"},
> +=09{ -1, NULL}
> +};
> +
> +#define translate_renameat2_flags(mode)        \
> +=09({translate_flags(mode, "|", renameat2_flags);})
> +
>  void
> -rename_f(int opno, long r)
> +do_renameat2(int opno, long r, int mode)
>  {
>  =09fent_t=09=09*dfep;
>  =09int=09=09e;
> @@ -4228,14 +4276,17 @@ rename_f(int opno, long r)
>  =09int=09=09oldid;
>  =09int=09=09parid;
>  =09int=09=09oldparid;
> +=09int=09=09which;
>  =09int=09=09v;
>  =09int=09=09v1;
> =20
>  =09/* get an existing path for the source of the rename */
>  =09init_pathname(&f);
> -=09if (!get_fname(FT_ANYm, r, &f, &flp, &fep, &v1)) {
> +=09which =3D (mode =3D=3D RENAME_WHITEOUT) ? FT_DEVm : FT_ANYm;
> +=09if (!get_fname(which, r, &f, &flp, &fep, &v1)) {
>  =09=09if (v1)
> -=09=09=09printf("%d/%d: rename - no filename\n", procid, opno);
> +=09=09=09printf("%d/%d: rename - no source filename\n",
> +=09=09=09=09procid, opno);
>  =09=09free_pathname(&f);
>  =09=09return;
>  =09}
> @@ -4261,7 +4312,7 @@ rename_f(int opno, long r)
>  =09=09free_pathname(&f);
>  =09=09return;
>  =09}
> -=09e =3D rename_path(&f, &newf) < 0 ? errno : 0;
> +=09e =3D rename_path(&f, &newf, mode) < 0 ? errno : 0;
>  =09check_cwd();
>  =09if (e =3D=3D 0) {
>  =09=09int xattr_counter =3D fep->xattr_counter;
> @@ -4272,16 +4323,22 @@ rename_f(int opno, long r)
>  =09=09if (flp - flist =3D=3D FT_DIR)
>  =09=09=09fix_parent(oldid, id);
> =20
> -=09=09del_from_flist(flp - flist, fep - flp->fents);
> -=09=09add_to_flist(flp - flist, id, parid, xattr_counter);
> +=09=09if (mode =3D=3D RENAME_WHITEOUT) {
> +=09=09=09fep->xattr_counter =3D 0;
> +=09=09=09add_to_flist(flp - flist, id, parid, xattr_counter);
> +=09=09} else {
> +=09=09=09del_from_flist(flp - flist, fep - flp->fents);
> +=09=09=09add_to_flist(flp - flist, id, parid, xattr_counter);
> +=09=09}
>  =09}
>  =09if (v) {
> -=09=09printf("%d/%d: rename %s to %s %d\n", procid, opno, f.path,
> +=09=09printf("%d/%d: rename(%s) %s to %s %d\n", procid,
> +=09=09=09opno, translate_renameat2_flags(mode), f.path,
>  =09=09=09newf.path, e);
>  =09=09if (e =3D=3D 0) {
> -=09=09=09printf("%d/%d: rename del entry: id=3D%d,parent=3D%d\n",
> +=09=09=09printf("%d/%d: rename source entry: id=3D%d,parent=3D%d\n",
>  =09=09=09=09procid, opno, oldid, oldparid);
> -=09=09=09printf("%d/%d: rename add entry: id=3D%d,parent=3D%d\n",
> +=09=09=09printf("%d/%d: rename target entry: id=3D%d,parent=3D%d\n",
>  =09=09=09=09procid, opno, id, parid);
>  =09=09}
>  =09}
> @@ -4290,6 +4347,24 @@ rename_f(int opno, long r)
>  }
> =20
>  void
> +rename_f(int opno, long r)
> +{
> +=09do_renameat2(opno, r, 0);
> +}
> +
> +void
> +rnoreplace_f(int opno, long r)
> +{
> +=09do_renameat2(opno, r, RENAME_NOREPLACE);
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


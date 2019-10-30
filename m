Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B83CA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 12:41:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05F112080F
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 12:41:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GHIxhIGS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfJ3MlG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 08:41:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30671 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726119AbfJ3MlG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 08:41:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572439264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jwJwdFsFfVCCCGhjx2903N6K6Srwmlu76TC9RUydWTM=;
        b=GHIxhIGS8cONrR4q1EnmjSS3T5Md2EQk240G7APehE4QYvmFricYVgpLtf1s/R/k4IsMGW
        aHEwT3M1UhdyVks7VVXNZSQufTTa9s9OKJuO8URLa8Oda5zrH+x6NBwpLJ9g6gPVkLF4/a
        0UmJ7Zchwxr2lSvWupGGLZjSvkb+BgE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-mmPIXzg_MmeNS4Q44mHykw-1; Wed, 30 Oct 2019 08:40:52 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33CD51005500;
        Wed, 30 Oct 2019 12:40:51 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 262D760BE0;
        Wed, 30 Oct 2019 12:40:49 +0000 (UTC)
Date:   Wed, 30 Oct 2019 08:40:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guaneryu@gmail.com, newtongao@tencent.com, jasperwang@tencent.com
Subject: Re: [PATCH v2 3/4] fsstress: add EXCHANGE renameat2 support
Message-ID: <20191030124047.GA46856@bfoster>
References: <cover.1572057903.git.kaixuxia@tencent.com>
 <8e8cf5e50bc3c26c90d2677d3194d36346ef0c24.1572057903.git.kaixuxia@tencent.com>
 <20191029134010.GF41131@bfoster>
 <8b5f167b-2d7c-a387-c440-80cfe6f95c42@gmail.com>
MIME-Version: 1.0
In-Reply-To: <8b5f167b-2d7c-a387-c440-80cfe6f95c42@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: mmPIXzg_MmeNS4Q44mHykw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 30, 2019 at 11:17:04AM +0800, kaixuxia wrote:
> On 2019/10/29 21:40, Brian Foster wrote:
> > On Sat, Oct 26, 2019 at 07:18:37PM +0800, kaixuxia wrote:
> >> Support the EXCHANGE renameat2 syscall in fsstress.
> >>
> >> In order to maintain filelist/filename integrity, we restrict
> >> rexchange to files of the same type.
> >>
> >> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> >> ---
> >=20
> > While this looks pretty good to me at this point, I do notice instances
> > of the following in a quick test:
> >=20
> > 0/29: rename(EXCHANGE) d3/d9/dc/dd to d3/d9/dc/dd/df 22
> > ...
> > 0/43: rename(EXCHANGE) d3 to d3/d9/dc/d18 22
> > ...
> >=20
> > It looks like we're getting an EINVAL error on rexchange of directories=
.
> > That same operation seems to work fine via the ./src/renameat2 tool. An=
y
> > idea what's going on there?
>=20
> Hmm.. I am not sure if I understand what your mean. Seems like
> this is because the special source and target parameters setting.
> There are parameters check for RENAME_EXCHANGE in renameat2() call,
>=20
>  static int do_renameat2(int olddfd, const char __user *oldname, int newd=
fd,
>                          const char __user *newname, unsigned int flags)
>  {
>   ...
>          /* source should not be ancestor of target */
>          error =3D -EINVAL;
>          if (old_dentry =3D=3D trap)
>                  goto exit5;
>          /* target should not be an ancestor of source */
>          if (!(flags & RENAME_EXCHANGE))
>                  error =3D -ENOTEMPTY;
>          if (new_dentry =3D=3D trap)
>                  goto exit5;
>  ...
>  }=20
>=20
> so we get the EINVAL error on rexchange of directories. I also tested it
> via the ./src/renameat2 tool, and the strace result as below,
>=20

Ah, I see. I wasn't aware of the restriction and didn't catch that quirk
of these particular requests, so I thought it was failing arbitrary
directory swaps (which is what I tested with renameat2). This makes
sense, thanks for the explanation.

>  # src/renameat2 -x /xfs-bufdeadlock/d3 /xfs-bufdeadlock/d3/d9/dc/d18
>   Invalid argument
>=20
>  syscall_316(0xffffff9c, 0x7ffe38930813, 0xffffff9c, 0x7ffe38930827, 0x2,=
 0) =3D -1 (errno 22)
> =20
> Exchange looks a bit more tricky here.. Maybe we have two choices,
> one is just leave the EINVAL there since the fsstress is stress
> test and the EINVAL possibility is low. The other one is we should
> do parameters check before invoking the renameat2() call, if the
> source and target file fents are not suitable we will try more
> until get the right file fents...
>=20

Hmm.. I think it might be fine to ignore from a functional standpoint if
the complexity is too involved to detect and skip. That said, I'm
wondering if the filelist helps us enough here to implement similar
checks as in the kernel VFS. On a quick look, it appears we walk up the
dentry chain looking to see if one dentry is a parent of the other. See
d_ancestor() (called via do_renameat2() -> lock_rename()) for example:

/*
 * ...
 * Returns the ancestor dentry of p2 which is a child of p1, if p1 is
 * an ancestor of p2, else NULL.
 */
struct dentry *d_ancestor(struct dentry *p1, struct dentry *p2)
{
        struct dentry *p;

        for (p =3D p2; !IS_ROOT(p); p =3D p->d_parent) {
                if (p->d_parent =3D=3D p1)
                        return p;
        }
        return NULL;
}

Any reason we couldn't do a couple similar checks on rexchange of two
dirs and skip the rename if necessary?

Brian

> >=20
> > Brian
> >=20
> >>  ltp/fsstress.c | 92 ++++++++++++++++++++++++++++++++++++++++++++-----=
---------
> >>  1 file changed, 71 insertions(+), 21 deletions(-)
> >>
> >> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> >> index ecc1adc..83d6337 100644
> >> --- a/ltp/fsstress.c
> >> +++ b/ltp/fsstress.c
> >> @@ -69,6 +69,9 @@ static int renameat2(int dfd1, const char *path1,
> >>  #ifndef RENAME_NOREPLACE
> >>  #define RENAME_NOREPLACE=09(1 << 0)=09/* Don't overwrite target */
> >>  #endif
> >> +#ifndef RENAME_EXCHANGE
> >> +#define RENAME_EXCHANGE=09=09(1 << 1)=09/* Exchange source and dest *=
/
> >> +#endif
> >>  #ifndef RENAME_WHITEOUT
> >>  #define RENAME_WHITEOUT=09=09(1 << 2)=09/* Whiteout source */
> >>  #endif
> >> @@ -115,6 +118,7 @@ typedef enum {
> >>  =09OP_REMOVEFATTR,
> >>  =09OP_RENAME,
> >>  =09OP_RNOREPLACE,
> >> +=09OP_REXCHANGE,
> >>  =09OP_RWHITEOUT,
> >>  =09OP_RESVSP,
> >>  =09OP_RMDIR,
> >> @@ -235,6 +239,7 @@ void=09readv_f(int, long);
> >>  void=09removefattr_f(int, long);
> >>  void=09rename_f(int, long);
> >>  void=09rnoreplace_f(int, long);
> >> +void=09rexchange_f(int, long);
> >>  void=09rwhiteout_f(int, long);
> >>  void=09resvsp_f(int, long);
> >>  void=09rmdir_f(int, long);
> >> @@ -296,6 +301,7 @@ opdesc_t=09ops[] =3D {
> >>  =09{ OP_REMOVEFATTR, "removefattr", removefattr_f, 1, 1 },
> >>  =09{ OP_RENAME, "rename", rename_f, 2, 1 },
> >>  =09{ OP_RNOREPLACE, "rnoreplace", rnoreplace_f, 2, 1 },
> >> +=09{ OP_REXCHANGE, "rexchange", rexchange_f, 2, 1 },
> >>  =09{ OP_RWHITEOUT, "rwhiteout", rwhiteout_f, 2, 1 },
> >>  =09{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
> >>  =09{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
> >> @@ -371,7 +377,7 @@ void=09del_from_flist(int, int);
> >>  int=09dirid_to_name(char *, int);
> >>  void=09doproc(void);
> >>  int=09fent_to_name(pathname_t *, flist_t *, fent_t *);
> >> -void=09fix_parent(int, int);
> >> +void=09fix_parent(int, int, bool);
> >>  void=09free_pathname(pathname_t *);
> >>  int=09generate_fname(fent_t *, int, pathname_t *, int *, int *);
> >>  int=09generate_xattr_name(int, char *, int);
> >> @@ -1118,7 +1124,7 @@ fent_to_name(pathname_t *name, flist_t *flp, fen=
t_t *fep)
> >>  }
> >> =20
> >>  void
> >> -fix_parent(int oldid, int newid)
> >> +fix_parent(int oldid, int newid, bool swap)
> >>  {
> >>  =09fent_t=09*fep;
> >>  =09flist_t=09*flp;
> >> @@ -1129,6 +1135,8 @@ fix_parent(int oldid, int newid)
> >>  =09=09for (j =3D 0, fep =3D flp->fents; j < flp->nfiles; j++, fep++) =
{
> >>  =09=09=09if (fep->parent =3D=3D oldid)
> >>  =09=09=09=09fep->parent =3D newid;
> >> +=09=09=09else if (swap && fep->parent =3D=3D newid)
> >> +=09=09=09=09fep->parent =3D oldid;
> >>  =09=09}
> >>  =09}
> >>  }
> >> @@ -4256,6 +4264,7 @@ out:
> >> =20
> >>  struct print_flags renameat2_flags [] =3D {
> >>  =09{ RENAME_NOREPLACE, "NOREPLACE"},
> >> +=09{ RENAME_EXCHANGE, "EXCHANGE"},
> >>  =09{ RENAME_WHITEOUT, "WHITEOUT"},
> >>  =09{ -1, NULL}
> >>  };
> >> @@ -4291,41 +4300,76 @@ do_renameat2(int opno, long r, int mode)
> >>  =09=09return;
> >>  =09}
> >> =20
> >> -=09/* get an existing directory for the destination parent directory =
name */
> >> -=09if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
> >> -=09=09parid =3D -1;
> >> -=09else
> >> -=09=09parid =3D dfep->id;
> >> -=09v |=3D v1;
> >> +=09/*
> >> +=09 * Both pathnames must exist for the RENAME_EXCHANGE, and in
> >> +=09 * order to maintain filelist/filename integrity, we should
> >> +=09 * restrict exchange operation to files of the same type.
> >> +=09 */
> >> +=09if (mode =3D=3D RENAME_EXCHANGE) {
> >> +=09=09which =3D 1 << (flp - flist);
> >> +=09=09init_pathname(&newf);
> >> +=09=09if (!get_fname(which, random(), &newf, NULL, &dfep, &v)) {
> >> +=09=09=09if (v)
> >> +=09=09=09=09printf("%d/%d: rename - no target filename\n",
> >> +=09=09=09=09=09procid, opno);
> >> +=09=09=09free_pathname(&newf);
> >> +=09=09=09free_pathname(&f);
> >> +=09=09=09return;
> >> +=09=09}
> >> +=09=09v |=3D v1;
> >> +=09=09id =3D dfep->id;
> >> +=09=09parid =3D dfep->parent;
> >> +=09} else {
> >> +=09=09/*
> >> +=09=09 * Get an existing directory for the destination parent
> >> +=09=09 * directory name.
> >> +=09=09 */
> >> +=09=09if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
> >> +=09=09=09parid =3D -1;
> >> +=09=09else
> >> +=09=09=09parid =3D dfep->id;
> >> +=09=09v |=3D v1;
> >> =20
> >> -=09/* generate a new path using an existing parent directory in name =
*/
> >> -=09init_pathname(&newf);
> >> -=09e =3D generate_fname(dfep, flp - flist, &newf, &id, &v1);
> >> -=09v |=3D v1;
> >> -=09if (!e) {
> >> -=09=09if (v) {
> >> -=09=09=09(void)fent_to_name(&f, &flist[FT_DIR], dfep);
> >> -=09=09=09printf("%d/%d: rename - no filename from %s\n",
> >> -=09=09=09=09procid, opno, f.path);
> >> +=09=09/*
> >> +=09=09 * Generate a new path using an existing parent directory
> >> +=09=09 * in name.
> >> +=09=09 */
> >> +=09=09init_pathname(&newf);
> >> +=09=09e =3D generate_fname(dfep, flp - flist, &newf, &id, &v1);
> >> +=09=09v |=3D v1;
> >> +=09=09if (!e) {
> >> +=09=09=09if (v) {
> >> +=09=09=09=09(void)fent_to_name(&f, &flist[FT_DIR], dfep);
> >> +=09=09=09=09printf("%d/%d: rename - no filename from %s\n",
> >> +=09=09=09=09=09procid, opno, f.path);
> >> +=09=09=09}
> >> +=09=09=09free_pathname(&newf);
> >> +=09=09=09free_pathname(&f);
> >> +=09=09=09return;
> >>  =09=09}
> >> -=09=09free_pathname(&newf);
> >> -=09=09free_pathname(&f);
> >> -=09=09return;
> >>  =09}
> >>  =09e =3D rename_path(&f, &newf, mode) < 0 ? errno : 0;
> >>  =09check_cwd();
> >>  =09if (e =3D=3D 0) {
> >>  =09=09int xattr_counter =3D fep->xattr_counter;
> >> +=09=09bool swap =3D (mode =3D=3D RENAME_EXCHANGE) ? true : false;
> >> =20
> >>  =09=09oldid =3D fep->id;
> >>  =09=09oldparid =3D fep->parent;
> >> =20
> >> +=09=09/*
> >> +=09=09 * Swap the parent ids for RENAME_EXCHANGE, and replace the
> >> +=09=09 * old parent id for the others.
> >> +=09=09 */
> >>  =09=09if (flp - flist =3D=3D FT_DIR)
> >> -=09=09=09fix_parent(oldid, id);
> >> +=09=09=09fix_parent(oldid, id, swap);
> >> =20
> >>  =09=09if (mode =3D=3D RENAME_WHITEOUT) {
> >>  =09=09=09fep->xattr_counter =3D 0;
> >>  =09=09=09add_to_flist(flp - flist, id, parid, xattr_counter);
> >> +=09=09} else if (mode =3D=3D RENAME_EXCHANGE) {
> >> +=09=09=09fep->xattr_counter =3D dfep->xattr_counter;
> >> +=09=09=09dfep->xattr_counter =3D xattr_counter;
> >>  =09=09} else {
> >>  =09=09=09del_from_flist(flp - flist, fep - flp->fents);
> >>  =09=09=09add_to_flist(flp - flist, id, parid, xattr_counter);
> >> @@ -4359,6 +4403,12 @@ rnoreplace_f(int opno, long r)
> >>  }
> >> =20
> >>  void
> >> +rexchange_f(int opno, long r)
> >> +{
> >> +=09do_renameat2(opno, r, RENAME_EXCHANGE);
> >> +}
> >> +
> >> +void
> >>  rwhiteout_f(int opno, long r)
> >>  {
> >>  =09do_renameat2(opno, r, RENAME_WHITEOUT);
> >> --=20
> >> 1.8.3.1
> >>
> >=20
>=20
> --=20
> kaixuxia


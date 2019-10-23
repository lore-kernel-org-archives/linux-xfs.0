Return-Path: <SRS0=UAxe=YQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E16CA9EB6
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 13:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A55021920
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 13:01:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wtgn/Gdc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405407AbfJWNBl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Oct 2019 09:01:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57597 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404790AbfJWNBl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Oct 2019 09:01:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571835700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=77an6VGlYaU/htqVB4ls6atoLy8fwJPV05AZjDNP49w=;
        b=Wtgn/Gdc5AQqwEJfSYxnXRASaSfLllyLk6On+zAZft3ZB7BU8XmW91vhrQ8hs6gwqXNjnW
        6C2EGx4SnO9hu5BpQJKjIB0RmhG8DK81XsNDE12sZiulFz9XomFBPvpd76g5fX5lmRTL7u
        2aiQzmmBHWUkzpKQiTW7Voi9jrpPTkU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-gSMKHnElPdeZWjUbI-8NMg-1; Wed, 23 Oct 2019 09:01:36 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97A9F1005500;
        Wed, 23 Oct 2019 13:01:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8300F5D70E;
        Wed, 23 Oct 2019 13:01:34 +0000 (UTC)
Date:   Wed, 23 Oct 2019 09:01:32 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH v5] fsstress: add renameat2 support
Message-ID: <20191023130132.GC59518@bfoster>
References: <a602433c-ec36-a607-e1bc-6e532e3ebaca@gmail.com>
MIME-Version: 1.0
In-Reply-To: <a602433c-ec36-a607-e1bc-6e532e3ebaca@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: gSMKHnElPdeZWjUbI-8NMg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 22, 2019 at 08:19:37PM +0800, kaixuxia wrote:
> Support the renameat2 syscall in fsstress.
>=20
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---
> Changes in v5:
>  - Fix the RENAME_EXCHANGE flist fents swap problem.
>=20
>  ltp/fsstress.c | 202 +++++++++++++++++++++++++++++++++++++++++++++++----=
------
>  1 file changed, 169 insertions(+), 33 deletions(-)
>=20
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 51976f5..7c59f2d 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
...
> @@ -4269,16 +4367,31 @@ rename_f(int opno, long r)
>  =09=09=09oldid =3D fep->id;
>  =09=09=09fix_parent(oldid, id);
>  =09=09}
> -=09=09del_from_flist(flp - flist, fep - flp->fents);
> -=09=09add_to_flist(flp - flist, id, parid, xattr_counter);
> +
> +=09=09if (mode =3D=3D RENAME_WHITEOUT) {
> +=09=09=09add_to_flist(FT_DEV, fep->id, fep->parent, 0);
> +=09=09=09del_from_flist(flp - flist, fep - flp->fents);
> +=09=09=09add_to_flist(flp - flist, id, parid, xattr_counter);
> +=09=09} else if (mode =3D=3D RENAME_EXCHANGE) {
> +=09=09=09if (dflp - flist =3D=3D FT_DIR) {
> +=09=09=09=09oldid =3D dfep->id;
> +=09=09=09=09fix_parent(oldid, fep->id);
> +=09=09=09}
> +=09=09=09swap_flist_fents(flp - flist, fep - flp->fents,
> +=09=09=09=09=09 dflp - flist, dfep - dflp->fents);

Hmm.. sorry, but this is still a little confusing. One thing I realized
when running this is that the id correlates with filename and the
filename correlates to type (i.e., fN for files, cN for devs, dN for
dirs, etc.). This means that we can now end up doing something like
this:

0/8: rename(EXCHANGE) c4 to f5 0
0/8: rename source entry: id=3D5,parent=3D-1
0/8: rename target entry: id=3D5,parent=3D-1

... which leaves an 'f5' device node and 'c4' regular file. Because of
this, I'm wondering if we should just restrict rexchange to files of the
same type and keep this simple. That means we would use the file type of
the source file when looking up a destination to exchange with (instead
of FT_ANY).

With regard to fixing up the flist, this leaves two general cases:

- Between two non-dirs: REXCHANGE f0 <-> d3/f5

The id -> parent relationship actually hasn't changed because both file
entries still exist just as before the call. We've basically just
swapped inodes from the directory tree perspective. This means
xattr_count needs to be swapped between the entries.

- Between two dirs: REXCHANGE d1 <-> d2/d3

I think the same thing applies as above with regard to the parent ids of
the directories themselves. E.g., d3 is still under d2, it just now
needs the xattr_count from the old d1 and vice versa. Additionally, all
of the children of d2/d3 are now under d1 and vice versa, so those
parent ids need to be swapped. That said, we can't just call
fix_parent() to swap all parentid =3D=3D 1 to 3 and then repeat for 3 -> 1
because that would put everything under 1. Instead, it seems like we
actually need a single fix_parent() sweep to change all 1 -> 3 and 3 ->
1 parent ids in a single pass.

Moving on to RWHITEOUT, the above means that we leave a dev node around
with whatever the name of the source file was. That implies we should
restrict RWHITEOUT to device nodes if we want to maintain
filelist/filename integrity. The immediate question is: would that allow
the associated fstest to still reproduce the deadlock problem? I think
it should, but we should confirm that (i.e., the test now needs to do
'-fmknod=3DNN' instead of '-fcreat=3DNN').

Thoughts? Does that all sound reasonable/correct or have I
misinterpreted things?

Finally, given the complexity disparity between the two operations, at
this point I'd suggest to split this into two patches (one for general
renameat2 support + rwhiteout, another for rexchange support on top).

Brian

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
>  =09=09=09=09procid, opno, fep->id, fep->parent);
> -=09=09=09printf("%d/%d: rename add entry: id=3D%d,parent=3D%d\n",
> +=09=09=09printf("%d/%d: rename target entry: id=3D%d,parent=3D%d\n",
>  =09=09=09=09procid, opno, id, parid);
>  =09=09}
>  =09}
> @@ -4287,6 +4400,29 @@ rename_f(int opno, long r)
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


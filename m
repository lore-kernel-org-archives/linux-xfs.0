Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D91CA9EBD
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 16:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7B7F21E6F
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 16:01:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PiO9lsB+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393656AbfJYQBP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:01:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38528 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2393630AbfJYQBP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 12:01:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572019273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9qGgD+rL1mCzJPjdb6uSdLz8UpQKgGXkm1axivwnviA=;
        b=PiO9lsB+UJCq1fxukofIcPGuKdq8yaXLKEdGxwjTd3is/bNG0jlQBrzwDnbhpm0Q4XRW39
        xCFVEKZkggjARoCXOiwPi6BsBqL7aFHRLPI5GvyTB5hki3HiqJ4qGZkpOrAdxxJCker2Yh
        ymZLYf/gSwMgObBFNwuGdRrNfdY93gA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-xcFlTnyCMby325UWYypOJA-1; Fri, 25 Oct 2019 12:01:10 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF283107AD31;
        Fri, 25 Oct 2019 16:01:08 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 11DFB5D70E;
        Fri, 25 Oct 2019 16:01:07 +0000 (UTC)
Date:   Fri, 25 Oct 2019 12:01:06 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guaneryu@gmail.com, newtongao@tencent.com, jasperwang@tencent.com
Subject: Re: [PATCH 2/4] fsstress: add NOREPLACE and WHITEOUT renameat2
 support
Message-ID: <20191025160106.GE11837@bfoster>
References: <cover.1571926790.git.kaixuxia@tencent.com>
 <1c7113e038b084962acf34f30b93a50ec5ed20aa.1571926790.git.kaixuxia@tencent.com>
MIME-Version: 1.0
In-Reply-To: <1c7113e038b084962acf34f30b93a50ec5ed20aa.1571926790.git.kaixuxia@tencent.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: xcFlTnyCMby325UWYypOJA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 10:20:49PM +0800, kaixuxia wrote:
> Support the renameat2(NOREPLACE and WHITEOUT) syscall in fsstress.
>=20
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---
>  ltp/fsstress.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++---=
------
>  1 file changed, 89 insertions(+), 15 deletions(-)
>=20
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 95285f1..5059639 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
...
> @@ -4272,16 +4323,21 @@ rename_f(int opno, long r)
>  =09=09if (flp - flist =3D=3D FT_DIR)
>  =09=09=09fix_parent(oldid, id);
> =20
> -=09=09del_from_flist(flp - flist, fep - flp->fents);
> -=09=09add_to_flist(flp - flist, id, parid, xattr_counter);
> +=09=09if (mode =3D=3D RENAME_WHITEOUT)
> +=09=09=09add_to_flist(flp - flist, id, parid, xattr_counter);

Hmm, so we've added a new devnode for the target and a whiteout was
added in its place. What about the xattr_count of the original devnode?
I wonder if we should reset that to zero. Other than that the rest looks
fine to me.

Brian

> +=09=09else {
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
> @@ -4290,6 +4346,24 @@ rename_f(int opno, long r)
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


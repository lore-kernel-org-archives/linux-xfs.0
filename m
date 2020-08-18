Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18DB4C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 03:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9F2D207DE
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 03:25:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Om+U1qDV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgHRDZt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 23:25:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23840 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726422AbgHRDZt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 23:25:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597721147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sjvunXuH427JuUewluiKQ62JX/ns9cVyx8gwJh3RHQc=;
        b=Om+U1qDVb6iqi96X/SGL7kTwVCTUaPW4oeMGFc/P2kxLRpjdX2MFHQqCzg6J81TPXJmuYj
        RIpkTfaD4EFmwTrtKsSLx7eFBpfDY0q1497LqNDoG8ACg+oIMYXWwHnuwZZsvU+9kyj8Z8
        5k7Q9mn90TtUcTL8uktVSB1Jmn3sZew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-sX4-tMxJNnaglyza-pwuJw-1; Mon, 17 Aug 2020 23:25:45 -0400
X-MC-Unique: sX4-tMxJNnaglyza-pwuJw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F0271006702;
        Tue, 18 Aug 2020 03:25:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8807D1A7CD;
        Tue, 18 Aug 2020 03:25:44 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7D67B60345;
        Tue, 18 Aug 2020 03:25:44 +0000 (UTC)
Date:   Mon, 17 Aug 2020 23:25:44 -0400 (EDT)
From:   Jianhong Yin <jiyin@redhat.com>
To:     sandeen@redhat.com
Cc:     linux-xfs@vger.kernel.org, Jianhong Yin <yin-jianhong@163.com>
Message-ID: <1538111614.12358313.1597721144157.JavaMail.zimbra@redhat.com>
In-Reply-To: <16bf0257-dbfa-ff0a-cb96-b247acadb2ef@redhat.com>
References: <20200817090048.17991-1-jiyin@redhat.com> <16bf0257-dbfa-ff0a-cb96-b247acadb2ef@redhat.com>
Subject: Re: [PATCH] [xfs_db:type] do nothing if 'current type' == 'the
 requested type'
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.68.5.41, 10.4.195.1]
Thread-Topic: do nothing if 'current type' == 'the requested type'
Thread-Index: kUAjyUoEjPOC8ejdVYBOP2ZA6K61rg==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


----- =E5=8E=9F=E5=A7=8B=E9=82=AE=E4=BB=B6 -----
> =E5=8F=91=E4=BB=B6=E4=BA=BA: "Eric Sandeen" <esandeen@redhat.com>
> =E6=94=B6=E4=BB=B6=E4=BA=BA: "Jianhong Yin" <jiyin@redhat.com>, linux-xfs=
@vger.kernel.org
> =E6=8A=84=E9=80=81: "Jianhong Yin" <yin-jianhong@163.com>
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: =E6=98=9F=E6=9C=9F=E4=BA=8C, 2020=
=E5=B9=B4 8 =E6=9C=88 18=E6=97=A5 =E4=B8=8A=E5=8D=88 4:33:15
> =E4=B8=BB=E9=A2=98: Re: [PATCH] [xfs_db:type] do nothing if 'current type=
' =3D=3D 'the requested type'
>=20
> On 8/17/20 4:00 AM, Jianhong Yin wrote:
> > From: Jianhong Yin <yin-jianhong@163.com>
> >=20
> > for power saving and also as a workaround of below issue:
> >> xfs_db -r /dev/vda3 -c "inode 132" -c "type inode" -c "inode"
> >> current inode number is 128
> >=20
> > Reported-by: Jianhong Yin <jiyin@redhat.com>
> > Suggested-by: Eric Sandeen <esandeen@redhat.com>
> > Tested-by: Jianhong Yin <yin-jianhong@163.com>
> > Signed-off-by: Jianhong Yin <yin-jianhong@163.com>
> > ---
> >  db/type.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >=20
> > diff --git a/db/type.c b/db/type.c
> > index 3cb1e868..679de1b0 100644
> > --- a/db/type.c
> > +++ b/db/type.c
> > @@ -213,6 +213,9 @@ type_f(
> > =20
> > =20
> >  =09} else {
> > +=09=09if (cur_typ !=3D NULL && strcmp(cur_typ->name, argv[1]) =3D=3D 0=
)
> > +=09=09=09return 0;
> > +
> >  =09=09tt =3D findtyp(argv[1]);
> >  =09=09if (tt =3D=3D NULL) {
> >  =09=09=09dbprintf(_("no such type %s\n"), argv[1]);
>=20
> Thanks for this - I had a patch on my stack to do the same thing,
> but did I it this way:
>=20
> diff --git a/db/type.c b/db/type.c
> index 3cb1e868..5433bcfb 100644
> --- a/db/type.c
> +++ b/db/type.c
> @@ -219,6 +219,8 @@ type_f(
>  =09=09} else {
>  =09=09=09if (iocur_top->typ =3D=3D NULL)
>  =09=09=09=09dbprintf(_("no current object\n"));
> +=09=09=09else if (iocur_top->typ =3D=3D tt)
> +=09=09=09=09return 0;
>  =09=09=09else {
>  =09=09=09=09cur_typ =3D tt;
>  =09=09=09=09set_iocur_type(tt);
>=20
> which I guess I like a little better than using strcmp on the argument...
> it compares the type structure directly, rather than comparing the names.
Good to know that :)

I just thought that 'tt' is also come from findtyp()->forearch:strcmp(argv,=
)
 and it could save more cpu instructions if compare before findtyp().

but seems I forgot that findtyp() is always needed if curtyp !=3D requested=
 type

"Premature optimization is the root of all evil" ...

Thanks
Jianhong

>=20
> -Eric
>=20


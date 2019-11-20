Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A577CC432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 22:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F98E2088F
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 22:44:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IOaeNfRK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbfKTWoN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 17:44:13 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34046 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725820AbfKTWoN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 17:44:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574289852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5+23d4IG9IIhNJZALFRvFPnj5ZN8Fl8WxULwSSegPW4=;
        b=IOaeNfRKTkC0xgmIHNWddVFWLPjzhXMc+JttGJgOhWsmBB+HwdgXUnuvYRIXsSNzjVngJo
        x51Mm7Rl6fX0zAWRcSKy5nrnjvKvpqtC+2WbHe6O76taxmIXp9ZfWK9TWBOf48xFb6f8l2
        5ZwTwdLhsUFltdBy28wyTxu/RxHEj8g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-mSNG49F3P_mu4PCsdgSm1g-1; Wed, 20 Nov 2019 17:44:10 -0500
Received: by mail-wr1-f71.google.com with SMTP id h7so1053442wrb.2
        for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2019 14:44:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=Q0uo9Um/+gtVbwo53kRaQGs/qNUcTcwIx+tUMpZG+Mo=;
        b=mkkIryEEZu5UsJ1gMWpnrgYpBTHRSVX0UBXitzBLjy+zkN25vOOvyuxZw53qR8HGAF
         xQ3iJct/5rZLm/fgvxD9tAZZUfMGG+vYenjlra8+9MFNQoYmV6EjNfzGSt4wpYo3ktiA
         WtbgmDsuUZNdVghOp1yGzX+ESYNHuNOuQrfsZgYW0oK8W+Ehre0E0HzqAlaRR2zhYJu0
         4QQeGrEPR4k9qW9ouTRZwPwwxe7YHA3MT1jWLhZYfRiAOl3nsOR/QNj8p6kyltZnPllt
         /zCUikisuvlMpDYm8ye7Vz8VyyKimBOpoTAZ2sZ/ewFCqj42f7ke+pe/pK1iHOf7uJdA
         waag==
X-Gm-Message-State: APjAAAW73vF9jhQSol2Rckz0+9PTvKaLrPt+Q4DigS5d5rLA7EG+mi2w
        jgGg5ivJOVa2nN8F7x/o0gJzUFzyMod1Cd8ktXeY2L0M+xVuDmLepTMgfrAhprQIpuQvrXkhij8
        d14hqyz8bQ4nhr/mUBy3g
X-Received: by 2002:adf:fe0b:: with SMTP id n11mr6368166wrr.218.1574289848643;
        Wed, 20 Nov 2019 14:44:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqwHflUb3Yq0LkFjZRQpYkaZs/9iRMzDcuCpMEojH5oHxCHULUIw6Wi8oIcvzgezJHxv72KWSA==
X-Received: by 2002:adf:fe0b:: with SMTP id n11mr6368144wrr.218.1574289848340;
        Wed, 20 Nov 2019 14:44:08 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id u13sm688419wmm.45.2019.11.20.14.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 14:44:07 -0800 (PST)
Date:   Wed, 20 Nov 2019 23:44:04 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: remove kmem_zalloc() wrapper
Message-ID: <20191120224404.dbuegv5ejmydrlb6@orion>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20191120104425.407213-1-cmaiolino@redhat.com>
 <20191120104425.407213-4-cmaiolino@redhat.com>
 <20191120212401.GC4614@dread.disaster.area>
 <20191120214145.GT6219@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191120214145.GT6219@magnolia>
X-MC-Unique: mSNG49F3P_mu4PCsdgSm1g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 01:41:45PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 21, 2019 at 08:24:01AM +1100, Dave Chinner wrote:
> > On Wed, Nov 20, 2019 at 11:44:23AM +0100, Carlos Maiolino wrote:
> > > Use kzalloc() directly
> > >=20
> > > Special attention goes to function xfs_buf_map_from_irec(). Giving th=
e
> > > fact we are not allowed to fail there, I removed the 'if (!map)'
> > > conditional from there, I'd just like somebody to double check if it'=
s
> > > fine as I believe it is
> > >=20
> > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> >=20
> > It looks good as a 1:1 translation, but I've noticed a few places we
> > actually have the context wrong and have been saved by the fact tehy
> > are called in transaction context (hence GFP_NOFS is enforced by
> > task flags).
> >=20
> > This can be fixed in a separate patch, I've noted the ones I think
> > need changing below.
> >=20
> > > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_l=
eaf.c
> > > index 795b9b21b64d..67de68584224 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > @@ -2253,7 +2253,8 @@ xfs_attr3_leaf_unbalance(
> > >  =09=09struct xfs_attr_leafblock *tmp_leaf;
> > >  =09=09struct xfs_attr3_icleaf_hdr tmphdr;
> > > =20
> > > -=09=09tmp_leaf =3D kmem_zalloc(state->args->geo->blksize, 0);
> > > +=09=09tmp_leaf =3D kzalloc(state->args->geo->blksize,
> > > +=09=09=09=09   GFP_KERNEL | __GFP_NOFAIL);
> >=20
> > In a transaction, GFP_NOFS.
>=20
> As we're discussing on IRC, this is probably correct, but let's do a
> straight KM_ -> GFP_ conversion here, warts and all; and then do a
> separate series to sort out incorrect flag usage.

Sure, thanks guys, I can focus on that then after this series. Do you guys
prefer me to 'finish' this series (i.e. removing KM_* flags), or fixing the
wrong contexts before the next patches for KM_* -> GFP_* stuff?

Cheers.

>=20
> --D
>=20
> > > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > > index dc39b2d1b351..4fea8e5e70fb 100644
> > > --- a/fs/xfs/xfs_buf_item.c
> > > +++ b/fs/xfs/xfs_buf_item.c
> > > @@ -701,8 +701,8 @@ xfs_buf_item_get_format(
> > >  =09=09return 0;
> > >  =09}
> > > =20
> > > -=09bip->bli_formats =3D kmem_zalloc(count * sizeof(struct xfs_buf_lo=
g_format),
> > > -=09=09=09=090);
> > > +=09bip->bli_formats =3D kzalloc(count * sizeof(struct xfs_buf_log_fo=
rmat),
> > > +=09=09=09=09   GFP_KERNEL | __GFP_NOFAIL);
> > >  =09if (!bip->bli_formats)
> > >  =09=09return -ENOMEM;
> > >  =09return 0;
> >=20
> > In a transaction, GFP_NOFS.
> >=20
> > > diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> > > index 1b5e68ccef60..91bd47e8b832 100644
> > > --- a/fs/xfs/xfs_dquot_item.c
> > > +++ b/fs/xfs/xfs_dquot_item.c
> > > @@ -347,7 +347,8 @@ xfs_qm_qoff_logitem_init(
> > >  {
> > >  =09struct xfs_qoff_logitem=09*qf;
> > > =20
> > > -=09qf =3D kmem_zalloc(sizeof(struct xfs_qoff_logitem), 0);
> > > +=09qf =3D kzalloc(sizeof(struct xfs_qoff_logitem),
> > > +=09=09     GFP_KERNEL | __GFP_NOFAIL);
> >=20
> > In a transaction, GFP_NOFS.
> >=20
> > > diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> > > index 9f0b99c7b34a..0ce50b47fc28 100644
> > > --- a/fs/xfs/xfs_extent_busy.c
> > > +++ b/fs/xfs/xfs_extent_busy.c
> > > @@ -33,7 +33,8 @@ xfs_extent_busy_insert(
> > >  =09struct rb_node=09=09**rbp;
> > >  =09struct rb_node=09=09*parent =3D NULL;
> > > =20
> > > -=09new =3D kmem_zalloc(sizeof(struct xfs_extent_busy), 0);
> > > +=09new =3D kzalloc(sizeof(struct xfs_extent_busy),
> > > +=09=09      GFP_KERNEL | __GFP_NOFAIL);
> >=20
> > transaction, GFP_NOFS.
> >=20
> > >  =09new->agno =3D agno;
> > >  =09new->bno =3D bno;
> > >  =09new->length =3D len;
> > > diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> > > index c3b8804aa396..872312029957 100644
> > > --- a/fs/xfs/xfs_extfree_item.c
> > > +++ b/fs/xfs/xfs_extfree_item.c
> > > @@ -163,7 +163,7 @@ xfs_efi_init(
> > >  =09if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
> > >  =09=09size =3D (uint)(sizeof(xfs_efi_log_item_t) +
> > >  =09=09=09((nextents - 1) * sizeof(xfs_extent_t)));
> > > -=09=09efip =3D kmem_zalloc(size, 0);
> > > +=09=09efip =3D kzalloc(size, GFP_KERNEL | __GFP_NOFAIL);
> > >  =09} else {
> > >  =09=09efip =3D kmem_cache_zalloc(xfs_efi_zone,
> > >  =09=09=09=09=09 GFP_KERNEL | __GFP_NOFAIL);
> >=20
> > Both of these GFP_NOFS.
> >=20
> > > @@ -333,9 +333,9 @@ xfs_trans_get_efd(
> > >  =09ASSERT(nextents > 0);
> > > =20
> > >  =09if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
> > > -=09=09efdp =3D kmem_zalloc(sizeof(struct xfs_efd_log_item) +
> > > +=09=09efdp =3D kzalloc(sizeof(struct xfs_efd_log_item) +
> > >  =09=09=09=09(nextents - 1) * sizeof(struct xfs_extent),
> > > -=09=09=09=090);
> > > +=09=09=09=09GFP_KERNEL | __GFP_NOFAIL);
> > >  =09} else {
> > >  =09=09efdp =3D kmem_cache_zalloc(xfs_efd_zone,
> > >  =09=09=09=09=09 GFP_KERNEL | __GFP_NOFAIL);
> >=20
> > Same here.
> >=20
> > Hmmm. I guess I better go look at the kmem_cache_[z]alloc() patches,
> > too.
> >=20
> > > diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> > > index 76b39f2a0260..7ec70a5f1cb0 100644
> > > --- a/fs/xfs/xfs_refcount_item.c
> > > +++ b/fs/xfs/xfs_refcount_item.c
> > > @@ -143,8 +143,8 @@ xfs_cui_init(
> > > =20
> > >  =09ASSERT(nextents > 0);
> > >  =09if (nextents > XFS_CUI_MAX_FAST_EXTENTS)
> > > -=09=09cuip =3D kmem_zalloc(xfs_cui_log_item_sizeof(nextents),
> > > -=09=09=09=090);
> > > +=09=09cuip =3D kzalloc(xfs_cui_log_item_sizeof(nextents),
> > > +=09=09=09       GFP_KERNEL | __GFP_NOFAIL);
> > >  =09else
> > >  =09=09cuip =3D kmem_cache_zalloc(xfs_cui_zone,
> > >  =09=09=09=09=09 GFP_KERNEL | __GFP_NOFAIL);
> >=20
> > Both GFP_NOFS.
> >=20
> > > diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> > > index 6aeb6745d007..82d822885996 100644
> > > --- a/fs/xfs/xfs_rmap_item.c
> > > +++ b/fs/xfs/xfs_rmap_item.c
> > > @@ -142,7 +142,8 @@ xfs_rui_init(
> > > =20
> > >  =09ASSERT(nextents > 0);
> > >  =09if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
> > > -=09=09ruip =3D kmem_zalloc(xfs_rui_log_item_sizeof(nextents), 0);
> > > +=09=09ruip =3D kzalloc(xfs_rui_log_item_sizeof(nextents),
> > > +=09=09=09       GFP_KERNEL | __GFP_NOFAIL);
> > >  =09else
> > >  =09=09ruip =3D kmem_cache_zalloc(xfs_rui_zone,
> > >  =09=09=09=09=09 GFP_KERNEL | __GFP_NOFAIL);
> >=20
> > Both GFP_NOFS.
> >=20
> > Cheers,
> >=20
> > Dave.
> > --=20
> > Dave Chinner
> > david@fromorbit.com
>=20

--=20
Carlos


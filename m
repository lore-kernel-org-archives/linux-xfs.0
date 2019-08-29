Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0525DC3A5A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 12:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB15C2189D
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 12:59:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jTNBqfky"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfH2M7a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 08:59:30 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46464 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbfH2M7a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 08:59:30 -0400
Received: by mail-qk1-f193.google.com with SMTP id p13so2752877qkg.13;
        Thu, 29 Aug 2019 05:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HEKZCS+bOazP6E7OgzEFyhh89atM6KuakPKyM2V0+Q0=;
        b=jTNBqfkyRwfBmowP8r9mNdxfaV9F4Wc+RvgJy0HLuVBRiynOZSmqbVo/6Bk6k6W+Sw
         mR+8KKknLHDpBGs6OLWU4yzpxK9LHNYubewHurtsBPsgY0z9Hk4heFFTxhgT+Af5g8xb
         RxgPBCiFNc8JguF7yE2xbiJBiOxrPakMQYPp0NzAA9qoIzYC9L8Lb4CFUMRmkhgNezrS
         XFdf4nwnDf9R2kYYsWhkSJ4OKI6Mr1vPpzagQDnO8NdtDmrjiVu46o6KgR1nQ6Qm2aYV
         EIR7YiKGdst/exzCME/iJBvNO6qFsmsRAV7cP3Xw4oS6Ki2zLVgr41mqPouJx/VVfDzF
         N4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HEKZCS+bOazP6E7OgzEFyhh89atM6KuakPKyM2V0+Q0=;
        b=YEOwfQrtZlSRy1pXsPYUe3IE953VUMvqyCYOwWCQbkjZxfcA3HAaN9RFmjltIyUx+7
         N/xqo6UpTvxrT1deQdZ6cj0eRKQaYpXaasshn1Cbngs8xER2s3p0yqJuwCmXUXO/TSwy
         jbrT0tW7L7nBUrqvD1u8DWBXw/Z5xA7anKVj/4EYbNHWIeQKzoO70SX/eJZvbFKdb/Nk
         0rGVD/ujBevvGtfpaeqp6jr19EiDJ3rT5qX/Xh4TVS9cvnrqom17l2F9zWkOQQ89fJ4M
         DPbZkuys3ZDQQfGA77OOCoh1Ne5VrxOj4rqWam4ephWz2/D0i56D6lTBOZzPZoxwX8RL
         wScA==
X-Gm-Message-State: APjAAAUzyrxgVjQyftoUhCY5NgChbIJhx0C9xCDrSYfCUdUShpjco2IG
        g+qDxgvLwTUL3JrPJi3X5NlbUN6J38N6OXiVHACTQiBi
X-Google-Smtp-Source: APXvYqwi7VYGZqQTv1Zo3sNDjutu6dnG8lQDHVh8JHFtc1AxhnyE18KO4tRB8sr/3QJ76hrnuFrBDkD7KyFy2dCSNEY=
X-Received: by 2002:a05:620a:13c5:: with SMTP id g5mr8924033qkl.433.1567083568871;
 Thu, 29 Aug 2019 05:59:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190828064749.GA165571@LGEARND20B15> <20190829075655.GD18966@infradead.org>
In-Reply-To: <20190829075655.GD18966@infradead.org>
From:   Austin Kim <austindh.kim@gmail.com>
Date:   Thu, 29 Aug 2019 21:59:17 +0900
Message-ID: <CADLLry7s=-v5cjAmu04rKad-ycOycO1UCPTpC+exL6MqbzUGtw@mail.gmail.com>
Subject: Re: [PATCH] xfs: Use WARN_ON rather than BUG() for bailout mount-operation
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

2019=EB=85=84 8=EC=9B=94 29=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 4:56, C=
hristoph Hellwig <hch@infradead.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On Wed, Aug 28, 2019 at 03:47:49PM +0900, Austin Kim wrote:
> > If the CONFIG_BUG is enabled, BUG() is executed and then system is cras=
hed.
> > However, the bailout for mount is no longer proceeding.
> >
> > For this reason, using WARN_ON rather than BUG() could prevent this sit=
uation.
> > ---
> >  fs/xfs/xfs_mount.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 322da69..10fe000 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -213,8 +213,7 @@ xfs_initialize_perag(
> >                       goto out_hash_destroy;
> >
> >               spin_lock(&mp->m_perag_lock);
> > -             if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
> > -                     BUG();
> > +             if (WARN_ON(radix_tree_insert(&mp->m_perag_tree, index, p=
ag))){
>
> Please make this a WARN_ON_ONCE so that we don't see a flodding of
> messages in case of this error.
>
Hello, Mr. Christoph
Thanks for good feedback.
If the kernel log is flooded with error message, as you pointed out,
it may cause other side-effect.(e.g: system non-responsive or lockup)

To. Mr. Darrick J. Wong
If you or other kernel developers do not disagree with the
idea(WARN_ON_ONCE instead of WARN_ON),
do I have to resend the patch with new revision?

The title, the commit message and patch might be changed as followings;
=3D=3D=3D=3D=3D=3D
xfs: Use WARN_ON_ONCE rather than BUG() for bailout mount-operation

If the CONFIG_BUG is enabled, BUG() is executed and then system is crashed.
However, the bailout for mount is no longer proceeding.

For this reason, using WARN_ON_ONCE rather than BUG() could prevent
this situation.

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 322da69..d831c13 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -213,8 +213,7 @@ xfs_initialize_perag(
                        goto out_hash_destroy;

                spin_lock(&mp->m_perag_lock);
-               if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
-                       BUG();
+               if (WARN_ON_ONCE(radix_tree_insert(&mp->m_perag_tree,
index, pag))) {
                        spin_unlock(&mp->m_perag_lock);
                        radix_tree_preload_end();
                        error =3D -EEXIST;
=3D=3D=3D=3D=3D=3D

BR,
Guillermo Austin Kim

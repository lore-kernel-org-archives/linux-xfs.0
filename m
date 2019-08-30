Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B18D6C3A59F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 01:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F75A21726
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 01:38:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KzuSLJOr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfH3BiK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 21:38:10 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45341 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfH3BiK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 21:38:10 -0400
Received: by mail-qk1-f195.google.com with SMTP id m2so4751748qki.12;
        Thu, 29 Aug 2019 18:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=riBD6zIa0GLwxZxw5kjfrzLClNMKDhfP3dU69LeJJuE=;
        b=KzuSLJOrcRihiHLsTnPx+PjcG0KIUfLAnA9glP7fuG2YK7/RRlQtmXifOyTXNpXs06
         wPNFDT4AV/NlElcaQwEqwvWq63hF36D2fsOiYNe2btW8g7Sy0iaPjZELJpG+e4LxeTFx
         lrlB7Ot1pxWEPOxDWcwDN3Rd7h0FjTOS3W0GJudkFLDEZKXtKexZRAnEBYV28ZuW8E5z
         KgK72lTGMk58vWTc/haCWSq73/Mq0GWf0DqHbgE7is2yAsX3nUu2L06D2znstREBlJqC
         LfcbK2dd8SpNe/K6nPcJVk6jBNvGClDGk6cA5e/vc+RjOEc6NIoxUqwUNtPAOGY4jsu4
         /x3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=riBD6zIa0GLwxZxw5kjfrzLClNMKDhfP3dU69LeJJuE=;
        b=ge5g89R0MoQ3dMH5gJ/wWpfCDwuRfF7clBqpvZGa7KH0RwvzeElwMhZg/gYkS4tOQd
         TioB/waDzD0Tla0zsY7WX9AMCamNogGFkkqnhfMK00WsRGgt3vpvRFRwY+E8D2tkbTux
         eZ3ZVjAWYLzCgaA+5h8anqNlERZhBLFMV16eD9BLWOusuoMTau4/k2oGWf5+frJ+BO37
         HfdJd4oIZstIVGeS5Jl/fxSOXyHpYkMkZs8jq4EaTyHdvo9PNahv5wKEVFOeff/VPOP/
         PFCtAbS0NC7jcHu3cz+Z1Te9xzMTZxSCFYcE6WNEOCR68rhCcbbHRDU3zto+LWJZ7VVY
         fUmw==
X-Gm-Message-State: APjAAAXMMQhYIffqMYcesxUdfRTIVe0ONNeh24RIwpDvTlcEIAZ/q4fU
        Wsg6jGr7o6qNo1X5wM1xbUOCE3oQvDeABxOzbnY=
X-Google-Smtp-Source: APXvYqxx/DUEr1wrbCAVRGFpFI1e1ScthD1Gbbq8Of2A5WiFuipHThL8SOTiWitnlIqCWjysQ9pr+6R8Tlffocsy0lg=
X-Received: by 2002:a05:620a:691:: with SMTP id f17mr13059559qkh.470.1567129089481;
 Thu, 29 Aug 2019 18:38:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190830003022.GA152970@LGEARND20B15> <20190830003356.GW5354@magnolia>
In-Reply-To: <20190830003356.GW5354@magnolia>
From:   Austin Kim <austindh.kim@gmail.com>
Date:   Fri, 30 Aug 2019 10:37:58 +0900
Message-ID: <CADLLry5Z1ex_FCnBj4_kX=FTRkVY9ykKR5u3bpL5Z30zMHVdyQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: Use WARN_ON_ONCE rather than BUG for bailout mount-operation
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

2019=EB=85=84 8=EC=9B=94 30=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 9:33, D=
arrick J. Wong <darrick.wong@oracle.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> On Fri, Aug 30, 2019 at 09:30:22AM +0900, Austin Kim wrote:
> > If the CONFIG_BUG is enabled, BUG is executed and then system is crashe=
d.
> > However, the bailout for mount is no longer proceeding.
> >
> > For this reason, using WARN_ON_ONCE rather than BUG can prevent this si=
tuation.
> >
> > Signed-off-by: Austin Kim <austindh.kim@gmail.com>
> > ---
> >  fs/xfs/xfs_mount.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 322da69..c0d0b72 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -213,8 +213,7 @@ xfs_initialize_perag(
> >                       goto out_hash_destroy;
> >
> >               spin_lock(&mp->m_perag_lock);
> > -             if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
> > -                     BUG();
> > +             if (WARN_ON_ONCE(radix_tree_insert(&mp->m_perag_tree, ind=
ex, pag))) {
>
> Er... please wrap the line at 80 columns.

Oh..
Let me resend patch soon after wrapping 80 column lines.

>
> --D
>
> >                       spin_unlock(&mp->m_perag_lock);
> >                       radix_tree_preload_end();
> >                       error =3D -EEXIST;
> > --
> > 2.6.2
> >

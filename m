Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FBAC3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 14:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC83423429
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 14:53:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FLzNB5xX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbfH3OxR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 10:53:17 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40725 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbfH3OxR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 10:53:17 -0400
Received: by mail-qk1-f193.google.com with SMTP id f10so6367614qkg.7;
        Fri, 30 Aug 2019 07:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=elBMA7XStNQqn0xnx17M5IleJjwTUUXWgaglfXsybBk=;
        b=FLzNB5xXAXrVENogWaDCuVt1rfRYsBVVUMJdaR/Da4BqDSG84guWmY7CTISXgHkCLd
         3SL8vvScXbqB4Nu/2H/g0F3j8MjXsIuBOSIjXG2XT8Ua9Pmwkc9PQS3Z/iDoR42G+IFJ
         IdhkSyj0AhT6d0EBttvT/qC5+qFIUbI6/YGdI1nvxsUFQWe1kaZJaOFu0lZL5L93zNL8
         T/A71rhoyNavJU8Fm3cX5q4/Wii+GNqb9bD890/eFR8sXSJBE4HDmF7b00cpsI/G2qQi
         Bi+r/nvwJa5fpwG/czdxl8zXo2msjgCGNQjY19iSVHug+FDC/3xrg/h0/D3//5CuQBV2
         6hxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=elBMA7XStNQqn0xnx17M5IleJjwTUUXWgaglfXsybBk=;
        b=S9l2L0pneDyDbxDBRSOso7h/OCs3//Xcb+adBgqi9heb4KLZjY0ef2g9ciMRW3BiT5
         NEl93iyrPejeTZHWIEFNN0AbbAXCuAiNUwPfs5MNbEmaD3zZ5767EFKZ+eBFqkWdQmtY
         QDEDzrVGGWtH2cbgqC1hkYM13G363/AdfT33pp8c/tduyoxPXqOTNy8aQNCPdIQ8ntTC
         seYv205vlhOfJiBOQUVcsBI3jaSJD1rbPD2DgAHG0FVCZaRroz3TDFnetBigScZgCd/G
         9iKpcCgeSNzfiPso9dpI+C2LMrBv1WmPxoxIiS6aj0zW4GRDoCyRt4AYNtfG0PD/eLIy
         KTlA==
X-Gm-Message-State: APjAAAWJ9os19JBQ6Q83rzr9cJfZgeCtDBfXL/ejCoSKFSDJERtxMOQB
        Nn9HKRqQk3nWwLuxzZhXx0qmtDU4cBP+ZyG4J0s=
X-Google-Smtp-Source: APXvYqx8V+U14X5ZOkymoLRGvOmUGRSj4Iv2MrQEv1E8NH7cdtmdiapBnrQ5HQJDqHJzP/Gf3RC33CVuDzVaClVSq+M=
X-Received: by 2002:a37:b07:: with SMTP id 7mr14362304qkl.386.1567176796337;
 Fri, 30 Aug 2019 07:53:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190830053707.GA69101@LGEARND20B15> <20190830053945.GX5354@magnolia>
In-Reply-To: <20190830053945.GX5354@magnolia>
From:   Austin Kim <austindh.kim@gmail.com>
Date:   Fri, 30 Aug 2019 23:53:06 +0900
Message-ID: <CADLLry6yf1a_8ruR=DV78hUdgNAi+kN8ReciEgwjozjahpCgrQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: Initialize label array properly
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

2019=EB=85=84 8=EC=9B=94 30=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 2:39, D=
arrick J. Wong <darrick.wong@oracle.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> On Fri, Aug 30, 2019 at 02:37:07PM +0900, Austin Kim wrote:
> > In case kernel stack variable is not initialized properly,
> > there is a risk of kernel information disclosure.
> >
> > So, initialize 'char label[]' array with null characters.
>
> Got a testcase for this?  At least a couple other filesystems implement
> this ioctl too, which means they all should be checked/tested on a
> regular basis.

Thanks for feedback.
As you pointed out, I figured out ioctl(e.g: ext4_ioctl, f2fs_ioctl)
of other file system is implemented with the same ways.
Please ignore the patch in this mail thread.

BR,
Austin Kim

>
> --D
>
> > Signed-off-by: Austin Kim <austindh.kim@gmail.com>
> > ---
> >  fs/xfs/xfs_ioctl.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 9ea5166..09b3bee 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -2037,7 +2037,7 @@ xfs_ioc_setlabel(
> >       char                    __user *newlabel)
> >  {
> >       struct xfs_sb           *sbp =3D &mp->m_sb;
> > -     char                    label[XFSLABEL_MAX + 1];
> > +     char                    label[XFSLABEL_MAX + 1] =3D {0};
> >       size_t                  len;
> >       int                     error;
> >
> > --
> > 2.6.2
> >

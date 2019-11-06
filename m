Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 594C8C5DF63
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 18:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2422E20869
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 18:30:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ucHv9viP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfKFSaA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 13:30:00 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:40717 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbfKFSaA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 13:30:00 -0500
Received: by mail-yb1-f196.google.com with SMTP id y18so4270780ybs.7
        for <linux-xfs@vger.kernel.org>; Wed, 06 Nov 2019 10:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LEL2gSdUbe4aSh3PRMY+WG+viepjtitpPAPkTYVw+ZU=;
        b=ucHv9viP03W+1m3WIsyo45l5nsRY5dzAc+c0JladhGiy7QbTSflB4Um8LlfJEl3vnv
         /VPwtvWcFK8/y++FQqWFRa5QzyD52+eoguCOWe1Ys+/tnrQH61kGCuMQabTAOVwvQrJr
         Y3Cnsbm0vMqYm7ja05pKzWJA5+UXZUDbmqrxS3ZyIe3TA2gKF4ay/BGHayjmLI3223uC
         vawKGbVp/o/47ig6vL98cV/pAV9qTnpFa6EeTeWOVrtQel5eniJUv9kliyFCUl0Si9Kv
         EOlCQMQPyNLJkpONlfe7BPEIOEMGL1a6xxeeketp919DoD1KKXZp71rBj43dhqTEN+2i
         tESQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LEL2gSdUbe4aSh3PRMY+WG+viepjtitpPAPkTYVw+ZU=;
        b=mBSzOftaFB8OnrRwwLi2lWgIaWBTJxCXuCh9nh8ZKP6rl1LSX7TgjEECH5LADKVy66
         yOsX1VtpmgbFPII2nIfrvBTds2i8E7E+zZXm4QJleJ17DtSO3gNrjBSzkuTsK8Puxryy
         2vq+wzIIqt3UnR/zBaFzMs28UWfLPYW5QX9XqAKqg6AzE7ZBosUZEfBY3JqkY0+8DhDY
         af+/bYj2TAaKScQEF26glXeq1oOKFyQTjMVMKcaUrGfpOfZ5J+yruGMjPfb4eYRB4bWs
         tSMFXWDXEOufxs4PgTTAq1KLvqhBicQk0vN7KPJMPog6xAPT4Aa4WXFD0c686r2Gd9lF
         BVtw==
X-Gm-Message-State: APjAAAUF/cUbOmowSKtbFX89agEgj76/zEGVTqRi5hzK1+MOUJpi31pF
        5lOBu5GPI0GLVYFSfqOjQp21CNm9J+l0BPsck8M=
X-Google-Smtp-Source: APXvYqxHA87WLTEEY1OkSYE1t+15i2ARDh9ets/R1wq6Hu5AsgMwRsx1wGknFyaQ4QxUlsZ5ao4KeZCrpwTuEr7h2W8=
X-Received: by 2002:a25:a0d3:: with SMTP id i19mr3168848ybm.14.1573064999326;
 Wed, 06 Nov 2019 10:29:59 -0800 (PST)
MIME-Version: 1.0
References: <20191106055855.31517-1-amir73il@gmail.com> <20191106160139.GK4153244@magnolia>
In-Reply-To: <20191106160139.GK4153244@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 6 Nov 2019 20:29:48 +0200
Message-ID: <CAOQ4uxhg=44nShrnmVYAgCGMno4QaeAZKc5cW8bko-dVOd_Scw@mail.gmail.com>
Subject: Re: [PATCH] xfs_io/lsattr: expose FS_XFLAG_HASATTR flag
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 6, 2019 at 6:03 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Wed, Nov 06, 2019 at 07:58:55AM +0200, Amir Goldstein wrote:
> > For efficient check if file has xattrs.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  io/attr.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/io/attr.c b/io/attr.c
> > index b713d017..ba88ef16 100644
> > --- a/io/attr.c
> > +++ b/io/attr.c
> > @@ -37,6 +37,7 @@ static struct xflags {
> >       { FS_XFLAG_FILESTREAM,          "S", "filestream"       },
> >       { FS_XFLAG_DAX,                 "x", "dax"              },
> >       { FS_XFLAG_COWEXTSIZE,          "C", "cowextsize"       },
> > +     { FS_XFLAG_HASATTR,             "X", "has-xattr"        },
> >       { 0, NULL, NULL }
> >  };
> >  #define CHATTR_XFLAG_LIST    "r"/*p*/"iasAdtPneEfSxC"
>
> /me wonders if this should have /*X*/ commented out the same way we do
> for "p".

Sure. Eric, please let me know if you want a re-submit for this.

>
> Otherwise, the patch looks ok to me...
>
> /me *also* wonders how many filesystems fail to implement this flag but
> support xattrs.
>
> Oh.  All of them.  Though I assume overlayfs is being patched... :)
>

It doesn't need to be patched. It doesn't have xattr storage of its own.
The ioctl is passed down to the underlying fs (*).
(*) The ioctl is currently blocked on overlayfs directories.

Thanks,
Amir.

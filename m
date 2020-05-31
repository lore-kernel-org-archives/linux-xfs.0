Return-Path: <SRS0=JBSb=7N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500CEC433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 31 May 2020 14:04:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22BB120776
	for <linux-xfs@archiver.kernel.org>; Sun, 31 May 2020 14:04:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A4lwu0e2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgEaOEz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 May 2020 10:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgEaOEz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 May 2020 10:04:55 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB932C061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 31 May 2020 07:04:53 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id h4so975928iob.10
        for <linux-xfs@vger.kernel.org>; Sun, 31 May 2020 07:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5o6o1lZiB96O+6YjFvxxbCNRwjQA4Vho/jBvJk3UXC8=;
        b=A4lwu0e2kR5oSH3y2ijSKdijHvBd5Xlh0/Lm7DK1c7eI72am9VT42l+U4rkimuSbfU
         EvcFHwIBAUlaVCi1vjcy/4APZXPHQubeIKP6aaVfngvHayH+bT8tJQN81MfN0wVQtiBj
         Eu84k2f9eeEVTV7BBeC12fF7FbZEOEkxfhqCkGO+hqxd670VWB2BLOc5BJ3c396P9PWr
         MJar/VXBAyuXxXLjSoJ4l+Har7QQPQfBreQhzZHfmmqplLdDZ/pgtSts2SkYVsg1trMH
         kjEi/5ClvOCYV0o3cqu9z6dHyz7k/geRPCJ2C5haYp+69DKmanRwFODpIyLeTAcS0IXF
         NUig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5o6o1lZiB96O+6YjFvxxbCNRwjQA4Vho/jBvJk3UXC8=;
        b=WUL+XVeiWsiJ85LYoZHl/GIjkcbPS/nOwSnr8RZZoAobIiJ4KCUfOyvkOp9iLZ6mKl
         QVPTbhUqrpwtFtgLuw/Uf8P2DYPDFTqeZxjeCywcFD6L+PE6+n29XIeVk9Wv/GaMSQy9
         mXJWgvVugSzjOuwu6w6hpdGzFeCfehiZlyKHpkAFov/K/8vgVKz3yvBcsFwYdxhmMPL6
         C5F5jPxbzDbl4oHBsMUB6Hd+VVTpz57KkMPOZTcx4krrTB9P1UVa0JD8kgLvNLm3RjEP
         DDAEFZLL/f1WpzY8FsIpkkBm5+4ARCaFhF3qPHdPzluOSNU/XNpj4B9+aNU0z04GwoWT
         +sZg==
X-Gm-Message-State: AOAM5320uppw7gRLifGkD1N/HQArL6pLtWBLjv5BnT3uwB45Yri/fdhV
        dUghBmh/ofMpJnLXAqiNQ+4GYrNtr3srIa3lkvUnDA==
X-Google-Smtp-Source: ABdhPJzAqsLnse4O3icmrOiE/xH5V0iDR+yFcoQJzCIUJFbz/3o85/9Rzxb7QtyX2GkYCfsF3yXJyOuIeDDUfMGZ5Dg=
X-Received: by 2002:a02:85a5:: with SMTP id d34mr16184809jai.123.1590933893094;
 Sun, 31 May 2020 07:04:53 -0700 (PDT)
MIME-Version: 1.0
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <157784108138.1364230.6221331077843589601.stgit@magnolia> <b979d33d-361b-88cd-699c-7e5f1c621698@sandeen.net>
 <20200213014121.GX6870@magnolia>
In-Reply-To: <20200213014121.GX6870@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 31 May 2020 17:04:42 +0300
Message-ID: <CAOQ4uxiveTQu8_7UOvN07=P4o9hBBZTCyu4sSw5UpbrNPQL2pQ@mail.gmail.com>
Subject: Re: [PATCH 03/14] xfs: refactor quota exceeded test
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > >     } else {
> > > -           if ((!d->d_blk_softlimit || (be64_to_cpu(d->d_bcount) <= be64_to_cpu(d->d_blk_softlimit))) &&
> > > -               (!d->d_blk_hardlimit || (be64_to_cpu(d->d_bcount) <= be64_to_cpu(d->d_blk_hardlimit)))) {
> > > +           if (!over) {
> > >                     d->d_btimer = 0;
> > >             }
> >
> > I guess that could be
> >
> > >     } else if (!over) {
> > >             d->d_btimer = 0;
> > >     }
> >
> > ? but again *shrug* and that's beyond refactoring, isn't it.
>
> Strictly speaking, yes, but I think they're logically equivalent.
>

Of course they are.. chiming in to agree with Eric that else if
looks better after the nice cleanup.
But I won't stand in your way to keep the else { if {

Thanks,
Amir.

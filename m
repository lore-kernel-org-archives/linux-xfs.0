Return-Path: <SRS0=hCPB=2A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA01CC43603
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Dec 2019 11:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2322207FF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Dec 2019 11:55:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gt2NVgit"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfLJLzL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Dec 2019 06:55:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25544 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726956AbfLJLzK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Dec 2019 06:55:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575978908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qYfUbf5Vfugy/TmBKT6opYUanhHVUnjSWMfYpk0Dz6U=;
        b=Gt2NVgitZv5Ni2INZg9VI6EqjlLsGKK+b98oLLuErl+dSmtndURJEmp157JBrpghH7Ya3s
        OrVtjFSXLefzuNi84dlgJP7sGrpZYmCd1A/Vv3MFAqRMHZqs+5V74twn08N3MQdxZ2M3h1
        FsA6pSBmp0fGvkz4u7A/tk7aJL3Q4/A=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-YJaqFk0YMpa8nyq9PYidcQ-1; Tue, 10 Dec 2019 06:55:07 -0500
Received: by mail-vk1-f200.google.com with SMTP id z24so397019vkn.0
        for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2019 03:55:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=1LnhkzoJxSNI+ZNRtSLHT6IuKUF205kj8ENBDVaw7rs=;
        b=R5LrpAZNs3HzD+g0pZkwxLTlR6r6A7E46ywnHOc7XraOjfO7d7Xzbjq7AyAWBuNenC
         MQDUmCttXLMLKNuw0yjAeYLxBuTGzMb/uJNkSZBrL3Izemj5p+qgDNuO4+pVYy3VSzQl
         sWK4lMgSbc0daeYdgLw1jnS+bI2dAuhSNJGUPOhelvbfpnHhMQA58QllO/s1kgOhXrq9
         DNNxn1nF1eZU/P6Wlc8FIWPMreBLMaGf/nwcx6o9JXomqlrm43KzyAMFIAGryD1k1xZb
         iIfutvbJ/Eh7AL9U0xJQ/ZuSMhywRYegHo9Iy7mWiJds+7ZLsaQoGWT0bG707zs0yThC
         ocig==
X-Gm-Message-State: APjAAAWJmcVA2WPA4Kei9nz5zPvLii7TmGR7fVEQ9k2i061X5+t1hrGd
        ZghTld537jJ/zmjrGfH4cGq7nI9plWGiHZYqym5TNvXHXiAS9UZWugxkj18GiKcJNI++Lzdt4+w
        +YakYl7/QYVAFfom2u3bNQl351oq1ko+wtO+c
X-Received: by 2002:a9f:3209:: with SMTP id x9mr28860396uad.84.1575978907209;
        Tue, 10 Dec 2019 03:55:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqy6ylTD4Iyhi2cszb8byw0OkPmEoa/HO4Pmvl7WKtVg1afP6lvQCbvJJSm9VFdBDk844BEIvpPEGtp/0PKG3sk=
X-Received: by 2002:a9f:3209:: with SMTP id x9mr28860380uad.84.1575978906912;
 Tue, 10 Dec 2019 03:55:06 -0800 (PST)
MIME-Version: 1.0
References: <20191210114807.161927-1-preichl@redhat.com>
In-Reply-To: <20191210114807.161927-1-preichl@redhat.com>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Tue, 10 Dec 2019 12:54:55 +0100
Message-ID: <CAJc7PzUmJNNCcMXG3ywjfYvzO2+N3X8_2czjPU1vMKaV-F4Y3A@mail.gmail.com>
Subject: Re: [PATCH v4] mkfs: Break block discard into chunks of 2 GB
To:     linux-xfs@vger.kernel.org
X-MC-Unique: YJaqFk0YMpa8nyq9PYidcQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

what do you think about the way 'quiet' var is passed? It doesn't look
as natural parameter to 'discard_devices()' and ' discard_blocks' to
me. What do you think about making 'quiet' a global variable?
Thanks for opinions.

Bye.


On Tue, Dec 10, 2019 at 12:48 PM Pavel Reichl <preichl@redhat.com> wrote:
>
> Some users are not happy about the BLKDISCARD taking too long and at the =
same
> time not being informed about that - so they think that the command actua=
lly
> hung.
>
> This commit changes code so that progress reporting is possible and also =
typing
> the ^C will cancel the ongoing BLKDISCARD.
>
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
> Changelog:
>         V4: Limit the reporting about discarding to a single line
>
>  mkfs/xfs_mkfs.c | 50 ++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 37 insertions(+), 13 deletions(-)
>
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 18338a61..4bfdebf6 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1240,17 +1240,40 @@ done:
>  }
>
>  static void
> -discard_blocks(dev_t dev, uint64_t nsectors)
> +discard_blocks(dev_t dev, uint64_t nsectors, int quiet)
>  {
> -       int fd;
> +       int             fd;
> +       uint64_t        offset =3D 0;
> +       /* Discard the device 2G at a time */
> +       const uint64_t  step =3D 2ULL << 30;
> +       const uint64_t  count =3D BBTOB(nsectors);
>
> -       /*
> -        * We intentionally ignore errors from the discard ioctl.  It is
> -        * not necessary for the mkfs functionality but just an optimizat=
ion.
> -        */
>         fd =3D libxfs_device_to_fd(dev);
> -       if (fd > 0)
> -               platform_discard_blocks(fd, 0, nsectors << 9);
> +       if (fd <=3D 0)
> +               return;
> +       if (!quiet) {
> +               printf("Discarding blocks...");
> +               fflush(stdout);
> +       }
> +
> +       /* The block discarding happens in smaller batches so it can be
> +        * interrupted prematurely
> +        */
> +       while (offset < count) {
> +               uint64_t        tmp_step =3D min(step, count - offset);
> +
> +               /*
> +                * We intentionally ignore errors from the discard ioctl.=
 It is
> +                * not necessary for the mkfs functionality but just an
> +                * optimization. However we should stop on error.
> +                */
> +               if (platform_discard_blocks(fd, offset, tmp_step))
> +                       return;
> +
> +               offset +=3D tmp_step;
> +       }
> +       if (!quiet)
> +               printf("Done.\n");
>  }
>
>  static __attribute__((noreturn)) void
> @@ -2507,18 +2530,19 @@ open_devices(
>
>  static void
>  discard_devices(
> -       struct libxfs_xinit     *xi)
> +       struct libxfs_xinit     *xi,
> +       int                     quiet)
>  {
>         /*
>          * This function has to be called after libxfs has been initializ=
ed.
>          */
>
>         if (!xi->disfile)
> -               discard_blocks(xi->ddev, xi->dsize);
> +               discard_blocks(xi->ddev, xi->dsize, quiet);
>         if (xi->rtdev && !xi->risfile)
> -               discard_blocks(xi->rtdev, xi->rtsize);
> +               discard_blocks(xi->rtdev, xi->rtsize, quiet);
>         if (xi->logdev && xi->logdev !=3D xi->ddev && !xi->lisfile)
> -               discard_blocks(xi->logdev, xi->logBBsize);
> +               discard_blocks(xi->logdev, xi->logBBsize, quiet);
>  }
>
>  static void
> @@ -3749,7 +3773,7 @@ main(
>          * All values have been validated, discard the old device layout.
>          */
>         if (discard && !dry_run)
> -               discard_devices(&xi);
> +               discard_devices(&xi, quiet);
>
>         /*
>          * we need the libxfs buffer cache from here on in.
> --
> 2.23.0
>


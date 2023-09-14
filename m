Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85C0EEAA41
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Sep 2023 13:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239081AbjINNlB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Sep 2023 09:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239069AbjINNlA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Sep 2023 09:41:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 220D230DC
        for <linux-xfs@vger.kernel.org>; Thu, 14 Sep 2023 06:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694698758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xGHliAKjOveXPybvz3wXDjaFu5BVp6f2/0UhWex+mMY=;
        b=aRdRei9uEB81N+Wvz0Lyim6h45O6o6vgI80R9KP6Y9QgHwkuIAP1eAHg0NkB7kFgN8Th3c
        tfQ32D0d6bEluXQpd79zUVRp0/jfZrHqM8VW5/YSw783p8nIj8I1E7+paL+L2lHGHEIO9k
        OPnGK20kol0WVztIKBSyrfV19jke/DU=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-VE_AAB8KOjaBsG8PuoEfGw-1; Thu, 14 Sep 2023 09:39:16 -0400
X-MC-Unique: VE_AAB8KOjaBsG8PuoEfGw-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2ba1949656bso13231351fa.0
        for <linux-xfs@vger.kernel.org>; Thu, 14 Sep 2023 06:39:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694698754; x=1695303554;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xGHliAKjOveXPybvz3wXDjaFu5BVp6f2/0UhWex+mMY=;
        b=BAR+WX7tmTc0SSSBEGLiCmdyX4aOTVGyTZ2dqgPbF4x+Htr9+LVMm7mLH7IVt+9itE
         5IKArDO0YsedrdW4f+gK5UyOy5M8XT7lfuKvEXCCmexgHq6taPrLlgY85CZS2W76//D7
         ENcFF6gtZsIm5nC1XDP4E07h20hT756BgK1q8w2AiIVD4nutEmuJojN7NldVuuRP09wJ
         Ooo+cfMUIKSifOJg+wpwJ213KM5DWxpmVttPUlaAb0U9td3gCWOXHVrP7Kwcz0PmYXcy
         dtrUa2BFdNBUUrt3J+nvG79FjxAnlUIDYF8wgvDZfeDEiMFCBx46cmXFSbl5i1xMU/N7
         lE+Q==
X-Gm-Message-State: AOJu0Yw2pFyhXeovEPlGuTjgNxZmO1SHZbQ9dDNMusQXhIXhqH61eIJA
        xv0sH5IpuU748xNEVI5iopoJMZmcZT6efvhWBD5547sRYYlIQitgXvfyPpP2AI6MyaKLNuLPXY+
        fL1wY6dxXK8i2B0ygNP4S34IBIDI9k4zF3zGwXiNHV9xMv/M=
X-Received: by 2002:a2e:7407:0:b0:2bf:aba1:d951 with SMTP id p7-20020a2e7407000000b002bfaba1d951mr4774152ljc.10.1694698754499;
        Thu, 14 Sep 2023 06:39:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkyb645dg6WISgsy/QNkYR8limLjBXTaKi2ezZPkwrRQxLKFU1cQxQp7o8IRmXLqLczbYh20pvaq5NGj9l+/g=
X-Received: by 2002:a2e:7407:0:b0:2bf:aba1:d951 with SMTP id
 p7-20020a2e7407000000b002bfaba1d951mr4774138ljc.10.1694698754197; Thu, 14 Sep
 2023 06:39:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230914123640.79682-1-cem@kernel.org>
In-Reply-To: <20230914123640.79682-1-cem@kernel.org>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Thu, 14 Sep 2023 15:39:02 +0200
Message-ID: <CAJc7PzVLB43ck855sLjTOadUv1eza6KV_bXwXBTMhvbhZi97vA@mail.gmail.com>
Subject: Re: [PATCH] mkfs: Improve warning when AG size is a multiple of
 stripe width
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

LGTM

Signed-off-by: Pavel Reichl <preichl@redhat.com>


On Thu, Sep 14, 2023 at 2:38=E2=80=AFPM <cem@kernel.org> wrote:
>
> From: Carlos Maiolino <cmaiolino@redhat.com>
>
> The current output message prints out a suggestion of an AG size to be
> used in lieu of the user-defined one.
> The problem is this suggestion is printed in filesystem blocks, while
> agsize=3D option receives a size in bytes (or m, g).
>
> This patch tries to make user's life easier by outputing the suggesting
> in bytes directly.
>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index d3a15cf44..827d5b656 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3179,9 +3179,11 @@ _("agsize rounded to %lld, sunit =3D %d\n"),
>                 if (cli_opt_set(&dopts, D_AGCOUNT) ||
>                     cli_opt_set(&dopts, D_AGSIZE)) {
>                         printf(_(
> -"Warning: AG size is a multiple of stripe width.  This can cause perform=
ance\n\
> -problems by aligning all AGs on the same disk.  To avoid this, run mkfs =
with\n\
> -an AG size that is one stripe unit smaller or larger, for example %llu.\=
n"),
> +"Warning: AG size is a multiple of stripe width. This can cause performa=
nce\n\
> +problems by aligning all AGs on the same disk. To avoid this, run mkfs w=
ith\n\
> +an AG size that is one stripe unit smaller or larger,\n\
> +for example: agsize=3D%llu (%llu blks).\n"),
> +                               (unsigned long long)((cfg->agsize - dsuni=
t) * cfg->blocksize),
>                                 (unsigned long long)cfg->agsize - dsunit)=
;
>                         fflush(stdout);
>                         goto validate;
> --
> 2.39.2
>


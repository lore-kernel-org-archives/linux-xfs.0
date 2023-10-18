Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ADEBCDB47E
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Oct 2023 14:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345829AbjJROf1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 10:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235251AbjJROfJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 10:35:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DB9469D
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 07:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697639561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K+hIIyolcoAhu3WZDYJvpkd8XrLzwi17lqom2zgmM7I=;
        b=hw0/gsxz7Utr/tDjWTJke9E3ePjobw0wgtSZlwFElKpjYHO60sn0u1Bk2lTHJDDV3dMlEi
        EJ8ZipmSYMT5fSU+rBHo76/D6nCdV4wcWsabf37GZ/HRqzc2Etg+z0kBNH1KuQAjY1ZA/B
        ICqLvKkJaBnPgLTWtHyyM8AXDjzsylY=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-EuhMtsd2OH-2untG1FaNWQ-1; Wed, 18 Oct 2023 10:32:38 -0400
X-MC-Unique: EuhMtsd2OH-2untG1FaNWQ-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3b2e21c06f9so2208113b6e.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 07:32:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697639557; x=1698244357;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K+hIIyolcoAhu3WZDYJvpkd8XrLzwi17lqom2zgmM7I=;
        b=iwgeMqASvVqRdkYtCYG8tCKufzyR1H+kzomItYff3MvNgmfCx4Bd872TJHLRO6WPdN
         w8Eu9xpufi0OSDP8wPVHbkzEi+uh5sgTeuaVUwyWZOmUM1Qq44tnTG9lkxibAPeFLgtt
         zoR2+gYpCH6Lr/ShRII/8VRL/85kRkeOw3puSim7N5t4H4cDt7rtfqdsvCL5Ox2C0QgU
         Gp32nMk3e97kFuqoEkGIVbmzDjZA48gIJP3ALVWDnzW3jw6tFcvSdSSlUxIQaPXzZUYN
         RNwbZXP1HwbU3jOeDrfvhdWg/Lm7ctqczJo/tpw1VfX6lAcUuW2hR72vJ2+ONfHyvI2w
         yPag==
X-Gm-Message-State: AOJu0YxrFJegsluYJ+z70JweF3tEqlhq5iAo8+/V6lX6dzyYvrhzSvRN
        MqIFKhUVgRmoKD/58bEnrz6DUrqPO9t8MYZb+adXNG0gtodX1B8/lQ0ZoRRGJ1Rv3hI6Pbqe4Fq
        vkb1kGYZMEoPa20SnRPXJh2n4WZwSCChyZD7k
X-Received: by 2002:a05:6808:df3:b0:3a4:8251:5f43 with SMTP id g51-20020a0568080df300b003a482515f43mr5134032oic.40.1697639557740;
        Wed, 18 Oct 2023 07:32:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJZ0HVTUp+cKIoQPyPSp/EXlm6/WaNKSXxkPslSA2R5r3Bbt7OFS5yZTlg6c13Zt/RYoAUWjid9rbi0mzRUuU=
X-Received: by 2002:a05:6808:df3:b0:3a4:8251:5f43 with SMTP id
 g51-20020a0568080df300b003a482515f43mr5134021oic.40.1697639557500; Wed, 18
 Oct 2023 07:32:37 -0700 (PDT)
MIME-Version: 1.0
References: <8762e91a210f4cc5713fce05fe5906c18513bd0a.1697617238.git.jstancek@redhat.com>
 <20231018122220.GB10751@lst.de>
In-Reply-To: <20231018122220.GB10751@lst.de>
From:   Jan Stancek <jstancek@redhat.com>
Date:   Wed, 18 Oct 2023 16:32:19 +0200
Message-ID: <CAASaF6xHTv6iZd5ttHOJ_M=hpjaGZOnUCGSHkbGy_yLbe2G8nw@mail.gmail.com>
Subject: Re: [PATCH] iomap: fix short copy in iomap_write_iter()
To:     Christoph Hellwig <hch@lst.de>
Cc:     djwong@kernel.org, willy@infradead.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 18, 2023 at 2:22=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> On Wed, Oct 18, 2023 at 10:24:20AM +0200, Jan Stancek wrote:
> > Make next iteration retry with amount of bytes we managed to copy.
>
> The observation and logic fix look good.  But I wonder if simply
> using a goto instead of the extra variable would be a tad cleaner?
> Something like this?

Looks good to me. Would you be OK if I re-posted it as v2 with your
Signed-off-by added?


>
> ---
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 061f3d14c12001..2d491590795aa4 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -881,8 +881,10 @@ static loff_t iomap_write_iter(struct iomap_iter *it=
er, struct iov_iter *i)
>                 size_t bytes;           /* Bytes to write to folio */
>                 size_t copied;          /* Bytes copied from user */
>
> +               bytes =3D iov_iter_count(i);
> +retry:
>                 offset =3D pos & (chunk - 1);
> -               bytes =3D min(chunk - offset, iov_iter_count(i));
> +               bytes =3D min(chunk - offset, bytes);
>                 status =3D balance_dirty_pages_ratelimited_flags(mapping,
>                                                                bdp_flags)=
;
>                 if (unlikely(status))
> @@ -933,10 +935,12 @@ static loff_t iomap_write_iter(struct iomap_iter *i=
ter, struct iov_iter *i)
>                          * halfway through, might be a race with munmap,
>                          * might be severe memory pressure.
>                          */
> -                       if (copied)
> -                               bytes =3D copied;
>                         if (chunk > PAGE_SIZE)
>                                 chunk /=3D 2;
> +                       if (copied) {
> +                               bytes =3D copied;
> +                               goto retry;
> +                       }
>                 } else {
>                         pos +=3D status;
>                         written +=3D status;
>


Return-Path: <SRS0=qbJ3=ZP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10960C432C0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Nov 2019 07:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEC0E20719
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Nov 2019 07:08:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WmEEkVDK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfKWHIK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Nov 2019 02:08:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57778 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725973AbfKWHIJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 Nov 2019 02:08:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574492889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VCWLkvpBJLd7H/qwpMubjDPd8qthzH9oi2De95B4d6Y=;
        b=WmEEkVDKs/u/NUl6rfpJdQXV/5ffGCNqOZ4OE5hsg4iP0/bjn8a553loUuD+Y6vIREcb77
        AM3DiL2rkwrw8LNLxVXeWx/SOWqCIFQX4x6XWyIivUyC9TUD9YOpvRbN7xCoouudsuqyCf
        H4IwJvm3XAj/Rr6tteMeA3XAdKg/Mog=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-BLByVz22MyivKi_jLzoJrA-1; Sat, 23 Nov 2019 02:08:07 -0500
Received: by mail-vk1-f200.google.com with SMTP id i5so4022597vkg.21
        for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2019 23:08:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LvtviGT4niQ4FZf5+2XD/RmSjXNoAu/VqWvl+MDE9J8=;
        b=KLoPTGkYnvWr+RyeVzTFj4UBxdJvjwGIaYyzsq6AnlSKA6BsDpjFOQSZB9ZAlu62qR
         osBuEy15JmueNFg/GmPlGDF5wy2okaTq0zBKCi1u9pn0uHg4ogf+faRvdZNceimd44TF
         6fyY9FdWDYidf8P4QI56mePM6rIziFM15SzllGQp+p0HVhv1qGy9D8HDxyVOBfAwP+Gu
         AyyKW5a7ebyftBR8yNeuw7PH3k86Mg/GZk44uEAKkqR3XmsMLf+at3SEfi4xap5YNutI
         mz0AYJwpeyiS+SGQBGMVDudBF0F3KUwILiaNKnnSUQJe/9jLMPvshW8dKINCRHwJOAtA
         mUjw==
X-Gm-Message-State: APjAAAVFh9tf0/7s0D2n0+s78ZOc4oaPCJGxCw0H0CROpjdh6aVEdWF9
        /1/c9dT4MGMCCsyc3UwaBkvVvgFehnUVKksszkWgGSdnOEyDPt8hVY9JYZLVbSZVNLOVJwlyWcs
        vpZF1NuLXed+4/9hIUYJrY8hqe1AVKZDcoH2V
X-Received: by 2002:a05:6102:a17:: with SMTP id t23mr12470434vsa.121.1574492887138;
        Fri, 22 Nov 2019 23:08:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqz3frlKsRXqpfBIJJ25T9tWMXeWVlKNhO6sQbgke0cA5Or9XUeXxG2DVGGx6t54fFyuOGp1GJbB+GX6sPm/1P8=
X-Received: by 2002:a05:6102:a17:: with SMTP id t23mr12470429vsa.121.1574492886957;
 Fri, 22 Nov 2019 23:08:06 -0800 (PST)
MIME-Version: 1.0
References: <20191122213122.13327-1-jpittman@redhat.com>
In-Reply-To: <20191122213122.13327-1-jpittman@redhat.com>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Sat, 23 Nov 2019 08:07:54 +0100
Message-ID: <CAJc7PzWPv5UHMWb+twW6g8tWLCFX_6aRTaH6F3bXLsRmZxaZvQ@mail.gmail.com>
Subject: Re: [PATCH] xfsprogs: add missing carriage returns in libxfs/rdwr.c
To:     John Pittman <jpittman@redhat.com>
Cc:     Eric Sandeen <esandeen@redhat.com>, linux-xfs@vger.kernel.org
X-MC-Unique: BLByVz22MyivKi_jLzoJrA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 22, 2019 at 10:31 PM John Pittman <jpittman@redhat.com> wrote:
>
> In libxfs/rdwr.c, there are several fprintf() calls that are
> missing trailing carriage returns. This translates to the
> following CLI prompt being on the same line as the message.
> Add missing carriage returns, alleviating the issue.
>
> Fixes: 0a7942b38215 ("libxfs: don't discard dirty buffers")
> Signed-off-by: John Pittman <jpittman@redhat.com>
> ---
>  libxfs/rdwr.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 7080cd9c..3f69192d 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -651,7 +651,7 @@ __libxfs_getbufr(int blen)
>         pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
>         bp->b_ops =3D NULL;
>         if (bp->b_flags & LIBXFS_B_DIRTY)
> -               fprintf(stderr, "found dirty buffer (bulk) on free list!"=
);
> +               fprintf(stderr, "found dirty buffer (bulk) on free list!\=
n");
>
>         return bp;
>  }
> @@ -1224,7 +1224,7 @@ libxfs_brelse(
>                 return;
>         if (bp->b_flags & LIBXFS_B_DIRTY)
>                 fprintf(stderr,
> -                       "releasing dirty buffer to free list!");
> +                       "releasing dirty buffer to free list!\n");
>
>         pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
>         list_add(&bp->b_node.cn_mru, &xfs_buf_freelist.cm_list);
> @@ -1245,7 +1245,7 @@ libxfs_bulkrelse(
>         list_for_each_entry(bp, list, b_node.cn_mru) {
>                 if (bp->b_flags & LIBXFS_B_DIRTY)
>                         fprintf(stderr,
> -                               "releasing dirty buffer (bulk) to free li=
st!");
> +                               "releasing dirty buffer (bulk) to free li=
st!\n");
>                 count++;
>         }
>
> --
> 2.17.2
>

Hello John,

it seems to me that you are confusing carriage return (CR, \r) and
line feed (LF, \n) in the commit description. Could you check that
out, please? Otherwise it looks good to me.

Thanks.

Pave Reichl


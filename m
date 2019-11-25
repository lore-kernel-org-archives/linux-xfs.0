Return-Path: <SRS0=T9vs=ZR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EAC2C432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Nov 2019 18:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FAC820836
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Nov 2019 18:08:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CqkdKrdH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbfKYSIc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Nov 2019 13:08:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21133 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727722AbfKYSIc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Nov 2019 13:08:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574705311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w906B4jlQYQfALss72ECeRO6d5nMwMvOhJSEBp+Iub0=;
        b=CqkdKrdH9mfUkJC/A+papgMkW/tPEVIVaZyUr+IU/PfLT/WcWX3Smzyg12cdfNsrOmEKpP
        EY9Aa4rqS/RZlkyGLJq+VgTgZgP9TzbBlU/Dz/9ngEJQx/shw5L6QUDWWxZrW76F7LXn8W
        61ceTKVX4p3kZ5r1tJyx45q+FKTpjFU=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-3wmRe-LYPuS0MBuPVZty6g-1; Mon, 25 Nov 2019 13:08:29 -0500
Received: by mail-vs1-f69.google.com with SMTP id s67so2340276vsc.15
        for <linux-xfs@vger.kernel.org>; Mon, 25 Nov 2019 10:08:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XEE6pzya3lP0p6G9d0wno8xPfBD9PiwCEqVVJQwjalU=;
        b=GRxCKje3mV5HKlgtXyfbusOj3MjOR2lFrGD3C9SJznDAWAleeKgHaSOFHwiMxEgnMy
         Q53ERP44Y06BC2GbN3sucgiWmKzqwok521B9cqz63W1P0NXe4iLA2moeEOqTpgLl3QXu
         RYJWUc6u93eW/SVooEj0vSVqkNUqp/qP0G3nO2UFo9KU87qRh50vHLwEdNF0ms1Pt7xs
         QXp05LD+2x3568qYgmX3mpxAs318kybd76N0OToHZwvOnO/etwzOO4aO331B0ZELJDey
         oRNDixc/dcrVo4Qc2bebOCGJVKYfbg2exzgw5bbqWkQZBRXVypqeoylkvA0iqZQu2KZq
         8WEA==
X-Gm-Message-State: APjAAAXhmrIEsjZcjBmpXuqWR8H3I8DedasSWwCbQONX2QGaU65CawhI
        fgpM3/gMenkFDOZyyIN8cxfU6j2zjhvUUJI4S8OP8hLud+SjHMqlQpWs2j0XnYTkVmdqVEvY1E2
        J7gXJpR8PJbULHM9QvdqtKQ2YLG30zuTutN2X
X-Received: by 2002:a05:6102:a17:: with SMTP id t23mr19624548vsa.121.1574705309291;
        Mon, 25 Nov 2019 10:08:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqzE11Utgd3x11VnhnYHHeXOEo28z0P8CCHEZkVKSrvDB3TWME/Yl3pKNQk0vQHZoaQrDIn4HNuAZ2UaKKvoyjQ=
X-Received: by 2002:a05:6102:a17:: with SMTP id t23mr19624532vsa.121.1574705309019;
 Mon, 25 Nov 2019 10:08:29 -0800 (PST)
MIME-Version: 1.0
References: <20191123155508.15769-1-jpittman@redhat.com>
In-Reply-To: <20191123155508.15769-1-jpittman@redhat.com>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Mon, 25 Nov 2019 19:08:18 +0100
Message-ID: <CAJc7PzXpVN6p4AiWLKyrreCsB6BgdsGd3zy1J4JyMptCPCyqXQ@mail.gmail.com>
Subject: Re: [PATCH v3] xfsprogs: add missing line feeds in libxfs/rdwr.c
To:     John Pittman <jpittman@redhat.com>
Cc:     Eric Sandeen <esandeen@redhat.com>, linux-xfs@vger.kernel.org
X-MC-Unique: 3wmRe-LYPuS0MBuPVZty6g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 23, 2019 at 4:55 PM John Pittman <jpittman@redhat.com> wrote:
>
> In libxfs/rdwr.c, there are several fprintf() calls that are
> missing trailing line feeds. This translates to the following
> CLI prompt being on the same line as the message. Add missing
> line feeds, alleviating the issue.
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

Hi John,

thanks for the update.

 Reviewed-by: Pavel Reichl <preichl@redhat.com>


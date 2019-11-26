Return-Path: <SRS0=SRpQ=ZS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62655C432C0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 09:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 382A120727
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 09:33:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wv9tAt/2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfKZJdw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 04:33:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35202 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727275AbfKZJdw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Nov 2019 04:33:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574760831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2nSmjaiCeK0tPIUCWmMnr9+cGi/m2g3mz3niRE935j0=;
        b=Wv9tAt/2B2j+ugZlfo7qN/6ehHV9DVTqHw1qky801+9voFvLAqHYvUer2F+Ympa/YTir6N
        yWdEC6IhzdpsdWc5Hj9z1j5MKNmUzV/04BvmTd4ZJLlHqcu9pJ9WfRSoccmn2e6cqB6jlW
        PZQ3lrWfZgbzC3mcUCTqjss2i2KlnXg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-dU80S2_5PgyU2TNYcU4Ilw-1; Tue, 26 Nov 2019 04:33:48 -0500
Received: by mail-wr1-f69.google.com with SMTP id q13so108966wrx.16
        for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2019 01:33:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=D6zb3L7kfsY10hYEodHHwYnmsqmtJJOrV6yY9VQVz30=;
        b=INKE7lWbCX9RhBFN0oZNBMBS+1HeUkZu90l043hLN9/wCtxDnAdmb56r7WRU8bn24F
         9dAtvhET1SSHLf4Lbyrvy2/oZCkTrSBXMqmMxhkTCWgORorwpvt2+iLOLMiCtgZfdns/
         tnO4b6Gj42vaOw6op1buHNyncxfzX2WP7gXcYdl3SB1xy3oAkKGDP3v11XqQp+VPJ7cJ
         N83Q5saeEe6bwfJvyE2BAmXL3QjrW1LjoxVvedP7czexawoF/ZH03prbPB7s9ruOChZU
         UYL5DiGJf/VlcQPuzJeqjalhdFSzzdgrOrTQ2RjxYB2rQhWu03jjxCe8RwW3ySqP3wRx
         M5UQ==
X-Gm-Message-State: APjAAAW8kQ5FEJrFMqBA09BuAMvmCV2ze8OqZF3MuwfBa1f96L1xlrMz
        XH63tT2U0WQhkLqJ3QPwyEIzMDpBxHqy4C/rcFx4ohYOoI0UjSmEo/DBRcCBWgCVk2dAhBj/WOt
        XnQse+yJLp75FCMoCZIbN
X-Received: by 2002:adf:e301:: with SMTP id b1mr35538641wrj.280.1574760827270;
        Tue, 26 Nov 2019 01:33:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqxpSjd7YlMWEjGQCDnnNG+7uNpySYIgPwzGN6aS5A9Iqx8pKH5o7kqixdMtDi5sZaYz0ZZGwA==
X-Received: by 2002:adf:e301:: with SMTP id b1mr35538628wrj.280.1574760827081;
        Tue, 26 Nov 2019 01:33:47 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id x10sm14047170wrp.58.2019.11.26.01.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 01:33:46 -0800 (PST)
Date:   Tue, 26 Nov 2019 10:33:44 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     John Pittman <jpittman@redhat.com>
Cc:     esandeen@redhat.com, preichl@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfsprogs: add missing line feeds in libxfs/rdwr.c
Message-ID: <20191126093344.l43sriu2jm7gvqsq@orion>
Mail-Followup-To: John Pittman <jpittman@redhat.com>, esandeen@redhat.com,
        preichl@redhat.com, linux-xfs@vger.kernel.org
References: <20191123155508.15769-1-jpittman@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191123155508.15769-1-jpittman@redhat.com>
X-MC-Unique: dU80S2_5PgyU2TNYcU4Ilw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 23, 2019 at 10:55:08AM -0500, John Pittman wrote:
> In libxfs/rdwr.c, there are several fprintf() calls that are
> missing trailing line feeds. This translates to the following
> CLI prompt being on the same line as the message. Add missing
> line feeds, alleviating the issue.
>=20
> Fixes: 0a7942b38215 ("libxfs: don't discard dirty buffers")
> Signed-off-by: John Pittman <jpittman@redhat.com>

Despite my Reviewed-by previously, next patches, please don't forget to als=
o
provide the changelog for your Vx patches.

> ---

^ Changelogs should go below this line, so they are not propagated to the g=
it
tree, but it's really helpful to understand why you needed to send new vers=
ions.

Cheers.

>  libxfs/rdwr.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 7080cd9c..3f69192d 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -651,7 +651,7 @@ __libxfs_getbufr(int blen)
>  =09pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
>  =09bp->b_ops =3D NULL;
>  =09if (bp->b_flags & LIBXFS_B_DIRTY)
> -=09=09fprintf(stderr, "found dirty buffer (bulk) on free list!");
> +=09=09fprintf(stderr, "found dirty buffer (bulk) on free list!\n");
> =20
>  =09return bp;
>  }
> @@ -1224,7 +1224,7 @@ libxfs_brelse(
>  =09=09return;
>  =09if (bp->b_flags & LIBXFS_B_DIRTY)
>  =09=09fprintf(stderr,
> -=09=09=09"releasing dirty buffer to free list!");
> +=09=09=09"releasing dirty buffer to free list!\n");
> =20
>  =09pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
>  =09list_add(&bp->b_node.cn_mru, &xfs_buf_freelist.cm_list);
> @@ -1245,7 +1245,7 @@ libxfs_bulkrelse(
>  =09list_for_each_entry(bp, list, b_node.cn_mru) {
>  =09=09if (bp->b_flags & LIBXFS_B_DIRTY)
>  =09=09=09fprintf(stderr,
> -=09=09=09=09"releasing dirty buffer (bulk) to free list!");
> +=09=09=09=09"releasing dirty buffer (bulk) to free list!\n");
>  =09=09count++;
>  =09}
> =20
> --=20
> 2.17.2
>=20

--=20
Carlos


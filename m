Return-Path: <SRS0=SRpQ=ZS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CD9C432C0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 09:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86A1920862
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 09:31:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IA/LBZbJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfKZJb2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 04:31:28 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57078 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727150AbfKZJb1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Nov 2019 04:31:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574760686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lHEnMLB+9c2IehJ8rdWsEHWfnJvwt4anVFxbATOl4p8=;
        b=IA/LBZbJ8gDhfb6YUw+liDEAOhXi+V2elRfGcy3Cyi8bfEO72x/WecgDylyF+SVyloSJkW
        LBOEsLneNoxGfKjOhxBh3mKBWpIeXKivSRVBBE2GxOyrJYam9vm/aZIN5IQYSqvgUhIRrx
        fjh6nYd3AlEpv9Y+6+FqgcfWdlnBXbo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-0Ln7UvPzOIKlgGyVI1asPg-1; Tue, 26 Nov 2019 04:31:23 -0500
Received: by mail-wm1-f70.google.com with SMTP id y133so862894wmd.8
        for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2019 01:31:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=0wuoKFNt67j9c0UqZvY/VhCMXKK0Ig8xHNgCa727aE0=;
        b=Qp+CfKHKICx3rWYNjU9b6XwCSJ2t2B/4LdkE08qb762o9L2+2bEzKdCuEKOipB3PeF
         h2Y5N/VW0q1cDhn7uNnL6bUSnQ27ARFR4ryFbzFTPqq285+L7DBe5EzsQK44YRtHr9to
         lKVYEbioDn74mPgwTOrqCzLH3EdTRXdk63wKhDxsj/pxSPg3ExSlwAI5X4FJCFM/Fs7s
         OI3kaXg8M35yBknc8egLYZSHSSvSG/xZRZ+njpoIvgeIfaue0s90H1/w+OkRITTheD/q
         cdypttyGkAel9JClS9y+mzV5yK6tjs+ilEevvVUS1K1Vi6JgZIPjOYAPAC1cEDqnKiHF
         USiw==
X-Gm-Message-State: APjAAAXsVqWWgfcjVPpbFLIvJmxDwDKZcmmLLZ0juqJbOnFzB1o02g7A
        /Sdw/TLKgpJoSQYTkcKw51/wbdH2Q/fyuIWDMNjHbWFwpJyeMWbk8jLZ6/EHxfcXFMdTffb/qhA
        i/1mtCiTO/XwvhCZ4Clm3
X-Received: by 2002:a5d:5307:: with SMTP id e7mr20107719wrv.146.1574760682341;
        Tue, 26 Nov 2019 01:31:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqy56/ghC6e0gugKAu8LRcWEiTA886Fv9wzoEzwaHzsEJYDG/TG5gGSN68zaE7kWC3gT/xlF8g==
X-Received: by 2002:a5d:5307:: with SMTP id e7mr20107692wrv.146.1574760682091;
        Tue, 26 Nov 2019 01:31:22 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id c12sm13918665wro.96.2019.11.26.01.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 01:31:21 -0800 (PST)
Date:   Tue, 26 Nov 2019 10:31:18 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     John Pittman <jpittman@redhat.com>
Cc:     esandeen@redhat.com, preichl@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfsprogs: add missing line feeds in libxfs/rdwr.c
Message-ID: <20191126093118.opwguv6ol2aqec5m@orion>
Mail-Followup-To: John Pittman <jpittman@redhat.com>, esandeen@redhat.com,
        preichl@redhat.com, linux-xfs@vger.kernel.org
References: <20191123155508.15769-1-jpittman@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191123155508.15769-1-jpittman@redhat.com>
X-MC-Unique: 0Ln7UvPzOIKlgGyVI1asPg-1
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


Looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
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


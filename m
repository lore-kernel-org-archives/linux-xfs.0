Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB79BC433E2
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 21:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB55F206EF
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 21:48:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WkeyVDi3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbgICVsF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 17:48:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23284 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729371AbgICVsB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 17:48:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599169679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oBrynNccaVwKMAHtYaWvrpJ0iV4f205Vo+3SkjyLb1M=;
        b=WkeyVDi3uPoTBtLXVFs6s5fI46CSwjklz/r91HEZwaxiNm2bd3WYUorsEhLsgfE9/od9Zz
        1/BorK/dQYWgCxlajJE3fc703HQLVyFyKMFTWb8MksHup35m+u4U5AQgyRn4nBhxj/q+YB
        MglUjzR188eK8RA0vTq5GVvJvoEzGpY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-a8NKTWk1P-mHivU5NIYrAQ-1; Thu, 03 Sep 2020 17:47:57 -0400
X-MC-Unique: a8NKTWk1P-mHivU5NIYrAQ-1
Received: by mail-wr1-f71.google.com with SMTP id l17so1540593wrw.11
        for <linux-xfs@vger.kernel.org>; Thu, 03 Sep 2020 14:47:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oBrynNccaVwKMAHtYaWvrpJ0iV4f205Vo+3SkjyLb1M=;
        b=MOpHstAtmrYWP9QcFRMWAgcT6jDdFkYtFOpabhLuTVgz8iOvbemKM/jMjLqUoMTOSu
         8ulhQKXsbUuUSZ4TQ6YxbAshO4K6IyokGQgxkVdOQ/GsspapxqCg/MuTK+WMc1Mcd54r
         WoB3nPNNj2qYjQMUylyxiebnsi0cHvpCaNqfMd7QeAwWWk6clQsFpT66auBO0IuVmpxy
         rbI1KEdt+hxjWh60m3wsljwyT0hG+XRdePZ1rSUoUJoeA5oNc+NZgnNPiS2z5LBkvfyD
         YgKh1s0mBf4rBcdcJ7ogZVDbyf4cifujrE9BmU9Vxd567vxzIyDbo9eJYdTbdHpB/Sm5
         DiHA==
X-Gm-Message-State: AOAM533pqSZqu+D5ZogKzkVUZBxOHOCZUj0t/Badvi/U+Acsw5K4D9Dc
        3Gq7n/cjzUXZUrO/LipyKoWjnu5sL0ghMCfkzKmPbRrTaqNWOQcuk2NgjBZQQOlvW5JveQsQ7lA
        5D7eKjulZV1A85YOZt+dZXCLs8NjA4O/ugx0n
X-Received: by 2002:a7b:c0c5:: with SMTP id s5mr4395615wmh.152.1599169676210;
        Thu, 03 Sep 2020 14:47:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfurQNCgokDtRoLPRuHgAybZLnKZ8B+2PgntmWzIP1k1DncX3kyUDbDZW6vrGvGz+eL5DynJVwhOUzgUE9+X8=
X-Received: by 2002:a7b:c0c5:: with SMTP id s5mr4395604wmh.152.1599169676019;
 Thu, 03 Sep 2020 14:47:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200903165632.1338996-1-agruenba@redhat.com> <695a418c-ba6d-d3e9-f521-7dfa059764db@sandeen.net>
In-Reply-To: <695a418c-ba6d-d3e9-f521-7dfa059764db@sandeen.net>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Thu, 3 Sep 2020 23:47:44 +0200
Message-ID: <CAHc6FU5zwQTBaGVban6tCH7kNwr+NiW-_oKC1j0vmqbWAWx50g@mail.gmail.com>
Subject: Re: [PATCH] iomap: Fix direct I/O write consistency check
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 3, 2020 at 11:12 PM Eric Sandeen <sandeen@sandeen.net> wrote:
> On 9/3/20 11:56 AM, Andreas Gruenbacher wrote:
> > When a direct I/O write falls back to buffered I/O entirely, dio->size
> > will be 0 in iomap_dio_complete.  Function invalidate_inode_pages2_range
> > will try to invalidate the rest of the address space.
>
> (Because if ->size == 0 and offset == 0, then invalidating up to (0+0-1) will
> invalidate the entire range.)
>
>
>                 err = invalidate_inode_pages2_range(inode->i_mapping,
>                                 offset >> PAGE_SHIFT,
>                                 (offset + dio->size - 1) >> PAGE_SHIFT);
>
> so I guess this behavior is unique to writing to a hole at offset 0?
>
> FWIW, this same test yields the same results on ext3 when it falls back to
> buffered.

That's interesting. An ext3 formatted filesystem will invoke
dio_warn_stale_pagecache and thus log the error message, but the error
isn't immediately reported by the "pwrite 0 4k". It takes adding '-c
"fsync"' to the xfs_io command or similar to make it fail.

An ext4 formatted filesystem doesn't show any of these problems.

Thanks,
Andreas

> -Eric
>
> > If there are any
> > dirty pages in that range, the write will fail and a "Page cache
> > invalidation failure on direct I/O" error will be logged.
> >
> > On gfs2, this can be reproduced as follows:
> >
> >   xfs_io \
> >     -c "open -ft foo" -c "pwrite 4k 4k" -c "close" \
> >     -c "open -d foo" -c "pwrite 0 4k"
> >
> > Fix this by recognizing 0-length writes.
> >
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > ---
> >  fs/iomap/direct-io.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> > index c1aafb2ab990..c9d6b4eecdb7 100644
> > --- a/fs/iomap/direct-io.c
> > +++ b/fs/iomap/direct-io.c
> > @@ -108,7 +108,7 @@ static ssize_t iomap_dio_complete(struct iomap_dio *dio)
> >        * ->end_io() when necessary, otherwise a racing buffer read would cache
> >        * zeros from unwritten extents.
> >        */
> > -     if (!dio->error &&
> > +     if (!dio->error && dio->size &&
> >           (dio->flags & IOMAP_DIO_WRITE) && inode->i_mapping->nrpages) {
> >               int err;
> >               err = invalidate_inode_pages2_range(inode->i_mapping,
> >
>


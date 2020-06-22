Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B84C0C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 09:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89F6A206E2
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 09:08:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N1hluJ66"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgFVJIP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 05:08:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26841 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726618AbgFVJIP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 05:08:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592816893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RCKX5GS7JWN5V5e59N4MpanE/MlwLHSwobXRaeohnIs=;
        b=N1hluJ66vpcPSxGbzcySdZZdGmnnPFXD/tgjMgs3SgE9KLrpqcGt6mttIY8p0Pd42wwJGC
        98EMvSZghcNmQ6Z+yyWLcKY+BZ/zLlU3iru7E0zWyTrw4N1A9gVMzOxUdbUq9PAmfN/pnh
        x7oGwyCB23iNjaAcIbV0go3C8Hj2TSY=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-ejD8UXntN_aoANfWXQm6uQ-1; Mon, 22 Jun 2020 05:08:12 -0400
X-MC-Unique: ejD8UXntN_aoANfWXQm6uQ-1
Received: by mail-oo1-f70.google.com with SMTP id v9so8283774oov.1
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 02:08:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RCKX5GS7JWN5V5e59N4MpanE/MlwLHSwobXRaeohnIs=;
        b=aaBPc5DLbKhU8fjYWen+f9HiufRb5iOL+nzPy8/nTKPRv6/jtoclezsZmn5eGiH3Vu
         LPBji0X4vge4pjmh3V5p+1FzssWzxnUuiJXlyJhWaXvBXYzfP5Fo23VMtmjwhfB5xD5W
         fqQseZC6Wut455kxzqdw4U5DJpOJm7o5St7YF8OV63g7u9Y0TfzbyP1lMKhR/4VGl86c
         UyZz6sjWPk69iTGJPOd+/8f+SPzvSvt7cHM3Us1ZwvQMVSfPTi7RrDSI4kvXw8kxDVOI
         KVVbtgd4rOqjHlMdMW6jYn9NocdXzqXvGKEwSuC41z8KITlgf0rfvBUEJ+VG2wfJrAm/
         zdrw==
X-Gm-Message-State: AOAM533oBENFzfcRvpy9iASdyZKcH1VP9BV58hiVXAMJZ0g7m8M5nAi+
        GOrnmy5WEkM7IZfOWKHpfxb/FZVKArQRHEBAKKr/w8TISoLBJlhjjaUXJ8mt9jNdWz4qQIaZSyf
        aRqwxWborwpLlZYaUGbPLJOnoBz4aeKDAx0xX
X-Received: by 2002:aca:5049:: with SMTP id e70mr12026834oib.72.1592816891188;
        Mon, 22 Jun 2020 02:08:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyf1UlkS0QUbrHlpUEpl7yyMoJOq+l/zWCgfs0PQCmZvMH3Mzx49MdVcvg1uxxRhc751A7eZ3hkcs/YxKB3XPU=
X-Received: by 2002:aca:5049:: with SMTP id e70mr12026813oib.72.1592816890888;
 Mon, 22 Jun 2020 02:08:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200618122408.1054092-1-agruenba@redhat.com> <20200619131347.GA22412@infradead.org>
In-Reply-To: <20200619131347.GA22412@infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Mon, 22 Jun 2020 11:07:59 +0200
Message-ID: <CAHc6FU7uKUV-R+qJ9ifLAJkS6aPoG_6qWe7y7wJOb7EbWRL4dQ@mail.gmail.com>
Subject: Re: [PATCH v2] iomap: Make sure iomap_end is called after iomap_begin
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Bob Peterson <rpeterso@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 19, 2020 at 3:25 PM Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Jun 18, 2020 at 02:24:08PM +0200, Andreas Gruenbacher wrote:
> > Make sure iomap_end is always called when iomap_begin succeeds.
> >
> > Without this fix, iomap_end won't be called when a filesystem's
> > iomap_begin operation returns an invalid mapping, bypassing any
> > unlocking done in iomap_end.  With this fix, the unlocking would
> > at least still happen.
> >
> > This iomap_apply bug was found by Bob Peterson during code review.
> > It's unlikely that such iomap_begin bugs will survive to affect
> > users, so backporting this fix seems unnecessary.
> >
> > Fixes: ae259a9c8593 ("fs: introduce iomap infrastructure")
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > ---
> >  fs/iomap/apply.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/iomap/apply.c b/fs/iomap/apply.c
> > index 76925b40b5fd..32daf8cb411c 100644
> > --- a/fs/iomap/apply.c
> > +++ b/fs/iomap/apply.c
> > @@ -46,10 +46,11 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
> >       ret = ops->iomap_begin(inode, pos, length, flags, &iomap, &srcmap);
> >       if (ret)
> >               return ret;
> > -     if (WARN_ON(iomap.offset > pos))
> > -             return -EIO;
> > -     if (WARN_ON(iomap.length == 0))
> > -             return -EIO;
> > +     if (WARN_ON(iomap.offset > pos) ||
> > +         WARN_ON(iomap.length == 0)) {
> > +             written = -EIO;
> > +             goto out;
> > +     }
>
> As said before please don't merge these for no good reason.

I really didn't expect this tiny patch to require much discussion at
all, but just to be clear ... do you actually object to this very
patch that explicitly doesn't merge the two checks and keeps them on
two separate lines so that the warning messages will report different
line numbers, or are you fine with that?

Thanks,
Andreas


Return-Path: <SRS0=cXLJ=75=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD8EC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Jun 2020 13:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D222207C3
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Jun 2020 13:57:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OSaDlEdi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgFPN5Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Jun 2020 09:57:24 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21436 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726526AbgFPN5X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jun 2020 09:57:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592315842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mxL0md2vs9aP4NRN6scYuB5CiMGDrbZCWGjDCy0BQrw=;
        b=OSaDlEdipp7xjxXlZPC+rbkA5tcVKXTDmicrWlPaVCrBIO8Fjh0AEpI1Pzy29UhX6JY4OF
        m+BajCyzHhI+boOBq2Jt3Jls3bvNL6m+qTd27MURvMVewrSxV2kOMsvVjbb08dKESnMRj0
        SYXeBDLpxjeZ00CgxGQgJ3+TXB9iI3k=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-51ElOD7LNyaozG6lTwN4eQ-1; Tue, 16 Jun 2020 09:57:20 -0400
X-MC-Unique: 51ElOD7LNyaozG6lTwN4eQ-1
Received: by mail-oo1-f69.google.com with SMTP id e12so9706811oob.10
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2020 06:57:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mxL0md2vs9aP4NRN6scYuB5CiMGDrbZCWGjDCy0BQrw=;
        b=K6BHPO7KT9+b7TPWr1Gwg/5YdTc6ywq+Bhlm2NQ2ihGLih2hrCvxJVv/TJkU3t9+0q
         KkgMLFgYHtog5NG9rjZWocv2qEsp2FwJoIcdgujgjWOOSoWYLihRdZEKCxa0C9S7tkP/
         mHKbLt5q6awTb3QtZLWK4Gr3R7Mop9XkfSov5oHKTAczXxo00VRQfR0/lKDpib0gSNQv
         aj3y3SnPY3E04KnBF+l9bX6nulJYcrUq9qcWME4EiEnkGrpp43KczzJ/gxXxoPyxVhXP
         /sqpndHUT7yEbRQiALgG/HXfeD7F9QyDvGCrssYsbt1wvvO7aTZ7fXtGshNnVX+uRLKW
         AOEA==
X-Gm-Message-State: AOAM531ag9Kh0xjy3eJ78b8r96I6jJgsRUZCJrI0d/gewUDNFjy8xSYt
        sJ0Khy5vi7C5SK1J4r6n+hmQKHHquppbqQu7/y680tdO8FAaLdq2PsDJ2QnzsIvHrSEqw3Gu3mK
        WRAg+boeEipE8sq5IunwvnLYZVm+h9mxlzn/+
X-Received: by 2002:a9d:798c:: with SMTP id h12mr2490379otm.297.1592315839810;
        Tue, 16 Jun 2020 06:57:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2fk3/Mp9qtZPBw8lguU7HnnDH6p9/1XySC487M/O8qetk+5hVKpY6RDtmPOKgYMjal9GAhKQBddiRFTUcTQ4=
X-Received: by 2002:a9d:798c:: with SMTP id h12mr2490368otm.297.1592315839524;
 Tue, 16 Jun 2020 06:57:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200615160244.741244-1-agruenba@redhat.com> <20200615233239.GY2040@dread.disaster.area>
 <20200615234437.GX8681@bombadil.infradead.org> <20200616003903.GC2005@dread.disaster.area>
 <315900873.34076732.1592309848873.JavaMail.zimbra@redhat.com> <20200616132318.GZ8681@bombadil.infradead.org>
In-Reply-To: <20200616132318.GZ8681@bombadil.infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Tue, 16 Jun 2020 15:57:08 +0200
Message-ID: <CAHc6FU7uU8rUMdkspqH+Zv_O5zi2eEyOYF4x4Je-eCNeM+7NHA@mail.gmail.com>
Subject: Re: [PATCH] iomap: Make sure iomap_end is called after iomap_begin
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 16, 2020 at 3:23 PM Matthew Wilcox <willy@infradead.org> wrote:
> On Tue, Jun 16, 2020 at 08:17:28AM -0400, Bob Peterson wrote:
> > ----- Original Message -----
> > > > I'd assume Andreas is looking at converting a filesystem to use iomap,
> > > > since this problem only occurs for filesystems which have returned an
> > > > invalid extent.
> > >
> > > Well, I can assume it's gfs2, but you know what happens when you
> > > assume something....
> >
> > Yes, it's gfs2, which already has iomap. I found the bug while just browsing
> > the code: gfs2 takes a lock in the begin code. If there's an error,
> > however unlikely, the end code is never called, so we would never unlock.
> > It doesn't matter to me whether the error is -EIO because it's very unlikely
> > in the first place. I haven't looked back to see where the problem was
> > introduced, but I suspect it should be ported back to stable releases.
>
> It shouldn't just be "unlikely", it should be impossible.  This is the
> iomap code checking whether you've returned an extent which doesn't cover
> the range asked for.  I don't think it needs to be backported, and I'm
> pretty neutral on whether it needs to be applied.

Right, when these warnings trigger, the filesystem has already screwed
up; this fix only makes things less bad. Those kinds of issues are
very likely to be fixed long before the code hits users, so it
shouldn't be backported.

This bug was in iomap_apply right from the start, so:

Fixes: ae259a9c8593 ("fs: introduce iomap infrastructure")

Thanks,
Andreas


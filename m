Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB13C4363C
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 16:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3E12206FA
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 16:38:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fkj6Qg5Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388113AbgJBQi4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 12:38:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32059 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726017AbgJBQi4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 12:38:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601656734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=84z+VKDf92M5bqGxp5HR6C8cGmLvdQoEUZUF+fNU9M0=;
        b=fkj6Qg5Y4wK6MQaaa1ijbuJAoKo602Bu2a2UnEEYAq6yUpCk7XSVQO4u4+KbI5tSxJVCXr
        7jIoWAVwODysxzILUvvxAYqxT1h2m6ABDQ578QZxpK0vdQ6Jb/2orB/8Rtajl+h1W1zq3+
        rHpNZRUYUI6DMlzqD3rUhRZx1vPkGVE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-qUpNMzdfMNC5G3edKD1Ccw-1; Fri, 02 Oct 2020 12:38:50 -0400
X-MC-Unique: qUpNMzdfMNC5G3edKD1Ccw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1224188C12A;
        Fri,  2 Oct 2020 16:38:49 +0000 (UTC)
Received: from bfoster (ovpn-114-177.rdu2.redhat.com [10.10.114.177])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 48DF85C1DA;
        Fri,  2 Oct 2020 16:38:49 +0000 (UTC)
Date:   Fri, 2 Oct 2020 12:38:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: kick extra large ioends to completion workqueue
Message-ID: <20201002163847.GB4708@bfoster>
References: <20201002153357.56409-1-bfoster@redhat.com>
 <20201002153357.56409-3-bfoster@redhat.com>
 <20201002161923.GB49524@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002161923.GB49524@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 02, 2020 at 09:19:23AM -0700, Darrick J. Wong wrote:
> On Fri, Oct 02, 2020 at 11:33:57AM -0400, Brian Foster wrote:
> > We've had reports of soft lockup warnings in the iomap ioend
> > completion path due to very large bios and/or bio chains. Divert any
> > ioends with 256k or more pages to process to the workqueue so
> > completion occurs in non-atomic context and can reschedule to avoid
> > soft lockup warnings.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_aops.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 3e061ea99922..84ee917014f1 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -30,6 +30,13 @@ XFS_WPC(struct iomap_writepage_ctx *ctx)
> >  	return container_of(ctx, struct xfs_writepage_ctx, ctx);
> >  }
> >  
> > +/*
> > + * Kick extra large ioends off to the workqueue. Completion will process a lot
> > + * of pages for a large bio or bio chain and a non-atomic context is required to
> > + * reschedule and avoid soft lockup warnings.
> > + */
> > +#define XFS_LARGE_IOEND	(262144 << PAGE_SHIFT)
> 
> Hm, shouldn't that 262144 have to be annoated with a 'ULL' so that a
> dumb compiler won't turn that into a u32 and shift that all the way to
> zero?
> 

Probably.. will fix.

> I still kind of wonder about the letting the limit hit 16G on power with
> 64k pages, but I guess the number of pages we have to whack is ... not
> that high?
> 

TBH, the limit is kind of picked out of a hat since we don't have any
real data on the point where the page count becomes generally too high.
I originally was capping the size of the ioend, so for that I figured
1GB on 4k pages was conservative enough to still allow fairly large
ioends without doing too much page processing. This patch doesn't cap
the I/O size, so I suppose it might be more reasonable to reduce the
threshold if we wanted to. I don't really have a strong preference
either way. Hm?

> I dunno, if you fire up a 64k-page system with fantastical IO
> capabilities, attach a realtime volume, fallocate a 32G file and then
> try to write to that, will it actually turn that into one gigantic IO?
> 

Not sure, but one report we had was an x86_64 box pushing a 10GB+ bio
chain... :P

Brian

> > +
> >  /*
> >   * Fast and loose check if this write could update the on-disk inode size.
> >   */
> > @@ -239,7 +246,8 @@ static inline bool xfs_ioend_needs_workqueue(struct iomap_ioend *ioend)
> >  {
> >  	return ioend->io_private ||
> >  		ioend->io_type == IOMAP_UNWRITTEN ||
> > -		(ioend->io_flags & IOMAP_F_SHARED);
> > +		(ioend->io_flags & IOMAP_F_SHARED) ||
> > +		(ioend->io_size >= XFS_LARGE_IOEND);
> >  }
> >  
> >  STATIC void
> > -- 
> > 2.25.4
> > 
> 


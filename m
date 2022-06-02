Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D5AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jun 2022 15:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235996AbiFBPcf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jun 2022 11:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbiFBPce (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jun 2022 11:32:34 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1606BD94
        for <linux-xfs@vger.kernel.org>; Thu,  2 Jun 2022 08:32:33 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id hf10so3616801qtb.7
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jun 2022 08:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=351BGscnFb6fOiSLJ8JRSm8+B6M5wCDRVtIhnHMhJP0=;
        b=hN/tjVY+vS8gRaKCyfDLet9tX+ccqWSz7FSvrN9o4G0JF0LRx4SaplIHjrNRAtRnAV
         XTgvcJENORSj515U6SWsAm6BKmGLRL/98BmbY/BV0zfRaaH/PMa+DJ3e5bJrBZ8JH6gA
         jcKiXmE0bv5b5QirnX5CfMNvCLfjLCp2D85HmeEgmFxojGfQ1kKZrPhRQJAtrOd9QMWk
         KMrQryV0ZM6HAI0X4zuRGpeRc2877gof9dTDxwi9meLwqdnncTb2ULZcxEZrg9kCY7bg
         A9/rMxYrPTnhLt1zMTrxrI+tKS48rtbdYEWnOLp+zWR6I0es3MtranvilRvDEMvOjafp
         nQ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=351BGscnFb6fOiSLJ8JRSm8+B6M5wCDRVtIhnHMhJP0=;
        b=G6yLPm4Lnn+AeVpHpQyE1fUDvJvULVxdNK3ey9dQYJ5X1m05vWa64eogq8e7DqXRop
         F1aA/O+YuflCyRvN81dqvGY2fNnP9P9NklugGjLiFSx3D+5a5hVpI6CNYfQ3o6IJStuO
         s/fJJRdTHjAqf2PLNtq4D3z7z8k5XRgp5zN5APfZfzhjKI8C7m65J9TBBRKnfqQsR/FB
         3JZuPb8AS91QIbQtRf8SyYzA3odL6VGMhRmAOLHtstvvpIUWy8jmF2rDZsT4mIOUGJbt
         6LgSxF8wQaL13nboOcRdXDduTjcfKe0xVESGRHW0SfrCZ55Kj76RwzSXjZDooHysVRgm
         6ryA==
X-Gm-Message-State: AOAM530ZGyUvuvKeupzAPndQPPcma8jBRLdWyxIXZujOvj/Tg3kWf5w4
        CkCtFYNxj2inXpqeTgPij3curUFNsJG/Yg==
X-Google-Smtp-Source: ABdhPJwedKuk4vx7HanWkPD1ZPpgqYUWMWMFu0Q3HbQ4Dh8q+n8oK1SAymC0DbBh+5Hf7BB2gVgQEw==
X-Received: by 2002:ac8:5b84:0:b0:2f3:cba9:242d with SMTP id a4-20020ac85b84000000b002f3cba9242dmr4079685qta.260.1654183952165;
        Thu, 02 Jun 2022 08:32:32 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:1d66])
        by smtp.gmail.com with ESMTPSA id k4-20020a378804000000b006a5d2eb58b2sm3407092qkd.33.2022.06.02.08.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 08:32:31 -0700 (PDT)
Date:   Thu, 2 Jun 2022 11:32:30 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chris Mason <clm@fb.com>, Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "dchinner@redhat.com" <dchinner@redhat.com>
Subject: Re: [PATCH RFC] iomap: invalidate pages past eof in
 iomap_do_writepage()
Message-ID: <YpjYDjeR2Wpx3ImB@cmpxchg.org>
References: <20220601011116.495988-1-clm@fb.com>
 <YpdZKbrtXJJ9mWL7@infradead.org>
 <BB5F778F-BFE5-4CC9-94DE-3118C60E13B6@fb.com>
 <20220602065252.GD1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220602065252.GD1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 02, 2022 at 04:52:52PM +1000, Dave Chinner wrote:
> On Wed, Jun 01, 2022 at 02:13:42PM +0000, Chris Mason wrote:
> > In prod, bpftrace showed looping on a single inode inside a mysql
> > cgroup.  That inode was usually in the middle of being deleted,
> > i_size set to zero, but it still had 40-90 pages sitting in the
> > xarray waiting for truncation.  We’d loop through the whole call
> > path above over and over again, mostly because writepages() was
> > returning progress had been made on this one inode.  The
> > redirty_page_for_writepage() path does drop wbc->nr_to_write, so
> > the rest of the writepages machinery believes real work is being
> > done.  nr_to_write is LONG_MAX, so we’ve got a while to loop.
> 
> Yup, this code relies on truncate making progress to avoid looping
> forever. Truncate should only block on the page while it locks it
> and waits for writeback to complete, then it gets forcibly
> invalidated and removed from the page cache.

It's not looping forever, truncate can just take a relatively long
time during which the flusher is busy-spinning full bore on a
relatively small number of unflushable pages (range_cyclic).

But you raise a good point asking "why is truncate stuck?". I first
thought they might be cannibalizing each other over the page locks,
but that wasn't it (and wouldn't explain the clear asymmetry between
truncate and flusher). That leaves the waiting for writeback. I just
confirmed with tracing that that's exactly where truncate sits while
the flusher goes bananas on the same inode. So the race must be this:

truncate:                flusher
                         put a subset of pages under writeback
i_size_write(0)
wait_on_page_writeback()
                         loop with range_cyclic over remaining dirty >EOF pages

> Hence I think we can remove the redirtying completely - it's not
> needed and hasn't been for some time.
> 
> Further, I don't think we need to invalidate the folio, either. If
> it's beyond EOF, then it is because a truncate is in progress that
> means it is somebody else's problem to clean up. Hence we should
> leave it to the truncate to deal with, just like the pre-2013 code
> did....

Perfect, that works.

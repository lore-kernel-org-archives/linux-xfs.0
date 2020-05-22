Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F620C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 06:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F5B62073B
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 06:18:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T0QVshTG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgEVGSu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 02:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgEVGSu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 02:18:50 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13FD4C061A0E
        for <linux-xfs@vger.kernel.org>; Thu, 21 May 2020 23:18:49 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q8so8835955iow.7
        for <linux-xfs@vger.kernel.org>; Thu, 21 May 2020 23:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NcdpqzTDymq5TKODuTKefU8MFL+e10qtA8M10+0B9qk=;
        b=T0QVshTGZHkgeLPf5AO57imGlKVICWNHdu9mUF+BwWtOeNFQY+efp1v5IUc3oktk+Q
         YRl8RefGNrs4yw00EEmFOAjPnvZSBcMkfWCdpgh+E5Fz6wEEXeZ3ezchlHLFmSNrgb6e
         zssjEI6jGDMeIHdAHLHnx1m6cZWGQAA4jROrrDoy4XMyvzsfLz1lfle6eMqKSIbmVq9Z
         7OiZm9AAbWX2Yj5P7r4KgxGjOBg6ZgGPo7NNYlbkiuUB7kFY5kswy8JFzGyzVCdEZ1Qv
         TPAzN9B8YVtNaTHXfL8NAoT7xO2EF5IMHKy3q2JR2KSr+eg3CrmgDSwJtTgE1Ph4aA4H
         DSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NcdpqzTDymq5TKODuTKefU8MFL+e10qtA8M10+0B9qk=;
        b=WZJUB/ujoJ9metn5SYiTvGiYK14j8xZfiU0bTfneAVGzhe32ckudDo5hKy7bBJEX02
         BM2o1DXeMmEXYnELTTuh7mhUMZclIb7Rl7oZI0yxLy4QQjBb8hDVF0RE7Mhk2c95Un96
         rn0r2uYr2xAH8M4VIpheD07YcYyij1KvL+TJwF0oFmPyCKAEBfKgjnQqKVRXD8YiG4dD
         RUxMLn0q6F1h/1WoB/G6OrXA0qiIzhsKSq8xy781Mrb3K7YRwiYxhk/xlgWUVXW3EgYt
         /A3FrV2wveeSGbgbkc1qeQ56W2RzJ5g6wPJV/8OgMb4BqTIm4TK5r9Ud6QdoslbZCEsN
         CEvA==
X-Gm-Message-State: AOAM531tbzNInPQvQAWIFpBd+HXKVKSf5moyfYYDqghSkuPW3SE6frkO
        Hb7T1GwSgvU9ykYpTLj2g0NCVb18dGFttqjv/OB4CxSr
X-Google-Smtp-Source: ABdhPJynKZuJTAaapNmzoMRBDihMkF27ULfX1YFPc4Tr8qbs8ClSfw40qTqoCZb/s71H7nsUMyDV+lG3v5Cxo587O2I=
X-Received: by 2002:a02:b149:: with SMTP id s9mr6881396jah.81.1590128328026;
 Thu, 21 May 2020 23:18:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200522035029.3022405-1-david@fromorbit.com>
In-Reply-To: <20200522035029.3022405-1-david@fromorbit.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 22 May 2020 09:18:37 +0300
Message-ID: <CAOQ4uxhcwUV6056FejN+1XyEugSLp4qPF1KTp9+qpZeE0S8KKg@mail.gmail.com>
Subject: Re: [PATCH 00/24] xfs: rework inode flushing to make inode reclaim
 fully asynchronous
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 6:51 AM Dave Chinner <david@fromorbit.com> wrote:
>
> Hi folks,
>
> Inode flushing requires that we first lock an inode, then check it,
> then lock the underlying buffer, flush the inode to the buffer and
> finally add the inode to the buffer to be unlocked on IO completion.
> We then walk all the other cached inodes in the buffer range and
> optimistically lock and flush them to the buffer without blocking.
>
> This cluster write effectively repeats the same code we do with the
> initial inode, except now it has to special case that initial inode
> that is already locked. Hence we have multiple copies of very
> similar code, and it is a result of inode cluster flushing being
> based on a specific inode rather than grabbing the buffer and
> flushing all available inodes to it.
>
> The problem with this at the moment is that we we can't look up the
> buffer until we have guaranteed that an inode is held exclusively
> and it's not going away while we get the buffer through an imap
> lookup. Hence we are kinda stuck locking an inode before we can look
> up the buffer.
>
> This is also a result of inodes being detached from the cluster
> buffer except when IO is being done. This has the further problem
> that the cluster buffer can be reclaimed from memory and then the
> inode can be dirtied. At this point cleaning the inode requires a
> read-modify-write cycle on the cluster buffer. If we then are put
> under memory pressure, cleaning that dirty inode to reclaim it
> requires allocating memory for the cluster buffer and this leads to
> all sorts of problems.
>
> We used synchronous inode writeback in reclaim as a throttle that
> provided a forwards progress mechanism when RMW cycles were required
> to clean inodes. Async writeback of inodes (e.g. via the AIL) would
> immediately exhaust remaining memory reserves trying to allocate
> inode cluster after inode cluster. The synchronous writeback of an
> inode cluster allowed reclaim to release the inode cluster and have
> it freed almost immediately which could then be used to allocate the
> next inode cluster buffer. Hence the IO based throttling mechanism
> largely guaranteed forwards progress in inode reclaim. By removing
> the requirement for require memory allocation for inode writeback
> filesystem level, we can issue writeback asynchrnously and not have
> to worry about the memory exhaustion anymore.
>
> Another issue is that if we have slow disks, we can build up dirty
> inodes in memory that can then take hours for an operation like
> unmount to flush. A RMW cycle per inode on a slow RAID6 device can
> mean we only clean 50 inodes a second, and when there are hundreds
> of thousands of dirty inodes that need to be cleaned this can take a
> long time. PInning the cluster buffers will greatly speed up inode
> writeback on slow storage systems like this.
>
> These limitations all stem from the same source: inode writeback is
> inode centric, And they are largely solved by the same architectural
> change: make inode writeback cluster buffer centric.  This series is
> makes that architectural change.
>
> Firstly, we start by pinning the inode backing buffer in memory
> when an inode is marked dirty (i.e. when it is logged). By tracking
> the number of dirty inodes on a buffer as a counter rather than a
> flag, we avoid the problem of overlapping inode dirtying and buffer
> flushing racing to set/clear the dirty flag. Hence as long as there
> is a dirty inode in memory, the buffer will not be able to be
> reclaimed. We can safely do this inode cluster buffer lookup when we
> dirty an inode as we do not hold the buffer locked - we merely take
> a reference to it and then release it - and hence we don't cause any
> new lock order issues.
>
> When the inode is finally cleaned, the reference to the buffer can
> be removed from the inode log item and the buffer released. This is
> done from the inode completion callbacks that are attached to the
> buffer when the inode is flushed.
>
> Pinning the cluster buffer in this way immediately avoids the RMW
> problem in inode writeback and reclaim contexts by moving the memory
> allocation and the blocking buffer read into the transaction context
> that dirties the inode.  This inverts our dirty inode throttling
> mechanism - we now throttle the rate at which we can dirty inodes to
> rate at which we can allocate memory and read inode cluster buffers
> into memory rather than via throttling reclaim to rate at which we
> can clean dirty inodes.
>
> Hence if we are under memory pressure, we'll block on memory
> allocation when trying to dirty the referenced inode, rather than in
> the memory reclaim path where we are trying to clean unreferenced
> inodes to free memory.  Hence we no longer have to guarantee
> forwards progress in inode reclaim as we aren't doing memory
> allocation, and that means we can remove inode writeback from the
> XFS inode shrinker completely without changing the system tolerance
> for low memory operation.
>
> Tracking the buffers via the inode log item also allows us to
> completely rework the inode flushing mechanism. While the inode log
> item is in the AIL, it is safe for the AIL to access any member of
> the log item. Hence the AIL push mechanisms can access the buffer
> attached to the inode without first having to lock the inode.
>
> This means we can essentially lock the buffer directly and then
> call xfs_iflush_cluster() without first going through xfs_iflush()
> to find the buffer. Hence we can remove xfs_iflush() altogether,
> because the two places that call it - the inode item push code and
> inode reclaim - no longer need to flush inodes directly.
>
> This can be further optimised by attaching the inode to the cluster
> buffer when the inode is dirtied. i.e. when we add the buffer
> reference to the inode log item, we also attach the inode to the
> buffer for IO processing. This leads to the dirty inodes always
> being attached to the buffer and hence we no longer need to add them
> when we flush the inode and remove them when IO completes. Instead
> the inodes are attached when the node log item is dirtied, and
> removed when the inode log item is cleaned.
>
> With this structure in place, we no longer need to do
> lookups to find the dirty inodes in the cache to attach to the
> buffer in xfs_iflush_cluster() - they are already attached to the
> buffer. Hence when the AIL pushes an inode, we just grab the buffer
> from the log item, and then walk the buffer log item list to lock
> and flush the dirty inodes attached to the buffer.
>
> This greatly simplifies inode writeback, and removes another memory
> allocation from the inode writeback path (the array used for the
> radix tree gang lookup). And while the radix tree lookups are fast,
> walking the linked list of dirty inodes is faster.
>
> There is followup work I am doing that uses the inode cluster buffer
> as a replacement in the AIL for tracking dirty inodes. This part of
> the series is not ready yet as it has some intricate locking
> requirements. That is an optimisation, so I've left that out because
> solving the inode reclaim blocking problems is the important part of
> this work.
>
> In short, this series simplifies inode writeback and fixes the long
> standing inode reclaim blocking issues without requiring any changes
> to the memory reclaim infrastructure.
>
> Note: dquots should probably be converted to cluster flushing in a
> similar way, as they have many of the same issues as inode flushing.
>
> Thoughts,

Thank you for this wonderful write up!
Can't wait to deploy this on production machines :)

> comments

Since this is a "long standing issue" I am sure you have tests.
Can you please share the tests you used (simoop?) with some
encouraging performance numbers - flattening the stall curve ;-).

> and improvements

I wonder if the cluster buffer inode counter can be mixed as another
metric for choosing the best inodes to reclaim. If my math is correct
and depending on the specific system page/struct inode size,
reclaiming a cluster buffer with single dirty inode reclaims at least
1 page + 1 xfs_inode with low probability to free a slab page.
Reclaiming a cluster buffer with 8 dirty inodes reclaims at least
1 page + 8 xfs_inode with much higher probability to freeing one or two
slab pages (in the best case where adjacent inodes where allocated
consequently).

Thanks,
Amir.

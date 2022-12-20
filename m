Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F07AC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 04:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiLTEtO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 23:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiLTEtN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 23:49:13 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8C8CEE
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 20:49:12 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id a9so11106531pld.7
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 20:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G3Bdyp112uU+b78/29pjVQhwK0Ezv6wC3Ndyo7lWjsc=;
        b=MUmAV+vPWpKkgC0AO0yrcizFiElS3mNtObOOCSfqMegKS29PZ+k1lEMtw45bed1kOw
         wW36edgqKHFmbnCmVmubt9pDjRi/Ctpfzob5JJSmXxpDTyIQpDvf1OvfmfXolCt22wsN
         poIxvpXvdkLkq3A8FLHnZLGpTpLr54HnO0J2jcWnxprCK8DxbZYmyHuNVreQcwlcRSkq
         ijm4nZd2WyH/IfPO0mqBqBKIClNnM7JrDOHhUP8kUyyBXyKdp9Pb1IMeeixsg651nhzL
         fXicwg9CPeCRj2mAJysw40xaV6mTsqZH1LTKki4EKPTlt8BOM3oBtbkoqZRHkB4OE+kY
         URzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G3Bdyp112uU+b78/29pjVQhwK0Ezv6wC3Ndyo7lWjsc=;
        b=4Z+i9Vxarvwkn73lpTdl5o+vpJr+FpVtM36qHf7WAu9PJfXUInP2/KJF1+oUqwwCZX
         p3l/ROyYmlP8YBCQDDudEo/NcIkcF6tCbZpYWz8aggiaA5iDbNml8sSt0DTdnBSxnU0u
         cp7CKVWGEfGdiKwmaIm29j5W8j8TsO9v47t0JHYBjwCz9YwHCeHoCsj4v0d95OwBBGvw
         LFx37crjDl2ccZoRb/j12JnxDcLJxP0VXXTsvctYCaabzVQ6rDILn1YU7taTWQUwwbnO
         i2plWUyOnn41BhVKRKRt7VwdqwTvzeg/hcTxoEvhDYztQPI+lWc8VkpNaxop+Iscbqpb
         jvkA==
X-Gm-Message-State: ANoB5pmCwxXqL7jksADVGYq17FPzWY+41S5p8K1TJqpiGpBK1HuLIZ8Z
        /uvDPu2znlehnbuqIwSx6XwWRQ==
X-Google-Smtp-Source: AA0mqf6cWrna31yy4ciHZzhpmZpldFqO1/E9OGZyGzIrdJhmIUu3SFAcCpRudk0zNo9FI0Pt8Qm6fg==
X-Received: by 2002:a17:902:7b8b:b0:186:e434:6265 with SMTP id w11-20020a1709027b8b00b00186e4346265mr43515240pll.2.1671511751903;
        Mon, 19 Dec 2022 20:49:11 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id t6-20020a170902e84600b001871acf245csm8114351plg.37.2022.12.19.20.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 20:49:11 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p7UYu-00AZsP-Hm; Tue, 20 Dec 2022 15:49:08 +1100
Date:   Tue, 20 Dec 2022 15:49:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: don't stall background reclaim on inactvation
Message-ID: <20221220044908.GH1971568@dread.disaster.area>
References: <167149469744.336919.13748690081866673267.stgit@magnolia>
 <167149470870.336919.10695086693636688760.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167149470870.336919.10695086693636688760.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 19, 2022 at 04:05:08PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The online fsck stress tests deadlocked a test VM the other night.  The
> deadlock happened because:
> 
> 1. kswapd tried to prune the sb inode list, xfs found that it needed to
> inactivate an inode and that the queue was long enough that it should
> wait for the worker.  It was holding shrinker_rwsem.
> 
> 2. The inactivation worker allocated a transaction and then stalled
> trying to obtain the AGI buffer lock.
> 
> 3. An online repair function called unregister_shrinker while in
> transaction context and holding the AGI lock.  It also tried to grab
> shrinker_rwsem.
> 
> #3 shouldn't happen and was easily fixed, but seeing as we designed
> background inodegc to avoid stalling reclaim, I feel that #1 shouldn't
> be happening either.  Fix xfs_inodegc_want_flush_work to avoid stalling
> background reclaim on inode inactivation.

Yup, I see what you are saying, but I specifically left GFP_KERNEL
reclaim to throttle on inodegc if necessary.  kswapd runs in
GFP_KERNEL context - it's the only memory reclaim context where it
is actually safe to block in this manner in the filesystem. The
question becomes one of whether we allow kswapd to ignore inodegc
queue limits.

Before the background inodegc, we used to do all the xfs_inactive()
work in ->destroy_inode, directly from the VFS inode cache shrinker
context run by GFP_KERNEL memory reclaim contexts such as kswapd().
IOWs, causing kswapd to wait while we run inactivation in the VFS
inode cache shrinker context is something we've done for a long
time. kswapd did:

	vfs inode shrinker
	  destroy inode
	    xfs_inactive()
	    mark inode inactivated
	    update radix tree tags

And then the XFS inode shrinker walks INACTIVATED inodes and frees
them.

Now the code does:

	vfs inode shrinker
	  NEED_INACTIVE
	  -> inodegc queue
	     if (throttle needed)
		flush_work(gc->work);
	  return

Then some time later in a different context inodegc then runs and
we do:

	xfs_inactive
	INACTIVATED

And then sometime later in a different context the XFS inode
shrinker walks INACTIVATED inodes and frees them.

Essentially, without throttling the bulk of the memory freeing work
is shifted from the immediate GFP_KERNEL reclaim context to some
later GFP_KERNEL reclaim context.

For small memory reclaim scans (i.e. low priority shrinker
invocations) this doesn't matter - we aren't at risk of OOM in these
situations, and these are the typical situations in which memory
reclaim is needed. Generally speaking the the background work is
fast enough that memory is freed before shortages escalate.

However, when we have large inode caches and a significant memory
demand event, we get into the situation where reclaim might be
scanning a hundreds of thousands of cached VFS inodes at a time.

We kinda need to stall kswapd in these cases - it may be the only
reclaim context that can free inodes - and we need to avoid kswapd
dumping all the freeable inodes on the node to a queue that isn't
being processed, decided it has no more memory that can be freed
because all the VFS inodes have gone and there's nothing reclaimable
on the XFS inode lists, so it declares OOM when we have hundreds of
thousands of freeable inodes sitting there waiting for inodegc to
run.

I note that inodes queued for inodegc are not counted as reclaimable
XFS inodes, so for the purposes of shrinkers those inodes queued on
inodegc disappear from the shrinker accounting compeltely. Maybe we
could consider a separate bug hidden by the inodegc throttling -
maybe that's the bug that makes throttling kswapd on inodegc
necessary.

But this re-inforces my point - I don't think we can just make
kswapd skip inodegc throttling without further investion into the
effect on performance under memory pressure as well as OOM killer
resistance. It's likely a solvable issue, but given how complex and
subtle the inode shrinker interactions can be, I'd like to make sure
we don't wake a sleeping dragon here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

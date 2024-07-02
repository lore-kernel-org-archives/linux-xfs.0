Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E0079CC
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719899716; cv=none; b=B92MQn7TjYgZfYCzC8DHGYO0SNAn0m0WXZVYeWqdUIvtVWg6al/Nmpctf8j7/zjGnxKCLXKIcao6uWSGGzjXdl0Eo5H3h56RaU7To9ryqlJMvsgguOzVfNrGES7+bcZoFXcqmVRa1RD1z3PGtbamIZa3yRcPyCHZ721XSpLLwyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719899716; c=relaxed/simple;
	bh=yfGpAmUuZ/JzdJPBUzoc+k4evKWHlRekGFVQouPZ/s4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LiKNzitJjDhU+bdmw8UQggW0tltzLJsAOREYz90LTop7CN0AvDYqdHtDXqKKnBlOlLyKN5/13naDUUNzjrvDQiSuspiEHP2e0voNfMhjJHJdoEZz/hCC3eI7qpFDR5FTL3EvwPXK+8KCVZDnpeRkEx4t5OUmXS3+7By+0gVE8g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=eriWc7+N; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="eriWc7+N"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3d55e2e0327so2044895b6e.0
        for <linux-xfs@vger.kernel.org>; Mon, 01 Jul 2024 22:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1719899713; x=1720504513; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rmkheATIgV0EPHSlh+7AbFF8dPmUkG6VN5nv2fkaE3U=;
        b=eriWc7+NlEcMqIRFxiQTSd0O5dP+Ml7I7h5A29DPAabWAnR91q24fbbnH6gUmKA0uN
         GRdru7tNqeJ0l/PgjgzU+BuRWa5aCb0Mq51CGSZTZTsULRFdiGk3FB/Yx4DG29xFp+TG
         TEI5u+qXCvp4orr5xvjQHooyboxZ8fx/7hriomn9xlQcwqSGW0GrG6LLFF1+KTU3oZq+
         lL0AyCBxPw8t0SPrs1i6hd1X2SrGvbiHi/EXhlIbC35Jsq5jBDHYTY2Qne+KHNt0e9X6
         Qa6FR8jpbasVz6Yic5g2ldvX84HUkvUCuVtMavR/2iV+1BCQk5gQJdksP8pWzIX0Al/b
         m42Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719899713; x=1720504513;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rmkheATIgV0EPHSlh+7AbFF8dPmUkG6VN5nv2fkaE3U=;
        b=eoJ/xlhLpXY6BdioRalFhPG3OM9zWJaBZfE7f0Vuzl0YreFajVesBJFQFriuUMsBJi
         Ny+jgCyeAcv6oB63YE6RRQyh3T5NqaHZqd8c0IxCOGx/PvzNQjOJw9cmonFcb2DAQ+gw
         xTA3g1FrtDYfxWuJrwBAxTHqG05phFV5Pp3XHZqEk3kln8HaKc3wIz+SP3rWHLjkmAy2
         +L3pAmBXcX61J6oyWyaYltl9OZg6U9XDsGNaE6GcpLjCa7JJrTvtsQDPETO+hBSWBebR
         SIm+ObmytMSpeZhwyuOF9k1tySt52DSJWP6ftWmsl6RCJSDjYRpyQKirO83PSyyvBVWu
         MwVw==
X-Forwarded-Encrypted: i=1; AJvYcCWhOTx/sdEPv8XeT17Hsm/O7qI1BzukHVR3IgK9XmG6BdHjiblWkjEQfgcri7LaJ5HSKYaMwOpUZbC14ZL0ZRCV1aaOAsCvduPa
X-Gm-Message-State: AOJu0YwZ9SqzqrLbHyFZMNshTcAr2zYcg1BVJFDYs4ikAVst6gU7FPre
	nSImGD9G9sNACeFRI50ITsSoId5BTQPXnYO75WA3Hj2zvo59D3PrZwja78GFc0A=
X-Google-Smtp-Source: AGHT+IHO+SY1lPsx22bhXTxjoF9rc12IRcJ6e6RBMW6DYu0rPxhqZVKyeW0SpRsj7vAzXwaovFUXig==
X-Received: by 2002:a05:6808:1909:b0:3d5:6312:a017 with SMTP id 5614622812f47-3d6b32e5a46mr10244393b6e.29.1719899713463;
        Mon, 01 Jul 2024 22:55:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-708044b1112sm7566445b3a.182.2024.07.01.22.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 22:55:13 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sOWTu-001Adu-29;
	Tue, 02 Jul 2024 15:55:10 +1000
Date: Tue, 2 Jul 2024 15:55:10 +1000
From: Dave Chinner <david@fromorbit.com>
To: Long Li <leo.lilong@huawei.com>
Cc: willy@infradead.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS
Message-ID: <ZoOWPj2ICDIjCA80@dread.disaster.area>
References: <20240115230113.4080105-1-david@fromorbit.com>
 <20240115230113.4080105-8-david@fromorbit.com>
 <20240622094411.GA830005@ceph-admin>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240622094411.GA830005@ceph-admin>

On Sat, Jun 22, 2024 at 05:44:11PM +0800, Long Li wrote:
> On Tue, Jan 16, 2024 at 09:59:45AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > In the past we've had problems with lockdep false positives stemming
> > from inode locking occurring in memory reclaim contexts (e.g. from
> > superblock shrinkers). Lockdep doesn't know that inodes access from
> > above memory reclaim cannot be accessed from below memory reclaim
> > (and vice versa) but there has never been a good solution to solving
> > this problem with lockdep annotations.
> > 
> > This situation isn't unique to inode locks - buffers are also locked
> > above and below memory reclaim, and we have to maintain lock
> > ordering for them - and against inodes - appropriately. IOWs, the
> > same code paths and locks are taken both above and below memory
> > reclaim and so we always need to make sure the lock orders are
> > consistent. We are spared the lockdep problems this might cause
> > by the fact that semaphores and bit locks aren't covered by lockdep.
> > 
> > In general, this sort of lockdep false positive detection is cause
> > by code that runs GFP_KERNEL memory allocation with an actively
> > referenced inode locked. When it is run from a transaction, memory
> > allocation is automatically GFP_NOFS, so we don't have reclaim
> > recursion issues. So in the places where we do memory allocation
> > with inodes locked outside of a transaction, we have explicitly set
> > them to use GFP_NOFS allocations to prevent lockdep false positives
> > from being reported if the allocation dips into direct memory
> > reclaim.
> > 
> > More recently, __GFP_NOLOCKDEP was added to the memory allocation
> > flags to tell lockdep not to track that particular allocation for
> > the purposes of reclaim recursion detection. This is a much better
> > way of preventing false positives - it allows us to use GFP_KERNEL
> > context outside of transactions, and allows direct memory reclaim to
> > proceed normally without throwing out false positive deadlock
> > warnings.
> 
> Hi Dave,
> 
> I recently encountered the following AA deadlock lockdep warning
> in Linux-6.9.0. This version of the kernel has currently merged
> your patch set. I believe this is a lockdep false positive warning.

Yes, it is.

> The xfs_dir_lookup_args() function is in a non-transactional context
> and allocates memory with the __GFP_NOLOCKDEP flag in xfs_buf_alloc_pages().
> Even though __GFP_NOLOCKDEP can tell lockdep not to track that particular
> allocation for the purposes of reclaim recursion detection, it cannot
> completely replace __GFP_NOFS.

We are not trying to replace GFP_NOFS with __GFP_NOLOCKDEP. What we
are trying to do is annotate the allocation sites where lockdep
false positives will occur. That way if we get a lockdep report from
a location that uses __GFP_NOLOCKDEP, we know that it is either a
false positive or there is some nested allocation that did not honor
__GFP_NOLOCKDEP.

We've already fixed a bunch of nested allocations (e.g. kasan,
kmemleak, etc) to propagate the __GFP_NOLOCKDEP flag so they don't
generate false positives, either. So the amount of noise has already
been reduced.

> Getting trapped in direct memory reclaim
> maybe trigger the AA deadlock warning as shown below.

No, it can't. xfs_dir_lookup() can only lock referenced inodes.
xfs_reclaim_inodes_nr() can only lock unreferenced inodes. It is not
possible for the same inode to be both referenced and unreferenced
at the same time, therefore memory reclaim cannot self deadlock
through this path.

I expected to see some situations like this when getting rid of
GFP_NOFS (because now memory reclaim runs in places it never used
to). Once I have an idea of the sorts of false positives that are
still being tripped over, I can formulate a plan to eradicate them,
too.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

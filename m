Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A81C4167D
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 22:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjKHWGA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 17:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjKHWF7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 17:05:59 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C344258A
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 14:05:57 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-6c431b91b2aso161385b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 08 Nov 2023 14:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1699481156; x=1700085956; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BPrWruA3spy+o1hpuI+ZXmsqMhnVwk9rXY+leRYr2R8=;
        b=13lAb1vSiI/W2kR0t93Kro03cG5k15m07JmYZHfK6Rxkfkdq63BkjoEi8JGkjot430
         eqbVAoHGZb8BAXfbiGcVtjdCdQVETCvq5zVME5EGs6ifo8z/d3tpprq7GcO844dnqOpf
         K+VSg+C+U+hQgAeNB7nvs6Nu4Ymw3BmQt7x/RBnguYuDjrvYywWNuD2caXLNQTcaGta0
         NKYJvVrIVOnM2XAuG16eKaTLg/NS2/1Lx6vr9qmMXj7zctz+F4InF0vYnRKBugykzjiY
         +vo/mDPfg/1dd7BrWFvKX26WzU6NwHsYujpvrDwth9ZTCuaCuQu5Pzqh0XMDxUw7qS6a
         bk/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699481156; x=1700085956;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BPrWruA3spy+o1hpuI+ZXmsqMhnVwk9rXY+leRYr2R8=;
        b=NXPddWcsfS4cf40PU0/Mh22v5Jhv4XcQe8hf7UH7IisC/YBdfZ9jJttHHxMDt4HYtW
         mP6P50SmhExt7KszNvqVNhRw8imSg3YOL42c7Un8bf1EkfEt/Wmy4EwOoMaCYlRyMnVy
         bxt7Cbo2dQPjraNin3PA0YA95502uGfD1K2894HSbRM6Jm3k+ZyT7pGuLXlINpKNxKVt
         Frr9E+9KeQytLXkzJ1sLUT2lKN7B4Nc7Ae4hzVmdXzEkhjQFbNBNsTPVosxEVi0zINx3
         /nXUHeaUNP0NNm3fOVOzBCjOmW73M6wK8BrDFHVlbUw6pLm1vXj1wV7yDGupegkOdPbp
         kTnA==
X-Gm-Message-State: AOJu0YxgXHudQCESFL62+cHKbh9zINh+tOaneC38gd2W7Tctwb4YEdpC
        qg5vTV4a5EG2yGqfqZ/NaXLA5IwLNhIMQjSxrRA=
X-Google-Smtp-Source: AGHT+IEJ4U+M+96QlZ7uIPViNJaRdGqkravFWgJLaYzKV0ZJpP6oBLhYWQ9kr/wza2LzjCN00GOjTQ==
X-Received: by 2002:a05:6a20:9d8e:b0:181:2f76:f9f6 with SMTP id mu14-20020a056a209d8e00b001812f76f9f6mr3767249pzb.44.1699481156446;
        Wed, 08 Nov 2023 14:05:56 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902f7ca00b001bb892a7a67sm2197786plw.1.2023.11.08.14.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Nov 2023 14:05:55 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1r0qgK-00A315-0D;
        Thu, 09 Nov 2023 09:05:52 +1100
Date:   Thu, 9 Nov 2023 09:05:52 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Per =?iso-8859-1?Q?F=F6rlin?= <Per.Forlin@axis.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfsprogs: repair: Higher memory consumption when disable prefetch
Message-ID: <ZUwGQDBhtR4ZHtt+@dread.disaster.area>
References: <DU0PR02MB9824633F6B7AA1090D3D02A9EFA8A@DU0PR02MB9824.eurprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DU0PR02MB9824633F6B7AA1090D3D02A9EFA8A@DU0PR02MB9824.eurprd02.prod.outlook.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 08, 2023 at 03:56:00PM +0000, Per Förlin wrote:
> Hi Linux XFS community,
> 
> Please bare with me I'm new to XFS :)
> 
> I'm comparing how EXT4 and XFS behaves on systems with a relative
> small RAM vs storage ratio. The current focus is on FS repair memory consumption.
> 
> I have been running some tests using the max_mem_specified option.
> The "-m" (max_mem_specified) parameter does not guarantee success but it surely helps
> to reduce the memory load, in comparison to EXT4 this is an improvement.
> 
> My question concerns the relation between "-P" (disable prefetch) and "-m" (max_mem_specified).
> 
> There is a difference in xfs_repair memory consumption between the following commands
> 1. xfs_repair -P -m 500
> 2. xfs_repair -m 500
>
> 1) Exceeds the max_mem_specified limit
> 2) Stays below the max_mem_specified limit

Purely co-incidental, IMO.

As the man page says:

	-m maxmem

	      Specifies the approximate maximum amount of memory, in
	      megabytes, to use for xfs_repair.  xfs_repair has its
	      own  internal  block cache  which  will  scale  out
	      up to the lesser of the process’s virtual address
	      limit or about 75% of the system’s physical RAM.  This
	      option overrides these limits.

	      NOTE: These memory limits are only approximate and may
	      use more than the specified limit.

IOWs, behaviour is expected - the max_mem figure is just a starting
point guideline, and it only affects the size of the IO cache that
repair holds.  We still need lots of memory to index free space,
used space, inodes, hold directory information, etc, so memory usage
on any filesystem with enough metadata in it to fill the internal
buffer cache will always go over this number....

> I expected disabled prefetch to reduce the memory load but instead the result is the opposite.
> The two commands 1) and 2) are being executed in the same system.

> My speculation:
> Does the prefetch facilitate and improve the calculation of the memory
> consumption and make it more accurate?

No, prefetching changes the way processing of the metadata occurs.
It also vastly changes the way IO is done and the buffer cache is
populated.

e.g. prefetching looks at metadata density and issues
large IOs if the density is high enough and then chops them up into
individual metadata buffers in memory at prefetch IO completion.
This avoids doing lots of small IOs, greatly improving IO throughput
and keeping the processing pipeline busy.

This comes at the cost of increased CPU overhead and non-buffer
cache memory footprint, but for slow IO devices this can improve IO
throughput (and hence repair times) by a factor of up to 100x. Have
a look at the difference in IO patterns when you enable/disable
prefetching...

When prefetching is turned off, the processing issues individual IO
itself and doesn't do density-based scan optimisation. In some cases
this is faster (e.g. high speed SSDs) because it is more CPU
efficient, but it results in different IO patterns and buffer access
patterns.

The end result is that buffers have a very different life time when
prefetching is turned on compared to when it is off, and so there's
a very different buffer cache memory footprint between the two
options.

> Here follows output with -P and without -P from the same system.
> I have extracted the part the actually differs.
> The full logs are available the bottom of this email.
> 
> # -P -m 500 #
> Phase 3 - for each AG...
> ...
> Active entries = 12336
> Hash table size = 1549
> Hits = 1
> Misses = 224301
> Hit ratio =  0.00
> MRU 0 entries =  12335 ( 99%)
> MRU 1 entries =      0 (  0%)
> MRU 2 entries =      0 (  0%)
> MRU 3 entries =      0 (  0%)
> MRU 4 entries =      0 (  0%)
> MRU 5 entries =      0 (  0%)
> MRU 6 entries =      0 (  0%)
> MRU 7 entries =      0 (  0%)

Without prefetching, we have a single use for all buffers and the
metadata accessed is 20x larger than the size of the buffer cache
(220k vs 12k for the cache size).  This is just showing how the
non-prefetch case is just streaming buffers through the cache in
processing access order.

i.e. The MRU list indicates that nothing is being kept for long
periods or being accessed out of order as all buffers are on list 0
(most recently used). i.e. nothing is aging out and which means
buffers are being used and reclaimed in the same order they are
being instantiated.  If anything was being accessed out of order, we
would see buffers move down the aging lists....

> # -m 500 #
> Phase 3 - for each AG...
> ...
> Active entries = 12388
> Hash table size = 1549
> Hits = 220459
> Misses = 235388
> Hit ratio = 48.36

And there's the difference - two accesses per buffer for the
prefetch case. One for the IO dispatch to bring it into memory (the
miss) and one for processing (the hit).

> MRU 0 entries =      2 (  0%)
> MRU 1 entries =      0 (  0%)
> MRU 2 entries =   1362 ( 10%)
> MRU 3 entries =     68 (  0%)
> MRU 4 entries =     10 (  0%)
> MRU 5 entries =   6097 ( 49%)
> MRU 6 entries =   4752 ( 38%)
> MRU 7 entries =     96 (  0%)

And the MRU list shows how the buffer access are not uniform - we
are seeing buffers of all different ages in the cache. This shows
that buffers are being aged 5-6 times before they are getting used,
which means the cache size is almost too small for prefetch to work
effectively....

Actually, the cache is too small - cache misses are significantly
larger than cache hits, meaning some buffers are being fetched from
disk twice because the prefetched buffers are aging out before the
processing thread gets to them. Give xfs_repair ~5GB of RAM, and it
should only need to do a single IO pass in phase 3 and then phase 4
and 6 will hit the buffers in the cache and hence not need to do any
IO at all...

So to me, this is prefetch working as it should - it's bringing
buffers into cache in the optimal IO pattern rather than the
application level access pattern. The difference in memory footprint
compared to no prefetching is largely co-incidental and really not
something we are concerned about in any way...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

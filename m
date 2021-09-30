Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2226FC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Sep 2021 04:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E922C61350
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Sep 2021 04:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347962AbhI3Ens (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Sep 2021 00:43:48 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36294 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347942AbhI3Ens (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Sep 2021 00:43:48 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1A9951053529;
        Thu, 30 Sep 2021 14:42:03 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mVntS-000jJq-FD; Thu, 30 Sep 2021 14:42:02 +1000
Date:   Thu, 30 Sep 2021 14:42:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Rustam Kovhaev <rkovhaev@gmail.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        akpm@linux-foundation.org, vbabka@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] xfs: use kmem_cache_free() for kmem_cache objects
Message-ID: <20210930044202.GP2361455@dread.disaster.area>
References: <20210929212347.1139666-1-rkovhaev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929212347.1139666-1-rkovhaev@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=6155401c
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=pGLkceISAAAA:8 a=7-415B0cAAAA:8
        a=Wxa0iJoosyqG7NVgZfMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 29, 2021 at 02:23:47PM -0700, Rustam Kovhaev wrote:
> For kmalloc() allocations SLOB prepends the blocks with a 4-byte header,
> and it puts the size of the allocated blocks in that header.
> Blocks allocated with kmem_cache_alloc() allocations do not have that
> header.
> 
> SLOB explodes when you allocate memory with kmem_cache_alloc() and then
> try to free it with kfree() instead of kmem_cache_free().
> SLOB will assume that there is a header when there is none, read some
> garbage to size variable and corrupt the adjacent objects, which
> eventually leads to hang or panic.
> 
> Let's make XFS work with SLOB by using proper free function.
> 
> Fixes: 9749fee83f38 ("xfs: enable the xfs_defer mechanism to process extents to free")
> Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>

IOWs, XFS has been broken on SLOB for over 5 years and nobody
anywhere has noticed.

And we've just had a discussion where the very best solution was to
use kfree() on kmem_cache_alloc() objects so we didn't ahve to spend
CPU doing global type table lookups or use an extra 8 bytes of
memory per object to track the slab cache just so we could call
kmem_cache_free() with the correct slab cache.

But, of course, SLOB doesn't allow this and I was really tempted to
solve that by adding a Kconfig "depends on SLAB|SLUB" option so that
we don't have to care about SLOB not working.

However, as it turns out that XFS on SLOB has already been broken
for so long, maybe we should just not care about SLOB code and
seriously consider just adding a specific dependency on SLAB|SLUB...

Thoughts?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

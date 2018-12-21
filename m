Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:29589 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725837AbeLUV6g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Dec 2018 16:58:36 -0500
Date: Sat, 22 Dec 2018 08:58:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] iomap: Revert "fs/iomap.c: get/put the page in
 iomap_page_create/release()"
Message-ID: <20181221215832.GF4205@dastard>
References: <20181220122324.17082-1-david@fromorbit.com>
 <20181220174130.GA21065@lst.de>
 <20181220205342.GC4205@dastard>
 <CAHk-=wgdbrbV+jNUmhJ7KZsR77CY+pUF7EmtxP2mWKnE8ZyFSQ@mail.gmail.com>
 <20181221093919.GA2337@lst.de>
 <CAHk-=wjL7m3fLj1sVH91dcW51Qk4B9S7Q7OKf7dna6j+QoB5=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjL7m3fLj1sVH91dcW51Qk4B9S7Q7OKf7dna6j+QoB5=w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Piotr Jaroszynski <pjaroszynski@nvidia.com>, william.kucharski@oracle.com, stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Fri, Dec 21, 2018 at 11:18:35AM -0800, Linus Torvalds wrote:
> Dave,
>  any chance you can validate Christoph's patch and we could re-apply the fix?

Not for a few days - I'm out of the office until after xmas now.

I did notice the same bug in the original patch yesterday (and
mentioned it to Darrick on #xfs) when doing post-mortem analysis,
but I couldn't tell if that was the only problem all my test
machines were tied up testing that the revert didn't
introduce/uncover any new problems...

I'll test it as soon as I'm back around the office so we can get it
in -rc1 if there's no problems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60465 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389636AbeLUTU6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Dec 2018 14:20:58 -0500
Date: Fri, 21 Dec 2018 20:20:56 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] iomap: Revert "fs/iomap.c: get/put the page in
 iomap_page_create/release()"
Message-ID: <20181221192056.GA27640@lst.de>
References: <20181220122324.17082-1-david@fromorbit.com> <20181220174130.GA21065@lst.de> <20181220205342.GC4205@dastard> <CAHk-=wgdbrbV+jNUmhJ7KZsR77CY+pUF7EmtxP2mWKnE8ZyFSQ@mail.gmail.com> <20181221093919.GA2337@lst.de> <CAHk-=wjL7m3fLj1sVH91dcW51Qk4B9S7Q7OKf7dna6j+QoB5=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjL7m3fLj1sVH91dcW51Qk4B9S7Q7OKf7dna6j+QoB5=w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Piotr Jaroszynski <pjaroszynski@nvidia.com>, william.kucharski@oracle.com, stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Fri, Dec 21, 2018 at 11:18:35AM -0800, Linus Torvalds wrote:
> Dave,
>  any chance you can validate Christoph's patch and we could re-apply the fix?

I think Dave being in Australia is probably off to his well earned
weekend, like I should here in Europe now :)

Given that it took so long to find the original issue I think we should
not worry about 4.20 and just get the fix into 4.21-rc early and add it
to stable.

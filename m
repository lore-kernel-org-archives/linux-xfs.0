Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58080 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729941AbfGOQnW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 12:43:22 -0400
Date: Mon, 15 Jul 2019 09:43:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC 00/11] iomap: regroup code by functional area
Message-ID: <20190715164307.GA6176@magnolia>
References: <156200051933.1790352.5147420943973755350.stgit@magnolia>
 <20190708184652.GB20670@infradead.org>
 <20190709164952.GT1404256@magnolia>
 <20190709181214.GA31130@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709181214.GA31130@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Jul 09, 2019 at 11:12:14AM -0700, Christoph Hellwig wrote:
> I looked over it and while some of the small files seem very tiny
> they are reasonably split.
> 
> What rather annoys me is the page.c/read.c/write.c split.  All these
> really belong mostly together, except maybe the super highlevel
> write code that then either calls into the buffer_head vs iomap_page
> based code.  By keeping them together we can eliminate most of
> iomap_internal.h and once the writeback code moves also keep
> iomap_page private to that bigger read.c file.

<nod> I think it makes sense to combine them into a single read_write.c
file or something.

> 
> A few other minor notes:
> 
>  - I think iomap_sector() should move to linux/iomap.h as an inline
>    helper.

So long as you're ok with including blkdev.h from iomap.h. :)

>  - iomap_actor_t / iomap_apply should probaby just move to linux/iomap.h
>    as well, which would avoid needing the awkward subdir include in
>    dax.c

I'd also like to fix the opencoded iomap_apply() in fs/dax.c, but
cleaning all that up looks stressful enough to defer for 5.4.

>  - some of the copyrights for the small files seem totally wrong.
>    e.g. all the swapfile code was written by you, so it should not have
>    my or rh copyright notices on it

Will fix the swapfile code.

--D

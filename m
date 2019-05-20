Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:56905 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726424AbfETXch (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:32:37 -0400
Date: Tue, 21 May 2019 09:32:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/17] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190520233233.GF29573@dread.disaster.area>
References: <20190520161347.3044-1-hch@lst.de>
 <20190520161347.3044-15-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520161347.3044-15-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 06:13:44PM +0200, Christoph Hellwig wrote:
> The xfs_buf structure is basically used as a glorified container for
> a vmalloc allocation in the log recovery code.  Replace it with a
> real vmalloc implementation and just build bios directly as needed
> to read into or write from it to simplify things a bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I like the way the series runs in general, and the end result is a
fair bit neater, but I'm struggling to work out how we translate
this to the userspace code that uses uncached/raw buffer IO.

i.e. I'm in the process of porting the xfs_buf.c code to userspace,
and was using the uncached buffer API to provide the bits the
log code and other raw IO users (xfs_db, repair prefetch) with this
functionality through the API this patchset removes.

I wrote the patches a couple of days ago to move all this uncached
IO and kernel memory and device specific stuff to a xfs_buftarg.[ch]
files. This leaves xfs_buf.c as purely cached buffer management
code, has no bio stuff in it, no memory allocation, no shrinkers,
LRUs, etc).

So while it's easy to drop the uncached buffer API from the kernel
side, it leaves me with the question of what API do we use in
userspace to provide this same functionality? I suspect that we
probably need to separate all this log-to-bio code out into a
separate file (e.g. xfs_log_io.[ch]) to leave a set of API stubs
that we can reimplement in userspace to pread/pwrite directly to
the log buftarg device fd as I've done already for the buffer
code...

Thoughts?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

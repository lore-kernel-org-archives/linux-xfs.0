Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55020 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752344AbdIRP1I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Sep 2017 11:27:08 -0400
Date: Mon, 18 Sep 2017 17:27:06 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [linux-next][XFS][trinity] WARNING: CPU: 32 PID: 31369 at
        fs/iomap.c:993
Message-ID: <20170918152706.GA11482@lst.de>
References: <1505746565.6990.18.camel@abdul.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1505746565.6990.18.camel@abdul.in.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, chandan <chandan@linux.vnet.ibm.com>

On Mon, Sep 18, 2017 at 08:26:05PM +0530, Abdul Haleem wrote:
> Hi,
> 
> A warning is triggered from:
> 
> file fs/iomap.c in function iomap_dio_rw
> 
>     if (ret)
>         goto out_free_dio;
> 
>     ret = invalidate_inode_pages2_range(mapping,
>             start >> PAGE_SHIFT, end >> PAGE_SHIFT);
> >>  WARN_ON_ONCE(ret);
>     ret = 0;
> 
>     inode_dio_begin(inode);

This is expected and an indication of a problematic workload - which
may be triggered by a fuzzer.

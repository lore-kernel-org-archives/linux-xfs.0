Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60254 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfFQXao (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jun 2019 19:30:44 -0400
Date: Mon, 17 Jun 2019 16:30:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: use bios directly in the log code v4
Message-ID: <20190617233036.GQ3773859@magnolia>
References: <20190605191511.32695-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605191511.32695-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 05, 2019 at 09:14:47PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series switches the log writing and log recovery code to use bios
> directly, and remove various special cases from the buffer cache code.
> 
> A git tree is available here:
> 
>     git://git.infradead.org/users/hch/xfs.git xfs-log-bio
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-log-bio

I don't know if either (a) I'll find something in the other log cleanup
series to comment on or (b) if Dave has any further thoughts about
whatever it is he's doing with xfs_buf in userspace.  However, for
patches 1-15 and 17-24, I think this looks good enough for more
widespread testing, so...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Chances since v3:
>  - add a few additional cleanup patches
>  - clean up iclog allocation
>  - drop a not required vmap invalidation
>  - better document the iclog size fields
>  - fix vmap invalidation
> 
> Changes since v2:
>  - rename the 'flush' flag to 'need_flush'
>  - spelling fixes
>  - minor cleanups
> 
> Changes since v1:
>  - rebased to not required the log item series first
>  - split the bio-related code out of xfs_log_recover.c into a new file
>    to ease using xfs_log_recover.c in xfsprogs
>  - use kmem_alloc_large instead of vmalloc to allocate the buffer
>  - additional minor cleanups

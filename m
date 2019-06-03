Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53984 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbfFCRfV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 13:35:21 -0400
Date: Mon, 3 Jun 2019 10:35:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: use bios directly in the log code v2
Message-ID: <20190603173506.GC5390@magnolia>
References: <20190603172945.13819-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603172945.13819-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 07:29:25PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series switches the log writing and log recovery code to use bios
> directly, and remove various special cases from the buffer cache code.
> Note that I have developed it on top of the previous series of log item
> related cleanups, so if you don't have that applied there is a small

Hmm, /I/ don't have that applied. :/

Can you resend that series in its current form with (or without) all the
suggested review cleanups, please? :)

--D

> conflict.  To make life easier I have pushed out a git branche here:
> 
>     git://git.infradead.org/users/hch/xfs.git xfs-log-bio
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-log-bio
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

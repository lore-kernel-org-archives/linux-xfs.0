Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48010 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbfFQX5v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jun 2019 19:57:51 -0400
Date: Mon, 17 Jun 2019 16:57:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: misc log item related cleanups v2
Message-ID: <20190617235744.GR3773859@magnolia>
References: <20190613180300.30447-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613180300.30447-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 13, 2019 at 08:02:40PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> I've recently been trying to debug issue related to latencies related to
> locked buffers and went all over our log item lifecycles for that.
> 
> It turns out a lot of code in that area is rather obsfucated and
> redundant.  This series is almost entirely cleanups, but there are lots
> of it.  The only exception is a fix for systematic memory leaks which
> appears entirely theoretical.
> 
> Note that this series sits on top of the series titled
> "use bios directly in the log code v4".  To make everyones life easier
> a git tree is available here:
> 
>     git://git.infradead.org/users/hch/xfs.git xfs-log-item-cleanup
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-log-item-cleanup

Generally looks good enough for wider testing, so for patches 1-4 and 6-20...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> 
> Changes since v1:
>  - improve a few commit messages
>  - add various comments
>  - minor code style fixes
>  - drop the patch to remove iop_pushed from the quotaoff item
>  - set XFS_LI_ABORTED earlier in xfs_trans_committed_bulk

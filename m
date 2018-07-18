Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44570 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730403AbeGSAGC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jul 2018 20:06:02 -0400
Date: Wed, 18 Jul 2018 16:25:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: XFS long delays on disk full
Message-ID: <20180718232533.GC4813@magnolia>
References: <20180718212240.vxl33543lrh7vgzz@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180718212240.vxl33543lrh7vgzz@two.firstfloor.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 18, 2018 at 02:22:40PM -0700, Andi Kleen wrote:
> Hi,
> 
> I was doing some testing on a 4.18-rc1 kernel, and a single threaded
> test wrote a fairly large file to a XFS file system, causing it to
> fill up.
> 
> After that the process hung in D state for a long time, and only
> recovered after several minutes. Here's the backtrace during
> the hang:
> 
> [<0>] wb_wait_for_completion+0x5e/0x90
> [<0>] sync_inodes_sb+0xc9/0x290

Hmm, these two:

> [<0>] xfs_flush_inodes+0x25/0x30 [xfs]
> [<0>] xfs_file_buffered_aio_write+0x2be/0x300 [xfs]

Offhand I'd guess (while awayish at OSCON) that the fs hit ENOSPC while
trying to write() the file so now we're scanning the fs like mad trying
to free up space preallocations from any open file in the fs.

How big is the fs, how big is the file, how many inodes, how many are
open, which kernel?

--D

> [<0>] __vfs_write+0x114/0x1a0
> [<0>] vfs_write+0xad/0x1a0
> [<0>] ksys_write+0x52/0xc0
> [<0>] do_syscall_64+0x5b/0x160
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [<0>] 0xffffffffffffffff
> 
> There were no IO errors or similar.
> 
> Expected? Already fixed?
> 
> Thanks,
> -Andi
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

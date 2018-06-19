Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:43055 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S937124AbeFSCdU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jun 2018 22:33:20 -0400
Date: Tue, 19 Jun 2018 12:32:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: Assertion failed: !rwsem_is_locked(&inode->i_rwsem)
Message-ID: <20180619023246.GG19934@dastard>
References: <20180619021746.GA6652@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619021746.GA6652@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 18, 2018 at 08:17:46PM -0600, Ross Zwisler wrote:
> During some xfstest runs on next-20180615 I hit the following with DAX +
> generic/388:
> 
> ================================================
> WARNING: lock held when returning to user space!
> 4.17.0-next-20180615-00001-gf09d99951966 #2 Not tainted
> ------------------------------------------------
> fsstress/6598 is leaving the kernel with locks still held!
> 2 locks held by fsstress/6598:
>  #0: 00000000d8f89e14 (&sb->s_type->i_mutex_key#13){++++}, at: xfs_ilock+0x211/0x310
>  #1: 000000005cc93137 (&(&ip->i_mmaplock)->mr_lock){++++}, at: xfs_ilock+0x1eb/0x310

What errors occurred before this? generic/388 is testing all sorts
of error paths by randomly shutting down the filesystem, so it'e
entirely possible that we've leaked those locks (XFS_IOLOCK and
XFS_MMAPLOCK) on some rarely travelled error path. The prior errors
might help identify that path.

> XFS: Assertion failed: !rwsem_is_locked(&inode->i_rwsem), file: fs/xfs/xfs_super.c, line: 966

As this is just a follow on issue at unmount where we expect the
inode to be unlocked before tearing it down - it's just a messenger,
not the smoking gun...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

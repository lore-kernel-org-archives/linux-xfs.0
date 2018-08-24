Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:48392 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726935AbeHYDPv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Aug 2018 23:15:51 -0400
Date: Sat, 25 Aug 2018 09:39:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix GPF in swapfile_activate of file from overlayfs
Message-ID: <20180824233901.GA2234@dastard>
References: <1535101371-26461-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1535101371-26461-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Aug 24, 2018 at 12:02:51PM +0300, Amir Goldstein wrote:
> Since overlayfs implements stacked file operations, f_inode
> is no longer euqivalent to f_mapping->host and xfs should use
> the latter, same as generic_swapfile_activate().

Since when has file_inode() not pointed to the inode backing the
struct file?

> Using f_inode results in an attempt to dereference an xfs_inode
> struct from an ovl_inode pointer:
> 
>  CPU: 0 PID: 2462 Comm: swapon Not tainted
>  4.18.0-xfstests-12721-g33e17876ea4e #3402
>  RIP: 0010:xfs_find_bdev_for_inode+0x23/0x2f
>  Call Trace:
>   xfs_iomap_swapfile_activate+0x1f/0x43
>   __se_sys_swapon+0xb1a/0xee9
> 
> Fixes: d1d04ef8572b ("ovl: stack file ops")

Oh, since about 3 days ago.

So now we've got to deal with a vfs interface change that isn't
documented, hasn't been clearly communicated prior to merging, and
it subtly breaks a subset of callers.

So, please enlighten me with a documentation patch before changing
any XFS code: What is the new behaviour and the rules we must follow
for calling file_inode()?

I'm also interested in understanding whether anyone auditted all the
callers to see if they follow those rules.  There are another
20-odd file_inode() calls in XFS, and ~750 across fs/. How many
other places have been checked for correctness under the new rules?

i.e.  I can't review this patch without also confirming that all the
other file_inode() callers in XFS are still correct, and I can't do
that until I understand what the new behaviour of file_inode() is
and when it is not safe to use.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:60808 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751094AbeBHVNE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Feb 2018 16:13:04 -0500
Date: Fri, 9 Feb 2018 08:13:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs_io: support a basic extent swap command
Message-ID: <20180208211302.GE20266@dastard>
References: <20180208155719.17095-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180208155719.17095-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 08, 2018 at 10:57:19AM -0500, Brian Foster wrote:
> Extent swap is a low level mechanism exported by XFS to facilitate
> filesystem defragmentation. It is typically invoked by xfs_fsr under
> conditions that will atomically adjust inode extent state without
> loss of file data.
> 
> While xfs_fsr provides some debug capability to tailor its behavior,
> it is not flexible enough to facilitate low level tests of the
> extent swap mechanism. For example, xfs_fsr may skip swaps between
> inodes that consist solely of preallocated extents because it
> considers such files already 100% defragmented. Further, xfs_fsr
> copies data between files where doing so may be unnecessary and thus
> inefficient for lower level tests.
> 
> Add a basic swapext command to xfs_io that allows userspace
> invocation of the command under more controlled conditions. This
> facilites targeted tests without interference from xfs_fsr policy,
> such as using files with only preallocated extents, known/expected
> failure cases, etc. This command makes no effort to retain data
> across the operation. As such, it is for testing purposes only.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> v2:
> - Update xfs_io man page.
> - Fix up commit log description.
> v1: https://marc.info/?l=linux-xfs&m=151792224511355&w=2

Looks good. I'm no longer confused :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

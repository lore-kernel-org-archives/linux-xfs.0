Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37585 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751146AbdCPKHp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2017 06:07:45 -0400
Subject: Re: xfs: pass total block res. as total xfs_bmapi_write() parameter
References: <153397e1-ba41-20b3-455e-d622c234bc3a@gmail.com>
 <1489580654-29669-1-git-send-email-nborisov@suse.com>
From: Jiri Slaby <jslaby@suse.cz>
Message-ID: <862c1ff6-2d48-d059-4cc5-326927f440dd@suse.cz>
Date: Thu, 16 Mar 2017 11:07:41 +0100
MIME-Version: 1.0
In-Reply-To: <1489580654-29669-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>, stable@vger.kernel.org
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, david@fromorbit.com, Brian Foster <bfoster@redhat.com>

On 03/15/2017, 01:24 PM, Nikolay Borisov wrote:
> From: Brian Foster <bfoster@redhat.com>
> 
> The total field from struct xfs_alloc_arg is a bit of an unknown
> commodity. It is documented as the total block requirement for the
> transaction and is used in this manner from most call sites by virtue of
> passing the total block reservation of the transaction associated with
> an allocation. Several xfs_bmapi_write() callers pass hardcoded values
> of 0 or 1 for the total block requirement, which is a historical oddity
> without any clear reasoning.
> 
> The xfs_iomap_write_direct() caller, for example, passes 0 for the total
> block requirement. This has been determined to cause problems in the
> form of ABBA deadlocks of AGF buffers due to incorrect AG selection in
> the block allocator. Specifically, the xfs_alloc_space_available()
> function incorrectly selects an AG that doesn't actually have sufficient
> space for the allocation. This occurs because the args.total field is 0
> and thus the remaining free space check on the AG doesn't actually
> consider the size of the allocation request. This locks the AGF buffer,
> the allocation attempt proceeds and ultimately fails (in
> xfs_alloc_fix_minleft()), and xfs_alloc_vexent() moves on to the next
> AG. In turn, this can lead to incorrect AG locking order (if the
> allocator wraps around, attempting to lock AG 0 after acquiring AG N)
> and thus deadlock if racing with another operation. This problem has
> been reproduced via generic/299 on smallish (1GB) ramdisk test devices.
> 
> To avoid this problem, replace the undocumented hardcoded total
> parameters from the iomap and utility callers to pass the block
> reservation used for the associated transaction. This is consistent with
> other xfs_bmapi_write() callers throughout XFS. The assumption is that
> the total field allows the selection of an AG that can handle the entire
> operation rather than simply the allocation/range being requested (e.g.,
> resulting btree splits, etc.). This addresses the aforementioned
> generic/299 hang by ensuring AG selection only occurs when the
> allocation can be satisfied by the AG.
> 
> Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> Here is the backport for 3.12 

Applied, thanks!

-- 
js
suse labs

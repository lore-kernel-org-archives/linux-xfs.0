Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:52887 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388126AbfBNWQ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 17:16:29 -0500
Date: Fri, 15 Feb 2019 09:16:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: reserve blocks for ifree transaction during log
 recovery
Message-ID: <20190214221626.GX14116@dastard>
References: <155017109378.6016.17031057745821704893.stgit@magnolia>
 <155017110489.6016.15023654256490874855.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155017110489.6016.15023654256490874855.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Thu, Feb 14, 2019 at 11:05:04AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Log recovery frees all the inodes stored in the unlinked list, which can
> cause expansion of the free inode btree.  The ifree code skips block
> reservations if it thinks there's a per-AG space reservation, but we
> don't set up the reservation until after log recovery, which means that
> a finobt expansion blows up in xfs_trans_mod_sb when we exceed the
> transaction's block reservation.
> 
> To fix this, we set the "no finobt reservation" flag to true when we
> create the xfs_mount and only set it to false if we confirm that every
> AG had enough free space to put aside for the finobt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

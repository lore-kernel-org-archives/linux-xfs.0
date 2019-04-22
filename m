Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:57243 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728831AbfDVXU3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Apr 2019 19:20:29 -0400
Date: Tue, 23 Apr 2019 09:20:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: unlock inode when xfs_ioctl_setattr_get_trans can't
 get transaction
Message-ID: <20190422232025.GZ29573@dread.disaster.area>
References: <20190422182541.GA4676@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190422182541.GA4676@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Mon, Apr 22, 2019 at 11:25:41AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We passed an inode into xfs_ioctl_setattr_get_trans with join_flags
> indicating which locks are held on that inode.  If we can't allocate a
> transaction then we need to unlock the inode before we bail out, like
> all the other error paths do.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Yup, that's a problem, and the function header comment says "we now
take full responsibility for unlocking the inode" so this looks
fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

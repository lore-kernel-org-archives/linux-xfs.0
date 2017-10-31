Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11015 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752319AbdJaXO7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 19:14:59 -0400
Date: Wed, 1 Nov 2017 10:14:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: remove inode log format typedef
Message-ID: <20171031231449.GH5858@dastard>
References: <20171031193026.GF4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031193026.GF4911@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Tue, Oct 31, 2017 at 12:30:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove xfs_inode_log_format_t now that xfs_inode_log_format is
> explicitly padded and therefore is a real on-disk structure.  This
> enables xfs/122 to check the size of the structure.
> 
> (No functional changes, this is for benefit of xfsprogs)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

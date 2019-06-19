Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:52283 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726023AbfFSAln (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 20:41:43 -0400
Date: Wed, 19 Jun 2019 10:40:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: move xfs_ino_geometry to xfs_mount.h
Message-ID: <20190619004041.GA26375@dread.disaster.area>
References: <20190618205935.GS5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618205935.GS5387@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Tue, Jun 18, 2019 at 01:59:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The inode geometry structure isn't related to ondisk format; it's
> support for the mount structure.  Move it to xfs_mount.h.

That means we have to duplicate it in userspace - xfs_mount.h is not
shared. I'd suggest that libxfs/xfs_shared.h would be a better place
for it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

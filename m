Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27106 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933336AbdKAWuZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 18:50:25 -0400
Date: Wed, 1 Nov 2017 15:50:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs: account for per-AG reservation in statfs
 f_blocks
Message-ID: <20171101225021.GM4911@magnolia>
References: <20171101211642.GK4911@magnolia>
 <20171101214250.GS5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171101214250.GS5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Thu, Nov 02, 2017 at 08:42:50AM +1100, Dave Chinner wrote:
> On Wed, Nov 01, 2017 at 02:16:42PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Since the blocks reserved by the per-AG reservation mechanism are never
> > available to userspace, there's no point in reporting them via statfs.
> > Reduce the number of blocks reported by statfs so our space accounting
> > works the way it did in the old days -- f_blocks is the theoretical
> > upper bound on the amount of space that user programs could allocate,
> > and f_blocks is the current maximum.
> > 
> > This eliminates the regression where you format a 100T XFS and df
> > reports 2T are already "used".  Now it reports that you have a 98T
> > filesystem.
> > 
> > (Dave's thinp rfc might very well fix this whole problem; this is
> > purely a bandaid to shut down the complaints.)
> 
> Yes, it does. These two patches from the series can stand alone,
> though I've renamed the variables I used as a result of discussion
> with Brian and Amir. If you want to take these instead, I'll post my
> updated patches for you:
> 
> https://www.spinics.net/lists/linux-xfs/msg12211.html
> https://www.spinics.net/lists/linux-xfs/msg12215.html

Sure, please send along whatever the latest version looks like.

m_LBA_size -> m_total_size -> m_fs_addr_space etc. :)

FWIW I already took the patch that converts the remaining hasFOO
helper functions.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

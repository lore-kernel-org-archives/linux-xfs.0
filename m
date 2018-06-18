Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:25544 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754549AbeFRD4R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Jun 2018 23:56:17 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fUlH5-0003as-9W
        for linux-xfs@vger.kernel.org; Mon, 18 Jun 2018 13:56:15 +1000
Date: Mon, 18 Jun 2018 13:56:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: symlinks can be zero length during log recovery
Message-ID: <20180618035615.GD19934@dastard>
References: <20180615014314.27574-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180615014314.27574-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Fri, Jun 15, 2018 at 11:43:14AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> A log recovery failure has been reproduced where a symlink inode has
> a zero length in extent form. It was caused by a shutdown during a
> combined fstress+fsmark workload.
> 
> To fix it, we have to allow zero length symlink inodes through
> xfs_dinode_verify() during log recovery. We already specifically
> check and allow this case in the shortform symlink fork verifier,
> but in this case we don't get that far, and the inode is not in
> shortform format.
> 
> Update the dinode verifier to handle this case, and change the
> symlink fork verifier to only allow this case to exist during log
> recovery.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Self-NAK on this - I've got a patch that prevents zero length
symlinks from going to disk, so allowing them through log recovery
is not necessary - they are always invalid.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

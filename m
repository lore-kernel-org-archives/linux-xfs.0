Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39020 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752129AbeC0XuH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 19:50:07 -0400
Date: Tue, 27 Mar 2018 16:50:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/20] xfs: halt auto-reclamation activities while
 rebuilding rmap
Message-ID: <20180327235002.GK4818@magnolia>
References: <152210855435.13184.6475770131389744177.stgit@magnolia>
 <152210859201.13184.1114348565922103.stgit@magnolia>
 <20180327231509.GX18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180327231509.GX18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 28, 2018 at 10:15:09AM +1100, Dave Chinner wrote:
> On Mon, Mar 26, 2018 at 04:56:32PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Rebuilding the reverse-mapping tree requires us to quiesce all inodes in
> > the filesystem, so we must stop background reclamation of post-EOF and
> > CoW prealloc blocks.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We also do the same thing during remount and unmount, so these
> helpers should be used in those places, too.
> 
> And, thinking about it - if the filesystem is frozen then we should
> also be cancelling this background work and re-enabling it on
> thaw. Seems like we've missed that altogether...

Yeah, I was wondering about whether these reclaim bits could fire up on
a frozen filesystem.  I'll try toggling reclaim during freeze/umount a
shot, which means we won't have to do it in the rmapbt repair patch.

--D

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

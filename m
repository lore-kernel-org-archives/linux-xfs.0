Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30126 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbdJDXMf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Oct 2017 19:12:35 -0400
Date: Wed, 4 Oct 2017 16:12:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/25] xfs: scrub the AGI
Message-ID: <20171004231232.GA7122@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706331918.19351.1010060377239825093.stgit@magnolia>
 <20171004014347.GX3666@dastard>
 <20171004042501.GO6503@magnolia>
 <20171004064333.GD3666@dastard>
 <20171004180204.GU6503@magnolia>
 <20171004221634.GG3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171004221634.GG3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 05, 2017 at 09:16:34AM +1100, Dave Chinner wrote:
> On Wed, Oct 04, 2017 at 11:02:04AM -0700, Darrick J. Wong wrote:
> > On Wed, Oct 04, 2017 at 05:43:33PM +1100, Dave Chinner wrote:
> > > It seems to me that we're using the superblock 0 values as the
> > > golden master because it's a mounted filesystem, and then comparing
> > > everything else against it. Maybe we should at least check a couple
> > > of secondary superblocks to see that they match the primary
> > > superblock - that way we'll have some confidence that at least
> > > things like agcount, agblocks, dblocks, etc are valid before we go
> > > any further...
> > 
> > xfs_scrub_superblock does check the secondary superblock geometry
> > against whatever's in mp->m_sb, which came from sb 0.
> 
> /me smacks forehead
> 
> The patch is even named "scrub the backup superblocks".
> 
> Perhaps it didn't sink in because they are normally called
> "secondary superblocks". My bad....

Sometimes I think I still have ext4 on the brain. :(

--D

> > > BUt maybe all we need is comment in the overall scrub description -
> > > that we're pretty much assuming that sb 0 is intact because we write
> > > what is in memory back to it and so we can simply validate
> > > everything else against the primary superblock contents...
> > 
> > Correct.  Since scrub is run against a mounted live filesystem we assume
> > that the mount code fully validated sb 0 and therefore we can rely on it
> > not being wrong.
> > 
> > If OTOH sb 0 *is* wrong then the admin is better off running xfs_repair
> > because there's too much whirring machinery to go changing fundamental
> > geometry.
> 
> Yup, that makes sense.
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

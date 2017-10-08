Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42855 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753187AbdJHDyv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 7 Oct 2017 23:54:51 -0400
Date: Sat, 7 Oct 2017 20:54:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 17/25] xfs: scrub inode block mappings
Message-ID: <20171008035447.GP7122@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706335646.19351.8363960454156993724.stgit@magnolia>
 <20171006025123.GQ3666@dastard>
 <20171006170044.GJ7122@magnolia>
 <20171007231055.GX3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171007231055.GX3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Oct 08, 2017 at 10:10:55AM +1100, Dave Chinner wrote:
> On Fri, Oct 06, 2017 at 10:00:44AM -0700, Darrick J. Wong wrote:
> > On Fri, Oct 06, 2017 at 01:51:23PM +1100, Dave Chinner wrote:
> > > On Tue, Oct 03, 2017 at 01:42:36PM -0700, Darrick J. Wong wrote:
> > > > +	    daddr >= info->eofs ||
> > > > +	    daddr + dlen > info->eofs)
> > > > +		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
> > > > +				irec->br_startoff);
> > > > +
> > > > +	if (irec->br_state == XFS_EXT_UNWRITTEN &&
> > > > +	    !xfs_sb_version_hasextflgbit(&mp->m_sb))
> > > 
> > > Superblock scrubber should reject any filesystem without the
> > > extflgbit as corrupt - it's always set by mkfs - so I'm not sure we
> > > need to check this here.
> > 
> > What happens if scrub encounters a v4 filesystem without EXTFLGBIT?
> 
> We don't support such filesystems (user level stale data exposure
> security risk), but we have allowed them to continue to mount
> because such filesystems did exist in the past (*cough* SGI DMF
> database partitions *cough*). I'd suggest scrub should say
> filesystems without the flag are bad are too old to be scrubbed
> correctly.

Ok, works for me.

> > The superblock scrubber only checks that the secondary superblocks are
> > consistent (geometry-wise) with sb 0, and mount doesn't prohibit
> > !EXTFLGBIT filesystems from mounting.  fallocate and friends even work,
> > albeit slower because we actually write zeroes to the disk in lieu of
> > setting the unwritten flag, apparently.
> 
> Unwritten extents were enabled by default in 2003, and the mkfs flag
> was dropped completely in 2007. So no filesystem made in the past
> ten years should have this set.
> 
> > But, seeing as mkfs always sets EXTFLGBIT and v5 implies the feature
> > even if the bit isn't set; and there's no way to turn off the feature
> > bit (except unsupported things like xfs_db -x), are you suggesting that
> > we should simply end support for mounting !EXTFLGBIT v4 filesystems?
> 
> I wasn't suggesting that, but perhaps we should.

Anyone want to send a patch to get people out of the woodwork?

:)

> > > > +
> > > > +out_unlock:
> > > > +	return error;
> > > 
> > > Hmmm - out_unlock doesn't unlock anything?
> > 
> > Heh, it never does.  Baaaaaaaaad label.

(Fixed.)

--D

> :P
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

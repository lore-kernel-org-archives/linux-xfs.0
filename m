Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0R0mObA175205 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 18:48:24 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE2D08CA5AC
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 16:50:47 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	AM2LCAv5FFxqaKtP for <xfs@oss.sgi.com>;
	Wed, 26 Jan 2011 16:50:47 -0800 (PST)
Date: Thu, 27 Jan 2011 11:50:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/8] xfs: prevent extsize alignment from exceeding
	maximum extent size
Message-ID: <20110127005045.GD21311@dastard>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
	<1295945444-29488-6-git-send-email-david@fromorbit.com>
	<1296076975.1980.942.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1296076975.1980.942.camel@doink>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 26, 2011 at 03:22:55PM -0600, Alex Elder wrote:
> On Tue, 2011-01-25 at 19:50 +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When doing delayed allocation, if the allocation size is for a
> > maximally sized extent, extent size alignment can push it over this
> > limit. This results in an assert failure in xfs_bmbt_set_allf() as
> > the extent length is too large to find in the extent record.
> > 
> > Fix this by ensuring that we allow for space that extent size
> > alignment requires (up to 2 * (extsize -1) blocks as we have to
> > handle both head and tail alignment) when limiting the maximum size
> > of the extent.
> 
> I think this is OK, however...
> 
> It seems to me that the XFS_FILBLKS_MIN() call you're making is
> sort of magical because it pre-supposes exactly what the following
> xfs_bmap_extsize_align() actually does.

Sure, but that is not a big deal because we know exactly
what xfs_bmap_extsize_align() does and we control it directly.
I plan to completely remove the extsize alignment from the delalloc
path anyway, so this is really just a fix for the given bug, not a
long term solution.

> And because of that, I
> would rather see that logic built into xfs_bmap_extsize_align()
> itself.

Possibly....
> I haven't looked at it closely, but I presume the other
> two spots that call xfs_bmap_extsize_align() would be subject to
> the same MAXEXTLEN limit.

.... but it doesn't matter for those callers as they already limit
the length of the allocation after alignment to something valid.

The problem is that the delayed allocation path has none of the same
limits on the extent length that other callers have, so the fix is
only needed for the delayed allocation path.

> OK with me if you disagree though.

Yes, I disagree, but it's still a very good question. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C884F29DFE
	for <xfs@oss.sgi.com>; Fri,  5 Apr 2013 01:56:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 44336AC006
	for <xfs@oss.sgi.com>; Thu,  4 Apr 2013 23:56:03 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	aV15lWiYBzNqQAic for <xfs@oss.sgi.com>;
	Thu, 04 Apr 2013 23:56:01 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UO0Z2-0006CM-8o
	for xfs@oss.sgi.com; Fri, 05 Apr 2013 17:55:56 +1100
Date: Fri, 5 Apr 2013 17:55:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/22] xfs: metadata CRCs, fourth version
Message-ID: <20130405065556.GI12011@dastard>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1364965892-19623-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Wed, Apr 03, 2013 at 04:11:10PM +1100, Dave Chinner wrote:
> Hi Folks,
> 
> New CRC patchset. Previous versions:
> 
> http://oss.sgi.com/archives/xfs/2013-01/msg00328.html
> http://oss.sgi.com/archives/xfs/2013-02/msg00451.html
> http://oss.sgi.com/archives/xfs/2013-03/msg00291.html
> 
> This version is based on 3.9-rc4 + TOT xfsdev. 3.9-rc5 has loopback
> bugs that make it useless for testing, so I've just kept my tree on
> -rc4.
> 
> New in this patch set:
> 
>         - numerous bug fixes
> 	- cleanups to addresse Bens review comments
> 	- logs entire inode allocation buffers
> 	- reworks the buffer type tracking for log recovery
> 	- fixes the endian issues reported by sparse
> 	- splits out the symlink code rearrangement
> 	- adds support for v5 superblock feature masks
>         - add mount warnings about CRC support being experimental
> 
> Still to do:
> 
>         - Documentation (half written, not in series)

So in finishing this off this afternoon, I realised that there is
another aspect of inode modifications that isn't fully covered by
the CRCs - the unlinked list modifications. That is because it
happens under the covers directly to the inode buffer.

This hasn't been detected so far, because the end result of this is
that the CRC ends up still being valid. What happens is this:

	- last CRC is calculated with di_next_unlinked = NULLAGINO
	- xfs_iunlink() sets di_next_unlinked, invalidating the CRC
	- xfs_iunlink_remove() resets di_next_unlinked = NULLAGINO,
	  making the CRC valid again.

Then when all those mods are made:

	- inode reclaim flushes the inode, recalculating the CRC
	  again, or:
	- xfs_ifree_cluster marks the inode XFS_ISTALE and it is not
	  updated any further, leaving the CRC in a valid state.

So, in all normal cases, the invalid CRC is not ever noticed as we
don't verify the CRC for inode buffer operations.

If we crash with an inode on the unlinked list or with transactions
in the log that move it to/from the unlinked list, log replay will
simply modify the buffer, similar to xfs_iunlink()/
xfs_iunlink_remove(), hence leaving us with an inode with a valid
CRC again.

This does need to be fixed, but I don't think it is a show stopper
issue right now. As to how to fix it? I think that for version 3
inodes, I need to change the unlinked list handling to be logged in
the core inode rather than as part of the buffer. Indeed, the
di_next_unlinked field is already being logged in the inode core for
version 3 inodes, so this is simply a code change that can be done
without an on-disk format change or special new transactions. This
is another reason I don't think this is a showstopper problem....

Comments?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

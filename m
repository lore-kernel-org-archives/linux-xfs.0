Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2PKw48L245947 for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 15:58:04 -0500
Subject: Re: [PATCH 5/6] xfs: register the inode cache shrinker before
	quotachecks
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1300860870-15471-6-git-send-email-david@fromorbit.com>
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>
	<1300860870-15471-6-git-send-email-david@fromorbit.com>
Date: Fri, 25 Mar 2011 16:01:08 -0500
Message-ID: <1301086868.2537.684.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, 2011-03-23 at 17:14 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> During mount, we can do a quotacheck that involves a bulkstat pass
> on all inodes. If there are more inodes in the filesystem than can
> be held in memory, we require the inode cache shrinker to run to
> ensure that we don't run out of memory.
> 
> Unfortunately, the inode cache shrinker is not registered until we
> get to the end of the superblock setup process, which is after a
> quotacheck is run if it is needed. Hence we need to register the
> inode cache shrinker earlier in the mount process so that we don't
> OOM during mount. This requires that we also initialise the syncd
> work before we register the shrinker, so we nee dto juggle that
> around as well.
> 
> While there, make sure that we have set up the block sizes in the
> VFS superblock correctly before the quotacheck is run so that any
> inodes that are cached as a result of the quotacheck have their
> block size fields set up correctly.
> 
> Cc: stable@kernel.org
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

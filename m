Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CD834805C
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 02:35:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A93888F804B
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 00:35:20 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	JKIeuNBUYkHfXvbg for <xfs@oss.sgi.com>;
	Sat, 16 Mar 2013 00:35:19 -0700 (PDT)
Date: Sat, 16 Mar 2013 18:35:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix WARN_ON(delalloc) in xfs_vm_releasepage()
Message-ID: <20130316073508.GI6369@dastard>
References: <1363267854-25602-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363267854-25602-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Thu, Mar 14, 2013 at 02:30:54PM +0100, Jan Kara wrote:
> When a dirty page is truncated from a file but reclaim gets to it before
> truncate_inode_pages(), we hit WARN_ON(delalloc) in
> xfs_vm_releasepage(). This is because reclaim tries to write the page,
> xfs_vm_writepage() just bails out (leaving page clean) and thus reclaim
> thinks it can continue and calls xfs_vm_releasepage() on page with dirty
> buffers.
> 
> Fix the issue by redirtying the page in xfs_vm_writepage(). This makes
> reclaim stop reclaiming the page and also logically it keeps page in a
> more consistent state where page with dirty buffers has PageDirty set.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Definitely look s like a problem taht needs fixing, and it seems to
me to be the correct fix.

I got a bug report recently about this warning being triggered,
but the total report was the warning and a workload description
of "XFS produced a warning at some point during a 28 hour long DB
benchmark." Not particularly helpful, but this looks like a
potential cause. Thanks!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

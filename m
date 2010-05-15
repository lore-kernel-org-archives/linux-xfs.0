Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4F1Rv82056168 for <xfs@oss.sgi.com>; Fri, 14 May 2010 20:27:59 -0500
Received: from ZenIV.linux.org.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 237321B58E39
	for <xfs@oss.sgi.com>; Fri, 14 May 2010 18:30:11 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id VWpgZSx1vGeUhHpq for
	<xfs@oss.sgi.com>; Fri, 14 May 2010 18:30:11 -0700 (PDT)
Date: Sat, 15 May 2010 02:30:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/5] Per-superblock shrinkers
Message-ID: <20100515013005.GA31073@ZenIV.linux.org.uk>
References: <1273821863-29524-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1273821863-29524-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, May 14, 2010 at 05:24:18PM +1000, Dave Chinner wrote:
> 
> This series reworks the filesystem shrinkers. We currently have a
> set of issues with the current filesystem shrinkers:
> 
> 	1. There is an dependency between dentry and inode cache
> 	   shrinking that is only implicitly defined by the order of
> 	   shrinker registration.
> 	2. The shrinkers need to walk the superblock list and pin
> 	   the superblock to avoid unmount races with the sb going
> 	   away.
> 	3. The dentry cache uses per-superblock LRUs and proportions
> 	   reclaim between all the superblocks which means we are
> 	   doing breadth based reclaim. This means we touch every
> 	   superblock for every shrinker call, and may only reclaim
> 	   a single dentry at a time from a given superblock.
> 	4. The inode cache has a global LRU, so it has different
> 	   reclaim patterns to the dentry cache, despite the fact
> 	   that the dentry cache is generally the only thing that
> 	   pins inodes in memory.
> 	5. Filesystems need to register their own shrinkers for
> 	   caches and can't co-ordinate them with the dentry and
> 	   inode cache shrinkers.

NAK in that form; sb refcounting and iterators had been reworked for .34,
so at least it needs rediff on top of that.  What's more, it's very
obviously broken wrt locking - you are unregistering a shrinker
from __put_super().  I.e. grab rwsem exclusively under a spinlock.

Essentially, you've turned dropping a _passive_ reference to superblock
(currently an operation safe in any context) into an operation allowed
only when no fs or vm locks are held by caller.  Not going to work...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

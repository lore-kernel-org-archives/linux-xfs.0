Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C14947F4E
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 16:39:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 41B28AC005
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 14:39:51 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	CTR5eRPvoEwRE0Th for <xfs@oss.sgi.com>;
	Wed, 26 Nov 2014 14:39:49 -0800 (PST)
Date: Thu, 27 Nov 2014 09:39:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] vfs: don't let the dirty time inodes get more than a
	day stale
Message-ID: <20141126223901.GF9561@dastard>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-4-git-send-email-tytso@mit.edu>
	<20141125015332.GE27262@dastard> <20141125044508.GG31339@thunk.org>
	<20141125234851.GB9561@dastard> <20141126102017.GJ28449@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141126102017.GJ28449@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Nov 26, 2014 at 05:20:17AM -0500, Theodore Ts'o wrote:
> On Wed, Nov 26, 2014 at 10:48:51AM +1100, Dave Chinner wrote:
> > No abuse necessary at all. Just a different inode_dirtied_after()
> > check is requires if the inode is on the time dirty list in
> > move_expired_inodes().
> 
> I'm still not sure what you have in mind here.  When would this be
> checked? 

Have you looked at where move_expired_inodes() gets called from?
It's called periodically from background writeback by queue_io(),
and sync uses the same infrastructure to expire all inodes on the
dirty list....

> It sounds like you want to set a timeout such that when an
> inode which had its timestamps updated lazily 24 hours earlier, the
> inode would get written out.  Yes?  But that implies something is
> going to have to scan the list of inodes on the dirty time list
> periodically.  When are you proposing that this take place?

The writeback code already does this for dirty inodes. it does it in
move_expired_inodes() to move the inodes with i_dirtied_when is
older than 30s. It's *trivial* to add a time dirty inode list and
scan that at the same time to pull off inodes that are older than
24hrs.

> The various approaches that come to mind all seem more complex than
> what I have in this patch 3 of 4, and I'm not sure it's worth the
> complexity.

the "once a day" stuff you've added is a horrible, nasty hack. I
wasn't going to say anything about it (i.e. if you can't say
anything nice...). The existing dirty inode writeback expiry code
does *everything* we need already, we just need to plumb in a new
list and add an expiry check of that list to move inodes to the b_io
list when they have been timestamp dirty for more than 24 hours...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

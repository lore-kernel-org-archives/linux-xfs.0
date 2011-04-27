Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3R2NSEO192162 for <xfs@oss.sgi.com>; Tue, 26 Apr 2011 21:23:29 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2FA5A4170A0
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2011 19:26:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	mLG4vTnClCsuFALd for <xfs@oss.sgi.com>;
	Tue, 26 Apr 2011 19:26:59 -0700 (PDT)
Date: Wed, 27 Apr 2011 12:26:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110427022655.GE12436@dastard>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
	<20110424234655.GC12436@dastard>
	<alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
	<alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Apr 25, 2011 at 12:19:24AM -0700, Christian Kujau wrote:
> On Mon, 25 Apr 2011 at 09:46, Dave Chinner wrote:
> > I'd say they are not being reclaimmmed because the VFS hasn't let go
> > of them yet. Can you also dump /proc/sys/fs/{dentry,inode}-state so
> > we can see if the VFS has released the inodes such that they can be
> > reclaimed by XFS?
> 
> Please see http://nerdbynature.de/bits/2.6.39-rc4/oom/
> 
>  - slabinfo-4.txt.bz2, contains /proc/sys/fs/{dentry,inode}-state and

Ok, so looking at slabinfo-5.txt.bz2, this is the pattern of dentry,
VFS inode and XFS inode use patterns:

http://userweb.kernel.org/~dgc/slab-usage.png

What this shows is that VFS inode cache memory usage increases until
about the 550 sample mark before the VM starts to reclaim it with
extreme prejudice. At that point, I'd expect the XFS inode cache to
then shrink, and it doesn't. I've got no idea why the either the
shrinker or background reclaim is not reclaiming and freeing inodes,
but it is the reason why the system OOMs.

Can you check if there are any blocked tasks nearing OOM (i.e. "echo
w > /proc/sysrq-trigger") so we can see if XFS inode reclaim is
stuck somewhere?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0F3pVn5062868 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 21:51:31 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F0BC1C51655
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 19:52:26 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	RMBNcCLEq7HWAdR9 for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 19:52:26 -0800 (PST)
Date: Fri, 15 Jan 2010 14:52:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs 3.1.0 repair problems?
Message-ID: <20100115035222.GC28498@discord.disaster>
References: <4B4FDC3E.6030205@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B4FDC3E.6030205@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Jan 14, 2010 at 09:08:46PM -0600, Eric Sandeen wrote:
> It looks like maybe the freespace checking isn't quite up to par:
> 
> test 073 is dying with:
> 
> _check_xfs_filesystem: filesystem on /mnt/test/14309.image is inconsistent
> *** xfs_repair -n output ***
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - scan filesystem freespace and inode maps...
> sb_fdblocks 26156829, counted 26157853

Actually, that looks like it is out by exactly 1024 blocks, which is
the default amount of reserved space in the filesystem. Perhaps
there is something else wrong with the unmount code that
is not unreserving this space before the superblock is
written to disk?

I'm about to see if I can reproduce it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

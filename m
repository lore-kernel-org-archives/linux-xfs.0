Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0F5tbUV070554 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 23:55:37 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E897311F29DE
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 21:56:31 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	TvCMKb9vCCsgfFM1 for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 21:56:31 -0800 (PST)
Date: Fri, 15 Jan 2010 16:56:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs 3.1.0 repair problems?
Message-ID: <20100115055628.GD28498@discord.disaster>
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
>         - found root inode chunk

This is caused by the remount,ro done in the test - the superblock
is written to disk with the reserved blocks considered used. At
unmount time those reserve blocks are "freed" before the superblock
is written and so the total is correct at that time.

I'm going to go look at the kernel code now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

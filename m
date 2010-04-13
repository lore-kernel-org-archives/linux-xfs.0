Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D2m3iE184315 for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 21:48:04 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 700762BA582
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 19:49:49 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	g3K4hLeWxhczUZWZ for <xfs@oss.sgi.com>;
	Mon, 12 Apr 2010 19:49:49 -0700 (PDT)
Date: Tue, 13 Apr 2010 12:49:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.34-rc3: inode 0x401afe0 background reclaim flush failed
	with 11
Message-ID: <20100413024946.GP2493@dastard>
References: <alpine.DEB.2.01.1004091348010.29272@bogon.housecafe.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1004091348010.29272@bogon.housecafe.de>
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
Cc: xfs@oss.sgi.com

On Fri, Apr 09, 2010 at 02:05:14PM -0700, Christian Kujau wrote:
> Hi,
> 
> while running some filesystem benchmarks, this happend in my logs when 
> bonnie++ was running:
> 
> [14610.114155] Filesystem "md0": inode 0x401afe0 background reclaim flush failed with 11
> [14610.114171] Filesystem "md0": inode 0x401afe1 background reclaim flush failed with 11
> [14610.114183] Filesystem "md0": inode 0x401afe2 background reclaim flush failed with 11
> [...]
> 
> ...and so forth for a couple of inodes.
> 
> I can reproduce this pretty reliably with bonnie++ now. This did not 
> happen with 2.6.33, but the bonnie++ version has been upgraded too, so I'm 
> still not sure if this is a real regression.
> 
> I've put a few details on http://nerdbynature.de/bits/2.6.34-rc3/xfs/
> 
> Is this something to worry about?

No.

http://git.kernel.org/?p=linux/kernel/git/dgc/xfs.git;a=commit;h=7bb6049804717d4aa1f43f2abb50691c0df1d9f2

> 
> Thanks,
> Christian.
> 
> PS: Why is the inode shown in hex and not in decimal? Would something 
> like this do:

Because I find that large inode numbers in hex are much easier to
understand than huge decimal numbers. The inode number is a direct
encoding of it's location on disk and these days I can generally
decode them in my head direct from the hex value. IOWs, the first
thing I almost always do when looking at an inode number is convert
it to hex, so I don't see any point in printing them in decimal...

e.g. without knowing the geometry of the filesystem, I'd guess that
inode 0x401afe0 is inode 0x20 (32) of an inode allocation chunk,
it's AG 2, 4, 8 or 16 (depends on the size of the AGs), and the
block offset into the AG is 0xd7e (agbno 3454). From that I know a
lot about the inode - it's the first in an inode cluster buffer and
the other inodes reported are in the same buffer hence it's only one
one busy buffer that caused the warnings, the agbno is small so it's
near the start of the AG so there probably aren't a large number of
inodes in the filesystem, etc.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

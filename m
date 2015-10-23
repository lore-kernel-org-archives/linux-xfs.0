Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E767A7F37
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 01:55:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D6657304039
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2015 23:55:42 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	St6BCoVZj2E1oiC8 for <xfs@oss.sgi.com>;
	Thu, 22 Oct 2015 23:55:40 -0700 (PDT)
Date: Fri, 23 Oct 2015 17:55:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: du result is smaller than xfs_quota report
Message-ID: <20151023065537.GE19199@dastard>
References: <tencent_7585C3B40C484DE23B248E82@qq.com>
	<0952A0E9-F360-46CE-BE7A-1B8473700F08@sandeen.net>
	<tencent_756CDB1668EC804906FB9672@qq.com>
	<20151021071331.GD19199@dastard>
	<tencent_309A49F965AE688A078ADD3E@qq.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <tencent_309A49F965AE688A078ADD3E@qq.com>
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
To: YeYin <eyniy@qq.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs <xfs@oss.sgi.com>

On Wed, Oct 21, 2015 at 04:09:20PM +0800, YeYin wrote:
> Hi, Dave,
> Thank you very much. I got some results:
> # xfs_db -xr  /dev/sda4                        
> xfs_db> convert agno 1 agino 78272 ino
> 0x800131c0 (2147561920)
> xfs_db> inode 2147561920
> xfs_db> p
> core.magic = 0x494e
> core.mode = 0100600
> core.version = 2
> core.format = 2 (extents)
> core.nlinkv2 = 0
....
> However, I want to ask how this situation to happen?

Either O_TMPFILE files that are still open, or files that have been
unlinked but still have an open file descriptor referencing them.
They won't be unlinked until the last reference goes away.

> # tail -f /data/test.data &
> [1] 27598
> # unlink /data/test.data 
> 
> 
> # xfs_db -xr -c 'inode 29409295' -c p /dev/sda4
> core.magic = 0x494e
> core.mode = 0100644
> core.version = 2
> core.format = 2 (extents)
> core.nlinkv2 = 1

Inode hasn't been written back to disk yet. That happens
asynchronously, usually based on time, sometimes sooner due to log
space demands, sometimes longer due to repeated modifications.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

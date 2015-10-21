Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A48057F37
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2015 02:13:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3D0BDAC001
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2015 00:13:36 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	KLKAp8ad3AavgYyN for <xfs@oss.sgi.com>;
	Wed, 21 Oct 2015 00:13:33 -0700 (PDT)
Date: Wed, 21 Oct 2015 18:13:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: du result is smaller than xfs_quota report
Message-ID: <20151021071331.GD19199@dastard>
References: <tencent_7585C3B40C484DE23B248E82@qq.com>
	<0952A0E9-F360-46CE-BE7A-1B8473700F08@sandeen.net>
	<tencent_756CDB1668EC804906FB9672@qq.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <tencent_756CDB1668EC804906FB9672@qq.com>
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

On Wed, Oct 21, 2015 at 02:37:04PM +0800, YeYin wrote:
> > Is anything mounted under that directory hierarchy, and hiding files from du's view?
> 
> 
> No, Thanks. I found some unlinked inodes, but I can't get some useful information:
> 
> 
> # xfs_db -xr -c 'agi 1' -c p /dev/sda4  
....
> unlinked[0-63] = 0:78272 ....

> # xfs_db -xr -c 'inode 78272' -c p /dev/sda4

That's because 78272 isn't an real inode number. It's a AG relative
inode number ("agino") of 78272. The global inode number folds in
the AG number to it, and this is from AG 1. So:

xfs_db> convert agno 1 agino 78272 ino
<inum>
xfs_db> inode <inum>
xfs_db> p
....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 80FB97FE0
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 17:40:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 612218F80A6
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 15:40:13 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	WhJno6QT0g5EAIit for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 15:40:11 -0800 (PST)
Date: Fri, 30 Jan 2015 10:15:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair fails with corrupt dinode
Message-ID: <20150129231538.GE6282@dastard>
References: <587A9635632B174A943E53AF3B58A9082E3BE068CE@vanda>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <587A9635632B174A943E53AF3B58A9082E3BE068CE@vanda>
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
To: "SCHEFFER, Philippe" <Philippe.SCHEFFER@inist.fr>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Jan 29, 2015 at 04:48:15PM +0100, SCHEFFER, Philippe wrote:
> Hi,
> 
> I have a corrupted xfs filesytem. When I try to repair I get this error :
> disconnected inode 1427919, moving to lost+found
> corrupt dinode 1427919, extent total = 1, nblocks = 0.  This is a bug.
> Please capture the filesystem metadata with xfs_metadump and
> report it to xfs@oss.sgi.com.
> cache_node_purge: refcount was 1, not zero (node=0x1f6c19620)
> 
> fatal error -- 117 - couldn't iget disconnected inode
> 
> I captured metada with xfs_metadump but the file is 1,4Gb long. I can't send it to you.
> 
> I printed inode1427919 :
> 
> xfs_db> inode 1427919
> xfs_db> print
> core.magic = 0x494e
....
> core.format = 2 (extents)
....
> core.size = 2536
> core.nblocks = 1
> core.extsize = 0
> core.nextents = 1
....
> u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,320660992,1,0]

That's an inode with one extent of one block and looks perfectly
valid. We'll need the entire output of the xfs_repair run to see if
there were any prior actions taken on that inode by xfs_repair....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

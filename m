Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6D1827CA5
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 21:53:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 50A89304059
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 19:53:30 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZCT3jNvKjSnFBGIW for <xfs@oss.sgi.com>;
	Thu, 11 Feb 2016 19:53:28 -0800 (PST)
Date: Fri, 12 Feb 2016 14:52:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/32] dio: unwritten conversion bug tests
Message-ID: <20160212035253.GX14668@dastard>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
	<20160211234037.2202.93885.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160211234037.2202.93885.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Feb 11, 2016 at 03:40:37PM -0800, Darrick J. Wong wrote:
> Check that we don't expose old disk contents when a directio write to
> an unwritten extent fails due to IO errors.  This primarily affects
> XFS and ext4.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

aiocp.c: In function 'main':
aiocp.c:407:1: warning: format '%d' expects argument of type 'int', but argument 3 has type 'off_t' [-Wformat=]
 printf("tocopy=%d len=%d blk=%d\n", tocopy, length, aio_blksize);
 ^

Followup patch is fine, I'll commit as is.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

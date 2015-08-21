Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EB7E67FA1
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 17:52:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BCAA58F804C
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 15:52:53 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	GVzZ34z7w48LK0v5 for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2015 15:52:51 -0700 (PDT)
Date: Sat, 22 Aug 2015 08:52:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: document dax in xfs.5 and other minor fixes
Message-ID: <20150821225248.GQ3902@dastard>
References: <55D799B9.8040002@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55D799B9.8040002@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Aug 21, 2015 at 04:35:53PM -0500, Eric Sandeen wrote:
> Document the dax option, fix whitespace around logdev/rtdev,
> and add missing qnoenforce.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

No, I don't want the DAX mount option documented. As the code says:

#define XFS_MOUNT_DAX           (1ULL << 62)    /* TEST ONLY! */

The mount option needs to go away and be replaced by on-disk
inheritable per-inode flags. I have the kernel patch to do this, but
I have not written the xfs_io patch to get/set/clear the flags yet.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

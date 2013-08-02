Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CE4C729E11
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 20:47:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9BCF18F8040
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 18:47:28 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	KFMCym4GtP3kYu33 for <xfs@oss.sgi.com>;
	Thu, 01 Aug 2013 18:47:27 -0700 (PDT)
Date: Fri, 2 Aug 2013 11:47:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 6/7] xfs: add capability check to free eofblocks ioctl
Message-ID: <20130802014725.GW7118@dastard>
References: <20130801113020.0d43302f@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130801113020.0d43302f@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 01, 2013 at 11:30:20AM -0400, Dwight Engen wrote:
> Check for CAP_SYS_ADMIN since the caller can truncate preallocated
> blocks from files they do not own nor have write access to. A more
> fine grained access check was considered: require the caller to
> specify their own uid/gid and to use inode_permission to check for
> write, but this would not catch the case of an inode not reachable
> via path traversal from the callers mount namespace.
> 
> Add check for read-only filesystem to free eofblocks ioctl.
> 
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

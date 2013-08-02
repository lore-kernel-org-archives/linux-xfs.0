Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7ED7E29DFB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 20:47:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5AD2F3040BA
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 18:47:02 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	cM0IOJnIK3GiJZ14 for <xfs@oss.sgi.com>;
	Thu, 01 Aug 2013 18:47:00 -0700 (PDT)
Date: Fri, 2 Aug 2013 11:46:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 3/7] xfs: ioctl check for capabilities in the current
	user namespace
Message-ID: <20130802014659.GV7118@dastard>
References: <20130801113006.13370058@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130801113006.13370058@oracle.com>
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

On Thu, Aug 01, 2013 at 11:30:06AM -0400, Dwight Engen wrote:
> Use inode_capable() to check if SUID|SGID bits should be cleared to match
> similar check in inode_change_ok().
> 
> The check for CAP_LINUX_IMMUTABLE was not modified since all other file
> systems also check against init_user_ns rather than current_user_ns.
> 
> Only allow changing of projid from init_user_ns.
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

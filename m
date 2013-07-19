Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2C3A37F5E
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 00:35:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AD9B3AC001
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 22:35:36 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	pfRs5wRyt9YGxbqf for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 22:35:35 -0700 (PDT)
Date: Fri, 19 Jul 2013 15:35:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 4/7] xfs: convert kuid_t to/from uid_t for internal
	structures
Message-ID: <20130719053532.GV11674@dastard>
References: <20130717114734.4d2ca6fb@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130717114734.4d2ca6fb@oracle.com>
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

On Wed, Jul 17, 2013 at 11:47:34AM -0400, Dwight Engen wrote:
> Use uint32 from init_user_ns for xfs internal uid/gid
> representation in xfs_icdinode, xfs_dqid_t.
> 
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> ---
>  fs/xfs/xfs_inode.c    |  6 +++---
>  fs/xfs/xfs_iops.c     | 38 ++++++++++++++++++++------------------
>  fs/xfs/xfs_qm.c       | 10 +++++-----
>  fs/xfs/xfs_quota.h    | 11 ++++++-----
>  fs/xfs/xfs_symlink.c  |  6 ++++--
>  fs/xfs/xfs_vnodeops.c |  8 +++++---
>  6 files changed, 43 insertions(+), 36 deletions(-)

Looks good. It's clear now that here is a difference between what
is held in the VFS inode and the XFS inode core....

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8S73keY196838 for <xfs@oss.sgi.com>; Fri, 28 Sep 2012 02:03:46 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	SYsPtxJDW4X7GNrx for <xfs@oss.sgi.com>;
	Fri, 28 Sep 2012 00:05:05 -0700 (PDT)
Date: Fri, 28 Sep 2012 17:05:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 2/8] xfs: support a tag-based inode_ag_iterator
Message-ID: <20120928070503.GI25626@dastard>
References: <1348767952-24229-1-git-send-email-bfoster@redhat.com>
	<1348767952-24229-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1348767952-24229-3-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 27, 2012 at 01:45:46PM -0400, Brian Foster wrote:
> Genericize xfs_inode_ag_walk() to support an optional radix tree tag
> and args argument for the execute function. Create a new wrapper
> called xfs_inode_ag_iterator_tag() that performs a tag based walk
> of perag's and inodes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_qm_syscalls.c |    5 ++-
>  fs/xfs/xfs_sync.c        |   61 +++++++++++++++++++++++++++++++++++++++-------
>  fs/xfs/xfs_sync.h        |    7 ++++-
>  3 files changed, 60 insertions(+), 13 deletions(-)

Looks fine, but needs the same xfs_icache.c rebase...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UHu6WQ061164 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 12:56:18 -0500
Date: Mon, 29 Oct 2012 18:14:19 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 10/25] xfs: verify btree blocks as they are read from disk
Message-ID: <20121030011419.GM30227@caliban.engr.sgi.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-11-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-11-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 25, 2012 at 05:33:59PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add an btree block verify callback function and pass it into the
> buffer read functions. Because each different btree block type
> requires different verification, add a function to the ops structure
> that is called from the generic code.
> 
> Also, propagate the verification callback functions through the
> readahead functions, and into the external bmap and bulkstat inode
> readahead code that uses the generic btree buffer read functions.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_alloc_btree.c  |   49 +++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_bmap.c         |   60 ++++++++++++++++++++++++-----------------
>  fs/xfs/xfs_bmap_btree.c   |   47 ++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_bmap_btree.h   |    1 +
>  fs/xfs/xfs_btree.c        |   66 +++++++++++++++++++++++----------------------
>  fs/xfs/xfs_btree.h        |   10 ++++---
>  fs/xfs/xfs_ialloc_btree.c |   40 +++++++++++++++++++++++++++
>  fs/xfs/xfs_inode.c        |    2 +-
>  fs/xfs/xfs_inode.h        |    1 +
>  fs/xfs/xfs_itable.c       |    3 ++-
>  10 files changed, 218 insertions(+), 61 deletions(-)

Looks good.  I remember there being conversations about whether or not
XFS needed to go on a stack diet for some platforms.  But in general,
I think there's merit to providing these functions as callbacks.

Reviewed-by: Phil White <pwhite@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

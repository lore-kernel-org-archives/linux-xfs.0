Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UHu6W0061164 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 12:56:08 -0500
Date: Tue, 30 Oct 2012 06:34:46 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 22/25] xfs: add pre-write metadata buffer verifier
	callbacks
Message-ID: <20121030133446.GH18595@caliban.engr.sgi.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-23-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-23-git-send-email-david@fromorbit.com>
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

On Thu, Oct 25, 2012 at 05:34:11PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> These verifiers are essentially the same code as the read verifiers,
> but do not require ioend processing. Hence factor the read verifier
> functions and add a new write verifier wrapper that is used as the
> callback.
> 
> This is done as one large patch for all verifiers rather than one
> patch per verifier as the change is largely mechanical. This
> includes hooking up the write verifier via the read verifier
> function.
> 
> Hooking up the write verifier for buffers obtained via
> xfs_trans_get_buf() will be done in a separate patch as that touches
> code in many different places rather than just the verifier
> functions.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_alloc.c        |   38 +++++++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_alloc_btree.c  |   21 +++++++++++++++++----
>  fs/xfs/xfs_attr_leaf.c    |   19 +++++++++++++++++--
>  fs/xfs/xfs_attr_leaf.h    |    2 +-
>  fs/xfs/xfs_bmap_btree.c   |   21 +++++++++++++++++----
>  fs/xfs/xfs_da_btree.c     |   30 ++++++++++++++++++------------
>  fs/xfs/xfs_dir2_block.c   |   16 +++++++++++++++-
>  fs/xfs/xfs_dir2_data.c    |   19 +++++++++++++++++--
>  fs/xfs/xfs_dir2_leaf.c    |   31 ++++++++++++++++++++++++-------
>  fs/xfs/xfs_dir2_node.c    |   17 ++++++++++++++++-
>  fs/xfs/xfs_dir2_priv.h    |    2 +-
>  fs/xfs/xfs_dquot.c        |   22 ++++++++++++++++++----
>  fs/xfs/xfs_ialloc.c       |   17 ++++++++++++++++-
>  fs/xfs/xfs_ialloc_btree.c |   19 ++++++++++++++++---
>  fs/xfs/xfs_inode.c        |   19 +++++++++++++++++--
>  fs/xfs/xfs_inode.h        |    2 +-
>  fs/xfs/xfs_itable.c       |    2 +-
>  fs/xfs/xfs_mount.c        |   19 +++++++++++++++++--
>  18 files changed, 262 insertions(+), 54 deletions(-)

Looks OK by me.

Reviewed-by: Phil White <pwhite@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

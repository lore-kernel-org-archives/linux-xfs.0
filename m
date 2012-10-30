Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UHu6W4061164 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 12:56:09 -0500
Date: Tue, 30 Oct 2012 06:41:19 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 24/25] xfs: convert buffer verifiers to an ops structure.
Message-ID: <20121030134118.GJ18595@caliban.engr.sgi.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-25-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-25-git-send-email-david@fromorbit.com>
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

On Thu, Oct 25, 2012 at 05:34:13PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To separate the verifiers from iodone functions and associate read
> and write verifiers at the same time, introduce a buffer verifier
> operations structure to the xfs_buf.
> 
> This avoids the need for assigning the write verifier, clearing the
> iodone function and re-running ioend processing in the read
> verifier, and gets rid of the nasty "b_pre_io" name for the write
> verifier function pointer. If we ever need to, it will also be
> easier to add further content specific callbacks to a buffer with an
> ops structure in place.
> 
> We also avoid needing to export verifier functions, instead we
> can simply export the ops structures for those that are needed
> outside the function they are defined in.
> 
> This patch also fixes a directory block readahead verifier issue
> it exposed.
> 
> This patch also adds ops callbacks to the inode/alloc btree blocks
> initialised by growfs. These will need more work before they will
> work with CRCs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_ag.h           |    4 +++
>  fs/xfs/xfs_alloc.c        |   26 +++++++++++--------
>  fs/xfs/xfs_alloc.h        |    2 +-
>  fs/xfs/xfs_alloc_btree.c  |   18 +++++++------
>  fs/xfs/xfs_alloc_btree.h  |    2 ++
>  fs/xfs/xfs_attr_leaf.c    |   19 +++++++-------
>  fs/xfs/xfs_attr_leaf.h    |    3 ++-
>  fs/xfs/xfs_bmap.c         |   22 ++++++++--------
>  fs/xfs/xfs_bmap_btree.c   |   20 +++++++-------
>  fs/xfs/xfs_bmap_btree.h   |    3 +--
>  fs/xfs/xfs_btree.c        |   26 +++++++++----------
>  fs/xfs/xfs_btree.h        |    9 +++----
>  fs/xfs/xfs_buf.c          |   63 ++++++++++++++++++++++++++-------------------
>  fs/xfs/xfs_buf.h          |   24 ++++++++++-------
>  fs/xfs/xfs_da_btree.c     |   28 ++++++++++----------
>  fs/xfs/xfs_da_btree.h     |    4 +--
>  fs/xfs/xfs_dir2_block.c   |   20 +++++++-------
>  fs/xfs/xfs_dir2_data.c    |   52 ++++++++++++++++++++++++++++++-------
>  fs/xfs/xfs_dir2_leaf.c    |   36 ++++++++++++++------------
>  fs/xfs/xfs_dir2_node.c    |   26 ++++++++++---------
>  fs/xfs/xfs_dir2_priv.h    |   10 ++++---
>  fs/xfs/xfs_dquot.c        |   16 +++++++-----
>  fs/xfs/xfs_fsops.c        |   26 ++++++++++++++++---
>  fs/xfs/xfs_ialloc.c       |   18 +++++++------
>  fs/xfs/xfs_ialloc.h       |    2 +-
>  fs/xfs/xfs_ialloc_btree.c |   17 ++++++------
>  fs/xfs/xfs_ialloc_btree.h |    2 ++
>  fs/xfs/xfs_inode.c        |   22 +++++++++-------
>  fs/xfs/xfs_inode.h        |    3 +--
>  fs/xfs/xfs_itable.c       |    2 +-
>  fs/xfs/xfs_log_recover.c  |    2 +-
>  fs/xfs/xfs_mount.c        |   35 +++++++++++++++----------
>  fs/xfs/xfs_mount.h        |    4 +--
>  fs/xfs/xfs_trans.h        |    6 ++---
>  fs/xfs/xfs_trans_buf.c    |    8 +++---
>  35 files changed, 346 insertions(+), 234 deletions(-)

More mechanical changes.  Looks good.

Reviewed-by: Phil White <pwhite@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

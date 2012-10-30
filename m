Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UHu6Vu061164 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 12:56:07 -0500
Date: Tue, 30 Oct 2012 06:44:27 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 25/25] xfs: add write verifiers to log recovery
Message-ID: <20121030134427.GK18595@caliban.engr.sgi.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-26-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-26-git-send-email-david@fromorbit.com>
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

On Thu, Oct 25, 2012 at 05:34:14PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Log recovery reads metadata, modifies it and rewrites it to disk.
> It is only practical to add write verifiers to metadata buffers
> because we do not know the type of the buffer prior to reading it
> from disk. Further, if it is an new bufer, the contents might not
> contain anything we can verify. Hence we only attempt to verify
> after the buffer changes have been replayed and we can peek at the
> buffer to find out what it contains to attached the correct
> verifier.  This ensures that we don't introduce gross corruptions as
> a result of replaying transactions in the log.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_alloc.c       |    2 +-
>  fs/xfs/xfs_alloc.h       |    1 +
>  fs/xfs/xfs_alloc_btree.c |   15 ++++---
>  fs/xfs/xfs_da_btree.h    |    1 +
>  fs/xfs/xfs_dir2_leaf.c   |    2 +-
>  fs/xfs/xfs_dir2_node.c   |    2 +-
>  fs/xfs/xfs_dir2_priv.h   |    3 ++
>  fs/xfs/xfs_dquot.c       |   17 +++++++-
>  fs/xfs/xfs_dquot.h       |    2 +
>  fs/xfs/xfs_log_recover.c |  104 +++++++++++++++++++++++++++++++++++++++++++++-
>  10 files changed, 138 insertions(+), 11 deletions(-)

Generally, a good read.  It kept me on the edge of my seat.

Reviewed-by: Phil White <pwhite@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

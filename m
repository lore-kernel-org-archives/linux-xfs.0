Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9V0Lxcn085125 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 19:21:59 -0500
Date: Tue, 30 Oct 2012 17:23:47 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 19/25] xfs: add xfs_da_node verification
Message-ID: <20121031002346.GB20337@caliban.engr.sgi.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-20-git-send-email-david@fromorbit.com>
	<20121030133026.GE18595@caliban.engr.sgi.com>
	<20121030222332.GD29378@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121030222332.GD29378@dastard>
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
Cc: xfs@oss.sgi.com, Phil White <pwhite@sgi.com>

On Wed, Oct 31, 2012 at 09:23:32AM +1100, Dave Chinner wrote:
> There's also another problem with this - endian swapping is missing.

Endian swapping doesn't matter.  include/linux/types.h defines __be16 as
a __u16 and 0 is 0 is 0, no matter which order you put the bytes.

Doesn't hurt to make it clear though.
 
> xfs: add xfs_da_node verification
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_attr.c      |   22 ++++------
>  fs/xfs/xfs_attr_leaf.c |   12 +++---
>  fs/xfs/xfs_attr_leaf.h |    8 ++--
>  fs/xfs/xfs_da_btree.c  |  109 ++++++++++++++++++++++++++++++++++++------------
>  fs/xfs/xfs_da_btree.h  |    3 ++
>  fs/xfs/xfs_dir2_leaf.c |    2 +-
>  fs/xfs/xfs_dir2_priv.h |    1 +
>  7 files changed, 107 insertions(+), 50 deletions(-)

I'm a little surprised (and dismayed) that it passed xfstests with that.
Presumably, it never ran into a case where level or count were > 0 on
an invalid xfs_da_node.

Anyway...

Reviewed-by: Phil White <pwhite@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

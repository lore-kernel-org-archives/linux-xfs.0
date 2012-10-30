Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UHu6WC061164 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 12:56:12 -0500
Date: Tue, 30 Oct 2012 06:21:37 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 16/25] xfs: factor out dir2 data block reading
Message-ID: <20121030132136.GB18595@caliban.engr.sgi.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-17-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-17-git-send-email-david@fromorbit.com>
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

On Thu, Oct 25, 2012 at 05:34:05PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> And add a verifier callback function while there.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_dir2_block.c |    3 +--
>  fs/xfs/xfs_dir2_data.c  |   32 ++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_dir2_leaf.c  |   38 +++++++++++++++++---------------------
>  fs/xfs/xfs_dir2_node.c  |    8 ++++----
>  fs/xfs/xfs_dir2_priv.h  |    2 ++
>  5 files changed, 56 insertions(+), 27 deletions(-)
 
This one actually made a little light bulb go off.  I'd been wondering
why you conjoined logical conditions in an assignment to block_ok
earlier, but split things out here.  I see now that it's to explicitly
and unambiguosly separate out the order of evaluation.

Reviewed-by: Phil White <pwhite@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

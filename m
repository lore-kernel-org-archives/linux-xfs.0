Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 29B077FAD
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 18:07:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B8CA9AC002
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 16:06:58 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id YeCteAXwNYUGBUCc for <xfs@oss.sgi.com>;
	Tue, 08 Oct 2013 16:06:57 -0700 (PDT)
Message-ID: <5254900F.5020506@sandeen.net>
Date: Tue, 08 Oct 2013 18:06:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 05/32] xfs: ensure we copy buffer type in da btree root
	splits
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
	<1380510944-8571-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 9/29/13 10:15 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When splitting the root of the da btree, we shuffled data between
> buffers and the structures that track them. At one point, we copy
> data and state from one buffer to another, including the ops
> associated with the buffer. When we do this, we also need to copy
> the buffer type associated with the buf log item so that the buffer
> is logged correctly. If we don't do that, log recovery won't
> recognise it and hence it won't recalculate the CRC on the buffer
> after recovery. This leads to a directory block that can't be read
> after recovery has run.
> 
> Found by inspection after finding the same problem with remote
> symlink buffers.

Makes sense, matches kernel commit 0a4edc8f0b54cd5f613e7fda7dc8106cb9869bc9

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  libxfs/xfs_da_btree.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
> index b7b6705..f106e06 100644
> --- a/libxfs/xfs_da_btree.c
> +++ b/libxfs/xfs_da_btree.c
> @@ -612,6 +612,7 @@ xfs_da3_root_split(
>  	xfs_trans_log_buf(tp, bp, 0, size - 1);
>  
>  	bp->b_ops = blk1->bp->b_ops;
> +	xfs_trans_buf_copy_type(bp, blk1->bp);
>  	blk1->bp = bp;
>  	blk1->blkno = blkno;
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

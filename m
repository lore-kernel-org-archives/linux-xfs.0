Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E11607F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 23:23:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8B9A0AC004
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 21:23:17 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	3XNeUOBKXYkb83vj for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 21:23:16 -0700 (PDT)
Date: Tue, 25 Aug 2015 14:23:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: libxfs: verifier should set buffer error when da block has a bad
	magic number
Message-ID: <20150825042302.GH714@dastard>
References: <20150825040609.GT10043@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150825040609.GT10043@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 24, 2015 at 09:06:09PM -0700, Darrick J. Wong wrote:
> If xfs_da3_node_read_verify() doesn't recognize the magic number of a
> buffer it's just read, set the buffer error to -EFSCORRUPTED so that
> the error can be sent up to userspace.  Without this patch we'll
> ASSERT on the bad magic eventually while trying to traverse or change
> the block, but we really ought to fail fast in the verifier.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 2385f8c..ec4a5a1 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -238,6 +238,7 @@ xfs_da3_node_read_verify(
>  
>  	/* corrupt block */
>  	xfs_verifier_error(bp);
> +	xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  }

That should be in the default block of the switch statement,
otherwise it will overwrite the error from the node format crc/
verifier failures....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

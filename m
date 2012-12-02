Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB2NTA6n023424 for <xfs@oss.sgi.com>; Sun, 2 Dec 2012 17:29:11 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6FDx91xJ6CnioqqX for <xfs@oss.sgi.com>;
	Sun, 02 Dec 2012 15:31:31 -0800 (PST)
Date: Mon, 3 Dec 2012 10:31:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/3] xfs: use b_maps[] for discontiguous buffers
Message-ID: <20121202233128.GC29399@dastard>
References: <20121128222309.109033307@.sgi.com>
	<20121128222622.688093599@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121128222622.688093599@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 28, 2012 at 04:23:10PM -0600, Mark Tinguely wrote:
> Commits starting at 77c1a08 introduced a multiple segment support
> to xfs_buf. xfs_trans_buf_item_match() could not find a multi-segment
> buffer in the transaction because it was looking at the single segment
> block number rather than the multi-segment b_maps[0].bm.bn. This
> results on a recursive buffer lock that can never be satisfied.
> 
> This patch:
>  1) Changed the remaining b_map accesses to be b_maps[0] accesses.
>  2) Renames the single segment b_map structure to __b_map to avoid
>     future confusion.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

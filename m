Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAN1URW8008366 for <xfs@oss.sgi.com>; Thu, 22 Nov 2012 19:30:27 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	2tqD26TSGA89Edl1 for <xfs@oss.sgi.com>;
	Thu, 22 Nov 2012 17:32:37 -0800 (PST)
Date: Fri, 23 Nov 2012 12:32:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: use b_maps[] for discontiguous buffers
Message-ID: <20121123013234.GA32450@dastard>
References: <20121120224120.224166649@sgi.com>
	<20121120224146.376767354@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121120224146.376767354@sgi.com>
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

On Tue, Nov 20, 2012 at 04:41:21PM -0600, Mark Tinguely wrote:
> This patch sets all the b_bmap accesses to be b_maps[0]. b_maps[0]
> works for single and multiple segment buffers.
> 
> This fixes a bug where xfs_trans_buf_item_match() could not find a
> multi-segment buffer associated with the transaction because it was
> looking for the block number in the single segment location
> b_map.bm.bn rather than the new generic b_maps[0].bm.bn. This
> resulted in recursive buffer lock that can never be satisfied.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

Looks good, though I agree with Christoph that renaming b_map to
__b_map would be a good idea to prevent future confusion.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

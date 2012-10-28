Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9SM4Bhk068324 for <xfs@oss.sgi.com>; Sun, 28 Oct 2012 17:04:11 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	sdXU2bG4FgBu9We4 for <xfs@oss.sgi.com>;
	Sun, 28 Oct 2012 15:05:59 -0700 (PDT)
Date: Mon, 29 Oct 2012 09:05:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 1/3] xfs: Add ratelimited printk for different alert
	levels
Message-ID: <20121028220545.GB4353@dastard>
References: <cover.1348641483.git.rprabhu@wnohang.net>
	<ca71153845539b0c76ba3e3aab9611ad6c5cf72b.1348641483.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ca71153845539b0c76ba3e3aab9611ad6c5cf72b.1348641483.git.rprabhu@wnohang.net>
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
To: raghu.prabhu13@gmail.com
Cc: bpm@sgi.com, elder@kernel.org, Raghavendra D Prabhu <rprabhu@wnohang.net>, xfs@oss.sgi.com

On Wed, Sep 26, 2012 at 12:26:47PM +0530, raghu.prabhu13@gmail.com wrote:
> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
> 
> Ratelimited printk will be useful in printing xfs messages which are otherwise
> not required to be printed always due to their high rate (to prevent kernel ring
> buffer from overflowing), while at the same time required to be printed.
> 
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>

This is fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

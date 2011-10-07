Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p971vBFB212830 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 20:57:11 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 367EF1B3AF3
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 18:57:08 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Rgbd9tEXDLaL4bET for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 18:57:08 -0700 (PDT)
Date: Fri, 7 Oct 2011 12:57:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 9/9] xfs: remove xfs_buf_target_name
Message-ID: <20111007015707.GF3159@dastard>
References: <20111006210607.175284390@bombadil.infradead.org>
	<20111006210640.089607475@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111006210640.089607475@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Oct 06, 2011 at 05:06:16PM -0400, Christoph Hellwig wrote:
> The calling convention that returns a pointer to a static buffer is
> fairly nasty, so just opencode it in the only caller that is left.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

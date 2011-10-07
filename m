Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p971tOm6212778 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 20:55:25 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB3271442C51
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 19:02:13 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	E7p1g0Fl1axLa1DF for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 19:02:13 -0700 (PDT)
Date: Fri, 7 Oct 2011 12:55:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/9] xfs: use xfs_ioerror_alert in xfs_buf_iodone_callbacks
Message-ID: <20111007015521.GE3159@dastard>
References: <20111006210607.175284390@bombadil.infradead.org>
	<20111006210639.904713322@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111006210639.904713322@bombadil.infradead.org>
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

On Thu, Oct 06, 2011 at 05:06:15PM -0400, Christoph Hellwig wrote:
> Use xfs_ioerror_alert instead of opencoding a very similar error
> message.
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

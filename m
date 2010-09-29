Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8TBSuaj043625 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 06:28:56 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BE03E9130C
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 04:42:59 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	B6zKEYiZxSsBykFu for <xfs@oss.sgi.com>;
	Wed, 29 Sep 2010 04:42:59 -0700 (PDT)
Date: Wed, 29 Sep 2010 21:29:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] [PATCH 1/3] xfs: remove XFS_MOUNT_NO_PERCPU_SB
Message-ID: <20100929112920.GO5665@dastard>
References: <20100929072221.583672974@bombadil.infradead.org>
	<20100929072237.865681186@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100929072237.865681186@bombadil.infradead.org>
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

On Wed, Sep 29, 2010 at 03:22:22AM -0400, Christoph Hellwig wrote:
> Fail the mount if we can't allocate memory for the per-CPU counters.
> This is consistent with how we handle everything else in the mount
> path and makes the superblock counter modification a lot simpler.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.  I had an "XXX: kill XFS_MOUNT_NO_PERCPU_SB?" in my
patch, so no complaints about this from me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

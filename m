Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB14fjhh172248 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 22:41:45 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 265081C84AFC
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 20:43:26 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	XRnzkB4fcai7IwFH for <xfs@oss.sgi.com>;
	Tue, 30 Nov 2010 20:43:26 -0800 (PST)
Date: Wed, 1 Dec 2010 15:43:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/10] xfs: remove xfs_probe_cluster
Message-ID: <20101201044324.GH16922@dastard>
References: <20101122130506.868076797@bombadil.infradead.org>
	<20101122130904.341654979@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101122130904.341654979@bombadil.infradead.org>
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

On Mon, Nov 22, 2010 at 08:05:13AM -0500, Christoph Hellwig wrote:
> xfs_map_blocks always calls xfs_bmapi with the XFS_BMAPI_ENTIRE entire
> flag, which tells it to not cap the extent at the passed in size, but
> just treat the size as an minimum to map.  This means xfs_probe_cluster
> is entirely useless as we'll always get the whole extent back anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

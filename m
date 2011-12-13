Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBDNKJaK178684 for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 17:20:20 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46FD2156F9EF
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 15:20:18 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	gFnxrUs09Aciu0JY for <xfs@oss.sgi.com>;
	Tue, 13 Dec 2011 15:20:18 -0800 (PST)
Date: Wed, 14 Dec 2011 10:20:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/11] xfs: always return with the iolock held from
	xfs_file_aio_write_checks
Message-ID: <20111213232017.GH3179@dastard>
References: <20111208155755.323930705@bombadil.infradead.org>
	<20111208155919.215723395@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111208155919.215723395@bombadil.infradead.org>
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

On Thu, Dec 08, 2011 at 10:58:05AM -0500, Christoph Hellwig wrote:
> While xfs_iunlock is fine with 0 lockflags the calling conventions are much
> cleaner if xfs_file_aio_write_checks never returns without the iolock held.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I'm not sure this makes sense by itself. maybe combine it with the
next patch? Regardless:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

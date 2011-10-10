Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9A1btpM137662 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 20:37:55 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDF59152E972
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 18:45:00 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	wzk2qwqBvewz4k5d for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 18:45:00 -0700 (PDT)
Date: Mon, 10 Oct 2011 12:37:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: do not update xa_last_pushed_lsn for locked items
Message-ID: <20111010013749.GR3159@dastard>
References: <20111006183257.036884724@bombadil.infradead.org>
	<20111006183549.399127499@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111006183549.399127499@bombadil.infradead.org>
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
Cc: Stefan Priebe <s.priebe@profihost.ag>, xfs@oss.sgi.com

On Thu, Oct 06, 2011 at 02:32:58PM -0400, Christoph Hellwig wrote:
> If an item was locked we should not update xa_last_pushed_lsn and thus skip
> it when restarting the AIL scan as we need to be able to lock and write it
> out as soon as possible.  Otherwise heavy lock contention might starve AIL
> pushing too easily, especially given the larger backoff once we moved
> xa_last_pushed_lsn all the way to the target lsn.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Stefan Priebe <s.priebe@profihost.ag>
> Tested-by: Stefan Priebe <s.priebe@profihost.ag>

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN24Sxf071572 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 20:04:29 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 762E114789A9
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 18:06:26 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	NpiUX3OPZDB8q5Ke for <xfs@oss.sgi.com>;
	Wed, 22 Dec 2010 18:06:26 -0800 (PST)
Date: Thu, 23 Dec 2010 13:06:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: untangle phase1 vs phase2 recovery helpers
Message-ID: <20101223020623.GD18264@dastard>
References: <20101201220620.340188389@bombadil.infradead.org>
	<20101201220710.647499265@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101201220710.647499265@bombadil.infradead.org>
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

On Wed, Dec 01, 2010 at 05:06:24PM -0500, Christoph Hellwig wrote:
> Dispatch to a different helper for phase1 vs phase2 in xlog_recover_commit_trans
> instead of doing it in all the low-level functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Good cleanup. That'll make it much easier to work out how to
shoe-horn in item readahead to try to minimise log recovery times
for large logs...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB54UPDJ110576 for <xfs@oss.sgi.com>; Sun, 4 Dec 2011 22:30:25 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B34101DC1E4F
	for <xfs@oss.sgi.com>; Sun,  4 Dec 2011 20:30:22 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	sSShwy2k6WT13fQI for <xfs@oss.sgi.com>;
	Sun, 04 Dec 2011 20:30:22 -0800 (PST)
Date: Mon, 5 Dec 2011 15:09:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/16] xfs: remove the sync_mode argument to
	xfs_qm_dqflush_all
Message-ID: <20111205040954.GK7046@dastard>
References: <20111128082722.604873274@bombadil.infradead.org>
	<20111128082836.852396783@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128082836.852396783@bombadil.infradead.org>
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

On Mon, Nov 28, 2011 at 03:27:26AM -0500, Christoph Hellwig wrote:
> It always is zero, and removing it will make future changes easier.

Of course - there's only one caller ;)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

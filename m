Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB541GhH109433 for <xfs@oss.sgi.com>; Sun, 4 Dec 2011 22:01:16 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0918498EAE6
	for <xfs@oss.sgi.com>; Sun,  4 Dec 2011 20:01:12 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AMf0o691wZkIqAPg for <xfs@oss.sgi.com>;
	Sun, 04 Dec 2011 20:01:12 -0800 (PST)
Date: Mon, 5 Dec 2011 14:39:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: remove the deprecated nodelaylog option
Message-ID: <20111205033945.GE7046@dastard>
References: <20111128082522.224645690@bombadil.infradead.org>
	<20111128082556.867074573@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128082556.867074573@bombadil.infradead.org>
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

On Mon, Nov 28, 2011 at 03:25:23AM -0500, Christoph Hellwig wrote:
> The delaylog mode has been the default for a long time, and the nodelaylog
> option has been scheduled for removal in Linux 3.3.  Remove it and code
> only used by it now that we have opened the 3.3 window.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. I'm sure that further cleanups will now be more obvious
and easier to do.... :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

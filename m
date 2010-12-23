Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN1mlEK069219 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 19:48:47 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D67FB1CDBA2E
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 17:50:44 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	zmEIZLOPCFuRSuAX for <xfs@oss.sgi.com>;
	Wed, 22 Dec 2010 17:50:44 -0800 (PST)
Date: Thu, 23 Dec 2010 12:50:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: remove leftovers of old buffer log items in
	recovery code
Message-ID: <20101223015040.GA18264@dastard>
References: <20101201220620.340188389@bombadil.infradead.org>
	<20101201220710.042656730@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101201220710.042656730@bombadil.infradead.org>
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

On Wed, Dec 01, 2010 at 05:06:21PM -0500, Christoph Hellwig wrote:
> XFS used to support different types of buffer log items long time ago.
> Remove the switch statements checking the log item type in various
> buffer recovery helpers that were left over from those days and the
> rather useless xlog_recover_do_buffer_pass2 wrapper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. This should have been done when all the old unsupported
buffer formats were removed.

Reviewed-by: Dave Chinner <dchinner@redhat.com>


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

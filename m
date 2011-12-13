Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBDMM9af177127 for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 16:22:09 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8668C57C88B
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 14:22:07 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	gmTnHAqQp2mcuT0q for <xfs@oss.sgi.com>;
	Tue, 13 Dec 2011 14:22:07 -0800 (PST)
Date: Wed, 14 Dec 2011 09:21:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/11] xfs: replace i_pin_wait with a bit waitqueue
Message-ID: <20111213222158.GE3179@dastard>
References: <20111208155755.323930705@bombadil.infradead.org>
	<20111208155918.662107724@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111208155918.662107724@bombadil.infradead.org>
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

On Thu, Dec 08, 2011 at 10:58:02AM -0500, Christoph Hellwig wrote:
> Replace i_pin_wait, which is only used during synchronous inode flushing
> with a bit waitqueue.  This trades off a much smaller inode against
> slightly slower wakeup performance, and saves 12 (32-bit) or 20 (64-bit)
> bytes in the XFS inode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alex Elder <aelder@sgi.com>

Looks fine - the pinning code never modifies the i_flags field, so
doesn't require the i_flags_lock anywhere so the concerns i had
about the previous patch are not relevant here...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

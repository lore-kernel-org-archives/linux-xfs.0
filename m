Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB54SnOb110502 for <xfs@oss.sgi.com>; Sun, 4 Dec 2011 22:28:49 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D874C4D8212
	for <xfs@oss.sgi.com>; Sun,  4 Dec 2011 20:28:47 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9csvdetHpFGBio8Y for <xfs@oss.sgi.com>;
	Sun, 04 Dec 2011 20:28:47 -0800 (PST)
Date: Mon, 5 Dec 2011 15:17:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/16] xfs: cleanup xfs_qm_dqlookup
Message-ID: <20111205041732.GM7046@dastard>
References: <20111128082722.604873274@bombadil.infradead.org>
	<20111128082837.263453373@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128082837.263453373@bombadil.infradead.org>
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

On Mon, Nov 28, 2011 at 03:27:28AM -0500, Christoph Hellwig wrote:
> Rearrange the code to avoid the conditional locking around the flist_locked
> variable.  This means we lose a (rather pointless) assert, and hold the
> freelist lock a bit longer for one corner case.

Hardly worth mentioning that corner case - all we do is hold the
mutex while doing a XFS_DQHOLD() instead of dropping it first, which
we do for the other case, anyway.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Otherwise,

Reviewed-by: Dave Chinner <dchinner@redhat.com>


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

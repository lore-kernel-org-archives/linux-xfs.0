Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBDK2hDB170565 for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 14:02:44 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 009EF1D3A916
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 11:45:00 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	KltUEuOaJZ70aGZy for <xfs@oss.sgi.com>;
	Tue, 13 Dec 2011 11:45:00 -0800 (PST)
Date: Wed, 14 Dec 2011 06:44:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 12/19] xfs: flatten the dquot lock ordering
Message-ID: <20111213194457.GD14273@dastard>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215854.769664827@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206215854.769664827@bombadil.infradead.org>
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

On Tue, Dec 06, 2011 at 04:58:18PM -0500, Christoph Hellwig wrote:
> Introduce a new XFS_DQ_FREEING flag that tells lookup and mplist walks
> to skip a dquot that is beeing freed, and use this avoid the trylock
> on the hash and mplist locks in xfs_qm_dqreclaim_one.  Also simplify
> xfs_dqpurge by moving the inodes to a dispose list after marking them
> XFS_DQ_FREEING and avoid the locker ordering constraints.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me withthe coment updates.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

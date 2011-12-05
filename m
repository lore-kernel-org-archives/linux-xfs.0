Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB541LvE109458 for <xfs@oss.sgi.com>; Sun, 4 Dec 2011 22:01:22 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DDA6698EBA5
	for <xfs@oss.sgi.com>; Sun,  4 Dec 2011 20:01:20 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ga5xKwiZFpd3B1xC for <xfs@oss.sgi.com>;
	Sun, 04 Dec 2011 20:01:20 -0800 (PST)
Date: Mon, 5 Dec 2011 14:57:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/16] xfs: untange SYNC_WAIT and SYNC_TRYLOCK meanings
	for xfs_qm_dqflush
Message-ID: <20111205035751.GH7046@dastard>
References: <20111128082722.604873274@bombadil.infradead.org>
	<20111128082836.344682532@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128082836.344682532@bombadil.infradead.org>
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

On Mon, Nov 28, 2011 at 03:27:23AM -0500, Christoph Hellwig wrote:
> Only skip pinned dquots if SYNC_TRYLOCK is specified, and adjust the callers
> to keep the behaviour unchanged.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yup, matches all the way th inode flush code is driven now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

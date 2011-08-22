Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7M6SZja035805 for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 01:28:35 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94A861DA2B6D
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2011 23:28:33 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1PevRCMfGGx34hEn for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2011 23:28:33 -0700 (PDT)
Date: Mon, 22 Aug 2011 16:26:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: use the "delwri" terminology consistently
Message-ID: <20110822062644.GJ3162@dastard>
References: <20110814171517.174040686@bombadil.infradead.org>
	<20110814171652.809674388@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110814171652.809674388@bombadil.infradead.org>
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

On Sun, Aug 14, 2011 at 01:15:23PM -0400, Christoph Hellwig wrote:
> And also remove the strange local lock and delwri list pointers in a few
> functions.

Agreed, now that the code is simpler than it used to be, the local
variables are not needed anymore.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

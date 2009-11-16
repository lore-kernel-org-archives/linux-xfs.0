Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAG3Kf0B075248 for <xfs@oss.sgi.com>; Sun, 15 Nov 2009 21:20:41 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94E5C1881058
	for <xfs@oss.sgi.com>; Sun, 15 Nov 2009 19:21:01 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	JEdCJpGmcevxij3F for <xfs@oss.sgi.com>;
	Sun, 15 Nov 2009 19:21:01 -0800 (PST)
Date: Mon, 16 Nov 2009 14:20:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/7] xfs: kill the STATIC_INLINE macro
Message-ID: <20091116032057.GF9467@discord.disaster>
References: <20091114161717.233372584@bombadil.infradead.org>
	<20091114161801.978180093@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091114161801.978180093@bombadil.infradead.org>
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

On Sat, Nov 14, 2009 at 11:17:22AM -0500, Christoph Hellwig wrote:
> Remove our own STATIC_INLINE macro.  For small function inside implementation
> files just use STATIC and let gcc inline it, and for those in headers do the
> normal static inline - they are all small enough to be inlined for debug
> builds, too.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

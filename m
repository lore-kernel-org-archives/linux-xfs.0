Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAG3Gijo074848 for <xfs@oss.sgi.com>; Sun, 15 Nov 2009 21:16:44 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DACB118812A3
	for <xfs@oss.sgi.com>; Sun, 15 Nov 2009 19:17:04 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	Gf7grsCUbD6EhYl7 for <xfs@oss.sgi.com>;
	Sun, 15 Nov 2009 19:17:04 -0800 (PST)
Date: Mon, 16 Nov 2009 14:17:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/7] xfs: rename xfs_attr_fetch to xfs_attr_get_int
Message-ID: <20091116031702.GD9467@discord.disaster>
References: <20091114161717.233372584@bombadil.infradead.org>
	<20091114161801.612419979@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091114161801.612419979@bombadil.infradead.org>
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

On Sat, Nov 14, 2009 at 11:17:20AM -0500, Christoph Hellwig wrote:
> Using a totally different name for the lowlevel get operation does not
> fit the _int convention used in the rest of the attr code, so rename it.
> 
> While we're at it also fix the prototype to use the normal convention
> and mark it static as it's never used outside of xfs_attr.c.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

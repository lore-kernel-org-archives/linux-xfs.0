Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0BN7p5r008531 for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 17:07:51 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E28E179C7B2
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 15:07:50 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	rDZO5xeloJo4wPiB for <xfs@oss.sgi.com>;
	Sun, 11 Jan 2009 15:07:50 -0800 (PST)
Date: Mon, 12 Jan 2009 10:07:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/7] xfs: add a lock class for group/project dquots
Message-ID: <20090111230747.GF8071@disturbed>
References: <20090109221104.237540000@bombadil.infradead.org>
	<20090109221300.927598000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090109221300.927598000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

On Fri, Jan 09, 2009 at 05:11:09PM -0500, Christoph Hellwig wrote:
> We can have both a user and a group/project dquot locked at the same time,
> as long as the user dquot is locked first.  Tell lockdep about that fact
> by making the group/project dquots a different lock class.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

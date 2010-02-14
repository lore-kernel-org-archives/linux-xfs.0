Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1ENDc5S006051 for <xfs@oss.sgi.com>; Sun, 14 Feb 2010 17:13:39 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B0A021CE00E
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2010 15:14:54 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	I3T7L3b8sWMVOjVA for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2010 15:14:54 -0800 (PST)
Date: Mon, 15 Feb 2010 10:14:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: use blkid raw mode
Message-ID: <20100214231451.GE28392@discord.disaster>
References: <20100214220753.GB14927@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100214220753.GB14927@infradead.org>
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

On Sun, Feb 14, 2010 at 05:07:53PM -0500, Christoph Hellwig wrote:
> blkid without options usually gets no probe results at all just after
> creating a filesystem.  This problem is due to the cache that blkid
> uses in it's default mode, and is unlikely to get fixed.  Use the -p
> option to bypass the cache layer.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Make sense.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

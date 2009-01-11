Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0BNKf4D010018 for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 17:20:41 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CB6FF17D77D7
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 15:08:55 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	eo6dSXZij1Bl0AbK for <xfs@oss.sgi.com>;
	Sun, 11 Jan 2009 15:08:55 -0800 (PST)
Date: Mon, 12 Jan 2009 10:08:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/7] xfs: use mnt_want_write in compat_attrmulti ioctl
Message-ID: <20090111230852.GG8071@disturbed>
References: <20090109221104.237540000@bombadil.infradead.org>
	<20090109221259.664448000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090109221259.664448000@bombadil.infradead.org>
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

On Fri, Jan 09, 2009 at 05:11:06PM -0500, Christoph Hellwig wrote:
> The compat version of the attrmulti ioctl needs to ask for and then
> later release write access to the mount just like the native version,
> otherwise we could potentially write to read-only mounts.
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

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4Q6A9cm065337 for <xfs@oss.sgi.com>; Wed, 26 May 2010 01:10:09 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97765A52B76
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 23:14:13 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	EtfOdjU1cDoqwGcT for <xfs@oss.sgi.com>;
	Tue, 25 May 2010 23:14:13 -0700 (PDT)
Date: Wed, 26 May 2010 16:12:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2 v2] xfs: drop dmapi hooks
Message-ID: <20100526061226.GP2150@dastard>
References: <20100510140823.GA16540@infradead.org>
	<20100525094524.GA1647@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100525094524.GA1647@infradead.org>
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

On Tue, May 25, 2010 at 05:45:24AM -0400, Christoph Hellwig wrote:
> Dmapi support was never merged upstream, but we still have a lot of hooks
> bloating XFS for it, all over the fast pathes of the filesystem.
> 
> This patch drops over 700 lines of dmapi overhead.  If we'll ever get HSM
> support in mainline at least the namespace events can be done much saner
> in the VFS instead of the individual filesystem, so it's not like this
> is much help for future work.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

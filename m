Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n974esn6160969 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 23:40:55 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1FD464A9319
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 21:42:19 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	1Yee9rBYa7urPu34 for <xfs@oss.sgi.com>;
	Tue, 06 Oct 2009 21:42:19 -0700 (PDT)
Date: Wed, 7 Oct 2009 15:42:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs: add discard support
Message-ID: <20091007044215.GK9464@discord.disaster>
References: <20091006184758.GA4780@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091006184758.GA4780@infradead.org>
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

On Tue, Oct 06, 2009 at 02:47:58PM -0400, Christoph Hellwig wrote:
> Call the BLKDISCARD ioctl to mark the whole disk as unused before creating
> a new filesystem.  This will allow SSDs, Arrays with thin provisioning support
> and virtual machines to make smarter allocation decisions.

Good idea, but perhaps the discard should be optional rather than
unconditional.  My immediate thought was the SOP for setting up
encrypted devices - fill the empty disk with random data before
setting up the encrypted device. If you then send it a discard....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

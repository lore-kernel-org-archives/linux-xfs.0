Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAULx00C143150 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 15:59:01 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24D0E1C83D72
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 14:00:42 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	ESW2cbbFGB1EPGzL for <xfs@oss.sgi.com>;
	Tue, 30 Nov 2010 14:00:42 -0800 (PST)
Date: Wed, 1 Dec 2010 09:00:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: don't truncate prealloc from frequently
	accessed inodes
Message-ID: <20101130220038.GH3556@dastard>
References: <1290991431-20519-1-git-send-email-david@fromorbit.com>
	<1290991431-20519-3-git-send-email-david@fromorbit.com>
	<20101130170301.GA5712@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101130170301.GA5712@infradead.org>
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

On Tue, Nov 30, 2010 at 12:03:01PM -0500, Christoph Hellwig wrote:
> Did any problems show up with just trying to use an inode flag instead
> of the counter?  I'd really hate to bloat the inode without reason.

None that I've noticed in local testing, but I haven't been
focussing on this aspect so I hadn't changed it. I'll change it to a
flag, and we can go back to a counter if necessary.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

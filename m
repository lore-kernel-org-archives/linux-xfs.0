Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1HJSLJW255077 for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 13:28:23 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F9501DA64A
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 11:29:39 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 24GL81T2I6wXiBD3 for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2010 11:29:39 -0800 (PST)
Date: Wed, 17 Feb 2010 14:29:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Non-blocking inode locking in IO completion
Message-ID: <20100217192938.GA14015@infradead.org>
References: <1266384989-28928-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1266384989-28928-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Feb 17, 2010 at 04:36:29PM +1100, Dave Chinner wrote:
> The introduction of barriers to DM loop devices (e.g. dm-crypt) has
> created a new IO order completion dependency that XFS does not
> handle. That is, the completion of log IOs (which have barriers) in
> the loop filesystem are now dependent on completion of data IO in
> the backing filesystem.

I don't think dm belongs into the picture here at all.  The problem
is simply with the loop device, which sits below dm-crypt in the
bugzilla reports.  The loop device in SuSE (and for a short time in
mainline until we saw unexplainable XFS lockups) implements barriers
using fsync.  Now that fsync turns a log I/O that issues a barrier
in the XFS filesystem inside the loop device into a data I/O the
backing filesystem.  With this the rest of your description applies
again.

The patch looks good to me - while I hate introducing random delay()
calls I don't really see a way around this. 

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1ICXwYO050440 for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 06:34:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4865C1DD224
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 04:35:17 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id CLZEiU3iwanPm9gl for
	<xfs@oss.sgi.com>; Thu, 18 Feb 2010 04:35:17 -0800 (PST)
Date: Thu, 18 Feb 2010 07:35:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Non-blocking inode locking in IO completion
Message-ID: <20100218123512.GA6016@infradead.org>
References: <1266384989-28928-1-git-send-email-david@fromorbit.com>
	<20100217192938.GA14015@infradead.org>
	<20100217211312.GQ28392@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100217211312.GQ28392@discord.disaster>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Feb 18, 2010 at 08:13:12AM +1100, Dave Chinner wrote:
> > The patch looks good to me - while I hate introducing random delay()
> > calls I don't really see a way around this. 
> 
> I thought about using queue_delayed_work(), but then the change
> became much bigger and has other side effects like increasing the
> size of the ioend structure.

Yes, now that the normal work struct and the delayed work struct are
different it would be a pain, agreed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

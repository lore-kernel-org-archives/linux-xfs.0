Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1HLBwxt261909 for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 15:11:58 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D247E1DAC0F
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 13:13:15 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	m8pTAJH0o0kmflj2 for <xfs@oss.sgi.com>;
	Wed, 17 Feb 2010 13:13:15 -0800 (PST)
Date: Thu, 18 Feb 2010 08:13:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Non-blocking inode locking in IO completion
Message-ID: <20100217211312.GQ28392@discord.disaster>
References: <1266384989-28928-1-git-send-email-david@fromorbit.com>
	<20100217192938.GA14015@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100217192938.GA14015@infradead.org>
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

On Wed, Feb 17, 2010 at 02:29:38PM -0500, Christoph Hellwig wrote:
> On Wed, Feb 17, 2010 at 04:36:29PM +1100, Dave Chinner wrote:
> > The introduction of barriers to DM loop devices (e.g. dm-crypt) has
> > created a new IO order completion dependency that XFS does not
> > handle. That is, the completion of log IOs (which have barriers) in
> > the loop filesystem are now dependent on completion of data IO in
> > the backing filesystem.
> 
> I don't think dm belongs into the picture here at all.  The problem
> is simply with the loop device, which sits below dm-crypt in the
> bugzilla reports.  The loop device in SuSE (and for a short time in
> mainline until we saw unexplainable XFS lockups) implements barriers
> using fsync.  Now that fsync turns a log I/O that issues a barrier
> in the XFS filesystem inside the loop device into a data I/O the
> backing filesystem.  With this the rest of your description applies
> again.

Fair point. I'll change the description to be more accurate.

> The patch looks good to me - while I hate introducing random delay()
> calls I don't really see a way around this. 

I thought about using queue_delayed_work(), but then the change
became much bigger and has other side effects like increasing the
size of the ioend structure.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

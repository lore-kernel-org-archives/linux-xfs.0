Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OJDZVV047824 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 14:13:35 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	UcGQfRrXSIo8rp4Z for <xfs@oss.sgi.com>;
	Wed, 24 Oct 2012 12:15:18 -0700 (PDT)
Date: Thu, 25 Oct 2012 06:15:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH 0/2] fiemap: filesystem free space mapping
Message-ID: <20121024191515.GU4291@dastard>
References: <1350537079-16246-1-git-send-email-david@fromorbit.com>
	<20121023123044.GG7341@infradead.org>
	<20121023215313.GQ4291@dastard> <20121024114711.GB11262@shiny>
	<20121024150951.GA24318@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121024150951.GA24318@infradead.org>
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
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Chris Mason <chris.mason@fusionio.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Oct 24, 2012 at 11:09:51AM -0400, Christoph Hellwig wrote:
> On Wed, Oct 24, 2012 at 07:47:17AM -0400, Chris Mason wrote:
> > I'm all for it in the main fiemap call, it makes much more sense for the
> > users I think.
> 
> How so?  Current fiemap is a per-inode information, Daves new call is
> per-fs.  Making one a flag of another is a gross user interface.  In
> addition we're bound to get issue where filesystems fail to wire up
> fiemap to the tons of different iops just for this operation, or
> accidentally wire up "real" fiemap to things like special files or
> pipes.
> 
> Btw, I'd like t orestate that I really love to see this functionality in
> the VFS, just not multiplexed over FIEMAP.

That's fine. I just wanted to clarify what you were asking.
FIEMAPFS it is, then...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

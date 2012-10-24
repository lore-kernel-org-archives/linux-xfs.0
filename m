Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OF8BT1018111 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 10:08:11 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	yMAzHvV5AO9A75jD (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Oct 2012 08:09:55 -0700 (PDT)
Date: Wed, 24 Oct 2012 11:09:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC, PATCH 0/2] fiemap: filesystem free space mapping
Message-ID: <20121024150951.GA24318@infradead.org>
References: <1350537079-16246-1-git-send-email-david@fromorbit.com>
	<20121023123044.GG7341@infradead.org>
	<20121023215313.GQ4291@dastard> <20121024114711.GB11262@shiny>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121024114711.GB11262@shiny>
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
To: Chris Mason <chris.mason@fusionio.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Oct 24, 2012 at 07:47:17AM -0400, Chris Mason wrote:
> I'm all for it in the main fiemap call, it makes much more sense for the
> users I think.

How so?  Current fiemap is a per-inode information, Daves new call is
per-fs.  Making one a flag of another is a gross user interface.  In
addition we're bound to get issue where filesystems fail to wire up
fiemap to the tons of different iops just for this operation, or
accidentally wire up "real" fiemap to things like special files or
pipes.

Btw, I'd like t orestate that I really love to see this functionality in
the VFS, just not multiplexed over FIEMAP.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

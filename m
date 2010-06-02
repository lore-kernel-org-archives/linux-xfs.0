Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o526BTj4055732 for <xfs@oss.sgi.com>; Wed, 2 Jun 2010 01:11:29 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFB8D130D447
	for <xfs@oss.sgi.com>; Tue,  1 Jun 2010 23:16:17 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	x2kolfaHNZHXm8zF for <xfs@oss.sgi.com>;
	Tue, 01 Jun 2010 23:16:17 -0700 (PDT)
Date: Wed, 2 Jun 2010 16:13:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/17] pending patches
Message-ID: <20100602061353.GR7011@dastard>
References: <20100531160727.842750532@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100531160727.842750532@bombadil.infradead.org>
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

On Mon, May 31, 2010 at 12:07:27PM -0400, Christoph Hellwig wrote:
> Here's my list of pending patches.  Ordering them is getting a bit
> difficult as various patches that have been out of a while haven't
> been commited yet.  Note that some patches require Dave's
> 
> 	[PATCH] xfs: fix race in inode cluster freeing failing to stale inodes
> 
> applies first.  That patch is a clear candidate for something that
> should go to Linus ASAP IHMO.

That's a fine set of cleanups, Christoph:

79 files changed, 974 insertions(+), 3106 deletions(-)

I'm still running it through QA. If it survives another day or so
I'll push them all out into my git tree for Alex....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

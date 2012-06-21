Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5L7DNha006892 for <xfs@oss.sgi.com>; Thu, 21 Jun 2012 02:13:23 -0500
Date: Thu, 21 Jun 2012 03:13:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] types.h: implement intptr_t and uintptr_t
Message-ID: <20120621071319.GC5106@infradead.org>
References: <1338487534-14575-1-git-send-email-jengelh@inai.de>
	<20120620075216.GA24798@infradead.org>
	<20120620230232.GN30705@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120620230232.GN30705@dastard>
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
Cc: bpm@sgi.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Jan Engelhardt <jengelh@inai.de>, joe@perches.com, xfs@oss.sgi.com

On Thu, Jun 21, 2012 at 09:02:32AM +1000, Dave Chinner wrote:
> On Wed, Jun 20, 2012 at 03:52:16AM -0400, Christoph Hellwig wrote:
> > I'd really like to get Jans type cleanups in XFS in for the next
> > merge window.  Given the lack of feedback on lkml in favor or
> > against (u)intptr_t I'm tempted to add them to xfs_linux.h for now,
> > and then do another push to propagate them to kernel-wide types later.
> > 
> > Is that fine with everybody?
> 
> I'd just push it into the XFS tree and into linux-next. It's a
> relatively harmless set of changes, and if nobody cares enough about
> it except us, just push it and see what happens when people start
> noticing the conflicts it might cause....

Given that's it's been out on lkml for a while that sounds at least
okay-ish.  I just fear we might get dragged into a long discussion when
then pull request is sent.  Just adding the types locally and moving
them to types.h in a single patch avoids that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

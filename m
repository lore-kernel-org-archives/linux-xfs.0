Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAQMwLfG238495 for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 16:58:21 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	BPFkfSHyWpThDCdD for <xfs@oss.sgi.com>;
	Mon, 26 Nov 2012 15:00:35 -0800 (PST)
Date: Tue, 27 Nov 2012 10:00:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: inode allocation should use unmapped buffers.
Message-ID: <20121126230033.GS32450@dastard>
References: <1353641065-14983-1-git-send-email-david@fromorbit.com>
	<1353641065-14983-2-git-send-email-david@fromorbit.com>
	<20121126221253.GH27055@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121126221253.GH27055@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Nov 26, 2012 at 04:12:53PM -0600, Ben Myers wrote:
> Hi Dave,
> 
> On Fri, Nov 23, 2012 at 02:24:23PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Inode buffers do not need to be mapped as inodes are read or written
> > directly from/to the pages underlying the buffer. This fixes a
> > regression introduced by commit 611c994 ("xfs: make XBF_MAPPED the
> > default behaviour").
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Dave Chinner <david@fromorbit.com>
> 
> committed to git://oss.sgi.com/xfs/xfs.git, master and for-next.
> 
> What's with the multiple Signed-off-by?  Is your cousin Dave getting involved
> in XFS development too?  Welcome!  ;)

Ah, I forgot the "-s" flag to guilt patchbomb which prevents it
git-send-email from adding signed-off-by lines from the local
repository committer. That's my mistake (it's the first time I've
ever done that), you can kill the ones from the david@fromorbit.com
address.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

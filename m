Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3U1BrEs179343 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 20:11:53 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	51rZXPaBoTbGEUrp for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 18:11:51 -0700 (PDT)
Date: Mon, 30 Apr 2012 11:11:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/3] xfs: make largest supported offset less shouty
Message-ID: <20120430011124.GD3283@dastard>
References: <1335519922-14371-1-git-send-email-david@fromorbit.com>
	<20120429125729.GU9541@dastard>
	<20120429215830.GQ19889@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120429215830.GQ19889@infradead.org>
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

On Sun, Apr 29, 2012 at 05:58:30PM -0400, Christoph Hellwig wrote:
> On Sun, Apr 29, 2012 at 10:57:29PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > XFS_MAXIOFFSET() is just a simple macro that resolves to
> > mp->m_maxioffset. It doesn't need to exist, and it just makes the
> > code unnecessarily loud and shouty.
> > 
> > Make it quiet and easy to read.
> 
> Do we actually need to keep around a value in our superblock?
> s_maxbytes in the VFS superblock already does this, and it seems like
> at least our checks in the read path are superflous.

Ah, we do indeed keep the same value in s_maxbytes - that's one step
removed from m_maxioffset because it uses the same function to
calculate it, and they are done a long way apart. Ok, it looks like
I've got a couple more patches to write to finish off this cleanup.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3U33Zfs191702 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 22:03:35 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	KKu7q1zcsvYX0hsS for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 20:03:33 -0700 (PDT)
Date: Mon, 30 Apr 2012 13:03:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/3] xfs: make largest supported offset less shouty
Message-ID: <20120430030330.GF7015@dastard>
References: <1335519922-14371-1-git-send-email-david@fromorbit.com>
	<20120429125729.GU9541@dastard>
	<20120429215830.GQ19889@infradead.org>
	<20120430011124.GD3283@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120430011124.GD3283@dastard>
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

On Mon, Apr 30, 2012 at 11:11:24AM +1000, Dave Chinner wrote:
> On Sun, Apr 29, 2012 at 05:58:30PM -0400, Christoph Hellwig wrote:
> > On Sun, Apr 29, 2012 at 10:57:29PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > XFS_MAXIOFFSET() is just a simple macro that resolves to
> > > mp->m_maxioffset. It doesn't need to exist, and it just makes the
> > > code unnecessarily loud and shouty.
> > > 
> > > Make it quiet and easy to read.
> > 
> > Do we actually need to keep around a value in our superblock?
> > s_maxbytes in the VFS superblock already does this, and it seems like
> > at least our checks in the read path are superflous.

Actually, I can't find where the read path checks against
s_maxbytes. It's not in generic_segment_check(), and there appears
to be no other range checks in the VFS. So I think that the check we
have in xfs_file_aio_read needs to remain....

> Ah, we do indeed keep the same value in s_maxbytes - that's one step
> removed from m_maxioffset because it uses the same function to
> calculate it, and they are done a long way apart. Ok, it looks like
> I've got a couple more patches to write to finish off this cleanup.

Still, we can now replace the copy-n-paste code in
xfs_file_aio_read() with a call to generic_segment_check() seeing as
it returns a sum of the iovec length now, and still kill
m_maxioffset....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

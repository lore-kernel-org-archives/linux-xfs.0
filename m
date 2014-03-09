Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B0D177F50
	for <xfs@oss.sgi.com>; Sat,  8 Mar 2014 18:33:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5B4A6AC003
	for <xfs@oss.sgi.com>; Sat,  8 Mar 2014 16:32:58 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Z52VGqvBDKLVDgiY for <xfs@oss.sgi.com>;
	Sat, 08 Mar 2014 16:32:56 -0800 (PST)
Date: Sun, 9 Mar 2014 11:32:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH] xfs: make superblock version checks reflect reality
Message-ID: <20140309003254.GU6851@dastard>
References: <1394088890-10713-1-git-send-email-david@fromorbit.com>
	<20140306180534.GA305@infradead.org>
	<20140306225541.GL6851@dastard>
	<20140307101527.GC32333@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140307101527.GC32333@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Mar 07, 2014 at 02:15:27AM -0800, Christoph Hellwig wrote:
> On Fri, Mar 07, 2014 at 09:55:41AM +1100, Dave Chinner wrote:
> > > I'd vote to kill XFS_SB_NEEDED_FEATURES and just check the dirv2 bit
> > > explicitly.
> > 
> > Ok. The only real reason I did this was in case there's a single bit
> > error that clears the dirv2 bit, but it still contains other bits
> > that indicate that the superblock is recent enough that we
> > understand it's contents and what should bein the fs.  e.g. for
> > db/repair purposes - if the dir2 bit is not set, but any of the
> > above bits are set and the m_dirblklog is and it is sane, we can
> > assume that we've lost the feature bit and repair it.
> 
> Seems like we should just special case that in repair instead of
> allowing a filesystem to go through in the kernel that is guaranteed to
> be corrupted.

Ok, that makes a lot of sense. I'll change it to do that.

> > Should I just drop it out of the supported feature matrix and drop
> > all other checks on that field? That way we can then remove all the
> > the crap that tries to validate it from xfs_repair, too. I have no
> > idea what is actually valid for this field, so I think we should
> > simply drop support of it from everything.
> 
> I think we should pretending we know anything about the shared mount
> support.  Everytime it came up I failed to find any hint on how it was
> supposed to work.

*nod*. I'll drop the shared bit from the supported matrix, and also
treat sb_shared_vn != 0 a corruption.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

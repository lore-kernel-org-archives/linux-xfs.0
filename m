Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 938627F51
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 15:27:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 27A5BAC007
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 13:27:44 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ACnsztg05McJCKy9 for <xfs@oss.sgi.com>;
	Thu, 23 Jan 2014 13:27:40 -0800 (PST)
Date: Fri, 24 Jan 2014 08:27:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] libxfs: remove map from libxfs_readbufr_map
Message-ID: <20140123212735.GW13997@dastard>
References: <1390375033-10483-1-git-send-email-david@fromorbit.com>
	<1390375033-10483-3-git-send-email-david@fromorbit.com>
	<52E14E1E.8040605@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52E14E1E.8040605@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 23, 2014 at 12:15:10PM -0500, Brian Foster wrote:
> On 01/22/2014 02:17 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The map passed in to libxfs_readbufr_map is used to check the buffer
> > matches the map. However, the repair readahead code has no map it
> > can use to validate the buffer it set up previously, so just get rid
> > of the map being passed in because it serves no useful purpose.
> > 
> 
> The code looks fine, effectively just removing some assert code, but I'm
> not following the reasoning. I'm probably missing some context. Is the
> justification that no callers of libxfs_readbufr_map() will actually
> pass a map, or that the checking is not useful (redundant)?

Lets start with "redundant".

The libxfs_readbuf_map() call passes in the map it just passed to
libxfs_getbuf_map() - there's no real point to testing it as we've
got bigger problems if libxfs_getbuf_map() doesn't build the buffer
correctly from the map.

The call in db/io.c passes in the same map that was
passed to libxfs_readbuf_map(), which means it's checking the buffer
multiple times against the same map. Again, redundant because
the only thing that has a reference to the buffer is the db IO code.

Now API consistency:

libxfs_writebufr() has no requirement for a map for checking,
and takes no parameters other than the buffer and trusts the buffer
to be set up correctly. It treats both contiguous and discontiguous
buffers the same way.

libxfs_readbufr() takes a blkno/len because there are use cases
for partial buffer reads which we don't have for discontiguous
buffers.

Hence we don't need to pass a map to libxfs_readbuf_map()
for any functional reason. And seeing as libxfs_writebufr() already
trusts libxfs_getbuf_map() to set up a discontiguous buffer
correctly, I don't see why the read path should be any different.

Now for correctness:

The ASSERT code is not built in by default. It's pretty
obvious it has never been used because:

> > +libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
> >  {
> >  	int	fd = libxfs_device_to_fd(btp->dev);
> >  	int	error = 0;
> >  	char	*buf;
> >  	int	i;
> >  
> > -	ASSERT(BBTOB(len) <= bp->b_bcount);

It's obviously broken.

In summary, the map being passed in is unused, untested, redundant
and broken....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6428B7FEE
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 10:26:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 44F7A304062
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 08:26:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bOqpeMU0fE7MZBzg for
	<xfs@oss.sgi.com>; Fri, 04 Apr 2014 08:26:41 -0700 (PDT)
Date: Fri, 4 Apr 2014 11:26:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/6] xfs: write failure beyond EOF truncates too much data
Message-ID: <20140404152636.GA40629@bfoster.bfoster>
References: <1395396710-3824-1-git-send-email-david@fromorbit.com>
	<1395396710-3824-3-git-send-email-david@fromorbit.com>
	<20140329151419.GA33827@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140329151419.GA33827@bfoster.bfoster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Viro@disappointment.disaster, viro@ZenIV.linux.org.uk, Al@disappointment.disaster

On Sat, Mar 29, 2014 at 11:14:19AM -0400, Brian Foster wrote:
> On Fri, Mar 21, 2014 at 09:11:46PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > If we fail a write beyond EOF and have to handle it in
> > xfs_vm_write_begin(), we truncate the inode back to the current inode
> > size. This doesn't take into account the fact that we may have
> > already made successful writes to the same page (in the case of block
> > size < page size) and hence we can truncate the page cache away from
> > blocks with valid data in them. If these blocks are delayed
> > allocation blocks, we now have a mismatch between the page cache and
> > the extent tree, and this will trigger - at minimum - a delayed
> > block count mismatch assert when the inode is evicted from the cache.
> > We can also trip over it when block mapping for direct IO - this is
> > the most common symptom seen from fsx and fsstress when run from
> > xfstests.
> > 
> > Fix it by only truncating away the exact range we are updating state
> > for in this write_begin call.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_aops.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index e810243..6b4ecc8 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -1609,12 +1609,18 @@ xfs_vm_write_begin(
> >  	status = __block_write_begin(page, pos, len, xfs_get_blocks);
> >  	if (unlikely(status)) {
> >  		struct inode	*inode = mapping->host;
> > +		size_t		isize = i_size_read(inode);
> >  
> >  		xfs_vm_write_failed(inode, page, pos, len);
> >  		unlock_page(page);
> >  
> > -		if (pos + len > i_size_read(inode))
> > -			truncate_pagecache(inode, i_size_read(inode));
> 
> From what I can see, we have a write_begin/copy/write_end sequence per
> page and the inode size is updated down in the write_end path. If the
> write fails at write_begin time, then we haven't copied any data and the
> inode size hasn't changed.
> 
> The intent of the original code looks like it wants to break off any
> blocks that might have been set up beyond EOF before the write happened
> to fail. Could you elaborate on how this can kill blocks that might have
> been written successfully? Doesn't this only affect post-EOF metadata?
> 
> > +		/*
> > +		 * If the write is beyond EOF, we only want to kill blocks
> > +		 * allocated in this write, not blocks that were previously
> > +		 * written successfully.
> > +		 */
> > +		if (pos + len > isize)
> > +			truncate_pagecache_range(inode, pos, pos + len);
> 
> So the cache truncate now covers the range of the write. What happens if
> the part of the write is an overwrite? This seems similar to the problem
> you've described above... should the truncate start at isize instead?
> 

I ran an experiment on this to confirm my suspicion here. I added a
quick little hack to fail any write_begin (set status=-1) for which pos
!= 0. With that in place:

xfs_io -fc "pwrite -b 2k 0 2k" /mnt/file

# hexdump /mnt/file 
0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
*
0000800

xfs_io -c "pwrite -b 2k 1k 2k" /mnt/file
(fails)

# hexdump /mnt/file 
0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
*
0000400 0000 0000 0000 0000 0000 0000 0000 0000
*
0000800

The failed extending write trashes the data over the previously valid
region.

Brian

> Brian
> 
> >  
> >  		page_cache_release(page);
> >  		page = NULL;
> > -- 
> > 1.9.0
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

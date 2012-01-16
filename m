Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0GJjUqJ110132 for <xfs@oss.sgi.com>; Mon, 16 Jan 2012 13:45:30 -0600
Date: Mon, 16 Jan 2012 13:45:29 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 08/11] xfs: remove the i_size field in struct xfs_inode
Message-ID: <20120116194529.GB16581@sgi.com>
References: <20111218200003.557507716@bombadil.infradead.org>
	<20111218200132.134835340@bombadil.infradead.org>
	<20120116183201.GA16581@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120116183201.GA16581@sgi.com>
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

On Mon, Jan 16, 2012 at 12:32:01PM -0600, Ben Myers wrote:
> On Sun, Dec 18, 2011 at 03:00:11PM -0500, Christoph Hellwig wrote:
> > There is no fundamental need to keep an in-memory inode size copy in the XFS
> > inode.  We already have the on-disk value in the dinode, and the separate
> > in-memory copy that we need for regular files only in the XFS inode.
> > 
> > Remove the xfs_inode i_size field and change the XFS_ISIZE macro to use the
> > VFS inode i_size field for regular fields.  Switch code that was directly
				       files.

I'll fix that up.

-Ben

> > accessing the i_size field in the xfs_inode to XFS_ISIZE, or in cases where
> > we are limited to regular files direct access of the VFS inode i_size field.
> > 
> > This also allows dropping some fairly complicated code in the write path
> > which dealt with keeping the xfs_inode i_size uptodate with the VFS i_size
> > that is getting updated inside ->write_end.
> > 
> > Note that we do not bother resetting the VFS i_size when truncating a file
> > that gets freed to zero as there is point in doing so because the VFS inode
> > is no longer in use at this point.  Just relax the assert in xfs_ifree to
> > only check the on-disk size instead.
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This looks good to me too.  The only suggestion I had was that in some
> of these places where we call XFS_ISIZE or i_size_read twice in a row,
> it might be nicer to read them into a local variable and use that.
> Dave's comments were very helpful.
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

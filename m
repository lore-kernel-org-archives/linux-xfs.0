Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 862F67F47
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 03:54:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47B4E304039
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 01:54:18 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	0mYeumTUvGHzcVbx for <xfs@oss.sgi.com>;
	Thu, 16 Apr 2015 01:54:15 -0700 (PDT)
Date: Thu, 16 Apr 2015 18:54:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/8] xfs: add DAX IO path support
Message-ID: <20150416085402.GB21261@dastard>
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
	<1427194266-2885-8-git-send-email-david@fromorbit.com>
	<20150406174913.GE58965@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150406174913.GE58965@bfoster.bfoster>
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
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Mon, Apr 06, 2015 at 01:49:14PM -0400, Brian Foster wrote:
> On Tue, Mar 24, 2015 at 09:51:05PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > DAX does not do buffered IO (can't buffer direct access!) and hence
> > all read/write IO is vectored through the direct IO path.  Hence we
> > need to add the DAX IO path callouts to the direct IO
> > infrastructure.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_aops.c | 35 +++++++++++++++++++++++++++--------
> >  1 file changed, 27 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 3fc5052..97979e9 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -1559,6 +1559,30 @@ xfs_end_io_direct_write(
> >  	}
> >  }
> >  
> > +static inline ssize_t
> > +xfs_vm_do_dio(
> > +	struct inode		*inode,
> > +	int			rw,
> > +	struct kiocb		*iocb,
> > +	struct iov_iter		*iter,
> > +	loff_t			offset,
> > +	void			(*endio)(struct kiocb	*iocb,
> > +					 loff_t		offset,
> > +					 ssize_t	size,
> > +					 void		*private),
> > +	int			flags)
> > +{
> > +	struct block_device	*bdev;
> > +
> > +	if (IS_DAX(inode))
> > +		return dax_do_io(rw, iocb, inode, iter, offset,
> > +				 xfs_get_blocks_direct, endio, 0);
> > +
> 
> I assume this is supposed to be get_blocks_direct and not
> get_blocks_dax, based on the I/O codepath. The naming is starting to get
> a little confusing though. xfs_get_blocks_dax() implies to me that it's
> for any DAX I/O, but we only appear to use it internally for
> truncate/zeroing/mmap and such. Alas, I can't think of a better name atm
> and the code seems Ok to me:

xfs_get_blocks_dax is now gone as there is no difference between
the block mapping of DAX and direct IO....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7DD2B7F56
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 08:48:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 614AF30405F
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 06:48:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iEvLtgWBshbsZ8E6 for
	<xfs@oss.sgi.com>; Tue, 01 Apr 2014 06:48:15 -0700 (PDT)
Date: Tue, 1 Apr 2014 09:48:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/5] xfs: add flush flag to xfs_eofblocks
Message-ID: <20140401134810.GB21540@bfoster.bfoster>
References: <1396012563-60973-1-git-send-email-bfoster@redhat.com>
	<1396012563-60973-3-git-send-email-bfoster@redhat.com>
	<20140331214754.GE17603@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140331214754.GE17603@dastard>
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
Cc: xfs@oss.sgi.com

On Tue, Apr 01, 2014 at 08:47:54AM +1100, Dave Chinner wrote:
> On Fri, Mar 28, 2014 at 09:16:00AM -0400, Brian Foster wrote:
> > The flush flag allows the caller to issue a flush for scanned inodes. In
> > ENOSPC conditions caused by project quotas, a flush is required to free
> > up reserved metadata allocations.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_fs.h     | 4 +++-
> >  fs/xfs/xfs_icache.c | 3 +++
> >  2 files changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> > index c5fc116..fa3a58e 100644
> > --- a/fs/xfs/xfs_fs.h
> > +++ b/fs/xfs/xfs_fs.h
> > @@ -374,12 +374,14 @@ struct xfs_fs_eofblocks {
> >  #define XFS_EOF_FLAGS_GID		(1 << 2) /* filter by gid */
> >  #define XFS_EOF_FLAGS_PRID		(1 << 3) /* filter by project id */
> >  #define XFS_EOF_FLAGS_MINFILESIZE	(1 << 4) /* filter by min file size */
> > +#define XFS_EOF_FLAGS_FLUSH		(1 << 5) /* issue a flush */
> >  #define XFS_EOF_FLAGS_VALID	\
> >  	(XFS_EOF_FLAGS_SYNC |	\
> >  	 XFS_EOF_FLAGS_UID |	\
> >  	 XFS_EOF_FLAGS_GID |	\
> >  	 XFS_EOF_FLAGS_PRID |	\
> > -	 XFS_EOF_FLAGS_MINFILESIZE)
> > +	 XFS_EOF_FLAGS_MINFILESIZE | \
> > +	 XFS_EOF_FLAGS_FLUSH)
> >  
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 7ff59c9..d4e15db 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -1231,6 +1231,9 @@ xfs_inode_free_eofblocks(
> >  		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
> >  		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
> >  			return 0;
> > +
> > +		if (eofb->eof_flags & XFS_EOF_FLAGS_FLUSH)
> > +			filemap_flush(VFS_I(ip)->i_mapping);
> 
> So this does WB_SYNC_NONE writeback, which means the filesystem is
> free to ignore it when we get to .writepage. Given that we are are
> ENOSPC here, wouldn't it be better to guarantee that writeback will
> occur (i.e. use filemap_fdatawrite())?
> 

Yeah, I didn't catch that. That makes sense, thanks.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44796 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750713AbdISIUM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Sep 2017 04:20:12 -0400
Date: Tue, 19 Sep 2017 10:20:09 +0200
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 4/7] xfs: Implement fallocate query support mode
Message-ID: <20170919082009.jdxnxzeosqhutajc@rh_laptop>
References: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
 <1505749947-26360-5-git-send-email-lczerner@redhat.com>
 <20170918204838.GW6540@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170918204838.GW6540@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Sep 18, 2017 at 01:48:38PM -0700, Darrick J. Wong wrote:
> On Mon, Sep 18, 2017 at 05:52:24PM +0200, Lukas Czerner wrote:
> > Return all fallcoate modes supported by xfs file system.
> > 
> > Cc: linux-xfs@vger.kernel.org
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/xfs/xfs_file.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index ebdd0bd..85e06c6 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -746,7 +746,8 @@ xfs_file_write_iter(
> >  #define	XFS_FALLOC_FL_SUPPORTED						\
> >  		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
> >  		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |	\
> > -		 FALLOC_FL_INSERT_RANGE | FALLOC_FL_UNSHARE_RANGE)
> > +		 FALLOC_FL_INSERT_RANGE | FALLOC_FL_UNSHARE_RANGE |	\
> > +		 FALLOC_FL_QUERY_SUPPORT | FALLOC_FL_PREALLOC_RANGE)
> >  
> >  STATIC long
> >  xfs_file_fallocate(
> > @@ -768,6 +769,9 @@ xfs_file_fallocate(
> >  	if (mode & ~XFS_FALLOC_FL_SUPPORTED)
> >  		return -EOPNOTSUPP;
> >  
> > +	if (mode & FALLOC_FL_QUERY_SUPPORT)
> > +		return XFS_FALLOC_FL_SUPPORTED;
> 
> Urk, manpage update describing the goals of the query interface and how
> this is supposed to work is needed.

See linux-fsdevel for entire patch set. It's RFC, manpage update will
come later.
https://www.spinics.net/lists/linux-fsdevel/msg115740.html

> 
> Are we required to return only the mode flags that would reasonably be
> expected to work on this file, or the fs in general?  Do we return zero

Yes, as mentioned in cover letter it's supposed to return flags that
would be expected to work on this file.

> if the file is immutable (I guess the fd has to be O_RDONLY?) or if the
> fs is readonly?

It's going through the same path as any fallocate call.

> 
> And like hch said, why not {f,}pathconf?

I do not think fpathconf is suitable for this use case, see my reply to hch
and reply form Andreas.

-Lukas

> 
> --D
> 
> > +
> >  	xfs_ilock(ip, iolock);
> >  	error = xfs_break_layouts(inode, &iolock);
> >  	if (error)
> > -- 
> > 2.7.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

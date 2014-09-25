Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1AAE47FD0
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 16:03:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 092DF304039
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 14:03:36 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	JKib7tZNwBaec7bK for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 14:03:34 -0700 (PDT)
Date: Fri, 26 Sep 2014 07:03:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: consider freeze levels in xfs_fs_writable()
Message-ID: <20140925210330.GG4945@dastard>
References: <1411647632-28240-1-git-send-email-david@fromorbit.com>
	<1411647632-28240-2-git-send-email-david@fromorbit.com>
	<20140925161756.GA25798@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140925161756.GA25798@infradead.org>
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

On Thu, Sep 25, 2014 at 09:17:56AM -0700, Christoph Hellwig wrote:
> > index d36bdbc..9073895 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -607,7 +607,7 @@ xfs_mount_reset_sbqflags(
> >  	 * If the fs is readonly, let the incore superblock run
> >  	 * with quotas off but don't flush the update out to disk
> >  	 */
> > -	if (mp->m_flags & XFS_MOUNT_RDONLY)
> > +	if (!xfs_fs_writable(mp, SB_UNFROZEN))
> 
> This adds a new caller of xfs_fs_writable, which isn't mentioned in the
> changelog.

I can mention it, but it's so trivial I didn't think it was worth
it.

> > +	/*
> > +	 * We can be called during the fs freeze process, and we need to be
> > +	 * able to write the superblock in that case.
> > +	 */
> > +	if (!xfs_fs_writable(mp, SB_FREEZE_FS))
> >  		return 0;
> 
> And this already changes the checked freeze level, also not mentioned.

The changelog says "Hence allow the caller to pass in the freeze
level it is allowed to write" which is exactly what this code is
doing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

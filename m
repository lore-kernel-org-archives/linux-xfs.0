Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1E5hlCh102769 for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 23:43:47 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 713F5918626
	for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 21:46:24 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	cpGWKkfxlzA6ECmg for <xfs@oss.sgi.com>;
	Sun, 13 Feb 2011 21:46:24 -0800 (PST)
Date: Mon, 14 Feb 2011 16:46:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] libxlog: sync up with 2.6.38 kernel code
Message-ID: <20110214054622.GK2559@dastard>
References: <1294649091-27174-1-git-send-email-david@fromorbit.com>
	<1294649091-27174-3-git-send-email-david@fromorbit.com>
	<1297288144.2513.228.camel@doink> <20110214051005.GI2559@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110214051005.GI2559@dastard>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 14, 2011 at 04:10:05PM +1100, Dave Chinner wrote:
> On Wed, Feb 09, 2011 at 03:49:03PM -0600, Alex Elder wrote:
> > On Mon, 2011-01-10 at 19:44 +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Update libxlog with the current 2.6.38 kernel code and well as
> > > updating the necessary parts of libxfs and variaous header files to
> > > ensure that it compiles correctly.

....

> > > diff --git a/libxfs/xfs_mount.c b/libxfs/xfs_mount.c
> > > index 02bff42..dde9678 100644
> > > --- a/libxfs/xfs_mount.c
> > > +++ b/libxfs/xfs_mount.c
> > > @@ -270,7 +270,6 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb_t *sbp)
> > >  	mp->m_blockmask = sbp->sb_blocksize - 1;
> > >  	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
> > >  	mp->m_blockwmask = mp->m_blockwsize - 1;
> > > -	INIT_LIST_HEAD(&mp->m_del_inodes);
> > 
> > This hunk belongs in the next patch, not this one.
> > 
> 
> OK.

Actually, it has to be in this patch, because the only reason it
compiled prior to this patch was that INIT_LIST_HEAD() was defined
to a null macro. It is actually implemented in this patch, so this
does need to be removed here or the patch won't compile....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 03E0E7CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 18:57:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BA5958F8035
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 16:57:43 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	w8JBy34AzQdhjuj6 for <xfs@oss.sgi.com>;
	Thu, 05 May 2016 16:57:41 -0700 (PDT)
Date: Fri, 6 May 2016 09:57:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/7] xfs: add configuration handlers for specific errors
Message-ID: <20160505235739.GF26977@dastard>
References: <1462376600-8617-1-git-send-email-cmaiolino@redhat.com>
	<1462376600-8617-7-git-send-email-cmaiolino@redhat.com>
	<20160505141102.GF1231@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160505141102.GF1231@bfoster.bfoster>
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
Cc: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Thu, May 05, 2016 at 10:11:02AM -0400, Brian Foster wrote:
> On Wed, May 04, 2016 at 05:43:19PM +0200, Carlos Maiolino wrote:
> > now most of the infrastructure is in place, we can start adding
> > support for configuring specific errors such as ENODEV, ENOSPC, EIO,
> > etc. Add these error configurations and configure them all to have
> > appropriate behaviours. That is, all will be configured to retry forever by
> > default, except for ENODEV, which is an unrecoverable error, so it will be
> > configured to not retry on error
> > 
> > Changelog:
> > 
> > V3:
> > 	- Do not implement .fail_speed and .fail_at_unmount
> > 	- .fail_at_unmount will be implemented in a different patch
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/xfs_mount.h |  3 +++
> >  fs/xfs/xfs_sysfs.c | 20 ++++++++++++++++++++
> >  2 files changed, 23 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index 0382140..e3b3267 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -49,6 +49,9 @@ enum {
> >  };
> >  enum {
> >  	XFS_ERR_DEFAULT,
> > +	XFS_ERR_EIO,
> > +	XFS_ERR_ENOSPC,
> > +	XFS_ERR_ENODEV,
> >  	XFS_ERR_ERRNO_MAX,
> >  };
> >  
> > diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> > index c881360..1ed9033 100644
> > --- a/fs/xfs/xfs_sysfs.c
> > +++ b/fs/xfs/xfs_sysfs.c
> > @@ -481,6 +481,17 @@ static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
> >  	  .max_retries = -1,
> >  	  .retry_timeout = 0,
> >  	},
> > +	{ .name = "EIO",
> > +	  .max_retries = -1,
> > +	  .retry_timeout = 0,
> > +	},
> > +	{ .name = "ENOSPC",
> > +	  .max_retries = -1,
> > +	  .retry_timeout = 0,
> > +	},
> > +	{ .name = "ENODEV",
> > +	  .max_retries = -1,
> 
> Shouldn't this be 0?

If they are supposed to be "retry forever", they shoul dbe set to
the define I asked to be added in the last review. i.e.
XFS_ERR_RETRY_FOREVER. But if a device goes away, then we may as
well fail immediately as it will never come back as the same
device....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:46323 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727124AbeKPPoZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Nov 2018 10:44:25 -0500
Date: Fri, 16 Nov 2018 16:33:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] vfs: vfs_dedupe_file_range() doesn't return
 EOPNOTSUPP
Message-ID: <20181116053316.GC19305@dastard>
References: <20181108221909.27602-1-david@fromorbit.com>
 <20181108221909.27602-2-david@fromorbit.com>
 <20181108230349.GC15721@magnolia>
 <20181109064713.GD15721@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109064713.GD15721@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Nov 08, 2018 at 10:47:13PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 08, 2018 at 03:03:49PM -0800, Darrick J. Wong wrote:
> > On Fri, Nov 09, 2018 at 09:19:08AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > It returns EINVAL when the operation is not supported by the
> > > filesystem. Fix it to return EOPNOTSUPP to be consistent with
> > > the man page and clone_file_range().
> > > 
> > > Clean up the inconsistent error return handling while I'm there.
> > > (I know, lipstick on a pig, but every little bit helps...)
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > 
> > Looks ok, would rather just shred this ioctl and make a better one. :P
> > 
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > --D
> > 
> > > ---
> > >  fs/read_write.c | 15 +++++++--------
> > >  1 file changed, 7 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/fs/read_write.c b/fs/read_write.c
> > > index bfcb4ced5664..aa43224bcec6 100644
> > > --- a/fs/read_write.c
> > > +++ b/fs/read_write.c
> > > @@ -2094,17 +2094,18 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
> > >  	off = same->src_offset;
> > >  	len = same->src_length;
> > >  
> > > -	ret = -EISDIR;
> > > +	if (!file->f_op->remap_file_range)
> > > +		return -EOPNOTSUPP;
> 
> Minor downside: this causes regressions in generic/158 because
> directories and device files don't have a ->remap_file_range
> implementation.  I think it can be solved by moving this check after the
> !S_ISREG check below.

Done.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

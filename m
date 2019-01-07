Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44498 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfAGSCI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jan 2019 13:02:08 -0500
Date: Mon, 7 Jan 2019 10:02:00 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: correct statx's result_mask value
Message-ID: <20190107180200.GK12689@magnolia>
References: <1546854790-5233-1-git-send-email-suyj.fnst@cn.fujitsu.com>
 <20190107175229.GJ12689@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190107175229.GJ12689@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Su Yanjun <suyj.fnst@cn.fujitsu.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, suyanjun218@gmail.com

On Mon, Jan 07, 2019 at 09:52:29AM -0800, Darrick J. Wong wrote:
> On Mon, Jan 07, 2019 at 04:53:10AM -0500, Su Yanjun wrote:
> > For statx syscall, xfs return the wrong result_mask.
> > 
> > Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
> > ---
> >  fs/xfs/xfs_iops.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index f48ffd7..3811457 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -521,6 +521,9 @@ xfs_vn_getattr(
> >  			stat->btime.tv_nsec = ip->i_d.di_crtime.t_nsec;
> >  		}
> >  	}
> > +	
> > +	/* Only return mask that we care */
> > +	stat->result_mask &= request_mask;
> 
> Why not just:
> 
> 	stat->result_mask = STATX_BASIC_STATS;
> 
> at the top of the function?
> 
> I don't see the need to mask off result_mask at all, since we could some
> day elect to return more than what's in request_mask...
> 
> ...waitaminute, are you seeing garbage in the result_mask that's
> returned to userspace?  I also noticed the vfs stat functions declare
> "struct kstat stat;" without explicitly zeroing the structure fields,
> which means (I think) that we can leak stack information if the kernel
> isn't built with the stackleak plugin?

Ignore the above; vfs_getattr_nosec actually does zero the kstat buffer
before calling ->getattr.  We also set result_mask to STATX_BASIC_STATS.

Now I'm really confused: why is this necessary at all?  What incorrect
masks did you see, and under what circumstances?

--D

> --D
> 
> >  
> >  	if (ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE)
> >  		stat->attributes |= STATX_ATTR_IMMUTABLE;
> > -- 
> > 2.7.4
> > 
> > 
> > 

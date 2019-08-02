Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38374 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfHBNwi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 09:52:38 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so45070622wmj.3
        for <linux-xfs@vger.kernel.org>; Fri, 02 Aug 2019 06:52:37 -0700 (PDT)
Date: Fri, 2 Aug 2019 15:52:34 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 8/9] Use FIEMAP for FIBMAP calls
Message-ID: <20190802135233.rkwsgwfp6n5pj457@pegasus.maiolino.io>
References: <20190731141245.7230-1-cmaiolino@redhat.com>
 <20190731141245.7230-9-cmaiolino@redhat.com>
 <20190731232254.GW1561054@magnolia>
 <20190731233133.GB1561054@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731233133.GB1561054@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca, jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org

> > > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > > index b485190b7ecd..18a798e9076b 100644
> > > --- a/fs/xfs/xfs_iops.c
> > > +++ b/fs/xfs/xfs_iops.c
> > > @@ -1113,6 +1113,11 @@ xfs_vn_fiemap(
> > >  	struct fiemap_extent_info *fieinfo)
> > >  {
> > >  	int	error;
> > > +	struct	xfs_inode	*ip = XFS_I(inode);
> > 
> > Would you mind fixing the indentation to match usual xfs style?
> > 
> > > +
> > > +	if (fieinfo->fi_flags & FIEMAP_KERNEL_FIBMAP)
> > > +		if (xfs_is_reflink_inode(ip) || XFS_IS_REALTIME_INODE(ip))
> > > +			return -EINVAL;
> > 
> > The xfs part looks ok to me.
> 
> No it doesn't.  This check ought to be xfs_is_cow_inode() to match the
> code being removed in the last patch:
> 
> if ((fieinfo->fi_flags & FIEMAP_KERNEL_FIBMAP) &&
>     (xfs_is_cow_inode(ip) || XFS_IS_REALTIME_INODE(ip)))
> 	return -EINVAL;
> 

Agreed, will fix

> > --D
> > 

-- 
Carlos

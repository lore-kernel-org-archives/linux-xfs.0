Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48898 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757114AbdEKPni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2017 11:43:38 -0400
Date: Thu, 11 May 2017 08:43:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove XFS_HSIZE
Message-ID: <20170511154326.GB4519@birch.djwong.org>
References: <20170509090018.30094-1-hch@lst.de>
 <20170509154000.GO5973@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170509154000.GO5973@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, May 09, 2017 at 08:40:00AM -0700, Darrick J. Wong wrote:
> On Tue, May 09, 2017 at 11:00:18AM +0200, Christoph Hellwig wrote:
> > XFS_HSIZE is an extremly confusing way to calculate the size of handle_t.
> > Given that handle_t always only had two sizes, and one of them isn't
> > even covered by XFS_HSIZE to start with just remove the macro and use
> > a constant sizeof expression.
> > 
> > Note that XFS_HSIZE isn't used in xfsprogs, xfsdump or xfstests either.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

By the way, do you want me to try to slip this cleanup into 4.12, or
should it wait for 4.13?

--D

> 
> > ---
> >  fs/xfs/libxfs/xfs_fs.h | 4 ----
> >  fs/xfs/xfs_ioctl.c     | 3 +--
> >  2 files changed, 1 insertion(+), 6 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 095bdf049a3f..a9aa13e66046 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -446,10 +446,6 @@ typedef struct xfs_handle {
> >  } xfs_handle_t;
> >  #define ha_fsid ha_u._ha_fsid
> >  
> > -#define XFS_HSIZE(handle)	(((char *) &(handle).ha_fid.fid_pad	 \
> > -				 - (char *) &(handle))			  \
> > -				 + (handle).ha_fid.fid_len)
> > -
> >  /*
> >   * Structure passed to XFS_IOC_SWAPEXT
> >   */
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 6190697603c9..f6af76975bc8 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -120,8 +120,7 @@ xfs_find_handle(
> >  		handle.ha_fid.fid_pad = 0;
> >  		handle.ha_fid.fid_gen = inode->i_generation;
> >  		handle.ha_fid.fid_ino = ip->i_ino;
> > -
> > -		hsize = XFS_HSIZE(handle);
> > +		hsize = sizeof(xfs_handle_t);
> >  	}
> >  
> >  	error = -EFAULT;
> > -- 
> > 2.11.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

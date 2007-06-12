Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 20:09:52 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5C39iWt010364
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 20:09:47 -0700
Date: Tue, 12 Jun 2007 13:09:33 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Be smarter about handling ENOSPC during writeback
Message-ID: <20070612030933.GN86004887@sgi.com>
References: <20070604045219.GG86004887@sgi.com> <E436D9833B42EFAE6C2CE987@timothy-shimmins-power-mac-g5.local> <F80A059A828DE0E57A655471@boing.melbourne.sgi.com> <20070608073342.GW85884050@sgi.com> <1181603625.3758.53.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181603625.3758.53.camel@edge.yarra.acx>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: David Chinner <dgc@sgi.com>, Timothy Shimmin <tes@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jun 12, 2007 at 09:13:45AM +1000, Nathan Scott wrote:
> On Fri, 2007-06-08 at 17:33 +1000, David Chinner wrote:
> > On Fri, Jun 08, 2007 at 03:28:14PM +1000, Timothy Shimmin wrote:
> 
> > > Will we get questions from people about reduced space from df? :)
> > 
> > If we do, I think you just volunteered to write the FAQ entry ;)
> 
> It would be more correct of XFS to start doing the right thing by
> reporting different values for b_free and b_avail in statfs(2) -
> this code in xfs_mount.c::xfs_statvfs() ...
> 
>     statp->f_bfree = statp->f_bavail =
>                             sbp->sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);

Ok, yeah, that'd work.

Something like:

---
 fs/xfs/xfs_vfsops.c |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2007-06-08 21:46:29.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2007-06-12 13:08:49.933837815 +1000
@@ -876,6 +876,7 @@ xfs_statvfs(
 	statp->f_blocks = sbp->sb_dblocks - lsize;
 	statp->f_bfree = statp->f_bavail =
 				sbp->sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
+	statp->f_bfree += mp->m_resblks_avail;
 	fakeinos = statp->f_bfree << sbp->sb_inopblog;
 #if XFS_BIG_INUMS
 	fakeinos += mp->m_inoadd;

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

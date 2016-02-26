Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8ED717CA4
	for <xfs@oss.sgi.com>; Fri, 26 Feb 2016 13:36:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0C2BCAC002
	for <xfs@oss.sgi.com>; Fri, 26 Feb 2016 11:36:03 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id nr9CbjFOJF5az75X (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 26 Feb 2016 11:36:00 -0800 (PST)
Date: Fri, 26 Feb 2016 11:35:55 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/15] xfs: remove timestamps from incore inode
Message-ID: <20160226193555.GB27973@birch.djwong.org>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
	<1455693652-3899-10-git-send-email-david@fromorbit.com>
	<20160226180228.GB26924@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160226180228.GB26924@bfoster.bfoster>
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
Cc: xfs@oss.sgi.com

On Fri, Feb 26, 2016 at 01:02:28PM -0500, Brian Foster wrote:
> On Wed, Feb 17, 2016 at 06:20:46PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Source kernel commit 3987848c7c2be112e03c82d03821b044f1c0edec
> > 
> > The struct xfs_inode has two copies of the current timestamps in it,
> > one in the vfs inode and one in the struct xfs_icdinode. Now that we
> > no longer log the struct xfs_icdinode directly, we don't need to
> > keep the timestamps in this structure. instead we can copy them
> > straight out of the VFS inode when formatting the inode log item or
> > the on-disk inode.
> > 
> > This reduces the struct xfs_inode in size by 24 bytes.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Dave Chinner <david@fromorbit.com>
> > ---
> >  db/check.c               | 106 +++++++++++++++++++++++------------------------
> >  include/xfs_inode.h      |  16 ++++++-
> >  libxfs/libxfs_api_defs.h |   4 +-
> >  libxfs/util.c            |  17 ++++----
> >  libxfs/xfs_inode_buf.c   |  91 ++++++++++++++++++++++++++++++++++------
> >  libxfs/xfs_inode_buf.h   |   9 ++--
> >  libxfs/xfs_rtbitmap.c    |   2 +-
> >  mkfs/proto.c             |   2 +-
> >  8 files changed, 162 insertions(+), 85 deletions(-)
> > 
> ...
> > diff --git a/mkfs/proto.c b/mkfs/proto.c
> > index 21960d5..72a1576 100644
> > --- a/mkfs/proto.c
> > +++ b/mkfs/proto.c
> > @@ -653,7 +653,7 @@ rtinit(
> >  	mp->m_sb.sb_rbmino = rbmip->i_ino;
> >  	rbmip->i_d.di_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
> >  	rbmip->i_d.di_flags = XFS_DIFLAG_NEWRTBM;
> > -	*(__uint64_t *)&rbmip->i_d.di_atime = 0;
> > +	*(__uint64_t *)&VFS_I(mp->m_rbmip)->i_atime = 0;
> 
> FYI, this bit causes a NULL dereference because we've switched to using
> mp->m_rbmip instead of rbmip, and mp->m_rbmip is not initialized until
> just below. I assume this can be fixed in-tree...

I fixed it in the xfsprogs reflink tree that Dave is poking with, so
I'll send the patch to the mailing list.

--D

> 
> Brian
> 
> >  	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
> >  	libxfs_log_sb(tp);
> >  	mp->m_rbmip = rbmip;
> > -- 
> > 2.7.0
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

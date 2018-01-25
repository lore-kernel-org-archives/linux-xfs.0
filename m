Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39080 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbeAYSgj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 13:36:39 -0500
Date: Thu, 25 Jan 2018 10:36:34 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/11] xfs: always zero di_flags2 when we free the inode
Message-ID: <20180125183634.GJ9068@magnolia>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676032170.12349.11816443603352405608.stgit@magnolia>
 <20180125173120.GB44175@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180125173120.GB44175@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 25, 2018 at 12:31:21PM -0500, Brian Foster wrote:
> On Tue, Jan 23, 2018 at 06:18:41PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Always zero the di_flags2 field when we free the inode so that we never
> > write reflinked non-file inode records to disk.
> > 
> 
> By "non-file," do you mean "invalid" or "unallocated?"

In this particular function we're preventing unallocated inodes from
having the reflink flag set in order to uphold the general policy that only
files can have reflink set.

"Always zero the di_flags2 field when we free the inode so that we never
end up with an on-disk record for an unallocated inode that also has the
reflink iflag set.  This is in keeping with the general principle that
only files can have the reflink iflag set, even though we'll zero out
di_flags2 if we ever reallocate the inode."

--D

> Otherwise looks fine:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_inode.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index a208825..fc118dd 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -2465,6 +2465,7 @@ xfs_ifree(
> >  
> >  	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
> >  	ip->i_d.di_flags = 0;
> > +	ip->i_d.di_flags2 = 0;
> >  	ip->i_d.di_dmevmask = 0;
> >  	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
> >  	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1927B7F53
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 22:46:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 07E618F8039
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 20:46:19 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	L8v1lkJQljYzYdWS for <xfs@oss.sgi.com>;
	Tue, 23 Jul 2013 20:46:18 -0700 (PDT)
Date: Wed, 24 Jul 2013 13:46:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 6/7] xfs: check that eofblocks ioctl caller can write
	matched inodes
Message-ID: <20130724034615.GO19986@dastard>
References: <20130717114746.4e133042@oracle.com>
	<20130719060221.GX11674@dastard>
	<20130722120007.2a82cea5@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130722120007.2a82cea5@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 22, 2013 at 12:00:07PM -0400, Dwight Engen wrote:
> On Fri, 19 Jul 2013 16:02:21 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> [...]
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index d873ab9e..728283a 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > > @@ -1247,6 +1247,10 @@ xfs_inode_free_eofblocks(
> > >  		if (!xfs_inode_match_id(ip, eofb))
> > >  			return 0;
> > >  
> > > +		if (eofb->eof_flags & XFS_EOF_FLAGS_PERM_CHECK &&
> > > +		    inode_permission(VFS_I(ip), MAY_WRITE))
> > > +			return 0;
> > 
> > This assumes we are walking fully instantiated VFS inodes. That's
> > not necessarily true - we may be walking inodes that have already
> > been dropped from the VFS and are waiting for background reclaim to
> 
> Hi Dave, in looking at this a bit I don't see how they can be dropped
> from the VFS since they are igrab()ed in the flow:
> 
> xfs_icache_free_eofblocks
>   xfs_inode_ag_iterator_tag
>     xfs_inode_ag_walk
>       xfs_inode_ag_walk_grab
>         igrab

Ah, right, I forgot that we have two different methods of walking
that tree, and the one that xfs_icache_free_eofblocks() avoids
inodes in reclaim.

> and I don't see a way for xfs_inode_free_eofblocks() to be called other
> than the ag_walk flow.
> 
> If there is a way to get into xfs_inode_free_eofblocks where we can't
> use VFS_I(ip) then it will be a problem for the new code in
> xfs_inode_match_id() as well.

We can always use VFS_I(ip) because the struct inode is embedded in
the struct xfs_inode, so that's never an issue.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

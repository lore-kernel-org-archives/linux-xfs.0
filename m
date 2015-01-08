Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0FB0F7F47
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 17:41:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D5B9C8F8035
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 15:41:49 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	8noDTfgdRHGGaHpp for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2015 15:41:48 -0800 (PST)
Date: Fri, 9 Jan 2015 10:23:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: inodes are new until the dentry cache is set up
Message-ID: <20150108232328.GM25000@dastard>
References: <1420667576-7592-1-git-send-email-david@fromorbit.com>
	<20150108153205.GE33789@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150108153205.GE33789@bfoster.bfoster>
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

On Thu, Jan 08, 2015 at 10:32:05AM -0500, Brian Foster wrote:
> On Thu, Jan 08, 2015 at 08:52:56AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Al Viro noticed a generic set of issues to do with filehandle lookup
> > racing with dentry cache setup. They involve a filehandle lookup
> > occurring while an inode is being created and the filehandle lookup
> > racing with the dentry creation for the real file. This can lead to
> > multiple dentries for the one path being instantiated. There are a
> > host of other issues around this same set of paths.
> > 
> > The underlying cause is that file handle lookup only waits on inode
> > cache instantiation rather than full dentry cache instantiation. XFS
> > is mostly immune to the problems discovered due to it's own internal
> > inode cache, but there are a couple of corner cases where races can
> > happen.
> > 
> > We currently clear the XFS_INEW flag when the inode is fully set up
> > after insertion into the cache. Newly allocated inodes are inserted
> > locked and so aren't usable until the allocation transaction
> > commits. This, however, occurs before the dentry and security
> > information is fully initialised and hence the inode is unlocked and
> > available for lookups to find too early.
> > 
> > To solve the problem, only clear the XFS_INEW flag for newly created
> > inodes once the dentry is fully instantiated. This means lookups
> > will retry until the XFS_INEW flag is removed from the inode and
> > hence avoids the race conditions in questions.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
....
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index ce80eeb..8be5bb5 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -186,6 +186,8 @@ xfs_generic_create(
> >  	else
> >  		d_instantiate(dentry, inode);
> >  
> > +	xfs_finish_inode_setup(ip);
> > +
> >   out_free_acl:
> >  	if (default_acl)
> >  		posix_acl_release(default_acl);
> > @@ -194,6 +196,7 @@ xfs_generic_create(
> >  	return error;
> >  
> >   out_cleanup_inode:
> > +	xfs_finish_inode_setup(ip);
> >  	if (!tmpfile)
> >  		xfs_cleanup_inode(dir, inode, dentry);
> >  	iput(inode);
> > @@ -366,9 +369,11 @@ xfs_vn_symlink(
> >  		goto out_cleanup_inode;
> >  
> >  	d_instantiate(dentry, inode);
> > +	xfs_finish_inode_setup(cip);
> >  	return 0;
> >  
> >   out_cleanup_inode:
> > +	xfs_finish_inode_setup(cip);
> >  	xfs_cleanup_inode(dir, inode, dentry);
> >  	iput(inode);
> >   out:
> 
> Ok, but what about post-inode-allocation failure conditions down in
> xfs_create()? I don't know if there's any real harm in releasing an
> I_NEW inode, but iput_final() does throw a warning. Same general
> question applies to xfs_create_tmpfile(), etc..

Ah, good point, I missed those.

Where/how are you getting warnings thrown? I'm not seeing anything
from xfstests runs?

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
